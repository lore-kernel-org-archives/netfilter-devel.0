Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="NgTYHgou"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491E5113
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 04:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=j4ZlDOe+f2JRDu8UIynnR9NFfdbKktTLMk/okOZtq7E=; b=NgTYHgou04D4wKowQVQgl8RUN9
	o/2twH4GPdmGJEyYA1s29gMh7RDVaDQR/jYp81hKB0oJL70zfVJTXCjr5jvIloqvTiMvU/rV3bHT7
	jGDGV9fFbOU0D6XKGoDD7B4IOHQXCwt2nHhD2A1O2BcVW3aLvX9wPaGQegqxZZKpMS28DgJqwWIuA
	+xEuknzmciXe6oIMwqZz0Xu4t04P6cMQBRxK5ui2NY48V0zijV5SeJuNx/GjqSJVM6v+LJxzr11DD
	6UUCoVamCBm1YvX2T08Fl4rTE3wZcZNXpsOTXd0yEJ3Bi0ctHz/mv6EH6OD3muBTIMgcEI6VKcL6t
	A/Bqcypg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDlJN-0032wj-1o
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 12:59:33 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables 1/7] build: format `AM_CPPFLAGS` variables
Date: Thu, 14 Dec 2023 12:59:16 +0000
Message-ID: <20231214125927.925993-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214125927.925993-1-jeremy@azazel.net>
References: <20231214125927.925993-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/GNUmakefile.in | 10 +++++++++-
 iptables/Makefile.am      |  9 ++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index e289adf06547..40bcec7999ae 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -22,7 +22,15 @@ regular_CPPFLAGS   = @regular_CPPFLAGS@
 kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
 
 AM_CFLAGS       = ${regular_CFLAGS}
-AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include -I${top_srcdir} ${kinclude_CPPFLAGS} ${CPPFLAGS} @libnetfilter_conntrack_CFLAGS@ @libnftnl_CFLAGS@
+AM_CPPFLAGS     = ${regular_CPPFLAGS} \
+                  -I${top_builddir}/include \
+                  -I${top_builddir} \
+                  -I${top_srcdir}/include \
+                  -I${top_srcdir} \
+                  ${kinclude_CPPFLAGS} \
+                  ${CPPFLAGS} \
+                  @libnetfilter_conntrack_CFLAGS@ \
+                  @libnftnl_CFLAGS@
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 AM_LDFLAGS      = @noundef_LDFLAGS@ @regular_LDFLAGS@
 
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 0f8b430c2021..31d4b48624cb 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -1,7 +1,14 @@
 # -*- Makefile -*-
 
 AM_CFLAGS        = ${regular_CFLAGS}
-AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include -I${top_srcdir} ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftnl_CFLAGS} ${libnetfilter_conntrack_CFLAGS}
+AM_CPPFLAGS      = ${regular_CPPFLAGS} \
+                   -I${top_builddir}/include \
+                   -I${top_srcdir}/include \
+                   -I${top_srcdir} \
+                   ${kinclude_CPPFLAGS} \
+                   ${libmnl_CFLAGS} \
+                   ${libnftnl_CFLAGS} \
+                   ${libnetfilter_conntrack_CFLAGS}
 AM_LDFLAGS       = ${regular_LDFLAGS}
 
 BUILT_SOURCES =
-- 
2.43.0

