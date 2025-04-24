Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626A828CF78;
	Thu, 24 Apr 2025 21:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529323; cv=none; b=ue5VbrrcP3vHj460p+wvePHNBO4EGikDJwSjhwFDmlAhhrapanL4cp+LirNKT3b/19AO5iCqOJhRwEzK4rp/t/bZzW5TvDWTT06N6uHIoKr3m75OxPR9aDG0VGI/Tv66XfGxRxwXDrupdXbgjqLbrgVt6nU+C1+e93mtxzUZDjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529323; c=relaxed/simple;
	bh=jGZWp/s9c8MYYXptI7KPTyOMNgSBvW60zDMnz4Wv9Ok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZRvK+x06fcBKBmtwCuASpq1itSz9dOffx8uy/LXkAsmdLgRLnmjdeatLRSGiD+V7jzINlD6kTFtW6LbycYaZPCxRumGkmttxyTNfn6iBfQ+Tw+SedkO0lBOQaEbAhVq0jCwG18eUHzRz22ruejRy2w5TSA/1lLS16nLWqDUZoHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NNMzfbWa; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QCfCoDu4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NNMzfbWa";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QCfCoDu4"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0D3B260719; Thu, 24 Apr 2025 23:15:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529314;
	bh=Ii4iPquCDIwHC42dV7wmGy7Le9AS5Wx3alzRuxUPr+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNMzfbWa0wzycAne0o4J6w01Z0GgY9sGFjQVbdb65lC+4rREsQp/Rm4hFhILDMSzL
	 jaoeo75lbS3WrhtxOVOrmwzFQu/DG8iGyLauzcUg5YC4GXdYJ2QwyJVw0OUjaxs3Kq
	 AB3j/5Gg7TH9ebU2OmL0P8s8LVNb+JOOs9fC3lM4/K+p3SuYtDB06gfFuVkceIvIJA
	 DwGGhPQv04zaAiTp+jFmel1A871buNmOm9oxS/2NeXnTkUIi+i3nfdmY9/jA0M62wh
	 A9rdnmG5WF5dg0N8Nrap7Gr5IGweJj90P2kISnCvhOkCk4PsuTd33vx4sDJ7TyHRUt
	 iWGqyGxpNtHwA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 11EAA6070A;
	Thu, 24 Apr 2025 23:15:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529311;
	bh=Ii4iPquCDIwHC42dV7wmGy7Le9AS5Wx3alzRuxUPr+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCfCoDu4u+tDb1rw6llmzdmhiVyD8/wndLa+c4OCIPnXNkx8d/MmYDoHEuTEzish0
	 M+C8SwzOLk4gKYe23EkkfKnsWWHTcCPVesQrt8qWED2yBd4FEZOwCSqVzOZYqS4f5i
	 irGe4JboMzCLxGgU4hL1RhFSf+9ykV/BR+WyfWrOODZtlGJyp9jmCrygh+0oVwwRR4
	 g7nu2t8kMxCXIOHLhDue3m78AGOfiSBa4eKFyox1/1EGgGJz4S+Stfpm9sc1tLh4WG
	 DyB/chd01f2rMO9A4bwjml9fzRnI1v3cqVy5mgi57jUkqFEUQ0sCDS+VjrwfEjXgZq
	 1PajrVnMXu3qQ==
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
Date: Thu, 24 Apr 2025 23:14:49 +0200
Message-Id: <20250424211455.242482-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250424211455.242482-1-pablo@netfilter.org>
References: <20250424211455.242482-1-pablo@netfilter.org>
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

