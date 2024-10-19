Received: from forward204a.mail.yandex.net (forward204a.mail.yandex.net [178.154.239.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093862772A;
	Sat, 19 Oct 2024 18:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729361960; cv=none; b=THCOuHvbe+WUQERdcdADNnqcOAAfaPbehPeGqmlovUTvr/DeNDIKSpUaklIA1tfL26bZejNCdYWAgWZ+GAjsrT3d8PCYKx+cW/FAc5246lO7zj97H26yBIDrRDlW4/LiDozL0mT5vZj8XaQUA9fsbK6NB0Cg0uNiQe3QpUZ8JuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729361960; c=relaxed/simple;
	bh=ba0PMHBh4hhco6hEKIyZrHz4w5DvWH+aoE7VQQbkzKg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Vb51JJwCxNmg8NSTKTTxK36h8b4E/9oEaEfs1drPJz+avJFcLabcJKAbIcvmNDbcJWAEDrqB8uvvO90tpC0eWb2oHbq3sRXKr+y4QI+LUUV4bjqEkbMp6MMxL3E9r3VkSARPMif9DDa6s1UEkYEp4xHtDch+zNrJ0KndRVJde4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=hspbFWW3; arc=none smtp.client-ip=178.154.239.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="hspbFWW3"
Received: from forward102a.mail.yandex.net (forward102a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d102])
	by forward204a.mail.yandex.net (Yandex) with ESMTPS id 613E865EE3;
	Sat, 19 Oct 2024 21:19:09 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2b:1d5:0:640:773e:0])
	by forward102a.mail.yandex.net (Yandex) with ESMTPS id 1A62F60929;
	Sat, 19 Oct 2024 21:19:01 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id uIUibWLNqCg0-ix3uVImu;
	Sat, 19 Oct 2024 21:19:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1729361940; bh=g4i8i7ZDRuEetTlOlV3vjQxEOMpZ2Ny6wy/nHvTRQm4=;
	h=Cc:Message-Id:To:From:Date:Subject;
	b=hspbFWW3Hfj+Oqqfwyt4M1RRpSmBWI1Gr1jrsh/L4Xnn9Dcc6HrfvqT+R1ajeKAqv
	 6uaL/0zR5uWLoOuJ1bzyAFMiM+tCg4chxKnppDdfZ5PwZR/TiDNEfjwE8uD9PS8l/z
	 xOtNBKx/PKbz/mZtuv/CI9U2ecXeanP/83Utl9y4=
Authentication-Results: mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net; dkim=pass header.i=@0upti.me
From: Ilya Katsnelson <me@0upti.me>
Date: Sat, 19 Oct 2024 21:18:38 +0300
Subject: [PATCH v3] netfilter: xtables: fix a bunch of typos causing some
 targets to not load on IPv6
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241019-xtables-typos-v3-1-66dd2eaacf2f@0upti.me>
X-B4-Tracking: v=1; b=H4sIAP33E2cC/3WOwQqDMBAFf0Vybko21ho99T9KDzFZ60KrkqRBE
 f+90ZMUepwHM7yFeXSEntXZwhxG8jT0CfJTxkyn+ydysomZFPICAhSfgm5e6HmYx8Fz26K2jWp
 ASsuSMzpsadp790fijnwY3LznI2zrv1IEDlxIXUCpKiPQ3MRnDHR+I9tCUR7l6leWSb5uP8q8s
 EbhQV7X9Qufs1Yc5gAAAA==
X-Change-ID: 20241018-xtables-typos-dfeadb8b122d
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Florian Westphal <fw@strlen.de>, Sasha Levin <sashal@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ignat@cloudflare.com, 
 stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>, 
 Ilya Katsnelson <me@0upti.me>
X-Mailer: b4 0.14.2
X-Yandex-Filter: 1

The xt_NFLOG and xt_MARK changes were added with the wrong family
in 0bfcb7b71e73, which seems to just have been a typo,
but now ip6tables rules with --set-mark don't work anymore,
which is pretty bad.

Pablo spotted another typo introduced in the same commit in xt_TRACE.

Fixes: 0bfcb7b71e73 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Ilya Katsnelson <me@0upti.me>
---
Changes in v3:
- Fix another typo spotted by Pablo, adjust text accordingly.
- CCing stable because it's a pretty bad regression.
- Link to v2: https://lore.kernel.org/r/20241019-xtables-typos-v2-1-6b8b1735dc8e@0upti.me

Changes in v2:
- Fixed a typo in the commit message (that's karma).
- Replaced a reference to backport commit.
- Link to v1: https://lore.kernel.org/r/20241018-xtables-typos-v1-1-02a51789c0ec@0upti.me
---
 net/netfilter/xt_NFLOG.c | 2 +-
 net/netfilter/xt_TRACE.c | 1 +
 net/netfilter/xt_mark.c  | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index d80abd6ccaf8f71fa70605fef7edada827a19ceb..6dcf4bc7e30b2ae364a1cd9ac8df954a90905c52 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -79,7 +79,7 @@ static struct xt_target nflog_tg_reg[] __read_mostly = {
 	{
 		.name       = "NFLOG",
 		.revision   = 0,
-		.family     = NFPROTO_IPV4,
+		.family     = NFPROTO_IPV6,
 		.checkentry = nflog_tg_check,
 		.destroy    = nflog_tg_destroy,
 		.target     = nflog_tg,
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index f3fa4f11348cd8ad796ce94f012cd48aa7a9020f..2a029b4adbcadf95e493b153f613a210624a9101 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -49,6 +49,7 @@ static struct xt_target trace_tg_reg[] __read_mostly = {
 		.target		= trace_tg,
 		.checkentry	= trace_tg_check,
 		.destroy	= trace_tg_destroy,
+		.me         = THIS_MODULE,
 	},
 #endif
 };
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index f76fe04fc9a4e19f18ac323349ba6f22a00eafd7..65b965ca40ea7ea5d9feff381b433bf267a424c4 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -62,7 +62,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 	{
 		.name           = "MARK",
 		.revision       = 2,
-		.family         = NFPROTO_IPV4,
+		.family         = NFPROTO_IPV6,
 		.target         = mark_tg,
 		.targetsize     = sizeof(struct xt_mark_tginfo2),
 		.me             = THIS_MODULE,

---
base-commit: 75aa74d52f43e75d0beb20572f98529071b700e5
change-id: 20241018-xtables-typos-dfeadb8b122d

Best regards,
-- 
Ilya Katsnelson <me@0upti.me>

