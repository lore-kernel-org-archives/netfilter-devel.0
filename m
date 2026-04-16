Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E871226B2CE;
	Thu, 16 Apr 2026 01:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776303087; cv=none; b=mNmdGs32BoYm40sUAoHzOnpmPygwp1B5V1LJ1csD7fzKnZABV/ynFEryTVj5Q1+XKn1FdEGB/Np5U4vGn2BDSY1QZ9b9AUz0qCPnH87tQbHuNaaIR/EOumMa1skWMiL3f7ny8VpRgyni/MwR7/QsjRRaoF4VAJNhtyHVvtvXhZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776303087; c=relaxed/simple;
	bh=n82jOt6UEQC7+N0W8gYIzx30WEx1rR+0cYIp6zIdwf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFOHrp/05Sgb9q3UijApTGLXaL3gR3TQ/t+Nz6tLittl6fchVqPL1wUH+6Fj2SqqtdWhRibsKb36KHKHStKwPyIhuh8cXDqBaXnpRNwo0kQR/Sf91TDW7ZCYcgjcMsywW0zXQ9QSuhZIHWB8ope6R144O1q2bAEZ05sjjUFe6AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VvpAxH/f; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VvpAxH/f"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B85EA6017E;
	Thu, 16 Apr 2026 03:31:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776303084;
	bh=o8VaDYQ2e6Gez2TNQ38DdiCZe12qY8iiXBtviqCYhfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvpAxH/f5VO88hsLsKMhxVylzpxFNG4EgBo1X6GMgeiICHiB3XVvh5zuBlDkVQpt/
	 R2pkX7MjEdrNbKlLO6LL6/1C0mGbG9op8otvsQVeL3FGji4VgUdxEGo/gjFmvEXm5O
	 L42x9SFlcmMlBFScdPYXQ4JLGrbUL1DTp98Dm4QZ5dGj232Qim8kthY2fZj0eXKbMO
	 WTx3J1MoGlfhKMWXhtsZDTj1GS3XskqfektLRNxDgY+2m4s3FtSIg1GpSGZFyVCZIP
	 3YQiBJIs+ckwWR+CkblQYJcoO3hJWgUMmn6r9J5RjFm/N5bNJ4dGJ/MjkwahOg3Z5y
	 A6HXrYxmNOomw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 12/14] rculist: add list_splice_rcu() for private lists
Date: Thu, 16 Apr 2026 03:30:59 +0200
Message-ID: <20260416013101.221555-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416013101.221555-1-pablo@netfilter.org>
References: <20260416013101.221555-1-pablo@netfilter.org>
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

