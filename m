Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08C82C2346
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777389566; cv=none; b=K9SG7wLGiZOgbrFgQhkGtalbFK2F2X3acN3kDtH8EPlklct3lQtVIbdTp9DoA47k4oAfNPT8Qo/AHK7N2/eBPG7pFK36MhsD4knxSyrbcZvBysDsoO8+HaYeswMuJB0GmuLTrrcf9VwgPTzYFfwKVYvcIj0zk9Ed+xTWHvUEFvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777389566; c=relaxed/simple;
	bh=mNnEGDKVPa/tXsXcX0H17eaYDz01/ffGTAlCs+dAPHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fu2+/UExpBxAFauB6InB9ZyJwEAYcwqDJ7ROoTlCRpLRApl+OpSwOkrc1b+LnqX/ayCh/63sXxUsrIRSGqaO6XVT91dioIFN51/Fla6r/rFS76KigYatE2WZLBoKgU7c7ED6QSLucsCsSqMyXX25uDTw2LsV0PJjyts25N5VU2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=r2StriYg; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="r2StriYg"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4g4kcM3vSszGFDLt;
	Tue, 28 Apr 2026 17:19:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1777389553; x=1779203954; bh=rpAy0PBNWF
	XakzSAqAXjUE3jW1yNzRB9e/geUFBWnoc=; b=r2StriYg3raYkKvHd0gKVJ3J0G
	TutJZOw3GJYHei9kwievGY0h8lYa6M/XC7S6EEZppExHoVC6Uk0valYuie0V18/i
	e3Pn8FiuMaN6CHc/De+cN7+sacegkSGIu51TmO6C1XVJ/Dq5S4YcLvbdyKPkJkQ2
	akCZtYbrLZuySJPkA=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id JKC-TAcjYkz5; Tue, 28 Apr 2026 17:19:13 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4g4kcK4dNKzGFDMb;
	Tue, 28 Apr 2026 17:19:13 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 785B6140503; Tue, 28 Apr 2026 17:19:13 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/5] netfilter: ipset: Fix data race between add and list header in all hash types
Date: Tue, 28 Apr 2026 17:19:09 +0200
Message-Id: <20260428151913.584739-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260428151913.584739-1-kadlec@netfilter.org>
References: <20260428151913.584739-1-kadlec@netfilter.org>
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

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index c5a26236a0bb..56830e33e193 100644
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

