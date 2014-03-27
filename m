From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 0/5] Add suport for bridge if dev name meta exepression keys
Date: Thu, 27 Mar 2014 14:47:02 +0200
Message-ID: <1395924427-27947-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbaC0Mr2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:47:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here is the patch-set to add meta keys NFT_META_BRI_IIFNAME and NFT_META_BRI_OIFNAME.

I did not factorize nft_meta.c code to reuse nft_meta_select_ops() and nft_meta_bridge_init()
At least solutions I had made the code too ugly.
Declaring a type for select_ops functions, same for validate_get() one, and have
an in-between functions called relevantly by meta_<bridge_>init etc...

At least it looks like netfilter stack very rarely does typedef functions so I passed.

Last 2 patches are about user-space support.

Tomasz Bursztyka (4):
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

