From: Sven Wegener <sven.wegener@stealer.net>
Subject: ipset: Introduce KBUILD_OUTPUT to support kernels build with O=
Date: Thu, 18 Sep 2008 15:16:45 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0809181515130.22510@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:55923 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYIRNQ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:16:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 Makefile |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

I did not change the default path to the symlinks in /lib/modules, because 
2.4 kernels do not have these links.

--- ipset.orig/Makefile
+++ ipset/Makefile
@@ -7,6 +7,9 @@
 ifndef KERNEL_DIR
 KERNEL_DIR=/usr/src/linux
 endif
+ifndef KBUILD_OUTPUT
+KBUILD_OUTPUT=$(KERNEL_DIR)
+endif
 ifndef IP_NF_SET_MAX
 IP_NF_SET_MAX=256
 endif
@@ -53,12 +56,12 @@
 modules:
 	@[ ! -f $(KERNEL_DIR)/net/ipv4/netfilter/Config.in ] || (echo "Error: The directory '$(KERNEL_DIR)' looks like a Linux 2.4.x kernel source tree, you have to patch it by 'make patch_kernel'." && exit 1)
 	@[ -f $(KERNEL_DIR)/net/ipv4/netfilter/Kconfig ] || (echo "Error: The directory '$(KERNEL_DIR)' doesn't look like a Linux 2.6.x kernel source tree." && exit 1)
-	@[ -f $(KERNEL_DIR)/.config ] || (echo "Error: The kernel source in '$(KERNEL_DIR)' must be configured" && exit 1)
-	@[ -f $(KERNEL_DIR)/Module.symvers ] || echo "Warning: You should run 'make modules' in '$(KERNEL_DIR)' beforehand"
-	cd kernel; make -C $(KERNEL_DIR) M=`pwd` IP_NF_SET_MAX=$(IP_NF_SET_MAX) IP_NF_SET_HASHSIZE=$(IP_NF_SET_HASHSIZE) modules
+	@[ -f $(KBUILD_OUTPUT)/.config ] || (echo "Error: The kernel source in '$(KERNEL_DIR)' must be configured" && exit 1)
+	@[ -f $(KBUILD_OUTPUT)/Module.symvers ] || echo "Warning: You should run 'make modules' in '$(KERNEL_DIR)' beforehand"
+	cd kernel; make -C $(KBUILD_OUTPUT) M=`pwd` IP_NF_SET_MAX=$(IP_NF_SET_MAX) IP_NF_SET_HASHSIZE=$(IP_NF_SET_HASHSIZE) modules
 
 modules_install: modules
-	cd kernel; make -C $(KERNEL_DIR) M=`pwd` modules_install
+	cd kernel; make -C $(KBUILD_OUTPUT) M=`pwd` modules_install
 
 install: binaries_install modules_install
 
