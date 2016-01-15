From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/3] netfilter: bridge: add nf_afinfo to enable
 queuing to userspace
Date: Fri, 15 Jan 2016 10:49:05 +0100
Message-ID: <20160115094905.GA7462@breakpoint.cc>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1452847734-3766-2-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Stephane Bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37844 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbcAOJtI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 04:49:08 -0500
Content-Disposition: inline
In-Reply-To: <1452847734-3766-2-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephane Bryant <stephane.ml.bryant@gmail.com> wrote:
> From: stephane <stephane.ml.bryant@gmail.com>
> 
> This just adds and registers a nf_afinfo for the ethernet
> bridge, which enables queuing to userspace for the AF_BRIDGE
> family. No checksum computation is done.
> 
> Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
> ---
>  net/bridge/br_netfilter_hooks.c | 44 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index 7ddbe7e..7f8f922 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -999,6 +999,46 @@ static struct ctl_table brnf_table[] = {
>  };
>  #endif
>  
> +static void nf_br_saveroute(const struct sk_buff *skb,
> +			    struct nf_queue_entry *entry)

Please put all of these functions into a new file.
CONFIG_BRIDGE_NETFILTER will be deprecated, this is the glue part
that allows a bridge to use arp and /ip(6)tables.

