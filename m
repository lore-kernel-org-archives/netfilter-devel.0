From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 nf-next 4/5] netfilter: nfnetlink_queue: rename
 nfnetlink_queue_core.c
Date: Tue, 1 Sep 2015 09:52:17 +0900
Message-ID: <20150901005217.GE2642@gmail.com>
References: <20150824231038.GA20038@gmail.com>
 <20150824231520.GC20038@gmail.com>
 <20150826190553.GA18429@salvia>
 <20150901003436.GA2642@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33859 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbbIAAwW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2015 20:52:22 -0400
Received: by pabzx8 with SMTP id zx8so156230397pab.1
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2015 17:52:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150901003436.GA2642@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now conntrack attaching code belongs to nf_conntrack_core,
nfnetlink_queue_core can be renamed to old one.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/Makefile                                      |    1 -
 net/netfilter/{nfnetlink_queue_core.c => nfnetlink_queue.c} |    0
 2 files changed, 1 deletion(-)
 rename net/netfilter/{nfnetlink_queue_core.c => nfnetlink_queue.c} (100%)

diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 194dfa6..f2a456f 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -10,7 +10,6 @@ obj-$(CONFIG_NETFILTER) = netfilter.o
 
 obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_ACCT) += nfnetlink_acct.o
-nfnetlink_queue-y := nfnetlink_queue_core.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) += nfnetlink_log.o
 
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue.c
similarity index 100%
rename from net/netfilter/nfnetlink_queue_core.c
rename to net/netfilter/nfnetlink_queue.c
-- 
1.7.10.4

