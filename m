Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F54D3A0EA6;
	Tue,  9 Jun 2026 22:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781044585; cv=none; b=Nf+px+qFMPciFheODevveHcd0Kos2Q5az2+qeOCJkDzIKo1fCAo1hQXiOleMKJSwdLQr3xgPPDGp0hWHGKS+egvy/O88sg9MJinRaVkWWt7bp/vwpwUgCLVZixJa1ZWGRcQ1rk8juZwrtmdJe0YQjA380hnEuasrVJe6ZmhUkao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781044585; c=relaxed/simple;
	bh=pkdchpKkJGaY5XyAAG1xgR32F4hEHoYB5ZPkcPyQO18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uvwLi+zrMKXZY3MLzE7fe9RjER+gM+Ys5J4I3ZExttWT4zCyMq4ozslrVtHFOHFhpz6NpPqfCE4a3U2yj7mDBj0kQTRwMbgiHAqtX2d2VFTy3lHUOmbkvpxTPbvdbuZ1uF2WXnYaTG+trGUCvdHhIs+lo7x/tk7v8bGBelkcXZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=l4b5lYZf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="l4b5lYZf"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id EBE26600B9;
	Wed, 10 Jun 2026 00:36:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781044582;
	bh=dW60rC68pwFrDepJxZUsuSIySbePRZgnsQ3yxRcYZIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l4b5lYZfB83HKafknr+OZ804qlLJm0ZBbQmwreJwCQuyPGwuuzFhm6KMYc6vSe9t0
	 qdSUU2sGM1e75ddXLrGoMyM4ZSf5LmE1PnFxt2Q0i/LoaXHCt3XjNsHYJ0Gyj7w/Qv
	 Jhxa/Pde3r32hEVumvTeRYIIlTnlgn3UKBDSvcKejfYfpmCnPrn0jYAdW+lSd+OH12
	 bPqAkI3p0IskNpzhCCt24CVqaEkquxy7EubdHUHSnDb36FvFptw04qgSbmwjyJ+tqb
	 xOdtNnF9dprpkM/E0AZac8hB/UYaVXZM1gAYNOX5reeuLnJ6SkwBfBpaXUPAmomfqt
	 q/Uesu/MhooIQ==
Date: Wed, 10 Jun 2026 00:36:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, davem@davemloft.net, edumazet@google.com,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_log: validate MAC header was set before
 dumping it
Message-ID: <aiiVY8ieb4o6wOgP@chamomile>
References: <20260608001124.309352-1-xmei5@asu.edu>
 <aih9kXLYQKsWbUmP@chamomile>
 <uirq3v4lihhyfwg5x46xfupncevwzo4lgncit2ftsbq3jse67k@yavzv6oocv4d>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <uirq3v4lihhyfwg5x46xfupncevwzo4lgncit2ftsbq3jse67k@yavzv6oocv4d>

On Tue, Jun 09, 2026 at 03:01:14PM -0700, Xiang Mei wrote:
> On Tue, Jun 09, 2026 at 10:54:41PM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Jun 07, 2026 at 05:11:24PM -0700, Xiang Mei wrote:
> > > The fallback path of dump_mac_header() guards the MAC header access
> > > only with "skb->mac_header != skb->network_header", without checking
> > > skb_mac_header_was_set().  When the MAC header is unset, mac_header is
> > > 0xffff, so the test passes and skb_mac_header(skb) returns
> > > skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
> > > dev->hard_header_len bytes out of bounds into the kernel log.
> > > 
> > > This is reachable via the netdev logger: nf_log_unknown_packet() calls
> > > dump_mac_header() unconditionally, and an skb sent through AF_PACKET
> > > with PACKET_QDISC_BYPASS reaches the egress hook with mac_header still
> > > unset (__dev_queue_xmit(), which would reset it, is bypassed).
> > > 
> > > Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
> > > uses.  Only skbs with an unset MAC header are affected; valid ones are
> > > dumped as before.
> > > 
> > >  BUG: KASAN: slab-out-of-bounds in dump_mac_header (net/netfilter/nf_log_syslog.c:831)
> > >  Read of size 1 at addr ffff88800ea49d3f by task exploit/148
> > >  Call Trace:
> > >   kasan_report (mm/kasan/report.c:595)
> > >   dump_mac_header (net/netfilter/nf_log_syslog.c:831)
> > >   nf_log_netdev_packet (net/netfilter/nf_log_syslog.c:938 net/netfilter/nf_log_syslog.c:963)
> > >   nf_log_packet (net/netfilter/nf_log.c:260)
> > >   nft_log_eval (net/netfilter/nft_log.c:60)
> > >   nft_do_chain (net/netfilter/nf_tables_core.c:285)
> > >   nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:307)
> > >   nf_hook_slow (net/netfilter/core.c:619)
> > >   nf_hook_direct_egress (net/packet/af_packet.c:257)
> > >   packet_xmit (net/packet/af_packet.c:280)
> > >   packet_sendmsg (net/packet/af_packet.c:3114)
> > >   __sys_sendto (net/socket.c:2265)
> > > 
> > > Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
> > > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > > Assisted-by: Claude:claude-opus-4-8
> > > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > > ---
> > >  net/netfilter/nf_log_syslog.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
> > > index 7a8952b049d1..ed5283fb6b67 100644
> > > --- a/net/netfilter/nf_log_syslog.c
> > > +++ b/net/netfilter/nf_log_syslog.c
> > > @@ -815,7 +815,7 @@ static void dump_mac_header(struct nf_log_buf *m,
> > >  
> > >  fallback:
> > >  	nf_log_buf_add(m, "MAC=");
> > > -	if (dev->hard_header_len &&
> > > +	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
> > >  	    skb->mac_header != skb->network_header) {
> > 
> > Maybe this instead?
> > 
> > +           skb_mac_header_was_set(skb) &&
> > +           skb_mac_header_len(skb) != 0) {
> 
> Thanks for the quick reply to this patch.
> 
> The skb_mac_header_len is a combination of
> 1) `skb_mac_header_was_set(skb)` and
> 2) `skb->network_header - skb->mac_header`

No, 1) is only true if DEBUG_NET_WARN_ON_ONCE() is enabled.

> However, we have skb_mac_header_was_set added in the
> original patch, and we have `skb->network_header - skb->mac_header`

I think this is the last spot which opencodes skb_mac_header_len() in
the netfilter tree.

> at the start of the fallback code block:
> 
> ```
> fallback:
> 	nf_log_buf_add(m, "MAC=");
> 	if (dev->hard_header_len &&
> 	    skb->mac_header != skb->network_header) {
> 	    ...
> ```
> 
> So I think the original patch should be enough.

I think this patch could be streamlined like this:

ebb966d3bdfe ("netfilter: fix regression in looped (broad|multi)cast's MAC handling")
