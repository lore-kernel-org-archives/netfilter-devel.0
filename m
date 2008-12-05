From: Patrick McHardy <kaber@trash.net>
Subject: Re: More nf_conntrack_sip questions
Date: Fri, 05 Dec 2008 19:08:09 +0100
Message-ID: <49396E09.9070607@trash.net>
References: <4935B885.8030107@redfish-solutions.com> <493954ED.9070002@trash.net> <49396C4D.7020400@redfish-solutions.com> <49396DDD.9080308@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61447 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbYLESIM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:08:12 -0500
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
>>>> with sending the call directly to the phone).  (In this topology, my 
>>>> Asterisk box is also my firewall/NATting router...)
>>>>
>>>> If I enable the voice menus in the inbound dialplan, however, it can 
>>>> hear the voice menus, but not the called-party when they pick up 
>>>> their phone (extension).
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

Actually I think it was directrtpsetup. Still worth trying though.

> What about the module options?
