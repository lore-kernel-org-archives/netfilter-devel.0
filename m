Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699E254DADA;
	Tue, 13 Oct 2026 22:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929334; cv=none; b=MZ1eX2E5IqkDPvCCUTtVX0smCS34VCzVlsdMTbjADI9qPIyWlqBKJJYdrgdwLYTf7rhITrBcW801hzLRF4g8stfeFNkKKYFUcZqlfgrbky9LiFvC4IAScIn0zo8BAcLjDMXQ88QRXIvuBm9bSTuDr09JAbuyIDWx3r+X57/oQS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929334; c=relaxed/simple;
	bh=KMT7N2pBzNN5X4LMz/2lE/oP6K4KTZ2E8ZjROHI3lKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSuM7SNSDehCtPxAhLgZWWayUWx2e3yFVNo0JNiH4YZVnALArRwd8i3PbbkRHJB9cU05CVGT7Khl5S8wZMpRZIkit20inuOiTsRUToEiy8SFshA3dTeA/5f/4evSNAHtpcPgJqvz1yJb1fyALgZM8/m5ga72NWqxZVLj3E0dvzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UW2jrewu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UW2jrewu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791929322;
	bh=uKgHnDIaynoRPome4UjorUn5kpbOJOlehjx4uXDbuCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UW2jrewucs5HWKoO4OtUrCeMSyKlJD/CHsQIibiB+5kboatRwz++MwtcVU/NFBcGr
	 8XTQB7xhwesXdrtovvs2EuMsNtL0ojQBHoTMkPOeFgXQlAx6RBq1O9DfvcdOpl0ebO
	 ExySqTaq2dwZXvMVtO5d9x/6fBbgDlwVCn45HAHSy03c1Ev/8oC6T+3Y2MJHchabZ1
	 JHCTUvKcS3umvYCBEYxSywjXNCQMmhC/Ctt0M870FQu6w9KWQXY9XoL0PbF3+jWmSC
	 HimS/o1q2qT5Wxe+ZhLpbdGo2K1XXoAxc1/0nc5jp68lamUyQt6Tu7Hy9zSrcnuaPO
	 3T0zwBkKND4RQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 821D36005A;
	Wed, 14 Oct 2026 00:08:42 +0200 (CEST)
Date: Wed, 14 Oct 2026 00:08:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Palla Raghunath <raghunathpalla.0209@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	syzbot+5a8667f002726fc59f88@syzkaller.appspotmail.com
Subject: Re: [PATCH nf v2] netfilter: synproxy: check TCP header before
 verifying checksum
Message-ID: <as6r5-bAeNxesDY7@chamomile>
References: <20261009162624.16294-1-raghunathpalla.0209@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261009162624.16294-1-raghunathpalla.0209@gmail.com>

Hi,

On Fri, Oct 09, 2026 at 05:26:24PM +0100, Palla Raghunath wrote:
> synproxy_tg6() calls nf_ip6_checksum() with par->thoff before it checks
> that there is actually a TCP header at that offset.
> 
> par->thoff comes from ipv6_find_hdr(), which ip6_packet_match() calls
> with target -1. ipv6_find_hdr() only makes sure the first two bytes of
> each extension header are in the skb.

I think this qualifies as nf-next material, since this is now fixed in
the core through:

   ee319bd3a0e9 ("ipv6: do not let ipv6_find_hdr() return an offset past the packet end")


