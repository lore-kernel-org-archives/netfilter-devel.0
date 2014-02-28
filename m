From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH v2] netfilter: hash resizing
Date: Fri, 28 Feb 2014 13:48:02 +0000
Message-ID: <1393595283-7036-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, josh@joshtriplett.org,
	paulmck@linux.vnet.ibm.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34550 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaB1NsL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:48:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

this is a slightly updates patch for nft_hash to use RCU resizing. Since
the current implementation is seriously buggy, this should in any case be
an improvement. Testing also works fine.

Changes this v1 posting:

- use vmalloc as fallback for failed kmalloc allocations

- avoid potential overflow in hash expansion and shrinking checks,
  suggested by Josh. Note: I didn't use a shift since gcc properly
  generates that itself.

Please apply. Thanks!
