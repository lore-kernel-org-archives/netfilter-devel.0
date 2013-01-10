From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC PATCH 0/6] IPv6 Support
Date: Thu, 10 Jan 2013 16:29:33 +0200
Message-ID: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:29742 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab3AJO3n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:29:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here is an attempt to get iptables-nftables supporting IPv6.
I haven't tested it really, so I send it more as an RFC.

Starting from xtables.c which supports only IPv4, patch 2 combines the support for IPv6 in it.
The family attribute provided in patch 1 is set then used in nft.c to use it accordingly, in patch 3.

Patch 4 finalizes it in handling the right informations for rule manipulations depending on the family.

Patch 5 and 6 then adds the support of IPv6 when it comes to respectively save and print the firewall.

Please review,

Tomasz Bursztyka (6):
  nft: Add a family attribute to nft_handle
  xtables: Combine IPv6 support with IPv4 support
  nft: Use handle's family attribute instead of hardcoded AF_INET one
  nft: Support IPv6 rules manipulation
  nft: Use the right payload parsing function when saving a rule
  nft: Handle IPv6 when printing out firewall rules

 iptables/nft.c     | 651 +++++++++++++++++++++++++++++++++++++++--------------
 iptables/nft.h     |   1 +
 iptables/xtables.c | 378 +++++++++++++++++++++----------
 3 files changed, 741 insertions(+), 289 deletions(-)

-- 
1.8.0.2

