Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0842E3624A6
	for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2026 05:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777957963; cv=none; b=G7eAi9wCBbm78uN0AtVZnJt8lITzedZ3tvYcy1Vby0m1NgvgqYQuH41gNWvrNW3h4ALqDDTJOyZvbZsm6enmKoSillaPMN1vU4XEj8WSzr5D0ATacG3pbHwz4vUGlfj1gBy27xZ31IBcyOKBjDTx8dT9PaL9k0qYYMajfYlkE5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777957963; c=relaxed/simple;
	bh=iUgeGSsqv7MOSHVQK8yrYNQjBQhy4lMDkURuG/cYfgk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i9NDGXuh8BpgndI/J/dzxdksY1WDLlau4FvpJICbdFZTEiPO3WOsgF3hPgVl1hcWMfvgnsHc0RoLm4y4DGYPZDnIi6VXo0uKaYLsKZDm7ArvDUpeYa08iSLna5+U2zUHFMrJzMIzkNIY/1CCtvuwo6W+O+W8a/sya/mXQWErvA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ATGH2O+s; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ATGH2O+s"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3650a628473so2915641a91.3
        for <netfilter-devel@vger.kernel.org>; Mon, 04 May 2026 22:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777957961; x=1778562761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NrhTMqHn+rMdQZeR0f4MqPn+xrSow9rW/RMkyGQyv4Q=;
        b=ATGH2O+swMAsO4QhgOqgtXsjMBSGxUHlO6WqLXQvHOu+dMrJB6f5zYw/2oSa1TMQ4k
         Y65WnbOUjJRzFXz7zNn9y6MQ+f3kTUd0zOviw4JeY5aCaF41HSui9ClbWkgfqTnPuhjG
         UGsZfibRcsh/qCoMj2sC7z4dvTRHbV1BbCJ6oXmNivv78JK+nWBD2jxEPa5daL2aROg3
         tkhF0qCSJOwpZmhS/mqHJEo+aFswaKF1D6f5eSfANPgK6iqy4ZDEYh9WUAYd/INwzQds
         5qxLSg+PUYHgzmKbrmU0qGYyqrZFB+/VvyLnbnxhhLEAUkK4XYz0+RTQup+qWhYN2rCU
         z61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777957961; x=1778562761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NrhTMqHn+rMdQZeR0f4MqPn+xrSow9rW/RMkyGQyv4Q=;
        b=Db2WibUyoM5Y424X4MGRgGXto6QNNmZ2u9hR8Wzphvf+W+wqq8+hfE1FelGttDoOMR
         HyIvvI6x7XOHfBEfS+VRzGzhcy/yY/FL1K2p2ZsgvcoHDGiR7DaBQ2Ui/sZbYtT3HoXu
         4gW7zUQACRj4kbZjUcvxX8xyuY9EoVCyXr0NxQoaQtbhY4a2WNL3y0Odw//AzVlGuWXT
         mI4SK4Wf1H7DMotC1gVCCDK6FKBw1QgJTlxGvOv1eLJgvOysV1+xPkpH4fNB9CKYRHuC
         v7j/H6Psr4rELd8i113z6Y3Zo1flqqTD3EzBxbPGMtCOJIpa9uZHT5GJRm6cTm1DIbaG
         cW9A==
X-Gm-Message-State: AOJu0YxOHsBdGEFwC9AwWkEdOvrHBKmDdwzanqqTT1nqYdRq/NRTtCW3
	Hx+ErVGYbOcwf/vcpZxnZI9IFl0xZCys6+C1npTeMPo/Nes8cA35SAZ1mhQM+Ouv4BQVfw==
X-Gm-Gg: AeBDieu4aimYvBMevPDUg18q/nJCKdn4pIXPcll97NR88P4ZfuArz33cDgntF+xyRrP
	C6oVNNagovtL+bDp097CqzPb3UxwRuBz5gIegHNfN0Rj1Cj00Ebuy2eh8RYapoZRFueq/KyvlwG
	5UEuUyj7kQ/zsqsURiiLpXGOdNY0YgRyMHrpoVs/so0QCUmp/Lczd1QwlIF7kAH1kBBykNmUNyq
	hiOqDRRurP3vfS6gXTQ/imsvfExxnma9c6+IgMpeaZyLnps9qTd7LK1hpCrhu81bChhLIsxGQO0
	PFE07RWZmxf1UciV5mRYAg6za4W533/lgYSk6jA2U6so/vSeOzHdhFdvagViwQfyqn63gvYayST
	SE4JP9WA4Svjah+sEhbbal+2Utap6wYezhr9blFAp0zpH0nRHvGsJnEDppkp5Vn37GUD6nc3Z7p
	GXfWaO+SYPqvGYcre5CzrbvVRkMloMadcyeWycbVxaU/XJQR1TKqByyMOHU6AOxN2RVesaciAJ6
	OVN5jNllLVO0txGDzjtyoalLT4vKorfhGewQXyYzeVhX1eC1eSpmj8XyiihtENsCRl7wM1IbIU=
X-Received: by 2002:a17:902:f651:b0:2b0:6e12:bb21 with SMTP id d9443c01a7336-2b9f2846196mr116836475ad.41.1777957960980;
        Mon, 04 May 2026 22:12:40 -0700 (PDT)
Received: from alchemy-Precision-3630-Tower.tail7db246.ts.net ([156.146.97.67])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae0e5fasm120896855ad.54.2026.05.04.22.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 22:12:40 -0700 (PDT)
From: Pratham Gupta <pratham36gupta@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Pratham Gupta <pratham36gupta@gmail.com>
Subject: [PATCH net] netfilter: ctnetlink: use nf_ct_exp_net() in expectation dump
Date: Mon,  4 May 2026 22:11:57 -0700
Message-ID: <20260505051157.3895177-1-pratham36gupta@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
introduced exp->net so RCU-only expectation paths no longer need to
dereference exp->master for netns lookups.

Commit 3db5647984de ("netfilter: nf_conntrack_expect: skip expectations in other netns via proc")
updated the proc path accordingly, but ctnetlink_exp_dump_table() still
compares against nf_ct_net(exp->master).

Use nf_ct_exp_net(exp) here as well so the netlink dump path matches
the rest of the March 2026 expectation netns/RCU cleanup.

Fixes: 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
Cc: stable@vger.kernel.org
Signed-off-by: Pratham Gupta <pratham36gupta@gmail.com>
---
Tested expectation create/dump/delete on the host and in fresh Ubuntu 24.04
Docker userspace. Concurrent namespace churn/dump testing did not reproduce
a cross-netns leak.
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index eda5fe4a75c8..8ae3f6acc2d2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3158,7 +3158,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
 
-			if (!net_eq(nf_ct_net(exp->master), net))
+			if (!net_eq(nf_ct_exp_net(exp), net))
 				continue;
 
 			if (cb->args[1]) {
-- 
2.43.0

