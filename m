From: mathieu.poirier@linaro.org
Subject: [RFC PATCH 0/2] netfilter: Adding quota capabilities to nfnetlink
Date: Sun, 30 Mar 2014 15:10:42 -0600
Message-ID: <1396213844-10528-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34457 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaC3VK5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 17:10:57 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so7074366pdj.22
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Mar 2014 14:10:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mathieu Poirier <mathieu.poirier@linaro.org>

This is another re-spin on adding quota capabilities to the nfnetlink
accounting framework.  This time most of the quota support is located
in the framework itself rather than the filter.

Comments welcomed.

Thanks,
Mathieu

Mathieu Poirier (1):
  netfilter: xt_nfacct: Add quota to nfacct filter

Pablo Neira Ayuso (1):
  netfilter: nfnetlink_acct: Adding quota support to nf_acct objects

 include/linux/netfilter/nfnetlink_acct.h      |  3 +-
 include/uapi/linux/netfilter/nfnetlink.h      |  2 +
 include/uapi/linux/netfilter/nfnetlink_acct.h |  9 +++
 net/netfilter/nfnetlink_acct.c                | 93 +++++++++++++++++++++++++++
 net/netfilter/xt_nfacct.c                     | 13 ++++
 5 files changed, 119 insertions(+), 1 deletion(-)

-- 
1.8.3.2

