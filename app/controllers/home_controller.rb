class HomeController < ApplicationController
  before_action :authenticate_client!

  def index
    @client=params[:client_id]
  end


 def data
  
   events = current_client.events.all

   render :json => events.map {|event| {

              :id => event.id,
              :start_date => event.start_date.to_formatted_s(:db),
              :end_date => event.end_date.to_formatted_s(:db),
              :text => event.text,
              :rec_type => event.rec_type,
              :event_length => event.event_length,
              :event_pid => event.event_pid,
               :event_location => event.event_location
             
          }}
 end

 def db_action
  
   mode = params['!nativeeditor_status']
   id = params['id']
   start_date = params['start_date']
   end_date = params['end_date']
   text = params['text']
   rec_type = params['rec_type']
   event_length = params['event_length']
   event_pid = params['event_pid']
   tid = id
   event_location = params[:event_location]

   case mode
     when 'inserted'
       event = Event.create :start_date => start_date, :end_date => end_date, :text => text,
                            :rec_type => rec_type, :event_length => event_length, :event_pid => event_pid, :event_location => event_location
       tid = event.id
       event.client_id=current_client.id
       event.save
       if rec_type == 'none'
         mode = 'deleted'
       end

     when 'deleted'
       if rec_type != ''
         Event.where(event_pid: id).destroy_all
       end

       if event_pid != 0 and event_pid != ''
         event = Event.find(id)
         event.rec_type = 'none'
         event.save
       else
         Event.find(id).destroy
       end

     when 'updated'
       if rec_type != ''
         Event.where(event_pid: id).destroy_all
       end
     
       event = Event.find(id)
       event.start_date = start_date
       event.end_date = end_date
       event.text = text
       event.rec_type = rec_type
       event.event_length = event_length
       event.event_pid = event_pid
       event.event_location =event_location
       event.save
   end

   render :json => {
              :type => mode,
              :sid => id,
              :tid => tid,
          }
 end
end
