Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10E6224AF2
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 20:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774556303; cv=none; b=eUj8o/cHTwHw6BAmQIGQuSH3diYCcAh1rclCUe1Ic6kJxlYOTfN+4XIOuFky8j7ojMc/qjCm/72NWHiAdxxMQJ0fzPwA7jkTzafh1vvpZRuEn/+zQz8rwBVX+6YMr8wpOUZfsBRdp/kBiyyaHMKjmCq5hdHQbLZ3NLQ4XkdLWJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774556303; c=relaxed/simple;
	bh=JX4vHATIUFWQLbRlq7POOxtY7rKiXSnnAKpkp53Qk4w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a80i08aahi+MawCRkzj1f62s1Ue163Gqh3Wr1MkVSqiH8uI2K+RpDgQddmheW62u1qpvBjesvxNfHDWE3jkhaFLtzMcTVdGDlV+Q+RL/KaXaoHTP7P3ZoOg7HcGSa7ZfFSQ7WSCWHgodcbCV4OVv4gIWgZyDLMxY3WeNgD7BYh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=blqaZm56; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="blqaZm56"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43b527ac5d0so773832f8f.2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 13:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774556300; x=1775161100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wTEKVcMeJ2+2gv4frZXSVscFWk19gO1Vh54Xj2RwYEY=;
        b=blqaZm56Pg7xovNIpmBVh3tAUfgT9Wqpu9MfcT0TYYjveYmsdY68H83Hs1z5mg4tQK
         OJuaro/JcZNe/jj/+68toggUdhKd0g7pC5rQAqWc0z+0vX+fuVOe+RSRFvEiLhH00Ko0
         HyFexecWi2FRWcC8DgXv1v+Pb3FrecjRVD4cFFhBqjCjgqxWTL2OqoXwA656nHlnfvEK
         p15Ic2U6J/tfIowzBMxw4hTMwYJMBfine093n1Jqk3Hjmljb7onQJ1ET4ftqCGffQ5wq
         dgaHVxOFHdd2Z3cL/NNkKZW3tB9+i5AXmNtgmnQ8aL9zSfYrc/YlR8YlY0pN6VsezPT4
         qifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774556300; x=1775161100;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wTEKVcMeJ2+2gv4frZXSVscFWk19gO1Vh54Xj2RwYEY=;
        b=eOFy0mznJvpyCHmzH912P/zgno/4ldXubx81vpao816XgHnvlvb/U1edEYRWIWFU1r
         m1YqnDAM6dACc6tE9dyBl0s8Hp+6QZPu8HXQxOr3h8Y6PIOjHoYU/E4cK9yG+i+/mWqw
         yy7bGdM0R3ZKJS+tSprD+4c8SuJ9G5GdbBNWqrg1TmqcDq/YCP5vhdRIcwlnP4XuWGcB
         Lx1gUwS/Qo1YqXcPxebk5cALoBFH5Ll8JwYkfxjZ9sMOREakozW7nwi0flAG1yiqUlxV
         AkngiC5/01nAzjo114aO6Y6jb0Ouj/DPSIm3/4Np2CwZ8zEaPVrdRvFLxoc1FMLRcFDJ
         cvpg==
X-Forwarded-Encrypted: i=1; AJvYcCXAlm4drzApBEu+XFYUkHY5pfx7P0fke7Lm33xaa8gIglmmFR/7yxuK82k1UUONsxbvBjCLu3d7xnjjRYEpA/g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG6c3PrraOHs10VJ748jXQL/OC0GQcv/lYG2+4YOamKz7bEhPl
	bYb+5L3ZPnMAk2hGMPrXefsb45bcCc1GEh120HJkHlG03gwmg9MdvHXY
X-Gm-Gg: ATEYQzxF1xfndOaKigexXbgf/xzmbbO69pXgiqJ4gPEmG8I1Ppu/PShqvbwaU3IwuNm
	8KAlX+aoDweWIAtIyM6LqUzwqDnS/SKpmabNRrC2YfIpXqGD5QFZ6I+u/cvtESRe+OuE6cgCrAh
	0SSPw219xlO6tSCraycBULbQ+nHYFtv+jhdUX7P1JvKHoNlQRuQdOyCKUoVGelFJs+rvcVa9hjJ
	M3SgCJMxCKxEAucraimy7+lWZ23euai8WHFY2Qu2olQyNpAwFZr/RPOSOW7czaiiu7FIlRNN/+g
	MsWzDP1e4z1/BzB8JcKreOojv2TBanq0m3qmWcdHaA221+InpeNQGKi5W7lIoBxDwTpB3H89OPz
	8dd9bxbmvm/aCW07W4Sp+Sm3XZ4dOIZbncnMHhR3xlrYGNfYvCjFbi5Q8htAtsuZ2eIh9DEuh8H
	KwEYFTvZtT7Kmdj9H9wH+fnoBiek11JwO5y5qkAJcsD7xm0ZYJtwicd7TDh7+KSABo3CdLIAbeM
	JUklsgkej+G
X-Received: by 2002:a05:6000:4287:b0:43b:634d:1a9e with SMTP id ffacd0b85a97d-43b889c505fmr14390229f8f.15.1774556300321;
        Thu, 26 Mar 2026 13:18:20 -0700 (PDT)
Received: from snowdrop.snailnet.com (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b9192e3e8sm11693016f8f.5.2026.03.26.13.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 13:18:20 -0700 (PDT)
From: david.laight.linux@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: David Laight <david.laight.linux@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH next] netfilter: nf_conntrack_h323: Correct indentation when H323_TRACE defined
Date: Thu, 26 Mar 2026 20:18:19 +0000
Message-Id: <20260326201819.3900-1-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

