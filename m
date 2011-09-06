From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.9.1 released
Date: Tue, 6 Sep 2011 21:49:52 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1109062143300.9388@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:34432 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab1IFTty (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:49:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.9.1. It contains two important bugfixes: if 
you use ipset on a hardware with tight memory usage, please upgrade.

Kernel part changes:
 - Fix compiling ipset as external kernel modules (broken v6.9)
 - Complete Kconfig with hash:net,iface type (standalone package)
 - rtnetlink: Compute and store minimum ifinfo dump size (Greg Rose)
 - Remove redundant linux/version.h includes from net/ (Jesper Juhl)
 - ipset: use NFPROTO_ constants (Jan Engelhardt)
 - netfilter: ipset: expose userspace-relevant parts in ip_set.h
   (Jan Engelhardt)
 - netfilter: ipset: avoid use of kernel-only types (Jan Engelhardt)
 - netfilter: Remove unnecessary OOM logging messages (Joe Perches)
 - Dumping error triggered removing references twice and lead to kernel 
   BUG
 - Autoload set type modules safely

Userspace changes:
 - build: move ipset_errcode into library (Jan Engelhardt)
 - build: abort autogen on subcommand failure (Jan Engelhardt)
 - ipset: use NFPROTO_ constants (Jan Engelhardt)
 - Propagate "expose userspace-relevant parts in ip_set.h" to ipset source

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
