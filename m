Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8773A35A39D
	for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 07:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790493339; cv=none; b=KAGP+zl6Gp8GiCIxawTREIWk86viWLmbV+HBkzezpqxEVI93of1l7G3KF9dy0OClzSNOdzSRtcV6Djjp3QZe2TZWpc7iAUqvOdXXhOUEHAX8ySCwhN0pCvMDYeM/6AvM4E90KdEvcbF1M5VWLF+XkbZK3HrciUzoHvLHFkVSUn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790493339; c=relaxed/simple;
	bh=rnRLEgdA/1s1yycmRgso3T2+f+ZYJNQr7hOt/feO4pc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y7Jtjgkhp7nkxxYITYkBQE1W0GMTJ0pEpW0zpBBW5IDbZw0XEzmvnJ5WOfuH9VJpTP9pZX46v65OUQwnqg5HU4UP6nInyjgYz3p2OcueT7unT6HVDdn6Zqc74vj2xIo8g50OLBD9UJGu0Y87yvIXfYprqkWHxtiL6nQbdFb7K4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MArZXFSd; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MArZXFSd"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-34251480737so108512eec.3
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 00:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790493337; x=1791098137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QYM2plEZ7R9S62P1nYdznZP0BSc2LbAGxEIGE61a82Q=;
        b=MArZXFSdcLpj258o7hIWFACjqoPgIPWicBhrkHUfGJX7NqavbOWPxhWoCEd7dUWRsb
         NUR/fturKbAkT8IAH0nilHxuchUdBsDbpVFuLapj/w6VMdUrAT+WB0EfI65cxLot7OnD
         i1WMC1iOjczOfhazwflPGZkJ/XAMSYooAgRNOEPrFXrZZgYO9C+8iLtgb4+SZ6VGxPo7
         1N2gJpmXWim2H3EeUFtC3CMNkd2JktQJhrs5KudM7geZAQg220dWSdXGDuSxt1y2GoBt
         rk8MukUqqHUEewXuAUPAW4Ja5mbOUvaPs35/2Nca0LyGPJEKn1fd26YrjF4egc8duet5
         h0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790493337; x=1791098137;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QYM2plEZ7R9S62P1nYdznZP0BSc2LbAGxEIGE61a82Q=;
        b=wq0P0+3ZxtP3PqMi6CylWMEeSCvFAS4qSppy7b04kFHRAHNGxdFrACv2pkVeTftwUr
         8pqt59n2d5pLf+M7C1wU6nkuGYUrXtfVnqYePhhwhg5iCD4HsDYCoZIT65QbLfSThCa7
         P4Nvn2WwGc8wchn3FzwTLxn71WZOF7MJwTX5Uv6bNKB4HQCXsS/Dc276iP4pcK04eP6Y
         pnu1hV1Rw67n0NoYOSruzNZ/YdbP55ESDYG9VkiWfwPm8n+jGpiVjwSu4nmOWyd4yntm
         CwfVByoN4EQFoaGuPdByDgiyBLtm5x8c3X0oB/LfnemOAp0Ic2KUIyNUQmpFMN4xZpFq
         jaxw==
X-Gm-Message-State: AFq9FYITBJOBvOxBYK0Hy2aUEOlIqsnUj9pRRYxCbQOhzan9KrtOeo/E
	2NTb2OlYo/kXVizaINvvRJSv69ZgNU6AWO+RTZrqljkpedWzpqVsEkBl
X-Gm-Gg: AYBFou2NTL7hsW+iBAqfrKMbC8pMnggofiZf8wEL7/lqHsPbdy5wljGfLjHZsIugLMR
	sz/Gm8GsIvc/ikkgPzmXlAyJAoAqDrJrXxZn6FVgn30ls9f8ZJX+jP/qxWDain6GMDm5F8CJ+tB
	LqgxNzzqD6UIWswa28F21tjOWgwY2bC9PRhgXgRTAW3pTV/6V96PF4xf1RUKgBgkz3CG3wa+PuG
	IcVbIi3UHvU7fjh6MDofJ99LyuBl3yn6WHFwaLpOO431fKREnCwTa162gKEpgKsV+X7ARncxAtg
	mpKvTLw5JtDnz6sNbtWJlbS+Hj3gn4BfdGeFsuKP/jmFaE7DMJkZeGcFrHlL09qeR/mWz5lnGaM
	Gdslm5ISWLw7l8ah2a+RM+eiGGHzYvpIEujIUeRxC8jiMFXibpXvD5Kr7iHHJkjBj6J3BnEQFKh
	K1THkZ2yJ2JNkvsj9mXw2USQ7qdLfvBTyWsSe9dAwO+ypv9nI9PxZjTeedWYKPe2c71FWJpDYeU
	ck5C+pkKJLqpMMj8SQQROjdH4G5hFN/BhhC2zQVXgzjEpyOI7EcX0OKnA69ohJcHHlbfA==
