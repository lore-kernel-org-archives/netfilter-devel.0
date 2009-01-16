From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Targets with "mangle" table limiting (Was: Re: Troubles with
 MARK target in 2.6.28)
Date: Fri, 16 Jan 2009 09:15:44 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901160914200.22357@fbirervta.pbzchgretzou.qr>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden>  <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net>  <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr>  <496AEEB0.3080905@trash.net>  <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
  <alpine.LSU.2.00.0901150855420.23894@fbirervta.pbzchgretzou.qr> <38bcb3ec0901150408h39390a74s6fcc9f722094715d@mail.gmail.com> <496F3E5A.9050607@trash.net> <alpine.LSU.2.00.0901151744020.20619@fbirervta.pbzchgretzou.qr> <49703860.1020805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: James King <t.james.king@gmail.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50033 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbZAPIPp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:15:45 -0500
In-Reply-To: <49703860.1020805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-01-16 08:33, Patrick McHardy wrote:
>> On Thursday 2009-01-15 14:47, Patrick McHardy wrote:
>>>>> Namely that MARK.2 is available for all tables. It looks like an error,
>>>>> given that the previous ones were all limited to the mangle table.
>>>>> But, I would have to ask - what do we gain from limiting it to mangle?
>>>>> [...]
>>>>> I could imagine it having to do with routing (nfmark can be used as
>>>>> a routing key, as can TOS/DSCP):
>>>>> [...]
>>>>> What do others think?
>>> Agreed, it doesn't make sense to restrict it to mangle only.
>>>
>> Are there perhaps other targets besides MARK whose table restriction
>> should be relaxed?
>
> I can think of CONNMARK, CLASSIFY, TCPOPTSTRIP for consistency with
> TCPMSS and possibly CONNSECMARK (after consulting with James Morris).
>
connmark is already relaxed, as is connsecmark.

And so I wonder what purpose the mangle table has, other than being 
before routing.
