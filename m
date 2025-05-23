Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E15A18C011
	for <netfilter-devel@vger.kernel.org>; Fri, 23 May 2025 17:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748021258; cv=none; b=ZqKa++2XvRgn1FkLpsMJyepy1DyRyIrKRzTGJWLLASSVaFmROqrC3t3gNeLEIS90Lid6eN63Lc/XIrHHUuyvLaYuaBSK5ROw+zugNFg8quylysHRMISKH6aSP4xuboNBPdf7TH+2TolmCS02aVbNIwV0qQ5x1HLfL7Hzjiim+X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748021258; c=relaxed/simple;
	bh=F762d4sRki1ZL6EJkhVWUEm0rJJbGwae4hcsl828WWE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y9XhDF/99TW7CK913KWxKes4YDXiXHUYx+1FMtBobQJh2XUxUURQ/8ZrPeS5rfvh6JOyXlhTlcUm7osrBoj5j6fj+jtzxvZ1GBwhTuUi9nlo+snnd86DITUtrkfg8QArncZ+mykApllxrHEnUDxhlcDDIoSCCEyyTkGVA28SNLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from bozeman.lan (pool-96-240-17-61.nwrknj.fios.verizon.net [96.240.17.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mpagano)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 4DAB03435E0;
	Fri, 23 May 2025 17:27:35 +0000 (UTC)
From: Mike Pagano <mpagano@gentoo.org>
To: netfilter-devel@vger.kernel.org
Cc: mpagano@gentoo.org
Subject: [PATCH] ipset: Modify pernet_operations check
Date: Fri, 23 May 2025 13:26:51 -0400
Message-ID: <20250523172732.59179-1-mpagano@gentoo.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check for 'int \*id' in the pernet_operations struct
fails for some later versions of kernels as the declaration
is now 'int * const id'.

Kernel Commit 768e4bb6a75e3c6a034df7c67edac20bd222857e changed
the variable declaration that ipset uses to ensure presence
of the pernet ops id.

Modify the pattern match to include both the newer change while
still supporting the original declaration.

Signed-off-by: Mike Pagano <mpagano@gentoo.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index b8e9433..faf570b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -401,7 +401,7 @@ fi
 
 AC_MSG_CHECKING([kernel source for id in struct pernet_operations])
 if test -f $ksourcedir/include/net/net_namespace.h && \
-   $AWK '/^struct pernet_operations /,/^}/' $ksourcedir/include/net/net_namespace.h | $GREP -q 'int \*id;'; then
+   $AWK '/^struct pernet_operations /,/^}/' $ksourcedir/include/net/net_namespace.h | $GREP -qE 'int \*id;|int \* const id'; then
 	AC_MSG_RESULT(yes)
 	AC_SUBST(HAVE_NET_OPS_ID, define)
 else
-- 
2.49.0

