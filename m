From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.20 released
Date: Wed, 2 Oct 2013 23:21:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1310022310180.5975@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:47373 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab3JBVVi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:21:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.20 which brings one important bugfix, 
several new features and lot of small corrections, fixes.

The important bugfix is from Oliver Smith, which affects all hash types 
with a net element: if a CIDR value is deleted such that none of the same 
size exist any more, all larger (less-specific) values will then fail to 
match.

The most important new features are:

- netns support from Vitaly Lavrov
- hash:net,net and hash:net,port,net set types from Oliver Smith
- comment extension from Oliver Smith, which makes possible to annotate
  the set elements.

See the list of the changes:

Userspace changes:
  - Missing comment support added to hash:ip,port,ip and hash:net,iface
    types
  - Compatibility code is modified not to rely on kernel version numbers
  - Add userspace code to support hash:net,port,net kernel module
    (Oliver Smith)
  - Tests added to check comment extension
  - Add new userspace set revisions for comment support (Oliver Smith)
  - Support comments in the userspace library (Oliver Smith)
  - Rework the "fake" argument parsing for ipset restore (Oliver Smith)
  - Add userspace code to support hash:net,net kernel module
    (Oliver Smith)
  - Add test to verify CIDR tracking
  - configure: uclinux is also linux (Gustavo Zacarias)
  - Add specifying protocol for bitmap:port (Quentin Armitage)
  - Remove artifical restriction of netmask values for hash:ip type
    (Reported by Quentin Armitage, netfilter bugzilla id #844)
  - Make sure called test scripts can be executed (reported by Tomas 
    Budai)
  - Manpage fix: not just identical, but compatible type of sets can be
    swapped (Reported by Quentin Armitage, netfilter bugzilla id #843)
  - Fix error message typo (Reported by Quentin Armitage, netfilter 
    bugzilla id #843)
  - Parse option "family" first, because other options may depend on it
    (Bug reported by Quentin Armitage, closed netfilter bugzilla #841)
  - Change 2nd parameter type of ipset_parse_elem (Quentin Armitage)
  - Report broken netlink messages in debug mode
  - Fix hyphen used as minus sign in manpage (Neutron Soutmun)
  - libipset.pc must be installed via 'make install' (Eric Leblond)

Kernel part changes:
  - Compatibility code is modified not to rely on kernel version numbers
  - Use netlink callback dump args only
  - Add hash:net,port,net module to kernel (Oliver Smith)
  - Add net namespace for ipset (Vitaly Lavrov)
  - Use a common function at listing the extensions of the elements
  - For set:list types, replaced elements must be zeroed out
  - Fix hash resizing with comments
  - Support comments in the list-type ipset (Oliver Smith)
  - Support comments in bitmap-type ipsets (Oliver Smith)
  - Support comments in hash-type ipsets (Oliver Smith)
  - Support comments for ipset entries in the core (Oliver Smith)
  - Add hash:net,net module to kernel (Oliver Smith)
  - Fix serious failure in CIDR tracking (Oliver Smith)
  - list:set: make sure all elements are checked by the gc
  - Support extensions which need a per data destroy function
  - Generalize extensions support
  - Move extension data to set structure
  - Rename extension offset ids to extension ids
  - Prepare ipset to support multiple networks for hash types
  - Introduce new operation to get both setname and family
  - Validate the set family and not the set type family at swapping
    (Bug reported by Quentin Armitage, netfilter bugzilla id #843)
  - Consistent userspace testing with nomatch flag
  - Skip really non-first fragments for IPv6 when getting port/protocol
  - ipset standalone package needs to ship em_ipset.c (reported by Jan
    Engelhardt)

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
