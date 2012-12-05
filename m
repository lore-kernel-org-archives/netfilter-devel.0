From: borg@uu3.net
Subject: Re: Patch using ipset match in policy routing.
Date: Wed, 5 Dec 2012 13:33:10 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1212051326330.1837@cube>
References: <Pine.LNX.4.64.1212032247290.19414@cube>
 <alpine.DEB.2.00.1212042115450.26188@blackhole.kfki.hu>
 <Pine.LNX.4.64.1212042240550.16537@cube> <alpine.DEB.2.00.1212050926200.27565@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.uu3.net ([87.99.63.19]:34361 "EHLO borg.uu3.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab2LEMdM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:33:12 -0500
In-Reply-To: <alpine.DEB.2.00.1212050926200.27565@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> As far as I see, it's a chicken and egg problem: the kernel must lookup 
> the routing table first to select a source address and that can't be 
> changed later by policy routing.
You are correct.

> In the bugzilla thread Ambroz Bizjak suggested using SNAT. Why doens't it 
> a good solution?
SNAT is not supposed to be used that way.. better would be NETMAP.
But still I feel it is not right aproach.

Okey, lets cut it. I know that this patch is for very specific setups
that are used very rary. I rather wanted to have tech talk here about
how I've done certain things.

Lets it leave it as is. Patch is working fine (both SMP and non SMP hosts).
If someone will be interested in it, can pick it up and mail me directly.

Regards,
Borg
