Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4273469E6
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 11:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774007295; cv=none; b=NZkwFGq+9TMLViegaQxKqOa+x60XWKA982avhlVHpqB8SDF29iEmusvmHvK3fQmXQ58tJqIaRM+XANx9PPTDmiwJXBUFOfTgzRGoUwPslPNNPHRQ8twwQ9BArOLx7Nzr7hGNLWNqDd62dRq7M/q2S6V17RpYmFeME3XUdLWFkYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774007295; c=relaxed/simple;
	bh=gFOJbOLdErng6m8aifMum8J1FXghQiwC4LvIAGXBTEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NVmLmJZSwXujnId0abeSdlpjiR9ehwpUEfFY0V6wzRGegmCdcWDaqt9VK598/wkBIn4TE57XmBcfS20g9wsGeICrDAb/fBr8ai0YGs2Py9+OgOPjW3oSEjNxz6Z7kUVsNrUUhE2RWIOK5vTH8cVKxgaaILATN2iMTo5XUy4Hj3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=elwtd94W; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="elwtd94W"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4fcgcC4933z7s85Q;
	Fri, 20 Mar 2026 12:40:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1774006841; x=1775821242; bh=rk/JnZa5uN
	E4aHsyNPMIAfg/pJB0fS/Kb1zCnyBMuwM=; b=elwtd94WJ/lT9/DliuxjYHlQUu
	6+IW8RN6cI5xI1LgeVh/5K4kP81Kh4oqCB4d7FxY/3Yjq2P+POLlcV19UXP8oDX2
	xE7NXANC06g1dK8gUEAh62I0R9rVrT1dDw11sZxC8jZG4phtgU+O7GpACtLrzkia
	AIpX8xybXBI6zN3lk=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id hsF2T97Y8pUa; Fri, 20 Mar 2026 12:40:41 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4fcgc94r4dz7s85N;
	Fri, 20 Mar 2026 12:40:41 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 901C7340D75; Fri, 20 Mar 2026 12:40:41 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/1] netfilter: ipset: Fix data race between add and list header in all hash types
Date: Fri, 20 Mar 2026 12:40:41 +0100
Message-Id: <20260320114041.3486273-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260320114041.3486273-1-kadlec@netfilter.org>
References: <20260320114041.3486273-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The "ipset list -terse" command is actually a dump operation which
may run parallel with "ipset add" commands, which can trigger an
internal resizing of the hash type of sets just being dumped. However,
dumping just the header part of the set was not protected against
underlying resizing. Fix it by protecting the header dumping part
as well.

Reported-by: syzbot+786c889f046e8b003ca6@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index a2fe711cb5e3..2cc04da95afd 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1648,13 +1648,13 @@ ip_set_dump_do(struct sk_buff *skb, struct netlin=
k_callback *cb)
 			if (cb->args[IPSET_CB_PROTO] > IPSET_PROTOCOL_MIN &&
 			    nla_put_net16(skb, IPSET_ATTR_INDEX, htons(index)))
 				goto nla_put_failure;
+			if (set->variant->uref)
+				set->variant->uref(set, cb, true);
 			ret =3D set->variant->head(set, skb);
 			if (ret < 0)
 				goto release_refcount;
 			if (dump_flags & IPSET_FLAG_LIST_HEADER)
 				goto next_set;
-			if (set->variant->uref)
-				set->variant->uref(set, cb, true);
 			fallthrough;
 		default:
 			ret =3D set->variant->list(set, skb, cb);
--=20
2.39.5

