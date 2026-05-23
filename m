Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB040343899
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 13:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779542126; cv=none; b=rEPg9maRGeTczYffBP87Y91fQ6/PiXEsBzCqH8+C2m8QbOmdTNVKKAS7sWHEwsifI/VxEiX9dm9ggArlqgG/uRdb1YxCenoHSN7Xq3wsiq2vPnzXMgP3+9QlrfYdGjn2TPS2X+7XjYjENcmRHfYWNJ8fKkcTaYpMytgVwB4rfF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779542126; c=relaxed/simple;
	bh=+6BRIaNtvk5rAKXpix7QthaF+1jRDMPHqYJCsvUAxL4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=moOv6jTV6ZOtU5YF5UUAySkD0ZL45COQZS1X7llmjQa3HhI7w+CZ2wu1OC0LH0PAOPUZFsdE9dnyMXzYZ+5I3yJvckXYrd1e6sa/YfwTbxKJaW4g4OSoTQVrmFGz8dQCZysVFX13xHGRqYD8qxfMlsHk5W1loNuHjzDS9Mx9Ly0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=WO8cIuSn; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="WO8cIuSn"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gN2gv1H6qz7s86D;
	Sat, 23 May 2026 15:15:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1779542121; x=1781356522; bh=djO71CRZBk
	+p+L+kr8DM1adBQijJI2N1oXOlYF6D9tA=; b=WO8cIuSnlW58j36Lm6nvmql4Zp
	KiXYsF+9mMQWdXmqvzDzBGu4/bNtLVPle4aye4iSj81H7Q86vkWhhxy88/Vad0oz
	t3kF/rQNZCa+dpnVZ6v52t+nX7YZPT4S6jyHZeNVhmXP1dnJ3k97sxEV3lVbD8kW
	wiQsJR/Tlq9lTCooI=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id Gu_XOd45nGsQ; Sat, 23 May 2026 15:15:21 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (85-66-106-71.pool.digikabel.hu [85.66.106.71])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4gN2gq33N9z7s86P;
	Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 453A5141163; Sat, 23 May 2026 15:15:19 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/6] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
Date: Sat, 23 May 2026 15:15:16 +0200
Message-Id: <20260523131519.99953-4-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260523131519.99953-1-kadlec@netfilter.org>
References: <20260523131519.99953-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: ham 0%
Content-Transfer-Encoding: quoted-printable

Sashiko pointed out that kfree_rcu() was called before
rcu_assign_pointer() in handling the comment extension.
Fix the order so that rcu_assign_pointer() called first.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 3706b4a85a0f..a531b654b8d9 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -351,8 +351,8 @@ ip_set_init_comment(struct ip_set *set, struct ip_set=
_comment *comment,
=20
 	if (unlikely(c)) {
 		set->ext_size -=3D sizeof(*c) + strlen(c->str) + 1;
-		kfree_rcu(c, rcu);
 		rcu_assign_pointer(comment->c, NULL);
+		kfree_rcu(c, rcu);
 	}
 	if (!len)
 		return;
@@ -393,8 +393,8 @@ ip_set_comment_free(struct ip_set *set, void *ptr)
 	if (unlikely(!c))
 		return;
 	set->ext_size -=3D sizeof(*c) + strlen(c->str) + 1;
-	kfree_rcu(c, rcu);
 	rcu_assign_pointer(comment->c, NULL);
+	kfree_rcu(c, rcu);
 }
=20
 typedef void (*destroyer)(struct ip_set *, void *);
--=20
2.39.5

