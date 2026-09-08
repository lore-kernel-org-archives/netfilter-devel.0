Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9DB51E45C
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 10:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861786; cv=none; b=kOMgocNmux5RDKskNYv1iP/VLkVdN8I15QcCXVUEtNUVipNrS1cmg4wb8Wa1b5SCyTRXRhntFqj3T4Me1yc+gbzRlOE+hDbhC8hi5Q9qhivRTO7/xFTYi1MMeD5EvRkMHxS0eNBF369HY0SF+MjSPLF0BkWt5j0qY3RP2qLy5Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861786; c=relaxed/simple;
	bh=RKj1Op05n+KJsti9Hnj8xCIrWGq/t/vBwSIfOiKOmlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Weo1aKnn7dtNGqzkvruAI6tnaxyK6n5H7zldMBfTNjMoIEQzb407BF5i8aupPoDhMx1X0nK4kJZi2x0accFgUvkZoCkzUlnACuWcAmp0mV3fCvJXunAdjGueBWKMXOjLVBWOyZsRNVbyb9SDJvBLSafuHc1H1sZFG5BwheEMVFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YHgM2SO2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YHgM2SO2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tBa73/KwL7yeD1bmuuIcIEf1Orc57OAd5s3o1nOkQ/w=; b=YHgM2SO293HNEEh5VfZLlj2dyR
	+OuPdNn0xymmENq8FvlMxYCKCTR/MYXaIC/6JzE/wfQNyffbKiiEpYGj81d0iqe6c6l6wmKoBMZjH
	PUBxQ5EjqNX5dFoj62fjCB3AqJKJFWX6TllXxMFsewaya4L5tV/HvLcR+2u4QIH6RBU4X6NxTYlBT
	gGDo7OEM6XgXCJfFGNklKDb3RBwOgBwK3kNKdRfO1yHEP/3+em1uQy9B63v8/N7vVa6YjfoJ9TQkk
	rwFe+aQNcvfDVq+GWvVuWGZA7m8Xx9e/DmFw+qMcd7ABj3+fUHqeCSEBzvviQGfyKTnN8wR0qwO2y
	X5MLtHtg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x3sfO-000000005SH-3URv;
	Tue, 08 Sep 2026 12:03:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 4/4] netfilter: conntrack: Improve invalid packet stats
Date: Tue,  8 Sep 2026 12:02:56 +0200
Message-ID: <20260908100256.2648175-5-phil@nwl.cc>
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

If nf_ct_seq_adjust detects a malformed packet, increment 'invalid'
counter instead of 'drop'.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_conntrack_core.c  |  7 ++++++-
 net/netfilter/nf_conntrack_proto.c | 14 ++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b0cd530cf8fe..45e0580e72d2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2241,7 +2241,12 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 
 	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
 	    !nf_is_loopback_packet(skb)) {
-		if (nf_ct_seq_adjust(skb, ct, ctinfo, protoff) < 0) {
+		int ret = nf_ct_seq_adjust(skb, ct, ctinfo, protoff);
+
+		if (ret == -EINVAL) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), invalid);
+			return NF_DROP;
+		} else if (ret < 0) {
 			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
 			return NF_DROP;
 		}
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 0db404f662de..e4cc9a69494e 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -194,10 +194,16 @@ unsigned int nf_confirm(void *priv,
 		}
 	}
 
-	if (seqadj_needed &&
-	    nf_ct_seq_adjust(skb, ct, ctinfo, protoff) < 0) {
-		NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
-		return NF_DROP;
+	if (seqadj_needed) {
+		int ret = nf_ct_seq_adjust(skb, ct, ctinfo, protoff);
+
+		if (ret == -EINVAL) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), invalid);
+			return NF_DROP;
+		} else if (ret < 0) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return NF_DROP;
+		}
 	}
 
 	/* We've seen it coming out the other side: confirm it */
-- 
2.54.0

