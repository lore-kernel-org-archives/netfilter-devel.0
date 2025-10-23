Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FC5261B9C
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235570; cv=none; b=pymk/1xzfxNAodiFFhsGZ/d1Rvbx114y3zoki35XWkEFcz+Xby7dO+Y8NutFZ45QpSjW1EEOtJ5EoAjMVKolz8wuFfo5jSMc8eaQD8JpVhT6ODFfrO+IsuSYRQNoq2y5ya2olhI9ah3TYk8kNC/LFqvLKeSpYbi57DvGesl4XR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235570; c=relaxed/simple;
	bh=e2ZcW/yryWqP0UbEBMT6KC4mF4wMP2mIHH8RBOJrJnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyj/6fOeYyMGuhvo3Jvp0nmcTeZT53XniREAa+7fu5/IpgBL6cGlErapMRTn+uQyRWr50UtWSgRvO5VT8x+ZtUWeU50Tv46uRCsPWX+NOqVfIX1fOah3rQOMFFd9O+I1DYHT4FyYWONOkMQDrV10SKKeKKmyGhPn16voTPUlW20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GCw/ZZx7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GCw/ZZx7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pkszUg1RO52uGV9H2oPhYXCAlNJEV2DGs88AHGcaDTs=; b=GCw/ZZx7VzItOFEDOAlB9OK1Tp
	2AaLQly0oaAKqxGdHaazgGOCOniQ7TAlD5FZNw1B+ERRGS6T6sRhvJnMUnS37oxr+b5bZNhCu5k3W
	0L87oi0uFsRXWk/inZueviNDglqrLhZ8y3dkRSthQugAteS6mwS7loivSh9ruPOFN2gUTEx6qe8E/
	hZHYvawZxMkcgPGNChPDAfuASXqRcm7Udpdzj2OnMfHts2w9gLEbfmCWrYdbDXincU0j4lcCOuVWJ
	J3ubPlo/fIA96xstxroAPYvmmZ7b9Eg7T4H920vDDV5dSwX8ffRR9lRqm7aJJOHUByZv0RKk8k4AW
	1H0uroNw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxpA-000000007dL-3eaa;
	Thu, 23 Oct 2025 18:06:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 9/9] udata: Store u32 udata values in Big Endian
Date: Thu, 23 Oct 2025 18:05:47 +0200
Message-ID: <20251023160547.10928-10-phil@nwl.cc>
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

Avoid deviation of this data in between different byte orders. Assume
that direct callers of nftnl_udata_put() know what they do.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/udata.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/udata.c b/src/udata.c
index a1956571ef5fd..8cf4e7ca61e2f 100644
--- a/src/udata.c
+++ b/src/udata.c
@@ -8,6 +8,7 @@
 #include <udata.h>
 #include <utils.h>
 
+#include <arpa/inet.h>
 #include <stdlib.h>
 #include <stdint.h>
 #include <string.h>
@@ -100,7 +101,9 @@ EXPORT_SYMBOL(nftnl_udata_put_u32);
 bool nftnl_udata_put_u32(struct nftnl_udata_buf *buf, uint8_t type,
 			 uint32_t data)
 {
-	return nftnl_udata_put(buf, type, sizeof(data), &data);
+	uint32_t data_be = htonl(data);
+
+	return nftnl_udata_put(buf, type, sizeof(data_be), &data_be);
 }
 
 EXPORT_SYMBOL(nftnl_udata_type);
@@ -128,7 +131,7 @@ uint32_t nftnl_udata_get_u32(const struct nftnl_udata *attr)
 
 	memcpy(&data, attr->value, sizeof(data));
 
-	return data;
+	return ntohl(data);
 }
 
 EXPORT_SYMBOL(nftnl_udata_next);
-- 
2.51.0

