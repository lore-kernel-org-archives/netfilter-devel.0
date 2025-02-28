Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF833277005
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740768855; cv=none; b=Eqcdw5Nb3eXJN409zbvN9bxtRKLN7yzMBoqn4kcXYS28ZgpsZeYkrkPHhi7SRon3iOxi2k/bamNia2NqC6G3py8aD/G2w83RaffF/y00s3bF+q2hctCB2HfxH3ETnBYG7w6wH9uFbZqA20adqtHe3riYl/uPwQJc41pJ7fGtRDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740768855; c=relaxed/simple;
	bh=MfUCd2oxgEpRkYTTNhbxmXCuh5Ot+iuJ9+k0YoqtZTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eM9SlCzq5yUnowcC8C30dKej0O5Tuf+pMGklabbp3ykihfxzh60mKrD/wad8LfXXmZeRH6kpnPt4a2p4MPMig8uz83Bq3rBrOj8CHxQRt9Ti5AA1+SsZ16MmEPAxiUIO41Js5DCZrmx7VZBSiC0pS0eL3INIi1HPyjnbKcip1S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 65534)
	id AFE911003E8656; Fri, 28 Feb 2025 19:54:05 +0100 (CET)
X-Spam-Level: 
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:202:600a::a4])
	by a3.inai.de (Postfix) with ESMTP id 931611003E864B;
	Fri, 28 Feb 2025 19:54:05 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH] build: add hint for a2x error message
Date: Fri, 28 Feb 2025 19:54:05 +0100
Message-ID: <20250228185405.25448-1-jengelh@inai.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 816e9201..80a64813 100644
--- a/configure.ac
+++ b/configure.ac
@@ -53,7 +53,7 @@ CHECK_GCC_FVISIBILITY
 AS_IF([test "x$enable_man_doc" = "xyes"], [
        AC_CHECK_PROG(A2X, [a2x], [a2x], [no])
        AS_IF([test "$A2X" = "no" -a ! -f "${srcdir}/doc/nft.8"],
-	     [AC_MSG_ERROR([a2x not found, please install asciidoc])])
+	     [AC_MSG_ERROR([a2x not found, please install asciidoc, or pass --disable-man-doc])])
 ])
 
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.4])
-- 
2.48.1

