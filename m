From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH] Introducing libxt_*.man files. Sorted matches and modules
Date: Fri, 26 Oct 2007 17:00:45 +0200
Message-ID: <11934108451679-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:45951 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbXJZPAw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:00:52 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id EBFD5C1231
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Oct 2007 17:00:49 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The iptables.8 and ip6tables.8 man pages are now generated from libxt_*.man
files too. For xtables modules one man page is enough with libxt_ prefix.

The match and target lists are sorted alphabetically.

The make command doesn't print anything when creates man pages.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 Makefile            |    4 -
 extensions/Makefile |  132 +++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 103 insertions(+), 33 deletions(-)

Index: extensions/Makefile
===================================================================
--- extensions/Makefile	(revision 7083)
+++ extensions/Makefile	(working copy)
@@ -28,42 +28,64 @@
 PF6_EXT_ALL_SLIB:=$(PF6_EXT_SLIB) $(PF6_EXT_SE_SLIB) $(PF6_EXT_SLIB_OPTS)
 PFX_EXT_ALL_SLIB:=$(PFX_EXT_SLIB) $(PFX_EXT_SE_SLIB) $(PFX_EXT_SLIB_OPTS)
 
+# libipt*.c with libipt*.man
 PF_EXT_MAN_ALL_MATCHES:=$(foreach T,$(PF_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_match extensions/libipt_$(T).c  && echo $(T)))
 PF_EXT_MAN_ALL_TARGETS:=$(foreach T,$(PF_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_target extensions/libipt_$(T).c && echo $(T)))
 PF6_EXT_MAN_ALL_MATCHES:=$(foreach T,$(PF6_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_match6 extensions/libip6t_$(T).c  && echo $(T)))
 PF6_EXT_MAN_ALL_TARGETS:=$(foreach T,$(PF6_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_target6 extensions/libip6t_$(T).c && echo $(T)))
 
+# libxt*.c with libipt*.man
 PF_EXT_MAN_ALL_MATCHES+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q xtables_register_match extensions/libxt_$(T).c  && echo $(T)))
 PF_EXT_MAN_ALL_TARGETS+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q xtables_register_target extensions/libxt_$(T).c && echo $(T)))
 PF6_EXT_MAN_ALL_MATCHES+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q xtables_register_match extensions/libxt_$(T).c  && echo $(T)))
 PF6_EXT_MAN_ALL_TARGETS+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q xtables_register_target extensions/libxt_$(T).c && echo $(T)))
 
+# libxt*.c with libxt*.man
+PFX_EXT_MAN_ALL_MATCHES=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libxt_$(T).man && grep -q xtables_register_match extensions/libxt_$(T).c  && echo $(T)))
+PFX_EXT_MAN_ALL_TARGETS=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libxt_$(T).man && grep -q xtables_register_target extensions/libxt_$(T).c && echo $(T)))
+
+# libipt*.man
 PF_EXT_MAN_MATCHES:=$(filter $(PF_EXT_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
 PF_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
 PF_EXT_MAN_MATCHES+=$(filter $(PF_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
 PF_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
 
+# libipt*.man
 PF_EXT_MAN_TARGETS:=$(filter $(PF_EXT_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
 PF_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
 PF_EXT_MAN_TARGETS+=$(filter $(PF_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
 PF_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
 
+# libipt*.man
 PF_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF_EXT_MAN_MATCHES), $(PF_EXT_MAN_ALL_MATCHES))
 PF_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF_EXT_MAN_TARGETS), $(PF_EXT_MAN_ALL_TARGETS))
 
+# libip6t*.man
 PF6_EXT_MAN_MATCHES:=$(filter $(PF6_EXT_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
 PF6_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
 PF6_EXT_MAN_MATCHES+=$(filter $(PF6_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
 PF6_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
 
+# libip6t*.man
 PF6_EXT_MAN_TARGETS:=$(filter $(PF6_EXT_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
 PF6_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
 PF6_EXT_MAN_TARGETS+=$(filter $(PF6_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
 PF6_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
 
+# libip6t*.man
 PF6_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF6_EXT_MAN_MATCHES), $(PF6_EXT_MAN_ALL_MATCHES))
 PF6_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF6_EXT_MAN_TARGETS), $(PF6_EXT_MAN_ALL_TARGETS))
 
+# libxt*.man
+PFX_EXT_MAN_MATCHES:=$(filter $(PFX_EXT_SLIB), $(PFX_EXT_MAN_ALL_MATCHES))
+PFX_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SE_SLIB), $(PFX_EXT_MAN_ALL_MATCHES))
+PFX_EXT_MAN_TARGETS:=$(filter $(PFX_EXT_SLIB), $(PFX_EXT_MAN_ALL_TARGETS))
+PFX_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SE_SLIB), $(PFX_EXT_MAN_ALL_TARGETS))
+
+# libxt*.man
+PFX_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PFX_EXT_MAN_MATCHES), $(PFX_EXT_MAN_ALL_MATCHES))
+PFX_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PFX_EXT_MAN_TARGETS), $(PFX_EXT_MAN_ALL_TARGETS))
+
 ifneq ($(DO_SELINUX), 1)
 PF_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF_EXT_SELINUX_SLIB), $(PF_EXT_MAN_EXTRA_MATCHES))
 PF_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF_EXT_SELINUX_SLIB), $(PF_EXT_MAN_EXTRA_TARGETS))
