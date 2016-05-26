From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] build: update LIBVERSION to prepare a new release
Date: Thu, 26 May 2016 16:42:18 +0200
Message-ID: <1464273738-13993-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53514 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbcEZOmb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 May 2016 10:42:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B27DD1CC64A
	for <netfilter-devel@vger.kernel.org>; Thu, 26 May 2016 16:42:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A4D9B11FE82
	for <netfilter-devel@vger.kernel.org>; Thu, 26 May 2016 16:42:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2405411FE82
	for <netfilter-devel@vger.kernel.org>; Thu, 26 May 2016 16:42:24 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bump Current and Age accordingly, given that we got new interfaces.
This git repository shows these changes in the map file since previous
release:

$ git diff libnftnl-1.0.5..HEAD src/libnftnl.map
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -498,3 +498,33 @@ global:

 local: *;
 };
+
+LIBNFTNL_4.1 {
+       nftnl_trace_alloc;
+       nftnl_trace_free;
+
+       nftnl_trace_is_set;
+
+       nftnl_trace_get_u16;
+       nftnl_trace_get_u32;
+       nftnl_trace_get_u64;
+       nftnl_trace_get_str;
+       nftnl_trace_get_data;
+
+       nftnl_trace_nlmsg_parse;
+
+       nftnl_udata_buf_alloc;
+       nftnl_udata_buf_free;
+       nftnl_udata_buf_len;
+       nftnl_udata_buf_data;
+       nftnl_udata_buf_put;
+       nftnl_udata_start;
+       nftnl_udata_end;
+       nftnl_udata_put;
+       nftnl_udata_put_strz;
+       nftnl_udata_type;
+       nftnl_udata_len;
+       nftnl_udata_get;
+       nftnl_udata_next;
+       nftnl_udata_parse;
+} LIBNFTNL_4;

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Make_global.am | 2 +-
 configure.ac   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 6720d28..94c5dfc 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -18,7 +18,7 @@
 # set age to 0.
 # </snippet>
 #
-LIBVERSION=4:0:0
+LIBVERSION=5:0:1
 
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include ${LIBMNL_CFLAGS} ${LIBMXML_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 569dfbf..b78091e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,6 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT([libnftnl], [1.0.5])
+AC_INIT([libnftnl], [1.0.6])
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
-- 
2.1.4

