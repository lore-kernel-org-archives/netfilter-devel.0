From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH] nfacct: add filter in to the list operation
Date: Wed, 06 Aug 2014 14:53:03 +0400
Message-ID: <1407322384-4655-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39205 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbaHFKxJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:53:09 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9V00HKYSWDKYB0@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 06 Aug 2014 11:53:01 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It's implementation for client side of the filtering support, introduced in
"netfilter: nfnetlink_acct: add filter support to nfacct" patch.

Patch adds byte_quota, packet_quotas, counters and overquota arguments to the
list (list reset) command. nfacct hasn't any help/usage function,
in case of misprint end user will get genral message.

BR,
Alexey

Alexey Perevalov (1):
  nfacct: add filter in to the list operation

 include/linux/netfilter/nfnetlink_acct.h |    8 ++++
 src/nfacct.c                             |   62 ++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

-- 
1.7.9.5

