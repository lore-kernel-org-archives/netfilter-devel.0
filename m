Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F783DD530
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 07:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780990497; cv=none; b=HItUNWAMWNRJS2C+R3KdFylzzmy2mfWOvPSDyqOc8aHs2FkhIG9lBp0ScZ/2rPbCrlp15x3vYm9FKGsRu3LoRBKlH1vdXyGSkC7GAi/xHqEnIbVNE9rjhJ+FY1to4SA1/Kb2aJBDImruPyitTDQ91ncM3zXB3lIRJfSWfT8oDxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780990497; c=relaxed/simple;
	bh=+6BRIaNtvk5rAKXpix7QthaF+1jRDMPHqYJCsvUAxL4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dEG4Iv7Zwe2JQmV0+WuU1OXX5qdPYNJQcyyIVIhOAooUFi2PzxqwpECiXgjwmP6wNYR+3doTPJG9vMQkVbLtXFkI5FQBf4CBh1zuf+cNSGRYGrs4UaSzeOqs5FUSxKL9ds0y6bpGR7u3lu6rYcTSu416/S06TY49wx6DMdF+l+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=dJt2/yFr; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="dJt2/yFr"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gZL964whkz3sb0f;
	Tue, 09 Jun 2026 09:27:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1780990072; x=1782804473; bh=djO71CRZBk
	+p+L+kr8DM1adBQijJI2N1oXOlYF6D9tA=; b=dJt2/yFrfpB82hZjpHSVXy1DI5
	OWBR8TW0eALwb2s9LP3/wWjJ2BZk49tfkWA7pxdMNE2r0XYh4NwhGS7EWcM/ANL1
	y9GkbQrzCxqV2cbERiyzHjdhRNie7WRzqL0V6AiB/TTw/r1vrMciX7/JWm1XRAxo
	edU6f5jOfHHo3DLyc=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 4QHvALM2HgVS; Tue,  9 Jun 2026 09:27:52 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C0692.nat.pool.telekom.hu [37.76.6.146])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4gZL926LCtz3sb0p;
	Tue, 09 Jun 2026 09:27:50 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 492C6140B39; Tue,  9 Jun 2026 09:27:50 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2 3/9] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
Date: Tue,  9 Jun 2026 09:27:44 +0200
Message-Id: <20260609072750.318774-4-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260609072750.318774-1-kadlec@netfilter.org>
References: <20260609072750.318774-1-kadlec@netfilter.org>
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

