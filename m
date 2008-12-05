From: Philip Prindeville <philipp_subx@redfish-solutions.com>
Subject: Re: More nf_conntrack_sip questions
Date: Fri, 05 Dec 2008 10:00:45 -0800
Message-ID: <49396C4D.7020400@redfish-solutions.com>
References: <4935B885.8030107@redfish-solutions.com> <493954ED.9070002@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:44558 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753693AbYLESAx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:00:53 -0500
In-Reply-To: <493954ED.9070002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Philip Prindeville wrote:
>> I did a little investigation into my one-way voice issue, and noticed 
>> that if I don't do voice-menus (i.e. where the Asterisk box itself 
>> generates the first outbound INVITE, then passes-through the 2nd 
>> INVITE once a handset picks up) then I get two-way voice (i.e. with 
>> sending the call directly to the phone).  (In this topology, my 
>> Asterisk box is also my firewall/NATting router...)
>>
>> If I enable the voice menus in the inbound dialplan, however, it can 
>> hear the voice menus, but not the called-party when they pick up 
>> their phone (extension).
>>
>> So someone (either the SIP conntrack module on the Asterisk border 
>> firewall or else the SBC at the ILEC) is failing to look into the 2nd 
>> INVITE (i.e. we're not rewriting it properly as it goes by, or the 
>> SBC is failing to see it).
>
>
> What module options are you using for the SIP helper and how is call
> setup in asterisk configured (directrtpsetup, canreinvite, ...)?
>

For the PSTN's switch:

pbx*CLI> sip show peer sip_proxy
pbx*CLI> 

  * Name       : sip_proxy
  Secret       : xxxx
  MD5Secret    : <Not set>
  Context      : ctc-incoming
  Subscr.Cont. : <Not set>
  Language     : 
  AMA flags    : Unknown
  Transfer mode: open
  CallingPres  : Presentation Allowed, Not Screened
  Callgroup    : 
  Pickupgroup  : 
  Mailbox      : 
  VM Extension : asterisk
  LastMsgsSent : 32767/65535
  Call limit   : 0
  Dynamic      : No
  Callerid     : "" <>
  MaxCallBR    : 384 kbps
  Expire       : -1
  Insecure     : no
  Nat          : RFC3581
  ACL          : No
  T38 pt UDPTL : No
  CanReinvite  : Yes
  PromiscRedir : No
  User=Phone   : No
  Video Support: No
  Trust RPID   : No
  Send RPID    : No
  Subscriptions: Yes
  Overlap dial : No
  DTMFmode     : rfc2833
  LastMsg      : 0
  ToHost       : 66.232.80.9
  Addr->IP     : 66.232.80.9 Port 5060
  Defaddr->IP  : 0.0.0.0 Port 0
  Def. Username: 
  SIP Options  : (none)
  Codecs       : 0x6 (gsm|ulaw)
  Codec Order  : (ulaw:20,gsm:20)
  Auto-Framing:  No 
  Status       : Unmonitored
  Useragent    : 
  Reg. Contact : 

pbx*CLI> 

For the phone:

pbx*CLI> sip show peer office_1
pbx*CLI> 

  * Name       : office_1
  Secret       : <Set>
  MD5Secret    : <Not set>
  Context      : redfish-internal
  Subscr.Cont. : <Not set>
  Language     : 
  AMA flags    : Unknown
  Transfer mode: open
  CallingPres  : Presentation Allowed, Not Screened
  Callgroup    : 
  Pickupgroup  : 
  Mailbox      : 112@redfish,xxxx
  VM Extension : voicemail
  LastMsgsSent : 0/0
  Call limit   : 0
  Dynamic      : Yes
  Callerid     : "Redfish Solutions" <112>
  MaxCallBR    : 384 kbps
  Expire       : 1780
  Insecure     : no
  Nat          : Always
  ACL          : No
  T38 pt UDPTL : No
  CanReinvite  : Yes
  PromiscRedir : No
  User=Phone   : No
  Video Support: No
  Trust RPID   : No
  Send RPID    : No
  Subscriptions: Yes
  Overlap dial : No
  DTMFmode     : rfc2833
  LastMsg      : 0
  ToHost       : 
  Addr->IP     : 192.168.1.7 Port 5060
  Defaddr->IP  : 0.0.0.0 Port 5060
  Def. Username: office_1
  SIP Options  : (none)
  Codecs       : 0x6 (gsm|ulaw)
  Codec Order  : (ulaw:20,gsm:20)
  Auto-Framing:  No 
  Status       : OK (9 ms)
  Useragent    : Linksys/SPA942-5.1.15(a)
  Reg. Contact : sip:office_1@192.168.1.7:5060

pbx*CLI> 

