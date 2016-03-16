From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.29 released
Date: Wed, 16 Mar 2016 21:40:24 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1603162136130.7414@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:54136 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbcCPUjg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2016 16:39:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

ipset 6.29 is released, because the configure script was broken and a
race condition was fixed in concurrent save-swap and then delete 
operations.

Userspace changes:
  - Suppress unnecessary stderr in command loop for resize and list
  - Correction in comment test
  - Support chroot buildroots (reported by Jan Engelhardt)
  - Fix "configure" breakage due to pkg-config related changes
    (reported by Jan Engelhardt)
Kernel part changes:
  - Fix race condition in ipset save, swap and delete (Vishwanath Pai)

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
