From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset 6.20 compile failure on <3.8
Date: Sun, 27 Oct 2013 19:02:33 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1310271901530.6494@blackhole.kfki.hu>
References: <alpine.LSU.2.11.1310220048430.30326@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:46090 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab3J0SCf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:02:35 -0400
In-Reply-To: <alpine.LSU.2.11.1310220048430.30326@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Tue, 22 Oct 2013, Jan Engelhardt wrote:
 
> The openSUSE build system reports for their kernel 3.7 a FTBFS
> for ipset 6.20 (path abridged with a '~'):
> 
> [   94s]   CC [M]  ~/kernel/net/sched/em_ipset.o
> [   94s]   CC [M]  ~/kernel/net/netfilter/xt_set.o
> [   97s]   CC [M]  ~/kernel/net/netfilter/ipset/ip_set_core.o
> [   97s]   CC [M]  ~/kernel/net/netfilter/ipset/ip_set_getport.o
> [   97s] ~/kernel/net/netfilter/ipset/ip_set_core.c: In function 'ip_set_sockfn_get':
> [   97s] ~/kernel/net/netfilter/ipset/ip_set_core.c:1867:21: error: 'struct net' has no member named 'user_ns'
> 
> The lines 1867+ are:
>         if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
>                 return -EPERM;
> 
> But net->user_ns is only available starting from 3.8.

I have added the compatibility checking, thanks for reporting it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
