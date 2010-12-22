From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipsets: examples?
Date: Wed, 22 Dec 2010 11:45:03 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012221125040.3482@blackhole.kfki.hu>
References: <201012192237.43878.reuben.m@gmail.com> <alpine.DEB.2.00.1012201622001.14191@blackhole.kfki.hu> <201012201418.14281.reuben.m@gmail.com> <alpine.DEB.2.00.1012211032420.15250@blackhole.kfki.hu>
 <AANLkTi=9HYAAhbj4eauqzYm07OJeS+jmNVY=rtgad6Fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Reuben Martin <reuben.m@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:45598 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0LVKpG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:45:06 -0500
In-Reply-To: <AANLkTi=9HYAAhbj4eauqzYm07OJeS+jmNVY=rtgad6Fd@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 21 Dec 2010, Reuben Martin wrote:

> I want to be able to do:
> 
> ... -j MY_TARGET --ipset foo
> 
> where MY_TARGET would iterate over the members of foo, and for each
> member of foo the original packet is duplicated, the duplicate's
> destination is changed to the address value of the member, checksums
> recalculated, and sent on it's way.
> 
> My intent is to be able to take RTP media stream packets, and
> transparently forward them to a dynamically changing group of
> destination addresses.in a network where multicast is not an option.
> I'm sure there might be other uses for it, but that's all I'm
> concerned about at the moment.

I see. Sorry, it's not possible to use ipset for this purpose: there are 
no iterators which'd return the members of a set (listing is not similar 
or applicable). To design such an interface is not trivial. Maybe instead 
of iterating, passing your function to ipset is more feasible: ipset would 
call your function for every member of the given set.

(I Cc-ed netfilter-devel, because that's more appropriate list for such a 
discussion.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
