Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61104C352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiLGRph (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiLGRpa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:45:30 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBADA686A3
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dgwR8wVqeEnYvw8E+2h2nbHesm3u3OYnAiwWrIc3olY=; b=ISiFmFgfb2zyzqpO5ChdUKw5My
        rUijy8gGe88PYZI4oZuuLUjNLNmGPOfQpRlYQUMj1aJ+7kjCxV663zPkXK/jh3A44PSGP3PrbdlBy
        kkVHIyP7bQeyR73/l8T2OO8aJkuumkzEVh9yIRQiskjDjeGOjSVFwqUHu1r+wz2JJ1A+4Tn3ta+c1
        UGK2L+OPULWPduOdtqYwx2hRuYh5DKEngysX9QqiQJ+8TiWPLGUiDCGqp04WHkjxi71eIRKHUOrYo
        jdSlu7NdCC25rDou/vhqMzBZoDOGR/bjhlXefwuPbHw8330ebbjJl9TmW44o2PjM3BBENJn5MADrj
        5Dylh6iA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yU3-0000iF-6O
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:45:27 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/11] extensions: Makefile: Merge initext targets
Date:   Wed,  7 Dec 2022 18:44:23 +0100
Message-Id: <20221207174430.4335-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221207174430.4335-1-phil@nwl.cc>
References: <20221207174430.4335-1-phil@nwl.cc>
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

