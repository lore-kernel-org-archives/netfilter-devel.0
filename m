From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Thu, 19 Jan 2012 12:04:26 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201191154330.7547@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu> <4F130A03.7080208@googlemail.com> <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu> <4F131551.2090608@googlemail.com> <alpine.DEB.2.00.1201152100050.29766@blackhole.kfki.hu>
 <4F135552.4070804@googlemail.com> <alpine.DEB.2.00.1201160914550.30763@blackhole.kfki.hu> <4F175B94.60001@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:42158 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab2ASLE2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:04:28 -0500
In-Reply-To: <4F175B94.60001@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 18 Jan 2012, Mr Dash Four wrote:

> >  The sets have any use in the kernel side only and there the kernel 
> > matches single IP addresses and never whole networks.
> >   
> OK, I don't have intimate knowledge of the ipset code and its internal 
> workings, but it obviously accepts IP ranges since if I have a hash:net 
> set containing 10.1.0.0/16 for example and then test for that exact IP 
> range (10.1.0.0/16) then the test returns true, so ipset obviously 
> processes this IP range and returns a good result. How is that done if 
> the kernel "matches single IP addresses and never whole networks" then?

The kernel uses the sets to match the source/destination addresses of IP 
packets. And those are host, that is single IP addresses (not counting 
broadcast, multicast addresses).
 
> One other thing: *if* ipset can only accept single IP addresses instead 
> of IP ranges (I don't believe this to be the case, but anyway, if it 
> does), then you could process a single IP address in a loop containing 
> the whole range to be tested (10.1.12.0/24 in my example - i.e. looping 
> from 10.1.12.0 until 10.1.12.255 inclusive) and bail out as soon as 
> there is no match, which would then return 'false' (i.e. no match). You 
> could even speed things up a bit by implementing batch processing of IP 
> ranges internally (via a single kernel APIs instead of looping via ipset 
> and calling the kernel API each time for a single IP address check).
> 
> I know this implementation is a bit crude, but since this testing takes 
> place in userspace then this delay won't matter *that* much. How doable 
> is that?

The userspace testing is passed to the kernel for execution. There's no
shadow or backup or whatever set in userspace. The sets exist in kernel 
space and therefore all operations happen there.

Why do you need such tests at all?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
