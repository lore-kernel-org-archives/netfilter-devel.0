Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FAD01CA94
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 17:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728753330; cv=none; b=qdRCWpM/zD9M9eZWUUB8/necPcjDAsPtEJ63RL0NbvgBWL9ypmeggpYXX+0TZ29IGDS/vJfh1iSs05xti3fGjdJxkJNVOjEN/Dia/V/qoHYXJCu+PTaITrW3TWiiaHb6BeGqbNNQraxxrRc9A1Fj6SWwLCKfnATDUGYn2jtJdGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728753330; c=relaxed/simple;
	bh=sqEcZChAcbrKWDZegw9Nc5rSqBkMlDB4r+Uy00qXeVk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=odTiyYj5YqhFqmvzjYY+Bx0ZUlSWw97hjUak+dwPPK3Echufgkjl+Xenrwj8s+6p4cGNMnN5KsG+KZQ3EP5j3NaMGSSuCS+6qZIGijNV5jixIq3uhvhckEPPbz2BB4UQrOGaLewhm6QyGT/DSZR8hJbtBwmUr2prBfd1Klv32JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libmnl] build: do not build documentation automatically
Date: Sat, 12 Oct 2024 19:15:21 +0200
Message-Id: <20241012171521.33453-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make it option, after this update it is still possible to build the
documentation on demand via:

 cd doxygen
 make

if ./configure found doxygen. Otherwise, no need to build documentation
when building from source.

Update README to include this information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Makefile.am |  2 +-
 README      | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 94e6935d6138..6ec1a7b98827 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,7 +2,7 @@ include $(top_srcdir)/Make_global.am
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = src include examples doxygen
+SUBDIRS = src include examples
 DIST_SUBDIRS = src include examples doxygen
 
 pkgconfigdir = $(libdir)/pkgconfig
diff --git a/README b/README
index 317a2c6ad1d6..c82dedd2266a 100644
--- a/README
+++ b/README
@@ -23,6 +23,16 @@ forced to use them.
 You can find several example files under examples/ that you can compile by
 invoking `make check'.
 
+= Documentation =
+
+If ./configure reports that doxygen has been found, then you can build
+documentation through:
+
+	cd doxygen
+	make
+
+then, open doxygen/html/index.html in your browser.
+
 = Contributing =
 
 Please submit any patches to <netfilter-devel@vger.kernel.org>.
-- 
2.30.2

