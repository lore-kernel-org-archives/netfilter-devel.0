From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: Backports for the nla_put_net64() API changes
Date: Tue, 28 Jun 2016 10:23:32 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1606281022440.18118@blackhole.kfki.hu>
References: <20160623102211.GA31272@hydrogen>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:54423 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbcF1IVz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jun 2016 04:21:55 -0400
In-Reply-To: <20160623102211.GA31272@hydrogen>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 23 Jun 2016, Neutron Soutmun wrote:

> * Backports the patch "libnl: nla_put_net64():align on a 64-bit area" [1]
>   by Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> * Since the nla_put_net64() API has been changed, therefore, the
>   ip_set_compat.h.in should provides the macro IPSET_NLA_PUT_NET64 that
>   point to the nla_put_net64() with appropriate number of arguments.
> 
>   The build script should distinguish the API changes by detect for
>   the existence of nla_put_64bit() function in include/net/netlink.h.
>   This function was added in the same patches set and called by
>   the nla_put_be64() that called by nla_put_net64() respectively.
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit?id=e9bbe898cbe89b17ad3993c136aa13d0431cd537
> 
> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
> ---
>  configure.ac                                            | 10 ++++++++++
>  kernel/include/linux/netfilter/ipset/ip_set_compat.h.in |  7 +++++++
>  kernel/include/linux/netfilter/ipset/ip_set_counter.h   | 10 ++++++----
>  kernel/include/linux/netfilter/ipset/ip_set_skbinfo.h   |  7 ++++---
>  kernel/include/uapi/linux/netfilter/ipset/ip_set.h      |  1 +
>  5 files changed, 28 insertions(+), 7 deletions(-)

Patch is applied, thank you. I couldn't find a simpler backport solution 
either.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