The trace lines are indented using PRINT("%*.s", xx, " ").
Userspace will treat this as "%*.0s" and will output no characters
when 'xx' is zero, the kernel treats it as "%*s" and will output
a single ' ' - which is probably what is intended.

Change all the formats to "%*s" removing the default precision.
This gives a single space indent when level is zero.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 38 +++++++++++++-------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 7b1497ed97d2..287402428975 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -276,7 +276,7 @@ static unsigned int get_uint(struct bitstr *bs, int b)
 static int decode_nul(struct bitstr *bs, const struct field_t *f,
                       char *base, int level)
 {
-	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
 	return H323_ERROR_NONE;
 }
@@ -284,7 +284,7 @@ static int decode_nul(struct bitstr *bs, const struct field_t *f,
 static int decode_bool(struct bitstr *bs, const struct field_t *f,
                        char *base, int level)
 {
-	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
 	INC_BIT(bs);
 	if (nf_h323_error_boundary(bs, 0, 0))
@@ -297,7 +297,7 @@ static int decode_oid(struct bitstr *bs, const struct field_t *f,
 {
 	int len;
 
-	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
 	BYTE_ALIGN(bs);
 	if (nf_h323_error_boundary(bs, 1, 0))
@@ -316,7 +316,7 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
 {
 	unsigned int len;
 
-	PRINT("%*.s%s", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s", level * TAB_SIZE, " ", f->name);
 
 	switch (f->sz) {
 	case BYTE:		/* Range == 256 */
@@ -363,7 +363,7 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
 static int decode_enum(struct bitstr *bs, const struct field_t *f,
                        char *base, int level)
 {
-	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
 	if ((f->attr & EXT) && get_bit(bs)) {
 		INC_BITS(bs, 7);
@@ -381,7 +381,7 @@ static int decode_bitstr(struct bitstr *bs, const struct field_t *f,
 {
 	unsigned int len;
 
-	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
 	BYTE_ALIGN(bs);
 	switch (f->sz) {
@@ -417,7 +417,7 @@ static int decode_numstr(struct bitstr *bs, const struct field_t *f,
 {
 	unsigned int len;
 
-	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
 	/* 2 <= Range <= 255 */
 	if (nf_h323_error_boundary(bs, 0, f->sz))
@@ -437,7 +437,7 @@ static int decode_octstr(struct bitstr *bs, const struct field_t *f,
 {
 	unsigned int len;
 
-	PRINT("%*.s%s", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s", level * TAB_SIZE, " ", f->name);
 
 	switch (f->sz) {
 	case FIXD:		/* Range == 1 */
@@ -490,7 +490,7 @@ static int decode_bmpstr(struct bitstr *bs, const struct field_t *f,
 {
 	unsigned int len;
 
-	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
 	switch (f->sz) {
 	case BYTE:		/* Range == 256 */
@@ -522,7 +522,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
 	const struct field_t *son;
 	unsigned char *beg = NULL;
 
-	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
 	/* Decode? */
 	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
@@ -544,7 +544,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
 	/* Decode the root components */
 	for (i = opt = 0, son = f->fields; i < f->lb; i++, son++) {
 		if (son->attr & STOP) {
-			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
+			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
 			      son->name);
 			return H323_ERROR_STOP;
 		}
@@ -562,7 +562,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
 			if (nf_h323_error_boundary(bs, len, 0))
 				return H323_ERROR_BOUND;
 			if (!base || !(son->attr & DECODE)) {
-				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,
+				PRINT("%*s%s\n", (level + 1) * TAB_SIZE,
 				      " ", son->name);
 				bs->cur += len;
 				continue;
@@ -615,7 +615,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
 		}
 
 		if (son->attr & STOP) {
-			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
+			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
 			      son->name);
 			return H323_ERROR_STOP;
 		}
@@ -629,7 +629,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
 		if (nf_h323_error_boundary(bs, len, 0))
 			return H323_ERROR_BOUND;
 		if (!base || !(son->attr & DECODE)) {
-			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
+			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
 			      son->name);
 			bs->cur += len;
 			continue;
@@ -655,7 +655,7 @@ static int decode_seqof(struct bitstr *bs, const struct field_t *f,
 	const struct field_t *son;
 	unsigned char *beg = NULL;
 
-	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
 	/* Decode? */
 	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
@@ -710,7 +710,7 @@ static int decode_seqof(struct bitstr *bs, const struct field_t *f,
 			if (nf_h323_error_boundary(bs, len, 0))
 				return H323_ERROR_BOUND;
 			if (!base || !(son->attr & DECODE)) {
-				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,
+				PRINT("%*s%s\n", (level + 1) * TAB_SIZE,
 				      " ", son->name);
 				bs->cur += len;
 				continue;
@@ -751,7 +751,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
 	const struct field_t *son;
 	unsigned char *beg = NULL;
 
-	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
+	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
 	/* Decode? */
 	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
@@ -792,7 +792,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
 	/* Transfer to son level */
 	son = &f->fields[type];
 	if (son->attr & STOP) {
-		PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ", son->name);
+		PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ", son->name);
 		return H323_ERROR_STOP;
 	}
 
@@ -804,7 +804,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
 		if (nf_h323_error_boundary(bs, len, 0))
 			return H323_ERROR_BOUND;
 		if (!base || !(son->attr & DECODE)) {
-			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
+			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
 			      son->name);
 			bs->cur += len;
 			return H323_ERROR_NONE;
-- 
2.39.5

