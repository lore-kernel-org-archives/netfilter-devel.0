Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EC6318130;
	Fri, 23 Jan 2026 08:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769155815; cv=none; b=cMtKU/VbFwWDsBrxvrg/htusMluabYCl61DN+OEsARLDA/gSNCgKDvT2MZJL0zSt9tHeFZ9X9YXUFRVyQWoyBHb062f5ZTiXHLyvrO6D6JScpQVwSsV3UvSfqoDayNGuoVySvMsGYo0/01X4gaEYY7jTZad+S/NSosVDEiFGAQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769155815; c=relaxed/simple;
	bh=KoPh6CoDQrbPGBvFYnsLCd+GNqvjjvjLubw3jSOsLCc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AHEwFYJ80WOl1rizMn1hCPCLwr1JE+OovfRSmOXCJ3ecrKh5MJmvcsSleq//7GJYSI+Ov6aWfh+/T3uEoe3eVrYsmb5x3pVvVCu7IHIJkAji6oUHjUhdtBSNpG37HWw+TR4+W2o9DIQFfzgBCrSxiNthFadIAiZjzhtHs3ueFZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ofYQ9tbH; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ofYQ9tbH"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4s74jvUZ8p0iLWgkoGR7WCdJSEEcD6iiPzDAnhCxjho=;
	b=ofYQ9tbH41jqDoxqxPJygbhG/xgn4kDeYy8MDhJCE7c2YRlU7BjG4XafB2AhzKKLH/TcBgLpo
	eng04hlzkMD3HHLg4xCEfEC1ob+aBSEZ2nuYPdpAnemVvJLCdB1JgL32zT4i9F2YIjDJZCd1M/D
	Gw78L2RCahu1xJ+mNBwKKCQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dy9Vj2fLlzpSwH;
	Fri, 23 Jan 2026 16:06:21 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id AB30D4056A;
	Fri, 23 Jan 2026 16:10:10 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 23 Jan
 2026 16:10:09 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <pablo@netfilter.org>, <fw@strlen.de>, <phil@nwl.cc>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <horms@kernel.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH] netfilter: xt_time: use is_leap_year() helper
Date: Fri, 23 Jan 2026 16:10:51 +0800
Message-ID: <20260123081051.336239-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500011.china.huawei.com (7.185.36.131)

Use the is_leap_year() helper from rtc.h instead of
writing it by hand

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 net/netfilter/xt_time.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 6aa12d0f54e2..00319d2a54da 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -14,6 +14,7 @@
 
 #include <linux/ktime.h>
 #include <linux/module.h>
+#include <linux/rtc.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
 #include <linux/netfilter/x_tables.h>
@@ -64,11 +65,6 @@ static const u_int16_t days_since_epoch[] = {
 	3287, 2922, 2557, 2191, 1826, 1461, 1096, 730, 365, 0,
 };
 
-static inline bool is_leap(unsigned int y)
-{
-	return y % 4 == 0 && (y % 100 != 0 || y % 400 == 0);
-}
-
 /*
  * Each network packet has a (nano)seconds-since-the-epoch (SSTE) timestamp.
  * Since we match against days and daytime, the SSTE value needs to be
@@ -138,7 +134,7 @@ static void localtime_3(struct xtm *r, time64_t time)
 	 * (A different approach to use would be to subtract a monthlength
 	 * from w repeatedly while counting.)
 	 */
-	if (is_leap(year)) {
+	if (is_leap_year(year)) {
 		/* use days_since_leapyear[] in a leap year */
 		for (i = ARRAY_SIZE(days_since_leapyear) - 1;
 		    i > 0 && days_since_leapyear[i] > w; --i)
-- 
2.34.1

