From: pablo@netfilter.org
Subject: [PATCH] [RFC] ip_queue removal
Date: Tue, 17 Jan 2012 00:12:02 +0100
Message-ID: <1326755523-2762-1-git-send-email-pablo@netfilter.org>
Cc: jengelh@medozas.de, kaber@trash.net, kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44959 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab2APXML (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:12:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi,

I'm thinking about pushing the following patch to net-next once becomes
active.

Does anyone have any compelling reason to keep ip_queue still in the
tree?

Pablo Neira Ayuso (1):
  netfilter: remove ip_queue support

 Documentation/ABI/removed/ip_queue      |    9 +
 include/linux/netfilter_ipv4/ip_queue.h |   72 ----
 include/linux/netlink.h                 |    2 +-
 net/ipv4/netfilter/Makefile             |    3 -
 net/ipv4/netfilter/ip_queue.c           |  639 -------------------------------
 5 files changed, 10 insertions(+), 715 deletions(-)
 create mode 100644 Documentation/ABI/removed/ip_queue
 delete mode 100644 include/linux/netfilter_ipv4/ip_queue.h
 delete mode 100644 net/ipv4/netfilter/ip_queue.c

-- 
1.7.7.3

