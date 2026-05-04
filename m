Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991E73A5E70
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 11:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777893802; cv=none; b=WdL4Cg7LBVVDIodfqGqz//IYDtSuMeOBIpFwL5raS8LHGUD/+YZmVaTxptQNjJLdNCZZzoYyJ2ahFX6c7jn+kuRiJKmsKMyD3oKo3JEADxT/KDTLmpvJqHqCJ30NKz23Z/2BfGkXc23Olwz8Pnl0O+crlkxIZSOCCzyogYbQyhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777893802; c=relaxed/simple;
	bh=4S7VamUGXJkMeQB2ofubAms9FfbofD8iRmCfIuvPhTw=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=GWDfyGBWgGa0RuTnptxss6ITdGJpQCFU/u8dCBFuorHr3atjVQcgUq53lBjhCWZx1n6hNzK47LWZ8plQhgMFOBUUtGToUVfmiPAoJvQxEQXJ6K2IlQhhoRGTGNMJlsxvZY3tWnctqWBxEIqOIkzYnM3DzKsdlqG29fs5YxugpKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=aBHvBr4d; arc=none smtp.client-ip=185.70.43.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="aBHvBr4d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1777893798; x=1778152998;
	bh=4S7VamUGXJkMeQB2ofubAms9FfbofD8iRmCfIuvPhTw=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=aBHvBr4dVsqy7yHfiXycGHb6q4UNFr7s+mOyisMQD03NxNih9cJ3qc5awjA35ih0b
	 2CfMu45bEnpZfVyuvcbBjlvdf5LXb/t7/RJQy2M3Zrag5uCiMYTPwmuZA7BedPpUUO
	 M3VaEXgT4gYS8YXG075NlqSOk0ohCgZeyp6aYEz5DOrPcpQKV+uxsjIeqPa/+d+RAx
	 wFSrlUpbr0b8YjfmQPVvm6t4l0RXhSbI2trGmpCxL1gfIJqqIYhCCl2AfeUAh3QhWi
	 dR2YrSqW1FKtM6c14qYZMevJOt2EHq7cZfL7T1fMoXHC4bOz2Hm5NfULKz1dPS+IFb
	 6PBCEK/IhlwIA==
Date: Mon, 04 May 2026 11:23:14 +0000
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
From: =?utf-8?Q?=C3=80lex_Fern=C3=A1ndez?= <tomaquet18@protonmail.com>
Cc: =?utf-8?Q?=C3=80lex_Fern=C3=A1ndez?= <tomaquet18@protonmail.com>
Subject: [PATCH v4] netfilter: conntrack: fix integer overflow in expectation timeout
Message-ID: <20260504112300.715192-1-tomaquet18@protonmail.com>
Feedback-ID: 64308806:user:proton
X-Pm-Message-ID: 2d7f08c6467d8601e415e0fb3ef5a17b019017ab
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

In ctnetlink_change_expect(), the expectation timeout is calculated by
multiplying the user-provided timeout value by HZ. Because ntohl()
returns a 32-bit unsigned integer, this multiplication is performed in
32-bit arithmetic before being promoted to the 64-bit jiffies format.

If a user provides a large enough timeout (e.g., 42949673 on a system
with HZ=3D100), the multiplication wraps around the 32-bit limit,
resulting in a near-zero jiffies value. This causes the expectation
to be immediately collected by the garbage collector instead of staying
open for the requested duration.

This patch casts the result of ntohl() to u64 prior to multiplication,
matching the safe pattern already used for standard conntrack timeouts.

Signed-off-by: =C3=80lex Fern=C3=A1ndez <tomaquet18@protonmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntr=
ack_netlink.c
index eda5fe4a7..be89bf1ba 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3466,7 +3466,7 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x=
,
 =09=09=09return -ETIME;
=20
 =09=09x->timeout.expires =3D jiffies +
-=09=09=09ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
+=09=09=09(u64)ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
 =09=09add_timer(&x->timeout);
 =09}
 =09return 0;
--=20
2.43.0


