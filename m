Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C537B19DFA2
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 12:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738067453; cv=none; b=XWUoWzciFo7WBHETeDG+95M5fiuTlEbGgi1x4lZji0FWxvWuLY3bQIh5g2rtOdC8f9Ob61e0mT3xaO4PExxLpL9OJdZBZd25tAVcA2UiblhXCln3tVJ3UyDZp5MdI/t/jtyBcnCo4WpC4ZelVASJxhlMXebWvFIbLtAgnll3aPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738067453; c=relaxed/simple;
	bh=KefN3Zyr2xTOSwQ5X18JgI0HPgdj74J+uKTXB4iuL2A=;
	h=Message-Id:To:From:Date:Subject; b=HYMvZqOgFqBze2LY3968RyqwK3k42rJX21Sc2q7eLwu9WZUCB+J9wPK3za59j/Zzh3kajk25XZ+fq832kXWzmRHhNjGiUP3wUv+FqT9wySHWMwRKW9dM4+xlVwZwtwvaig+FC7poZS9O1KSi0Sjzf9ZSuw6Yx3E2GXdf3jVRNGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=YAOf+nr4; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="YAOf+nr4"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id 60F147D32E
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 13:30:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1738067441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc; bh=3LcMvc8Bhutu5kE8Tr/EJi3MuZiVLG/d4G2DQ1eAg04=;
	b=YAOf+nr4KLISDXjsUqq8/icPhIIJLOJuu8pWqv12yLoRylUWOL8gNJOQ0Q9PsDB1HULoLV
	Bib2Cndr38vCQ/mSji3ZeKYakkhIB+DRte/V0in2CZChTeCUChO7wXXspSi5fbfKlPNqfW
	XHUr2XJbguo+1BRT9y+Kv7YfzQVXNSw=
Message-Id: <D7DPHJ1SMOH5.PYG2FTMQM1YQ@pwned.life>
To: <netfilter-devel@vger.kernel.org>
From: "Achill Gilgenast" <fossdd@pwned.life>
Date: Tue, 28 Jan 2025 13:28:48 +0100
Subject: [PATCH v2] configure: Avoid addition assignment operators
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

For compatability with other /bin/sh like busybox ash, since they don't
support the addition assignment operators (+=) and otherwise fails with:

	./configure: line 14174: regular_CFLAGS+= -D__UAPI_DEF_ETHHDR=0: not found

Signed-off-by: Achill Gilgenast <fossdd@pwned.life>
---
 configure.ac | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 2d38a4d4..0106b316 100644
--- a/configure.ac
+++ b/configure.ac
@@ -202,8 +202,8 @@ fi;
 pkgdatadir='${datadir}/xtables';
 
 if test "x$enable_profiling" = "xyes"; then
-	regular_CFLAGS+=" -fprofile-arcs -ftest-coverage"
-	regular_LDFLAGS+=" -lgcov --coverage"
+	regular_CFLAGS="$regular_CFLAGS -fprofile-arcs -ftest-coverage"
+	regular_LDFLAGS="$regular_LDFLAGS -lgcov --coverage"
 fi
 
 AC_MSG_CHECKING([whether the build is using musl-libc])
@@ -222,7 +222,7 @@ AC_COMPILE_IFELSE(
 AC_MSG_RESULT([${enable_musl_build}])
 
 if test "x$enable_musl_build" = "xyes"; then
-	regular_CFLAGS+=" -D__UAPI_DEF_ETHHDR=0"
+	regular_CFLAGS="$regular_CFLAGS -D__UAPI_DEF_ETHHDR=0"
 fi
 
 define([EXPAND_VARIABLE],

base-commit: b3f3e256c263b9a1db49732696aba0dde084ef5e
-- 
2.48.1
