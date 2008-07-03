From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Thu, 3 Jul 2008 10:44:37 +0200
Message-ID: <200807031044.37410.ludwig.nussel@suse.de>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbYGCMwj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:52:39 -0400
Received: from Relay1.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 20E0F41728
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2008 10:44:38 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> I'm happy to announce ipset-2.3.2. Besides cosmetic changes and cleanups, 
> this release includes the sources of both the userspace tool and the 
> kernel modules: you can install ipset wihtout patch-o-matic-ng. Please 
> read the README file for the instructions on how to install ipset without 
> pom-ng.

Ah, nice. I'd like to suggest to add the following patch. It
separates building the kernel modules and the user space parts. That
eases packaging for distributions as the kernel part has to be
compiled several times for different kernel flavors so the
integrated way is not really useful there :-)
Additionally IP_NF_SET_MAX and IP_NF_SET_HASHSIZE should be moved to
kernel/Kbuild for that purpose. Atm one has to extract them from the
Makefile and define them manually for the kernel module build pass.

btw is there a reason why the tarball has a date appended to the
release number? I just wonder whether the package version should be
2.3.2_20080702 or whether 2.3.2 suffices.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>

---
 Makefile |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 253498e..3b4abe1 100644
--- a/Makefile
+++ b/Makefile
@@ -5,7 +5,7 @@
 ######################################################################
 
 ifndef KERNEL_DIR
-KERNEL_DIR=/usr/src/linux
+KERNEL_DIR=KERNEL_DIR=/lib/modules/$(shell uname -r)/build
 endif
 ifndef IP_NF_SET_MAX
 IP_NF_SET_MAX=256
@@ -36,7 +36,11 @@ SHARED_LIBS=$(foreach T, $(SETTYPES),libipset_$(T).so)
 INSTALL=$(DESTDIR)$(BINDIR)/ipset $(DESTDIR)$(MANDIR)/man8/ipset.8
 INSTALL+=$(foreach T, $(SETTYPES), $(DESTDIR)$(LIBDIR)/ipset/libipset_$(T).so)
 
-all: $(PROGRAMS) $(SHARED_LIBS)
+all: ipset modules
+
+ipset: $(PROGRAMS) $(SHARED_LIBS)
+
+modules:
 	cd kernel; make -C $(KERNEL_DIR) M=`pwd` IP_NF_SET_MAX=$(IP_NF_SET_MAX) IP_NF_SET_HASHSIZE=$(IP_NF_SET_HASHSIZE) modules
 
 .PHONY: tests
@@ -44,9 +48,9 @@ all: $(PROGRAMS) $(SHARED_LIBS)
 tests:
 	cd tests; ./runtest.sh
 
-ipset_install: all $(INSTALL)
+ipset_install: ipset $(INSTALL)
 
-modules_install:
+modules_install: modules
 	cd kernel; make -C $(KERNEL_DIR) M=`pwd` modules_install
 
 install: ipset_install modules_install
-- 
1.5.6


cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)







