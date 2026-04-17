Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7A13B47CD;
	Fri, 17 Apr 2026 09:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776418792; cv=none; b=aqmy4kIzil73CuSSS9XT1dhDnFtROT8L1Lwex+6fnUi4BRdA+a0b0HU1YFoo29JouS0L/aOWtAGIrkDCOOdt08n+GOLHKAxvs/ge54Koj/+2S76B+iTC0yiQH/XywDGtqs1bjiZ9GNF3qUzKPbczfBXnz27Ac+4aXwYfzpt+3V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776418792; c=relaxed/simple;
	bh=S3GejDg9W3hcOQC5RNKxkOhw6ILpGzU3/ViOh0Y6tto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhm0wCHj4BLlRsfZ71v+Ha/7VsZB3LmtpL3GAGoVKsDAzCiLj/HQSZyHYdRzQEtEEPQdnT/v1Gg2pMFZvHysR1yp8D7yyg88zerutWqwD8N2JvcHTbzBjAIu81TXeyDM6/lOUwRkMpkeQRQQlgaiqSVbTvHHqHdbVbUpljIKm90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ptQKlgv/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ptQKlgv/"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 316E860178;
	Fri, 17 Apr 2026 11:39:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776418789;
	bh=3wQwkBO7gN30MIoY+gvXQRgC5GkDuDM//suSpAKMa+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptQKlgv/qvt4QPh5JLUQQen05w37z5YWFkAls7BdVEyG8tsoWb45lVEh8glqsOoBc
	 qWBnvLDjBdypIl7don2nmMDenfYFIUbv19s27x9SfyLhAAI8kJo0q1+324FhdzqF+J
	 eigeNaplABR3UwKI386k2HswsD2SB9Hhet4BXStAJ9p7yYxUvaPxUtAJdg2UUx+L7I
	 CP+RBK5IKcVCzF6+LtwvbwjfnVF+JYfFfECIrbojcRqW5vDKAu2piW4kE0BwmIGvGn
	 Xa4y9hQuFS8QNUetJaD7q35HWBrO+GJQvMfWjC1QvbysUsRgDcBZPDXhg+3cSJ5IoD
	 qMlePxDXoYYWg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH nf,v6 2/4] rculist: add list_splice_rcu() for private lists
Date: Fri, 17 Apr 2026 11:39:40 +0200
Message-ID: <20260417093942.373885-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417093942.373885-1-pablo@netfilter.org>
References: <20260417093942.373885-1-pablo@netfilter.org>
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
v6: - just a rebase on top of net-next, net is still behind.

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

