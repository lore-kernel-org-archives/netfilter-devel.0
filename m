From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 nf-next 2/5] netfilter: nf_conntrack_netlink: rename to
 link ct attachment with
Date: Tue, 1 Sep 2015 09:39:37 +0900
Message-ID: <20150901003937.GC2642@gmail.com>
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
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36237 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbbIAAjm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2015 20:39:42 -0400
Received: by pacgr6 with SMTP id gr6so5078275pac.3
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2015 17:39:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150901003436.GA2642@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is the first pharse of which linking conntrack attach code
with nf_conntrack_netlink. The plan is intended to attach a conntrack
to nflog, based on what nfqueue has already done.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/Makefile                                                |    1 +
 net/netfilter/{nf_conntrack_netlink.c => nf_conntrack_netlink_core.c} |    0
 2 files changed, 1 insertion(+)
 rename net/netfilter/{nf_conntrack_netlink.c => nf_conntrack_netlink_core.c} (100%)

diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 70d026d..05a7746 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_NF_CT_PROTO_SCTP) += nf_conntrack_proto_sctp.o
 obj-$(CONFIG_NF_CT_PROTO_UDPLITE) += nf_conntrack_proto_udplite.o
 
 # netlink interface for nf_conntrack
+nf_conntrack_netlink-y := nf_conntrack_netlink_core.o
 obj-$(CONFIG_NF_CT_NETLINK) += nf_conntrack_netlink.o
 obj-$(CONFIG_NF_CT_NETLINK_TIMEOUT) += nfnetlink_cttimeout.o
 obj-$(CONFIG_NF_CT_NETLINK_HELPER) += nfnetlink_cthelper.o
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink_core.c
similarity index 100%
rename from net/netfilter/nf_conntrack_netlink.c
rename to net/netfilter/nf_conntrack_netlink_core.c
-- 
1.7.10.4

