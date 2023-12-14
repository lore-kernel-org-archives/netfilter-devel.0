Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="MB1bCOTi"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F25A6
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 04:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fkGHOASEKfLYizqQMY5JAOTAzzIyc7UFjNgU/hMDnlI=; b=MB1bCOTidhaQuNI/LNaS+KXxZz
	y53yWl2dBlqj/ugl7oYrFIBG74HkZOIo2Fv+QqwG3yiD5kQ6p56pccaAePjuab13VjNo08c3VtbiZ
	jhvsJSLFGHOHuhiN4/Iulpo7LIB10Iom7c2AXki4s8BpvJhl43Nm5/8Deci69Aab9NmRE5ljGcxs1
	LLgXqhQr3f+7sp9Lm7aVKBOx/CyMpOFNvQnfR6OMh3Lwl3kYY+tYflj6wColIIk5Do518tDtyJcNJ
	EZoXMcHqXSRm7EIx7VQIKaE+fR5mVd8jDX2ggvmjjPvNgryrCr3ZNtX2gHikWPybY0gCPBgJxMC/T
	Xd1gPo+w==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDlJN-0032wj-2g
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 12:59:33 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables 7/7] build: suppress man-page listing in silent rules
Date: Thu, 14 Dec 2023 12:59:22 +0000
Message-ID: <20231214125927.925993-8-jeremy@azazel.net>
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

Add an `AM_V_PRINTF` variable to control whether `printf` is called.

Normally `AM_V_*` variables work by prepending

  @echo blah;

to a whole rule to replace the usual output with something briefer.
Since, in this case, the aim is to suppress `printf` commands _within_ a
rule, `AM_V_PRINTF` works be prepending `:` to the `printf` command.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/GNUmakefile.in | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index f41af7c1420d..24ec57f7d1cb 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -40,16 +40,19 @@ am__v_CC_0           = @echo "  CC      " $@;
 am__v_CCLD_0         = @echo "  CCLD    " $@;
 am__v_GEN_0          = @echo "  GEN     " $@;
 am__v_LN_0           = @echo "  LN      " $@;
+am__v_PRINTF_0       = :
 am__v_AR_            = ${am__v_AR_@AM_DEFAULT_V@}
 am__v_CC_            = ${am__v_CC_@AM_DEFAULT_V@}
 am__v_CCLD_          = ${am__v_CCLD_@AM_DEFAULT_V@}
 am__v_GEN_           = ${am__v_GEN_@AM_DEFAULT_V@}
 am__v_LN_            = ${am__v_LN_@AM_DEFAULT_V@}
+am__v_PRINTF_        = ${am__v_PRINTF_@AM_DEFAULT_V@}
 AM_V_AR              = ${am__v_AR_@AM_V@}
 AM_V_CC              = ${am__v_CC_@AM_V@}
 AM_V_CCLD            = ${am__v_CCLD_@AM_V@}
 AM_V_GEN             = ${am__v_GEN_@AM_V@}
 AM_V_LN              = ${am__v_LN_@AM_V@}
+AM_V_PRINTF          = ${am__v_PRINTF_@AM_V@}
 
 #
 #	Wildcard module list
@@ -221,6 +224,7 @@ ${initext_sources}: %.c: .%.dd
 #
 #	Manual pages
 #
+
 ex_matches = $(shell echo ${1} | LC_ALL=POSIX grep -Eo '\b[[:lower:][:digit:]_]+\b')
 ex_targets = $(shell echo ${1} | LC_ALL=POSIX grep -Eo '\b[[:upper:][:digit:]_]+\b')
 man_run    = \
@@ -228,19 +232,19 @@ man_run    = \
 	for ext in $(sort ${1}); do \
 		f="${srcdir}/libxt_$$ext.man"; \
 		if [ -f "$$f" ]; then \
-			printf "\t+ $$f" >&2; \
+			${AM_V_PRINTF} printf "\t+ $$f" >&2; \
 			echo ".SS $$ext"; \
 			cat "$$f" || exit $$?; \
 		fi; \
 		f="${srcdir}/libip6t_$$ext.man"; \
 		if [ -f "$$f" ]; then \
-			printf "\t+ $$f" >&2; \
+			${AM_V_PRINTF} printf "\t+ $$f" >&2; \
 			echo ".SS $$ext (IPv6-specific)"; \
 			cat "$$f" || exit $$?; \
 		fi; \
 		f="${srcdir}/libipt_$$ext.man"; \
 		if [ -f "$$f" ]; then \
-			printf "\t+ $$f" >&2; \
+			${AM_V_PRINTF} printf "\t+ $$f" >&2; \
 			echo ".SS $$ext (IPv4-specific)"; \
 			cat "$$f" || exit $$?; \
 		fi; \
-- 
2.43.0

