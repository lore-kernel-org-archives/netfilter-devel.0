Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF7241C6A;
	Tue,  7 Jan 2025 02:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217831; cv=none; b=cEbQvP/EnTGpyQa+JVaFgSvdwvBxeKPCJs/yD7VbM22xP2sqGTIyE+hLQKh6rS0INpWkikIuUnIL9VrgdnDhG6wNMCYPlYX/KCfnug4B+Nalg/Jjbnlt0C1WiIR3vUlsigi/OXTeqzGspY72l9jkW4oC2zDcuB0TApznzNyoSWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217831; c=relaxed/simple;
	bh=YMUtxu3ZrQ8r+vp5iNnZHoTn55cwjES43gOUeyMFtZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DNuGmtXEiV7nYePVoKIXFMM28XVQnIbaenSwrfc3WImVOQlOp3GMa4d1rZNdcwdYQUNzEzLtHu4VQgFpS1263TwMWsv3lJjBC3KdQ83J8M0DlIX2Yoyd5UGr/NgWps0DR5zknHHby0plldDZtgWwiywdIPFApQ4XbQfsO90l83A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=2BwGqvk6 reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="2BwGqvk6"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwNK60QhzVb2;
	Tue, 07 Jan 2025 03:43:45 +0100 (CET)
From: egyszeregy@freemail.hu
To: fw@strlen.de,
	pablo@netfilter.org,
	lorenzo@kernel.org,
	daniel@iogearbox.net,
	leitao@debian.org,
	amiculas@cisco.com,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH 10/10] netfilter: Use merged xt_*.h, ipt_*.h headers.
Date: Tue,  7 Jan 2025 03:41:20 +0100
Message-ID: <20250107024120.98288-11-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250107024120.98288-1-egyszeregy@freemail.hu>
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217826;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=2774; bh=X1NSHN7AudtxJJL7cfhLz4NFxJxb/YyHcQzUVR5zAAE=;
	b=2BwGqvk6UWyDhYcmbWw02c+XDBAEtOEoMMEHwdMsiEje9aeSmjXBhJWW9Wh3x7uo
	M4kleri3SmJfjqFWVPS5j8M7A4eOamnuUrDVJSPjND6wyQZ5hbZV3ufZOw+e1w8V2wP
	ArVBQyi8cpANmrDEvSW72q4jZgskfwAuJ29juuDuSxZA9B/yBluvci/0SZ5zlQD56iC
	u+HScqirhauozmIx8OxLuNAPG/axfTUzOJ4snZ0kflK3y8tXbnVkD4sjA1WhWzShSFX
	ikl63Rgh1F7cLcisXF//R0GAD3ol9m691O+Jkd1OQBlmr0DilQLVErk9q5f5T90FhU2
	wkOB8YyqHA==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Change to use merged xt_*.h, ipt_*.h header files.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 net/ipv4/netfilter/ipt_ECN.c | 2 +-
 net/netfilter/xt_DSCP.c      | 2 +-
 net/netfilter/xt_HL.c        | 4 ++--
 net/netfilter/xt_RATEEST.c   | 2 +-
 net/netfilter/xt_TCPMSS.c    | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 5930d3b02555..1370069a5cac 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -14,7 +14,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_ECN.h>
+#include <linux/netfilter_ipv4/ipt_ecn.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index cfa44515ab72..90f24a6a26c5 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -14,7 +14,7 @@
 #include <net/dsfield.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_DSCP.h>
+#include <linux/netfilter/xt_dscp.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: DSCP/TOS field modification");
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index 7873b834c300..a847d7a7eacd 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -14,8 +14,8 @@
 #include <net/checksum.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_TTL.h>
-#include <linux/netfilter_ipv6/ip6t_HL.h>
+#include <linux/netfilter_ipv4/ipt_ttl.h>
+#include <linux/netfilter_ipv6/ip6t_hl.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 4f49cfc27831..a86bb0e4bb42 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -14,7 +14,7 @@
 #include <net/netns/generic.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_RATEEST.h>
+#include <linux/netfilter/xt_rateest.h>
 #include <net/netfilter/xt_rateest.h>
 
 #define RATEEST_HSIZE	16
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 116a885adb3c..3dc1320237c2 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -22,7 +22,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_tcpudp.h>
-#include <linux/netfilter/xt_TCPMSS.h>
+#include <linux/netfilter/xt_tcpmss.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-- 
2.43.5

