Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F4A2550D2
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 13:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751979891; cv=none; b=Yd8yzKsKUgLMWedqHnkwIRQJAo5bqzPaQE7SDATUA+fdAoYPBDeecAA3J12vS2IzbGq0fOrBmWNNQOmLAqqOhYkvrJIDu0XteXhCOsgGlNZDsh9YOevRN4vZ+NrS6SV9YOSBLNpbgcH7wqTn/IE9dPdIIAtlbomvE2xsnsflp6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751979891; c=relaxed/simple;
	bh=5mPqqCQmESU6me0lwafw93tBMnGWxl6x8Paz05hE6Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AdQR/496RXPKB0ZiVUYLHegeoouzsQi/LidfV5fEyHRxe/IAZBfmhxgc8CUnBoAYfMgiX3vnnanTIHcsq2tGwwLCg0dyxrFZQsftFpvCdZXjKVEk9awPon9RXZITktHZRDlqApEi93IRAHtFYiqd6BPnOQy0a8qTjuHFKxUEXsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ii0fhBgG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ii0fhBgG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NwR6R8clXN6zNcHGxIyA3fZ4DM0NEdt6sTScVXTWlVo=; b=ii0fhBgGEzDgc9Vl/Z+y6xu8+j
	mQYUjxes3f5PY7qx4UULb9aYgROKF2myZHPr5xblVTdsbG/1eohLQn/ECD0nq8boLXdHlgJwXphQJ
	uIoj5Pc9Vm6fog23QYd91IimEQ1zj3N7tU7UVztPZDPPu/1sxyKhNVBbCH6q/S5bs1kUa2Fy7Hr0h
	LNoch9u+UalR6LY3YUgUZBNus0faDVbXxqOZt0m5JuzM53mUzgsF30D4vXCSfAIFmTUWGtO8q8sjr
	DbWFgyzl/7t6/HTayOXCr7JawVOEK+BAQ5cJqOYIPIXNo+VUjzn2SClG/DX15XPHl1IsLUltJnlV5
	j0cAZbgA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uZ807-000000002pW-3JgK;
	Tue, 08 Jul 2025 15:04:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH] mnl: Support NFNL_HOOK_TYPE_NFT_FLOWTABLE
Date: Tue,  8 Jul 2025 15:04:42 +0200
Message-ID: <20250708130442.16449-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New kernels dump info for flowtable hooks the same way as for base
chains.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter/nfnetlink_hook.h |  2 ++
 src/mnl.c                                | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_hook.h b/include/linux/netfilter/nfnetlink_hook.h
index 84a561a74b982..1a2c4d6424b5f 100644
--- a/include/linux/netfilter/nfnetlink_hook.h
+++ b/include/linux/netfilter/nfnetlink_hook.h
@@ -61,10 +61,12 @@ enum nfnl_hook_chain_desc_attributes {
  *
  * @NFNL_HOOK_TYPE_NFTABLES: nf_tables base chain
  * @NFNL_HOOK_TYPE_BPF: bpf program
+ * @NFNL_HOOK_TYPE_NFT_FLOWTABLE: nf_tables flowtable
  */
 enum nfnl_hook_chaintype {
 	NFNL_HOOK_TYPE_NFTABLES = 0x1,
 	NFNL_HOOK_TYPE_BPF,
+	NFNL_HOOK_TYPE_NFT_FLOWTABLE,
 };
 
 /**
diff --git a/src/mnl.c b/src/mnl.c
index 33269ffebbbf6..3713fe3b3a745 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -48,6 +48,7 @@ struct basehook {
 	const char *table;
 	const char *chain;
 	const char *devname;
+	const char *objtype;
 	int family;
 	int chain_family;
 	uint32_t num;
@@ -2453,7 +2454,8 @@ static int dump_nf_hooks(const struct nlmsghdr *nlh, void *_data)
 		}
 
 		type = ntohl(mnl_attr_get_u32(nested[NFNLA_HOOK_INFO_TYPE]));
-		if (type == NFNL_HOOK_TYPE_NFTABLES) {
+		if (type == NFNL_HOOK_TYPE_NFTABLES ||
+		    type == NFNL_HOOK_TYPE_NFT_FLOWTABLE) {
 			struct nlattr *info[NFNLA_CHAIN_MAX + 1] = {};
 			const char *tablename, *chainname;
 
@@ -2471,6 +2473,10 @@ static int dump_nf_hooks(const struct nlmsghdr *nlh, void *_data)
 				hook->chain = xstrdup(chainname);
 			}
 			hook->chain_family = mnl_attr_get_u8(info[NFNLA_CHAIN_FAMILY]);
+			if (type == NFNL_HOOK_TYPE_NFT_FLOWTABLE)
+				hook->objtype = "flowtable";
+			else
+				hook->objtype = "chain";
 		} else if (type == NFNL_HOOK_TYPE_BPF) {
 			struct nlattr *info[NFNLA_HOOK_BPF_MAX + 1] = {};
 
@@ -2594,7 +2600,9 @@ static void print_hooks(struct netlink_ctx *ctx, int family, struct list_head *h
 			fprintf(fp, "\t\t+%010u", prio);
 
 		if (hook->table && hook->chain)
-			fprintf(fp, " chain %s %s %s", family2str(hook->chain_family), hook->table, hook->chain);
+			fprintf(fp, " %s %s %s %s",
+				hook->objtype, family2str(hook->chain_family),
+				hook->table, hook->chain);
 		else if (hook->hookfn && hook->chain)
 			fprintf(fp, " %s %s", hook->hookfn, hook->chain);
 		else if (hook->hookfn) {
-- 
2.49.0

