Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68411191481
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2024 09:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718616227; cv=none; b=bM/4fkMfBCfJxS8T2uEMJN7Z6kvfM7ke0RKS/43s1BYYcsiaj0F4A+D5l4bhotTkHLD0CbdmnR2SmK9WrgZ73PLHQaJ3oQClP0vymLhMrostTtL8Gzc1AIz0jJpiOFt3rqrunOybfQKJQ4B9fhGZLkPXn9PbWJomvH4MM8QytDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718616227; c=relaxed/simple;
	bh=89w5YmXBwnQ625TdU4ufUzXADTtWy3uhbMdjTwmBumU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=khjBKKy7bzGAWwbzYJYER+UdUdOrmGOMGrkYqbr8ie7x4bcT0HfjWewhSGSGXKKHsDtftyEbd1GtwKjosCFv6+/FRgRwb0/uLzCErLwdwZMWLFdn92z34n/3zwfIUHnwbcXUsZpGlZo2F1ARuuycq0g0d6KxCCr98h8MPqBOvKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=QpnpuNN/; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="QpnpuNN/"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id A6FA7CC00FE;
	Mon, 17 Jun 2024 11:18:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1718615895; x=1720430296; bh=YvJTKRzI/u
	53/AaIf9EYrkLCXObZMQd5gm0RBqna4Wc=; b=QpnpuNN/D2FMM9znYD3sIiDT3d
	U4pHlwgZ3sgQseNXBOY6Pd9SjBjwXB7HzAO4ToQzoRB/L6piYhqJgSAdjlZFM6/z
	LGOHXnX5e7wVGVvW3lFwpAQJLXEne9+KIh6FXe90r9JW+YyYV6qHdd+RMgurSuUx
	tESGmuUwlCWEaDm2s=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Mon, 17 Jun 2024 11:18:15 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 586B2CC0111;
	Mon, 17 Jun 2024 11:18:15 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 5336D34316A; Mon, 17 Jun 2024 11:18:15 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/1] netfilter: ipset: Fix suspicious rcu_dereference_protected()
Date: Mon, 17 Jun 2024 11:18:15 +0200
Message-Id: <20240617091815.610343-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240617091815.610343-1-kadlec@netfilter.org>
References: <20240617091815.610343-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

When destroying all sets, we are either in pernet exit phase or
are executing a "destroy all sets command" from userspace. The latter
was taken into account in ip_set_dereference() (nfnetlink mutex is held),
but the former was not. The patch adds the required check to
rcu_dereference_protected() in ip_set_dereference().

Reported-by: syzbot+b62c37cdd58103293a5a@syzkaller.appspotmail.com
Reported-by: syzbot+cfbe1da5fdfc39efc293@syzkaller.appspotmail.com
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202406141556.e0b6f17e-lkp@intel.co=
m
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index c7ae4d9bf3d2..61431690cbd5 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -53,12 +53,13 @@ MODULE_DESCRIPTION("core IP set support");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
=20
 /* When the nfnl mutex or ip_set_ref_lock is held: */
-#define ip_set_dereference(p)		\
-	rcu_dereference_protected(p,	\
+#define ip_set_dereference(inst)	\
+	rcu_dereference_protected((inst)->ip_set_list,	\
 		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET) || \
-		lockdep_is_held(&ip_set_ref_lock))
+		lockdep_is_held(&ip_set_ref_lock) || \
+		(inst)->is_deleted)
 #define ip_set(inst, id)		\
-	ip_set_dereference((inst)->ip_set_list)[id]
+	ip_set_dereference(inst)[id]
 #define ip_set_ref_netlink(inst,id)	\
 	rcu_dereference_raw((inst)->ip_set_list)[id]
 #define ip_set_dereference_nfnl(p)	\
@@ -1133,7 +1134,7 @@ static int ip_set_create(struct sk_buff *skb, const=
 struct nfnl_info *info,
 		if (!list)
 			goto cleanup;
 		/* nfnl mutex is held, both lists are valid */
-		tmp =3D ip_set_dereference(inst->ip_set_list);
+		tmp =3D ip_set_dereference(inst);
 		memcpy(list, tmp, sizeof(struct ip_set *) * inst->ip_set_max);
 		rcu_assign_pointer(inst->ip_set_list, list);
 		/* Make sure all current packets have passed through */
--=20
2.39.2

