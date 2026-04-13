Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2296D36404A;
	Mon, 13 Apr 2026 09:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776073641; cv=none; b=ubAMoRnZUng7jUIMeP29lbydPwT3mTxaV3ixF2fNZs993Q9RSQNMq+JxKelVPZa3AyUiRfyiRlfcw4F/YErc1ULNYiZo64cT8lQIknDXZISrxYu8GL7YipVy52SImsfq2bszuRCfR9ndMhQ84AMAJx/N9KwLo8/mfZpYNpuVXrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776073641; c=relaxed/simple;
	bh=4aOb6ThLDBQYCx+aG1KLR6zwtxTjCP+veRl36Kco2eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfjXlWYQ+BikFZkOfl6BeV+QBib94NliXn+mqHV6ev20hUKuTHSimBOg3tyulA0qs1vDi/Z9ItRRoQSUaMpCKGMXry5pMlqBW6nUoGkhSnKLIKn6IzS3c5q6t10kJiOxy1Fw8HYYhrGvf/fp9cRU8FCxjyhbc5QF6FOQAB5HzKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZD4W9kNu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZD4W9kNu"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 867C860177;
	Mon, 13 Apr 2026 11:47:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776073636;
	bh=pqKjOvCMf0uhkn7M/yAMIhfsnybJGiM7MI7A8LqwbwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZD4W9kNuzSdcIhn28usvUu5YdOueHnKtT3fEDGoIfaHMZwbPm9RmncOhgTg3mMwkn
	 xoxo9PKfnyhIpnrz6ue9dnhVTiqFk6VnHFqq+tnpOWcWW1mYsY9B9uQF/x8bTH/JOk
	 piNxO7BoKj/F9UcmWDXAwzCMPTtkeJvmtrDtYEc4axDdOOKKR9CiJirNzwomNwxf1H
	 xCMiXqo3o2cR87kj1Wh8vaXB/XaNoaB50zFinbjstYoxmltTz7PYEvO1yoZS62wpXO
	 RD6/DLUlwH+1SGbsi2vCxOJzl9PEQ0Zx58UEzSBSje/4M4YnwtjRStsK0zok2E9kO4
	 Cly0m/iILmytw==
Date: Mon, 13 Apr 2026 11:47:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Li hongliang <1468888505@139.com>
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org, fw@strlen.de,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	kaber@trash.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org, imv4bel@gmail.com
Subject: Re: [PATCH 6.12.y] netfilter: conntrack: add missing netlink policy
 validations
Message-ID: <ady7oZdDQ5OfQILP@chamomile>
References: <20260413073105.2990210-1-1468888505@139.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260413073105.2990210-1-1468888505@139.com>

Why only 6.12?

On Mon, Apr 13, 2026 at 03:31:05PM +0800, Li hongliang wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> [ Upstream commit f900e1d77ee0ef87bfb5ab3fe60f0b3d8ad5ba05 ]
> 
> Hyunwoo Kim reports out-of-bounds access in sctp and ctnetlink.
> 
> These attributes are used by the kernel without any validation.
> Extend the netlink policies accordingly.
> 
> Quoting the reporter:
>   nlattr_to_sctp() assigns the user-supplied CTA_PROTOINFO_SCTP_STATE
>   value directly to ct->proto.sctp.state without checking that it is
>   within the valid range. [..]
> 
>   and: ... with exp->dir = 100, the access at
>   ct->master->tuplehash[100] reads 5600 bytes past the start of a
>   320-byte nf_conn object, causing a slab-out-of-bounds read confirmed by
>   UBSAN.
> 
> Fixes: 076a0ca02644 ("netfilter: ctnetlink: add NAT support for expectations")
> Fixes: a258860e01b8 ("netfilter: ctnetlink: add full support for SCTP to ctnetlink")
> Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Li hongliang <1468888505@139.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c    | 2 +-
>  net/netfilter/nf_conntrack_proto_sctp.c | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 323e147fe282..f51cdfba68fb 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -3460,7 +3460,7 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x,
>  
>  #if IS_ENABLED(CONFIG_NF_NAT)
>  static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
> -	[CTA_EXPECT_NAT_DIR]	= { .type = NLA_U32 },
> +	[CTA_EXPECT_NAT_DIR]	= NLA_POLICY_MAX(NLA_BE32, IP_CT_DIR_REPLY),
>  	[CTA_EXPECT_NAT_TUPLE]	= { .type = NLA_NESTED },
>  };
>  #endif
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index 4cc97f971264..fabb2c1ca00a 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -587,7 +587,8 @@ static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
>  }
>  
>  static const struct nla_policy sctp_nla_policy[CTA_PROTOINFO_SCTP_MAX+1] = {
> -	[CTA_PROTOINFO_SCTP_STATE]	    = { .type = NLA_U8 },
> +	[CTA_PROTOINFO_SCTP_STATE]	    = NLA_POLICY_MAX(NLA_U8,
> +							 SCTP_CONNTRACK_HEARTBEAT_SENT),
>  	[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL]  = { .type = NLA_U32 },
>  	[CTA_PROTOINFO_SCTP_VTAG_REPLY]     = { .type = NLA_U32 },
>  };
> -- 
> 2.34.1
> 
> 
