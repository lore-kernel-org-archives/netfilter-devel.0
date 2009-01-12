From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ebtables match inverted in 2.6.28? (Was: Re: ebtables
 match inverted in 2.6.28?)
Date: Mon, 12 Jan 2009 06:14:46 +0100
Message-ID: <496AD1C6.9080906@trash.net>
References: <84ee33570812311400m5492af64n45c645a13fe91c2c@mail.gmail.com> <1230779772.29793.31.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Matt Cross <matt.cross@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: matthltc@us.ibm.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55617 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZALFPC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:15:02 -0500
In-Reply-To: <1230779772.29793.31.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Matthew Helsley wrote:
> On Wed, 2008-12-31 at 17:00 -0500, Matt Cross wrote:
>> I think the work to move ebtables to use xtables broke ebtables.
>> Specifically, in commit 8cc784eec6676b58e7f60419c88179aaa97bf71c the
>> return value of the match functions was inverted so that they return 1
>> (true) on matches instead of EBT_MATCH (0), and vice versa (look in
>> ebt_ip.c).  The logic in ebtables.c (ebt_do_table() and
>> EBT_MATCH_ITERATE()) expect match functions to return 0 for matches.
>>
>> The patch at the end of this message fixes the problem, but seems a
>> little hacky to me.  Who's the right person to address this?

Jan, could you have a look at this please?

>> --- linux-2.6.28.orig/net/bridge/netfilter/ebtables.c   2008-12-24
>> 18:26:37.000000000 -0500
>> +++ linux-2.6.28/net/bridge/netfilter/ebtables.c        2008-12-31
>> 16:17:44.000000000 -0500
>> @@ -80,7 +80,7 @@
>>  {
>>         par->match     = m->u.match;
>>         par->matchinfo = m->data;
>> -       return m->u.match->match(skb, par);
>> +       return !m->u.match->match(skb, par);
>>  }
