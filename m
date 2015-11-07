From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.27 released
Date: Sat, 7 Nov 2015 13:49:33 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1511071342340.14242@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm happy to announce ipset 6.27 with a couple of important fixes, notably 
hash type expiration and alignment fixes for different architectures.

Userspace changes:
  - Handle uint64_t alignment issue in ipset tool
Kernel part changes:
  - Fix reported memory size for hash:* types
  - Fix hash type expire: release empty hash bucket block
  - Fix hash type expiration: incorrect index fixed
  - Collapse same condition body to a single one
  - Fix extension alignment
  - Compatibility: include linux/export.h when needed
  - Compatibility: make sure vmalloc.h is included for kvfree()
  - Compatibility: Fix detecting 'struct net' in 'struct tcf_ematch'
  - Compatibility: Protect definition of RCU_INIT_POINTER in compatibility
    header file
  - netfilter: ipset: Fix sleeping memory allocation in atomic context
    (Nikolay Borisov)

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
