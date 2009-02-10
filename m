From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-2.4.8
Date: Tue, 10 Feb 2009 20:25:41 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0902102019120.10299@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

I'm happy to announce ipset version 2.4.8. In the new version there's a 
bugfix, performance improvement and more (better) compatibility with old 
systems. The full list of changes are

- Userspace changes
  - In order to disable the extra warning flags, NO_EXTRA_WARN_FLAGS
    variable added to userspace Makefile
- Kernel part changes
  - The Jenkins' hash lookup2() replaced with Jenkins' faster/better 
    lookup3() hash function.
  - Bug fixed: after elements are added and deleted from a hash, an 
    element can successfully be added in spite it's already in the hash 
    and thus duplicates can occur (bug spotted by Shih-Yi Chen). 
  - Compatibility with old gcc without 'bool' added.

You can download the new tarball from http://ipset.netfilter.org/ or 
directly from git://git.netfilter.org/ipset.git.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
