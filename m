Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF8016B73E
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718378209; cv=none; b=oKYlBypjNfyHythCeGHnHEA60GDS5Hx+SyrVlI7xkU5+7WKlYRZIZuG4ybb+mSTpCw7OAQ5Ltxe6sF2cCkIi/YUdzomHuTy+DSN4ss77D3GPvP+N9bV7/fjKl6jDO09jW3+EDL/dqVSsQMqfWAeSBHPnoNqsaObTCSaxyWAwUMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718378209; c=relaxed/simple;
	bh=HzI8Ug5TT32/qdHQ4WPf1OKFtgrqJ/tEZDwbzAflKhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfpZu/MrNgjsTBDWPjJuic890yYNZ4wJyECBs003nwkp8w7vgF9KkwYHmQSh5RvCt+HBSjbg/RswrdNm/LDiadQWWi0JZjWosz0x2AJvHpnNieyvt1+0mLPqSj0b7GMgCyVWjuJV5SF373/61RpfYNfrV/kMqsUo/THHhSvQIQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gjqDdmjo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gjqDdmjo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0ByjG0cUmTZt76ScN72C9fSHMRgA6/Et8U55GFdMcN4=; b=gjqDdmjozRbjkpbULSlHU6NL/w
	itQ6gzZ4CeC4phGUtJGERPgeenITTfqy968PZL+ranLHvM9IvxI9uLAsezu3pCpQ22ssL8JAWCruT
	hGtH1H8++M4Q+p6b4Daxv449yEo8KvReEgcdipCPPvz5n9NV+50AQNf4O9V8e1+4hE0ZobyI9FGDG
	W0SGgHt5g1Y3iTRnXFLDrkp+rwSAiNGwV8r4gyDkF39TkYDbQj4FJAnjozMB/3TQya6Kj3tSPT+b9
	sl9eWDJ2fT1Dbp8Qvp76uir+8HG8hD46nKew2X1HCYCs2RzJxdsm98sUzp2z6GmLt5cb94X6tOYAX
	rSAo9WkQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sI8fO-000000007Kh-3duS;
	Fri, 14 Jun 2024 17:16:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: [nf-next PATCH v2 2/2] netfilter: xt_recent: Lift restrictions on max hitcount value
Date: Fri, 14 Jun 2024 17:16:41 +0200
Message-ID: <20240614151641.28885-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240614151641.28885-1-phil@nwl.cc>
References: <20240614151641.28885-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support tracking of up to 65535 packets per table entry instead of just
255 to better facilitate longer term tracking or higher throughput
scenarios.

Requested-by: Fabio <pedretti.fabio@gmail.com>
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1745
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/xt_recent.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 60259280b2d5..588a5e6ad899 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -59,9 +59,9 @@ MODULE_PARM_DESC(ip_list_gid, "default owning group of /proc/net/xt_recent/* fil
 /* retained for backwards compatibility */
 static unsigned int ip_pkt_list_tot __read_mostly;
 module_param(ip_pkt_list_tot, uint, 0400);
-MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 255)");
+MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 65535)");
 
-#define XT_RECENT_MAX_NSTAMPS	256
+#define XT_RECENT_MAX_NSTAMPS	65536
 
 struct recent_entry {
 	struct list_head	list;
@@ -69,8 +69,8 @@ struct recent_entry {
 	union nf_inet_addr	addr;
 	u_int16_t		family;
 	u_int8_t		ttl;
-	u_int8_t		index;
-	u_int8_t		nstamps;
+	u_int16_t		index;
+	u_int16_t		nstamps;
 	unsigned long		stamps[];
 };
 
@@ -80,7 +80,7 @@ struct recent_table {
 	union nf_inet_addr	mask;
 	unsigned int		refcnt;
 	unsigned int		entries;
-	u8			nstamps_max_mask;
+	u_int16_t		nstamps_max_mask;
 	struct list_head	lru_list;
 	struct list_head	iphash[];
 };
-- 
2.43.0

