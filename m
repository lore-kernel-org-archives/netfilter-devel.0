From: Philip Prindeville <philipp_subx@redfish-solutions.com>
Subject: Re: More nf_conntrack_sip questions
Date: Fri, 05 Dec 2008 10:10:25 -0800
Message-ID: <49396E91.1060403@redfish-solutions.com>
References: <4935B885.8030107@redfish-solutions.com> <493954ED.9070002@trash.net> <49396C4D.7020400@redfish-solutions.com> <49396DDD.9080308@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:41153 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbYLESKb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:10:31 -0500
In-Reply-To: <49396DDD.9080308@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Philip Prindeville wrote:
>> Patrick McHardy wrote:
>>> Philip Prindeville wrote:
>>>> I did a little investigation into my one-way voice issue, and 
>>>> noticed that if I don't do voice-menus (i.e. where the Asterisk box 
>>>> itself generates the first outbound INVITE, then passes-through the 
>>>> 2nd INVITE once a handset picks up) then I get two-way voice (i.e. 
>>>> with sending the call directly to the phone).  (In this topology, 
>>>> my Asterisk box is also my firewall/NATting router...)
>>>>
>>>> If I enable the voice menus in the inbound dialplan, however, it 
>>>> can hear the voice menus, but not the called-party when they pick 
>>>> up their phone (extension).
>>>>
>>>> So someone (either the SIP conntrack module on the Asterisk border 
>>>> firewall or else the SBC at the ILEC) is failing to look into the 
>>>> 2nd INVITE (i.e. we're not rewriting it properly as it goes by, or 
>>>> the SBC is failing to see it).
>>>
>>>
>>> What module options are you using for the SIP helper and how is call
>>> setup in asterisk configured (directrtpsetup, canreinvite, ...)?
>>>
>>
>> For the PSTN's switch:
>>
>>  CanReinvite  : Yes
>
> I vaguely recall some problem in the implementation of this feature,
> something with missing bridging of the RTP streams that was still
> necessary under some circumstances. Might be worth to try turning
> it off.
>
> What about the module options?

pbx*CLI> sip show settings
pbx*CLI> 

Global Settings:
----------------
  SIP Port:               5060
  Bindaddress:            0.0.0.0
  Videosupport:           No
  AutoCreatePeer:         No
  Allow unknown access:   Yes
  Allow subscriptions:    Yes
  Allow overlap dialing:  No
  Promsic. redir:         No
  SIP domain support:     Yes
  Call to non-local dom.: Yes
  URI user is phone no:   No
  Our auth realm          asterisk
  Realm. auth:            No
  Always auth rejects:    No
  Call limit peers only:  No
  Direct RTP setup:       No
  User Agent:             Asterisk PBX
  MWI checking interval:  10 secs
  Reg. context:           (not set)
  Caller ID:              asterisk
  From: Domain:           
  Record SIP history:     Off
  Call Events:            Off
  IP ToS SIP:             CS3
  IP ToS RTP audio:       EF
  IP ToS RTP video:       AF41
  T38 fax pt UDPTL:       No
  RFC2833 Compensation:   No
  SIP realtime:           Disabled

Global Signalling Settings:
---------------------------
  Codecs:                 0x6 (gsm|ulaw)
  Codec Order:            ulaw:20,gsm:20
  T1 minimum:             100
  Relax DTMF:             No
  Compact SIP headers:    No
  RTP Keepalive:          0 (Disabled)
  RTP Timeout:            0 (Disabled)
  RTP Hold Timeout:       0 (Disabled)
  MWI NOTIFY mime type:   application/simple-message-summary
  DNS SRV lookup:         Yes
  Pedantic SIP support:   No
  Reg. min duration       60 secs
  Reg. max duration:      3600 secs
  Reg. default duration:  120 secs
  Outbound reg. timeout:  20 secs
  Outbound reg. attempts: 0
  Notify ringing state:   Yes
  Notify hold state:      No
  SIP Transfer mode:      open
  Max Call Bitrate:       384 kbps
  Auto-Framing:           No 

Default Settings:
-----------------
  Context:                INVALID
  Nat:                    RFC3581
  DTMF:                   rfc2833
  Qualify:                0
  Use ClientCode:         No
  Progress inband:        Never
  Language:               (Defaults to English)
  MOH Interpret:          default
  MOH Suggest:            
  Voice Mail Extension:   asterisk

----
pbx*CLI> 

