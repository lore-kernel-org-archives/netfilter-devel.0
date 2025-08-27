Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6743570D4
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 14:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756303345; cv=none; b=exD7iZ6R3TVQBIr0XrhHeD5YEwaJ5tNhFCUGdXCM8W2padaE3rEqckdU7LQBWvUprQ3I8uJq9RL9strh067+GHE5yYw17s32+kk1YMoKaVQ3rxaMBi+ckSJe9IQDLWtb12nnSmn1pCMFMDqH1TyxqHvzS0ASbTj/dUmr9L117Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756303345; c=relaxed/simple;
	bh=J64Acv0e7mShCE05cH0UuaAW6zudmW4nDgr6VfTYCTQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=nSWRPeKkSD5R/DvnKv/uONaYQO4a8bJ4cWxx9cKf8V15y9Pjt0lbo9W8w6XbFwxWD0gYk/FpmiVbqnasD1iJS8soVSADZvgjyiYWzOmPi7uBXftKsXTzCp2j58j5hfYwth/547TIX9vHgmkI2KMW9/HN7kU5f3Qq7tdfbvRpaHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Wd5SqYbz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BcxgGvsD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Wd5SqYbz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BcxgGvsD"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1AC1B60280; Wed, 27 Aug 2025 16:02:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756303340;
	bh=YCB9UQD2eK53Gr5Gxy2ojXng0cMVSkLcn4fTseKJ+o0=;
	h=From:To:Subject:Date:From;
	b=Wd5SqYbz3+yPTPbbX+lVwJrG4Yxi4/x4gvWcOGJsw30CymIPUMtWRE4PBHuCiSXwC
	 3YBz8FV3aauB5Zlz7NPKTGJchcncpbgbsMoYaG7p/S2lVWbfCB7BwYhOMT6QrG7lEe
	 4pdUmUf88M7K9FXEXKzV0IFXLDTLVetmxoQLnynC2KjhXggQjc34FMfArtcGlJ5X0A
	 Tghw7OSMyLs7xhhDkDgHnY9ZY4Q1oPvh2wkCTKIt9Gelhm0uOsf+cg0V7VmBIiavuo
	 WHdYC/+PUdf/Zi3gX3NqssT7/ExNeWqiQ3ICCcFZu5CuOvNuAMMkoZlFgO7RD8EbYk
	 DwkA/fEoZVNXg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 995ED6027E
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 16:02:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756303339;
	bh=YCB9UQD2eK53Gr5Gxy2ojXng0cMVSkLcn4fTseKJ+o0=;
	h=From:To:Subject:Date:From;
	b=BcxgGvsDmchUqUg10gb35PnCwF3uLBsDMztuDuEHb9HxlaiCDd08JVHIJ19CdCCcy
	 Tnei0HVX9rM4GdGQPb4opyhJbuAe3z+EPeQInNQHUsTgcQYYSxdzc6BCLd0dDKpy0D
	 Rhc8tqWoZeag5Tfxafi/T3BRw8IqWmRPnaGy4btyFJRwqH73utX4kyQKi0HnvbABe6
	 69U2NUkSS+/KCpuFaKjZjukc2pFUajwG9uCmxZzjqqIATTrjh3geNrLsNXkBWHgR8w
	 RapMNgdJas2wkHQQj85ewUHXdngrZ2jL5B1Rlaoq/vI75GFK7ai6OmX30L8CdeV63i
	 n2IZ781+ggzSA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] build: disable --with-unitdir by default
Date: Wed, 27 Aug 2025 16:02:14 +0200
Message-Id: <20250827140214.645245-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same behaviour as in the original patch:

  --with-unitdir	auto-detects the systemd unit path.
  --with-unitdir=PATH	uses the PATH

no --with-unitdir does not install the systemd unit path.

INSTALL description looks fine for what this does.

While at this, extend tests/build/ to cover for this new option.

Fixes: c4b17cf830510 ("tools: add a systemd unit for static rulesets")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac             | 29 +++++++++++++++++++++--------
 tests/build/run-tests.sh |  2 +-
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/configure.ac b/configure.ac
index 42708c9f2470..3a751cb054b9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -115,15 +115,22 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
 ]])
 
 AC_ARG_WITH([unitdir],
-	[AS_HELP_STRING([--with-unitdir=PATH], [Path to systemd service unit directory])],
-	[unitdir="$withval"],
+	[AS_HELP_STRING([--with-unitdir[=PATH]],
+	[Path to systemd service unit directory, or omit PATH to auto-detect])],
 	[
-		unitdir=$("$PKG_CONFIG" systemd --variable systemdsystemunitdir 2>/dev/null)
-		AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'])
-	])
+		if test "x$withval" = "xyes"; then
+			unitdir=$($PKG_CONFIG --variable=systemdsystemunitdir systemd 2>/dev/null)
+			AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'])
+		elif test "x$withval" = "xno"; then
+			unitdir=""
+		else
+			unitdir="$withval"
+		fi
+	],
+	[unitdir=""]
+)
 AC_SUBST([unitdir])
 
-
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
@@ -137,5 +144,11 @@ nft configuration:
   use mini-gmp:			${with_mini_gmp}
   enable man page:              ${enable_man_doc}
   libxtables support:		${with_xtables}
-  json output support:          ${with_json}
-  systemd unit:			${unitdir}"
+  json output support:          ${with_json}"
+
+if test "x$unitdir" != "x"; then
+AC_SUBST([unitdir])
+echo "  systemd unit:                 ${unitdir}"
+else
+echo "  systemd unit:                 no"
+fi
diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
index 916df2e2fa8e..1d32d5d8afcb 100755
--- a/tests/build/run-tests.sh
+++ b/tests/build/run-tests.sh
@@ -3,7 +3,7 @@
 log_file="$(pwd)/tests.log"
 dir=../..
 argument=( --without-cli --with-cli=linenoise --with-cli=editline --enable-debug --with-mini-gmp
-	   --enable-man-doc --with-xtables --with-json)
+	   --enable-man-doc --with-xtables --with-json --with-unitdir --with-unidir=/lib/systemd/system)
 ok=0
 failed=0
 
-- 
2.30.2

