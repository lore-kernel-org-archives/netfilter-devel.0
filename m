Received: from mail.pavluk.org (n59-c78.client.tomica.ru [78.140.59.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B091386B3
	for <netfilter-devel@vger.kernel.org>; Sat, 10 Aug 2024 19:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.140.59.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723317412; cv=none; b=fItbwRjsAchxnvnk2SLd1wf7sD4wnyoab6vL83Qb0izlSbKUmHFb2upYd7hBSiwf0mqlQGHh6jc1edFIqlSwWlE/Vfy0fMLJ8DazNsPWt8mIbiMiGmNKUIV5p8sxNuCaF5W6XqcnxP6a0ihooQI4knmPTMW6luDLg86yriCn0Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723317412; c=relaxed/simple;
	bh=h7S89CqCzrAhUn6DfgRAodl/bYVXySGw/cMutmxFMMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G4EvMETuQ87Z+gG88pZsEz1vXw6+723oheIas8ckZ1A+KWDBeT6gE/AItjbzJwXKYdhmKrIz3FqQD91X3VWW4joLR5PDodXLdKL8twJNg8Q4k2Dh46xFmM/DaTXDT3MSoEDcpD3rhU3U8Yms37pM36iyO8bRQhOfE/ZQS/K4V/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pavluk.org; spf=pass smtp.mailfrom=pavluk.org; dkim=pass (1024-bit key) header.d=pavluk.org header.i=@pavluk.org header.b=K6YwlP33; arc=none smtp.client-ip=78.140.59.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pavluk.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pavluk.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pavluk.org header.i=@pavluk.org header.b="K6YwlP33"
From: chayleaf <chayleaf-git@pavluk.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pavluk.org; s=mail;
	t=1723316794; bh=mg/zuAjc6sqib3+7v4cw5/S0djipYCAwYcLKfHLP/ok=;
	h=From:To:Cc:Subject:Date;
	b=K6YwlP33DMZW/VwmdwINcEMcGfoRTqWPffUh9NNsHK4dv3tiFNa4q+785BwDK1cYo
	 qS1TWVR6BqqthfjIaNa2SPtl2diKR26n7I5KsEYC6uqKhBJWir1569IYoPvuiMZU2K
	 f+XdffYDkOSXlOdYkvoaOBZEBIPiH4iVkTAtS4ZM=
To: netfilter-devel@vger.kernel.org
Cc: chayleaf <chayleaf-git@pavluk.org>
Subject: [PATCH libnftnl] set: export nftnl_set_clone
Date: Sun, 11 Aug 2024 02:05:37 +0700
Message-ID: <20240810190605.1215981-1-chayleaf-git@pavluk.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is present in libnftnl/set.h, so this has to either be exported or
removed from the header.

Signed-off-by: chayleaf <chayleaf-git@pavluk.org>
---
 src/libnftnl.map | 1 +
 src/set.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/src/libnftnl.map b/src/libnftnl.map
index 8fffff1..3f660de 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -129,6 +129,7 @@ global:
   nftnl_set_get_str;
   nftnl_set_get_u32;
   nftnl_set_get_u64;
+  nftnl_set_clone;
   nftnl_set_nlmsg_build_payload;
   nftnl_set_nlmsg_parse;
   nftnl_set_parse;
diff --git a/src/set.c b/src/set.c
index 07e332d..c5f9518 100644
--- a/src/set.c
+++ b/src/set.c
@@ -352,6 +352,7 @@ uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
 	return val ? *val : 0;
 }
 
+EXPORT_SYMBOL(nftnl_set_clone);
 struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set)
 {
 	struct nftnl_set *newset;
-- 
2.44.1

