From: pablo@netfilter.org
Subject: [PATCH 0/2] nfnetlink_queue updates
Date: Mon, 24 Sep 2012 15:03:08 +0200
Message-ID: <1348491790-10276-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53659 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab2IXNEj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:04:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi,

The following patches aim to provide a workaround for the
problem described by Florian Westphal in:

http://marc.info/?l=netfilter-devel&m=134519473212536&w=2

The idea (by now) is to limit the maximum support length to what
we can handle, which is 65535 - 4 bytes and add a new attribute
that allows us to know the real packet length in the kernel.

Pablo Neira Ayuso (2):
  netfilter: nfnetlink_queue: fix maximum packet length to userspace
  netfilter: nfnetlink_queue: add NFQA_CAP_LEN attribute

 include/linux/netfilter/nfnetlink_queue.h |    1 +
 net/netfilter/nfnetlink_queue_core.c      |   19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

-- 
1.7.10.4

