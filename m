Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5301D346AED
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 09:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792400487; cv=none; b=MfgwoZ5pevGHx546WrADj0fJVzvJa8e9AscqqhA6NNVnIAsEhv6JTTE4KRVX9/pxUMRUkw79Sei4KZLcGxgeUD3S87hAtHbGTxduXDyrxVgoL0TYU31g8x7/KWQQCEVGWBDHLdO3eN3E2ArSqcxffAusi6sKwNgI2Upwi2Qva0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792400487; c=relaxed/simple;
	bh=9rM9MvdYypzSBn/lsJjcgYAkYznkBGWPKjZPTj46ys8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ZC4yGAI9Tgr83URbvQTEiDb+02KqEdo2UMr4jqKjLff8JGGnOS6atOvvkkS5KcyrlrPZpJams8zYI/3uBkPzpy+oM7vHxo45K/dFRCOo7TLX0U561edW6utc6lN7AlxrXJDEAftEsvsNDIYX3A0nMpbEf4xS4Q7UMvxrOBC43hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WdACorNQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WdACorNQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792400482;
	bh=GbZtXx8NjreX0wuUh/jmTSO2YYNvZPMCx//6ml94abY=;
	h=From:To:Subject:Date:From;
	b=WdACorNQhXTgz1bHRYTBKX9VKAh4+78cdDJuoW8yYGf1Il1ZulB0Q5u7mu6Bad+g1
	 VNbwZhGaeDyiuZflJPVFaTByfBgEo3RNQV5xcn/NP8nlmQ/EsFrNXx6UOvyOdViliP
	 NeEiKtSDSUfUwArZDbnGqCUS1rC4cMulI6vPdgW3XDJfr2/9xOuQPEz9MvkGcAoz+c
	 0v1xvGtBY+ubFRvohQWTdhhN5U4Jxrm7MphXZY6h6pY1/2QKigUixVPgR0KZ+3v+S6
	 BjNPpVRl++6TdA2ORpU50hYAe9dbYo5w+2nkrOzEIjxK1AC3sdwi+YsAbrnkSa7Coe
	 x/WeERfcWkc+w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C6D2660051
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 11:01:22 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: flowtable: consolidate unsupported hardware offload check
Date: Mon, 19 Oct 2026 11:01:18 +0200
Message-ID: <20261019090118.1818306-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move this check to the function that allocates and enqueues the hardware
offload work. If hardware does not support it, then turn this into noop.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..44e4c6a64431 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1079,12 +1079,24 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 	}
 }
 
+static bool nf_flow_offload_unsupported(struct flow_offload *flow)
+{
+	if (flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.tun_num ||
+	    flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.tun_num)
+		return true;
+
+	return false;
+}
+
 static struct flow_offload_work *
 nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow, unsigned int cmd)
 {
 	struct flow_offload_work *offload;
 
+	if (nf_flow_offload_unsupported(flow))
+		return NULL;
+
 	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
 		return NULL;
 
@@ -1102,15 +1114,6 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 	return offload;
 }
 
-static bool nf_flow_offload_unsupported(struct flow_offload *flow)
-{
-	if (flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.tun_num ||
-	    flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.tun_num)
-		return true;
-
-	return false;
-}
-
 void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
 			     struct flow_offload *flow)
 {
-- 
2.47.3

