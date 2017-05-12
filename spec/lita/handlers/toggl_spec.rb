require "spec_helper"
require 'pry'

describe Lita::Handlers::WateringReminder, lita_handler: true do
  it { is_expected.to route("el que riega los viernes en la tarde es camilo") }
  it { is_expected.to route("quienes riegan?") }
  it { is_expected.to route("camilo ya no quiere regar más") }
  it { is_expected.not_to route("quienes riegan hoy?") }
  it "acepta que una persona le diga directamente que va a regar" do
    carl = Lita::User.create(123, name: "carlos")
    send_message("voy a regar los lunes en la tarde", as: carl)
    expect(replies.last).to eq("Perfecto @carlos, te recordaré regar cada lunes en la tarde.")
    send_message("voy a regar los martes en la mañana", as: carl)
    expect(replies.last).to eq("Perfecto @carlos, te recordaré regar cada martes en la mañana.")
  end
  it "acepta que una persona le diga directamente que va a regar" do
    carl = Lita::User.create(123, name: "carlos")
    send_message("el que riega los miércoles en la tarde es pedro", as: carl)
    send_message("el que riega los martes en la mañana es carlos", as: carl)
    send_message("quienes riegan?", as: carl)
    expect(replies.last).to eq("Veamos:\ncarlos riega los martes en la mañana\npedro riega los miércoles en la tarde")
  end
  it "reminds to water" do
    now = Time.parse("2017-01-23 9:00:00")
    allow(Time).to receive(:now) { now }
    send_message("el que riega los lunes en la mañana es juan")
    watering_reminder = Lita::Handlers::WateringReminder.new(robot)
    watering_reminder.refresh
    expect(replies.last).to eq('@juan acuérdate que hoy día en la mañana te toca regar.')
  end

end
