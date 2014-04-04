From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH v2 0/4] Add suport for bridge if dev name meta exepression keys
Date: Fri,  4 Apr 2014 12:47:26 +0300
Message-ID: <1396604851-15348-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30438 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbaDDJrk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:47:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here is the patch-set to add meta keys NFT_META_BRI_IIFNAME and NFT_META_BRI_OIFNAME.

Changes against v1:
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

