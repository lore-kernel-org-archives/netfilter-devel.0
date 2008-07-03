From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Thu, 3 Jul 2008 11:09:10 +0200
Message-ID: <200807031109.10622.ludwig.nussel@suse.de>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu> <200807031044.37410.ludwig.nussel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:58248 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760039AbYGCMmj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:42:39 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 3628F417F6
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2008 11:09:11 +0200 (CEST)
In-Reply-To: <200807031044.37410.ludwig.nussel@suse.de>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ludwig Nussel wrote:
> Jozsef Kadlecsik wrote:
> > I'm happy to announce ipset-2.3.2. Besides cosmetic changes and cleanups, 
> > this release includes the sources of both the userspace tool and the 
> > kernel modules: you can install ipset wihtout patch-o-matic-ng. Please 
> > read the README file for the instructions on how to install ipset without 
> > pom-ng.
> 
> Ah, nice. I'd like to suggest to add the following patch. It
> separates building the kernel modules and the user space parts. That
> [...]
> +ipset: $(PROGRAMS) $(SHARED_LIBS)

*grmbl* Not using targets that are also programs actually
produces a working binary.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>

diff --git a/Makefile b/Makefile
index 3b4abe1..e049d4f 100644
--- a/Makefile
+++ b/Makefile
@@ -36,9 +36,9 @@ SHARED_LIBS=$(foreach T, $(SETTYPES),libipset_$(T).so)
 INSTALL=$(DESTDIR)$(BINDIR)/ipset $(DESTDIR)$(MANDIR)/man8/ipset.8
 INSTALL+=$(foreach T, $(SETTYPES), $(DESTDIR)$(LIBDIR)/ipset/libipset_$(T).so)
 
-all: ipset modules
+all: userspace modules
 
-ipset: $(PROGRAMS) $(SHARED_LIBS)
+userspace: $(PROGRAMS) $(SHARED_LIBS)
 
 modules:
 	cd kernel; make -C $(KERNEL_DIR) M=`pwd` IP_NF_SET_MAX=$(IP_NF_SET_MAX) IP_NF_SET_HASHSIZE=$(IP_NF_SET_HASHSIZE) modules
@@ -48,7 +48,7 @@ modules:
 tests:
 	cd tests; ./runtest.sh
 
-ipset_install: ipset $(INSTALL)
+ipset_install: userspace $(INSTALL)
 
 modules_install: modules
 	cd kernel; make -C $(KERNEL_DIR) M=`pwd` modules_install
-- 
1.5.6

-- 
 (o_   Ludwig Nussel
 //\   
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)

