Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB69EB64DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jul 2023 12:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjGRMBr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 08:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjGRMBq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 08:01:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F277E42
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 05:01:44 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     arturo@netfilter.org, jengelh@inai.de
Subject: [PATCH nft 1/2] update INSTALL file
Date:   Tue, 18 Jul 2023 14:01:18 +0200
Message-Id: <20230718120119.172757-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update it to current library dependencies and existing options.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 INSTALL | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/INSTALL b/INSTALL
index a3f10c372d14..9a597057ae3e 100644
--- a/INSTALL
+++ b/INSTALL
@@ -4,7 +4,7 @@ Installation instructions for nftables
  Prerequisites
  =============
 
-  - standard glibc headers, gcc etc.
+  - build tooling: glibc headers, gcc, autotools, automake, libtool, pkg-config.
 
   - libmnl: git://git.netfilter.org/libmnl.git
 
@@ -14,17 +14,15 @@ Installation instructions for nftables
 
   - bison
 
-  - libgmp
+  - libgmp: alternatively, see mini-gmp support below.
 
-  - libreadline
-
-  - pkg-config
-
-  - libtool
+  - libreadline or libedit or linenoise: required by interactive command line
 
   - optional: libxtables: required to interact with iptables-compat
 
-  - optional: docbook2x: required for building man-page
+  - optional: libjansson: required to build JSON support
+
+  - optional: asciidoc: required for building man-page
 
  Configuring and compiling
  =========================
@@ -60,17 +58,36 @@ Installation instructions for nftables
 	For libxtables support to interact with the iptables-compat
 	utility.
 
- Suggested configuration options: --prefix=/ --datarootdir=/usr/share
+ --without-cli
+
+	To disable interactive command line support, ie. -i/--interactive.
+
+ --with-cli=readline
+
+	To enable interactive command line support with libreadline.
+
+ --with-cli=linenoise
+
+	To enable interactive command line support with linenoise.
+
+ --with-cli=editline
+
+	To enable interactive command line support with libedit.
+
+ --with-json
+
+	To enable JSON support, this requires libjansson.
 
  Run "make" to compile nftables, "make install" to install it in the
  configured paths.
 
- Other notes
+ Source code
  ===========
 
- The nftables kernel tree can be found at:
+ Netfilter's Linux kernel tree can be found at:
 
- git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nftables.git
+ git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git/
+ https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git
 
  The latest version of this code can be found at:
 
-- 
2.30.2

