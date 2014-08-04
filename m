From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH] netfilter: nfnetlink_acct: add filter support to nfacct
 counter list/reset
Date: Mon, 04 Aug 2014 19:52:27 +0400
Message-ID: <1407167548-2883-1-git-send-email-a.perevalov@samsung.com>
References: <20140729163208.GA3739@salvia>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10581 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaHDPwf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:52:35 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9S001BEHFFBA90@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Mon, 04 Aug 2014 16:52:27 +0100 (BST)
In-reply-to: <20140729163208.GA3739@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I followed the same way as in
net/netfilter/nf_conntrack_netlink.c, I put filter code under ifdef.
Seems in case of not NFACCT_FILTER attribute support at kernel side,
client could not detect it.

Due there is no way to identify version number of the serialized
message, solution for counters is not so robust, e.g. kernel side could
be extended by new NFACCT_F_QUOTA_* value, but client side not. In this
case old version of the client side will get incorrect response for
counters request. I think OS vendors should keep it in sync.

I didn't find a way to support listening/reseting quota of any available type
(NFACCT_F_QUOTA) per one request by only one condition.

I saw the thread "[RFC PATCH libnetfilter_conntrack] add userspace dump filter".
For my purpose, where I want to receive only non zero counters, the proposed
way should be extended by list. NFACCT_FILTER should have NESTED type as you
proposed, also it should contain array of nfacct_filter. And condition should
traverse on list as well. Due receiving counters for me is a primary requirement
and non zero counter is a minory optimization requirement.
I decided to send a patch without key field in nfacct_filter structure at first
stage. But if you wish, I could. I mean, if you want the key field and fetching
by that key, it could be in this patch as well.

If you ok with protocol, I'll send client side patch as well.

Alexey Perevalov (1):
  netfilter: nfnetlink_acct: add filter support to nfacct counter
    list/reset

 include/uapi/linux/netfilter/nfnetlink_acct.h |   12 +++++
 net/netfilter/Kconfig                         |    9 ++++
 net/netfilter/nfnetlink_acct.c                |   61 +++++++++++++++++++++++++
 3 files changed, 82 insertions(+)

-- 
1.7.9.5

