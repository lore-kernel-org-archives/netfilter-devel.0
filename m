From: mathieu.poirier@linaro.org
Subject: [PATCH v4 0/2] Add quota capabilities to nfacct
Date: Mon, 10 Feb 2014 19:27:06 -0700
Message-ID: <1392085628-24804-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	fw@strlen.de, mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47347 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaBKC1Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:27:24 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so7056095pbc.24
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Feb 2014 18:27:24 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mathieu Poirier <mathieu.poirier@linaro.org>

For this iteration the synchronisation of packet and byte
accounting in 'nfnl_acct_update' was added.  That allowed
for the removal of spinlocks from the match function
in xt_nfacct.  Comments from v3 were also addressed.

Mathieu Poirier (2):
  netfilter: nfnetlink_acct: make shared objects SMP safe
  netfilter: xtables: add quota support for nfacct

 include/linux/netfilter/nfnetlink_acct.h      |  15 ++-
 include/uapi/linux/netfilter/nfnetlink.h      |   2 +
 include/uapi/linux/netfilter/nfnetlink_acct.h |   1 +
 include/uapi/linux/netfilter/xt_nfacct.h      |  14 ++-
 net/netfilter/Kconfig                         |   3 +-
 net/netfilter/nfnetlink_acct.c                |  57 ++++++++---
 net/netfilter/xt_nfacct.c                     | 139 ++++++++++++++++++++++++--
 7 files changed, 202 insertions(+), 29 deletions(-)

-- 
1.8.3.2

