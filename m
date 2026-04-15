Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3F6364EB0
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 22:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776292397; cv=none; b=ihH2ePhnfGsH/s9VhW/SjQY3xVZHx0t0DiKnzJ8pBPE3K3RAP7J/ILmwbx88jj3zzm0Ggq+mnhGLFxB/MAernl+1mTNDERHq8p0y7av1xMCTGQKJoiLiJFPhxW7fYbOHrpY/51eIA748j1AKnVWg/76O1fb6yx1lfYGjSKPeZto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776292397; c=relaxed/simple;
	bh=o63cZQCtcJdWzsfwaBnOzSylLO1uUllSuooGy93dwIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SpqIZ5rw3moDqONbaFbTI7Twp4VTk+6VZc22ObMG8vTksuT8npyFnx09ke+gUxTDh6XL8GTvg8ZkSzVLYDMe7VFjNQnGOut/1yKlLOho8OkqfcSH6fVMHnrikYJvsBkQ4ZDm/5f54AKivLtS6lHZJmbxUSaLoxfCB3N+l4DVaTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kf9LaL/r; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kf9LaL/r"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1041F600B9;
	Thu, 16 Apr 2026 00:33:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776292393;
	bh=oocH5WbpYY0EAID3hjac+owoCHI8pb7lHZMAbRtlH04=;
	h=From:To:Cc:Subject:Date:From;
	b=kf9LaL/rsa9LIEJtczO8EuYohmitGNmLEplLqwXZV8Fx2GNvGbnoYLO6r/qbwlKc4
	 02Cm6ULDiJn4mc+Ewp//X21u88zfCkRODj3X+UDJ/K7TVcuOKyQWFUQs9oZ59XaotU
	 ntVDc8sA0vhoeLZf4LTsmH35YBspZLUjhchNLE1veQG6ACJHOAlOuAg7PbFvYBK+p9
	 zjELlJe/YBhM1NX/F3OUqCHAqNnM6la6VlX7KDoe7lVMSOGL36fn4vwUYIISm0jMUc
	 Iu8KRIL9dYOOYsE1A/o3+rD9Hf4y12n+fL9K4VJd2lGV3fLfExU59Veru1EZqbzzMf
	 4+rUoFBKeydLg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v3 1/3] rculist: add list_splice_rcu() for private lists
Date: Thu, 16 Apr 2026 00:33:07 +0200
Message-ID: <20260415223309.95527-1-pablo@netfilter.org>
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
where there is a check to ensure that that the list to splice is not
empty. Note that __list_splice_rcu() has no documentation for this
reason.

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: added Reviewed-by: tag.

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

