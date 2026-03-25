Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A282D371D00;
	Wed, 25 Mar 2026 22:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477597; cv=none; b=mRzevoD7DHMAaUBKdXk05aj9e+p5ZY06GEsz2cHVfRZgICR/BSUdEaArJxf3/4p+cQlTRoAB3QGWOKHG5bl/rDTITgfTPntazaQoObd/Nz4+pmAty+LAvfZO3Fl6s2ThcgeVb+O8TLjNaFgczFeLkcPSYzMpngdexTxg+zZEVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477597; c=relaxed/simple;
	bh=tRCDBqR8kulnXcor79UnQ8qcoPxMqt+O0QToS0lqZl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giyqP/kocdNQTKByydHmo9vQxwQ+BQYLqaT1EjfcnI5p1WorF05tfUNIkMaRi70IDbYSdJu9RodHFB9m8oZ9sBx9EkxDpBXK8kKzPi0475iJPtDiu2AMzcXc02NpjwRvJe2PpGv0YZXl6OGJRx4B9DIUGU1+hjir7/pQiBTyWt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kUwsExoM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kUwsExoM"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8BAF76017E;
	Wed, 25 Mar 2026 23:26:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774477588;
	bh=kqSFS4W2XLOpKODUS+rPoXpc6ma0/YnHybOK2e4Uvgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUwsExoMmtMg7X4NfY4yKGMhDSgwVHRrrmTsb8LGaUqbkzP7pUIoy4nSS6ezw+yo+
	 Fl9OwBGPVbSY/v6TQSTbDmoNIbbtRKLTljlNv7z4ttXhK3oMJ7ujtabIK/mWLZpgjW
	 y4broPmqbrncIDGamJ+CVz4Y13Fz+pysTCDxqTiPfQ2vGKptW8ZTpS7RkKUzE6WYPe
	 BbfT+Syr9+NwVUDDNsCyXxpmi8xRYU5KWjzIWgKAOc85+7fPVUQieH1FMT6b2ezWFG
	 8if7HFA2YNvYXEkstd4ysaBKgwwMyKBolKeivljNUi8KuEVf2kJgG9Q6ygNwEwAkPv
	 0fQwwmE5Pvixw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 03/14] netfilter: ipset: Fix data race between add and list header in all hash types
Date: Wed, 25 Mar 2026 23:26:04 +0100
Message-ID: <20260325222615.637793-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325222615.637793-1-pablo@netfilter.org>
References: <20260325222615.637793-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

The "ipset list -terse" command is actually a dump operation which
may run parallel with "ipset add" commands, which can trigger an
internal resizing of the hash type of sets just being dumped. However,
dumping just the header part of the set was not protected against
underlying resizing. Fix it by protecting the header dumping part
as well.

Reported-by: syzbot+786c889f046e8b003ca6@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index a2fe711cb5e3..2cc04da95afd 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1648,13 +1648,13 @@ ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
 			if (cb->args[IPSET_CB_PROTO] > IPSET_PROTOCOL_MIN &&
 			    nla_put_net16(skb, IPSET_ATTR_INDEX, htons(index)))
 				goto nla_put_failure;
+			if (set->variant->uref)
+				set->variant->uref(set, cb, true);
 			ret = set->variant->head(set, skb);
 			if (ret < 0)
 				goto release_refcount;
 			if (dump_flags & IPSET_FLAG_LIST_HEADER)
 				goto next_set;
-			if (set->variant->uref)
-				set->variant->uref(set, cb, true);
 			fallthrough;
 		default:
 			ret = set->variant->list(set, skb, cb);
-- 
2.47.3

