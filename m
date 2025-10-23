Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A058327978C
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235578; cv=none; b=C5hJdySNc6GQ+z9F9AvD3Co7WzQG2u0I21b4GzgpxHx4UeVH6/8TuCNI7ppHK8kkFfwctuL2CYLz9ewCQu75R/F3s1vMBAIpvKp/DbrJXsPOtxm6BuGlmA+J0O70QDUMnGTdGfm+FDXRU9R14eOSO3OC2u6OUVM7pObd+d0aHG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235578; c=relaxed/simple;
	bh=SLQw6y5bD0Md0jIu4baVTSmKCvwpCar4noNOutfreVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Az2vESWZ/NGjcsmHHV2oRXBUIkdnJVaNgdSDpSlvbSQCuET9V+LgkEUaQt7kfwucH4aX7sekP4+dzR3Mox7JnnEvyGoynlo0LjUdQBw3MxtlTrpeJfu3kt1e6s/16AEaALGeVuVD7t6JWdJWsZLoKmVUBqssazUCf4UWqOWVHyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Tny4f0QJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Tny4f0QJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5eYNBj41dAU24avyTL3HyxgRW6Yx+oPkft2ia841TUY=; b=Tny4f0QJNpddvU5gD8y8aDEsvP
	o8iyerg9uLsxGS1R213cbsf8A5s6ihzyFozEAg9OIriyoR4TCQ3Ac4Z/LWL4/vXgdkISvNY62o091
	dOPDClk5QcOBsiabhUKbllpx96UGm5ufLsEpfE8ARltYvwAaD09EkG8AXSKgoqbgDI4BQTTqG5RNm
	UY2+LuHz2TLzWwO1TiljnwkyOuSc8MStnIDVffk33vtXQK6inykQ/BlrPhlQOgmV6gYuu8DygJA5A
	lClgjpSKfRv9R1TjrzuIcogUqfiA8MBurZ8RLUuIcSXeSxFc7EBFp3YRU63YcnJWE38MWvDmz/Ech
	G/jklpLw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxpO-000000007fx-2dUi;
	Thu, 23 Oct 2025 18:06:15 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 1/9] set_elem: Review debug output
Date: Thu, 23 Oct 2025 18:05:39 +0200
Message-ID: <20251023160547.10928-2-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023160547.10928-1-phil@nwl.cc>
References: <20251023160547.10928-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

* Do not print a colon if no data part is present
* Include the object's name for objmap elements
* Print flags only if non-zero, but prefixed by 'flags' keyword to avoid
  confusion with data values

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/set_elem.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/src/set_elem.c b/src/set_elem.c
index 05220e7933242..6c1be44ce5073 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -687,7 +687,7 @@ int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type ty
 int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 				    const struct nftnl_set_elem *e)
 {
-	int ret, dregtype = DATA_VALUE, offset = 0, i;
+	int ret, dregtype = DATA_NONE, offset = 0, i;
 
 	ret = snprintf(buf, remain, "element ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
@@ -705,18 +705,29 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-	ret = snprintf(buf + offset, remain, " : ");
-	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-
-	if (e->flags & (1 << NFTNL_SET_ELEM_VERDICT))
+	if (e->flags & (1 << NFTNL_SET_ELEM_DATA))
+		dregtype = DATA_VALUE;
+	else if (e->flags & (1 << NFTNL_SET_ELEM_CHAIN))
+		dregtype = DATA_CHAIN;
+	else if (e->flags & (1 << NFTNL_SET_ELEM_VERDICT))
 		dregtype = DATA_VERDICT;
 
-	ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->data,
-				      DATA_F_NOPFX, dregtype);
-	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	if (dregtype != DATA_NONE) {
+		ret = snprintf(buf + offset, remain, " : ");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = snprintf(buf + offset, remain, "%u [end]", e->set_elem_flags);
-	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->data,
+					      DATA_F_NOPFX, dregtype);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	} else if (e->flags & (1 << NFTNL_SET_ELEM_OBJREF)) {
+		ret = snprintf(buf + offset, remain, " : %s ", e->objref);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
+
+	if (e->set_elem_flags) {
+		ret = snprintf(buf + offset, remain, "flags %u ", e->set_elem_flags);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
 
 	if (e->user.len) {
 		ret = snprintf(buf + offset, remain, "  userdata = { ");
-- 
2.51.0

