From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.11 released
Date: Sat, 14 Jan 2012 15:52:13 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:42664 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab2ANOwQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jan 2012 09:52:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.11, which brings a couple of build fixes 
from Jan and a timeout bugfix for the hash:net,iface type where the timed 
out entries were still matched until the garbage collector erased them.

The new version includes two new features as well:

- The hash:*net* types support the "nomatch" flag for the entries,
  by which one can build up a set with exceptions. For example the set

	ipset create test hash:net
	ipset add test 192.168.0/24
	ipset add test 192.168.0/30 nomatch

   matches all IP addresses from 192.168.0/24 except the ones
   from 192.168.0/30. 

- Escaping notation added to support hostnames and service names with dash 
  in the name: such names must be enclosed by square brackets

	ipset add test [hostname-with-dash],[ftp-data]

Userspace changes:
 - Support hostnames and service names with dash
 - Exceptions support added to hash:*net* types
 - Set types moved into libipset library
 - Library map file added in order to support library versioning
 - doc: Linux 2.6.39 already has the defs (Jan Engelhardt)
 - build: install libipset in the right place (Jan Engelhardt)
 - Provide a pkgconfig file (Jan Engelhardt)
 - build: make distcheck work and use POSIX mode for tarball generation
   (Jan Engelhardt)
 - build: install libipset/linux_ip_set_list.h (Jan Engelhardt)
 - build: include libipset/nfproto.h (Jan Engelhardt)
 - build: process include/libipset/ (Jan Engelhardt)
 - build: use AC_CONFIG_AUX_DIR and stash away tools (Jan Engelhardt)
 - Update .gitignore (Jan Engelhardt)

Kernel part changes:
 - hash:net,iface timeout bug fixed
 - Exceptions support added to hash:*net* types
 - net: Add export.h for EXPORT_SYMBOL/THIS_MODULE to non-modules
 - Log warning when a hash type of set gets full

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
