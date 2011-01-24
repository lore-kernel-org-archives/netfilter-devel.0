From: "Holger Eitzenberger" <holger@eitzenberger.org>
Subject: [patch 6/6] ipset: fix spelling error
Date: Mon, 24 Jan 2011 22:36:37 +0100
Message-ID: <20110124214015.902503724@jonathan.eitzenberger.org>
References: <20110124213631.195499507@jonathan.eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1AXVkR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:40:17 -0500
Content-Disposition: inline; filename=ipset-fix-spelling-error.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ipset/src/errcode.c
===================================================================
--- ipset.orig/src/errcode.c
+++ ipset/src/errcode.c
@@ -30,14 +30,14 @@ static const struct ipset_errcode_table
 	{ EEXIST, IPSET_CMD_CREATE,
 	  "Set cannot be created: set with the same name already exists" },
 	{ IPSET_ERR_FIND_TYPE, 0,
-	  "Kernel error received: set type does not supported" },
+	  "Kernel error received: set type not supported" },
 	{ IPSET_ERR_MAX_SETS, 0,
 	  "Kernel error received: maximal number of sets reached, "
 	  "cannot create more." },
 	{ IPSET_ERR_INVALID_NETMASK, 0,
 	  "The value of the netmask parameter is invalid" },
 	{ IPSET_ERR_INVALID_FAMILY, 0,
-	  "The protocol family not supported by the set type" },
+	  "Potocol family not supported by the set type" },
 
 	/* DESTROY specific error codes */
 	{ IPSET_ERR_BUSY, IPSET_CMD_DESTROY,

