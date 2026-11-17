Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794885912;
	b=Q8izg5Y0Wm4+7IHAq71CTjls3VbDfzMAPrF9r7Ldu7W5EMlZEcIZHHQEob5X9RjNrc38
	 gjW98TdRnTicVaRSQgngO69FL4BxVtG9MhEHO5iLdJIL5fmQLMk1pMHJk1zP6uwgUq6AW
	 pNF6E0+j+tjZUFpI/PjGM/VGJALWzOZbTrBEsAxxVg1Vf88H4lx92bkKmyrSahdCx8EXH
	 SlOn53DL/YlydWW6sQPUmOim520yofHDuH2hwRu3DPSKiMaYxCiYKn534d6rtYvxhJ1EL
	 RxLex7UgAfBvxhfrnwmpLEhePHZgHqTGBzNihzGaZs5LY6d9/S8NPevnEeucCWdljIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794885912;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WbDoSnKE0ZGoRZJIcuyliBf/KrTv4kOLTh6gP0t2RoI=;
	b=fO0ku2N3deKbZz9XhJ9dz48cmxxzJCRkwudwpkOkymU36eCVejdkbMMILqzGVtVyRPV0
	 g1BargzGd3SfexmTAGj2I1yjVDHme3LS6MR15oU+5ze/UIC79ho7Wj2zLfvR6xZKZBkcl
	 VWIrv0ad/dulhJBOIjVGk40Lq3x3Cwyv7DOF9xHlzRl8NjlqdlhSul8rCdvySemXp+FC3
	 B2S8lVXv7j/tCWWGJmfbMdQQfOOTn2ciYkqnlpy5LyYLPsUOu0Vf+Y0eA+voADc/QkhjC
	 zvCVX/UdDSLG54IN3VWOPkriibw9MgvRBQeRmhJAqU/3xAL/qUckCU3S/rlGwD/ES5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AAD606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 03:25:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32AAD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AC3CF6055A; Tue, 17 Nov 2026 04:25:09 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Dominik Shaim Ulrich <info@openservis.cz>
Subject: [PATCH nf] netfilter: synproxy: fix double tsoff application in server ACK TSecr
Date: Tue, 17 Nov 2026 04:24:53 +0100
Message-ID: <20261117032459.19314-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
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

When SYNPROXY is active with timestamp options enabled, the handshake ACK
sent to the backend carries a TSecr that is off by synproxy->tsoff.

The code swaps tsval and tsecr before calling synproxy_send_server_ack().
The ACK is built with the correct TSecr (the server's TSval), but it
re-enters ipv4_synproxy_hook() on its way out, where
synproxy_tstamp_adjust() adds tsoff to TSecr a second time.

Since commit 3ba075278c11 ("tcp: be less liberal in TSEcr received while in
SYN_RECV state") Linux TCP performs stricter validation and such backends
will drops the ACK. This will delay connection establishment until the
server SYN-ACK retransmit, which may take a few seconds.

Replace the swap() by explicit initialisation of tsval/tsecr for both
the server and client ACKs.  Build the server ACK with TSecr
pre-compensated (server TSval - tsoff), so that the adjustment on
re-entry yields the server's actual TSval.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Reported-and-tested-by: Dominik Shaim Ulrich <info@openservis.cz>
Closes: https://lore.kernel.org/netfilter-devel/CAFvzkdAXBNAWcHFNo6akAo63Wd8B_jvhkt=AEmuLR9fgPBEfGg@mail.gmail.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_synproxy_core.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 401ce5a13f3f..9c6a4c8c3a63 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -651,6 +651,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 	const struct ip_ct_tcp *state;
 	struct tcphdr *th, _th;
 	unsigned int thoff;
+	u32 tsval, tsecr;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct)
@@ -732,13 +733,18 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 				  NF_SYNPROXY_OPT_WSCALE |
 				  NF_SYNPROXY_OPT_SACK_PERM);
 
-		swap(opts.tsval, opts.tsecr);
+		tsval = opts.tsval;
+		tsecr = opts.tsecr;
+
+		opts.tsval = tsecr;
+		opts.tsecr = tsval - synproxy->tsoff;
 		synproxy_send_server_ack(net, state, skb, th, &opts);
 
 		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
 		nf_conntrack_event_cache(IPCT_SEQADJ, ct);
 
-		swap(opts.tsval, opts.tsecr);
+		opts.tsecr = tsecr;
+		opts.tsval = tsval;
 		synproxy_send_client_ack(net, skb, th, &opts);
 
 		consume_skb(skb);
@@ -1074,6 +1080,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 	struct synproxy_options opts = {};
 	const struct ip_ct_tcp *state;
 	struct tcphdr *th, _th;
+	u32 tsval, tsecr;
 	__be16 frag_off;
 	u8 nexthdr;
 	int thoff;
@@ -1162,13 +1169,18 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 				  NF_SYNPROXY_OPT_WSCALE |
 				  NF_SYNPROXY_OPT_SACK_PERM);
 
-		swap(opts.tsval, opts.tsecr);
+		tsval = opts.tsval;
+		tsecr = opts.tsecr;
+
+		opts.tsval = tsecr;
+		opts.tsecr = tsval - synproxy->tsoff;
 		synproxy_send_server_ack_ipv6(net, state, skb, th, &opts);
 
 		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
 		nf_conntrack_event_cache(IPCT_SEQADJ, ct);
 
-		swap(opts.tsval, opts.tsecr);
+		opts.tsecr = tsecr;
+		opts.tsval = tsval;
 		synproxy_send_client_ack_ipv6(net, skb, th, &opts);
 
 		consume_skb(skb);
-- 
2.56.1

