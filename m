From: Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH iptables 3/3] android: build: Blacklist TCPOPTSTRIP on systems that lack TCPOPT_*
Date: Sat, 26 Oct 2013 11:50:33 -0700
Message-ID: <1382813433-20890-4-git-send-email-cernekee@gmail.com>
References: <1382813433-20890-1-git-send-email-cernekee@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39701 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3JZSut (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Oct 2013 14:50:49 -0400
Received: by mail-pb0-f53.google.com with SMTP id up7so4744873pbc.40
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2013 11:50:48 -0700 (PDT)
In-Reply-To: <1382813433-20890-1-git-send-email-cernekee@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bionic's <netinet/tcp.h> is missing constants needed to build this module,
so have autoconf check for this condition before trying to build it.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 configure.ac |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/configure.ac b/configure.ac
index 76d0b37..53a9ded 100644
--- a/configure.ac
+++ b/configure.ac
@@ -91,6 +91,14 @@ if test "$nfconntrack" -ne 1; then
 	echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
 fi;
 
+AC_CHECK_DECL([TCPOPT_WINDOW], [tcpopt_ok=1], [tcpopt_ok=0],
+	[[#include <netinet/tcp.h>]])
+
+if test "$tcpopt_ok" -ne 1; then
+	blacklist_modules="$blacklist_modules TCPOPTSTRIP";
+	echo "WARNING: TCPOPT_* constants not found, TCPOPTSTRIP target will not be built";
+fi;
+
 AC_SUBST([blacklist_modules])
 AC_CHECK_SIZEOF([struct ip6_hdr], [], [#include <netinet/ip6.h>])
 
-- 
1.7.9.5

