Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C903CF034
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 08:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776241253; cv=none; b=cVr+avY61yYEbsNj8lir10ycEyEp7atyQxWcDU5gAtjKVnXYPjQ8kgk6LzPkoYopm5RjpP70/gP45r/JIK00EvZxthjIhxgdGV2GkIxsdQQN99kIEaYgfbCGju5J+3cp0zOepSXsy69y9pF4RzMEBXvNP4a9zqvtNuP5Bnb8MFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776241253; c=relaxed/simple;
	bh=mhivghAY4iqzWA8QMbRoxlpLf9wlOsy2eI7mzmhbFMM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D1+t4BTsG7DTp95BBG4d+F5TMOnbeYcYcgx8WyAhq1GGfwUcLuRVOysdkJkD2faM66rjKlSqh+gtaDHcfm1PPLgoyL8f3TzCmEM1LYb2zwbpC6KqT4SRWXCJ48q4KOajL67bWgimnWw0u1W0UjDOI2t1CY7HZvh946aHRgqs+/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=A1vJcHWA; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="A1vJcHWA"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4fwYxP6cQtz7s85N;
	Wed, 15 Apr 2026 10:20:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1776241240; x=1778055641; bh=UPYFQnNHUB
	vCFSBcJlCDrBtq0YeZvIr5oN6GY29vYpg=; b=A1vJcHWA9W94tyqQ76NK5gClCh
	zhV2VdOMLoJO1f42G/k4HyXGRTB7rzlDlSSuT5kjBMTiFXQbEoKNjyjgXIthCFbQ
	kbJ/ewgde4TS7+Eq3RfZGM/yb55XPrG0hWeTrWSf7mrlm9aw8/RvY/jx4+aCKerW
	EwSzH743qRvOuRlLM=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id TYnsdlxcN5gb; Wed, 15 Apr 2026 10:20:40 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4fwYxM5RJwz7s85G;
	Wed, 15 Apr 2026 10:20:39 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id AD11934316B; Wed, 15 Apr 2026 10:20:39 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] netfilter: ipset: Fix data race between add and list header in all hash types
Date: Wed, 15 Apr 2026 10:20:38 +0200
Message-Id: <20260415082039.4133308-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260415082039.4133308-1-kadlec@netfilter.org>
References: <20260415082039.4133308-1-kadlec@netfilter.org>
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
index d0c9fe59c67d..e6a8b3acc556 100644
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

