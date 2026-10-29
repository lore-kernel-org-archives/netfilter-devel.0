Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793279885;
	b=J0ITgtgQPJdzqW4yQ0XDg1fW1AVY3hT5IkVk360l5EuMQINcv1s4NH/zc2nbPC6xSrA7
	 VcqkhOfBZGK9M1jpzdzFRyIzwbFvtYoKhjU+AkBheor0Oej+Q+DCkjovMubdWyzGZEOkB
	 kQ272PzRTUi3EGA1b3VDB54FcL/vF8ZCBJDPumo89vWZBEzs1HyQjU8BmzzJB+Og1hYpk
	 W2voOUOhyzikkGIqhErwXa1XldXZJYQwa2e8FQwlNyTrao/biFASRIj5vjBFTzofHjEQ5
	 hRFn6pY5TpvLtcpf75a5bi69sWpjxcko3IU52xS1ACfEzL/z9j+wqsb4P8nqQATVP3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793279885;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=vVC+fZb1VVnYyKkEydfk9nnMz1YEvRH4h5saQBN6pds=;
	b=SvdjZNEtEF4u+w4lW2qfawLm3thK42nsg2SpjkoO+a+QqYQ/MJc+GZty2tQLGpADFt9x
	 bO2JcQxKNptF39458kHTyx5vcP+bm9acDJK42L/o9UOI03E5DWNeh33qlF9cr3DWdFCCq
	 VudTzhs866Kw3jnYzKsuXLHg1/5v1/K1MrSAvBCHs1GDnif2IaRyOeTRZqvhV+zQy4owm
	 iaN6noR1SoVMUvNY2T886yvEwFSAnwe4bN0w0Ai53HI87aajvBaOttjKjMtp+50nBKlC7
	 80bDTX6AhddYvpoOSw2dX4L6P1UEu2Dfh76EAiSHCXjSJ350KsWhnJkEQYXqC3yQ+Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="IiQ9l0T/";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fSYLBDCe;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="IiQ9l0T/";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fSYLBDCe;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84464606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:18:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84464606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IiQ9l0T/;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fSYLBDCe;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IiQ9l0T/;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fSYLBDCe
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 419A522034;
	Thu, 29 Oct 2026 13:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793279877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vVC+fZb1VVnYyKkEydfk9nnMz1YEvRH4h5saQBN6pds=;
	b=IiQ9l0T/x2uTPfxZ9IwHRU386n81M4Bkf4Ts00q5qoqQt54X1UeoFgVBkZTFGj5LqbVwFX
	t3OX7aZwFMN0aSq71mSxO89EcZifkdp7VyVFVqEeahqEWIAbZsnPSNWqo0RXwQZS62EvOf
	dRT4Tkerc2mNL4J+9nsSk22UNvO5akY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793279877;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vVC+fZb1VVnYyKkEydfk9nnMz1YEvRH4h5saQBN6pds=;
	b=fSYLBDCeOtYfqt/7mLJE5LjnUhoKOZzUnXBpRwrD9iuyPzkyKQFEWyuSLfnoqvNmK1zkmY
	Ytos544oXitTjGCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793279877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vVC+fZb1VVnYyKkEydfk9nnMz1YEvRH4h5saQBN6pds=;
	b=IiQ9l0T/x2uTPfxZ9IwHRU386n81M4Bkf4Ts00q5qoqQt54X1UeoFgVBkZTFGj5LqbVwFX
	t3OX7aZwFMN0aSq71mSxO89EcZifkdp7VyVFVqEeahqEWIAbZsnPSNWqo0RXwQZS62EvOf
	dRT4Tkerc2mNL4J+9nsSk22UNvO5akY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793279877;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vVC+fZb1VVnYyKkEydfk9nnMz1YEvRH4h5saQBN6pds=;
	b=fSYLBDCeOtYfqt/7mLJE5LjnUhoKOZzUnXBpRwrD9iuyPzkyKQFEWyuSLfnoqvNmK1zkmY
	Ytos544oXitTjGCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B717B1339F;
	Thu, 29 Oct 2026 13:17:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cJhxIYRH42rndQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 29 Oct 2026 13:17:56 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next] netfilter: xt_time: fix monthday computation for dates past 2039
Date: Thu, 29 Oct 2026 14:17:18 +0100
Message-ID: <20261029131718.5531-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

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
---
Note: this is just a code cleanup because I keep getting dumb AI reports
about this. I got already 3 (!!!). Let's just remove the old code and
use modern mechanisms as it also reduces the object size. Sorry for
making you review this useless thing.
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
2.56.0

