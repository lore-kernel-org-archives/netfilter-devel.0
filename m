From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.20.1 released
Date: Sun, 27 Oct 2013 19:52:01 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1310271947300.7144@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:33199 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab3J0SwE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:52:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.20.1. The most important fix in this release 
is the memory allocation for bitmap:port: unnecessarily large memory was 
allocated in versions 6.19-6.20.

Userspace changes:
  - build: fix incorrect library versioning (Jan Engelhardt)
  - netfilter: ipset: Fix configure failure when --with-kmod=no
    (Oliver Smith)
  - Avoid clashing with configured kernel in [CONFIG_]IP_SET_MAX

Kernel part changes:
  - netfilter: ipset: remove duplicate define (Michael Opdenacker)
  - net->user_ns is available starting from 3.8, add compatibility
    checking (reported by Jan Engelhardt)
  - Fix memory allocation for bitmap:port (reported by Quentin Armitage)
  - Avoid clashing with configured kernel in [CONFIG_]IP_SET_MAX
  - The unnamed union initialization may lead to compilation error
    (reported by Husnu Demir)
  - Use dev_net() instead of the direct access to ->nd_net (reported by
    the kbuild test robot)

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
