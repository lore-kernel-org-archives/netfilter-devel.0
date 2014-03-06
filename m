From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 5/8] netfilter: ipset: Prepare the kernel for create option flags when no extension is needed
Date: Thu,  6 Mar 2014 10:23:45 +0100
Message-ID: <1394097828-27901-6-git-send-email-kadlec@blackhole.kfki.hu>
References: <1394097828-27901-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:48207 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbaCFJXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:23:53 -0500
In-Reply-To: <1394097828-27901-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h      |    2 ++
 include/uapi/linux/netfilter/ipset/ip_set.h |    6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 4ac00d4..f476bce 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -219,6 +219,8 @@ struct ip_set {
 	u8 revision;
 	/* Extensions */
 	u8 extensions;
+	/* Create flags */
+	u8 flags;
 	/* Default timeout value, if enabled */
 	u32 timeout;
 	/* Element data size */
diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/linux/netfilter/ipset/ip_set.h
index f636f28..a29a378 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -188,6 +188,12 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
+/* The flag bits which correspond to the non-extension create flags */
+enum ipset_create_flags {
+	IPSET_CREATE_FLAG_NONE = 0,
+	IPSET_CREATE_FLAG_MAX = 7,
+};
+
 /* Commands with settype-specific attributes */
 enum ipset_adt {
 	IPSET_ADD,
-- 
1.7.10.4

