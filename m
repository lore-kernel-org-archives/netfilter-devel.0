From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 3/3] netfilter: rename nfnetlink_queue_core.c to nfnetlink_queue.c
Date: Tue,  8 Sep 2015 18:54:51 +0200
Message-ID: <1441731291-21342-4-git-send-email-pablo@netfilter.org>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
Cc: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37663 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbbIHQsY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 12:48:24 -0400
In-Reply-To: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that we have integrated the ct glue code into nfnetlink_queue without
introducing dependencies with the conntrack code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/{nfnetlink_queue_core.c => nfnetlink_queue.c} |    0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename net/netfilter/{nfnetlink_queue_core.c => nfnetlink_queue.c} (100%)

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue.c
similarity index 100%
rename from net/netfilter/nfnetlink_queue_core.c
rename to net/netfilter/nfnetlink_queue.c
-- 
1.7.10.4

