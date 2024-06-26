Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8530168483
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2024 22:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441502; cv=none; b=maJ1rajLgbtqDk05aN65MlDLKItPzFh3cR2aJj461C/GJKTgZP4O8LStGdpQ32zkctEkxmv9kl9KvXcaUoor4KqiqngVKMPdxZicRINLJvi35zr1+g2ZEfYMk7zzM8c98Waf7bv/hoW6bVs9qQAE4HRgz+uwpOJ5MSuNoFZnlM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441502; c=relaxed/simple;
	bh=XvB/fVOzVICV4Hv7X0DoArH2+gBOnyTOV7+wtC/P4YI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XjuZLgRJRw+s+kk8Fdxsyd+H9VX6gXrF2iiznKvti+f34SKnO5aRmbYNgNAVO0dPFxcclXpQLxLfrvtbNzuE81CASE5OdV1WZ+G6yahR4Bm+l003m/BGpPfH3+xYgih0v4pvbYdg0i0ZRMk6J/sJW7LAbUCgDbrGz3kQN1j+1Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pSCYUsZ0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pSCYUsZ0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=v/gzPNJcPy5BetvmF8luKVE1aX6U8ovO7k86kRK1ksc=; b=pSCYUsZ0BZDX8wMwg/jhAkfqYZ
	SkKfs5+zGspCDpwQoSL8hlqZUJuV1vL6HVf4ZY4Ebzmdbkrn60Jul4lkaxV3DFrefhPWkmRvf6Zv8
	Kk+SrPfG9h13dojma7WH+18S3UDIm5XYi7MxO+n982CylyAcM7825IBnQz8OQzjM0gvWK6E6xYmCz
	x/Aiy3p2DxcXlro8NjobHy46ikRhIcCVCEKtTrvd1ACJBKfjyjtqDw+y4A4hjnIa9nfk+vP0URYId
	HUybwmW1U3muASWLeIqhvtcREf8RT0fwuvT7iYQQMPbZYGF8jWf4wETtHmjcj/ARicDHxnaXz46qI
	6S5HIUmw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sMbHF-000000002Ce-49Tx;
	Thu, 27 Jun 2024 00:38:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: [nf-next PATCH v2] netfilter: xt_recent: Lift restrictions on max hitcount value
Date: Thu, 27 Jun 2024 00:35:05 +0200
Message-ID: <20240626223806.31720-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
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

Note how this aligns sizes of struct recent_entry's 'nstamps' and
'index' fields when 'nstamps' was larger before. This is unnecessary as
the value of 'nstamps' grows along with that of 'index' after being
initialized to 1 (see recent_entry_update()). Its value will thus never
exceed that of 'index' and therefore does not need to provide space for
larger values.

Requested-by: Fabio <pedretti.fabio@gmail.com>
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1745
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fold the educational first patch into the actual change, keeping the
  commit's rationale on correctness.
---
 net/netfilter/xt_recent.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index ef93e0d3bee0..588a5e6ad899 100644
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
@@ -69,7 +69,7 @@ struct recent_entry {
 	union nf_inet_addr	addr;
 	u_int16_t		family;
 	u_int8_t		ttl;
-	u_int8_t		index;
+	u_int16_t		index;
 	u_int16_t		nstamps;
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

