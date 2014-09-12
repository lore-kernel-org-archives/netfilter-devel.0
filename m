From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v4 0/2] nfacct: add filter in to the list operation
Date: Fri, 12 Sep 2014 14:56:56 +0400
Message-ID: <1410519418-8671-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, netfilter-devel@vger.kernel.org,
	kyungmin.park@samsung.com, hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34857 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaILK5E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:57:04 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBS00IM8BVS0MA0@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Fri, 12 Sep 2014 11:59:52 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

It's fourth version of patch for filtering, but also with fix for argument
singleness.

Changes since v3.
	avoid introducing new variable for checking sigleness and report from
function instead of macro

Alexey Perevalov (2):
  nfacct: check cmd line argument for singleness
  nfacct: add filter in to the list operation

 include/linux/netfilter/nfnetlink_acct.h |    8 ++++++
 src/nfacct.c                             |   44 ++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

-- 
1.7.9.5

