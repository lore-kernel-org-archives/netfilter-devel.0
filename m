Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D7B2C109E;
	Tue, 22 Apr 2025 20:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745353436; cv=none; b=pgMC/IXLsVh30kQIiDTORbYnLw+Nq1L5NjpfeQLb5FMmFRoHeJaefQSLxWZJ9r01FGB8EDqD6wSZ3eJUwR217IYEmboNbZbGzB1VHr/6drRn7dSrgj8xvi89uBmpkT1zOk/dUAZb8LtFoCMmFEwI0k2ZNvz+T2dWGcZG32kiQsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745353436; c=relaxed/simple;
	bh=jGZWp/s9c8MYYXptI7KPTyOMNgSBvW60zDMnz4Wv9Ok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eAyUv2JUZbI2g2JiHBPcAHI+j+mJyXp0NBY2KmtRxpi5aBsL2vFpHmZEc7f0mTnCnk5Vnc3koBx6+Lnupsgquhe8FDmfdpSrBzT5BriszwL36kdHrBnAvVs0ozKxNDj9EB9eisufXpKO+pfn2QB8Koud4s7UimWBg1zvochUFog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hxwLQhbl; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b+NNI9N9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hxwLQhbl";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b+NNI9N9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EE3F1609C8; Tue, 22 Apr 2025 22:23:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353430;
	bh=Ii4iPquCDIwHC42dV7wmGy7Le9AS5Wx3alzRuxUPr+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxwLQhbl0yJ1MY25jAcPVFfkukLu0mQ9WGf2hZfIyRsBwsCH8qZyexzRHiSJYhbAe
	 krIK6ZRFUpo71u5iw/yYW5sVQhVyl05oHPXawzYnOd+gmVth2YPvc3QHNixD12dRe+
	 U/BTV4fYYkdjL+9o++4OwywaDaSvyJvunGPB+7K1WrMR6JcEgjgXPsyjr5uLHAFO5Q
	 kQ20Fv3z1Qy+qHffz4mBNCnQ2ljgg8ciWvAOqlq5G/wIaD2UTegg1tWX8k1Wf7HP7+
	 RhcqlBKgz2axJSRoAuM9CZ7kY+es/3RRYIPaH/iw4k9pBWNxL1MNRjNSug9M0NQPfX
	 VGDKB5InYjF+A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AEFEC609B9;
	Tue, 22 Apr 2025 22:23:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353429;
	bh=Ii4iPquCDIwHC42dV7wmGy7Le9AS5Wx3alzRuxUPr+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+NNI9N9S2tiGfcV9iSEBnfwZgh0xEu+Rl+okVkAkIZ+Yqz7fnMcEK5lN+jySwAL/
	 WEB2bGFMp8aTcWKOFnLZIBuDzeVhJNryylL5SeVB1lo7bXOTGLkiHzAEmtX7XK1x+d
	 1yzIpfqpWakeWpYD9lEieScJZQFfXxA+4AEc7hXrvJo1dRHy45DCN2Q0m8J7XScuiE
	 KfSWine/FtK8THANnKWRp+W2tXqnRt6/nVqEaX/n/1U6p0EU7ny8cpTulPbVKy2qcq
	 NRlAvVisKUYibSqrMdMAd9O91zyn+B5XoeChcy3FvZBTR/lPExhp1VxOD9mBHinYO0
	 f9PkYksH7Y94g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 1/7] netfilter: xt_IDLETIMER: convert timeouts to secs_to_jiffies()
Date: Tue, 22 Apr 2025 22:23:21 +0200
Message-Id: <20250422202327.271536-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250422202327.271536-1-pablo@netfilter.org>
References: <20250422202327.271536-1-pablo@netfilter.org>
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

