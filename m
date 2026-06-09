Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945301D0DEE;
	Tue,  9 Jun 2026 20:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038487; cv=none; b=Pxd3AnTqi6lfh7Y1D0JqIk/i8dYCASMWnsU4NEZ+NZCRRlcrGqaRZXdKufdOPMuOpqYNOvZna6Mat6A1Lfj1TDOB1MHz95othfX9uxDfFAMsVQRbLna0+VMbKf5tZsGUrypAG6g6twpCJlHBKgV8DYKoOhGSN5GK3gZKrIhrDjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038487; c=relaxed/simple;
	bh=qH2NHrTSg6H9UZ14cUNGdYCptVbzBYO0JnflD8NmuEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gXw4OPKemFq/Ovc6lLNQSVqN+6/2uTy1CjBkx/o2CrSJA5Jf8zB7yBEOP/kHdi+g3NZRljEtd283eTaIh44xbGoaZPkveRmnJ7VYuGLqUMOUGNFGZKpXkg4Qq7bU5fd1+1NhA6XHMaF4rc4sgB4p4QpFXqSuCBp4sDCze00u0HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LIKvy6xi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LIKvy6xi"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C6F006019E;
	Tue,  9 Jun 2026 22:54:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781038483;
	bh=eXjeXx+LSBvztg1fZ1tnibSWXhVV8jJmiXcT6bQSujc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LIKvy6xiPAiGKD/cH0AuibzCjXGS9vzUTJMhkWjKWt4lv871PtMotU/i98N7Yt+R+
	 SDMcNEmoqKDvyXkoj01uKXLNiOudh6VlnAlQbDtGHX3f72VH+MZD/jJkXEnsibPXvn
	 Of742crtqByhqVyQN5jiWgefps1PMoHjrYbpq2ZhuHNnURvHt+ah48f+OC5FkPZgNh
	 Y/1OyqRaQWBBLAj8C8bNDutIxc0xBFvAarOh+UTGLwMHlvF9x/8828dvfx+Xae/PQz
	 9FbIbPVLtw4UHw+xTIZ7FrwqJWCVh9EBPPX4Pv70H+WyNUNIFfN38tvPjc3rXW7Wlt
	 e/tmRwo7HahOQ==
Date: Tue, 9 Jun 2026 22:54:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, davem@davemloft.net, edumazet@google.com,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_log: validate MAC header was set before
 dumping it
Message-ID: <aih9kXLYQKsWbUmP@chamomile>
References: <20260608001124.309352-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260608001124.309352-1-xmei5@asu.edu>

On Sun, Jun 07, 2026 at 05:11:24PM -0700, Xiang Mei wrote:
> The fallback path of dump_mac_header() guards the MAC header access
> only with "skb->mac_header != skb->network_header", without checking
> skb_mac_header_was_set().  When the MAC header is unset, mac_header is
> 0xffff, so the test passes and skb_mac_header(skb) returns
> skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
> dev->hard_header_len bytes out of bounds into the kernel log.
> 
> This is reachable via the netdev logger: nf_log_unknown_packet() calls
> dump_mac_header() unconditionally, and an skb sent through AF_PACKET
> with PACKET_QDISC_BYPASS reaches the egress hook with mac_header still
> unset (__dev_queue_xmit(), which would reset it, is bypassed).
> 
> Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
> uses.  Only skbs with an unset MAC header are affected; valid ones are
> dumped as before.
> 
>  BUG: KASAN: slab-out-of-bounds in dump_mac_header (net/netfilter/nf_log_syslog.c:831)
>  Read of size 1 at addr ffff88800ea49d3f by task exploit/148
>  Call Trace:
>   kasan_report (mm/kasan/report.c:595)
>   dump_mac_header (net/netfilter/nf_log_syslog.c:831)
>   nf_log_netdev_packet (net/netfilter/nf_log_syslog.c:938 net/netfilter/nf_log_syslog.c:963)
>   nf_log_packet (net/netfilter/nf_log.c:260)
>   nft_log_eval (net/netfilter/nft_log.c:60)
>   nft_do_chain (net/netfilter/nf_tables_core.c:285)
>   nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:307)
>   nf_hook_slow (net/netfilter/core.c:619)
>   nf_hook_direct_egress (net/packet/af_packet.c:257)
>   packet_xmit (net/packet/af_packet.c:280)
>   packet_sendmsg (net/packet/af_packet.c:3114)
>   __sys_sendto (net/socket.c:2265)
> 
> Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
>  net/netfilter/nf_log_syslog.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
> index 7a8952b049d1..ed5283fb6b67 100644
> --- a/net/netfilter/nf_log_syslog.c
> +++ b/net/netfilter/nf_log_syslog.c
> @@ -815,7 +815,7 @@ static void dump_mac_header(struct nf_log_buf *m,
>  
>  fallback:
>  	nf_log_buf_add(m, "MAC=");
> -	if (dev->hard_header_len &&
> +	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
>  	    skb->mac_header != skb->network_header) {

Maybe this instead?

+           skb_mac_header_was_set(skb) &&
+           skb_mac_header_len(skb) != 0) {

>  		const unsigned char *p = skb_mac_header(skb);
>  		unsigned int i;
> -- 
> 2.43.0
> 
