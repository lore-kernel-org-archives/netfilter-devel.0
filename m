From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH v3 0/5] Add suport for bridge if dev name meta exepression keys
Date: Tue,  8 Apr 2014 14:25:19 +0300
Message-ID: <1396956324-17803-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62297 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbaDHLZl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:25:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here is the patch-set to add meta keys NFT_META_BRI_IIFNAME and NFT_META_BRI_OIFNAME.

Changes against
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

