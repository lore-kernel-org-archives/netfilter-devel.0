Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6D946EF73;
	Fri, 25 Sep 2026 08:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790324518; cv=none; b=OA3XLul9tEjSS+66W7eSarG4kMlTosiWn1Epjz3vQj2eWBMLuyqyHbJwsUQxcdlXs6BFEXn3lEhm1Cef5M5nkEjc+d+6yqpjelBvkQmBNVYhN3MnBO7xP5Yetlqz12C6PXWuMjvUr/Jc3JRGlrevk52lZl+S08/ZUwwhZ8jkiNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790324518; c=relaxed/simple;
	bh=lYNZTHj4bXk3G76nAjxQmWcB4E5tH2D+9HYzrEAMXRY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fdla/DyaaJFwARKJCytI2U0q7gJjzSV9gu6xMEX4tALvdbmh8tOZtmdwQWsrSy3ZmDjorlf1NUuRGEbbLgNNPOO9g7IFNi/eMdm0Nzla8smymIgDf2+6CBs3qbrsnY4MnQHWYtyrRSYySbmfWV250pf0mZRLQxvWzn9tMguNdWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=IG/VhGDE; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="IG/VhGDE"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id E30B34E41074;
	Fri, 25 Sep 2026 08:21:53 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B6FA66073B;
	Fri, 25 Sep 2026 08:21:53 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8421410328D17;
	Fri, 25 Sep 2026 10:21:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790324512; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=9zlMNo7dhbIKdnwOjjrU+ow8dEzmY8i59iiS5x+t/FM=;
	b=IG/VhGDEF4ZHUvj7BmdLKfkZhcEE6cXYfdl7f8lxwoZUVPsbJe7ye9e61stNBOnJPmHBtF
	U99VFe/cBllpghwdwNrzEDMa4QB7XsnuqidNnx4sZepXzOtboNPUapzzpaz6BSN0nl3DsV
	XCbc7/wOIz4NruAAXZHStp8DYSP+lHJEY5JOSaJ+pc4JfXNvVbR/RvlWwvpD2xxTzzG2Rd
	ynRJ5xPCeQaK75Yrxby6Q1Gku7b73k0TVovD0G9x2xjmfcdOcXdtmBw+kU6XY/4N5S59Lh
	wmHOBw7lvWgKAcPqYINmQxzWkJiOVNbA7KwpVbsosj9ry1ZTMOnVdSabkcEYOw==
From: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Date: Fri, 25 Sep 2026 10:21:42 +0200
Subject: [PATCH 5.15.y 1/2] rculist: add list_splice_rcu() for private
 lists
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-cve-2026-52988-5-15-v1-1-ef05a24139f2@bootlin.com>
References: <20260925-cve-2026-52988-5-15-v1-0-ef05a24139f2@bootlin.com>
In-Reply-To: <20260925-cve-2026-52988-5-15-v1-0-ef05a24139f2@bootlin.com>
To: stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
 Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, 
 Joel Fernandes <joel@joelfernandes.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: thomas.petazzoni@bootlin.com, rcu@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, netdev@vger.kernel.org, 
 "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
X-Mailer: b4 0.15.2
X-Last-TLS-Session-Version: TLSv1.3

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f902877b635551513729bdf9a8d1422c4aab7741 ]

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
index d29740be4833..ad37c0584c23 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -204,6 +204,35 @@ static inline void list_replace_rcu(struct list_head *old,
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
2.55.0

