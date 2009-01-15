From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_statistic.c - the statistic match
Date: Thu, 15 Jan 2009 16:56:37 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901151652120.17559@fbirervta.pbzchgretzou.qr>
References: <4967CDCB.3080306@astrocorp.com>  <alpine.LSU.2.00.0901100433100.28890@fbirervta.pbzchgretzou.qr>  <496B7F66.40900@astrocorp.com> <38bcb3ec0901150237nc2d8316l62c27beef7e59170@mail.gmail.com> <alpine.LSU.2.00.0901151143480.400@fbirervta.pbzchgretzou.qr>
 <496F5A5C.1070504@astrocorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: James King <t.james.king@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@astrocorp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34445 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbZAOP4i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:56:38 -0500
In-Reply-To: <496F5A5C.1070504@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-01-15 16:46, Bryan Duff wrote:
>>
>> And iptables -Z should take care of the counters if rules are added
>> one-by-one. Also noteworthy is that when iptables is run, the
>> ruleset (including counters) is downloaded from the kernel, and
>> later uploaded again - possible setting counters backwards.
>> (I do no think there are any workarounds to that in the kernel,
>> at least I have not seen any.)
>> But at least all of the counters are set to where they were.
>
> Would iptables -Z fix the internal counter for the statistic nth match rule?  I
> don't see that it would.  Because that's the counter I really care about
> fixing.

It depends on the module and the implementation. As for -A/-I/-Z, all
private data will usually be retained. Only when the actual rule that
references a module is deleted, the private data of the module _may_
be removed too -- this obviously does not apply for modules that have
an information storage that can be referenced multiple times, such as
xt_recent, xt_condition or xt_quota2.

So if you want to have the nth state be zeroed too, it's best to use
iptables-restore to insert them all at once into the kernel.

> A couple things - this problem occurs multiple times after adding
> the rules (as in it can correct itself by oops'ing again), the
> other amusing thing - if I use printk's I can make it happen
> faster, also if I'm doing more throughput it happens faster.

Oopses, where?
