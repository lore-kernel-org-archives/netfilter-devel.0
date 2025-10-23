Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07E429C328
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236088; cv=none; b=En8mpTpR8TvewiPDaX78oVYwB8JKOt5VT88m7EEGbJ/+sBwx6v3IOWblG0UnN3/s5vDzOE+StNI3gLETdcazBa5GPYqk1Wfvo9GFNSj4CgVYY/ficmgAIgo9CLq9UGMeEc6vp5Hwi5nEwK2x2uQaukdzMxHBctaMOzGNULddD1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236088; c=relaxed/simple;
	bh=3a0jxJKFGTDNyY+PrqPC5vC8Nts3oOTQ0dQHRFvg05g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MU+U5vVWVww50ZX23dBqXVPDbd0zjGVBtAu26d2HgqIHvDWC2MTEUbl/lp/kslmdXZ1KrGkIV0LvS0CpLCvvhmcgj6FKNcDgjt0KkSPbZzAJfinqsQl6cspK09BsJuzX5QiiW39/3EWnAlEASv5ltltdR3fhS3l6allu3XFtBBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mBlarRyZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mBlarRyZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2MHu2Q3eoYFJg4ytcU0GslievA11dMlxSSajrWF6N44=; b=mBlarRyZsfGjhOky1bm+UdWsSI
	1mch/Eyq4zuQm4JgJLS4/Qxp+QOEhZn0Li3oSN16h0KL055Y6JTsfQqmOuYNguDkiEcZdzgifaLIy
	G22sUpDaUTob/veTro/bjn/KZIL7YKMh3/85Daz6oCXlP5gF+s182cCiJ1aVOhkfXtgWrFkyhtI9c
	TLph+WcfRZ0EOudApGFdlOeBT2CmGKYm6YBcwHGIRHVcuAPwvJkUPD0CJjL03q0nfOFsVj01/SflS
	1pohf7TLSO0AyatcKR0gThyXo9lIrJhAVAu17YagtcJkGNX8hiUY6cWw1XIre3aVW8RH0GfhSOkjT
	eMu0cnMA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxc-0000000006j-3SGE;
	Thu, 23 Oct 2025 18:14:45 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 22/28] mergesort: Linearize concatentations in network byte order
Date: Thu, 23 Oct 2025 18:14:11 +0200
Message-ID: <20251023161417.13228-23-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Results are more stable this way.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mergesort.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/mergesort.c b/src/mergesort.c
index bd1c21877b21d..95037e5be8608 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -20,11 +20,11 @@ static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
 
 	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
 		ilen = div_round_up(i->len, BITS_PER_BYTE);
-		mpz_export_data(data + len, i->value, i->byteorder, ilen);
+		mpz_export_data(data + len, i->value, BYTEORDER_BIG_ENDIAN, ilen);
 		len += ilen;
 	}
 
-	mpz_import_data(value, data, BYTEORDER_HOST_ENDIAN, len);
+	mpz_import_data(value, data, BYTEORDER_BIG_ENDIAN, len);
 }
 
 static mpz_srcptr expr_msort_value(const struct expr *expr, mpz_t value)
-- 
2.51.0

