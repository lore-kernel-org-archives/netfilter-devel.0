Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE041DDC3F
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 22:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757369965; cv=none; b=rrt6ptVqJ8UIScfQG0SbPa0TJSMXSp+zL5zjz6SlxjPavgdxhHj2+yT//Z/vbwDHlDMRTvQAIZcYiI5TfuoAHXHXoZ/3UQQv70C0Lq3S7RgJhubZX6Lf1WFIUYCTwXOYPuutUXnGe7X3Vn5WZPjg4drKb0VIfSDkPLXE2XGoiQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757369965; c=relaxed/simple;
	bh=FzJ2BNYDZU7yA+0akbo7wNXsNdMdzbVhlsYI7go0A0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dyEAlisQ0cOsK03ia7c8p/m84FC2VwrejRn40FsdgG+z3tt2xz98a6dAsZrJeMIb8ypDdUwdvdl5AJrU31rYWdaRCMIPe5oHDJLRNSCa2Dq1XlE/Pg4uJJMB52oXPRZz/5f0nFvG2OTKti+vzwoCHDbvNpAETLle+bSPOCdYb7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=g/s+5wKC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="g/s+5wKC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=k2aYStaDGcY/K+LM5/3f9sparn3eV3PhYRxYeuR9QLE=; b=g/s+5wKCl56oH2D2kL/DFDmo3N
	iaEdehhvVVK21IBjGJNn4ELs6ZaTLMG0NyAzFuMOeD+We16pBp4cnVB8VwZ9g6aVWbA3rE6VQICHe
	Fybg/UP/po1qU2nmYfxp0L4KQdQW8R9ZEnU6oFa4/Yq7OZML51ymkO6ISK+vI254CM6WBYLul+xXD
	UyMqx4IfJ7HfacRBWgkcJ5k81evg5iMI6yePFnlZs1nlm1EhWhTf0JLfDZk9GPRQNehtX3lFTZoZw
	H1MbrwqPAYq5XWfqMJGt7Wr6KJXAXVBoVeqrwL+QZSmvMtMTUcUs3lzgvpvLCqnCzuZA74b6tYOid
	MLAEyKrg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uvkCg-0000000012M-2YXS;
	Tue, 09 Sep 2025 00:19:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] Makefile: Fix for 'make CFLAGS=...'
Date: Tue,  9 Sep 2025 00:19:09 +0200
Message-ID: <20250908221909.31384-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Appending to CFLAGS from configure.ac like this was too naive, passing
custom CFLAGS in make arguments overwrites it. Extend AM_CFLAGS instead.

Fixes: 64c07e38f0494 ("table: Embed creating nft version into userdata")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am  | 2 ++
 configure.ac | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 5190a49ae69f1..3e3f1e61092bb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -156,6 +156,8 @@ AM_CFLAGS = \
 	\
 	$(GCC_FVISIBILITY_HIDDEN) \
 	\
+	-DMAKE_STAMP=$(MAKE_STAMP) \
+	\
 	$(NULL)
 
 AM_YFLAGS = -d -Wno-yacc
diff --git a/configure.ac b/configure.ac
index da16a6e257c91..3517ea041f7ea 100644
--- a/configure.ac
+++ b/configure.ac
@@ -153,7 +153,6 @@ AC_CONFIG_COMMANDS([nftversion.h], [
 # Current date should be fetched exactly once per build,
 # so have 'make' call date and pass the value to every 'gcc' call
 AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
-CFLAGS="${CFLAGS} -DMAKE_STAMP=\${MAKE_STAMP}"
 
 AC_CONFIG_FILES([					\
 		Makefile				\
-- 
2.51.0

