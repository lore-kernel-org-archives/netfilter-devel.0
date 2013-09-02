From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/1] netfilter: Ignore bogus SACK option values in TCP conntrack
Date: Mon,  2 Sep 2013 20:58:00 +0200
Message-ID: <1378148280-1153-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1378148280-1153-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Corey Hickey <bugfood-ml@fatooh.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36905 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758718Ab3IBS6D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 14:58:03 -0400
In-Reply-To: <1378148280-1153-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The netfilter TCP conntrack used to mark packets with bogus SACK option
values as INVALID. However, it seems broken SEQ anonymizers, which are
responsible for such traffic, are not going to die out soon and conntrack
effectively blocks traffic coming through such devices.

Better be liberal at conntrack level: when SACK is bogus, ignore it.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Reported-by: Corey Hickey <bugfood-ml@fatooh.org>
Tested-by: Corey Hickey <bugfood-ml@fatooh.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 44d1ea3..cd67de8 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -640,6 +640,11 @@ static bool tcp_in_window(const struct nf_conn *ct,
 	in_recv_win = !receiver->td_maxwin ||
 		      after(end, sender->td_end - receiver->td_maxwin - 1);
 
+	/* Fall back to ACK when SACK is bogus */
+	if (!(before(sack, receiver->td_end + 1) &&
+	      after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)))
+		sack = ack;
+
 	pr_debug("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
 		 before(seq, sender->td_maxend + 1),
 		 (in_recv_win ? 1 : 0),
-- 
1.7.0.4

