Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="aTTrWBls"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3C6115
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 04:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oe0K+IXE2u5A2ukTey1u7Ej/nhqidC0FnUGJxqr59Hs=; b=aTTrWBlsyX5wUmb6qbegtiY2k0
	HNeV/902oq+Wx8j6IgZ4bIr8j3DaOvg43fWwQxTarX2LzUUQjTthvDoIvEXR+lRlVDeFx+85NUmzO
	RaLoWxnXyeMhbOgrJk6BwHxWj6NS2rru0Q1pKfoRkk8Jp7/9reyUY5HyJgmz8HnDEpMREOjyuWkLL
	Yz+j19cHQgxieaDBcGtqdo0FU9ZFr2UcCJtrkhn/8/Oad5mPauQHrIE9vgB/IXSCq0STQZiQlVeGK
	0DL/MJ1QgNmH1tSkmZs1v2efcuDgvCnEI1+HlH7PP76xE87NGHE1vlr7fb9TbQ7k1IW02b6KHiH6o
	OOyzqGKg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDlJN-0032wj-2P
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 12:59:33 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables 5/7] build: add an automake verbosity variable for `ln`
Date: Thu, 14 Dec 2023 12:59:20 +0000
Message-ID: <20231214125927.925993-6-jeremy@azazel.net>
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
 extensions/GNUmakefile.in | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index f91ebf5e4e6e..dfa58c3b9e8b 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -39,14 +39,17 @@ am__v_AR_0           = @echo "  AR      " $@;
 am__v_CC_0           = @echo "  CC      " $@;
 am__v_CCLD_0         = @echo "  CCLD    " $@;
 am__v_GEN_0          = @echo "  GEN     " $@;
+am__v_LN_0           = @echo "  LN      " $@;
 am__v_AR_            = ${am__v_AR_@AM_DEFAULT_V@}
 am__v_CC_            = ${am__v_CC_@AM_DEFAULT_V@}
 am__v_CCLD_          = ${am__v_CCLD_@AM_DEFAULT_V@}
 am__v_GEN_           = ${am__v_GEN_@AM_DEFAULT_V@}
+am__v_LN_            = ${am__v_LN_@AM_DEFAULT_V@}
 AM_V_AR              = ${am__v_AR_@AM_V@}
 AM_V_CC              = ${am__v_CC_@AM_V@}
 AM_V_CCLD            = ${am__v_CCLD_@AM_V@}
 AM_V_GEN             = ${am__v_GEN_@AM_V@}
+AM_V_LN              = ${am__v_LN_@AM_V@}
 
 #
 #	Wildcard module list
@@ -140,17 +143,17 @@ lib%.oo: ${srcdir}/lib%.c
 	${AM_V_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
 
 libxt_NOTRACK.so: libxt_CT.so
-	ln -fs $< $@
+	${AM_V_LN} ln -fs $< $@
 libxt_state.so: libxt_conntrack.so
-	ln -fs $< $@
+	${AM_V_LN} ln -fs $< $@
 libxt_REDIRECT.so: libxt_NAT.so
-	ln -fs $< $@
+	${AM_V_LN} ln -fs $< $@
 libxt_MASQUERADE.so: libxt_NAT.so
-	ln -fs $< $@
+	${AM_V_LN} ln -fs $< $@
 libxt_SNAT.so: libxt_NAT.so
-	ln -fs $< $@
+	${AM_V_LN} ln -fs $< $@
 libxt_DNAT.so: libxt_NAT.so
-	ln -fs $< $@
+	${AM_V_LN} ln -fs $< $@
 
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
 xt_RATEEST_LIBADD   = -lm
-- 
2.43.0

