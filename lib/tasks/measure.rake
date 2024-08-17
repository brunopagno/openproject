# If this file is merged something went wrong. Please delete-me
#
#

namespace :measure do
  task owning_users: [:environment] do
    if !Rails.env.development?
      puts "This task is only for development environment"
      return
    end

    ActiveRecord::Base.logger.level = 1

    total_depth = 5000
    puts "Measuring owning users with #{total_depth} depth"

    puts "creating data for benchmark"
    user = User.create!(firstname: "User", lastname: "user", mail: "asdf@asdf.com", login: "asdfanta", password: "asdf123456")
    previous = Company.create!(name: "root",
                               owner: User.create!(firstname: "The true owner of everything",
                                                   lastname: "user",
                                                   mail: "qwerty@qwerty.com",
                                                   login: "qwertyness",
                                                   password: "qwerty12345"))
    total_depth.times do |depth|
      company = Company.create!(name: "Company #{depth}", owner: user)
      Share.create!(parent: previous, child: company)
      previous = company
    end

    puts "finished creating all data, performing benchmark..."

    Benchmark.bm do |x|
      x.report("Naive: ") { Company.last.owning_users }
    end

    puts "the owner is #{Company.last.owning_users}"

    puts "cleaning up"
    Company.destroy_all
    User.where(lastname: "user").destroy_all
    Share.destroy_all
  end
end
