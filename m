From: Patrick McHardy <kaber@trash.net>
Subject: Re: Targets with "mangle" table limiting (Was: Re: Troubles with
 MARK target in 2.6.28)
Date: Fri, 16 Jan 2009 08:33:52 +0100
Message-ID: <49703860.1020805@trash.net>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden>  <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net>  <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr>  <496AEEB0.3080905@trash.net>  <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>  <alpine.LSU.2.00.0901150855420.23894@fbirervta.pbzchgretzou.qr> <38bcb3ec0901150408h39390a74s6fcc9f722094715d@mail.gmail.com> <496F3E5A.9050607@trash.net> <alpine.LSU.2.00.0901151744020.20619@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: James King <t.james.king@gmail.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60690 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbZAPHdz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:33:55 -0500
In-Reply-To: <alpine.LSU.2.00.0901151744020.20619@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-01-15 14:47, Patrick McHardy wrote:
>>>> Namely that MARK.2 is available for all tables. It looks like an error,
>>>> given that the previous ones were all limited to the mangle table.
>>>> But, I would have to ask - what do we gain from limiting it to mangle?
>>>> [...]
>>>> I could imagine it having to do with routing (nfmark can be used as
>>>> a routing key, as can TOS/DSCP):
>>>> [...]
>>>> What do others think?
>> Agreed, it doesn't make sense to restrict it to mangle only.
>>
> Are there perhaps other targets besides MARK whose table restriction
> should be relaxed?

I can think of CONNMARK, CLASSIFY, TCPOPTSTRIP for consistency with
TCPMSS and possibly CONNSECMARK (after consulting with James Morris).


