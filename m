From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.9.1 released
Date: Thu, 15 Sep 2011 08:53:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1109150846290.5001@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1109062143300.9388@blackhole.kfki.hu> <4E713E0F.1050403@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:53596 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab1IOGx0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Sep 2011 02:53:26 -0400
In-Reply-To: <4E713E0F.1050403@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 15 Sep 2011, Mr Dash Four wrote:

> Jozsef Kadlecsik wrote:
> > I'm happy to announce ipset 6.9.1. It contains two important bugfixes: if
> > you use ipset on a hardware with tight memory usage, please upgrade.
> >   
> I am trying to compile this source (kernel modules only) against the latest
> fedora-released kernel - 2.6.40 (a.k.a. 3.0.1), but get the following errors:
> 
> net/netfilter/ipset/ip_set_core.c:244:5: warning: "LINUX_VERSION_CODE" is not
> defined
> net/netfilter/ipset/ip_set_core.c:244:26: warning: "KERNEL_VERSION" is not
> defined
> net/netfilter/ipset/ip_set_core.c:244:40: error: missing binary operator
> before token "("
> net/netfilter/ipset/ip_set_core.c:1175:5: warning: "LINUX_VERSION_CODE" is not
> defined
> net/netfilter/ipset/ip_set_core.c:1175:26: warning: "KERNEL_VERSION" is not
> defined
> net/netfilter/ipset/ip_set_core.c:1175:40: error: missing binary operator
> before token "("
> net/netfilter/ipset/ip_set_core.c: In function 'ip_set_dump':
> net/netfilter/ipset/ip_set_core.c:1178: error: too many arguments to function
> 'netlink_dump_start'
> make[3]: *** [net/netfilter/ipset/ip_set_core.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [net/netfilter/ipset] Error 2
> make[1]: *** [net/netfilter] Error 2
> make: *** [net] Error 2
> make: *** Waiting for unfinished jobs....
> 
> Am I missing something?

I suppose you are trying to compile the kernel part of the package 
directly. What should be done is as follows:

ipset-6.9.1$ ./autogen.sh
ipset-6.9.1$ ./configure --with-kbuild=/fedora/released/kernel/tree
ipset-6.9.1$ make modules
ipset-6.9.1$ make modules_install

Or your kernel tree is not prepared for building external modules:
you should run at least "make modules_prepare" in 
/fedora/released/kernel/tree.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
