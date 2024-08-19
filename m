Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454FA158A33
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724105930; cv=none; b=inR2Ai2lo1YtQizBOciru/0Swp74BZTAGMZ/iyRvL8QY3SkhC9HwpBX9bROl5VEd6kFVjSTFgIynCMLcWAAUyPcYyn50dtwGpr0y1MMd+mwO3DCSLuUD5vtbFg8UhBRhlYqudR2RuMau/CADU/4WrcAiT1UAWI4ADrUcXcIL0tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724105930; c=relaxed/simple;
	bh=kdzatTk0v4luGpGNhnU2+bo6+JYcPdtWiqXP1LS99ww=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qTMhdEAOYncsXFRHepPivSzIN/bSKZct1EY+IrJRlIjElzkLoyKborYRD03hqH1k4h1DbqQxf3guHpnhVAoz+jmikZwTBja1WhLPusgqFOGCwPLGrQUh/0Rso5vsNRSJ4UPvZgBI4lrzS55FZoihFOf64ziY9h3UcQq6WR5AHRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] datatype: replace DTYPE_F_ALLOC by bitfield
Date: Tue, 20 Aug 2024 00:18:34 +0200
Message-Id: <20240819221834.972153-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240819221834.972153-1-pablo@netfilter.org>
References: <20240819221834.972153-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only user of the datatype flags field is DTYPE_F_ALLOC, replace it by
bitfield, squash byteorder to 8 bits which is sufficient.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h | 14 +++-----------
 src/datatype.c     |  8 ++++----
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 09b84eca27a7..df3bc3850b51 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -120,15 +120,6 @@ enum byteorder {
 
 struct expr;
 
-/**
- * enum datatype_flags
- *
- * @DTYPE_F_ALLOC:		datatype is dynamically allocated
- */
-enum datatype_flags {
-	DTYPE_F_ALLOC		= (1 << 0),
-};
-
 struct parse_ctx;
 /**
  * struct datatype
@@ -145,11 +136,12 @@ struct parse_ctx;
  * @print:	function to print a constant of this type
  * @parse:	function to parse a symbol and return an expression
  * @sym_tbl:	symbol table for this type
- * @refcnt:	reference counter (only for DTYPE_F_ALLOC)
+ * @refcnt:	reference counter (only for dynamically allocated, see .alloc)
  */
 struct datatype {
 	uint32_t			type;
-	enum byteorder			byteorder;
+	enum byteorder			byteorder:8;
+	uint32_t			alloc:1;
 	unsigned int			flags;
 	unsigned int			size;
 	unsigned int			subtypes;
diff --git a/src/datatype.c b/src/datatype.c
index 9293f38ed713..ea73eaf9a691 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1347,7 +1347,7 @@ static struct datatype *datatype_alloc(void)
 	struct datatype *dtype;
 
 	dtype = xzalloc(sizeof(*dtype));
-	dtype->flags = DTYPE_F_ALLOC;
+	dtype->alloc = 1;
 	dtype->refcnt = 1;
 
 	return dtype;
@@ -1359,7 +1359,7 @@ const struct datatype *datatype_get(const struct datatype *ptr)
 
 	if (!dtype)
 		return NULL;
-	if (!(dtype->flags & DTYPE_F_ALLOC))
+	if (!dtype->alloc)
 		return dtype;
 
 	dtype->refcnt++;
@@ -1389,7 +1389,7 @@ struct datatype *datatype_clone(const struct datatype *orig_dtype)
 	*dtype = *orig_dtype;
 	dtype->name = xstrdup(orig_dtype->name);
 	dtype->desc = xstrdup(orig_dtype->desc);
-	dtype->flags = DTYPE_F_ALLOC | orig_dtype->flags;
+	dtype->alloc = 1;
 	dtype->refcnt = 1;
 
 	return dtype;
@@ -1401,7 +1401,7 @@ void datatype_free(const struct datatype *ptr)
 
 	if (!dtype)
 		return;
-	if (!(dtype->flags & DTYPE_F_ALLOC))
+	if (!dtype->alloc)
 		return;
 
 	assert(dtype->refcnt != 0);
-- 
2.30.2

