From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 03/11] Split out the event cache
Date: Fri, 03 Nov 2006 21:47:39 +0900 (JST)
Message-ID: <200611031247.kA3Cleow025738@toshiba.co.jp>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210913.061177411@wlug.westbo.se>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: gandalf@wlug.westbo.se
In-Reply-To: <20061101210913.061177411@wlug.westbo.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Martin Josefsson <gandalf@wlug.westbo.se>
Date: Wed, 01 Nov 2006 22:08:48 +0100

> This patch splits out the event cache into its own file
> nf_conntrack_ecache.c
> 
> Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
> 


> Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_ecache.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_ecache.h	2006-11-01 18:06:26.000000000 +0100
> @@ -0,0 +1,95 @@
> +/*
> + * connection tracking event cache.
> + */
> +
> +#ifndef _NF_CONNTRACK_ECACHE_H
> +#define _NF_CONNTRACK_ECACHE_H
> +#include <net/netfilter/nf_conntrack.h>
> +
> +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> +#include <linux/notifier.h>
> +#include <linux/interrupt.h>
> +#include <net/netfilter/nf_conntrack_expect.h>

This should be out of CONFIG_NF_CONNTRACK_EVENTS, to avoid build error at


> ....
>
> +#else /* CONFIG_NF_CONNTRACK_EVENTS */
> +
> +static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
> +					    const struct sk_buff *skb) {}
> +static inline void nf_conntrack_event(enum ip_conntrack_events event,
> +				      struct nf_conn *ct) {}
> +static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct) {}
> +static inline void
> +nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
> +			  struct nf_conntrack_expect *exp) {}

here.

-- Yasuyuki Kozakai