@@ -74,12 +96,28 @@
 PF6_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF6_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_TARGETS))
 PF6_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_MATCHES))
 PF6_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_TARGETS))
+
+PFX_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PFX_EXT_MAN_EXTRA_MATCHES))
+PFX_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PFX_EXT_MAN_EXTRA_TARGETS))
 endif
 
+# extra man pages requires this (really _A_ll)
+PFA4_EXT_MAN_EXTRA_MATCHES:=$(PF_EXT_MAN_EXTRA_MATCHES) $(PFX_EXT_MAN_EXTRA_MATCHES)
+PFA4_EXT_MAN_EXTRA_TARGETS:=$(PF_EXT_MAN_EXTRA_TARGETS) $(PFX_EXT_MAN_EXTRA_TARGETS)
+PFA6_EXT_MAN_EXTRA_MATCHES:=$(PF6_EXT_MAN_EXTRA_MATCHES) $(PFX_EXT_MAN_EXTRA_MATCHES)
+PFA6_EXT_MAN_EXTRA_TARGETS:=$(PF6_EXT_MAN_EXTRA_TARGETS) $(PFX_EXT_MAN_EXTRA_TARGETS)
+
+
 allman:
-	@echo ALL_SLIB: $(PF_EXT_ALL_SLIB)
-	@echo ALL_MATCH: $(PF_EXT_MAN_ALL_MATCHES)
-	@echo ALL_TARGET: $(PF_EXT_MAN_ALL_TARGETS)
+	@echo 'ALL_SLIB (IPv4):' $(PF_EXT_ALL_SLIB)
+	@echo 'ALL_SLIB (IPv6):' $(PF6_EXT_ALL_SLIB)
+	@echo 'ALL_SLIB (both):' $(PFX_EXT_ALL_SLIB)
+	@echo 'ALL_MATCH (IPv4):' $(PF_EXT_MAN_ALL_MATCHES)
+	@echo 'ALL_MATCH (IPv6):' $(PF6_EXT_MAN_ALL_MATCHES)
+	@echo 'ALL_MATCH (both):' $(PFX_EXT_MAN_ALL_MATCHES)
+	@echo 'ALL_TARGET (IPv4):' $(PF_EXT_MAN_ALL_TARGETS)
+	@echo 'ALL_TARGET (IPv6):' $(PF6_EXT_MAN_ALL_TARGETS)
+	@echo 'ALL_TARGET (both):' $(PFX_EXT_MAN_ALL_TARGETS)
 
 PF_EXT_SLIB+=$(PF_EXT_SLIB_OPTS)
 PF6_EXT_SLIB+=$(PF6_EXT_SLIB_OPTS)
@@ -173,58 +211,90 @@
 endif
  
 EXTRAS += extensions/libipt_targets.man
-extensions/libipt_targets.man: $(patsubst %,extensions/libipt_%.man,$(PF_EXT_MAN_ALL_TARGETS))
-	@for ext in $(PF_EXT_MAN_TARGETS); do \
+extensions/libipt_targets.man: $(patsubst %,extensions/libipt_%.man,$(PF_EXT_MAN_ALL_TARGETS)) $(patsubst %,extensions/libxt_%.man,$(PFX_EXT_MAN_ALL_TARGETS))
+	@for ext in `echo $(PF_EXT_MAN_TARGETS) $(PFX_EXT_MAN_TARGETS) | sed 's/ /\n/g' | sort`; do \
 	    echo ".SS $$ext" ;\
