From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.21 released
Date: Tue, 4 Mar 2014 22:12:26 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1403042207250.17838@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm happy to announce ipset 6.21, which, besides bugfixes and corrections, 
includes the new set type hash:ip,mark from Vytas Dauksa and the forceadd 
option from Josh Hunt. See the updated manpage about these new features.
 
Userspace changes:
  - ipset: add userspace support for forceadd (Josh Hunt)
  - kernel: uapi: fix MARKMASK attr ABI breakage (Florian Westphal)
  - lib: fix ifname 'physdev:' prefix parsing (Florian Westphal)
  - Prepare the kernel for create option flags when no extension is needed
  - print mark & mark mask in hex rather then decimal (Vytas Dauksa)
  - add markmask for hash:ip,mark data type (Vytas Dauksa)
  - add hash:ip,mark data type to ipset (Vytas Dauksa)
  - ipset: manpage: correct add action synopsis for hash:net,port,net.
    (Mart Frauenlob)
  - ipset: manpage: remove spare comma for hash:net,net test action.
    (Mart Frauenlob)
  - Fix all set output from list/save when set with counters in use.
    (Sergey Popovich)
  - ipset: Fix malformed output from list/save for ICMP types in port 
    field (Sergey Popovich)
  - ipset: fix timeout data type size (Nikolay Martynov)

Kernel part changes:
  - ipset: add forceadd kernel support for hash set types (Josh Hunt)
  - netfilter: ipset: move registration message to init from net_init
    (Ilia Mirkin)
  - kernel: uapi: fix MARKMASK attr ABI breakage (Florian Westphal)
  - Prepare the kernel for create option flags when no extension is needed
  - add markmask for hash:ip,mark data type (Vytas Dauksa)
  - add hash:ip,mark data type to ipset (Vytas Dauksa)
  - ipset: remove unused code (Stephen Hemminger)
  - netfilter: ipset: Add hash: fix coccinelle warnings (Fengguang Wu)
  - Typo in ip_set_hash_netnet.c fixed (David Binderman)
  - net ipset: use rbtree postorder iteration instead of opencoding
    (Cody P Schafer)
  - ipset: Follow manual page behavior for SET target on list:set
    (Sergey Popovich)

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
