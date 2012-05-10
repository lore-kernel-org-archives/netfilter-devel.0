From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.12 released
Date: Thu, 10 May 2012 12:18:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:37623 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861Ab2EJKTB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 May 2012 06:19:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.12. This release contains a few important 
bugfixes, dynamic module support in the ipset tool by Neutron Soutmun
and several backports and compatibility fixes.

Please note: if you compile ipset with gcc 4.7 or above, you must use this 
release. The bug reported by Seblu in previous releases results a broken 
binary when compiled with gcc 4.7 or above.

Userspace changes:
 - Cleanup generated files by make tidy
 - Add more CC warning option to debug mode
 - Report syntax error messages immediately
 - Suppress false syntax error messages
 - Add configure summary for the ipset userspace tool
 - Add dynamic module support to ipset userspace tool
   (Neutron Soutmun)
 - Move ipset_port_usage() into lib (Neutron Soutmun)
 - Fix invalid assignment to const void pointer (bug reported by Seblu)
 - Remove unused variables (warnings fixed)
 - Fix timeout value overflow bug at large timeout parameters
   (bug reported by Andreas Herz)
 - Improve ipset help text messages (Mr Dash Four)

Kernel part changes:
 - Backport nla_put_net* functions as NLA_PUT* were removed
 - netlink: add netlink_dump_control structure for netlink_dump_start()
 - ipset: Stop using NLA_PUT*().
 - Fix hash size checking in kernel (bug reported by Seblu)
 - Correct README file about minimal required iptables version
   (Oskar Berggren)
 - Sparse warnings "incorrect type in assignment" fixed
 - Fix timeout value overflow bug at large timeout parameters
   (bug reported by Andreas Herz)
 - ipv6: Add fragment reporting to ipv6_skip_exthdr().
 - net: remove ipv6_addr_copy()
 - Fix the inclusion of linux/export.h (Henry Culver)

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
