Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C02EC4338F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 11:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9833610A8
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 11:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241100AbhHELxN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 07:53:13 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58794 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240848AbhHELxN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 07:53:13 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5FE276004F;
        Thu,  5 Aug 2021 13:52:20 +0200 (CEST)
Date:   Thu, 5 Aug 2021 13:52:52 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     proelbtn <contact@proelbtn.com>
Cc:     netfilter-devel@vger.kernel.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [PATCH v4 1/2] netfilter: add new sysctl toggle for lightweight
 tunnel netfilter hooks
Message-ID: <20210805115252.GA13060@salvia>
References: <20210802113433.6099-1-contact@proelbtn.com>
 <20210802113433.6099-2-contact@proelbtn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210802113433.6099-2-contact@proelbtn.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Aug 02, 2021 at 11:34:32AM +0000, proelbtn wrote:
> This patch introduces new sysctl toggle for enabling lightweight tunnel
> netfilter hooks.
> 
> Signed-off-by: proelbtn <contact@proelbtn.com>
> ---
>  .../networking/nf_conntrack-sysctl.rst        |  7 +++
>  include/net/lwtunnel.h                        |  3 ++
>  include/net/netfilter/nf_conntrack_lwtunnel.h | 15 ++++++
>  net/core/lwtunnel.c                           |  3 ++
>  net/netfilter/Makefile                        |  3 ++
>  net/netfilter/nf_conntrack_lwtunnel.c         | 52 +++++++++++++++++++
>  net/netfilter/nf_conntrack_standalone.c       | 13 +++++
>  7 files changed, 96 insertions(+)
>  create mode 100644 include/net/netfilter/nf_conntrack_lwtunnel.h
>  create mode 100644 net/netfilter/nf_conntrack_lwtunnel.c
> 
> diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
> index d31ed6c1cb0d..5afa4603aa4b 100644
> --- a/Documentation/networking/nf_conntrack-sysctl.rst
> +++ b/Documentation/networking/nf_conntrack-sysctl.rst
> @@ -30,6 +30,13 @@ nf_conntrack_checksum - BOOLEAN
>  	in INVALID state. If this is enabled, such packets will not be
>  	considered for connection tracking.
>  
> +nf_conntrack_lwtunnel - BOOLEAN
> +	- 0 - disabled (default)
> +	- not 0 - enabled
> +
> +	If this option is enabled, the lightweight tunnel netfilter hooks are
> +	enabled. This option cannot be disabled once it is enabled.
> +

Rename this to nf_hooks_lwtunnel?

>  nf_conntrack_count - INTEGER (read-only)
>  	Number of currently allocated flow entries.
>  
> diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
> index 05cfd6ff6528..11a2e3ce50b3 100644
> --- a/include/net/lwtunnel.h
> +++ b/include/net/lwtunnel.h
> @@ -51,6 +51,9 @@ struct lwtunnel_encap_ops {
>  };
>  
>  #ifdef CONFIG_LWTUNNEL
> +
> +DECLARE_STATIC_KEY_FALSE(nf_ct_lwtunnel_enabled);
> +
>  void lwtstate_free(struct lwtunnel_state *lws);
>  
>  static inline struct lwtunnel_state *
> diff --git a/include/net/netfilter/nf_conntrack_lwtunnel.h b/include/net/netfilter/nf_conntrack_lwtunnel.h
> new file mode 100644
> index 000000000000..230206d035b7
> --- /dev/null
> +++ b/include/net/netfilter/nf_conntrack_lwtunnel.h
> @@ -0,0 +1,15 @@
> +#include <linux/sysctl.h>
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_LWTUNNEL
> +int nf_conntrack_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
> +					 void *buffer, size_t *lenp,
> +					 loff_t *ppos);
> +#else // CONFIG_LWTUNNEL
> +int nf_conntrack_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
> +					 void *buffer, size_t *lenp,
> +					 loff_t *ppos)
> +{
> +    return 0;
> +}
> +#endif
> \ No newline at end of file
> diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
> index 8ec7d13d2860..8be3274e30ec 100644
> --- a/net/core/lwtunnel.c
> +++ b/net/core/lwtunnel.c
> @@ -23,6 +23,9 @@
>  #include <net/ip6_fib.h>
>  #include <net/rtnh.h>
>  
> +DEFINE_STATIC_KEY_FALSE(nf_ct_lwtunnel_enabled);
> +EXPORT_SYMBOL_GPL(nf_ct_lwtunnel_enabled);
> +
>  #ifdef CONFIG_MODULES
>  
>  static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 049890e00a3d..07209930b5e4 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -212,3 +212,6 @@ obj-$(CONFIG_IP_SET) += ipset/
>  
>  # IPVS
>  obj-$(CONFIG_IP_VS) += ipvs/
> +
> +# lwtunnel
> +obj-$(CONFIG_LWTUNNEL) += nf_conntrack_lwtunnel.o
> diff --git a/net/netfilter/nf_conntrack_lwtunnel.c b/net/netfilter/nf_conntrack_lwtunnel.c
> new file mode 100644
> index 000000000000..cddbf8c5883a
> --- /dev/null
> +++ b/net/netfilter/nf_conntrack_lwtunnel.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/sysctl.h>
> +#include <net/lwtunnel.h>
> +#include <net/netfilter/nf_conntrack.h>
> +
> +static inline int nf_conntrack_lwtunnel_get(void)
> +{
> +	if (static_branch_unlikely(&nf_ct_lwtunnel_enabled))
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static inline int nf_conntrack_lwtunnel_set(int enable)
> +{
> +	if (static_branch_unlikely(&nf_ct_lwtunnel_enabled)) {
> +		if (!enable)
> +			return -EPERM;

EBUSY instead.
