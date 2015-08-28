From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.26 released
Date: Fri, 28 Aug 2015 19:20:09 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1508281917380.22014@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm happy to announce ipset 6.26 which contains a bugfix and a few
cleanups and optimizations.

Userspace changes:
  - Out of bound access in hash:net* types fixed (reported by Dave Jones):
    new tests added to the testsuite to verify the fix
  - Warn about loaded in ip_set modules at module installation
  - Use IPSET_BIN in resize-and-list.sh and suppress echoing of loop
    variable
  - Manpage typo corrections (David Wittman)
  - Fix grammar error in manpage (Neutron Soutmun)

Kernel part changes:
  - Out of bound access in hash:net* types fixed (reported by Dave Jones)
  - Make struct htype per ipset family (originally from Sergey Popovich)
  - Optimize hash creation routine (originally from Sergey Popovich)
  - Make sure element data size is a multiple of u32 (originally from 
    Sergey Popovich)
  - Make NLEN compile time constant for hash types (originally from Sergey
    Popovich)
  - Simplify mtype_expire() for hash types (originally from Sergey 
    Popovich)
  - Count non-static extension memory into the set memory size for 
    userspace
  - net: sched: Simplify em_ipset_match (Eric W. Biederman)

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
