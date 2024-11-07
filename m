Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC7E215F5A
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730995962; cv=none; b=Ti+Ov8E8LSgcwCkoUS6WGlLfOlA/4qN+4ScDkS08hfrs9L6OFN1ZQeqtOA0Ml6d592ziNF6hi4vsJ7usexkCDXhIZ2KgnT8MIt5Ct+bmU5iPbusG8PUrN8LTmrbknYMoVt6I/2WNvDemVIdq0a5e1K/ctZ7Ey9oIEyqVwteG+h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730995962; c=relaxed/simple;
	bh=hLjN4mcms6WWr8ZvOA+t8dRt+qTD9IZcR1HsbGR5+ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJQauYlTDro11EAWzpOS6rBzBfhAf3sooC5YqbAfiEydSBrAx7BE762ncAVUgdaawWuN2fZhiYyGEHdOQHaTSlfVQubJKuekudFcFqTrirgbG/rHN7Xw8eJnEExkV/JqdakX5RVLgNQpXk01IB62L1AswgEhfoBATsrD0TohH+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Qili8s8P; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Qili8s8P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9K2QKljc6Kydzkt6BnVspBTm2rQGaQ0vzdDf6G+uV74=; b=Qili8s8PW1ZUehMyDQTcndGxqs
	KAqgdaJrOZaBCg8eiWhgJy4+lEKcDIld35g9KrAoSSLWGtk6jjoTYYnHuO2JCyYOCiD8xMGkKwtmL
	sBmS8wddSPoSd7t6O4RQ0nQcYIO+NRXbEPUqy8ANWxi4r+qfnveX5LMIgwJlnGaDV+S2Cb8+aiYd7
	zNaGQHqBRkinHKKSOz7+tfaWCvAEG+mMFfMuXUXYmR7z9+QxHPa9lAhCblEpCBdRfv3JaDi8BiClB
	UP9+SY4F8a4QCHDr/pHmZNamCkZrc0pea/UatE9gNm1JHNPgI38nTUCKUbdybxZLo5jfd5X3g0k7b
	aPOhGQcw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t957c-000000003Wu-3TBg;
	Thu, 07 Nov 2024 17:12:36 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	coreteam@netfilter.org
Subject: [iptables PATCH] libxtables: Hide xtables_strtoul_base() symbol
Date: Thu,  7 Nov 2024 17:12:33 +0100
Message-ID: <20241107161233.22665-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <ZyzYApZKx79g8jqm@calendula>
References: <ZyzYApZKx79g8jqm@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are no external users, no need to promote it in xtables.h.

Fixes: 1af6984c57cce ("libxtables: Introduce xtables_strtoul_base()")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/Makefile.am        | 2 +-
 include/xtables.h          | 2 --
 include/xtables_internal.h | 7 +++++++
 libxtables/xtables.c       | 1 +
 libxtables/xtoptions.c     | 1 +
 5 files changed, 10 insertions(+), 3 deletions(-)
 create mode 100644 include/xtables_internal.h

diff --git a/include/Makefile.am b/include/Makefile.am
index 07c88b901e808..f3e480f72bf09 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -11,7 +11,7 @@ nobase_include_HEADERS = \
 	libiptc/ipt_kernel_headers.h libiptc/libiptc.h \
 	libiptc/libip6tc.h libiptc/libxtc.h libiptc/xtcshared.h
 
-EXTRA_DIST = iptables linux iptables.h ip6tables.h
+EXTRA_DIST = iptables linux iptables.h ip6tables.h xtables_internal.h
 
 uninstall-hook:
 	dir=${includedir}/libiptc; { \
diff --git a/include/xtables.h b/include/xtables.h
index ab856ebc426ac..9fdd8291e91b9 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -491,8 +491,6 @@ extern void xtables_register_matches(struct xtables_match *, unsigned int);
 extern void xtables_register_target(struct xtables_target *me);
 extern void xtables_register_targets(struct xtables_target *, unsigned int);
 
-extern bool xtables_strtoul_base(const char *, char **, uintmax_t *,
-	uintmax_t, uintmax_t, unsigned int);
 extern bool xtables_strtoul(const char *, char **, uintmax_t *,
 	uintmax_t, uintmax_t);
 extern bool xtables_strtoui(const char *, char **, unsigned int *,
diff --git a/include/xtables_internal.h b/include/xtables_internal.h
new file mode 100644
index 0000000000000..a87a40cc8dae5
--- /dev/null
+++ b/include/xtables_internal.h
@@ -0,0 +1,7 @@
+#ifndef XTABLES_INTERNAL_H
+#define XTABLES_INTERNAL_H 1
+
+extern bool xtables_strtoul_base(const char *, char **, uintmax_t *,
+	uintmax_t, uintmax_t, unsigned int);
+
+#endif /* XTABLES_INTERNAL_H */
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 7d54540b73b73..5fc50a63f380b 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -64,6 +64,7 @@
 #endif
 #include <getopt.h>
 #include "iptables/internal.h"
+#include "xtables_internal.h"
 
 #define NPROTO	255
 
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 774d0ee655ba7..64d6599af904b 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -21,6 +21,7 @@
 #include <arpa/inet.h>
 #include <netinet/ip.h>
 #include "xtables.h"
+#include "xtables_internal.h"
 #ifndef IPTOS_NORMALSVC
 #	define IPTOS_NORMALSVC 0
 #endif
-- 
2.47.0

