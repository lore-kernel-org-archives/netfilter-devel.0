Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7560F4BFE85
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2026 15:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791213800; cv=none; b=H56nyaElFQDfbtpHjieBptkPmu89Uo9U7kWiS1Xb711z0WpQ/Bvc+aJ0BtNN+7dDwi6+2Fhk5SyXy0+kouw33y/V+4j0Ioh8tUNomcXlory98evBuBoCFM3yE1rklKL1Yqu5tQe1H40La1XLiIgQ9cVixjcYsK5RhmLbtBXtqEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791213800; c=relaxed/simple;
	bh=RG1agnXLBjcZG441O6oFRZ0nobQwKmC/y9ELIPQfKAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n0gLr9Cp1ZeHa9dDF0gq/WTrSok5ED14C1VdPWAqJzf4IuX+b6rf9rBTeShMNt10FS9WNyt7eGZscmZn67rwLyUEfRl9vrFFm2Y3Aql8raqeOO5tJLnYxmUTR1ZJILlfzVByXbyxI6PLV8TBXHDy+jvSpPgupwJ5dhizpWEd0Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ICPvJIG7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PxGXBLY+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nQ14j51C; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dIH+mpni; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ICPvJIG7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PxGXBLY+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nQ14j51C";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dIH+mpni"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F122621DF8;
	Mon,  5 Oct 2026 15:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791213783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtWOvTzDhsbL+fnaDf7hn8RMABYqEKUGcMYsDWK0xRI=;
	b=ICPvJIG77dMO7DopWY1BM9La9FdlEBUDQeFcPYoxCfs6HuSG7abOWe5348gYc8HU1LGFqP
	IvmikGCMZfGZTOix/Go543ylzM6uzmtacvWJMuQh5KUlzxgyJnfscSHm+Vz7NiHM5t1KzV
	XPJpgGABl5hKiryFx9UjbVfXraooeJc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791213783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtWOvTzDhsbL+fnaDf7hn8RMABYqEKUGcMYsDWK0xRI=;
	b=PxGXBLY+sBw49+/lvxY+ac1W0bcl1OeDfPRV7JQZnHe2d2PuyKp15OGkKkaeKW1FBKpGln
	0fffPRXB7yVMCnDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nQ14j51C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dIH+mpni
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791213778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtWOvTzDhsbL+fnaDf7hn8RMABYqEKUGcMYsDWK0xRI=;
	b=nQ14j51CuWC/cIB0kruN6i6tB+xCe4/p2VcA2pEAwI27C4uME72yTEiD6b5mjr5kri6T2y
	mOplc5c+c3wGZvJcJM3vKInjmQqChgIfExnCS2+aekuhXf6DxFquEaKssPYwmaD3TQnhst
	oI0xY/ZLuG0dRgjwzD+DSgCnX0UZlPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791213778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtWOvTzDhsbL+fnaDf7hn8RMABYqEKUGcMYsDWK0xRI=;
	b=dIH+mpnih/qOlD7xtr2Ya64dfoFdMPpTCMGccl5mS91PRSFFZsqG8WFlNzVF7o5lKFg9J0
	LIaIE0JdLogkveDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3EB213B06;
	Mon,  5 Oct 2026 15:22:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xHu4JtHAw2oLbwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 05 Oct 2026 15:22:57 +0000
Message-ID: <6af568ad-c487-49da-b087-fa0b600b247b@suse.de>
Date: Mon, 5 Oct 2026 17:21:58 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next v2] netfilter: nft_synproxy: only handle pure SYN
 and ACK packets
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
 Fernando Fernandez Mancera <ffmancera@riseup.net>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+d7795c8487ca4e20ed88@syzkaller.appspotmail.com,
 syzbot+d0d2f1a65f45b319d25d@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <20261004160615.142456-1-ngocthang2710.1999@gmail.com>
 <20261005151257.9128-1-ngocthang2710.1999@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261005151257.9128-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	FREEMAIL_TO(0.00)[gmail.com,netfilter.org,strlen.de];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[d0d2f1a65f45b319d25d,d7795c8487ca4e20ed88];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,appspotmail.com:email,suse.de:dkim,suse.de:email,suse.de:mid,syzkaller.appspot.com:url]
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: F122621DF8
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 10/5/26 5:12 PM, Nguyen Ngoc Thang wrote:
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
> 
> Reported-by: syzbot+d7795c8487ca4e20ed88@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d7795c8487ca4e20ed88
> Reported-by: syzbot+d0d2f1a65f45b319d25d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d0d2f1a65f45b319d25d
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> ---
> v2:
> - Retarget to nf-next (Pablo).
> - Drop the Fixes: tag accordingly.

This should have been sent as a standalone thread not as a reply under 
the v1. In any case, I agree with the patch.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

> 
> v1: https://lore.kernel.org/all/20261004160615.142456-1-ngocthang2710.1999@gmail.com/
> 
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
>    synproxy tx .170->.187 in=syz_tun out=lo syn=1 ack=1
>    synproxy tx .187->.170 in=lo      out=lo syn=1 ack=1
>    synproxy tx .170->.187 in=lo      out=lo syn=1 ack=1
>    ...
> 
> Before (3fd2ff60f6d6, full C repro):
>    - synproxy syn_received ~400k per CPU per netns after 15s
>    - rtable 80k -> 295k, skbuff_head_cache >1M, softirq time explodes
>    - "BUG: workqueue lockup", then OOM / hung task, VM wedges
> 
> After (2 runs x 300s, full C repro):
>    - no lockup, hung task or OOM
>    - rtable flat (~2.2k), skbuff_head_cache flat (~80k)
>    - syn_received grows slowly (~9.5k/300s): real SYNs still answered
> 
> ACK|FIN and ACK|RST no longer hit the cookie check (and its NF_DROP);
> they continue, as with ip(6)t_SYNPROXY's XT_CONTINUE. The usual
> "ct state invalid drop" rule still catches them.
> 
>   net/netfilter/nft_synproxy.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
> index 9ed288c9d168..a580cb7324da 100644
> --- a/net/netfilter/nft_synproxy.c
> +++ b/net/netfilter/nft_synproxy.c
> @@ -53,13 +53,13 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
>   	struct synproxy_net *snet = synproxy_pernet(net);
>   	struct sk_buff *skb = pkt->skb;
>   
> -	if (tcp->syn) {
> +	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
>   		/* Initial SYN from client */
>   		nft_synproxy_tcp_options(opts, tcp, snet, &info);
>   		synproxy_send_client_synack(net, skb, tcp, opts);
>   		consume_skb(skb);
>   		regs->verdict.code = NF_STOLEN;
> -	} else if (tcp->ack) {
> +	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
>   		/* ACK from client */
>   		if (synproxy_recv_client_ack(net, skb, tcp, opts,
>   					     ntohl(tcp->seq))) {
> @@ -84,13 +84,13 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
>   	struct synproxy_net *snet = synproxy_pernet(net);
>   	struct sk_buff *skb = pkt->skb;
>   
> -	if (tcp->syn) {
> +	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
>   		/* Initial SYN from client */
>   		nft_synproxy_tcp_options(opts, tcp, snet, &info);
>   		synproxy_send_client_synack_ipv6(net, skb, tcp, opts);
>   		consume_skb(skb);
>   		regs->verdict.code = NF_STOLEN;
> -	} else if (tcp->ack) {
> +	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
>   		/* ACK from client */
>   		if (synproxy_recv_client_ack_ipv6(net, skb, tcp, opts,
>   						  ntohl(tcp->seq))) {

