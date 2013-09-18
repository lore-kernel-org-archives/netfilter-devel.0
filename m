From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] ipset: Add net namespace for ipset
Date: Wed, 18 Sep 2013 21:37:01 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309182130130.22081@blackhole.kfki.hu>
References: <52385AC3.7010607@guap.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "V. Lavrov" <lve@guap.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:52864 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab3IRThD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:37:03 -0400
In-Reply-To: <52385AC3.7010607@guap.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 17 Sep 2013, V. Lavrov wrote:

> This patch adds netns support for ipset.
> 
> Major changes were made in ip_set_core.c and ip_set.h.Added the initialization
> and
> destruction of the network namespace for ipset subsystem.
> In the prototypes of public functions ip_set added parameter "struct net*".
> 
> The remaining corrections related to the change prototypes of public functions
> ip_set_xxx.
> 
> The patch was developed for the kernel 3.10.10 (ipset not changed in .11 and
> .12).

The patch looks OK, however please rebase it using the ipset git tree. 
There was a couple of changes and your patch cannot be applied.

I'll work on to solve the backward incompatibility with the supported 
kernel version where there was no netns at all.

Best regards,
Jozsef
 
> Signed-off-by: Vitaly Lavrov <lve@guap.ru>
> --
> include/linux/netfilter/ipset/ip_set.h | 16 +--
> net/netfilter/ipset/ip_set_bitmap_ip.c | 3 +-
> net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
> net/netfilter/ipset/ip_set_bitmap_port.c | 3 +-
> net/netfilter/ipset/ip_set_core.c | 282
> ++++++++++++++++++++++++++++++----------------
> net/netfilter/ipset/ip_set_hash_gen.h | 3 +-
> net/netfilter/ipset/ip_set_list_set.c | 26 +++--
> net/netfilter/xt_set.c | 40 +++----
> net/sched/em_ipset.c | 7 +-
> 9 files changed, 238 insertions(+), 144 deletions(-)
> 
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
