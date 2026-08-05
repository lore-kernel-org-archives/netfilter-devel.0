Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57DA3E7BB4;
	Wed,  5 Aug 2026 08:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785918283; cv=none; b=UjCpcXpMqIXoJvpIPXBvQvwm+Cxr6Uw2Sa7p4GsNxETaxdf9PPLGS9UZBwycWrclN9fz+pjTkSw008805Yr4rm5Uda7+AKjFq5aMAQSrhoovJZWK/TBSk22KSy+56TNKF+PtVpbIkBsN1iFBBkLeczLrua89lcXwYykJjT1qRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785918283; c=relaxed/simple;
	bh=CruObnqRrJmN9xH+FaUBUUO8FmbeKTNyP///uGb6bcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9g9Qlz8srhdjFWmzXPwqx49p9NfSz27/EA1k9wjpy11+2W3PRb2RM5bII+WJutpctv575ciheDyQ9PdO3kcui/VkWWQp2NmzpFccgm6QNQKMLoqyFaF+oDmQSxRZAD62K3jlUMoQEBXphQravXIfnwVmO9UA1sGemMBQV44siM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BbuKFdH+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BbuKFdH+"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 76A4960191;
	Wed,  5 Aug 2026 10:24:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785918275;
	bh=8Q7gwHkeDPOt6ZXrXrZGh7P8pcldqb2u/9akUBDhfq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BbuKFdH+fBy8LtOYuFE0wX8AVC4JySyK15LmJGnKhd0qiA7UvJw4u2/XNEsvriw6D
	 Irn5Scvbmxkqttt1OOiG217vafzdKuJk9SBcoxSyZeciNwhykTE03wLnslX3V8TvCf
	 LQfNegcoop0ouXJGnXen4NYoBvSZKtUltLzJdu/8vFL71tkpJHWbD8U3yLJir1ZWAV
	 LWd3l2ZIiHhLsCI/FB5pBsNTOWHo7UjOGEn71LMfaqddXkYSrno5aYNeT6OUMqbbp5
	 f7+xcBF/TtpK4wM5Nt+I6lGzpI2sJC5ZkDBzHlV5BZTUAcfMbKPF+11+4pxQVNdHL3
	 1yr3V491UjUGg==
Date: Wed, 5 Aug 2026 10:24:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alexandre Ferrieux <alexandre.ferrieux@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	edumazet@google.com, alexandre.ferrieux@orange.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_dup_netdev: scrub duplicates to
 preserve the direct path
Message-ID: <anLzQeYulW2CQItC@chamomile>
References: <20260804201150.16364-1-alexandre.ferrieux@orange.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260804201150.16364-1-alexandre.ferrieux@orange.com>

Hi,

On Tue, Aug 04, 2026 at 10:11:50PM +0200, Alexandre Ferrieux wrote:
> The nftables 'dup' action clones the skb with its full glory of
> metadata, including references to its destination and conntrack
> information. As a consequence, a link failure on the duplicate's
> egress path ends up doing the same as it would for the direct path,
> for example invalidating the original packet's destination, which
> typically breaks all TCP connections to that address.
>
> In other words, the "dup" path has the potential to wreak havoc
> in the direct path as a consequence of secondary link failures. This
> is very bad behavior for a monitoring tool, which is the most
> obvious application of 'dup'.

Can you describe your use-case a bit and how it breaks?

> This patch fixes all similar scenarii by calling skb_scrub_pkt()
> on the clone, severing its link to precious direct-path state.

This patch is targetted at the net tree, but nf.git is preferred.

> Note: the second argument of skb_scrub_pkt(), the boolean "packet
> is crossing netns", is intentionally set to 'false', as a 'true'
> involves exaggerate scrubbing, e.g. of the timestamp, which a
> monitoring 'dup' typically wants to preserve.

Yes, the skb->mark should really remain in place for the duplication.
As for the conntrack and dst, you have to explain what it breaks on
your end.

> Signed-off-by: Alexandre Ferrieux <alexandre.ferrieux@orange.com>
> ---
>  net/netfilter/nf_dup_netdev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
> index c6bd5c29bed6..0f47a2135955 100644
> --- a/net/netfilter/nf_dup_netdev.c
> +++ b/net/netfilter/nf_dup_netdev.c
> @@ -63,8 +63,10 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
>  		return;
>  
>  	skb = skb_clone(pkt->skb, GFP_ATOMIC);
> -	if (skb)
> +	if (skb) {
> +		skb_scrub_packet(skb, false);
>  		nf_do_netdev_egress(skb, dev, nft_hook(pkt));
> +	}
>  }
>  EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
>  
> -- 
> 2.47.3
> 
> 
