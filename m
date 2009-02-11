From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: Netfilter API and libiptc
Date: Wed, 11 Feb 2009 14:39:14 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net>
 <20090209183941.GA1050@zenon.in.qult.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Ignacy Gawedzki <i@lri.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:34871 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZBKNjS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:39:18 -0500
In-Reply-To: <20090209183941.GA1050@zenon.in.qult.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On Mon, 9 Feb 2009, Ignacy Gawedzki wrote:
> On Mon, Feb 09, 2009 at 06:10:03PM +0100, thus spake Patrick McHardy:
>> Ignacy Gawedzki wrote:
>>> Hi everybody,
>>>
>>> I'm currently working on a project that relies on manipulation of iptables in
>>> order to perform fine data packet accounting.  This manipulation is performed
>>> dynamically, so the code initially used libiptc.
>>>
>>> Since iptables 1.4.0, libiptc is not distributed anymore, so I resolved to
>>> incorporate the code into our own source distribution, just as people from
>>> collectd seemingly did.
>>> <cut>

> My question was not about how to prevent the machine from crashing, but rather
> how are we supposed to manipulate iptables, now that libiptc is not available.
> <cut>

I would propose that we add libiptc again.

Possibly as a shared library, like we have libxtables.so?

Controlling API/ABI changes is going to be a lot harder when people starts 
to incorporate the libiptc code into their own source distributions. (I'm 
also guildy with the Perl IPTables::libiptc package...)

Patrick, what do you say?

And Jan, you seems to be the one that removed libiptc... pro vs. cons?


Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
