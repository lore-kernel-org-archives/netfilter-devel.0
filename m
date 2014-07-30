From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 0/2] fixes for NFACCT_F_OVERQUOTA usage
Date: Wed, 30 Jul 2014 19:17:53 +0400
Message-ID: <1406733475-5222-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13076 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaG3PSL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:18:11 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9J00E586HYF4A0@mailout4.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 30 Jul 2014 16:17:58 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

I chose straightforward approach and I have used bitwise operators instead of
bit helper functions.

Also I found some inconsistency in report after reset for overquota.

This patch set was based on commit 5a7439efd1c5c416f768fc550048ca130cf4bf99
(dated Jul 25 20:08:13 2014 - little bit updated :)

Alexey Perevalov (2):
  netfilter: nfnetlink_acct: avoid using NFACCT_F_OVERQUOTA with bit
    helper funcitons
  netfilter: nfnetlink_acct: dump unmodified nfacct flags

 net/netfilter/nfnetlink_acct.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
1.7.9.5

