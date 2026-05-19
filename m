Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F9D3D88EC
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 21:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226719; cv=none; b=aq0sCDrVUtd/4jLcLu/jW+zsZvh8soiFBQxrHMuRavLlkXyyyGwwm1AUowhnZigsXqKSUrCkGMe+e59qFNWaji7J/ZrmJwksI9lIQye3jLrOXanZwr4DowsD3S0iQO4F7ipBbIEOMiaRxhHFJro3kgMgERjNAar0H0A97iGuJFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226719; c=relaxed/simple;
	bh=kbN103sWeh3mYsr9nQa2v7/wrAiFSgBQyarOQVVrn38=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOXZWs3d1JBHkLWDS/Jmq9Q2QNRHl4bHapvRudNnP9m5Iw0nkrlsbhwqWeCEAipzVn16mdt7kyK/6G0RDlvno8maQsCW52ub9OuW5uPsZwHEwThp5zzUsq1slbSAt0kJX9z6i3C85/OFkgHkzVOyjC4AMMqAg9pSS7Vp7v5pI8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UloPZQDN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UloPZQDN"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9AE3860297
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 23:38:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779226716;
	bh=EYEMyA4qw36gNAnZf7O9nfEfU78P4bfw8yGqw0NwCBo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UloPZQDN5ErrsBWo1vh6Elt/ZuDsBSbsmOfnzaKL5jxYzWUefnyfjnyNO5Q4EnnAY
	 iVPYyjqnqKUAICuhicg2Q8x3xhAmBQzsU3PnL8nSnMZ4QT6LinmzEv1yR63f1V8bu3
	 XBIqcc5TEXYtsaRdSK1AvPfRUq33igI1doiOyY+MHBSg0P49glecXhsFcQm1Au+rhh
	 nMK44R+hqe16tcjquHQPDbho69IN/tTm5JPTKcepUizhY9O0GgocjrwAjjXO2FfdUV
	 hTL5uWYiPkfMhu8LCyjIVLskNZn0eCvbLxNnTbgR9gWAl2nCchWzfj3cwiOn+UrXVL
	 5EnU6EHyp0ChQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 7/7] netfilter: xt_CT: fix race with rule removal and nfnetlink_queue
Date: Tue, 19 May 2026 23:38:26 +0200
Message-ID: <20260519213826.1181661-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260519213826.1181661-1-pablo@netfilter.org>
References: <20260519213826.1181661-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

         CPU0                           CPU1
                               xt_CT attaches tmpl_ct
  remove rule with xt_CT
  ...                          ...
  nf_queue_nf_hook_drop()
                               nfqueue's enqueue_skb

While skb is flying to be enqueued by nfqueue, the rule and the
helper/timeout can be removed, leaving a dangling pointer in the ct
extensions.

Set on dying bit in the template and handle this from nfnetlink_queue.

Fixes: 84f3bb9ae9db ("netfilter: xtables: add CT target")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 20 ++++++++++++++++++++
 net/netfilter/xt_CT.c           |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 984a0eb9e149..c682adc34dcf 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -412,6 +412,20 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	nf_queue_entry_free(entry);
 }
 
+static bool nf_ct_drop_template(const struct nf_queue_entry *entry)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	struct nf_conn *ct = (void *)skb_nfct(entry->skb);
+
+	if (!ct || !nf_ct_is_template(ct))
+		return false;
+
+	if (nf_ct_is_dying(ct))
+		return true;
+#endif
+	return false;
+}
+
 /* return true if the entry has an unconfirmed conntrack attached that isn't owned by us
  * exclusively.
  */
@@ -468,6 +482,9 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		}
 	}
 
+	if (nf_ct_drop_template(entry))
+		verdict = NF_DROP;
+
 	if (verdict != NF_DROP && entry->nf_ct_is_unconfirmed) {
 		/* If first queued segment was already reinjected then
 		 * there is a good chance the ct entry is now confirmed.
@@ -1077,6 +1094,9 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		break;
 	}
 
+	if (nf_ct_drop_template(entry))
+		return -EINVAL;
+
 	/* Check if someone already holds another reference to
 	 * unconfirmed ct.  If so, we cannot queue the skb:
 	 * concurrent modifications of nf_conn->ext are not
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 827e45f5d5ee..9c4e8e3f6d25 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -285,6 +285,8 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 	struct nf_conn_help *help;
 
 	if (ct) {
+		set_bit(IPS_DYING_BIT, &ct->status);
+
 		if (info->helper[0] || info->timeout[0])
 			nf_queue_nf_hook_drop(par->net);
 
-- 
2.47.3