-	    cat extensions/libipt_$$ext.man ;\
+	    if test -f extensions/libipt_$$ext.man; then \
+		cat extensions/libipt_$$ext.man ;\
+	    else \
+		cat extensions/libxt_$$ext.man ;\
+	    fi; \
 	done >extensions/libipt_targets.man
-	@if [ -n "$(PF_EXT_MAN_EXTRA_TARGETS)" ]; then \
-	    extra="$(PF_EXT_MAN_EXTRA_TARGETS)" ;\
-	    for ext in $${extra:-""}; do \
+	@if [ -n "$(PFA4_EXT_MAN_EXTRA_TARGETS)" ]; then \
+	    extra="$(PFA4_EXT_MAN_EXTRA_TARGETS)" ;\
+	    for ext in `echo $${extra:-""} | sed 's/ /\n/g' | sort`; do \
 		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
-		cat extensions/libipt_$$ext.man ;\
+		if test -f extensions/libipt_$$ext.man; then \
+		    cat extensions/libipt_$$ext.man ;\
+		else \
+		    cat extensions/libxt_$$ext.man ;\
+		fi; \
 	    done ;\
        	fi >>extensions/libipt_targets.man
 
 EXTRAS += extensions/libipt_matches.man
-extensions/libipt_matches.man: $(patsubst %,extensions/libipt_%.man,$(PF_EXT_MAN_ALL_MATCHES))
-	@for ext in $(PF_EXT_MAN_MATCHES); do \
+extensions/libipt_matches.man: $(patsubst %,extensions/libipt_%.man,$(PF_EXT_MAN_ALL_MATCHES)) $(patsubst %,extensions/libxt_%.man,$(PFX_EXT_MAN_ALL_MATCHES))
+	@for ext in `echo $(PF_EXT_MAN_MATCHES) $(PFX_EXT_MAN_MATCHES) | sed 's/ /\n/g' | sort`; do \
 	    echo ".SS $$ext" ;\
-	    cat extensions/libipt_$$ext.man ;\
+	    if test -f extensions/libipt_$$ext.man; then \
+		cat extensions/libipt_$$ext.man ;\
+	    else \
+		cat extensions/libxt_$$ext.man ;\
+	    fi; \
 	done >extensions/libipt_matches.man
-	@if [ -n "$(PF_EXT_MAN_EXTRA_MATCHES)" ]; then \
-	    extra="$(PF_EXT_MAN_EXTRA_MATCHES)" ;\
-	    for ext in $${extra:-""}; do \
+	@if [ -n "$(PFA4_EXT_MAN_EXTRA_MATCHES)" ]; then \
+	    extra="$(PFA4_EXT_MAN_EXTRA_MATCHES)" ;\
+	    for ext in `echo $${extra:-""} | sed 's/ /\n/g' | sort`; do \
 		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
-		cat extensions/libipt_$$ext.man ;\
+		if test -f extensions/libipt_$$ext.man; then \
+		    cat extensions/libipt_$$ext.man ;\
+		else \
+		    cat extensions/libxt_$$ext.man ;\
+		fi; \
 	    done ;\
        	fi >>extensions/libipt_matches.man
 
 EXTRAS += extensions/libip6t_targets.man
-extensions/libip6t_targets.man: $(patsubst %, extensions/libip6t_%.man, $(PF6_EXT_MAN_ALL_TARGETS))
-	@for ext in $(PF6_EXT_MAN_TARGETS); do \
+extensions/libip6t_targets.man: $(patsubst %, extensions/libip6t_%.man, $(PF6_EXT_MAN_ALL_TARGETS)) $(patsubst %,extensions/libxt_%.man,$(PFX_EXT_MAN_ALL_TARGETS))
+	@for ext in `echo $(PF6_EXT_MAN_TARGETS) $(PFX_EXT_MAN_TARGETS) | sed 's/ /\n/g' | sort`; do \
 	    echo ".SS $$ext" ;\
-	    cat extensions/libip6t_$$ext.man ;\
+	    if test -f extensions/libip6t_$$ext.man; then \
+		cat extensions/libip6t_$$ext.man ;\
+	    else \
+		cat extensions/libxt_$$ext.man ;\
+	    fi; \
 	done >extensions/libip6t_targets.man
