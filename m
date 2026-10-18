Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36297081A
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 00:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792281975; cv=none; b=P6Mk9VECgZOgCpr2YkuOzTJzwhinQYxhhBN1KQW1tvTaYBNDRuwWbvNiyjrzrZukDyJbwW4uVf/ljOA8mX5unwTz02msdsuEykp7Q1tnsqn1gVzWvqYn0v6zOzQMU5ZM3+AFZXZIH7WXZqlaVEsKtX0VhJeguAiMfN0UN397sX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792281975; c=relaxed/simple;
	bh=2UVU/62kVcA57pKU+yrzvhXKhGqJXNqGh7gzuIPAZ/Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFJYcuFqJDMBPCmg1/DPxz2cnDOgq1K1jHdd5Mpk8H14IBWdUdob+ND8YtGmu1zU8LAOCYMaRBEH0Vqr85J3b/WdiS0Fl2N26KtDsfOvz1eqJy9CtdA1jfD6oARI/kFuqzpQ1+KhWIjvVPE9Aa5NTqRE0xWkOC0IQ1NLed1eKoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Hq/NDETD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Hq/NDETD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792281971;
	bh=xlfMkuHvoM6QYSO6UzI4haCDewKwHGHfLyRxyqkma8g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Hq/NDETD4K0C+ty8tgay1RVGN8HiIjhzJ9c+IOo5xOMj6eEPmvNWqDqNjZnTAPJN9
	 FDNKnFJW1CtqkR4OaBKTV4u6yBsaJk/8kvQz0YNquMz/B3Q3cR3pU2pjXtWo/Xp65Q
	 Ow6nW/nviwA1mIvthJmpNME7tIE4edhp34hDxztxmpP9V/lIYdBmJOiDcbW5Q3e/cY
	 p0pZsAaRAMVI9yz7xHoetz5ow11ZPvfB8EFKtQLFhx5sqSnekNKVkG7W5JGT76P5oQ
	 CF80MRlbphw9gbpxumOJRmIfNGRfa2kT8vnHGxiTNLAy/D9BvAg+zNNsTBzURpayoj
	 XGZFqrmiyrawQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8B2BE600A3
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 02:06:11 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/2] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
Date: Sun, 18 Oct 2026 02:06:05 +0200
Message-ID: <20261018000605.1748752-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018000605.1748752-1-pablo@netfilter.org>
References: <20261018000605.1748752-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adding expectations to unconfirmed conntracks are problematic because of
reallocations of the ct extension area can happen while expectations are
placed in the ct extension expectation list.

NFQA_EXP was added with the purpose of supporting userspace conntrack
helpers, which create expectations in the postrouting hook with priority
NF_IP_PRI_CONNTRACK_CONFIRM.

Restrict this feature to userspace conntrack helpers.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 5b45d67e71cd..c2237328cca5 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1758,10 +1758,30 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 	if (nfnl_ct->parse(nfqa[NFQA_CT], ct) < 0)
 		return NULL;
 
-	if (nfqa[NFQA_EXP])
-		nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
-				      NETLINK_CB(entry->skb).portid,
-				      nlmsg_report(nlh));
+	if (nfqa[NFQA_EXP]) {
+		const struct nf_hook_entries *hooks;
+		struct nf_hook_ops **ops;
+		unsigned int i;
+
+		hooks = nf_queue_hook_entries(entry);
+		if (!hooks)
+			return NULL;
+
+		ops = nf_hook_entries_get_hook_ops(hooks);
+		if (!ops)
+			return NULL;
+
+		i = entry->hook_index;
+		if (i >= hooks->num_hook_entries)
+			return NULL;
+
+		if (ops[i]->hooknum == NF_INET_POST_ROUTING &&
+		    ops[i]->priority == NF_IP_PRI_CONNTRACK_CONFIRM) {
+			nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
+					       NETLINK_CB(entry->skb).portid,
+					       nlmsg_report(nlh));
+		}
+	}
 	return ct;
 #else
 	return NULL;
-- 
2.47.3