X-Received: by 2002:a05:7301:dd97:b0:33e:6a79:5a81 with SMTP id 5a478bee46e88-3427179721dmr7795597eec.1.1790493336434;
        Sun, 27 Sep 2026 00:15:36 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34144b4ae50sm19610096eec.17.2026.09.27.00.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 00:15:35 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] netfilter: nf_tables: serialize offload stats with callback unbind
Date: Sun, 27 Sep 2026 15:15:20 +0800
Message-ID: <20260927071520.3693598-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rule GET and dump requests collect hardware statistics under RCU without
holding commit_mutex. Callback unbind removes entries from the base
chain's flow_block.cb_list and frees them immediately while holding
commit_mutex, so RCU does not protect the statistics iterator.

For example, a rule dump can load a block_cb in nft_setup_cb_call(),
then a concurrent transaction can unbind the chain and free that callback
in nft_flow_offload_unbind(). When the dump resumes, it dereferences the
freed block_cb to invoke its callback.

KASAN reported:

  BUG: KASAN: slab-use-after-free in nft_setup_cb_call.constprop.0+0x19d/0x200
  Read of size 8 at addr ffff88810a64d420 by task poc/87
  Call Trace:
   nft_setup_cb_call.constprop.0+0x19d/0x200
   nft_flow_offload_cmd+0x23b/0x480
   nft_flow_rule_stats+0x89/0x1d0
   nf_tables_fill_rule_info+0x689/0x8e0
   __nf_tables_dump_rules+0x256/0x940
   nf_tables_dump_rules+0x762/0x9f0
   netlink_dump+0x489/0x1140
  Allocated by task 86:
   flow_block_cb_setup_simple+0x443/0x820
   nft_block_offload_cmd+0x154/0x1e0
   nft_flow_block_chain+0xf9/0x420
   nft_flow_rule_offload_commit+0x448/0x5b0
  Freed by task 88:
   kfree+0x131/0x3c0
   nft_flow_offload_unbind+0x29c/0x400
   nft_block_offload_cmd+0x166/0x1e0
   nft_flow_block_chain+0xf9/0x420
   nft_flow_rule_offload_commit+0x18d/0x5b0

Use mutex_trylock() to serialize read-side hardware statistics refresh
with callback unbind. A blocking acquisition would sleep under RCU and
reintroduce the commit_mutex -> nfnl_subsys_ipset -> nlk_cb_mutex ->
commit_mutex lock dependency previously removed from reset dumps.

On contention, skip the hardware refresh and retain the cached counters,
as when the existing best-effort statistics request fails. Pass the
caller's lock state so transaction notifications continue to refresh
statistics under the mutex they already hold. Release an acquired mutex
before dumping expressions, leaving rule lookup and callback order intact.

Fixes: b72920f6e4a9 ("netfilter: nftables: counter hardware offload support")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 net/netfilter/nf_tables_api.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b59628e6240c..f234dc3f8d1e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3780,7 +3780,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 				    const struct nft_table *table,
 				    const struct nft_chain *chain,
 				    const struct nft_rule *rule, u64 handle,
-				    bool reset)
+				    bool reset, bool commit_locked)
 {
 	struct nlmsghdr *nlh;
 	const struct nft_expr *expr, *next;
@@ -3806,8 +3806,15 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 			goto nla_put_failure;
 	}
 
-	if (chain->flags & NFT_CHAIN_HW_OFFLOAD)
-		nft_flow_rule_stats(chain, rule);
+	if (chain->flags & NFT_CHAIN_HW_OFFLOAD) {
+		struct nftables_pernet *nft_net = nft_pernet(net);
+
+		if (commit_locked || mutex_trylock(&nft_net->commit_mutex)) {
+			nft_flow_rule_stats(chain, rule);
+			if (!commit_locked)
+				mutex_unlock(&nft_net->commit_mutex);
+		}
+	}
 
 	list = nla_nest_start_noflag(skb, NFTA_RULE_EXPRESSIONS);
 	if (list == NULL)
@@ -3864,7 +3871,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 
 	err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
 				       event, flags, ctx->family, ctx->table,
-				       ctx->chain, rule, handle, false);
+				       ctx->chain, rule, handle, false, true);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -3924,7 +3931,8 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule, handle, ctx->reset) < 0) {
+					table, chain, rule, handle,
+					ctx->reset, false) < 0) {
 			ret = 1;
 			break;
 		}
@@ -4072,7 +4080,7 @@ nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 
 	err = nf_tables_fill_rule_info(skb2, net, portid,
 				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
-				       family, table, chain, rule, 0, reset);
+				       family, table, chain, rule, 0, reset, false);
 	if (err < 0) {
 		kfree_skb(skb2);
 		return ERR_PTR(err);
-- 
2.43.0

