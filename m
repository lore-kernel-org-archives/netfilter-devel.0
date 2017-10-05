From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] INSTALL: Update dependency list and configure with libxtables support
Date: Thu,  5 Oct 2017 13:01:09 +0530
Message-ID: <20171005073109.19874-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add configure with lixtables in INSTALL and required dependencies for
the same

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 INSTALL | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/INSTALL b/INSTALL
index 3e9a6ad..04981f1 100644
--- a/INSTALL
+++ b/INSTALL
@@ -18,6 +18,12 @@ Installation instructions for nftables
 
   - libreadline
 
+  - pkg-config
+
+  - libtool
+
+  - optional: libxtables: required for libxtables support
+
   - optional: docbook2x: required for building man-page
 
   - optional: docbook-utils: required for building PDF man-page
@@ -51,6 +57,11 @@ Installation instructions for nftables
 	having no other use for libgmp.
 	Note: This decreases the debugging verbosity in some files.
 
+ --with-xtables
+
+	For libxtables support which allow input of tables with -f
+ 	option in nft.
+
  Suggested configuration options: --prefix=/ --datarootdir=/usr/share
 
  Run "make" to compile nftables, "make install" to install it in the
-- 
2.11.0
