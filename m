From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  00/17] Xtables extensions: full support (pure nft or compat layer)
Date: Thu, 25 Jul 2013 20:16:20 +0300
Message-ID: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042Ab3GYRQm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:16:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Ok I won't repeat the long text about this RFC here again.
For more information, look at mail thread: "[iptables-nftables - RFC PATCH  00/15] Xtables extensions: full support (pure nft or compat layer)"

I applied the basic changes I told.

Note: this version still requires to be built with --enable-static. See patch 9.

Thanks,


Tomasz Bursztyka (17):
  nft: Remove useless function
  xtables: Add support for injecting xtables target into nft rule
  xtables: add support for injecting xtables matches into nft rule
  nft: Add nft expressions translation engine as a library
  nft: Integrate nft translator engine in current core
  nft: Manage xtables target parsing through translation tree
  nft: Manage xtables matches through nft translation tree
  nft: Add support for xtables extensions callback to change cs
  xtables: Add support for registering nft translation function for
    target
  xtables: Add support for registering nft translation function for
    match
  nft: Register all relevant xtables extensions into translation tree
  nft: Refactor firewall printing so it reuses already parsed cs struct
  nft: Refactor rule deletion so it compares both cs structure
  xtables: nft: Complete refactoring on how rules are saved
  xtables: Support pure nft expressions for DNAT extension
  nft: Add a function to reset the counters of an existing rule
  xtables: Support -Z options for a given rule number

 Makefile.am                       |   3 +
 configure.ac                      |   8 +
 extensions/GNUmakefile.in         |   1 +
 extensions/libipt_DNAT.c          | 221 +++++++++
 include/nft-translator.h          |  81 ++++
 include/xtables.h                 |  13 +
 iptables/Makefile.am              |   3 +-
 iptables/nft-ipv4.c               | 125 ++---
 iptables/nft-ipv6.c               |  81 ++--
 iptables/nft-shared.c             |  72 ++-
 iptables/nft-shared.h             |  23 +-
 iptables/nft-xt-ext.c             | 178 ++++++++
 iptables/nft-xt-ext.h             |  14 +
 iptables/nft.c                    | 934 +++++++++++++-------------------------
 iptables/nft.h                    |   9 +-
 iptables/xtables-events.c         |  21 +-
 iptables/xtables.c                |  15 +-
 libnfttrans/.nft-translator.c.swp | Bin 0 -> 28672 bytes
 libnfttrans/Makefile.am           |  28 ++
 libnfttrans/libnfttrans.pc        |  11 +
 libnfttrans/libnfttrans.pc.in     |  11 +
 libnfttrans/nft-translator.c      | 571 +++++++++++++++++++++++
 22 files changed, 1637 insertions(+), 786 deletions(-)
 create mode 100644 include/nft-translator.h
 create mode 100644 iptables/nft-xt-ext.c
 create mode 100644 iptables/nft-xt-ext.h
 create mode 100644 libnfttrans/.nft-translator.c.swp
 create mode 100644 libnfttrans/Makefile.am
 create mode 100644 libnfttrans/libnfttrans.pc
 create mode 100644 libnfttrans/libnfttrans.pc.in
 create mode 100644 libnfttrans/nft-translator.c

-- 
1.8.3.2

