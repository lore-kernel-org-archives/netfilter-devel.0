From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: high number of rule changes per second (was Re: Netfilter
 development project)
Date: Thu, 4 Sep 2008 09:40:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0809040924010.23053@tyr.diku.dk>
References: <000501c8fd68$da840390$8f8c0ab0$@com> <48A32467.80703@netfilter.org>
 <002101c90c64$f40dae50$dc290af0$@com> <48BCFD81.3070005@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Andy Loukes <andy@loukes.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:47523 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbYIDHlA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:41:00 -0400
In-Reply-To: <48BCFD81.3070005@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2 Sep 2008, Pablo Neira Ayuso wrote:

> Andy Loukes wrote:
>> I should clarify the problem we have a little more. I realised we shouldn't
>> be to be too hasty in throwing away our current system, which is currently
>> perl (not ideal but it does work and isn't a bottleneck) handling the
>> network connection which then just calls iptables to add and remove rules.

I have written a iptables system in Perl that scales to 5000 customers, 
and I can perform 77965 rule changes in 2.28 sec.

I have published my low-level iptables-to-perl library on CPAN called 
IPTables::libiptc.

  http://search.cpan.org/~hawk/IPTables-libiptc-0.11/

I have some extra modules that I have not published yet... but you can get 
them offlist if you like...


>> The problem we have is two-fold. First the application that is controlling
>> the firewall is load balanced, so often the daemon gets two concurrent
>> requests and it appears that only one iptables command can be executed at
>> once so one fails. We can fix that with locking but it would be interesting
>> to understand what is happening. Is this a kernel thing?

This is because iptables work by copying the entire ruleset to userspace 
and commiting it back... thus, there is a race-condition if two userspace 
iptables calls are performed at the same time.


>> Secondly it can take up to 0.5s to execute an iptables (1.3.8) add and this
>> is causing a bottleneck and making the first problem more significant.
>
> Use iptables-restore instead with -n. You can pipe iptables commands to
> it. And upgrade to iptables >= 1.4, there was a major rewrite to resolve
> scalability problems in iptables-restore.

Yep! -- my changes and experiences has gone into mainline ;-)

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
