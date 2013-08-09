From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 00/16] Xtables extensions: full support (pure nft or compat layer)
Date: Fri,  9 Aug 2013 16:31:14 +0300
Message-ID: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967605Ab3HINbh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rebased patch set of my RFC, against latest trunk.

Still requires to be built with --enable-static due to patch 10 (and that's something to be fixed, see below)

@Pablo: could you spend some time reviewing it, please? Don't spend too much yet on the code (though I have tested it and it works very well),
but I would like your opinion on the idea it implements. Code could be then changed/adapted if necessary.

To sum up:
- Parsing of rule happen one time in only one place (nft_rule_expr_iter() is called only once for good), via an expression pattern matching mechanism.
- Centralized parsing strategy for both usual stuff (ips, ifs, verdicts...) and also all xtables extensions.
  It recreates an iptables_command_structure. That's why there is a lot of refactoring (it removes a lot of duplicate expression list loops etc...)
- And of course transparent support on xtables extensions for both full nft based expressions list or when using xt compat layer in nftables.
 (so it will require now to "translate" little by little all xtables extensions, but the result will be transparent to the user. It will just get rid of the old fashioned xtables memory blob 
  one after another. So at some point it will work without any xtables modules in kernel side. DNAT is provided as an example here).
- Same strategy woulde be used in futur xtables-arptables and xtables-ebtables.

That's why, all in all, code base does not grow much (only ~40+ lines added).

The only "drawback" is this patch 10. It's required to know before hand every xtables extensions's nft expressions patterns so it's necessary for
them to be "pre-loaded", that's why currently it only works with --enable-static. We could add a function in xtables to pre-load shared libs to support --enable-shared without --enable-static.
It's not perfect here, I really would lik to get your input on that.

Tomasz Bursztyka (16):
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

 Makefile.am                   |   3 +
 configure.ac                  |   8 +
 extensions/GNUmakefile.in     |   1 +
 extensions/libipt_DNAT.c      | 221 ++++++++++++++++
 include/nft-translator.h      |  81 ++++++
 include/xtables.h             |  13 +
 iptables/Makefile.am          |   3 +-
 iptables/nft-ipv4.c           | 138 ++++------
 iptables/nft-ipv6.c           |  94 +++----
 iptables/nft-shared.c         | 447 ++++++++++++++++++---------------
 iptables/nft-shared.h         |  36 ++-
 iptables/nft-xt-ext.c         | 178 +++++++++++++
 iptables/nft-xt-ext.h         |  14 ++
 iptables/nft.c                | 556 ++++++++++------------------------------
 iptables/nft.h                |   5 +-
 iptables/xtables-events.c     |  21 +-
 iptables/xtables.c            |  15 +-
 libnfttrans/Makefile.am       |  28 +++
 libnfttrans/libnfttrans.pc    |  11 +
 libnfttrans/libnfttrans.pc.in |  11 +
 libnfttrans/nft-translator.c  | 571 ++++++++++++++++++++++++++++++++++++++++++
 21 files changed, 1651 insertions(+), 804 deletions(-)
 create mode 100644 include/nft-translator.h
 create mode 100644 iptables/nft-xt-ext.c
 create mode 100644 iptables/nft-xt-ext.h
 create mode 100644 libnfttrans/Makefile.am
 create mode 100644 libnfttrans/libnfttrans.pc
 create mode 100644 libnfttrans/libnfttrans.pc.in
 create mode 100644 libnfttrans/nft-translator.c

-- 
1.8.3.2

