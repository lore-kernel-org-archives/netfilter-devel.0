From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH] Fix overquota output result
Date: Wed, 30 Jul 2014 19:25:24 +0400
Message-ID: <1406733925-5344-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58853 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaG3PZb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:25:31 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9J00K576UCTUA0@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 30 Jul 2014 16:25:24 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes client side of nfacct report.
For details, see kernel patches in "fixes for NFACCT_F_OVERQUOTA usage" thread.
After this fix kernel bugs became visible.

Alexey Perevalov (1):
  Fix overquota output result

 src/libnetfilter_acct.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

-- 
1.7.9.5

