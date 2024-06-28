Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0081CCCA9;
	Fri, 28 Jun 2024 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590729; cv=none; b=qIvVZcGHLZhdcC6XPr+FoAcyh7y+wgPgzZ3tIoyhwgEjjyDzoOwbBeZRj5SkJdNj1ZnKCwqEPpEXf6w8AwKJkTnWhd/2IP1Nrm0zmRYF3Z2mVEiM9OeVknFiYnROhB8HmB0pIyvG81emdxN8D3Ggx+7rtWSCQny4UQ2v6W5vjdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590729; c=relaxed/simple;
	bh=QWdoxRnGLtzRglYYajDEVC9t/Eue0WSK/jHpEOqzg0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HTUTRfj+WtrYWY9D+C1ITSs03fjgGb7D7xwNl3HT4P6pzzKMEc9Z8r0aWpjGgvxa5J4fKWOZoOBEQBz51kmd9/07gdn7p/nO6rVQmxFOum0E2HzxD4gJOlGjYDVb07CDDw3JL3nvqfZOt0eqvmV7b4LWQ9WFfRYGzpd3+xji1Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 17/17] netfilter: xt_recent: Lift restrictions on max hitcount value
Date: Fri, 28 Jun 2024 18:05:05 +0200
Message-Id: <20240628160505.161283-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240628160505.161283-1-pablo@netfilter.org>
References: <20240628160505.161283-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

