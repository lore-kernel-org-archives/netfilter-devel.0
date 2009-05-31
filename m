From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] fix "manpages: do not include v4-only modules in ip6tables
 manpage"
Date: Sun, 31 May 2009 22:24:52 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905312220210.815@fbirervta.pbzchgretzou.qr>
References: <1243788616-375-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54385 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZEaUYv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 May 2009 16:24:51 -0400
In-Reply-To: <1243788616-375-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-05-31 18:50, Florian Westphal wrote:

>previous commit tries to skip v4-only module manpages
>by searching for NFPROTO_IPV(4|6) -- in the man page itself.
>
>Searching the .c file instead is not sufficient:
>- there is at least one page (libxt_policy) without a libxt_*c
>- there are targets/modules which use family AF_UNSPEC.

No, this one misses manpages too... Bah, time to eradicate the ip/ip6/
name mess.

>diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
>index 8d7f21d..44a6d02 100644
>--- a/extensions/GNUmakefile.in
>+++ b/extensions/GNUmakefile.in
>@@ -161,10 +161,13 @@ man_run    = \
> 	${AM_VERBOSE_GEN} \
> 	for ext in $(1); do \
> 		f="${srcdir}/libxt_$$ext.man"; \
>-		if [ -f "$$f" ] && grep -q "$(3)" "$$f"; then \
>-			echo ".SS $$ext"; \
>-			cat "$$f"; \
>-			continue; \
>+		if [ -f "$$f" ] ; then \
>+			cfile="${srcdir}/libxt_$$ext.c"; \
>+			if [ ! -f "$$cfile" ] || grep -q "\(_UNSPEC\|$(3)\)" "$$cfile"; then \
>+				echo ".SS $$ext"; \
>+				cat "$$f"; \
>+				continue; \
>+			fi; \
> 		fi; \
> 		f="${srcdir}/lib$(2)t_$$ext.man"; \
> 		if [ -f "$$f" ]; then \
