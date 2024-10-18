Received: from forward204d.mail.yandex.net (forward204d.mail.yandex.net [178.154.239.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5F2204019;
	Fri, 18 Oct 2024 15:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729266744; cv=none; b=hvQ5RPIbpw4D3jffu+jbO6fpAWkoZt5y7uE+TUqhpPj8OLhK8b8dpxD3Ke98aB7iSw1ChHmX1tMS7JrAz8rORV+Lf04I+PNnai7RIsGg4rgXUnkgQ1/y/hZ84DoCUFwjl1OECoA9lyug1WQtrNZpatqBkF1KSZaYc7xo/sBJGSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729266744; c=relaxed/simple;
	bh=7H0Q9U1UYxEFlkYaqSBmwzFL11HxpvwRT6aZlOH7Ypw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=I+SIWRJGkUEIJTAUQeKX/wPScqFgQB/1uvWjnm+XK62+LNtY0khiij75TPtRzNcP6CmaiSrhrV4nr71BBBVGVCMqT5j5WliOgfQzupSkzYX1eV61muEfsNPYPBbcPKbrJWAcLwXzTdrM0BHpWC1TSBXZEldeUqa+MShjdwp1Nz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=jAB1voQ+; arc=none smtp.client-ip=178.154.239.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="jAB1voQ+"
Received: from forward102d.mail.yandex.net (forward102d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d102])
	by forward204d.mail.yandex.net (Yandex) with ESMTPS id 19AF26488F;
	Fri, 18 Oct 2024 18:45:13 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-42.myt.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-42.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:36a7:0:640:faa7:0])
	by forward102d.mail.yandex.net (Yandex) with ESMTPS id 636EF6098E;
	Fri, 18 Oct 2024 18:45:04 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-42.myt.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 0jQoPjE7LqM0-eNKpu7n7;
	Fri, 18 Oct 2024 18:45:03 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1729266303; bh=bMXPLZvnJ4EGZ5ZCRb5TWGuQf6he/CI/uDpcRlMFVfI=;
	h=Cc:Message-Id:To:From:Date:Subject;
	b=jAB1voQ+ZfXuqwEoJA06wECx+2IvkApJNYHxhOqoyaUGYUvpECFl2gJfoc/egSpxl
	 7QrbNAXtvbFJccaRwGIfW2/IIEzwlzt596dAEKnacGjwjmJHIKjk082QHzc8zHNDmS
	 /UxKMngEIyfLtGXZl4pDSLtE2eps/fznNG1bYavs=
Authentication-Results: mail-nwsmtp-smtp-production-main-42.myt.yp-c.yandex.net; dkim=pass header.i=@0upti.me
From: Ilya Katsnelson <me@0upti.me>
Date: Fri, 18 Oct 2024 18:45:00 +0300
Subject: [PATCH] netfliter: xtables: fix typo causing some targets to not
 load on IPv6
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241018-xtables-typos-v1-1-02a51789c0ec@0upti.me>
X-B4-Tracking: v=1; b=H4sIAHuCEmcC/x3MQQqAIBBA0avErBNyaCFdJVpojjUQKU5EId49a
 fkW/xcQykwCU1cg083C8WzQfQfrbs+NFPtmwAFHPWijnsu6g0Rdb4qifCDrnXEa0UNrUqbAz/+
 bl1o/jyleKF8AAAA=
X-Change-ID: 20241018-xtables-typos-dfeadb8b122d
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Florian Westphal <fw@strlen.de>, Sasha Levin <sashal@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Ilya Katsnelson <me@0upti.me>
X-Mailer: b4 0.14.2
X-Yandex-Filter: 1

These were added with the wrong family in 4cdc55e, which seems
to just have been a typo, but now ip6tables rules with --set-mark
don't work anymore, which is pretty bad.

Fixes: 4cdc55ec6222 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")
Signed-off-by: Ilya Katsnelson <me@0upti.me>
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

