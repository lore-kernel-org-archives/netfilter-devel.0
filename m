Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4826E1F94A
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736781803; cv=none; b=OnK2yG/TAc1QTXcVBu1TkFi0wlMPuhH1piu2sHywLcVBE+8mRRWyrbdbrqRnu2iw83B89ZIVGdYFnW0ovXAdS8xqubxFppMWTAglgOhW9IcP/MesBu/OJgZ7vT9Dhup0pq54vnZSZotH4wcAj0mOJnNiTMP7tFFX+dCqtqNCnuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736781803; c=relaxed/simple;
	bh=7kltqEQGrEM3aYCciSbMv5Kw0vMsT+euNjj2QwuTrks=;
	h=Message-Id:To:From:Date:Subject; b=rLr5zdK46qd7SeDEPgfxDw0jMtFdL6SvF33gAOvAXyEEDspszKT6DiJwUA+gEYe/0u0jT5U04J5tL6X3YD8gpmVuQYVYhB9uHYzCWJfaVCT7VCwd65k/bUUIfZ29ifuRF0f3LhXI7x34QmN692T+/vtjQFvWe0+b1nmCO+EbhF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=TB719rZA; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="TB719rZA"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id A42227D32E
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 16:23:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1736781800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc; bh=zP0nAK2jw36oMStxxT5fm6iQyHCSltZw1YC3i5vUN/4=;
	b=TB719rZAPjMrIUMbjhRrS38dDH9vVOZJJnRWL9+Nj7iDMgY6wUFa28rIx0EjEIo+gXAoKk
	hXmEWChLB6Mt9TKmT5klikbGb9sc0wcifpLCnAGc1NhLKwnKIDT4ChoE+fpfVzevvVypd4
	xy3AqgQW6RocNmEIS4oD8NTQBEdjAUU=
Message-Id: <D711RJX8FZM8.1ZZRJ5PYBRMID@pwned.life>
To: <netfilter-devel@vger.kernel.org>
From: "fossdd" <fossdd@pwned.life>
Date: Mon, 13 Jan 2025 16:08:34 +0100
Subject: [PATCH] configure: Avoid addition assignment operators
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

For compatability with other /bin/sh like busybox ash, since they don't
support the addition assignment operators (+=) and otherwise fail with:

	./configure: line 14174: regular_CFLAGS+= -D__UAPI_DEF_ETHHDR=0: not found

Signed-off-by: fossdd <fossdd@pwned.life>
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
2.48.0
