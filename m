From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 0/3] Rework nfnetlink_queue conntrack support
Date: Tue,  8 Sep 2015 18:54:48 +0200
Message-ID: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
Cc: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37661 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbbIHQsZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 12:48:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Ken-ichirou,

Would you have a look at this patchset?

I think it should prepare the ground for what you need.

They are totally untested, so please carefully review them.

Pablo Neira Ayuso (3):
  netfilter: ctnetlink: remove ctnetlink_nfqueue_build_size()
  netfilter: nfnetlink_queue: get rid of nfnetlink_queue_ct.c
  netfilter: rename nfnetlink_queue_core.c to nfnetlink_queue.c

 include/linux/netfilter.h               |   12 +-
 include/net/netfilter/nfnetlink_queue.h |   51 --
 net/netfilter/Makefile                  |    1 -
 net/netfilter/nf_conntrack_netlink.c    |   87 +-
 net/netfilter/nfnetlink_queue.c         | 1443 +++++++++++++++++++++++++++++++
 net/netfilter/nfnetlink_queue_core.c    | 1415 ------------------------------
 net/netfilter/nfnetlink_queue_ct.c      |  113 ---
 7 files changed, 1506 insertions(+), 1616 deletions(-)
 delete mode 100644 include/net/netfilter/nfnetlink_queue.h
 create mode 100644 net/netfilter/nfnetlink_queue.c
 delete mode 100644 net/netfilter/nfnetlink_queue_core.c
 delete mode 100644 net/netfilter/nfnetlink_queue_ct.c

-- 
1.7.10.4

