From: Patrick McHardy <kaber@trash.net>
Subject: Re: Targets with "mangle" table limiting (Was: Re: Troubles with
 MARK target in 2.6.28)
Date: Thu, 15 Jan 2009 14:47:06 +0100
Message-ID: <496F3E5A.9050607@trash.net>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden>	 <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net>	 <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr>	 <496AEEB0.3080905@trash.net>	 <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>	 <alpine.LSU.2.00.0901150855420.23894@fbirervta.pbzchgretzou.qr> <38bcb3ec0901150408h39390a74s6fcc9f722094715d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42440 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbZAONrJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:47:09 -0500
In-Reply-To: <38bcb3ec0901150408h39390a74s6fcc9f722094715d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

James King wrote:
> On Thu, Jan 15, 2009 at 12:06 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> Namely that MARK.2 is available for all tables. It looks like an error,
>> given that the previous ones were all limited to the mangle table.
>> But, I would have to ask - what do we gain from limiting it to mangle?
>> All other *MARK targets are available for all tables too, so what was
>> the original reason for the table limit?
>>
>> I could imagine it having to do with routing (nfmark can be used as
>> a routing key, as can TOS/DSCP):
>>
>>> target TOS             1       mangle  IPv4    *       *            2
>>> target TOS             0       mangle  IPv4    *       *            1
>>> target DSCP            0       mangle  IPv4    *       *            1
>> then again, MARK has more uses than just for routing; it can, for example,
>> serve as a way to reduce the number of rules by remembering some previous
>> result.
>> What do others think?
> 
> The only place I can see in the mangle table where nfmark has any
> special consideration is in ipt_local_hook(), in case the local output
> packet needs to be rerouted, but it seems a bit heavy handed to
> restrict MARK there based on that one edge case.  It might be useful
> to have it available elsewhere, for example to be able to refine the
> mark as it passes through the different tables, especially now that
> the mark is maskable.

Agreed, it doesn't make sense to restrict it to mangle only.


