Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81C23BE146
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 16:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791129987; cv=none; b=AVeUUXMVJi07TA2bTWIcX/16HjrWV59PeWXOTjTme+kWw8913u+v/cqeLttzWWVz8ijeTiqCa9/izRWsZjVXj0yGpkrOkhSJ3KFAyUZERGwFyZU9rZU6mdEoFifAD3KT1GjZ5oo8qHa8uXbESaOHzrBsQzaAXkxj15UiehB7mJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791129987; c=relaxed/simple;
	bh=AITtcoaAIpb4uUeZtALKX3JgmREav8R3aY0e8nMvhXw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aqH9Ji02AdnDzPqu0MTogpEw64Q4beZN8YjgH3O66kxBlQ2PL4d+R0DsRIZXtTEOl3zLAXTUTiNQ1q9GGwYeNnugRXD7F3lFIvl1pf83qge2dntbVbeOwYKaW0lbc36PkUJxvQhwNEEn+HApXcgX00Of+jK6/HnZMSBopokzL/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UWB0PpX8; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UWB0PpX8"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-381b831d535so819156a91.0
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 09:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791129982; x=1791734782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KPCQRYfj3K7cx8lOYemZCxsct2R2cHzCc+gyMPgQVA0=;
        b=UWB0PpX84irY5u1ik9pACqKNxWiL5S/iHe8RtboCKx4bbfqlsHmXqaKo9HP1qFwapQ
         pjsQxFdVhl7QAXJGMDt+FG4huM65a7KZ9qopHbFQnmZP4ZNTl30XW/naKkwxs/+6iiqv
         2vxME+Cwi8+8BNV1BJCOGJb/7ZA8MikhfVs628uMta+UvLrbgDyJVvqee/qqgDk89nCN
         C4AnR1yTZl2MNnYsPX6va7rJwB5qdkzpXTfZ2itNU+m6zVDj6wArDRIhfT3Rw/w8GUC2
         UhNG1pKhcOFspa8NUl0GYxCTiOsmu3whdMxL3P381a41Xv9XZibvzY7137RgDfDqU6iN
         tXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791129982; x=1791734782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPCQRYfj3K7cx8lOYemZCxsct2R2cHzCc+gyMPgQVA0=;
        b=QanjFzubeZhD7t8hPC3da1Zvf/VjmCcF8yCSpiZIzUYUV6gJQT4OMNUUwVtn+1syjo
         /AkY5WOKt0I9M56JyVgtda9IC+Yfv7/ELtQGgfx3ADimjdX6c6f2k7XDYD+OBj3pkbf8
         1PTvH7bl83QikMIAB/BR6WQcB8DVF9wcf1zII7WP6dOLBd8VSEog/Pprla88MDw1BZiO
         /Flx0+A8QaQCrlu8qwR/znEt288vQEz7vPrHs6RUYLXPu8njthB4Jn2Jo/aEmMkgT3Ga
         iRmKOwFsf7X1T+B+BHZTN3ZEyWvfLA7827lgM6/OMfjmSRoz+je94gobe0rIKra0thPu
         aHuQ==
X-Forwarded-Encrypted: i=1; AKwUvBxoMgBeewwkZmgu2T7oRYEAnZHL0sg0SIoIp1majVXFQ07SOlc0LsRB8A1/5iU3ZMltbO9MjayYVfKVBnoWoJA=@vger.kernel.org
X-Gm-Message-State: AFq9FYI+/TXg1Yg65HbvNyaJ0B6ULkRN1qlibh9NbGOvDLfe7iodFKPu
	rc7GX6gdGjZ7XQzWoYrrZHCgTWj8DWFwPyfY6gOpNH+zAmxmP99xQzZx
X-Gm-Gg: AYBFou0tgw5OD9q/ZNJ32xdaCY+U0kIX4R9LzUm5YKHLm1E8JJ9lACPGpgXPwjYFVUd
	TMEwhOcN0p4nNQgYxpaMC6hrWq5pg3E/w4uGd/HYtmA3u7FD9wRHQu9878Ygiev5tf/7aHXTsQ4
	DABpQr1RMgsh20zV/ozuXISFrFZl8TEcFKhS56omjJyrPmS8FfSf/zsVcc4jS+wtbrF103rlNHc
	eS71RFdlrOqis41E2P3MSBokVKMUGi0Tvkz7K2whbKa5ylWYFvbXE1Ag0QJi7QWqXPxyCMPge90
	jFhgs7j5DEZELXGxKakkVe4eZ9WrP/mHIQWs+ZpB8a0kbrkbCIh39nXeTDOwIX/bYTcE+EJgF89
	opKorUE9L4K6C1RjZZB3TlYOsK6SaUWhKdRavq5BgB5j7KJuF7HYMMHX+hEOH1iCdYUb5rDVCpb
	rJkrE0WW1YTJrIanB4A3uhn2bfuONauasikdwOwTzB2uIieU/xv9fPM8J8/xf6pAFyB1DGJg==
X-Received: by 2002:a17:90b:1d43:b0:39e:1633:d29e with SMTP id 98e67ed59e1d1-3a786736686mr4376078a91.5.1791129982011;
        Sun, 04 Oct 2026 09:06:22 -0700 (PDT)
Received: from thangnn-ASUS.. ([2a09:bac5:d45f:e6::17:34f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7ad87874esm2760347a91.0.2026.10.04.09.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 09:06:21 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d7795c8487ca4e20ed88@syzkaller.appspotmail.com,
	syzbot+d0d2f1a65f45b319d25d@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Subject: [PATCH nf] netfilter: nft_synproxy: only handle pure SYN and ACK packets
Date: Sun,  4 Oct 2026 23:06:15 +0700
Message-ID: <20261004160615.142456-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
Notes (not for the changelog):

Reproduced in QEMU (x86_64, 2 vCPUs, KASAN+lockdep) with syzbot's C
repro for d7795c8487ca4e20ed88. Minimised: only the nft batch and the
injected SYN matter, which is exactly the d0d2f1a65f45b319d25d program.

The rule is an inet table, base chain on input, with an unconditional
"synproxy" expression. The SYN goes from 172.20.20.187 to .170 via tun;
syzkaller puts 172.20.20.10/24 on lo, so the whole /24 is local and the
SYN-ACK cookie comes back through lo. Instrumented trace:

  synproxy tx .170->.187 in=syz_tun out=lo syn=1 ack=1
  synproxy tx .187->.170 in=lo      out=lo syn=1 ack=1
  synproxy tx .170->.187 in=lo      out=lo syn=1 ack=1
  ...

Before (3fd2ff60f6d6, full C repro):
  - synproxy syn_received ~400k per CPU per netns after 15s
  - rtable 80k -> 295k, skbuff_head_cache >1M, softirq time explodes
  - "BUG: workqueue lockup", then OOM / hung task, VM wedges

After (2 runs x 300s, full C repro):
  - no lockup, hung task or OOM
  - rtable flat (~2.2k), skbuff_head_cache flat (~80k)
  - syn_received grows slowly (~9.5k/300s): real SYNs still answered

ACK|FIN and ACK|RST no longer hit the cookie check (and its NF_DROP);
they continue, as with ip(6)t_SYNPROXY's XT_CONTINUE. The usual
"ct state invalid drop" rule still catches them.

 net/netfilter/nft_synproxy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 9ed288c9d168..a580cb7324da 100644
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
2.43.0

