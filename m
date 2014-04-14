From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH v4 0/5] Add suport for bridge if dev name meta expression keys
Date: Mon, 14 Apr 2014 15:41:25 +0300
Message-ID: <1397479290-6967-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaDNMld (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:41:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here is the patch-set to add meta keys NFT_META_BRI_IIFNAME and NFT_META_BRI_OIFNAME.

Changes against
v3:
- Applied Pablo's comment so CONFIG_NF_TABLES_BRIDGE and CONFIG_BRIDGE_NF_EBTABLES are
  interdependent with CONFIG_BRIDGE_NETFILTER in order to properly add netfilter
  sub-directory when building.
v2:
- Applied Pablo's comment on patch 3
- Applied human readable names on patch 5 according to Pablo and Patrick comments.
v1:
- Rebased the kernel patch set against Patrick's nft_meta.c get/set init function split up.

Last 2 patches are about user-space support.

Tomasz Bursztyka (5):
kernel:
  netfilter: nf_tables: Stack expression type depending on their family
  netfilter: nf_tables: Make meta expression core functions public
  netfilter: nf_tables: Add meta expression key for bridge interface
    name
libnftnl:
  meta: Add support for input and output bridge interface name
nftables:
  meta: Add support for input and output bridge interface name


-- 
1.8.3.2

