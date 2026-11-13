Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539586;
	b=FY+zSmf1g+eG3nB4SHzznYcIcbRjmiUlmKGuhUPmGwcPhWv2PnFRlmqDk+UTW8JzAfex
	 baxfUx3yTxkxsHIzv9prr18J0W7Gxxlv1V3TKoc/Uu2gBMEIwAVOln2OwUQRTZO98GBYn
	 h2qnIunmyQg+ppVXVvmcuVZVG8zfIZnVBfDetvFD+K5JZitKKP2WAiC38J+whvAYl5P+i
	 gav7Qk80BiGlnZ6TJDvDzt9SQiTGGOVRjEJeZh97b2x61D4gqxtfAbTAYwuSy0wRpwuFv
	 4pE8q8Cx92iQB+HxxJC9drqW1yu0aTwt7RIKFGhkWIYkGslZ75l5o1po4uNGFAi+GLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539586;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=5AxYGpxQ2qdBjG6fmhL9U+5bCykooF0WL7T3Cnd0D0U=;
	b=n0XJThpnLTORfkrOxHRT3MJmNXIU4MBvEmsNWBzXz/91n2r7PUe1lWNp+MBTc80dQdbC
	 N47uEsl/oUodQ6Gp+0ZTlY5Wrsaon5Nf2VMd8I9lcyP4Qq0WmrhJQhoYL8h7pvSTFwpsg
	 EgC1UtSYLc7ItYnDA4bPa0LFewULQipmuMSDvBHR7jaknmDhOOpQ1XHRUPCxB0vHOe2Nf
	 eEEEFsCockHoJU1VIGFcVNDxfRm365dm0M1YgKg8241a5w9t+15qEptVofm4sGPC78ynf
	 ulvIoGA6gRC4aee+5Hkd1pr3n6OyG25JydcjlazCUb0i6YMKXzcTzd776NSrTHJJXYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TmpJZYm0;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0678F606A8B4;
	Fri, 13 Nov 2026 03:13:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0678F606A8B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TmpJZYm0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539584;
	bh=5AxYGpxQ2qdBjG6fmhL9U+5bCykooF0WL7T3Cnd0D0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TmpJZYm0pZ05rgmGe/TjGIdwp9L1Q0fpx2eEloYhqGY7kByaBtBmRaz5gxCzft26r
	 /NQTJFoXHESCKQ5BfkL7uZKJZT2l0sxEcbpLgYTs/TANb2u0qJROQTWlkjtvdPXh43
	 eUL/PbFSzejPIy827I+BfrSGONzpAxkuT3CZzr9pWxm9OxaZGnCJf0HkCHndVayfHF
	 pK+4/QPIiedzILP7LvZdLTrizKU0O14trIgBM0rvto4Wy4XhkzQ4qf/YBNLAH2MwUl
	 rG21AuIdoAAE981NivvrDzmv0ClHmi3bFwCoKhsVDitjusOEUUc0wiFFgX2j0MeCVV
	 accLz3PR2HQvw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C063160058;
	Fri, 13 Nov 2026 04:13:03 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 06/15] netfilter: xt_time: fix monthday computation for dates past 2039
Date: Fri, 13 Nov 2026 04:12:42 +0100
Message-ID: <20261113031251.2437074-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

iocaltime_3() derives the year from days_since_epoch[], which only has
entries up to 2039. For any date from 2040-01-01 on, the lookup stays on
the 2039 entry, so the day-of-year offset is 365 or more. That value is
used to compute r->monthday, which ends up larger than 31 (32 on
2040-01-01, and it wraps in the u8 later in the year).

Use time64_to_tm() instead of the table walk. It is always built in,
handles any time64_t, and always returns tm_mday in 1-31, so the table
and its 2039 limit go away. The result for 1970-2039 is unchanged.

Only the real-time clock reaches localtime_3(), so this is not
triggerable before the clock passes 2040-01-01 UTC.

This significantly reduces the size of xt_time object.

add/remove: 7/10 grow/shrink: 0/1 up/down: 143/-490 (-347)
Total: Before=1493, After=1146, chg -23.24%

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_time.c | 82 +++--------------------------------------
 1 file changed, 6 insertions(+), 76 deletions(-)

diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 2065fce8ef81..f0c4c1d1bc4a 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -13,8 +13,8 @@
 
 #include <linux/ktime.h>
 #include <linux/module.h>
-#include <linux/rtc.h>
 #include <linux/skbuff.h>
+#include <linux/time.h>
 #include <linux/types.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_time.h>
@@ -31,38 +31,7 @@ struct xtm {
 
 extern struct timezone sys_tz; /* ouch */
 
-static const u_int16_t days_since_year[] = {
-	0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334,
-};
-
-static const u_int16_t days_since_leapyear[] = {
-	0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335,
-};
-
-/*
- * Since time progresses forward, it is best to organize this array in reverse,
- * to minimize lookup time.
- */
-enum {
-	DSE_FIRST = 2039,
-	SECONDS_PER_DAY = 86400,
-};
-static const u_int16_t days_since_epoch[] = {
-	/* 2039 - 2030 */
-	25202, 24837, 24472, 24106, 23741, 23376, 23011, 22645, 22280, 21915,
-	/* 2029 - 2020 */
-	21550, 21184, 20819, 20454, 20089, 19723, 19358, 18993, 18628, 18262,
-	/* 2019 - 2010 */
-	17897, 17532, 17167, 16801, 16436, 16071, 15706, 15340, 14975, 14610,
-	/* 2009 - 2000 */
-	14245, 13879, 13514, 13149, 12784, 12418, 12053, 11688, 11323, 10957,
-	/* 1999 - 1990 */
-	10592, 10227, 9862, 9496, 9131, 8766, 8401, 8035, 7670, 7305,
-	/* 1989 - 1980 */
-	6940, 6574, 6209, 5844, 5479, 5113, 4748, 4383, 4018, 3652,
-	/* 1979 - 1970 */
-	3287, 2922, 2557, 2191, 1826, 1461, 1096, 730, 365, 0,
-};
+#define SECONDS_PER_DAY 86400
 
 /*
  * Each network packet has a (nano)seconds-since-the-epoch (SSTE) timestamp.
@@ -102,51 +71,12 @@ static inline void localtime_2(struct xtm *r, time64_t time)
 
 static void localtime_3(struct xtm *r, time64_t time)
 {
-	unsigned int year, i, w = r->dse;
-
-	/*
-	 * In each year, a certain number of days-since-the-epoch have passed.
-	 * Find the year that is closest to said days.
-	 *
-	 * Consider, for example, w=21612 (2029-03-04). Loop will abort on
-	 * dse[i] <= w, which happens when dse[i] == 21550. This implies
-	 * year == 2009. w will then be 62.
-	 */
-	for (i = 0, year = DSE_FIRST; days_since_epoch[i] > w;
-	    ++i, --year)
-		/* just loop */;
-
-	w -= days_since_epoch[i];
+	struct tm tm;
 
-	/*
-	 * By now we have the current year, and the day of the year.
-	 * r->yearday = w;
-	 *
-	 * On to finding the month (like above). In each month, a certain
-	 * number of days-since-New Year have passed, and find the closest
-	 * one.
-	 *
-	 * Consider w=62 (in a non-leap year). Loop will abort on
-	 * dsy[i] < w, which happens when dsy[i] == 31+28 (i == 2).
-	 * Concludes i == 2, i.e. 3rd month => March.
-	 *
-	 * (A different approach to use would be to subtract a monthlength
-	 * from w repeatedly while counting.)
-	 */
-	if (is_leap_year(year)) {
-		/* use days_since_leapyear[] in a leap year */
-		for (i = ARRAY_SIZE(days_since_leapyear) - 1;
-		    i > 0 && days_since_leapyear[i] > w; --i)
-			/* just loop */;
-		r->monthday = w - days_since_leapyear[i] + 1;
-	} else {
-		for (i = ARRAY_SIZE(days_since_year) - 1;
-		    i > 0 && days_since_year[i] > w; --i)
-			/* just loop */;
-		r->monthday = w - days_since_year[i] + 1;
-	}
+	time64_to_tm(time, 0, &tm);
 
-	r->month    = i + 1;
+	r->monthday = tm.tm_mday;	/* 1-31 */
+	r->month    = tm.tm_mon + 1;	/* 1-12 */
 }
 
 static bool
-- 
2.47.3

