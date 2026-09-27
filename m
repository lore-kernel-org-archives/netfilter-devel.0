Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02C73C378A;
	Sun, 27 Sep 2026 22:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546918; cv=none; b=K/5EsBknG4kaqyGEaKo4T0tmd9WcmRTWrXXVp0QDFZmqQ52IMgB0wl6gqROhWvhXWDydFb+30hvoLxboBJwQmLMSJRcI6+GwEQpVHltQG6C50eQ0tTM9ERjQCB/05QYM9iX8yLQZo8YSInpxmmICXojeq/4CUA6J6Tw/8XCSwmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546918; c=relaxed/simple;
	bh=y8rG4bxlHU/6227rK0/HCGuXqYtMjzgueAZNdQJqBTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jv2T7AumY2YRIDndZIW1335c4yoKSuiV6Vw9ErR7fOi0703C2CZCr6MmyddO3BBUBgCe90xNpQJQsHky5nMVyhMYWCg65j1hfMABuYwN/Y0QhJq7DMQiFGTTrn8a6nbw/Zd+pIkh4BJIK4FS/HwTp7l/51/nJGaeF9GEBGpd8vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uvnyxwGP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uvnyxwGP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546910;
	bh=P96IssL/zrnyt9ISfbsP54kwvK4Ib2boV6v4WJGxM/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvnyxwGPVgnOH4i8x38zmqsNpVZxQVh6B8JjHNuTfHyqqAjmexwcjU1huvb+AeU4J
	 mxPthyN6d18EiA0Z4VvR6Pgx521Uy4cRecx8tdRTaWG2ZEuv8ppeZFa9BVZi28PXSO
	 eB297nI9JsO5YKmAFjB+ZXyQWZEmt9PNR/KnO+snMfBDqyCO4SgkPH3DiVEMYMooHV
	 aGAoMYa4vh5WzRTK3kSyRuuM+Pa4wiXXuuoB7FaqvAzqnLpOSI5aFcGCNk7wmoJln9
	 oTEb9b3/9hJDrY185UGpunEZa97X6pz5Xhk93TUUSwErnarCZ35pxV0pH+GPvtV4ID
	 9AtVZHHeOZ4oA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 363C6603E3;
	Mon, 28 Sep 2026 00:08:30 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 07/11] ipvs: filter some flags received in the backup server
Date: Mon, 28 Sep 2026 00:08:12 +0200
Message-ID: <20260927220816.268206-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

While the IPVS SYNC protocol is not secure by design
we can still protect the backup server from messages that
can wreak havoc.

This commit addresses problems from received connection flags
or their combinations. We now drop messages as follows:

1. the NO_CPORT+TEMPLATE combination allows lookups for normal
connections to hit template which can break in many ways.
While the master does not sync connections with NO_CPORT flag,
i.e. before they are established, we still accept NO_CPORT
without TEMPLATE.

2. ONE_PACKET: it is not sent by master, so we do not
expect it in backup. Before now it was ignored by
IP_VS_CONN_F_BACKUP_MASK for protocol v1 while protocol
v0 created connections that are not hashed and dropped
immediately. Better to apply the IP_VS_CONN_F_BACKUP_MASK
also to the flags from v0 messages for consistency with v1.

Fixes: 87375ab47cd0 ("[IPVS]: ip_vs_ftp breaks connections using persistence")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index dfa8487ec0c2..1a30817fbbaf 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -954,6 +954,21 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 	ip_vs_conn_put(cp);
 }
 
+/* Check for incompatible flags */
+static bool ip_vs_sync_validate_flags(u32 flags)
+{
+	/* We do not expect NO_CPORT, especially to allow lookups
+	 * to hit templates
+	 */
+	if (flags & IP_VS_CONN_F_NO_CPORT) {
+		if (flags & IP_VS_CONN_F_TEMPLATE)
+			return false;
+	}
+	if (flags & IP_VS_CONN_F_ONE_PACKET)
+		return false;
+	return true;
+}
+
 /*
  *  Process received multicast message for Version 0
  */
@@ -977,8 +992,7 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
 			return;
 		}
 		s = (struct ip_vs_sync_conn_v0 *) p;
-		flags = ntohs(s->flags) | IP_VS_CONN_F_SYNC;
-		flags &= ~IP_VS_CONN_F_HASHED;
+		flags = ntohs(s->flags);
 		if (flags & IP_VS_CONN_F_SEQ_MASK) {
 			opt = (struct ip_vs_sync_conn_options *)&s[1];
 			p += FULL_CONN_SIZE;
@@ -991,6 +1005,13 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
 			p += SIMPLE_CONN_SIZE;
 		}
 
+		if (!ip_vs_sync_validate_flags(flags)) {
+			IP_VS_DBG(2, "BACKUP v0, Invalid flags 0x%X\n", flags);
+			continue;
+		}
+		flags &= IP_VS_CONN_F_BACKUP_MASK;
+		flags |= IP_VS_CONN_F_SYNC;
+
 		state = ntohs(s->state);
 		if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
 			pp = ip_vs_proto_get(s->protocol);
@@ -1146,7 +1167,13 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
 	}
 
 	/* Get flags and Mask off unsupported */
-	flags  = ntohl(s->v4.flags) & IP_VS_CONN_F_BACKUP_MASK;
+	flags = ntohl(s->v4.flags);
+	if (!ip_vs_sync_validate_flags(flags)) {
+		IP_VS_DBG(3, "BACKUP, Invalid flags 0x%X\n", flags);
+		retc = 25;
+		goto out;
+	}
+	flags &= IP_VS_CONN_F_BACKUP_MASK;
 	flags |= IP_VS_CONN_F_SYNC;
 	state = ntohs(s->v4.state);
 
-- 
2.47.3

