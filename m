Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD69C63708
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 15:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiLHPq6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiLHPqf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 10:46:35 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D724254344
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 07:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dgwR8wVqeEnYvw8E+2h2nbHesm3u3OYnAiwWrIc3olY=; b=P6EkR5x8RBWqrXTC/WqZFRVQCL
        oqERW6GmFld16X5ksVYyppgE0YfjUlGdgjuGO2caj0t/kjUiy8cEqh7o1LQcho1UEUezj4PLg1UuP
        kBbOS6bAcIWQKKY61jphIMbyfwLrvbsUI5K7OnxTKzzLXZw97nnMMni5LCnS9ZmmBt/fxmGdhIyqL
        72gcyRMTP3ynIAdeZSuYtGfOMr0chh8CG14DtPKCwgn10ceMcN85h5GmvjQWxcMOAWus4Rb4Zyeiu
        uODWJAqqqAolb+pQoWCOlT5/pyorYEmTcFsCq+Sr9crx6gdXQaPKSt4vdrCQU8WVSCJbsLD3DVXZo
        td+6uWyw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p3J6V-0005ej-5g; Thu, 08 Dec 2022 16:46:31 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 04/11] extensions: Makefile: Merge initext targets
Date:   Thu,  8 Dec 2022 16:46:09 +0100
Message-Id: <20221208154616.14622-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221208154616.14622-1-phil@nwl.cc>
References: <20221208154616.14622-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Abstract initext*.c and .initext*.dd stamp file recipes so a single one
serves for all variants.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/GNUmakefile.in | 106 +++++---------------------------------
 1 file changed, 14 insertions(+), 92 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 0239a06a90cd1..188e7a7902566 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -175,111 +175,33 @@ initexta_func := $(addprefix arpt_,${pfa_build_mod})
 initext4_func := $(addprefix ipt_,${pf4_build_mod})
 initext6_func := $(addprefix ip6t_,${pf6_build_mod})
 
-.initext.dd: FORCE
-	@echo "${initext_func}" >$@.tmp; \
-	cmp -s $@ $@.tmp || mv $@.tmp $@; \
-	rm -f $@.tmp;
-
-.initextb.dd: FORCE
-	@echo "${initextb_func}" >$@.tmp; \
-	cmp -s $@ $@.tmp || mv $@.tmp $@; \
-	rm -f $@.tmp;
-
-.initexta.dd: FORCE
-	@echo "${initexta_func}" >$@.tmp; \
-	cmp -s $@ $@.tmp || mv $@.tmp $@; \
-	rm -f $@.tmp;
-
-.initext4.dd: FORCE
-	@echo "${initext4_func}" >$@.tmp; \
-	cmp -s $@ $@.tmp || mv $@.tmp $@; \
-	rm -f $@.tmp;
+initexts := ext exta extb ext4 ext6
+initext_depfiles = $(patsubst %,.init%.dd,${initexts})
+initext_sources = $(patsubst %,init%.c,${initexts})
 
-.initext6.dd: FORCE
-	@echo "${initext6_func}" >$@.tmp; \
+${initext_depfiles}: FORCE
+	@echo "$(value $(patsubst .%.dd,%,$@)_func)" >$@.tmp; \
 	cmp -s $@ $@.tmp || mv $@.tmp $@; \
 	rm -f $@.tmp;
 
-initext.c: .initext.dd
-	${AM_VERBOSE_GEN}
-	@( \
-	echo "" >$@; \
-	for i in ${initext_func}; do \
-		echo "extern void lib$${i}_init(void);" >>$@; \
-	done; \
-	echo "void init_extensions(void);" >>$@; \
-	echo "void init_extensions(void)" >>$@; \
-	echo "{" >>$@; \
-	for i in ${initext_func}; do \
-		echo  " ""lib$${i}_init();" >>$@; \
-	done; \
-	echo "}" >>$@; \
-	);
-
-initextb.c: .initextb.dd
-	${AM_VERBOSE_GEN}
-	@( \
-	echo "" >$@; \
-	for i in ${initextb_func}; do \
-		echo "extern void lib$${i}_init(void);" >>$@; \
-	done; \
-	echo "void init_extensionsb(void);" >>$@; \
-	echo "void init_extensionsb(void)" >>$@; \
-	echo "{" >>$@; \
-	for i in ${initextb_func}; do \
-		echo  " ""lib$${i}_init();" >>$@; \
-	done; \
-	echo "}" >>$@; \
-	);
-
-initexta.c: .initexta.dd
+${initext_sources}: %.c: .%.dd
 	${AM_VERBOSE_GEN}
 	@( \
+	initext_func="$(value $(basename $@)_func)"; \
+	funcname="init_extensions$(patsubst initext%.c,%,$@)"; \
 	echo "" >$@; \
-	for i in ${initexta_func}; do \
+	for i in $${initext_func}; do \
 		echo "extern void lib$${i}_init(void);" >>$@; \
 	done; \
-	echo "void init_extensionsa(void);" >>$@; \
-	echo "void init_extensionsa(void)" >>$@; \
+	echo "void $${funcname}(void);" >>$@; \
+	echo "void $${funcname}(void)" >>$@; \
 	echo "{" >>$@; \
-	for i in ${initexta_func}; do \
+	for i in $${initext_func}; do \
 		echo  " ""lib$${i}_init();" >>$@; \
 	done; \
 	echo "}" >>$@; \
 	);
 
-initext4.c: .initext4.dd
-	${AM_VERBOSE_GEN}
-	@( \
-	echo "" >$@; \
-	for i in ${initext4_func}; do \
-		echo "extern void lib$${i}_init(void);" >>$@; \
-	done; \
-	echo "void init_extensions4(void);" >>$@; \
-	echo "void init_extensions4(void)" >>$@; \
-	echo "{" >>$@; \
-	for i in ${initext4_func}; do \
-		echo  " ""lib$${i}_init();" >>$@; \
-	done; \
-	echo "}" >>$@; \
-	);
-
-initext6.c: .initext6.dd
-	${AM_VERBOSE_GEN}
-	@( \
-	echo "" >$@; \
-	for i in ${initext6_func}; do \
-		echo "extern void lib$${i}_init(void);" >>$@; \
-	done; \
-	echo "void init_extensions6(void);" >>$@; \
-	echo "void init_extensions6(void)" >>$@; \
-	echo "{" >>$@; \
-	for i in ${initext6_func}; do \
-		echo " ""lib$${i}_init();" >>$@; \
-	done; \
-	echo "}" >>$@; \
-	);
-
 #
 #	Manual pages
 #
@@ -308,8 +230,8 @@ man_run    = \
 		fi; \
 	done >$@;
 
-matches.man: .initext.dd .initextb.dd .initexta.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
+matches.man: ${initext_depfiles} $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pfb_build_mod} ${pfa_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
 
-targets.man: .initext.dd .initextb.dd .initexta.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
+targets.man: ${initext_depfiles} $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pfb_build_mod} ${pfa_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
-- 
2.38.0

