From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.3 released
Date: Sun, 10 Apr 2011 17:40:17 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104101734180.3240@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm happy to announce ipset 6.3. The number of changes is relatively 
small, with one important fix in the SET target with --del-set option. As 
it was non-functional, if you need the SET target with --del-set then 
please upgrade.

Kernel part changes:
 - ipset/Kconfig was a mixed up kernel config file, fixed (Michael 
   Tokarev)
 - bitmap:ip,mac type requires "src" for MAC, enforce it
 - whitespace fixes: some space before tab slipped in
 - set match and SET target fixes (bugs reported by Lennert Buytenhek)

Userspace changes:
 - Testsuite changes: keep temporary files
 - bitmap:ip,mac type requires "src" for MAC: manpage is updated to 
   reflect the change
 - Testsuite checks added (SET target and dir parameter checks)

The syntax checking of the set match/target extensions of ip6?tables was 
also fixed: if you want to run the testsuite in ipset, you need iptables
from the git tree.

You can download the source code from:
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
