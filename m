From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nftables] fix parser.h recursive inclusion
Date: Thu, 16 Jan 2014 18:04:27 +0000
Message-ID: <20140116180426.GA12421@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58051 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaAPSEa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:04:30 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This the recursive parser.h inclusion that happens occasionally when
regenerating the parser files. Amazingly bison, despite its age, is
not using header sandwiches to protect against this *sigh*

Slightly ugly, but fixes the problem.


diff --git a/Makefile.rules.in b/Makefile.rules.in
index 25988dd..ae563a5 100644
--- a/Makefile.rules.in
+++ b/Makefile.rules.in
@@ -22,7 +22,14 @@ configure:		configure.ac
 
 %.c %.h:		%.y	$(makedeps)
 			@echo -e "  YACC\t\t$<"
-			$(YACC) $(YACCFLAGS) -d -o $@ $<
+			$(YACC) $(YACCFLAGS) --defines=$*.h.tmp -o $@ $<
+			( \
+				echo "#ifndef __$(*F)_H"; \
+				echo "#define __$(*F)_H"; \
+				cat $*.h.tmp; \
+				echo "#endif /* __$(*F)_H */" \
+			) > $*.h
+			$(RM) $*.h.tmp
 
 %.c %.h:		%.l	$(makedeps)
 			@echo -e "  LEX\t\t$<"
