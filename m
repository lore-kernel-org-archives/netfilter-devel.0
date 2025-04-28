Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7850A21147B;
	Mon, 28 Apr 2025 22:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745878399; cv=none; b=CxSfyIC+9J5S2YMMnmjrs/U82FLD1o7hALfXhwOeT0gW8JSr+qMjEmvqHEI2pBA6xkgaXrN2+jbGMWx5Bc8M8aK3w3heQb4NoPcCodujdbjpRx/UH9bBdqUwmafMVhj+CWO633aEnu2AsWrPWZGia8haeU/tdvHoqSn+nOiY7U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745878399; c=relaxed/simple;
	bh=jGZWp/s9c8MYYXptI7KPTyOMNgSBvW60zDMnz4Wv9Ok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n4UeHfjNLBUkKbZWncuL++lr6LZrMEQ2WudTwHYGy73Pa564nV0vS8H4vlZ0QyZtOOax/aDFUR6LBZq2qd6PQ/wkOYeBdBWTIRmlQkqq47GcEs+2MTLhzFQn2wQet2gG6YRT8EbQKeBk5xeoYp0FKfP+vRc3GsEkJpcqtvHY7VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nMyGlo3o; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t6I17io7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nMyGlo3o";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t6I17io7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5011E6054C; Tue, 29 Apr 2025 00:13:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878393;
	bh=Ii4iPquCDIwHC42dV7wmGy7Le9AS5Wx3alzRuxUPr+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMyGlo3oAm0/JcMNx5rTAB43q4tEvgryKJ0ChxCAMqNTvYrEyUgHcOj7B/6tPJlJa
	 6AEFyCj3tOwHAd7V0hhiiMdgsOMwiU6rBwhfVwOmA95KuNuT4x6cskIbvOEXWWHHm0
	 px2uvaZBHTNeVD7tUv6fSy4OqR7RkXTPh7qNgMSm2OkjrjnF1WBzGhMOdPO4II91ph
	 Sq2SAC0MOV8kw44UVORxRkoZsXRQsCxiyMDNuFcLlT4Q+uUfWuMdzWhxu6J1S/s7jN
	 II/9hVOHyBhzd34dANVT1zORpie6JUKLXeEQnX/qIJXbaLxU59TCmeVXzJA0OXcGck
	 7Y7DcWu5KJU+w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4B4EC603C4;
	Tue, 29 Apr 2025 00:13:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878391;
	bh=Ii4iPquCDIwHC42dV7wmGy7Le9AS5Wx3alzRuxUPr+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6I17io7XAtv0P1k3oc6bSAfpXdAxX0xSbC6yAXv6+WwjHInN4TRFARjeUcuL0RNs
	 qWSzw2FOLsb5pfUQ86U9kNe8LEoMgYjmL+174F9e/VBzU4/x1zMHoaUU+5MJ1QMhri
	 x+jsL85E/FDbqPYHToyHatgHQI767c6dItS3ZqgBaZp9f5U9+oQVHZXjdnqJ9K6JhO
	 5ZaMA5QZmKIUe2uG9kitHq+YZeEqkEDTQd3dMkIPAETmyPaJCRFKH1jEoHmEWJs+Dd
	 Zn6geUUlkFlqOBj3fmEShJvg5s+ljRkXSv6ke/6R1WZJXHnruTf4YRTqOO9Ij2ca6h
	 KE4IfjiZJzDpQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 1/6] netfilter: xt_IDLETIMER: convert timeouts to secs_to_jiffies()
Date: Tue, 29 Apr 2025 00:12:49 +0200
Message-Id: <20250428221254.3853-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250428221254.3853-1-pablo@netfilter.org>
References: <20250428221254.3853-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Easwar Hariharan <eahariha@linux.microsoft.com>

Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
secs_to_jiffies().  As the value here is a multiple of 1000, use
secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.

This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
the following Coccinelle rules:

@depends on patch@
expression E;
@@

-msecs_to_jiffies(E * 1000)
+secs_to_jiffies(E)

-msecs_to_jiffies(E * MSEC_PER_SEC)
+secs_to_jiffies(E)

Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_IDLETIMER.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 9f54819eb52c..9082155ee558 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -168,7 +168,7 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 	INIT_WORK(&info->timer->work, idletimer_tg_work);
 
 	mod_timer(&info->timer->timer,
-		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
+		  secs_to_jiffies(info->timeout) + jiffies);
 
 	return 0;
 
@@ -229,7 +229,7 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
 	} else {
 		timer_setup(&info->timer->timer, idletimer_tg_expired, 0);
 		mod_timer(&info->timer->timer,
-				msecs_to_jiffies(info->timeout * 1000) + jiffies);
+				secs_to_jiffies(info->timeout) + jiffies);
 	}
 
 	return 0;
@@ -254,7 +254,7 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,
 		 info->label, info->timeout);
 
 	mod_timer(&info->timer->timer,
-		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
+		  secs_to_jiffies(info->timeout) + jiffies);
 
 	return XT_CONTINUE;
 }
@@ -275,7 +275,7 @@ static unsigned int idletimer_tg_target_v1(struct sk_buff *skb,
 		alarm_start_relative(&info->timer->alarm, tout);
 	} else {
 		mod_timer(&info->timer->timer,
-				msecs_to_jiffies(info->timeout * 1000) + jiffies);
+				secs_to_jiffies(info->timeout) + jiffies);
 	}
 
 	return XT_CONTINUE;
@@ -320,7 +320,7 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 	if (info->timer) {
 		info->timer->refcnt++;
 		mod_timer(&info->timer->timer,
-			  msecs_to_jiffies(info->timeout * 1000) + jiffies);
+			  secs_to_jiffies(info->timeout) + jiffies);
 
 		pr_debug("increased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
@@ -382,7 +382,7 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 			}
 		} else {
 				mod_timer(&info->timer->timer,
-					msecs_to_jiffies(info->timeout * 1000) + jiffies);
+					secs_to_jiffies(info->timeout) + jiffies);
 		}
 		pr_debug("increased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
-- 
2.30.2

