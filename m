Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EE94FECE1;
	Wed, 16 Sep 2026 23:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600629; cv=none; b=NxS8toMB4O8nKjYBJ3JKwUPYW09FeLafs7F7wrlI2x+0SKB71fgfr3/TH5hiHLvwjVYehenSXvKR9N2ML4d0E2sJyojbQ7wtHT/mrOtkwjz30lR4T1l2d+HGeRSH8h/acwGE/6v68/trHAc/F3/rtjawavo7rlA0CP+MHc2emYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600629; c=relaxed/simple;
	bh=ChULSigMkmfHrDW1omPPnrtNQkPkdpTBqq3S0JwV6Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlE9T+hUejRt30w23sizyf+mi7xlGC4gHzZnMkQ0fcEny9D0ZRTBbAOEmJGv4CwZ2VbCUW5eptMuGSEIRkgeEhr3rcAkv6JAJmohF2CkBBy17Ir4eMWeM6f0v8aKvSif9EhD3rp68uMvp5gNRJKvnYFp1VOPD+ffdlGdi+ak5s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vxTMhpNa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vxTMhpNa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789600626;
	bh=16a/pzgNET+iZ6Rjzywu6Hd4HhCpGwpW7EJeDjb7N18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxTMhpNanXA3VDNr/xHmRE0QwMsAELppwZAQ5fFaAjcQ3hKzBaxInK7c9VDNIjoMb
	 zafAZZhrqfgBMfSI/fRhP5dmswcmDEEtegIjnT0f5IBFADRu6siA18sjGx/D0cEyW/
	 3/qRfUplCrd04t+0VHHZ7me6/v/bg1hZuyxQmj8omSYvcKCsozosE7n+DMTNvBkosw
	 Bppl8TBRsfaTPZxndihcpJLO+C0l8pTbvHXBudt2D2r4oCCNSFm/Ffrl5vUgBu4wkK
	 zMILjEfnS0kOTCFuCqNJrx0O5po03oRX7RT5V4B3XX5q0zWOxCBAs1LL2ViEbVeBhj
	 eHHtOvtXW3HYw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7CF8960088;
	Thu, 17 Sep 2026 01:17:05 +0200 (CEST)
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
Subject: [PATCH net 07/10] ipvs: filter some flags received in the backup server
Date: Thu, 17 Sep 2026 01:16:48 +0200
Message-ID: <20260916231652.127456-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916231652.127456-1-pablo@netfilter.org>
References: <20260916231652.127456-1-pablo@netfilter.org>
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
connections to hit template which can break in many ways

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
index 5383aeafb0ae..69dc28153ec1 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -949,6 +949,21 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
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
@@ -972,8 +987,7 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
 			return;
 		}
 		s = (struct ip_vs_sync_conn_v0 *) p;
-		flags = ntohs(s->flags) | IP_VS_CONN_F_SYNC;
-		flags &= ~IP_VS_CONN_F_HASHED;
+		flags = ntohs(s->flags);
 		if (flags & IP_VS_CONN_F_SEQ_MASK) {
 			opt = (struct ip_vs_sync_conn_options *)&s[1];
 			p += FULL_CONN_SIZE;
@@ -986,6 +1000,13 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
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
@@ -1141,7 +1162,13 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
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

