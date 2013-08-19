From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 0/5] Centralizes rule parsing
Date: Mon, 19 Aug 2013 15:04:01 +0300
Message-ID: <1376913846-15996-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22132 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3HSMEL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:04:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here are the patches that refactors how rules are parsed. So now it's done in one unique place for all operations.

And it adds a function to reset the counters with -Z since it's trivial to do so with such parsing strategy.

Tomasz Bursztyka (5):
  nft: Parse fully and properly at once a rule into a cs
  nft: Refactor firewall printing so it reuses already parsed cs struct
  nft: Refactor rule deletion so it compares both cs structure
  xtables: nft: Complete refactoring on how rules are saved
  nft: Add a function to reset the counters of an existing rule

 iptables/nft-ipv4.c       |  99 ++++-----
 iptables/nft-ipv6.c       |  85 +++-----
 iptables/nft-shared.c     | 267 ++++++++++++------------
 iptables/nft-shared.h     |  16 +-
 iptables/nft.c            | 513 ++++++++++------------------------------------
 iptables/nft.h            |   5 +-
 iptables/xtables-events.c |  19 +-
 iptables/xtables.c        |  15 +-
 8 files changed, 342 insertions(+), 677 deletions(-)

-- 
1.8.3.2

