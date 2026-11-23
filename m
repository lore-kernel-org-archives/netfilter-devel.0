Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442104;
	b=xEGcPu/PAHkI56FUGBk4a0gfAmKBsS/eka02c+PnpnHYem6UwAgUCMe/Ep5pHrkarnaY
	 itxwQJFyYwwiaLTfLxPX2b7F1JHy5E5bQeutT5Bw1xvd6CnJu8WsGvAWCA455LaqdEffc
	 fqM+jBhWnIlV7IETMEoGP+bDUmafrcjZIfbHv0ODCuuGAlq6HMNJ5PIolvUFX74u7GWDq
	 5/oQCdC419EoOD2MfHB2vTvC/YHQ9YC2WR4sj9cpm6Qn27kzlkG8gt9mo4zFCgLgi1fB9
	 8U+zK9SvxisijTNzKU72Dw/UCfhu0YZtYoNF2OczTvgLwizCHMMrwKLpbZcpItHIMQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442104;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=S7xkWiqqFqg9jXR+/p6MoARXsQBC0WdioQvUUUYQego=;
	b=ySWIzbNwrLfbPD7a1Fio3Edaz2Xw+HFIW3XcpZhqb4tUVWB7U2z9VRzBU4DgOVLoiDXq
	 Nekwng5Cd3DxTy7SGZlTf1DQnyU+f6EJ4HAkqiBdUElo0RKB3SUw3oc7JAvAG7S6Ps0xv
	 aOw7Lst9q8jXGg0GqZVMIYOAVsLNp/5G/iFjN3GQWDGW1lPZFPNT84Dm+mQCxCZwuwIKf
	 igRNlLB7prleFHT9Yofzbo3bpczbgUKdU8cbn2cIL4m/Iw+63vQcq7F0JufJMuBH0oz3y
	 J+CCEBY3qxWwuaLOuJtjo8s4/Rw/OEL8TgZ7jzRF8Bww9uBvjIzc1V4Q6n1JXb2KWDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=wCrXgCSX;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD5B606A337;
	Mon, 23 Nov 2026 13:55:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABD5B606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=wCrXgCSX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442100;
	bh=S7xkWiqqFqg9jXR+/p6MoARXsQBC0WdioQvUUUYQego=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCrXgCSXgJrfqkpVn0zilMZMORieaxMmoqO38wq8yfIgPSzxIlqEN5B4qe4LUHAH3
	 dUxlOups7CO+oXbGLtd4bwfhal2qUp0YcoZirUdi7+5In9cS1ddmlgpsMy+x+JrhZu
	 jTEiqTiZoyIf6IEk0zgTnxjWPib2j7CFYp2uJlVM17y+V9r699XCbFtI6PNiQ7sBjy
	 8xAVrj4z88QVU2WJqxtwAlQmvp055Qm7H8yvjGnUiLLfu6cBDS4ReN8GJcPupSL3TS
	 ObrHRvg2Tx+TT8f7B7vIwY0FYXshdh8B1OcwDnTvZZ1KiEUZJWwPYA9IE9z1wnVXfQ
	 eH2Nexnm+1jJg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A19B6602D6;
	Mon, 23 Nov 2026 14:54:59 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 08/15] netfilter: nft_synproxy: only handle pure SYN and ACK packets
Date: Mon, 23 Nov 2026 14:54:35 +0100
Message-ID: <20261123135442.3940372-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135442.3940372-1-pablo@netfilter.org>
References: <20261123135442.3940372-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

nft_synproxy treats any segment with SYN set as a client's initial SYN
and any segment with ACK set as the client's final ACK. A SYN-ACK thus
gets answered with a fresh SYN-ACK cookie.

If that reply is routed back to the same host, e.g. to a peer address
covered by an address on lo, it re-enters the input hook, is answered
again, and never stops. Every such SYN starts its own endless loop over
the loopback backlog, so NET_RX softirq keeps the CPU busy and memory
fills with skbs and rtable entries until workqueues stall and the
machine OOMs.

Use the same flag checks as ip(6)t_SYNPROXY: SYN without ACK, FIN or
RST is an initial SYN; ACK without SYN, FIN or RST is the client ACK.
Anything else falls through to the next expression.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Reported-by: syzbot+d7795c8487ca4e20ed88@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d7795c8487ca4e20ed88
Reported-by: syzbot+d0d2f1a65f45b319d25d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d0d2f1a65f45b319d25d
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_synproxy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 554a96a000f4..ad43faf1dd1b 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -53,13 +53,13 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
 
-	if (tcp->syn) {
+	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
 		/* Initial SYN from client */
 		nft_synproxy_tcp_options(opts, tcp, snet, &info);
 		synproxy_send_client_synack(net, skb, tcp, opts);
 		consume_skb(skb);
 		regs->verdict.code = NF_STOLEN;
-	} else if (tcp->ack) {
+	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
 		/* ACK from client */
 		if (synproxy_recv_client_ack(net, skb, tcp, opts,
 					     ntohl(tcp->seq))) {
@@ -84,13 +84,13 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
 
-	if (tcp->syn) {
+	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
 		/* Initial SYN from client */
 		nft_synproxy_tcp_options(opts, tcp, snet, &info);
 		synproxy_send_client_synack_ipv6(net, skb, tcp, opts);
 		consume_skb(skb);
 		regs->verdict.code = NF_STOLEN;
-	} else if (tcp->ack) {
+	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
 		/* ACK from client */
 		if (synproxy_recv_client_ack_ipv6(net, skb, tcp, opts,
 						  ntohl(tcp->seq))) {
-- 
2.47.3

