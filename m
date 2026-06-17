Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0893E0C66
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 08:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781686162; cv=none; b=Xo+/bQLh/9KkQCU7e8AEz87tGsc5st5Ih7laQwBgAd1HAIcchX3WK+4Cz6Ul5jEE78ya39tgOpiMSgKFTAQT2qbWuogZAa5pauwK4u6+8nLoHKhiuntYepXkaeJ7e6KaCvQqG0GpZdDYALnzdKmVKfcusZjU8ODWWsv3udh5Hhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781686162; c=relaxed/simple;
	bh=+6BRIaNtvk5rAKXpix7QthaF+1jRDMPHqYJCsvUAxL4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U8ZLkwdly98qImIwec9kNu8ryoeImkTjs2UfJWzlq/Auj8V4jQ9MKYfVR660KBLcKT/3eiK1AfSlnjVV45/aGY7+uH5812LIXa9YMV8G3QFHgtQxxh1IWrk6PeZTR6dXDfSpl3i5vxjpzUveB12JJCZAe9ypqWxONWaRdFUZkVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=jQ9tZt9Y; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="jQ9tZt9Y"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4ggHQN59Jyz3sb0W;
	Wed, 17 Jun 2026 10:41:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1781685690; x=1783500091; bh=djO71CRZBk
	+p+L+kr8DM1adBQijJI2N1oXOlYF6D9tA=; b=jQ9tZt9YGOIxQ1nWAuj7SduKFG
	GLVuECuu17ZIOsDuK4B3Ple/g0JwsINHDs+EGQoXfBVvUWfU711rohEA1IaL5cBT
	Ol2n48iCT1N9UexUrnOgBJOVhwxvUmryKJ9fvpR3upI9qO6pbDNYRncqZcaLQcnx
	qaxIrgyzqkGVFrOo8=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 5rpYSsWAiI-S; Wed, 17 Jun 2026 10:41:30 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4ggHQJ6wkKz3sb0g;
	Wed, 17 Jun 2026 10:41:28 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id AA7111406DB; Wed, 17 Jun 2026 10:41:28 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v3 3/7] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
Date: Wed, 17 Jun 2026 10:41:24 +0200
Message-Id: <20260617084128.6603-4-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260617084128.6603-1-kadlec@netfilter.org>
References: <20260617084128.6603-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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

