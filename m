Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A36BC001DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Aug 2023 16:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjHAQzv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 12:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbjHAQzv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 12:55:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF21268D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 09:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8aZtfMd6bhFliJmB0/XnBB8V76AptNunz8Fak1KqRig=; b=aemw8ilifqPvRrnYEAPQ/T3MvQ
        IC86/wX+V7JfSHQx5z/cWo/OzBwhM42m9u1SpxWb0japHNn1ZZHaDqRqvO5GvIH2R9tBtKIw218wb
        y7lt9KZTVIx7iPZbDmFF1ILEFGBGEW40qPlfxmebTHYaEOm3uF+CT9G3P2MMLAgccde7hsabFPgX+
        2FokDzR9TrW0vhMKTtUd+KPO2vkaP1wg+XZEi+WHFiiPkUFfUm/N9HjN2U5ZO7uJQU7V3mIIF3omt
        YvJeB2qVxBADtFc3SocFi+WlibMwHbByIeC88WiquXDW5M3499obVzS9nbKZfHdcAd4ZMCSLq0VKl
        KSMMVcmA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qQseV-0006O8-6c
        for netfilter-devel@vger.kernel.org; Tue, 01 Aug 2023 18:55:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] Makefile: Support 'make tags' and 'make cscope'
Date:   Tue,  1 Aug 2023 18:55:10 +0200
Message-Id: <20230801165510.23976-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Copy necessary bits from generated Makefile.in into the static
extensions/GNUmakefile.in so it plays nicely when called.

For some reason, using 'make ctags' creates a top-level tags file which
does not include others, so not quite useful. Using 'make tags' instead
works, but only after I created an etags-wrapper (calling ctags -e) in
my ~/bin. Seems as per design, though.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .gitignore                |  3 ++
 extensions/GNUmakefile.in | 66 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/.gitignore b/.gitignore
index ec4e44cad8aa7..d1b1fd9ad863c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -32,6 +32,9 @@ Makefile.in
 *.swp
 
 /tags
+TAGS
+/cscope.files
+/cscope.out
 
 # make check results
 /test-suite.log
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index e289adf06547f..37e6b271a808a 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -79,7 +79,8 @@ targets_install :=
 
 .SECONDARY:
 
-.PHONY: all install uninstall clean distclean FORCE dvi check installcheck
+.PHONY: all install uninstall clean distclean FORCE dvi check installcheck \
+	CTAGS GTAGS TAGS ctags tags cscopelist
 
 all: ${targets}
 
@@ -110,7 +111,7 @@ install: ${targets_install} ${symlinks_install}
 	rm -f initext.c initext4.c initext6.c initextb.c initexta.c
 	rm -f .*.d .*.dd;
 
-distclean: clean
+distclean: clean distclean-tags
 
 init%.o: init%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=$*_init ${CFLAGS} -o $@ -c $<;
@@ -249,3 +250,64 @@ dist_sources = $(filter-out ${dist_initext_src},$(wildcard $(srcdir)/*.[ch]))
 dvi:
 check: all
 installcheck:
+
+CSCOPE = @CSCOPE@
+CTAGS = @CTAGS@
+ETAGS = @ETAGS@
+
+am__tagged_files = ${dist_sources}
+am__define_uniq_tagged_files = \
+  list='$(am__tagged_files)'; \
+  unique=`for i in $$list; do \
+    if test -f "$$i"; then echo $$i; else echo $(srcdir)/$$i; fi; \
+  done | $(am__uniquify_input)`
+
+ID: $(am__tagged_files)
+	$(am__define_uniq_tagged_files); mkid -fID $$unique
+
+TAGS: tags
+tags: $(TAGS_DEPENDENCIES) $(am__tagged_files)
+	set x; \
+	here=`pwd`; \
+	$(am__define_uniq_tagged_files); \
+	shift; \
+	if test -z "$(ETAGS_ARGS)$$*$$unique"; then :; else \
+	  test -n "$$unique" || unique=$$empty_fix; \
+	  if test $$# -gt 0; then \
+	    $(ETAGS) $(ETAGSFLAGS) $(AM_ETAGSFLAGS) $(ETAGS_ARGS) \
+	      "$$@" $$unique; \
+	  else \
+	    $(ETAGS) $(ETAGSFLAGS) $(AM_ETAGSFLAGS) $(ETAGS_ARGS) \
+	      $$unique; \
+	  fi; \
+	fi
+
+CTAGS: ctags
+ctags: $(TAGS_DEPENDENCIES) $(am__tagged_files)
+	$(am__define_uniq_tagged_files); \
+	test -z "$(CTAGS_ARGS)$$unique" \
+	  || $(CTAGS) $(CTAGSFLAGS) $(AM_CTAGSFLAGS) $(CTAGS_ARGS) \
+	     $$unique
+
+GTAGS:
+	here=`$(am__cd) $(top_builddir) && pwd` \
+	  && $(am__cd) $(top_srcdir) \
+	  && gtags -i $(GTAGS_ARGS) "$$here"
+
+subdir = extensions
+cscopelist: $(am__tagged_files)
+	list='$(am__tagged_files)'; \
+	case "$(srcdir)" in \
+	  [\\/]* | ?:[\\/]*) sdir="$(srcdir)" ;; \
+	  *) sdir=$(subdir)/$(srcdir) ;; \
+	esac; \
+	for i in $$list; do \
+	  if test -f "$$i"; then \
+	    echo "$(subdir)/$$i"; \
+	  else \
+	    echo "$$sdir/$$i"; \
+	  fi; \
+	done >> $(top_builddir)/cscope.files
+
+distclean-tags:
+	-rm -f TAGS ID GTAGS GRTAGS GSYMS GPATH tags
-- 
2.40.0

