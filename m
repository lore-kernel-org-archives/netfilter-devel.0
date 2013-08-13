From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCHv2] iptables: link against libnetfilter_conntrack
Date: Tue, 13 Aug 2013 13:37:04 -0300
Message-ID: <1376411824-22311-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:59392 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab3HMQhN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:37:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When libnetfilter_conntrack is available iptables needs to link
against it otherwise we get build failures.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 iptables/Makefile.am | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index a4246eb..6390b7c 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -21,6 +21,9 @@ xtables_multi_SOURCES += ip6tables-save.c ip6tables-restore.c \
 xtables_multi_CFLAGS  += -DENABLE_IPV6
 xtables_multi_LDADD   += ../libiptc/libip6tc.la ../extensions/libext6.a
 endif
+if HAVE_LIBNETFILTER_CONNTRACK
+xtables_multi_LDADD += @libnetfilter_conntrack_LIBS@
+endif
 xtables_multi_SOURCES += xshared.c
 xtables_multi_LDADD   += ../libxtables/libxtables.la -lm

--
1.8.1.5

