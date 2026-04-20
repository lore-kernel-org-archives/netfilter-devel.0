Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC65221CC5C
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 06:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776665975; cv=none; b=sdwWdxVe01OaIV7znHSnYyYPyNxhhdMUehk+De2JEOKkp+jbb6RwiXmcM4tFOPhYgLaDvq0VBBmw//JaBgCNS5TAwec3ITzOJxDXyOqlj3VBimi2iu0RWMOoDj2YwuInQ4qLPxs4J5JWBLh/OxFzVfRuOnizwWxOH6NSltG0ALE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776665975; c=relaxed/simple;
	bh=n82jOt6UEQC7+N0W8gYIzx30WEx1rR+0cYIp6zIdwf8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYznfw8xZqch1rIpI8//IWWouWdX/vKnGZqIM7tqvn+yqXcxtzu9VRBxm5657p+N+8MO5Qg/Lc+/7gMaWAtKSBLbDjYgsYSl1CD8NxYhsI0qnNWBAgBVGYho2TBmjtx2alYeb8GcjpvHqhvlWTkKD9DoMAfSaecUGmJbg68WmOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iM9D6qsE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iM9D6qsE"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E6432602B1
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 08:19:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776665971;
	bh=o8VaDYQ2e6Gez2TNQ38DdiCZe12qY8iiXBtviqCYhfM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iM9D6qsEPIpudDOc9iUg1fu46wisUCnvhqr1dGeUt16Iqqu/CNm722QbSxjeRf4iE
	 teoAX729GqFHD8u1rsZoq7TrlicNgTvBhus1KYxW8yelobFBInmTbGLsB/zMRUKImq
	 ZrtYqbyYujW+q268g42H5zfALnnOqVjnt8sFUapy4S5nQW7+N88PSz5VpD5ak3tUse
	 Ng4c49R9v5RlkxW5fW/IQmAWo8d7TK+fy5YGvcvms7ps+jqTyGLSX/AsPEFF+pZjpg
	 nYXreWmvx+NNJfoDaUMlFEI7gDhZNuVjuJG1elPUGg6Ht9KdXzBCXnHvxLwJWeFgp7
	 7PAeMHhTIXsmQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 2/4] rculist: add list_splice_rcu() for private lists
Date: Mon, 20 Apr 2026 08:19:22 +0200
Message-ID: <20260420061924.69302-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420061924.69302-1-pablo@netfilter.org>
References: <20260420061924.69302-1-pablo@netfilter.org>
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

