Received: from mail.valinux.co.jp (mail.valinux.co.jp [210.128.90.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B251BF2A;
	Thu, 22 Aug 2024 04:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.128.90.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724301392; cv=none; b=uNsBvHn7aPHqPUGaJMjG28qddyFzVxF562W/seSixxDgl4TWYKTl2GwRYbEr0jd272HtXEWMdQii0pLpmmJFJSdtbrVLjqizadH9z9Q7b7Yfnmrt6QJeCy9Z/kAR+ItK8SNFI9sI2dNxz56wOfJpx6SE7mwlWtGP4BntWJcqXcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724301392; c=relaxed/simple;
	bh=rGhOD38GjPd2YCkgM1QGnWfa7sS2RIeAm2BRL6NL45I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J7ugdsblc5/qINGJGH6yFLUOHNZuzTwI3aAUEef0ZqB/6izLa0941LhlL4HwF8p38D+HYFDcuMqBku+oVfiG0jdoeH6o772PLdT3NuEJxYLnDXFAkVwfVSCTAa6YqDqGu1+uw+1ppiswtOHCj3brZ7qbwxzfGNWgmqAzQM36bzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=valinux.co.jp; spf=pass smtp.mailfrom=valinux.co.jp; arc=none smtp.client-ip=210.128.90.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=valinux.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valinux.co.jp
Received: from localhost (localhost [127.0.0.1])
	by mail.valinux.co.jp (Postfix) with ESMTP id BA818A9EBD;
	Thu, 22 Aug 2024 13:36:27 +0900 (JST)
X-Virus-Scanned: Debian amavisd-new at valinux.co.jp
Received: from mail.valinux.co.jp ([127.0.0.1])
	by localhost (mail.valinux.co.jp [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G7ptISx-GhRg; Thu, 22 Aug 2024 13:36:27 +0900 (JST)
Received: from DESKTOP-NBGHJ1C.local.valinux.co.jp (vagw.valinux.co.jp [210.128.90.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.valinux.co.jp (Postfix) with ESMTPSA id 8B39EA9B76;
	Thu, 22 Aug 2024 13:36:27 +0900 (JST)
From: takakura@valinux.co.jp
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ryo Takakura <takakura@valinux.co.jp>
Subject: [PATCH] netfilter: Don't track counter updates of do_add_counters()
Date: Thu, 22 Aug 2024 13:36:09 +0900
Message-Id: <20240822043609.141992-1-takakura@valinux.co.jp>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ryo Takakura <takakura@valinux.co.jp>

While adding counters in do_add_counters(), we call
xt_write_recseq_begin/end to indicate that counters are being updated.
Updates are being tracked so that the counters retrieved by get_counters()
will reflect concurrent updates.

However, there is no need to track the updates done by do_add_counters() as
both do_add_counters() and get_counters() acquire per ipv4,ipv6,arp mutex
beforehand which prevents concurrent update and retrieval between the two.

Moreover, as the xt_write_recseq_begin/end is shared among ipv4,ipv6,arp,
do_add_counters() called by one of ipv4,ipv6,arp can falsely delay the 
synchronization of concurrent get_counters() or xt_replace_table() called 
by any other than the one calling do_add_counters().

So remove xt_write_recseq_begin/end from do_add_counters() for ipv4,ipv6,arp.

Signed-off-by: Ryo Takakura <takakura@valinux.co.jp>
---
 net/ipv4/netfilter/arp_tables.c | 4 ----
 net/ipv4/netfilter/ip_tables.c  | 3 ---
 net/ipv6/netfilter/ip6_tables.c | 3 ---
 3 files changed, 10 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 14365b20f1c5..20de048d3e0c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1009,7 +1009,6 @@ static int do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	const struct xt_table_info *private;
 	int ret = 0;
 	struct arpt_entry *iter;
-	unsigned int addend;
 
 	paddc = xt_copy_counters(arg, len, &tmp);
 	if (IS_ERR(paddc))
@@ -1029,8 +1028,6 @@ static int do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	i = 0;
-
-	addend = xt_write_recseq_begin();
 	xt_entry_foreach(iter,  private->entries, private->size) {
 		struct xt_counters *tmp;
 
@@ -1038,7 +1035,6 @@ static int do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 		ADD_COUNTER(*tmp, paddc[i].bcnt, paddc[i].pcnt);
 		++i;
 	}
-	xt_write_recseq_end(addend);
  unlock_up_free:
 	local_bh_enable();
 	xt_table_unlock(t);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index fe89a056eb06..f54dea2a8fcd 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1162,7 +1162,6 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	const struct xt_table_info *private;
 	int ret = 0;
 	struct ipt_entry *iter;
-	unsigned int addend;
 
 	paddc = xt_copy_counters(arg, len, &tmp);
 	if (IS_ERR(paddc))
@@ -1182,7 +1181,6 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	i = 0;
-	addend = xt_write_recseq_begin();
 	xt_entry_foreach(iter, private->entries, private->size) {
 		struct xt_counters *tmp;
 
@@ -1190,7 +1188,6 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 		ADD_COUNTER(*tmp, paddc[i].bcnt, paddc[i].pcnt);
 		++i;
 	}
-	xt_write_recseq_end(addend);
  unlock_up_free:
 	local_bh_enable();
 	xt_table_unlock(t);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 131f7bb2110d..f1d3bb74eb16 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1179,7 +1179,6 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	const struct xt_table_info *private;
 	int ret = 0;
 	struct ip6t_entry *iter;
-	unsigned int addend;
 
 	paddc = xt_copy_counters(arg, len, &tmp);
 	if (IS_ERR(paddc))
@@ -1198,7 +1197,6 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	i = 0;
-	addend = xt_write_recseq_begin();
 	xt_entry_foreach(iter, private->entries, private->size) {
 		struct xt_counters *tmp;
 
@@ -1206,7 +1204,6 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 		ADD_COUNTER(*tmp, paddc[i].bcnt, paddc[i].pcnt);
 		++i;
 	}
-	xt_write_recseq_end(addend);
  unlock_up_free:
 	local_bh_enable();
 	xt_table_unlock(t);
-- 
2.34.1

