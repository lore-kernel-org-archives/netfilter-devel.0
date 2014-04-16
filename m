From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [PATCH] build: delete useless characters
Date: Wed, 16 Apr 2014 18:10:38 +0200
Message-ID: <20140416161038.1237.5216.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40891 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754922AbaDPQKs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:10:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are a lot of '-e' that seem useless in the build system.

Previous to this patch:
  [...]
  -e CC		src/evaluate.c
  -e CC		src/expression.c
  -e CC		src/proto.c
  [...]


With this patch:
  [...]
  CC		src/evaluate.c
  CC		src/expression.c
  CC		src/proto.c
  [...]

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 Makefile.rules.in |   20 ++++++++++----------
 doc/Makefile.in   |    4 ++--
 files/Makefile.in |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Makefile.rules.in b/Makefile.rules.in
index 6a00916..53ba7e9 100644
--- a/Makefile.rules.in
+++ b/Makefile.rules.in
@@ -12,16 +12,16 @@ configure:		configure.ac
 			sh configure
 
 %.o:			%.c	$(makedeps)
-			@echo -e "  CC\t\t$<"
+			@echo	"  CC\t\t$<"
 			$(CC) $(CFLAGS) -c -o $@ $<
 
 .%.d:			%.c	$(makedeps)
-			@echo -e "  DEP\t\t$<"
+			@echo	"  DEP\t\t$<"
 			$(RM) $@
 			$(CC) -M $(CFLAGS) $< | sed 's,$(*F)\.o[ :]*,$*.o $@ : ,g' > $@
 
 %.c %.h:		%.y	$(makedeps)
-			@echo -e "  YACC\t\t$<"
+			@echo	"  YACC\t\t$<"
 			$(YACC) $(YACCFLAGS) --defines=$*.h.tmp -o $@ $<
 			( \
 				echo "#ifndef __$(*F)_H"; \
@@ -32,15 +32,15 @@ configure:		configure.ac
 			$(RM) $*.h.tmp
 
 %.c %.h:		%.l	$(makedeps)
-			@echo -e "  LEX\t\t$<"
+			@echo	"  LEX\t\t$<"
 			$(LEX) -t --header-file=$(<:.l=.h) $< > $@
 
 %.8:			%.xml	$(makedeps)
-			@echo -e "  MAN\t\t$@"
+			@echo	"  MAN\t\t$@"
 			(cd $(SUBDIR); $(DB2MAN) --xinclude ../$<)
 
 %.pdf:			%.xml	$(makedeps)
-			@echo -e "  PDF\t\t$@"
+			@echo	"  PDF\t\t$@"
 			dblatex -q -t pdf -o $@ $<
 
 archive:
@@ -54,19 +54,19 @@ $(1)-extra-clean-files	:= $$(patsubst %,$(SUBDIR)%,$$($(1)-extra-clean-files))
 depfiles		:= $$(patsubst $(SUBDIR)%.o,$(SUBDIR).%.d,$$($(1)-obj))
 
 $(SUBDIR)$(1):		$$($(1)-extra-targets) $$($(1)-obj)
-			@echo -e "  LD\t\t$$@"
+			@echo	"  LD\t\t$$@"
 			$$(CC) $$($(1)-obj) $$(LDFLAGS) -o $$@
 all_targets		+= $(SUBDIR)$(1)
 
 .PHONY:			$(1)-clean
 $(1)-clean:
-			@echo -e "  CLEAN\t\t$(1)"
+			@echo	"  CLEAN\t\t$(1)"
 			$$(RM) $$($(1)-obj) $$(depfiles) $$($(1)-extra-clean-files) $(SUBDIR)$(1)
 clean_targets		+= $(1)-clean
 
 .PHONY:			$(1)-install
 $(1)-install:
-			@echo -e "  INSTALL\t$1"
+			@echo	"  INSTALL\t$1"
 			$(MKDIR_P) $$(DESTDIR)/$$($(1)-destdir)
 			$(INSTALL) -m 755 -p \
 				$(SUBDIR)$(1) \
@@ -92,5 +92,5 @@ install:		all $(SUBDIRS) $(install_targets)
 
 .PHONY: $(SUBDIRS)
 $(SUBDIRS):
-			@echo -e "  SUBDIR\t$@/"
+			@echo	"  SUBDIR\t$@/"
 			@$(MAKE) -s -f Makefile.rules $(MAKECMDGOALS) SUBDIR="$@/" SUBDIRS=""
diff --git a/doc/Makefile.in b/doc/Makefile.in
index 1ec856c..660172d 100644
--- a/doc/Makefile.in
+++ b/doc/Makefile.in
@@ -3,11 +3,11 @@ pdfdocs-@CONFIG_PDF@	+= doc/nft.pdf
 
 all:		$(mandocs-y) $(pdfdocs-y)
 clean:
-		@echo -e "  CLEAN\t\tdoc"
+		@echo	"  CLEAN\t\tdoc"
 		$(RM) $(mandocs-y) $(pdfdocs-y)
 
 install:	$(mandocs-y) $(pdfdocs-y)
-		@echo -e "  INSTALL\tdoc"
+		@echo	"  INSTALL\tdoc"
 		if test -n "$(mandocs-y)"; then \
 			$(MKDIR_P) $(DESTDIR)/${mandir}/man8 ;\
 			$(INSTALL) -m 755 -p $(mandocs-y) \
diff --git a/files/Makefile.in b/files/Makefile.in
index dc237e2..1b6dbc2 100644
--- a/files/Makefile.in
+++ b/files/Makefile.in
@@ -1,5 +1,5 @@
 install:
-	@echo -e "  INSTALL\tfiles"
+	@echo	"  INSTALL\tfiles"
 	$(MKDIR_P) $(DESTDIR)/$(confdir)
 	$(INSTALL) -m 755 -p $(SUBDIR)nftables/* $(DESTDIR)/$(confdir)/
 	$(SED) -i "s~#\! nft~#\!@sbindir@/nft~" $(DESTDIR)/$(confdir)/*

