From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC][PATCH] ipset - remove binding support
Date: Sun, 4 Jan 2009 00:12:50 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0901032348430.5993@blackhole.kfki.hu>
References: <1230654806.10747.6.camel@ws-aschultz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@warp10.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:36306 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbZACXMx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:12:53 -0500
In-Reply-To: <1230654806.10747.6.camel@ws-aschultz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Andreas,

On Tue, 30 Dec 2008, Andreas Schultz wrote:

> Whenever i'm playing with ipset (coding), i stumble over the binding
> stuff. This has been depreciated since 2.4.0 and i think it's time to
> start doing some work for the next major release.
> 
> So here is a patch that removes the binding support from ipset. I have
> tried to only remove stuff without changing to much else. Once binding
> is gone, some function calls and APIs can be simplified. But this should
> IMHO go into a separate patch.

If ipset internal structure remained the same, then according to the 
planned course your patch (i.e. removing binding) would be the proper next 
step. However the internals are being completely rewritten, mainly due to 
changing the kernel-userspace communication channel from sockopt to 
netlink. According to the planned timetable the new version will be out in 
the first quarter of this year, as development release. (The current 
branch as stable one will be maintained for a while.)

So - unless you have already got something developed on top of ipset -, 
I'd better not apply your patch. But if you have got something ready, 
just ping me. Otherwise just give me some time and there'll be a new 
branch with a new API, without binding.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
