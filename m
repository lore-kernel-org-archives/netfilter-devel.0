Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D45335BB4
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769625075; cv=none; b=gp7J3P4lHDiPoo2PjLRzntGi2261iB0Mq+KnGu1TQmOhxokiHbzpT7QhCmyCP/2sU7pw9oEorc8/n+dZkmXSrdWtK4Q+0zT2B5w9k8LoX8ZIArmudM73tHRdDZJQwCpHW6TMxLhQ4Mrf4Epbn5TdCj8Jmca8JLKVFvlwGia28+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769625075; c=relaxed/simple;
	bh=MC0oViIujmF6Jq46J63XkB0tcYJnX8193pMM1L+VDRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3Qi9hlj5sNlWpsIFK5pmuenHUD4+85JWkoqLQjFbNizVki5YEtY9m/JhL5vsMjPFkr9cyMtXIQMPHjWu2DNISFV+DzaFBdfnHk5jYVYDSSukDR75/IvZmtqYwMZPNToo0zKhBzPlGbsAzEt10TLErLT7WPYvW5CSo/vmh4XK8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=buxMJ5gj; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="buxMJ5gj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ez0ChkvPD/tw9gLDZ1YF/kZlXyUQ7KjC+Gk0hdtRQ7s=; b=buxMJ5gjdbg5rCuR2prYmAQbkz
	SLOb7j2TdaAjcqUVvuHGyV6Wm+3Tz/GWnYXe1WeR7YzjKULlJSRl/7SwQPuaoQn/fO/fYPQUg81Rp
	Gtp6aXsMaKi5ODndSDjW92sedwdAUuEG+/WgM3+3ViEe+EGvsqh9fLFK5VX6gAxD3zoPRXyiR/Fy3
	PES+MK8si1v7CCCVE8b3rgoHgvineXk0oJmtg4im2TeN9FphX6kJP41HUfHb43Dme4N/m6sJEA9Ac
	75m3bwPDZeXlMpnJszS9P6Kpv1tlTeAhPMqp+Dqim6NW3BsoixqZzU3dwgYna9hMuFqRd38zxJ05N
	rqWLYUXw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vlAJt-0000000CCaf-0Kag;
	Wed, 28 Jan 2026 18:31:13 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc: Arnout Engelen <arnout@bzzt.net>,
	Philipp Bartsch <phil@grmr.de>
Subject: [PATCH nft 3/3] build: support `SOURCE_DATE_EPOCH` for build time-stamp
Date: Wed, 28 Jan 2026 18:31:07 +0000
Message-ID: <20260128183107.215838-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260128183107.215838-1-jeremy@azazel.net>
References: <20260128183107.215838-1-jeremy@azazel.net>
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

In order to support reproducible builds, set the build time-stamp to the value
of the environment variable, `SOURCE_DATE_EPOCH`, if set, and fall back to
calling `date`, otherwise.

Link: https://reproducible-builds.org/docs/source-date-epoch/
Fixes: 64c07e38f049 ("table: Embed creating nft version into userdata")
Reported-by: Arnout Engelen <arnout@bzzt.net>
Closes: https://github.com/NixOS/nixpkgs/issues/478048
Suggested-by: Philipp Bartsch <phil@grmr.de>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 9859072e9ae5..022608627908 100644
--- a/configure.ac
+++ b/configure.ac
@@ -149,7 +149,7 @@ AC_ARG_WITH([stable-release], [AS_HELP_STRING([--with-stable-release],
             [], [with_stable_release=0])
 AC_SUBST([STABLE_RELEASE],[$with_stable_release])
 AC_SUBST([NFT_VERSION], [$(echo "${VERSION}" | tr '.' ',')])
-AC_SUBST([BUILD_STAMP], [$(date +%s)])
+AC_SUBST([BUILD_STAMP], [${SOURCE_DATE_EPOCH:-$(date +%s)}])
 
 AC_ARG_ENABLE([distcheck],
 	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
-- 
2.51.0

