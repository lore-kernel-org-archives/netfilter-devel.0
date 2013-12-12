From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables PATCH] Expose tables's chain usage and handle it.
Date: Thu, 12 Dec 2013 15:00:41 +0200
Message-ID: <1386853244-16783-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31068 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3LLNAx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:00:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Patch 1 adds the feature in the kernel,
Patch 2 is just an intermediate patch for libnftables to be up-to-date on header's documentation
Patch 3 is the actual patch in libnftables that handles properly the new attribute

Tomasz Burszsyka

-- 
1.8.4.4

