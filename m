Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0295081749;
	Sat, 13 Sep 2025 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757796769; cv=none; b=RTQwWTuaaqG3qhxoEsb6noNDLe4RYmRG3mk3IKdDECNpd0pJL3Bq4/VKfcTnCORDdonC2jvnIuH1uB8Qav/IMeFHcE2R65S+NFPguXjB5KgLfMpcThkIP/3qMLYhECYgFpJ6k4/4DYIPkaJaeEIUTCZC+P9EbZygIcnpaTXm/Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757796769; c=relaxed/simple;
	bh=qxmH0JupSBzHnBD0xTfOMOX9SUpYPtoCs6tq6IT75fE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0hUjvapaT/AaxV1Kq8RnbSTr7287b+XoRx/Eo+5spHUZ57bHx3AwUbdBd0FTq1yp2mdzmW6J5tLxjEm4IliuFk/S5oB2XhfhGJGs0NnRitEgxDm88Zc15lERT4A79NftX1mOJSKvt5uWYdg+1XC9sVD3kpVvzfoxKbEsMcmGbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2852E60309; Sat, 13 Sep 2025 22:52:44 +0200 (CEST)
Date: Sat, 13 Sep 2025 22:52:43 +0200
From: Florian Westphal <fw@strlen.de>
To: Elad Yifee <eladwf@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC] netfilter: flowtable: add CT metadata
 action for nft flowtables
Message-ID: <aMXZm_UL58OkoHlG@strlen.de>
References: <20250912163043.329233-1-eladwf@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250912163043.329233-1-eladwf@gmail.com>

Elad Yifee <eladwf@gmail.com> wrote:
> When offloading a flow via the default nft flowtable path,
> append a FLOW_ACTION_CT_METADATA action if the flow is associated with a conntrack entry.
> We do this in both IPv4 and IPv6 route action builders, after NAT mangles and before redirect.
> This mirrors net/sched/act_ct.c’s tcf_ct_flow_table_add_action_meta() so drivers that already
> parse FLOW_ACTION_CT_METADATA from TC offloads can reuse the same logic for nft flowtables.
> 
> Signed-off-by: Elad Yifee <eladwf@gmail.com>
> ---
>  net/netfilter/nf_flow_table_offload.c | 38 +++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index e06bc36f49fe..bccae4052319 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -12,6 +12,7 @@
>  #include <net/netfilter/nf_conntrack_acct.h>
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_conntrack_tuple.h>
> +#include <net/netfilter/nf_conntrack_labels.h>
>  
>  static struct workqueue_struct *nf_flow_offload_add_wq;
>  static struct workqueue_struct *nf_flow_offload_del_wq;
> @@ -679,6 +680,41 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
>  	return 0;
>  }
>  
> +static void flow_offload_add_ct_metadata(const struct flow_offload *flow,
> +					 enum flow_offload_tuple_dir dir,
> +					 struct nf_flow_rule *flow_rule)
> +{
> +	struct nf_conn *ct = flow->ct;
> +	struct flow_action_entry *entry;
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS)
> +	u32 *dst_labels;
> +	struct nf_conn_labels *labels;
> +#endif
> +
> +	if (!ct)
> +		return;

Under what circumstances can flow->ct be NULL?

> +	entry = flow_action_entry_next(flow_rule);
> +	entry->id = FLOW_ACTION_CT_METADATA;
> +
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
> +	entry->ct_metadata.mark = READ_ONCE(ct->mark);
> +#endif
> +
> +	entry->ct_metadata.orig_dir = (dir == FLOW_OFFLOAD_DIR_ORIGINAL);
> +
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS)
> +	dst_labels = entry->ct_metadata.labels;
> +	labels = nf_ct_labels_find(ct);
> +	if (labels)
> +		memcpy(dst_labels, labels->bits, NF_CT_LABELS_MAX_SIZE);
> +	else
> +		memset(dst_labels, 0, NF_CT_LABELS_MAX_SIZE);
> +#else
> +	memset(entry->ct_metadata.labels, 0, NF_CT_LABELS_MAX_SIZE);
> +#endif
> +}

This looks almost identical tcf_ct_flow_table_add_action_meta().

Any chance to make it a common helper function? act_ct already depends
on nf_flow_table anyway.
