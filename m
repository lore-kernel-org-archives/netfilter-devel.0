From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH] reset nfacct counters
Date: Mon, 28 Jul 2014 21:57:50 +0400
Message-ID: <1406570272-3704-1-git-send-email-a.perevalov@samsung.com>
References: <20140725160123.GA20548@salvia>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	kyungmin.park@samsung.com, hs81.go@samsung.com,
	netfilter-devel@vger.kernel.org, alexey.perevalov@hotmail.com,
	mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30825 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaG1R55 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:57:57 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9F0088VOK1J8B0@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Mon, 28 Jul 2014 18:57:37 +0100 (BST)
In-reply-to: <20140725160123.GA20548@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,
I used you guidance on flags usage for separate counters reset.
If no flags were specified we'll have old behaviour. I wanted to remove
NFNL_MSG_ACCT_GET_CTRZERO and use combination of (NFACCT_F_RESET_COUNTERS |
NFACCT_F_RESET_QUOTAS). But in this case I didn't find how to solve backward
compatibility issue.

You proposed to allocate memory for filter entity to use it with
netlink_dump_control, but netlink_dump_start is synchronous all the way,
and stack variable could be used there. But I could be wrong here and
there is a use case where netlink_dump_control's callback is calling from
another thread.

Due nfnetlink_acct header was modified, I think I need to send additional patches
for nfacct and libnetfilter_acct git reposotories. I saw such practice,
nfnetlink_acct.h duplicates in these repositories.

This patch was made for git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
repository, on top of 633594bb2d3890711a887897f2003f41735f0dfa commit.

Do you need a patch for nfacct command line tool to support following behaviour:
nfacct list reset [counter|quota] ?

Alexey Perevalov (1):
  netfilter: nfnetlink_acct: use flag to reset counters

 include/uapi/linux/netfilter/nfnetlink_acct.h |    2 ++
 net/netfilter/nfnetlink_acct.c                |   30 ++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

-- 
1.7.9.5

