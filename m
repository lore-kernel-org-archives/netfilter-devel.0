From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH 1/1] ipset: Add net namespace for ipset
Date: Fri, 27 Sep 2013 14:33:08 +0800
Message-ID: <524526A4.6010409@cn.fujitsu.com>
References: <5244222F.2030507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Vitaly Lavrov <vel21ripn@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22654 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab3I0GcC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:32:02 -0400
In-Reply-To: <5244222F.2030507@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/26/2013 08:01 PM, Vitaly Lavrov wrote:
> This patch adds netns support for ipset.
> 
> Major changes were made in ip_set_core.c and ip_set.h.
> Global variables are moved to per net namespace.
> Added initialization code and the destruction of the network namespace ipset subsystem.
> In the prototypes of public functions ip_set_* added parameter "struct net*".
> 
> The remaining corrections related to the change prototypes of public functions ip_set_*.
> 
> The patch for git://git.netfilter.org/ipset.git commit 6a4ec96c0b8caac5c35474e40e319704d92ca347
> 
> Signed-off-by: Vitaly Lavrov <lve@guap.ru>
> -- 

Looks good to me, thanks!

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>

>  kernel/include/linux/netfilter/ipset/ip_set.h    |  16 ++-
>  kernel/net/netfilter/ipset/ip_set_bitmap_ip.c    |   3 +-
>  kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c |   2 +-
>  kernel/net/netfilter/ipset/ip_set_bitmap_port.c  |   3 +-
>  kernel/net/netfilter/ipset/ip_set_core.c         | 286 +++++++++++++++++++++++++--------------
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h     |   3 +-
>  kernel/net/netfilter/ipset/ip_set_list_set.c     |  31 +++--
>  kernel/net/netfilter/xt_set.c                    |  40 +++---
>  kernel/net/sched/em_ipset.c                      |   7 +-
>  9 files changed, 243 insertions(+), 148 deletions(-)
> 

