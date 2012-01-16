From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Mon, 16 Jan 2012 09:27:00 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201160914550.30763@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu> <4F130A03.7080208@googlemail.com> <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu> <4F131551.2090608@googlemail.com> <alpine.DEB.2.00.1201152100050.29766@blackhole.kfki.hu>
 <4F135552.4070804@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:38307 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab2API1D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:27:03 -0500
In-Reply-To: <4F135552.4070804@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 15 Jan 2012, Mr Dash Four wrote:

> > Your request means a third mode, which could lead to even more confusion,
> > because that way one could not check whether the tested address as
> > *element* is added to the set or not.
> >   
> This is not a feature request, it is a bug fix!
> 
> If ipset, for whatever reason, can't (or won't) handle ip range for match
> testing, then such requests should be discarded with the appropriate error or
> warning message on the console given by the ipset binary, or, the appropriate
> functionality should be implemented so that such test matches give the right
> result.

ipset is a tool to build up so called sets inside the Linux kernel. The 
sets have any use in the kernel side only and there the kernel matches 
single IP addresses and never whole networks.

But if you say so, let it be a bug. Won't be fixed in the near future, 
however, as it has got a very low priority.

> Not to mention that the above bug is a clear *regression* as the v4.x 
> version of the ipset binary was able, for whatever reason , to produce 
> matches - successfully - using ip ranges like the one I used as an 
> example in my initial post.

The single set type in v4.x which incidentally had the feature you are 
missing was the iptreemap type alone. The *hash set types in ipset 4.x 
behaved exactly the same way as the current ones (ignoring the fact that 
the 4.x versions had more limitations and less functionality than the 
successor hash:* types in ipset 6.x).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
