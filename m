Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A34131E0EE
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 12:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756298598; cv=none; b=CxL4o2fq1n+WwQUWOBPZ7Ajrlw7VKnLGtOP/G5l4ICl2ADhGAcc1WSRAA2IrqJ9a4yUUW4Dv932+jcc1hIIpMv77sPCXw3EcXARzYj4cWBLLY5RTS36qpVuIg/Enu9jQbZxiox4QlSitKlGoCXxESC9o+mPXNxs+BupbZkcD1hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756298598; c=relaxed/simple;
	bh=y0s3vPnmIl8e8bU1RMi2xRiM+BKJEr/ShxN+/BF+ZkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBC4X3XcWHHNAlJ1c6+gU2DOLgqM93DyY3l73fVuB0JsZ4AeWa/s1JfzbMViBetZJsk1a116mNfjwztv3Dmha8HEdjLDjwl41ia6XFPvPMpmhs3yN8/ATpmygsZ1wsLzmiIQEXuNKd9PIiDO6+kcRZmviYly07QTI+hkWQlVkow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 65534)
	id 204061003DFEC3; Wed, 27 Aug 2025 14:43:08 +0200 (CEST)
X-Spam-Level: 
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:202:600a::a4])
	by a3.inai.de (Postfix) with ESMTP id F0A951003D9D08;
	Wed, 27 Aug 2025 14:43:07 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: pablo@netfilter.org
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org
Subject: [PATCH] build: make `make distcheck` succeed in the face of absolute paths
Date: Wed, 27 Aug 2025 14:43:07 +0200
Message-ID: <20250827124307.894879-1-jengelh@inai.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <90rp264n-po69-op18-1s8r-615r43sq38r0@vanv.qr>
References: <90rp264n-po69-op18-1s8r-615r43sq38r0@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`make distcheck` has an expectation that, if only --prefix is
specified, all other potentially-configurable paths are somehow
relative to '${prefix}', e.g. bindir defaults to '${prefix}/bin'.

We get an absolute path from $(pkg-config systemd ...) at all times
in case systemd.pc is present, and an empty path in case it is not,
which collides with the aforementioned expectation two ways. Add an
internal --with-dcprefix configure option for the sake of distcheck.
---
 Makefile.am  | 1 +
 configure.ac | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index e292d3b9..52a3e6c4 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -23,6 +23,7 @@ libnftables_LIBVERSION = 2:0:1
 ###############################################################################
 
 ACLOCAL_AMFLAGS = -I m4
+AM_DISTCHECK_CONFIGURE_FLAGS = --with-dcprefix='$${prefix}'
 
 EXTRA_DIST =
 BUILT_SOURCES =
diff --git a/configure.ac b/configure.ac
index 626c641b..198b3be8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -122,6 +122,11 @@ AC_ARG_WITH([unitdir],
 		AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'])
 	])
 AC_SUBST([unitdir])
+AC_ARG_WITH([dcprefix],
+        [AS_HELP_STRING([Extra path inserted for distcheck])],
+        [dcprefix="$withval"])
+AC_SUBST([dcprefix])
+AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'], [unitdir='${dcprefix}'"$unitdir"])
 
 
 AC_CONFIG_FILES([					\
-- 
2.51.0

