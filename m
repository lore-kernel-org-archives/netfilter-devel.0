Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="EUfvKL4E"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B9F112
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 08:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=j4ZlDOe+f2JRDu8UIynnR9NFfdbKktTLMk/okOZtq7E=; b=EUfvKL4ElY3WeG2pHCKwMCH1PT
	3Fv/cEbzaEbKyOfFbnDBXLneGvyjlrbGyvz4UX62sg8PRFW2KEGbwcRAIvgokfnC2BrA3mS3VgCZ3
	Lk4zzKgcf/KbpGM/FVJ0C7yjO6osw75JgkIL66BytPqjTngqea1r/sJK+RuLwQXqVu19tzxzSjnWJ
	L7usArKApyyD+RKR+YDn3Skl4Lw0w8DfVp02vlL1pshZLL/1SeFzOWITJ9JaXeXxtZVwXw/N0sBaG
	QpSWoajvzYiAh8f+egjL5Jt71Q12ZH3uLOnsMDHXMFjIKBnriprx/j9K+K9DWtk0NQ64KHHCkask+
	cPS7LKuw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDoor-0038UN-1l
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 16:44:17 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables v2 1/6] build: format `AM_CPPFLAGS` variables
Date: Thu, 14 Dec 2023 16:44:00 +0000
Message-ID: <20231214164408.1001721-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214164408.1001721-1-jeremy@azazel.net>
References: <20231214164408.1001721-1-jeremy@azazel.net>
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

