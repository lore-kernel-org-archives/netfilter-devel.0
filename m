Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5580A4175E
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ii5+ohQH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KN8244QfmMpeHf16RmxDx8A+zp87CpphPoy3OJ7/Z4w=; b=ii5+ohQHK2fWCWvhyg1sVng77x
	6UEGtE1OBhlRc0I5qZdKKM7wFaP+62wSpv49hGR5I8tDGFy7iYdaTK/+y6r0eTHFdnJtGawbCxGbP
	M3bpbSXWHqBWTVuhlqqze80wmSFZAmBq9afwzCji+F5zmxekPvFiNnpsC3eT1k/D11XTGMhIgbwUP
	rJdCmntskmPw81JJ0cZcBPGxZgPQh10SVaJniCcsP3IYXh261UImeotG9pLjY12R61CYXrU51uBq+
	u67W3LVlQtl64F1Y1TMf7ucN/UJQ0IE/WnACQVCnhMmCYEJvxyRzr2vLoYMncsklMyuJgBUGgqa5d
	gs6zfr8Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5r-0004Lg-Tm
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 02/23] libxtables: xtoptions: Support XTOPT_NBO with XTTYPE_UINT*
Date: Wed, 20 Dec 2023 17:06:15 +0100
Message-ID: <20231220160636.11778-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160636.11778-1-phil@nwl.cc>
References: <20231220160636.11778-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Value conversion into Big Endian byteorder is pretty straightforward,
merely needed a small helper for uint64.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtoptions.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 9694639188006..3973c807ded0e 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -147,6 +147,14 @@ static size_t xtopt_esize_by_type(enum xt_option_type type)
 	}
 }
 
+static uint64_t htonll(uint64_t val)
+{
+	uint32_t high = val >> 32;
+	uint32_t low = val & UINT32_MAX;
+
+	return (uint64_t)htonl(low) << 32 | htonl(high);
+}
+
 /**
  * Require a simple integer.
  */
@@ -174,14 +182,20 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 			*(uint8_t *)XTOPT_MKPTR(cb) = cb->val.u8;
 	} else if (entry->type == XTTYPE_UINT16) {
 		cb->val.u16 = value;
+		if (entry->flags & XTOPT_NBO)
+			cb->val.u16 = htons(cb->val.u16);
 		if (entry->flags & XTOPT_PUT)
 			*(uint16_t *)XTOPT_MKPTR(cb) = cb->val.u16;
 	} else if (entry->type == XTTYPE_UINT32) {
 		cb->val.u32 = value;
+		if (entry->flags & XTOPT_NBO)
+			cb->val.u32 = htonl(cb->val.u32);
 		if (entry->flags & XTOPT_PUT)
 			*(uint32_t *)XTOPT_MKPTR(cb) = cb->val.u32;
 	} else if (entry->type == XTTYPE_UINT64) {
 		cb->val.u64 = value;
+		if (entry->flags & XTOPT_NBO)
+			cb->val.u64 = htonll(cb->val.u64);
 		if (entry->flags & XTOPT_PUT)
 			*(uint64_t *)XTOPT_MKPTR(cb) = cb->val.u64;
 	}
@@ -216,17 +230,25 @@ static void xtopt_parse_float(struct xt_option_call *cb)
 static void xtopt_mint_value_to_cb(struct xt_option_call *cb, uintmax_t value)
 {
 	const struct xt_option_entry *entry = cb->entry;
+	int i = cb->nvals;
 
-	if (cb->nvals >= ARRAY_SIZE(cb->val.u32_range))
+	if (i >= ARRAY_SIZE(cb->val.u32_range))
 		return;
-	if (entry->type == XTTYPE_UINT8RC)
-		cb->val.u8_range[cb->nvals] = value;
-	else if (entry->type == XTTYPE_UINT16RC)
-		cb->val.u16_range[cb->nvals] = value;
-	else if (entry->type == XTTYPE_UINT32RC)
-		cb->val.u32_range[cb->nvals] = value;
-	else if (entry->type == XTTYPE_UINT64RC)
-		cb->val.u64_range[cb->nvals] = value;
+	if (entry->type == XTTYPE_UINT8RC) {
+		cb->val.u8_range[i] = value;
+	} else if (entry->type == XTTYPE_UINT16RC) {
+		cb->val.u16_range[i] = value;
+		if (entry->flags & XTOPT_NBO)
+			cb->val.u16_range[i] = htons(cb->val.u16_range[i]);
+	} else if (entry->type == XTTYPE_UINT32RC) {
+		cb->val.u32_range[i] = value;
+		if (entry->flags & XTOPT_NBO)
+			cb->val.u32_range[i] = htonl(cb->val.u32_range[i]);
+	} else if (entry->type == XTTYPE_UINT64RC) {
+		cb->val.u64_range[i] = value;
+		if (entry->flags & XTOPT_NBO)
+			cb->val.u64_range[i] = htonll(cb->val.u64_range[i]);
+	}
 }
 
 /**
-- 
2.43.0

