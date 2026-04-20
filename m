Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B852C08AD
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 18:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776711162; cv=none; b=eQCpNJKfLpe60PXvDb0zIYfB5+Dv10BbOUkPicDRDCe4e1Thosbi6zrvo6HKsrbbqikJeBJ6yhAoTMdyQ9iVqyy/bqVJO+hz20LY7kxGvtUU0QwfcZ6tLGA32+l+vzRmM9lUz+FfqI0WvuZrie08e+prIY3uaCYKmpLtJPTJJ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776711162; c=relaxed/simple;
	bh=xMWajWvtx4pph1B+rXoA44YyBc4fHloYB20vHswfqRs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQP7HTGJpOC8dyDaAltcJEtb0nrUvmWC/rELu0MFRD94Mhh7FUa0MjeClsiphub/NjCnq5rP2+N5GcjE4n2v4zbNQYRuFWO3+cO58u53wXCbmpf9q2hXRFRQxvve0Ayjoqg0vFpoSpq97I9xP7RY2TpWBkGAInbtp6+zqA24zB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OqaXtTmz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OqaXtTmz"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2E43760255
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 20:52:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776711159;
	bh=xLhCkbIbJ5aGnOIEyCboOYoC8gSobMN0qdBr0wx/zoQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OqaXtTmzxf5maM+Usr5nukSdB3wc6O4BNuNnaA1J/ss3LrM26lZ1FCMriW6bjv59T
	 bAUdun99J4y6Rdp0+amXvJmroscw6LNUdXvo1nUXbF5h6eQ3sWvOtXr1rsEkDSY2xi
	 IXHteztdp+A6BJtMFFJKL9cqBg0CmjY4Lt6o1ABZ/P0r+z2cUhZOZmVtxxdNiURMv1
	 kgf+4RuweoHq+cqP2eYdoGdBRfQaTQ6FRPK4VLK2COspnf7TVGS6Tyi0D3EaJyixfY
	 Qnegrf7iIEbN4mHfwo++MiT9UgvZ3hCL3XjCPXX4hNFxZdArTmnYoQDenjs4hnvpxz
	 eUlh1KBE0UEtQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v8 2/4] rculist: add list_splice_rcu() for private lists
Date: Mon, 20 Apr 2026 20:52:32 +0200
Message-ID: <20260420185234.23488-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420185234.23488-1-pablo@netfilter.org>
References: <20260420185234.23488-1-pablo@netfilter.org>
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
v8: no changes

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

