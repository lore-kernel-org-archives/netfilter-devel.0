From: heitzenberger@astaro.com
Subject: [patch 1/1] Add subsystem accessors
Date: Wed, 30 Jan 2008 19:21:29 +0100
Message-ID: <20080130182454.607358723@kruemel.intranet.astaro.de>
References: <20080130182128.826992459@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-41.dex002.intermedia.net ([64.78.21.130]:31405 "EHLO
	dhost002-41.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbYA3SlW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:41:22 -0500
Content-Disposition: inline; filename=nfct-add-subsys-accessors.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Need by newer ulogd v2.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: libnetfilter-conntrack/include/libnetfilter_conntrack/libnetfilter_conntrack.h
===================================================================
--- libnetfilter-conntrack.orig/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ libnetfilter-conntrack/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -44,6 +44,12 @@ extern int nfct_close(struct nfct_handle
 extern int nfct_fd(struct nfct_handle *cth);
 extern const struct nfnl_handle *nfct_nfnlh(struct nfct_handle *cth);
 
+/*
+ * Subsys accessors
+ */
+extern struct nfnl_subsys_handle *nfct_subsys_ct(const struct nfct_handle *);
+extern struct nfnl_subsys_handle *nfct_subsys_exp(const struct nfct_handle *);
+
 /* 
  * NEW libnetfilter_conntrack API 
  */
Index: libnetfilter-conntrack/src/main.c
===================================================================
--- libnetfilter-conntrack.orig/src/main.c
+++ libnetfilter-conntrack/src/main.c
@@ -109,3 +109,18 @@ const struct nfnl_handle *nfct_nfnlh(str
 {
 	return cth->nfnlh;
 }
+
+/*
+ * Subsystem accessors
+ */
+struct nfnl_subsys_handle *
+nfct_subsys_ct(const struct nfct_handle *cth)
+{
+	return cth->nfnlssh_ct;
+}
+
+struct nfnl_subsys_handle *
+nfct_subsys_exp(const struct nfct_handle *cth)
+{
+	return cth->nfnlssh_exp;
+}

-- 
Holger Eitzenberger <heitzenberger@astaro.com> | Kernel Developer
Astaro AG | www.astaro.com | Phone +49-721-490069-33 | Fax -55
