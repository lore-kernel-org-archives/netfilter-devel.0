Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35AC3BD24A;
	Thu, 16 Apr 2026 13:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345317; cv=none; b=n/6Bz8DiqiN6/x2DucjUGLpTAMqsj2UnPLuE0J7Q4rCElFebfxGxSoiOHMB9J0NgbkLrh18Fy2/pvSaqcttmeDNDZbTP42SMvtxiiFbszr01PeQJPcF5SfWphtgKtgvs6w8BsH8852Hl5w40osmhE1Qmr6aSyMUBk7q2z3zdL5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345317; c=relaxed/simple;
	bh=n82jOt6UEQC7+N0W8gYIzx30WEx1rR+0cYIp6zIdwf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDBapShPaqVuWHPn8YLZCts63zLoq3VVC7JEkD23pbWVEbu3rnW/8ah77vjK9fOKdcQzkN8OpQEels3gkSVv6RIiTo8oPpXVFx4t9oAIny9ag6tmx/yVJLgMFwcqUsybqvzJkjItYG94E1Rne9c8rEfIDVn1XBXAMv0EIo2944A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G//X2aiR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G//X2aiR"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E1CB960255;
	Thu, 16 Apr 2026 15:15:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776345314;
	bh=o8VaDYQ2e6Gez2TNQ38DdiCZe12qY8iiXBtviqCYhfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G//X2aiRfFXu+oy/TCnLFPnsnMG/Io+Ng5ZL77mves/6OPgQ6Yw2ev92J8RQe5bgY
	 EsSivdFCiqLQSeGtL7AKuIwfoueXnTg0UyhJfkjelYK7dY2kmMvCFFtiIiceI4sDow
	 Gy5aVu6oyN2ZvyYgLouuF3/4hqhv8V50FFQZ1Z81F+j5Ki3ht1oQWWNXwj1EUma+w8
	 Y8wM/8TF4zHTotP9itoDc2JlMD17C5LBTjb0U4akPciA1RRSzpIp3fJFahLv2Fbf+g
	 m6TLiZi5qijhtgyvHAEkLR3EYbomxnpEo1b+EV9pZk/qmu85/3sE+tuIRW0ppIu0jY
	 oG3MX1glRpxjw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 10/11] rculist: add list_splice_rcu() for private lists
Date: Thu, 16 Apr 2026 15:14:52 +0200
Message-ID: <20260416131453.308611-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416131453.308611-1-pablo@netfilter.org>
References: <20260416131453.308611-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds a helper function, list_splice_rcu(), to safely splice
a private (non-RCU-protected) list into an RCU-protected list.

The function ensures that only the pointer visible to RCU readers
(prev->next) is updated using rcu_assign_pointer(), while the rest of
the list manipulations are performed with regular assignments, as the
source list is private and not visible to concurrent RCU readers.

This is useful for moving elements from a private list into a global
RCU-protected list, ensuring safe publication for RCU readers.
Subsystems with some sort of batching mechanism from userspace can
benefit from this new function.

The function __list_splice_rcu() has been added for clarity and to
follow the same pattern as in the existing list_splice*() interfaces,
where there is a check to ensure that the list to splice is not
empty. Note that __list_splice_rcu() has no documentation for this
reason.

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/rculist.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 2abba7552605..e3bc44225692 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -261,6 +261,35 @@ static inline void list_replace_rcu(struct list_head *old,
 	old->prev = LIST_POISON2;
 }
 
+static inline void __list_splice_rcu(struct list_head *list,
+				     struct list_head *prev,
+				     struct list_head *next)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+
+	last->next = next;
+	first->prev = prev;
+	next->prev = last;
+	rcu_assign_pointer(list_next_rcu(prev), first);
+}
+
+/**
+ * list_splice_rcu - splice a non-RCU list into an RCU-protected list,
+ *                   designed for stacks.
+ * @list:	the non RCU-protected list to splice
+ * @head:	the place in the existing RCU-protected list to splice
+ *
+ * The list pointed to by @head can be RCU-read traversed concurrently with
+ * this function.
+ */
+static inline void list_splice_rcu(struct list_head *list,
+				   struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice_rcu(list, head, head->next);
+}
+
 /**
  * __list_splice_init_rcu - join an RCU-protected list into an existing list.
  * @list:	the RCU-protected list to splice
-- 
2.47.3

