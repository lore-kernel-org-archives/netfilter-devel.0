From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-3.0 released
Date: Sat, 16 May 2009 22:10:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905162203170.3688@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:37545 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170AbZEPUKM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2009 16:10:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm happy to announce the ipset-3.0 release, codename "big end" :-):
the release fixes bigendian and 64/32bit environment-related bugs and 
issues.

In consequence of the 64/32bit issues, the kernel-userspace protocol 
version number had to be bumped. Therefore if you upgrade to 3.0, you must 
install both the kernel modules and the ipset binary from the package - 
the kernel won't work with older ipset binaries and the new binary won't 
work with older ipset kernel modules. Here follows the new changelog 
entries:

userspace:
  - New kernel-userspace protocol release
  - Bigendian and 64/32bit fixes (Stefan Gula, bugzilla id 593)
  - tests/runtests.sh changed to support old bash shells

kernel part:
  - New kernel-userspace protocol release
  - Bigendian and 64/32bit fixes (Stefan Gula, bugzilla id 593)
  - Support of 2.4.3[67].*  kernels fixed
  - Compiling with debugging enabled fixed

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
