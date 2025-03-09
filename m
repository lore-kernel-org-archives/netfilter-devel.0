Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834481DE2C4
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Mar 2025 16:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741538521; cv=none; b=u2ZNmEB3Gz57x4FqLvcPxuCJxdhedmJ9bwzxCgYLC+Bz1uWoszwdFpqNZ7WspBIyCb5xpQR52OV6Z7FbO3FVFnn6v1ocUHYqsN/twAXg70BBmjqdx+ypRZcBUhDg5ABzwDo40HuIjIVkQPhu+1+vlRJrXej2c1N2DQTvjNBFrxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741538521; c=relaxed/simple;
	bh=g851HTn56Uv7Bhdy42p6hqyfZX4hu9JJKZ8UIq8WRyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nF685nCZVfpTwfQ1e89zaZr/XliYQApiDwqOIR8MG/bI9fPRReVUoIRWOQBvD/qH5Q6yaAZECoqD3Pv6BY6ajNw1R4dYKXVetua0Q9ssl/j47iojNs7QCybRS0ReAd7ifi1uZzcOe0lnzyVX9svTUdHT2zwIGmZEQGxb3zdJ75c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=nEXEQcCs; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="nEXEQcCs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xgICI/qvCkxHhbv3FMnt1FsF10i4GvHl/nCY4hApCVA=; b=nEXEQcCs3Qxtv5AyZQMZChmAWs
	gwjJgyLxpuzKM9HhCoRJv7nZnIX/ef7EXiJ420VCIfUrK9OeWx6C0Leg7d8dwPVHxb7gl7GCuY31r
	XB8U02231kU6QjIiR+HuTtxeTA/BZLEbsthoA0eYT2E5NJHvavLsS5FJ+17BVlEVWY/MRzsPFhHCs
	PdPqemkYR8yeK5vHVdXew58woKQPAHC3FdmpmyiWSkyEoDqJq/2gBZTpb835aJcVFIpJs1X5k4mlZ
	9hQU4Sf/X6fgNuhQB/zxWUBHMU29ilKvEnoVDGYuoky/jVFCuIKoDGjxq42VYbeAv20wFhMDexMoN
	FN+RNZjQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1trJip-00GJEH-1L;
	Sun, 09 Mar 2025 16:41:51 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 1/2] build: fix inclusion of Makefile.extra
Date: Sun,  9 Mar 2025 16:41:27 +0000
Message-ID: <20250309164131.1890225-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250309164131.1890225-1-jeremy@azazel.net>
References: <20250309164131.1890225-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Commit 08a16d90ceae ("build: use `$(top_srcdir)` when including Makefile.extra")
replaces hard-coded relative paths used to include Makefile.extra with
variables.  However, despite the commit message, the variables are enclosed with
braces, not parentheses, and it transpires that automake does not support the
use of braces in this context.  As a result, Makefile.extra is not included, and
the libxt_ACCOUNT.so and libxt_pknock.so extensions are not built.

Use parentheses instead.

Link: https://bugs.launchpad.net/ubuntu/+source/xtables-addons/+bug/2080528
Fixes: 08a16d90ceae ("build: use `$(top_srcdir)` when including Makefile.extra")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/ACCOUNT/Makefile.am | 2 +-
 extensions/Makefile.am         | 2 +-
 extensions/pknock/Makefile.am  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/ACCOUNT/Makefile.am b/extensions/ACCOUNT/Makefile.am
index 2514386f00b8..473a739f981a 100644
--- a/extensions/ACCOUNT/Makefile.am
+++ b/extensions/ACCOUNT/Makefile.am
@@ -3,7 +3,7 @@
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${abs_top_srcdir}/extensions
 AM_CFLAGS   = ${regular_CFLAGS} ${libxtables_CFLAGS}
 
-include ${top_srcdir}/Makefile.extra
+include $(top_srcdir)/Makefile.extra
 
 sbin_PROGRAMS = iptaccount
 iptaccount_LDADD = libxt_ACCOUNT_cl.la
diff --git a/extensions/Makefile.am b/extensions/Makefile.am
index 8f0aeb5666da..b99712dfcd38 100644
--- a/extensions/Makefile.am
+++ b/extensions/Makefile.am
@@ -26,4 +26,4 @@ install-exec-local: modules_install
 
 clean-local: clean_modules
 
-include ${top_srcdir}/Makefile.extra
+include $(top_srcdir)/Makefile.extra
diff --git a/extensions/pknock/Makefile.am b/extensions/pknock/Makefile.am
index 1ca5f91025b7..5fcae4794230 100644
--- a/extensions/pknock/Makefile.am
+++ b/extensions/pknock/Makefile.am
@@ -3,7 +3,7 @@
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${abs_top_srcdir}/extensions
 AM_CFLAGS   = ${regular_CFLAGS} ${libxtables_CFLAGS}
 
-include ${top_srcdir}/Makefile.extra
+include $(top_srcdir)/Makefile.extra
 
 sbin_PROGRAMS = pknlusr
 dist_man_MANS = pknlusr.8
-- 
2.47.2

