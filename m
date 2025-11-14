Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF39A927
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 00:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079958; cv=none; b=FRBjn3s8fN0SxlG+0mYSNpWY1juCnm7VK7+cOuSJOw6eBcUzwKG5nqBeykkMMqmTY+I9yMJ8BE3QjeFLVJcaJrq/W59wzddzVik6lcyhtxnopEUPMmIYB7NHIPw+SI++cfIE08iRjzioodspmcksa/JcxRmrgrfX16Zyak/d7uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079958; c=relaxed/simple;
	bh=6ToGgk8ScUOoFPjunf9b9xdfXCvvk/ZT2h2Srpz/OBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMEMLoW/mJNsWKJ76VdHjq5/h4tWGGjpStOfpDKGyhefupITVbReziQZ9NgW6tSH5VCz2yeZi5bK6urBsV0U+T5R5sd8q4mV78MlZxUA38jDl2+5MpQbh7RkFo9a3Fx/OesVHWh7ONhMf6yC1Hi7eclrXSjIXzsJ3U1JF5EWz7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WAfYhmmc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WAfYhmmc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QYa2BqO0No84c4npGuo8Vh3PSVa5xYelLh9qaX+7d0o=; b=WAfYhmmc1iYtgJEf7JAngU9A2a
	M5H+Z/+vFnZzVtQWZkCtn7SDLIHlv6PqLBUfhEs1oPKUJhy0/Fsr3BUwr5E9DDvcix3dclJE1JeOn
	eR0ARbwz7djoLEMlu7lS9q2KZ/j3bCnrEPxQhBbVggbuDdYGxdUgy2VD81+R2CS/VtqpXWUpyRgLn
	8IbrLxMBPLYVHksCrncvRj1tncVvRoOZtVesz4nnXu7xu46TkkaQj7BHR8C256kZUghyFfL9TAfI1
	DPrPFvxhbdA5+/dx/zP1tJhEVXVjdT47vAz5MnVGWTsc81RxthVEi4vVLDPVFOZZwHA8+QqZ46dcz
	JOpE3Zsw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJhdT-000000005kX-2ZlI;
	Fri, 14 Nov 2025 01:25:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 04/11] intervals: Convert byte order implicitly
Date: Fri, 14 Nov 2025 01:25:35 +0100
Message-ID: <20251114002542.22667-5-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251114002542.22667-1-phil@nwl.cc>
References: <20251114002542.22667-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When converting ranges to intervals, the latter's high and low values
must be in network byte order. Instead of creating the low/high constant
expressions with host byte order and converting the value, create them
with Big Endian and keep the value as is. Upon export, Little Endian MPZ
values will be byte-swapped by mpz_export_data() if BYTEORDER_BIG_ENDIAN
is passed.

The benefit of this is that value's byteorder may be communicated to
libnftnl later by looking at struct expr::byteorder field. By the time
this information is required during netlink serialization, there is no
other indicator for data byte order available.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/intervals.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 40ab42832fd9e..29e8fab8172a1 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -798,11 +798,8 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 	}
 
 	low = constant_expr_alloc(&key->location, set->key->dtype,
-				  set->key->byteorder, set->key->len, NULL);
-
+				  BYTEORDER_BIG_ENDIAN, set->key->len, NULL);
 	mpz_set(low->value, key->range.low);
-	if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
-		mpz_switch_byteorder(low->value, set->key->len / BITS_PER_BYTE);
 
 	low = set_elem_expr_alloc(&key->location, low);
 	set_elem_expr_copy(low, interval_expr_key(elem));
@@ -824,12 +821,11 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 	}
 
 	high = constant_expr_alloc(&key->location, set->key->dtype,
-				   set->key->byteorder, set->key->len,
+				   BYTEORDER_BIG_ENDIAN, set->key->len,
 				   NULL);
 	mpz_set(high->value, key->range.high);
 	mpz_add_ui(high->value, high->value, 1);
-	if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
-		mpz_switch_byteorder(high->value, set->key->len / BITS_PER_BYTE);
+	high->byteorder = BYTEORDER_BIG_ENDIAN;
 
 	high = set_elem_expr_alloc(&key->location, high);
 
-- 
2.51.0

