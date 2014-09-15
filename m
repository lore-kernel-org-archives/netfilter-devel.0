From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.22 released
Date: Mon, 15 Sep 2014 23:13:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409152304001.10006@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:40498 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277AbaIOVMx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:12:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.22, which, besides bugfixes and corrections, 
includes the new set type hash:mac and the skbinfo extension from Anton 
Danilov. The skbinfo extension makes possible to store fw mark, tc class 
and/or hardware queue parameters together with the set elements and then 
attach them to the matchig packets by the SET target. Example

ipset create mark_values hash:net skbinfo
ipset add mark_values 8.8.8.8/32 skbmark 0x1/0xffff
...
iptables -t mangle -A OUTPUT -p tcp -o iface \
	-j SET --map-set mark_values dst --map-mark

(At the moment the support of the --map-set options of
the SET target is available in the ipset branch of the iptables
git tree.)

Userspace changes:
  - hash:mac type added to ipset
  - Add test to check mark mapping
  - ipset: remove extran newline on debug output (Holger Eitzenberger)
  - ipset: avoid duplicate command flags (Holger Eitzenberger)
  - Remove a duplicate debug print (Holger Eitzenberger)
  - ipset: man: Add the skbinfo extension documentation. (Anton Danilov)
  - libipset: Add userspace support of the skbinfo extension of the list
    set type. (Anton Danilov)
  - libipset: Add userspace support of the skbinfo extension of the hash
    set types. (Anton Danilov)
  - libipset: Add userspace support of the skbinfo extension of the
    bitmap set types. (Anton Danilov)
  - libipset: Add userspace code for the skbinfo extension support.
    (Anton Danilov)
  - Make possible to compile ipset with IPSET_DEBUG from the dist.
    (Clinton Roy)
  - libipset: print third element in debugging (Sergey Popovich)
  - ipset: Handle missing leading zeros in ethernet address parser
    (Janeks Jaunups)
  - ipset: Pass IPSET_BIN to test scripts to change binary location
    (Neutron Soutmun)
  - ipset: Fix grammar error in manpage (Neutron Soutmun)
  - ipset: Fix printf format warning (Neutron Soutmun)

Kernel part changes:
  - hash:mac type added to ipset
  - skbinfo extension: send nonzero extension elements only to userspace
  - netfilter: Convert pr_warning to pr_warn (Joe Perches)
  - netfilter: ipset: Add skbinfo extension support to SET target.
    (Anton Danilov)
  - netfilter: ipset: Add skbinfo extension kernel support for the list
    set type. (Anton Danilov)
  - netfilter: ipset: Add skbinfo extension kernel support for the hash
    set types. (Anton Danilov)
  - netfilter: ipset: Add skbinfo extension kernel support for the
    bitmap set types. (Anton Danilov)
  - netfilter: ipset: Add skbinfo extension kernel support in the ipset
    core. (Anton Danilov)
  - Fix static checker warning in ip_set_core.c (reported by Dan 
    Carpenter)
  - Fix warn: integer overflows 'sizeof(*map) + size * set->dsize'
    (reported by Dan Carpenter)
  - net/netfilter/ipset: Resolve missing-field-initializer warnings
    (Mark Rustad)
  - netnet,netportnet: Fix value range support for IPv4 (Sergey Popovich)
  - Removed invalid IPSET_ATTR_MARKMASK validation (Vytas Dauksa) 

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
