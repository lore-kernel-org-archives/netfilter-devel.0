Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DB143DEBC;
	Fri,  2 Oct 2026 09:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790934950; cv=none; b=Uvujv777C4uYx+SseAtoPiaHYnT2hw8xPvBuev33Jav+LULp1Fj+0yLBRVOZVhFFNIT1Exs5/kPfmo+zebFg2/QtfbJptMwPoIFuQfPJD0zri016dPIe5TNVHaxIatIafNchUIdGKdPOfCCxRjUTEZVILj7iUPDONcorlg4ZkIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790934950; c=relaxed/simple;
	bh=8H4GTv6UGdhsnUBtRkv3ZUGEqj/K+JzbL0ghHLq0MmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hlTlO9XNK9ZdP8r8tdiOUdAXWVTLQLvpmBQHc+G8abqVVUwy+vaCs0hF98QFEmnKdO2VUq2t9Sa++E0uwYaYG7KDDWyoeli+9OMGWg/xj44ltfgquZ1NY8/posCTuZLJe9awQI4R3CCQWxwzANIFZiZIaDxNPC2KqJQwNavZUbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=K+A3k4Ud; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="K+A3k4Ud"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790934946;
	bh=NMGw5DyHEDu78hE99Z4vx1E/aL2cRKWLD5z9qn6sLp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K+A3k4UdnRSRNVFZNHEDe7cZsxCjLOVtuSI6nx4axRyf/jzSKC/CcdrbHLNR/EjJe
	 jZh4Iltf/k9hx1GPzxcGCViEfGXkTdXDRQY+w1i0XlrGy90i3StxATdF13ZpZRCRmR
	 EPSbjkBKNv5V5vtt92HCqBgQCc20RzNCNy2odiZ+7Qo9phxlqg/qCuBjnmHtPo7R01
	 5f1KDiXK+w11v7uG6BMOqb6mh5J1/rJeM5tzNXpJgMbjZhAvZDJw/fKbw5vuoeiCDL
	 j+wxOiUwTHGxQzm8CZZkttb9ctfj0BvR5mGivpAC/7coHCC+Igyx8fy7N40AlMaQRF
	 zWA0YDsFQIzbg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DA44A6069D;
	Fri,  2 Oct 2026 11:55:45 +0200 (CEST)
Date: Fri, 2 Oct 2026 11:55:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Daehyeon Ko <4ncienth@gmail.com>, phil@nwl.cc,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: conntrack: avoid recursive master
 destruction
Message-ID: <ar9_n76T92ILmLyg@chamomile>
References: <20261001180224.1018290-1-4ncienth@gmail.com>
 <ar6yM0h2zdVUU4rt@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ar6yM0h2zdVUU4rt@strlen.de>

On Thu, Oct 01, 2026 at 09:19:15PM +0200, Florian Westphal wrote:
> Daehyeon Ko <4ncienth@gmail.com> wrote:
> > Conntrack entries created through ctnetlink can reference another
> > confirmed entry as their master.  There is no limit on the resulting
> > chain depth.
> 
> I don't think this should be allowed.  I.e. (totally untested):
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2359,6 +2359,12 @@ ctnetlink_create_conntrack(struct net *net,
>                         goto err2;
>                 }
>                 master_ct = nf_ct_tuplehash_to_ctrack(master_h);
> +               if (master_ct->master) {
> +                       nf_ct_put(master_ct);
> +                       err = -EOPNOTSUPP;
> +                       goto err2;
> +               }

Agreed. Thanks.

> +
>                 __set_bit(IPS_EXPECTED_BIT, &ct->status);
>                 ct->master = master_ct;
