From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/7] netfilter: ctnetlink: cleanup message building and
 size	calculation
Date: Tue, 02 Jun 2009 15:11:34 +0200
Message-ID: <4A252506.9050604@trash.net>
References: <20090602114933.7677.25219.stgit@Decadence> <20090602115235.7677.91307.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39218 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZFBNLh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:11:37 -0400
In-Reply-To: <20090602115235.7677.91307.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch is a cleanup. It removes unneeded verbose information
> about the size calculation and it also replaces the old macros
> to build Netlink messages with the new nlmsg_*() helper functions.

This one is really hard to review because of the mixed renames
and code movals. Please split this into two patches.

> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 6c3f964..9aafe70 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -144,6 +144,12 @@ static inline u_int8_t nf_ct_protonum(const struct nf_conn *ct)
>  	return ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
>  }
>  
> +static inline const struct nf_conntrack_tuple *
> +nf_ct_tuple(const struct nf_conn *ct, enum ip_conntrack_dir dir)
> +{
> +	return &ct->tuplehash[dir].tuple;
> +}

This is a useful helper for other situations as well, so I think
it shouldn't be const.

> +static inline size_t
> +ctnetlink_nlmsg_size(const struct nf_conn *ct)
> +{
> +	...
> -	return alloc_skb(len, gfp);
> +	       + ctnetlink_proto_size(ct);
> +	       ;

^^ stray semicolon