> It then adds the header's declared length to the offset and stops at
> the first non-extension header, so the offset it returns can be past
> the end of the packet. For a CHECKSUM_NONE skb, nf_ip6_checksum()
> then calls skb_checksum(skb, 0, thoff, 0), and if thoff is bigger
> than skb->len we hit the BUG_ON(len) in skb_checksum():
> 
>   kernel BUG at net/core/skbuff.c:3606!
>   RIP: 0010:skb_checksum+0x8b2/0x8c0
>   Call Trace:
>    nf_ip6_checksum+0x1bd/0x320 net/netfilter/utils.c:89
>    synproxy_tg6+0x1a4/0x6e0 net/ipv6/netfilter/ip6t_SYNPROXY.c:21
>    ip6t_do_table+0xd37/0x15b0 net/ipv6/netfilter/ip6_tables.c:366
>    ...
> 
> syzbot's reproducer sends a 60-byte packet with an AH header followed by
> two hop-by-hop headers. The second hop-by-hop header says the next header
> is TCP and has hdrlen 167, which gives a thoff of 1400.
> 
> nft_synproxy_do_eval() has the same ordering: it calls nf_checksum()
> before it fetches the TCP header.
> 
> In both places, get the TCP header with skb_header_pointer() first and
> only then verify the checksum, the same way nf_reject_ip6_tcphdr_get()
> does it. Packets that don't have a full TCP header at thoff are now
> dropped before we try to checksum them.
>
> Fixes: 4ad362282cb4 ("netfilter: add IPv6 SYNPROXY target")
> Fixes: a311a8981727 ("netfilter: nft_synproxy: use the family-aware checksum helper")
> Reported-by: syzbot+5a8667f002726fc59f88@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5a8667f002726fc59f88
> Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
> Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
> ---
> Thanks Fernando for the review, and for spotting the nft_synproxy case
> and giving me the chance to fix it in this patch as well.
> 
> v2:
> - Also fix nft_synproxy_do_eval() and add its Fixes: tag, as Fernando
>   suggested
> - Drop the comment in synproxy_tg6()
> - Add Fernando's Reviewed-by
> - Rebase on v7.3-rc7
> 
> Testing: I ran syzbot's reproducer on v7.3-rc7 with this patch applied
> and ee319bd3a0e9 ("ipv6: do not let ipv6_find_hdr() return an offset
> past the packet end") reverted, since that commit already stops the bad
> offset from reaching the target on current trees. The BUG doesn't fire
> any more. The nft_synproxy change is only build-tested so far; I haven't
> managed to get a packet through an nft synproxy rule with the bad offset
> yet.
> 
> v1: https://lore.kernel.org/all/20260926204519.43402-1-raghunathpalla.0209@gmail.com/
> 
>  net/ipv6/netfilter/ip6t_SYNPROXY.c |  6 +++---
>  net/netfilter/nft_synproxy.c       | 12 ++++++------
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
> index d51d0c3e5fe9..b3aa4fe67589 100644
> --- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
> +++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
> @@ -18,13 +18,13 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
>  	struct synproxy_options opts = {};
>  	struct tcphdr *th, _th;
>  
> -	if (nf_ip6_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
> -		return NF_DROP;
> -
>  	th = skb_header_pointer(skb, par->thoff, sizeof(_th), &_th);
>  	if (th == NULL)
>  		return NF_DROP;
>  
> +	if (nf_ip6_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
> +		return NF_DROP;
> +
>  	if (!synproxy_parse_options(skb, par->thoff, th, &opts))
>  		return NF_DROP;
>  
> diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
> index 554a96a000f4..6b290a89886d 100644
> --- a/net/netfilter/nft_synproxy.c
> +++ b/net/netfilter/nft_synproxy.c
> @@ -118,12 +118,6 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
>  		return;
>  	}
>  
> -	if (nf_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP,
> -			nft_pf(pkt))) {
> -		regs->verdict.code = NF_DROP;
> -		return;
> -	}
> -
>  	tcp = skb_header_pointer(skb, thoff,
>  				 sizeof(struct tcphdr),
>  				 &_tcph);
> @@ -132,6 +126,12 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
>  		return;
>  	}
>  
> +	if (nf_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP,
> +			nft_pf(pkt))) {
> +		regs->verdict.code = NF_DROP;
> +		return;
> +	}
> +
>  	if (!synproxy_parse_options(skb, thoff, tcp, &opts)) {
>  		regs->verdict.code = NF_DROP;
>  		return;
> -- 
> 2.34.1
> 
