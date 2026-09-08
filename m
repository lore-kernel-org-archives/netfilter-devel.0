Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2BD51E43F
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 10:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861786; cv=none; b=m6yhVVfvqZxztuRNCUaMSkWJTGQ0t0Y6genhm7VHnetqelkzJEol2nKqWLR4Q/8KRsHEpxjGiPhbpalX0RU71a+Jwpk+qtRjeBK+q4Tfb2IYHDLUATDd/g2ssjwSjOywGLWdAavnT1GS2fb5JrNvmxPwX1l0WH1iFHuh3eXX4KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861786; c=relaxed/simple;
	bh=na4tp/2Uuk4E2uwN7woXS20VF23zBqPb/2sywZ2TtqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/2LkIwyxcesd60jNgRnqXfMsa3yDcikqVjo2pifuvT4QnfcwRh8MNBzvm981r0B9vP/kAKgykDqehP6crRAnD+bk9z5Aj1QTeOaJE251vCJlP7KIsY4GU1rfYsxJIaIBo8OrJ+izjGifrgpQ41+14eDUuhX8QY52g1I3WPKIic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Ga/MHbII; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ga/MHbII"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HVTehLZ3uPB78MCyXQjO7zIQpraE8HAHXFTHjDuvizI=; b=Ga/MHbIIZ+DXFQRHnjE7YXqiQJ
	h4qavgG5/cQy6KG97NjA05fmhqLUZUAjH901HpJLjp4ncLxY/ahXArH1/YuiyoOpiG+i40Ah6F3l2
	FyHHviEbm8lSyfvccKCL2EGmM8dbJIAIGWF6CChRe82+8BteiBClnDPEmBi5l9robxFVyjDp1bfR4
	g516VrRsL2+2XhQzH9W4TUVV9Z7eh7cKin6swxQjmbOOkR6t6RO4WPX7bll3bjmBkemEbiWUZOhV9
	hqgRfLgWew4+1fO9cN9ApuObI5mu3IjGT6crCVfj1pDGGkL+UHdJpIi5bWRomgY6/8pS/Vq75MYUF
	nKm3yPPA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x3sfO-000000005SC-1IAs;
	Tue, 08 Sep 2026 12:03:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 3/4] netfilter: conntrack: nf_ct_seq_adjust to return error cause
Date: Tue,  8 Sep 2026 12:02:55 +0200
Message-ID: <20260908100256.2648175-4-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908100256.2648175-1-phil@nwl.cc>
References: <20260908100256.2648175-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some callers will want to distinguish between malformed TCP packets and
other failure reasons, so invert the return code logic.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_conntrack_core.c   |  2 +-
 net/netfilter/nf_conntrack_ovs.c    |  2 +-
 net/netfilter/nf_conntrack_proto.c  |  2 +-
 net/netfilter/nf_conntrack_seqadj.c | 24 +++++++++++-------------
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f9b8927327ba..b0cd530cf8fe 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2241,7 +2241,7 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 
 	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
 	    !nf_is_loopback_packet(skb)) {
-		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+		if (nf_ct_seq_adjust(skb, ct, ctinfo, protoff) < 0) {
 			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
 			return NF_DROP;
 		}
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index b4085af3ad1c..d64379e203eb 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -76,7 +76,7 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 	 * addresses and/or port numbers in the text-based control connection.
 	 */
 	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
+	    nf_ct_seq_adjust(skb, ct, ctinfo, protoff) < 0)
 		return NF_DROP;
 	return NF_ACCEPT;
 }
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 7a40e4e0e33e..0db404f662de 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -195,7 +195,7 @@ unsigned int nf_confirm(void *priv,
 	}
 
 	if (seqadj_needed &&
-	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+	    nf_ct_seq_adjust(skb, ct, ctinfo, protoff) < 0) {
 		NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
 		return NF_DROP;
 	}
diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 220216a4edc5..c95b6383a330 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -117,23 +117,21 @@ static void nf_ct_sack_block_adjust(struct sk_buff *skb,
 }
 
 /* TCP SACK sequence number adjustment */
-static unsigned int nf_ct_sack_adjust(struct sk_buff *skb,
-				      unsigned int protoff,
-				      struct nf_conn *ct,
-				      enum ip_conntrack_info ctinfo)
+static int nf_ct_sack_adjust(struct sk_buff *skb, unsigned int protoff,
+			     struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
 	struct tcphdr *tcph = (void *)skb->data + protoff;
 	struct nf_conn_seqadj *seqadj = nfct_seqadj(ct);
 	unsigned int dir, optoff, optend;
 
 	if (!seqadj)
-		return 0;
+		return -ENOSPC;
 
 	optoff = protoff + sizeof(struct tcphdr);
 	optend = protoff + tcph->doff * 4;
 
 	if (skb_ensure_writable(skb, optend))
-		return 0;
+		return -ENOMEM;
 
 	tcph = (void *)skb->data + protoff;
 	dir = CTINFO2DIR(ctinfo);
@@ -144,7 +142,7 @@ static unsigned int nf_ct_sack_adjust(struct sk_buff *skb,
 
 		switch (op[0]) {
 		case TCPOPT_EOL:
-			return 1;
+			return 0;
 		case TCPOPT_NOP:
 			optoff++;
 			continue;
@@ -153,7 +151,7 @@ static unsigned int nf_ct_sack_adjust(struct sk_buff *skb,
 			if (optoff + 1 == optend ||
 			    optoff + op[1] > optend ||
 			    op[1] < 2)
-				return 0;
+				return -EINVAL;
 			if (op[0] == TCPOPT_SACK &&
 			    op[1] >= 2+TCPOLEN_SACK_PERBLOCK &&
 			    ((op[1] - 2) % TCPOLEN_SACK_PERBLOCK) == 0)
@@ -163,10 +161,10 @@ static unsigned int nf_ct_sack_adjust(struct sk_buff *skb,
 			optoff += op[1];
 		}
 	}
-	return 1;
+	return 0;
 }
 
-/* TCP sequence number adjustment.  Returns 1 on success, 0 on failure */
+/* TCP sequence number adjustment.  Returns 0 on success, -err on failure */
 int nf_ct_seq_adjust(struct sk_buff *skb,
 		     struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		     unsigned int protoff)
@@ -177,16 +175,16 @@ int nf_ct_seq_adjust(struct sk_buff *skb,
 	s32 seqoff, ackoff;
 	struct nf_conn_seqadj *seqadj = nfct_seqadj(ct);
 	struct nf_ct_seqadj *this_way, *other_way;
-	int res = 1;
+	int res = 0;
 
 	if (!seqadj)
-		return 0;
+		return -ENOSPC;
 
 	this_way  = &seqadj->seq[dir];
 	other_way = &seqadj->seq[!dir];
 
 	if (skb_ensure_writable(skb, protoff + sizeof(*tcph)))
-		return 0;
+		return -ENOMEM;
 
 	tcph = (void *)skb->data + protoff;
 	spin_lock_bh(&ct->lock);
-- 
2.54.0

