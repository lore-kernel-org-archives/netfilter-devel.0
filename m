Received: from forward102d.mail.yandex.net (forward102d.mail.yandex.net [178.154.239.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684D03207;
	Sat, 19 Oct 2024 05:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729314335; cv=none; b=TNO5/4sRZztI2CETGrI27AG1F5phO2WKufpE41PYP9+HPV3oXQNZPtF95xdazY73TmLt4iiTN/3npKt4q2LWvJnHGBJMk2GZEgAbzwEJxRGqh3YEnttry2B4dTLgwMi9KYRTOrA/LXevoTLtl677XzQHs643fuz5ti/ThuCTHzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729314335; c=relaxed/simple;
	bh=pzcp7AuVQDeoAjqOJS1Gci/darE5YR8LLwrxlUJTyCc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=LAdEQluKK3Aek61pvhAegrfP2DSgJdH9Cw6ijiaVAp12cCSO1U0yj04c0/BpeYrhCu6J9BaJRFDrSG41ZDhrhJJr4Y/GMlhOmGnjiUxabnfYcs2YG+V/Nm4qmLHF4FGPbcWzzhlcLHPQ3VjmgPq6zffQRfSu2jfs9MA1g5tVGJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=ftvN4ATL; arc=none smtp.client-ip=178.154.239.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="ftvN4ATL"
Received: from mail-nwsmtp-smtp-production-main-90.myt.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-90.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:540d:0:640:a455:0])
	by forward102d.mail.yandex.net (Yandex) with ESMTPS id 1FAF2609B7;
	Sat, 19 Oct 2024 08:05:29 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-90.myt.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id J5HMSoDXwSw0-MjPoKqZb;
	Sat, 19 Oct 2024 08:05:28 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1729314328; bh=2k2iS9iboQwDKwqPbtLjVnIVDV2C8spGP5e6zIWx4Pk=;
	h=Cc:Message-Id:To:From:Date:Subject;
	b=ftvN4ATLWURwRMHl2E9Z7385tfDjh00ZteL8yEs1gkWS6FBrddTigsdUuATzbTRJn
	 R0UVIs0RJa3keGhApPx7Xe1Xdxlr6BIS4kEI7qUkyY9CtDxUdAmdIrzBfbFiTIxu8t
	 /VwwufWj5d9VgWqZmaWir0Zh0EyyzaYQuGQZswhw=
Authentication-Results: mail-nwsmtp-smtp-production-main-90.myt.yp-c.yandex.net; dkim=pass header.i=@0upti.me
From: Ilya Katsnelson <me@0upti.me>
Date: Sat, 19 Oct 2024 08:05:07 +0300
Subject: [PATCH v2] netfilter: xtables: fix typo causing some targets to
 not load on IPv6
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241019-xtables-typos-v2-1-6b8b1735dc8e@0upti.me>
X-B4-Tracking: v=1; b=H4sIAAI+E2cC/3XMywrCMBCF4VcpszaSCYrRle8hXeQytQPalCSGl
 pJ3N3bv8j9wvg0SRaYEt26DSIUTh6mFOnTgRjM9SbBvDUqqE0rUYsnGviiJvM4hCT+Q8VZbVMp
 D+8yRBl5279G3HjnlENedL/hb/0kFBQqpzBkv+uokubv8zJmPb4K+1voFHOcGiKkAAAA=
X-Change-ID: 20241018-xtables-typos-dfeadb8b122d
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Florian Westphal <fw@strlen.de>, Sasha Levin <sashal@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ignat@cloudflare.com, 
 Phil Sutter <phil@nwl.cc>, Ilya Katsnelson <me@0upti.me>
X-Mailer: b4 0.14.2
X-Yandex-Filter: 1

These were added with the wrong family in 4cdc55e, which seems
to just have been a typo, but now ip6tables rules with --set-mark
don't work anymore, which is pretty bad.

Fixes: 0bfcb7b71e73 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Ilya Katsnelson <me@0upti.me>
---
Changes in v2:
- Fixed a typo in the commit message (that's karma).
- Replaced a reference to backport commit.
- Link to v1: https://lore.kernel.org/r/20241018-xtables-typos-v1-1-02a51789c0ec@0upti.me
---
 net/netfilter/xt_NFLOG.c | 2 +-
 net/netfilter/xt_mark.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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

