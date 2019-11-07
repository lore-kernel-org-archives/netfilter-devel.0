Return-Path: <SRS0=biDG=Y7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6030CC5DF61
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Nov 2019 11:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EBE7214D8
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Nov 2019 11:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733303AbfKGLpa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Nov 2019 06:45:30 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:35802 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbfKGLpa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Nov 2019 06:45:30 -0500
Received: from localhost ([::1]:48892 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iSgED-0005fS-IZ; Thu, 07 Nov 2019 12:45:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] files: Install sample scripts from files/examples
Date:   Thu,  7 Nov 2019 12:45:16 +0100
Message-Id: <20191107114516.9258-2-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191107114516.9258-1-phil@nwl.cc>
References: <20191107114516.9258-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Assuming these are still relevant and useful as a source of inspiration,
install them into DATAROOTDIR/doc/nftables/examples.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac               | 1 +
 files/Makefile.am          | 1 +
 files/examples/Makefile.am | 4 ++++
 3 files changed, 6 insertions(+)
 create mode 100644 files/examples/Makefile.am

diff --git a/configure.ac b/configure.ac
index 170b609321458..3a512e0295dc9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -137,6 +137,7 @@ AC_CONFIG_FILES([					\
 		include/linux/netfilter_ipv4/Makefile	\
 		include/linux/netfilter_ipv6/Makefile	\
 		files/Makefile				\
+		files/examples/Makefile			\
 		files/nftables/Makefile			\
 		files/osf/Makefile			\
 		doc/Makefile				\
diff --git a/files/Makefile.am b/files/Makefile.am
index 4f41b664e9db7..7deec15129772 100644
--- a/files/Makefile.am
+++ b/files/Makefile.am
@@ -1,2 +1,3 @@
 SUBDIRS =	nftables \
+		examples \
 		osf
diff --git a/files/examples/Makefile.am b/files/examples/Makefile.am
new file mode 100644
index 0000000000000..c40e041e43578
--- /dev/null
+++ b/files/examples/Makefile.am
@@ -0,0 +1,4 @@
+pkgdocdir = ${docdir}/examples
+dist_pkgdoc_SCRIPTS = ct_helpers.nft \
+		load_balancing.nft \
+		sets_and_maps.nft
-- 
2.24.0

