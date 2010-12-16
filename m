From: Patrick McHardy <kaber@trash.net>
Subject: Re: Use connection tracking to store private data for rate shaping
 algorithms?
Date: Thu, 16 Dec 2010 13:31:12 +0100
Message-ID: <4D0A0690.4000309@trash.net>
References: <AANLkTik6sRQ=Pju6krQnUEf7qkhZ0j-cb+CdgmsoHoCf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Dirk <biecie547@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40501 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab0LPMbP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:31:15 -0500
In-Reply-To: <AANLkTik6sRQ=Pju6krQnUEf7qkhZ0j-cb+CdgmsoHoCf@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 30.11.2010 16:18, schrieb Dirk:
> Hello,
> 
> 
> We are developing some some more advanced TCP rate shaping algorithms
> ( http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=1261834&tag=1 )
> and would like to implement it as a (GPL) kernel module. The goal is
> to have a high performant module that can 'shape' traffic for 10 000's
> of hosts and users on individual base and also minimize shaping
> overhead (drop/retransmits/latency) on the network.

Sounds interesting.

> Our current solution uses a custom developed iptables target that
> already performs traffic policing for 10'000s of simultaneous users (
> http://tnc2007.terena.org/programme/presentations/showbeb6.html ).
> Since policing is not an ideal way to regulate bandwidth, we want to
> improve it :-)
> 
> 
> However, in order to function correctly, we need to keep some extra
> information for each flow (both tcp and udp) through the device:
> - few statistics (two 64bit integers)
> - shaping/rate state information (four 64bit integers)
> 
>  This information should be set/accessible from a kernel tc qdisc module.
> 
> My idea was to use the connection tracking framework to keep track of
> connection states (which is also required by the algorithms) and
> somehow extend it to also store the extra information.

That sounds reasonable. I've implemented TCP rate control about 9
years ago and did the same.

> I have found there is an extension infrastructure for nf_conntrack (
> http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg15798.html
> ), but it does not seem a module is intended to register itself
> without modifying nf_ct_ext_id in /nf_conntrack_extend.h. Since that
> would require a kernel recompile, it is not really an option.
> 
> Since we're not (yet) familiar with the connection tracking code: what
> would be the best way to accomplish this?

You can't add data to the conntrack structure (neither directly nor
through extensions) without recompiling the kernel. I'd suggest to
use ct extensions, require a recompile for now and then merge your
module upstream once it's finished.
