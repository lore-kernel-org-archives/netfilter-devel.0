Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CC8F9D6
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 02:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707271967; cv=none; b=iZ2E7c+0wysgyClm07GmgY6NlHA21sXMeTjwFSUcgu1fCvpDQFrvuDapmNvbKYVZh/BA90+YKcUwErcvhfloSbfwICxH8QEd/5w/crbl9rKHePOOPgKfRBZZDwnAxtAhRCkh6Zw708FaBr+sJBaJPujd2BJsNBMzYdR/LIJxA4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707271967; c=relaxed/simple;
	bh=pS9jDqmQuQgejcOHhuSDbxbXVqMg9jMunSbUpTdhLl4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H6P1/zZ+12UzJgJpVDhR2jy79PEOHmhd6OfE7FUQd7xmIpBu8GIVc8R2ABca7YldsY+71OAazGCKWYF+la/lSedAj3RHBoKNahVsAQNUv5+XM8KgMB2IoL/VsxL0umXQajyFk0FlryFfmZ0qZxq5akZd19VmIqTjwCezi84Qxzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: netfilter-devel@vger.kernel.org
Cc: Sam James <sam@gentoo.org>
Subject: [PATCH] Makefile.am: don't silence -Wimplicit-function-declaration
Date: Wed,  7 Feb 2024 02:12:35 +0000
Message-ID: <20240207021236.46118-1-sam@gentoo.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This becomes an error in GCC 14 and Clang 16. It's a common misconception that
these warnings are invalid or simply noise for Bison/parser files, but even if
that were true, we'd need to handle it somehow anyway. Silencing them does nothing,
so stop doing that.

Further, I don't actually get any warnings to fix with bison-3.8.2. This mirrors
changes we've done in other netfilter.org projects.

Signed-off-by: Sam James <sam@gentoo.org>
---
 Makefile.am | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 0ed831a1..688a9849 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -170,7 +170,6 @@ src_libparser_la_SOURCES = \
 
 src_libparser_la_CFLAGS = \
 	$(AM_CFLAGS) \
-	-Wno-implicit-function-declaration \
 	-Wno-missing-declarations \
 	-Wno-missing-prototypes \
 	-Wno-nested-externs \
-- 
2.43.0