-	@if [ -n "$(PF6_EXT_MAN_EXTRA_TARGETS)" ]; then \
-	    extra="$(PF6_EXT_MAN_EXTRA_TARGETS)" ;\
-	    for ext in $${extra:-""}; do \
+	@if [ -n "$(PFA6_EXT_MAN_EXTRA_TARGETS)" ]; then \
+	    extra="$(PFA6_EXT_MAN_EXTRA_TARGETS)" ;\
+	    for ext in `echo $${extra:-""} | sed 's/ /\n/g' | sort`; do \
 		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
-		cat extensions/libip6t_$$ext.man ;\
+		if test -f extensions/libip6t_$$ext.man; then \
+		    cat extensions/libip6t_$$ext.man ;\
+		else \
+		    cat extensions/libxt_$$ext.man ;\
+		fi; \
 	    done ;\
        	fi >>extensions/libip6t_targets.man
 
 EXTRAS += extensions/libip6t_matches.man
-extensions/libip6t_matches.man: $(patsubst %, extensions/libip6t_%.man, $(PF6_EXT_MAN_ALL_MATCHES))
-	@for ext in $(PF6_EXT_MAN_MATCHES); do \
+extensions/libip6t_matches.man: $(patsubst %, extensions/libip6t_%.man, $(PF6_EXT_MAN_ALL_MATCHES)) $(patsubst %,extensions/libxt_%.man,$(PFX_EXT_MAN_ALL_MATCHES))
+	@for ext in `echo $(PF6_EXT_MAN_MATCHES) $(PFX_EXT_MAN_MATCHES) | sed 's/ /\n/g' | sort`; do \
 	    echo ".SS $$ext" ;\
-	    cat extensions/libip6t_$$ext.man ;\
+	    if test -f extensions/libip6t_$$ext.man; then \
+		cat extensions/libip6t_$$ext.man ;\
+	    else \
+		cat extensions/libxt_$$ext.man ;\
+	    fi; \
 	done >extensions/libip6t_matches.man
-	@if [ -n "$(PF6_EXT_MAN_EXTRA_MATCHES)" ]; then \
-	    extra="$(PF6_EXT_MAN_EXTRA_MATCHES)" ;\
-	    for ext in $${extra:-""}; do \
+	@if [ -n "$(PFA6_EXT_MAN_EXTRA_MATCHES)" ]; then \
+	    extra="$(PFA6_EXT_MAN_EXTRA_MATCHES)" ;\
+	    for ext in `echo $${extra:-""} | sed 's/ /\n/g' | sort`; do \
 		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
-		cat extensions/libip6t_$$ext.man ;\
+		if test -f extensions/libip6t_$$ext.man; then \
+		    cat extensions/libip6t_$$ext.man ;\
+		else \
+		    cat extensions/libxt_$$ext.man ;\
+		fi; \
 	    done ;\
        	fi >>extensions/libip6t_matches.man
 
Index: Makefile
===================================================================
--- Makefile	(revision 7083)
+++ Makefile	(working copy)
@@ -207,10 +207,10 @@
 	@-$(CC) -M -MG $(CFLAGS) $< | sed -e 's@^.*\.o:@$*.d $*.o:@' > $@
 
 iptables.8: iptables.8.in extensions/libipt_matches.man extensions/libipt_targets.man
-	sed -e '/@MATCH@/ r extensions/libipt_matches.man' -e '/@TARGET@/ r extensions/libipt_targets.man' iptables.8.in >iptables.8
+	@sed -e '/@MATCH@/ r extensions/libipt_matches.man' -e '/@TARGET@/ r extensions/libipt_targets.man' iptables.8.in >iptables.8
 
 ip6tables.8: ip6tables.8.in extensions/libip6t_matches.man extensions/libip6t_targets.man
-	sed -e '/@MATCH@/ r extensions/libip6t_matches.man' -e '/@TARGET@/ r extensions/libip6t_targets.man' ip6tables.8.in >ip6tables.8
+	@sed -e '/@MATCH@/ r extensions/libip6t_matches.man' -e '/@TARGET@/ r extensions/libip6t_targets.man' ip6tables.8.in >ip6tables.8
 
 # Development Targets
 .PHONY: install-devel-man3
