From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: ctnetlink: fix wrong message type in user
	updates
Date: Tue, 05 May 2009 15:14:29 +0200
Message-ID: <20090505131429.7241.88268.stgit@Decadence>
References: <20090505131219.7241.85258.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35349 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbZEENOg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 May 2009 09:14:36 -0400
In-Reply-To: <20090505131219.7241.85258.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the wrong message type that are triggered by
user updates, the following commands:

(term1)# conntrack -I -p tcp -s 1.1.1.1 -d 2.2.2.2 -t 10 --sport 10 --dport 20 --state LISTEN
(term1)# conntrack -U -p tcp -s 1.1.1.1 -d 2.2.2.2 -t 10 --sport 10 --dport 20 --state SYN_SENT
(term1)# conntrack -U -p tcp -s 1.1.1.1 -d 2.2.2.2 -t 10 --sport 10 --dport 20 --state SYN_RECV

only trigger event message of type NEW, when only the first is NEW
while others should be UPDATE.

(term2)# conntrack -E
    [NEW] tcp      6 10 LISTEN src=1.1.1.1 dst=2.2.2.2 sport=10 dport=20 [UNREPLIED] src=2.2.2.2 dst=1.1.1.1 sport=20 dport=10 mark=0
    [NEW] tcp      6 10 SYN_SENT src=1.1.1.1 dst=2.2.2.2 sport=10 dport=20 [UNREPLIED] src=2.2.2.2 dst=1.1.1.1 sport=20 dport=10 mark=0
    [NEW] tcp      6 10 SYN_RECV src=1.1.1.1 dst=2.2.2.2 sport=10 dport=20 [UNREPLIED] src=2.2.2.2 dst=1.1.1.1 sport=20 dport=10 mark=0

This patch also removes IPCT_REFRESH from the bitmask since it is
not of any use.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |   48 ++++++++++++++--------------------
 1 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f13fc57..c523f0b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1186,28 +1186,6 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 	return 0;
 }
 
-static inline void
-ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
-{
-	unsigned int events = 0;
-
-	if (test_bit(IPS_EXPECTED_BIT, &ct->status))
-		events |= IPCT_RELATED;
-	else
-		events |= IPCT_NEW;
-
-	nf_conntrack_event_report(IPCT_STATUS |
-				  IPCT_HELPER |
-				  IPCT_REFRESH |
-				  IPCT_PROTOINFO |
-				  IPCT_NATSEQADJ |
-				  IPCT_MARK |
-				  events,
-				  ct,
-				  pid,
-				  report);
-}
-
 static struct nf_conn *
 ctnetlink_create_conntrack(struct nlattr *cda[],
 			   struct nf_conntrack_tuple *otuple,
@@ -1373,6 +1351,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE) {
 			struct nf_conn *ct;
+			enum ip_conntrack_events events;
 
 			ct = ctnetlink_create_conntrack(cda, &otuple,
 							&rtuple, u3);
@@ -1383,9 +1362,18 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			err = 0;
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
-			ctnetlink_event_report(ct,
-					       NETLINK_CB(skb).pid,
-					       nlmsg_report(nlh));
+			if (test_bit(IPS_EXPECTED_BIT, &ct->status))
+				events = IPCT_RELATED;
+			else
+				events = IPCT_NEW;
+
+			nf_conntrack_event_report(IPCT_STATUS |
+						  IPCT_HELPER |
+						  IPCT_PROTOINFO |
+						  IPCT_NATSEQADJ |
+						  IPCT_MARK | events,
+						  ct, NETLINK_CB(skb).pid,
+						  nlmsg_report(nlh));
 			nf_ct_put(ct);
 		} else
 			spin_unlock_bh(&nf_conntrack_lock);
@@ -1404,9 +1392,13 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		if (err == 0) {
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
-			ctnetlink_event_report(ct,
-					       NETLINK_CB(skb).pid,
-					       nlmsg_report(nlh));
+			nf_conntrack_event_report(IPCT_STATUS |
+						  IPCT_HELPER |
+						  IPCT_PROTOINFO |
+						  IPCT_NATSEQADJ |
+						  IPCT_MARK,
+						  ct, NETLINK_CB(skb).pid,
+						  nlmsg_report(nlh));
 			nf_ct_put(ct);
 		} else
 			spin_unlock_bh(&nf_conntrack_lock);

