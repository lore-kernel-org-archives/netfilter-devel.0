Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BB92E2852;
	Thu, 28 May 2026 14:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779977551; cv=none; b=KniP41cYWc3tlEHMQu69qEzYRhhTmqQ3oR8D8X1n8qPu43B3oD1o4gGH4I0QX5jENC8TgnaCILQVPdb97DAL/ZgL31jpjYKL51W8RrplIQ1hZDMIeqvZtJVcRq+qYw7uom2oFv91gu2MlmHiKvRALuEkfh5qnu6gLfIl6rARPbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779977551; c=relaxed/simple;
	bh=cP2kA8+YYchg2ex0Elvu/5FOstG60ZZc/wj3YLEwDNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m+uHYCxtC3XDjpTWtqP5aVZ0c5z157j/+xIDyWIWStg1W7hS0oO3zm9ipP8NpenTF7hG7ssfNkKvknPmQh7Jgq37WqGhe2DQr5B6/blX6cbAtp2jW4v9og4coiixI3/zZJdqKH4D/Lj4uIJJX6cbz7PxO6xuzeL6ln9dN3spaM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 611D460551; Thu, 28 May 2026 16:12:26 +0200 (CEST)
Date: Thu, 28 May 2026 16:12:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Siho Lee <25esihoya@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nft_payload: move offset bounds check
 outside csum condition
Message-ID: <ahhNSscKHjx7bebv@strlen.de>
References: <CAOYEF6nf5-B-P7DHf_cpLaqUSoZC2FJphBqE2s4zE8MygMCb_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOYEF6nf5-B-P7DHf_cpLaqUSoZC2FJphBqE2s4zE8MygMCb_g@mail.gmail.com>

Siho Lee <25esihoya@gmail.com> wrote:
> From 574604a1b4a98ee130d7f727ad3c8a7df3f3b6f1 Mon Sep 17 00:00:00 2001
> From: Siho Lee <25esihoya@gmail.com>
> Date: Thu, 28 May 2026 22:39:03 +0900
> Subject: [PATCH v1] netfilter: nft_payload: move offset bounds check outside
>  csum condition
> 
> The bounds check for offset + priv->len was placed inside the csum
> condition block. When csum_type is NFT_PAYLOAD_CSUM_NONE and
> csum_flags is 0, the entire block including the bounds check is
> skipped.
> 
> For NFT_PAYLOAD_LL_HEADER, offset is computed as:
>     offset = skb_mac_header(skb) - skb->data - vlan_hlen
> which evaluates to -14 (or -18 with VLAN) after eth_type_trans()
> pulls the Ethernet header.
> 
> Without the bounds check, a negative offset reaches:
>     skb_ensure_writable(skb, max(offset + priv->len, 0))
>     skb_store_bits(skb, offset, src, priv->len)
> 
> max(-14 + 4, 0) == 0 makes skb_ensure_writable a no-op, and
> skb_store_bits(skb, -14, ...) writes to skb headroom (OOB write).
> 
> The signed-unsigned comparison in the bounds check correctly catches
> negative offsets: (unsigned int)(-10) is a large positive value that
> exceeds any valid skb->len.
> 
> Move the bounds check outside the csum condition so it applies
> regardless of csum_type/csum_flags.

This breaks link layer update support.

# cd git/nftables/tests/shell
# NFT=nft ./run-tests.sh testcases/packetpath/bridge_pass_up C
W: [FAILED]     1/1 testcases/packetpath/bridge_pass_up
