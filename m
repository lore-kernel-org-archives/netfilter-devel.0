From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v3 0/2] nfacct: add filter in to the list operation
Date: Thu, 11 Sep 2014 19:50:38 +0400
Message-ID: <1410450640-2414-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, netfilter-devel@vger.kernel.org,
	kyungmin.park@samsung.com, hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62240 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbaIKPup (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:50:45 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBQ00GR8UTA5H80@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Thu, 11 Sep 2014 16:53:34 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

It's third version of patch for filtering, but also with fix for argument
singleness.

Changes since v2.
	selection enum/variable was removed according to comment

I thought about singleness of one category's options. It's possibe to do without
refactoring, but code looks like overloaded by lines, so I would prefer to use some
general approach. Where we could use some special parser, but I feel you have one
in nft. So this serie includes straightforward approach.

Alexey Perevalov (2):
  nfacct: check cmd line argument for singleness
  nfacct: add filter in to the list operation

 include/linux/netfilter/nfnetlink_acct.h |    8 ++++
 src/nfacct.c                             |   60 +++++++++++++++++++++++++++++-
 2 files changed, 67 insertions(+), 1 deletion(-)

-- 
1.7.9.5

