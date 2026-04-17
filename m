Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4823822B1;
	Fri, 17 Apr 2026 09:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776417493; cv=none; b=Ltb2rp27ap4JM1naIZlCABIa28IGnpv5IxsZSBb/W4g8qmQGqdbDh57/TCcC1ZE6+x+w9kQoloc3HgWdt0yM5jSq8d0okbIDBPgJXqO8c9VZcDYQI+l6LFcvxyhq7r2u6H3+DCZlv9TzSxa4ggloZFWHOPhj9B3Lci3owiFI4PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776417493; c=relaxed/simple;
	bh=Be4QM8M4GIRdb+GnA7dhdp6cy7LBvw8G9JsG+y+BXys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pVlcFnR8X7fIxW7VQfXRGhBZcPdamha+nF30m2DUaanavEuFo9mDsC32e6uepSl559wWqA54DfJsqwjXwAZFakHKFoC4sgoA0Koayo0SqxrV7F/n8LMY2+mTBV/ZNdGtsAXOId09zHqxm7CfZl59UG7KGdD/Oi/Q0iVrfUrsPFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PZuJJ7+Z; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PZuJJ7+Z"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9698260292;
	Fri, 17 Apr 2026 11:18:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776417489;
	bh=7zl85BkB8pp5TRkk9evhYJSyDH2iAtcOJbeqVTRphQA=;
	h=From:To:Cc:Subject:Date:From;
	b=PZuJJ7+ZwxN6QHkXJCxwktZgK7KAt3UjYNgLUvVjEx6kE3iX9VFipJvIynRlkkanu
	 u1K/hlAVeHawT/gM3eNitABr4jdx3MV9YKtW86cKUt3uh9WZMFBkIeSkqQXID8rW3i
	 vaAGdSiAcXx9ds0xQyeQYQo0ckl67XbA7TlbO9n1E1wQRHyW6FhC5BH2+1+dRb/wpw
	 ChEexkW2zwfs7O89pldA2SiykCqwGMYjAF5FLyHeE3ds1OJiF/t59GInSc/BZwfDPB
	 u8uTqdVgk84AlnTCib2atprGpAoNkeM/sApnj4pseGhZySNPL4hRG/EO3gAoO1gzou
	 0GupewYacgk8A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH nf,v5 1/3] rculist: add list_splice_rcu() for private lists
Date: Fri, 17 Apr 2026 11:18:04 +0200
Message-ID: <20260417091806.342830-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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
v5: no changes, just including the full series to address AI report.

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

