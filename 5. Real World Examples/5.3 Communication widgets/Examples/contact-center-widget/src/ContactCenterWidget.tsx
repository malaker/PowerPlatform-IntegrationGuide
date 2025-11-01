import React, { useState, useEffect } from 'react';
import { Phone, PhoneOff, Mic, MicOff, Pause, Play, User, Clock, FileText, CheckCircle } from 'lucide-react';
import './styles.css';

export const ContactCenterWidget = () => {
  const [callActive, setCallActive] = useState(false);
  const [onHold, setOnHold] = useState(false);
  const [muted, setMuted] = useState(false);
  const [callDuration, setCallDuration] = useState('00:00');
  const [selectedTab, setSelectedTab] = useState('customer');

  useEffect(() => {
    let timer: NodeJS.Timeout;
    if (callActive) {
      let seconds = 0;
      timer = setInterval(() => {
        seconds++;
        const mins = Math.floor(seconds / 60);
        const secs = seconds % 60;
        setCallDuration(`${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`);
      }, 1000);
    }
    return () => clearInterval(timer);
  }, [callActive]);

  const startCall = () => {
    setCallActive(true);
  };

  const endCall = () => {
    setCallActive(false);
    setOnHold(false);
    setMuted(false);
    setCallDuration('00:00');
  };

  return (
    <div className="h-screen bg-gray-50 flex flex-col">
      {/* Header */}
      <div className="bg-gradient-to-r from-orange-500 to-orange-600 text-white px-4 py-3 shadow-md">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="bg-white text-orange-600 px-3 py-1 rounded font-bold text-sm">
              CCP
            </div>
            <span className="font-semibold">Contact Center</span>
          </div>
          <div className="flex items-center gap-2">
            <span className="text-xs bg-orange-700 px-2 py-1 rounded">Available</span>
          </div>
        </div>
      </div>

      {/* Call Status Bar */}
      {callActive && (
        <div className="bg-blue-600 text-white px-4 py-2 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-2 h-2 bg-green-400 rounded-full animate-pulse"></div>
            <span className="font-medium">Active Call</span>
          </div>
          <div className="flex items-center gap-2">
            <Clock className="w-4 h-4" />
            <span className="font-mono font-medium">{callDuration}</span>
          </div>
        </div>
      )}

      {/* Main Content */}
      <div className="flex-1 overflow-auto">
        <div className="max-w-4xl mx-auto p-4 space-y-4">
          
          {/* Call Controls */}
          <div className="bg-white rounded-lg shadow-md p-4">
            <h3 className="font-semibold text-gray-800 mb-3 flex items-center gap-2">
              <Phone className="w-4 h-4" />
              Call Controls
            </h3>
            
            {!callActive ? (
              <div className="text-center py-6">
                <button
                  onClick={startCall}
                  className="bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-lg font-medium flex items-center gap-2 mx-auto transition-colors"
                >
                  <Phone className="w-5 h-5" />
                  Accept Call
                </button>
                <p className="text-sm text-gray-500 mt-3">Waiting for incoming call...</p>
              </div>
            ) : (
              <div className="flex flex-wrap gap-2 justify-center">
                <button
                  onClick={() => setMuted(!muted)}
                  className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition-colors ${
                    muted ? 'bg-red-600 text-white' : 'bg-gray-200 text-gray-800 hover:bg-gray-300'
                  }`}
                >
                  {muted ? <MicOff className="w-4 h-4" /> : <Mic className="w-4 h-4" />}
                  {muted ? 'Unmute' : 'Mute'}
                </button>
                
                <button
                  onClick={() => setOnHold(!onHold)}
                  className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition-colors ${
                    onHold ? 'bg-yellow-600 text-white' : 'bg-gray-200 text-gray-800 hover:bg-gray-300'
                  }`}
                >
                  {onHold ? <Play className="w-4 h-4" /> : <Pause className="w-4 h-4" />}
                  {onHold ? 'Resume' : 'Hold'}
                </button>
                
                <button
                  onClick={endCall}
                  className="flex items-center gap-2 px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg font-medium transition-colors"
                >
                  <PhoneOff className="w-4 h-4" />
                  End Call
                </button>
              </div>
            )}
          </div>

          {/* Tabs */}
          <div className="bg-white rounded-lg shadow-md overflow-hidden">
            <div className="flex border-b">
              <button
                onClick={() => setSelectedTab('customer')}
                className={`flex-1 px-4 py-3 font-medium transition-colors ${
                  selectedTab === 'customer'
                    ? 'bg-orange-500 text-white'
                    : 'bg-gray-50 text-gray-700 hover:bg-gray-100'
                }`}
              >
                Customer Info
              </button>
              <button
                onClick={() => setSelectedTab('case')}
                className={`flex-1 px-4 py-3 font-medium transition-colors ${
                  selectedTab === 'case'
                    ? 'bg-orange-500 text-white'
                    : 'bg-gray-50 text-gray-700 hover:bg-gray-100'
                }`}
              >
                Case Details
              </button>
              <button
                onClick={() => setSelectedTab('notes')}
                className={`flex-1 px-4 py-3 font-medium transition-colors ${
                  selectedTab === 'notes'
                    ? 'bg-orange-500 text-white'
                    : 'bg-gray-50 text-gray-700 hover:bg-gray-100'
                }`}
              >
                Notes
              </button>
            </div>

            <div className="p-4">
              {selectedTab === 'customer' && (
                <div className="space-y-3">
                  <div className="flex items-start gap-3">
                    <User className="w-5 h-5 text-gray-400 mt-1" />
                    <div className="flex-1">
                      <p className="text-sm text-gray-500">Customer Name</p>
                      <p className="font-medium text-gray-800">Sarah Johnson</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-3">
                    <Phone className="w-5 h-5 text-gray-400 mt-1" />
                    <div className="flex-1">
                      <p className="text-sm text-gray-500">Phone Number</p>
                      <p className="font-medium text-gray-800">+1 (555) 123-4567</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-3">
                    <FileText className="w-5 h-5 text-gray-400 mt-1" />
                    <div className="flex-1">
                      <p className="text-sm text-gray-500">Account ID</p>
                      <p className="font-medium text-gray-800">ACC-2024-8473</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-3">
                    <CheckCircle className="w-5 h-5 text-green-500 mt-1" />
                    <div className="flex-1">
                      <p className="text-sm text-gray-500">Customer Tier</p>
                      <p className="font-medium text-gray-800">Prime Member</p>
                    </div>
                  </div>
                </div>
              )}

              {selectedTab === 'case' && (
                <div className="space-y-3">
                  <div>
                    <p className="text-sm text-gray-500 mb-1">Case Number</p>
                    <p className="font-medium text-gray-800">CASE-2024-10293</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500 mb-1">Issue Type</p>
                    <p className="font-medium text-gray-800">Order Delivery Issue</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500 mb-1">Priority</p>
                    <span className="inline-block bg-orange-100 text-orange-800 px-2 py-1 rounded text-sm font-medium">
                      High
                    </span>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500 mb-1">Status</p>
                    <span className="inline-block bg-blue-100 text-blue-800 px-2 py-1 rounded text-sm font-medium">
                      In Progress
                    </span>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500 mb-1">Order Number</p>
                    <p className="font-medium text-gray-800">112-8475839-3948572</p>
                  </div>
                </div>
              )}

              {selectedTab === 'notes' && (
                <div className="space-y-3">
                  <textarea
                    className="w-full h-32 p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 resize-none"
                    placeholder="Enter call notes here..."
                  ></textarea>
                  <button className="w-full bg-orange-500 hover:bg-orange-600 text-white py-2 rounded-lg font-medium transition-colors">
                    Save Notes
                  </button>
                </div>
              )}
            </div>
          </div>

          {/* Quick Actions */}
          <div className="bg-white rounded-lg shadow-md p-4">
            <h3 className="font-semibold text-gray-800 mb-3">Quick Actions</h3>
            <div className="grid grid-cols-2 gap-2">
              <button className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-800 rounded-lg text-sm font-medium transition-colors">
                Create Case
              </button>
              <button className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-800 rounded-lg text-sm font-medium transition-colors">
                Send Email
              </button>
              <button className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-800 rounded-lg text-sm font-medium transition-colors">
                Transfer Call
              </button>
              <button className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-800 rounded-lg text-sm font-medium transition-colors">
                Schedule Callback
              </button>
            </div>
          </div>

        </div>
      </div>

      {/* Footer */}
      <div className="bg-gray-800 text-gray-300 px-4 py-2 text-xs text-center">
        CIF v2 Compatible | Dynamics 365 Customer Service Integration
      </div>
    </div>
  );
};