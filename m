Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84DB2EF653;
	Sun,  4 Oct 2026 19:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791141227; cv=none; b=dAKbRqzcXAg0hGaXkPRaL87SgO0Nm+aOn8PbI9momaczgKBuU7r33NxtwnMnSMMiihtCjzYtlH90VLeYfktrk5cKZZCWrgVBOmuBOooyR3RSn+N/C9Q01NEgjcLFpzQccZIGzCB6vKNty96Wu5b34TRDCci+KmmN42QrL91RfIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791141227; c=relaxed/simple;
	bh=LmT7qUG0+JDTwsZCtUim498HbU/w8AFnWENCKFAEM80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fKXcJeQKdP6I7dio/7VIjn7rSxHUtv6dx992Dg0D8mOGPusB6HFl21jh9BJjuT2szrINAP1lLiY/XdCZ+IrZa/rOLjzkMKzOnlD9c6gpe/2wqDWWzHUyeTttWX4uRyPYYExVO0+8+N8N479G646V885Zgaz9y4QAXvqZwc7tGf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iiW+jCyZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iiW+jCyZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791141213;
	bh=6KYwscBAPThUi2rjcfCeCcgpFd71+oEj095WqmAons0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iiW+jCyZC1wbPm1lGzLldTbD1VnW2rM1oWRESBoYa+TwYXW+pAPbCLMN6Y4PsNNv7
	 ehkubjBjx6ehkHxBKEXJwNUi2AuTEAPhFwVckNnm4m7cOWC+hlxEbrvXmYaTLvOJzs
	 ObwHBwa5BNQVMGt77Z4tpvMvEOM3ATl4zUQvQYSWW4atazeKLfdvneEKQ49v1Pvp9D
	 kNHVaiY3AyCqHtGwfprE49tRKwRpzQtVnbzwgxURwI0d9TLDYhWjTIlWViRhcHg3kp
	 ZdRociy87W6/yaWyBOfUym8nEoGQYLjqZgd6KLad1xBN9KlFEwyamJD6eiijBviPS1
	 /gJOoVjdaDKTg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7889E60060;
	Sun,  4 Oct 2026 21:13:33 +0200 (CEST)
Date: Sun, 4 Oct 2026 21:13:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d7795c8487ca4e20ed88@syzkaller.appspotmail.com,
	syzbot+d0d2f1a65f45b319d25d@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH nf] netfilter: nft_synproxy: only handle pure SYN and ACK
 packets
Message-ID: <asKkUzOppJayDbvD@chamomile>
References: <20261004160615.142456-1-ngocthang2710.1999@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261004160615.142456-1-ngocthang2710.1999@gmail.com>

On Sun, Oct 04, 2026 at 11:06:15PM +0700, Nguyen Ngoc Thang wrote:
> nft_synproxy treats any segment with SYN set as a client's initial SYN
> and any segment with ACK set as the client's final ACK. A SYN-ACK thus
> gets answered with a fresh SYN-ACK cookie.
> 
> If that reply is routed back to the same host, e.g. to a peer address
> covered by an address on lo, it re-enters the input hook, is answered
> again, and never stops. Every such SYN starts its own endless loop over
> the loopback backlog, so NET_RX softirq keeps the CPU busy and memory
> fills with skbs and rtable entries until workqueues stall and the
> machine OOMs.
> 
> Use the same flag checks as ip(6)t_SYNPROXY: SYN without ACK, FIN or
> RST is an initial SYN; ACK without SYN, FIN or RST is the client ACK.
> Anything else falls through to the next expression.

Wrong tree. This proposal has to go through nf-next.

> Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
> Reported-by: syzbot+d7795c8487ca4e20ed88@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d7795c8487ca4e20ed88
> Reported-by: syzbot+d0d2f1a65f45b319d25d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d0d2f1a65f45b319d25d
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> ---
> Notes (not for the changelog):
> 
> Reproduced in QEMU (x86_64, 2 vCPUs, KASAN+lockdep) with syzbot's C
> repro for d7795c8487ca4e20ed88. Minimised: only the nft batch and the
> injected SYN matter, which is exactly the d0d2f1a65f45b319d25d program.
> 
> The rule is an inet table, base chain on input, with an unconditional
> "synproxy" expression. The SYN goes from 172.20.20.187 to .170 via tun;
> syzkaller puts 172.20.20.10/24 on lo, so the whole /24 is local and the
> SYN-ACK cookie comes back through lo. Instrumented trace:
> 
>   synproxy tx .170->.187 in=syz_tun out=lo syn=1 ack=1
>   synproxy tx .187->.170 in=lo      out=lo syn=1 ack=1
>   synproxy tx .170->.187 in=lo      out=lo syn=1 ack=1
>   ...
> 
> Before (3fd2ff60f6d6, full C repro):
>   - synproxy syn_received ~400k per CPU per netns after 15s
>   - rtable 80k -> 295k, skbuff_head_cache >1M, softirq time explodes
>   - "BUG: workqueue lockup", then OOM / hung task, VM wedges
> 
> After (2 runs x 300s, full C repro):
>   - no lockup, hung task or OOM
>   - rtable flat (~2.2k), skbuff_head_cache flat (~80k)
>   - syn_received grows slowly (~9.5k/300s): real SYNs still answered
> 
> ACK|FIN and ACK|RST no longer hit the cookie check (and its NF_DROP);
> they continue, as with ip(6)t_SYNPROXY's XT_CONTINUE. The usual
> "ct state invalid drop" rule still catches them.
> 
>  net/netfilter/nft_synproxy.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
> index 9ed288c9d168..a580cb7324da 100644
> --- a/net/netfilter/nft_synproxy.c
> +++ b/net/netfilter/nft_synproxy.c
> @@ -53,13 +53,13 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
>  	struct synproxy_net *snet = synproxy_pernet(net);
>  	struct sk_buff *skb = pkt->skb;
>  
> -	if (tcp->syn) {
> +	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
>  		/* Initial SYN from client */
>  		nft_synproxy_tcp_options(opts, tcp, snet, &info);
>  		synproxy_send_client_synack(net, skb, tcp, opts);
>  		consume_skb(skb);
>  		regs->verdict.code = NF_STOLEN;
> -	} else if (tcp->ack) {
> +	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
>  		/* ACK from client */
>  		if (synproxy_recv_client_ack(net, skb, tcp, opts,
>  					     ntohl(tcp->seq))) {
> @@ -84,13 +84,13 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
>  	struct synproxy_net *snet = synproxy_pernet(net);
>  	struct sk_buff *skb = pkt->skb;
>  
> -	if (tcp->syn) {
> +	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
>  		/* Initial SYN from client */
>  		nft_synproxy_tcp_options(opts, tcp, snet, &info);
>  		synproxy_send_client_synack_ipv6(net, skb, tcp, opts);
>  		consume_skb(skb);
>  		regs->verdict.code = NF_STOLEN;
> -	} else if (tcp->ack) {
> +	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
>  		/* ACK from client */
>  		if (synproxy_recv_client_ack_ipv6(net, skb, tcp, opts,
>  						  ntohl(tcp->seq))) {
> -- 
> 2.43.0
> 
