From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next v4 2/3] netfilter: bridge: pass L2 header and
 VLAN as netlink attributes in queues to userspace
Date: Fri, 18 Mar 2016 19:22:24 +0100
Message-ID: <20160318182224.GB21628@breakpoint.cc>
References: <1458322416-4137-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1458322416-4137-2-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Stephane Bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34219 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbcCRSW0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 14:22:26 -0400
Content-Disposition: inline
In-Reply-To: <1458322416-4137-2-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephane Bryant <stephane.ml.bryant@gmail.com> wrote:
> From: stephane <stephane.ml.bryant@gmail.com>
> 
> -this creates 2 netlink attribute NLQA_VLAN and NLQA_L2HDR
> -these are filled up for the PF_BRIDGE family on the way to userspace
> -NFQA_VLAN is a nested attribute, with the NFQA_VLAN_PROTO and the
>  NFQA_VLAN_TCI carrying the corresponding vlan_proto and vlan_tci
>  fields from the skb.
> 
> +	if ((entry->state.pf != PF_BRIDGE) || (!skb_mac_header_was_set(entskb)))
> +		return 0;

Nit: Inner () are not needed.

> +	if (skb_vlan_tag_present(entskb)) {
> +		nlalen += nla_total_size(nla_total_size(sizeof(__u16)) +
> +					 nla_total_size(sizeof(__be16)));
> +	}

Nit: {} not needed.

> +		if (nla_put_u16(skb, NFQA_VLAN_TCI, entskb->vlan_tci))
> +			goto nla_put_failure;

I would suggest to use nla_put_be16 + htons here, we also use bigendian
for things like skb->mark.

Rest looks good to me, thanks!
