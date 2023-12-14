Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="rtDRpk4G"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A39120
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 04:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/aad97Sfk9PzLlLRCQpm4opoE08ThxPtRJaDTbYakoA=; b=rtDRpk4GrSiG4ADMczGXdOa+TD
	AU7ig41WySipg84sowI/jyU4rLu8lyYZeoMfsvmCYE2TCjtYqtOGZ7SSuKdOOUFgHfDIzQcYI1C8i
	ElYmes7ZBg8fHIS7D+UXtsn3vJcR5hMNCpTHHZYxgQFzuhpT2EuBIFj1MC1vjOPVvgfv0CGqx2M5A
	dEQCNxqvVB/k+Z3WD2JUMhSRUua7lpd18D1U9KVCcpt9m+qODwO/rDlBd1mfr/4xygzl3jP1b+aH7
	AxMFY0T5mGzj5BzFxSEy5JjRH+vv3G3XHDWx3MgOUNjMqjwvSBPTqpd3Ip8/hYbS3Lql0imJ9HZhZ
	mxYLmYUw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDlJN-0032wj-2F
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 12:59:33 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables 4/7] build: use standard automake verbosity variables
Date: Thu, 14 Dec 2023 12:59:19 +0000
Message-ID: <20231214125927.925993-5-jeremy@azazel.net>
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

The previous implementation ignored the default verbosity defined by
configure, and controlled by --{enable,disable}-silent-rules, and
treated V="" as V=0.  Instead, follow the guide-lines given in the
automake manual.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/GNUmakefile.in | 41 +++++++++++++++++++++++----------------
 iptables/Makefile.am      |  6 +++---
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 51b18a59a580..f91ebf5e4e6e 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -34,12 +34,19 @@ AM_CPPFLAGS     = ${regular_CPPFLAGS} \
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 AM_LDFLAGS      = @noundef_LDFLAGS@ @regular_LDFLAGS@
 
-ifeq (${V},)
-AM_VERBOSE_CC     = @echo "  CC      " $@;
-AM_VERBOSE_CCLD   = @echo "  CCLD    " $@;
-AM_VERBOSE_AR     = @echo "  AR      " $@;
-AM_VERBOSE_GEN    = @echo "  GEN     " $@;
-endif
+AM_DEFAULT_VERBOSITY = @AM_DEFAULT_VERBOSITY@
+am__v_AR_0           = @echo "  AR      " $@;
+am__v_CC_0           = @echo "  CC      " $@;
+am__v_CCLD_0         = @echo "  CCLD    " $@;
+am__v_GEN_0          = @echo "  GEN     " $@;
+am__v_AR_            = ${am__v_AR_@AM_DEFAULT_V@}
+am__v_CC_            = ${am__v_CC_@AM_DEFAULT_V@}
+am__v_CCLD_          = ${am__v_CCLD_@AM_DEFAULT_V@}
+am__v_GEN_           = ${am__v_GEN_@AM_DEFAULT_V@}
+AM_V_AR              = ${am__v_AR_@AM_V@}
+AM_V_CC              = ${am__v_CC_@AM_V@}
+AM_V_CCLD            = ${am__v_CCLD_@AM_V@}
+AM_V_GEN             = ${am__v_GEN_@AM_V@}
 
 #
 #	Wildcard module list
@@ -118,7 +125,7 @@ clean:
 distclean: clean
 
 init%.o: init%.c
-	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=$*_init ${CFLAGS} -o $@ -c $<;
+	${AM_V_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=$*_init ${CFLAGS} -o $@ -c $<;
 
 -include .*.d
 
@@ -127,10 +134,10 @@ init%.o: init%.c
 #	Shared libraries
 #
 lib%.so: lib%.oo
-	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} ${LDFLAGS} -shared -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD};
+	${AM_V_CCLD} ${CCLD} ${AM_LDFLAGS} ${LDFLAGS} -shared -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD};
 
 lib%.oo: ${srcdir}/lib%.c
-	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
+	${AM_V_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
 
 libxt_NOTRACK.so: libxt_CT.so
 	ln -fs $< $@
@@ -158,22 +165,22 @@ xt_connlabel_LIBADD = @libnetfilter_conntrack_LIBS@
 #	handling code in the Makefiles.
 #
 lib%.o: ${srcdir}/lib%.c
-	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -DNO_SHARED_LIBS=1 -D_INIT=lib$*_init ${CFLAGS} -o $@ -c $<;
+	${AM_V_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -DNO_SHARED_LIBS=1 -D_INIT=lib$*_init ${CFLAGS} -o $@ -c $<;
 
 libext.a: initext.o ${libext_objs}
-	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+	${AM_V_AR} ${AR} crs $@ $^;
 
 libext_ebt.a: initextb.o ${libext_ebt_objs}
-	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+	${AM_V_AR} ${AR} crs $@ $^;
 
 libext_arpt.a: initexta.o ${libext_arpt_objs}
-	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+	${AM_V_AR} ${AR} crs $@ $^;
 
 libext4.a: initext4.o ${libext4_objs}
-	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+	${AM_V_AR} ${AR} crs $@ $^;
 
 libext6.a: initext6.o ${libext6_objs}
-	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+	${AM_V_AR} ${AR} crs $@ $^;
 
 initext_func  := $(addprefix xt_,${pfx_build_mod})
 initextb_func := $(addprefix ebt_,${pfb_build_mod})
@@ -191,7 +198,7 @@ ${initext_depfiles}: FORCE
 	rm -f $@.tmp;
 
 ${initext_sources}: %.c: .%.dd
-	${AM_VERBOSE_GEN}
+	${AM_V_GEN}
 	@( \
 	initext_func="$(value $(basename $@)_func)"; \
 	funcname="init_extensions$(patsubst initext%.c,%,$@)"; \
@@ -214,7 +221,7 @@ ${initext_sources}: %.c: .%.dd
 ex_matches = $(shell echo ${1} | LC_ALL=POSIX grep -Eo '\b[[:lower:][:digit:]_]+\b')
 ex_targets = $(shell echo ${1} | LC_ALL=POSIX grep -Eo '\b[[:upper:][:digit:]_]+\b')
 man_run    = \
-	${AM_VERBOSE_GEN} \
+	${AM_V_GEN} \
 	for ext in $(sort ${1}); do \
 		f="${srcdir}/libxt_$$ext.man"; \
 		if [ -f "$$f" ]; then \
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 31d4b48624cb..2007cd10260b 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -114,15 +114,15 @@ x_sbin_links  = iptables-nft iptables-nft-restore iptables-nft-save \
 endif
 
 iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../extensions/targets.man
-	${AM_VERBOSE_GEN} sed \
+	${AM_V_GEN} sed \
 		-e '/@MATCH@/ r ../extensions/matches.man' \
 		-e '/@TARGET@/ r ../extensions/targets.man' $< >$@;
 
 ${xlate_man_links}:
-	${AM_VERBOSE_GEN} echo '.so man8/xtables-translate.8' >$@
+	${AM_V_GEN} echo '.so man8/xtables-translate.8' >$@
 
 ip6tables.8 ip6tables-apply.8 ip6tables-restore.8 ip6tables-save.8:
-	${AM_VERBOSE_GEN} echo "$@" | sed 's|^ip6|.so man8/ip|' >$@
+	${AM_V_GEN} echo "$@" | sed 's|^ip6|.so man8/ip|' >$@
 
 pkgconfig_DATA = xtables.pc
 
-- 
2.43.0

