From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset nomatch not showing
Date: Mon, 26 Mar 2012 10:56:42 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1203261055350.24242@blackhole.kfki.hu>
References: <4F6C7368.3040905@googlemail.com> <alpine.DEB.2.00.1203232057030.20864@blackhole.kfki.hu> <4F6CD7DA.1080301@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:40099 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab2CZI4p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:56:45 -0400
In-Reply-To: <4F6CD7DA.1080301@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 23 Mar 2012, Mr Dash Four wrote:

> > I can't reproduce this. What is your kernel version,
> 3.2
> 
> >  ipset version
> ipset v6.11, protocol version: 6
> 
> >  and how did you install the ipset kernel modules: from the ipset package or
> > the modules came together with the kernel.
> >   
> Used the kernel modules, but applied a patch to bring them up to v6.11 level
> (can include that patch if you need it - just let me know). ipset executable
> has been built separately, using the v6.11 sources as released.

Could you send me then the patch?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
