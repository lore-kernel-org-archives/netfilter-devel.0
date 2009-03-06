From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-2.5.0
Date: Fri, 6 Mar 2009 11:44:36 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0903061141020.31761@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm happy to announce ipset 2.5.0. The changes of the release are

userspace:
  - On parisc architecture cast increases required aligment (bugzilla
    id 582), fixed.
  - Respect LDFLAGS settings at compile time (Peter Volkov).

kernel:
  - Use the spinlock initiator instead of setting the locks directly
    as it causes compilation errors with 2.6.29-rt (Jan Engelhardt).

You can download it as usual from http://ipset.netfilter.org/ or from
git:////git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
