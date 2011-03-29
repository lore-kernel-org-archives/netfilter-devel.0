From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.2 released
Date: Tue, 29 Mar 2011 22:02:31 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1103292159150.8469@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1103272124170.3535@blackhole.kfki.hu> <4D91E7D7.3070000@msgid.tls.msk.ru> <alpine.DEB.2.00.1103292123001.8329@blackhole.kfki.hu> <4D923687.6030003@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:38555 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407Ab1C2UCc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:02:32 -0400
In-Reply-To: <4D923687.6030003@msgid.tls.msk.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 29 Mar 2011, Michael Tokarev wrote:

> 29.03.2011 23:23, Jozsef Kadlecsik wrote:
> > On Tue, 29 Mar 2011, Michael Tokarev wrote:
> > 
> >> ipset-6.2/kernel/net/netfilter/ipset/Kconfig file
> >> appears to be some net/netfilter/Kconfig file from
> >> linux source tree (from one directory level up),
> >> patched with NETFILTER_XT_SET.  It gets included
> >> into itself recursively.
> > 
> > Yes, you are right, I fixed it in the ipset git tree. Thanks!
> 
> Actually I'm not sure at all this file is needed.

It is not needed at all in the ipset package. However for the 
sake of completeness it is kept.
 
> With current Kbuild file, it builds everything as
> modules, the only CONFIG_FOO in use is IP_SET_MAX
> which can be specfied in the upper-level Kconfig
> (in net/netfilter/Kconfig).
> 
> Besides, what's the intention of CONFIG_IP_SET
> vs CONFIG_NETFILTER_XT_SET?

CONFIG_IP_SET selects the ipset subsystem, while CONFIG_NETFILTER_XT_SET 
selects the set/SET match and target.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
