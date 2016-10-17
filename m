From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.30 released
Date: Mon, 17 Oct 2016 16:31:14 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1610171627220.29689@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:41770 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932779AbcJQObU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 10:31:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.30 which introduces a new set type, 
hash:ip,mac, and brings a couple of small corrections and backports from 
the most recent kernel tree.

Userspace changes:
  - Drop extra comma from error message (Neutron Soutmun)
  - Fix the incorrect dynamic/static modules list (Neutron Soutmun)
  - Correct tests to check the number of entries too
  - hash:ipmac type support added to ipset, userspace part (Tomasz 
    Chilinski)
Kernel part changes:
  - netfilter: ipset: hash: fix boolreturn.cocci warnings
    (Fengguang Wu)
  - Fix the nla_put_net64() API changes backport
  - netfilter: ipset: Fixing unnamed union init (Elad Raz)
  - netfilter: x_tables: Use par->net instead of computing from the passed
    net devices (Eric W. Biederman)
  - Correct the reported memory size for bitmap:* types
  - Fix coding styles reported by checkpatch.pl, already in kernel
  - netfilter: x_tables: Pass struct net in xt_action_param
    (Eric W. Biederman)
  - net: sched: fix skb->protocol use in case of accelerated vlan path
    (Jiri Pirko)
  - Check IPSET_ATTR_ETHER netlink attribute length in hash:ipmac too
  - netfilter: fix include files for compilation (Mikko Rapeli)
  - ipset: Backports for the nla_put_net64() API changes (Neutron Soutmun)
  - netfilter: ipset: use setup_timer() and mod_timer().
    (Muhammad Falak R Wani)
  - hash:ipmac type support added to ipset (Tomasz Chilinski)

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
