From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: nf_queue: reject NF_STOLEN verdicts from userspace
Date: Fri, 12 Aug 2011 22:34:52 +0200
Message-ID: <1313181292-8683-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, Julian Anastasov <ja@ssi.bg>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55249 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889Ab1HLUgR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2011 16:36:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A userspace listener may send (bogus) NF_STOLEN verdict, which causes s=
kb leak.

This problem was previously fixed via
64507fdbc29c3a622180378210ecea8659b14e40 (netfilter:
nf_queue: fix NF_STOLEN skb leak) but this had to be reverted because
NF_STOLEN can also be returned by a netfilter hook when iterating the
rules in nf_reinject.

Reject userspace NF_STOLEN verdict, as suggested by Micha=C5=82 Miros=C5=
=82aw.

This is complementary to commit fad54440438a7c231a6ae347738423cbabc936d=
9
(netfilter: avoid double free in nf_reinject).

Cc: Julian Anastasov <ja@ssi.bg>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ip_queue.c   |   11 ++++-------
 net/ipv6/netfilter/ip6_queue.c  |   11 ++++-------
 net/netfilter/nfnetlink_queue.c |    4 ++--
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queu=
e.c
index d2c1311..8ad0bb1 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -312,7 +312,7 @@ ipq_set_verdict(struct ipq_verdict_msg *vmsg, unsig=
ned int len)
 {
 	struct nf_queue_entry *entry;
=20
-	if (vmsg->value > NF_MAX_VERDICT)
+	if (vmsg->value > NF_MAX_VERDICT || vmsg->value =3D=3D NF_STOLEN)
 		return -EINVAL;
=20
 	entry =3D ipq_find_dequeue_entry(vmsg->id);
@@ -357,12 +357,9 @@ ipq_receive_peer(struct ipq_peer_msg *pmsg,
 		break;
=20
 	case IPQM_VERDICT:
-		if (pmsg->msg.verdict.value > NF_MAX_VERDICT)
-			status =3D -EINVAL;
-		else
-			status =3D ipq_set_verdict(&pmsg->msg.verdict,
-						 len - sizeof(*pmsg));
-			break;
+		status =3D ipq_set_verdict(&pmsg->msg.verdict,
+					 len - sizeof(*pmsg));
+		break;
 	default:
 		status =3D -EINVAL;
 	}
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_qu=
eue.c
index 413ab07..974d07f 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -312,7 +312,7 @@ ipq_set_verdict(struct ipq_verdict_msg *vmsg, unsig=
ned int len)
 {
 	struct nf_queue_entry *entry;
=20
-	if (vmsg->value > NF_MAX_VERDICT)
+	if (vmsg->value > NF_MAX_VERDICT || vmsg->value =3D=3D NF_STOLEN)
 		return -EINVAL;
=20
 	entry =3D ipq_find_dequeue_entry(vmsg->id);
@@ -357,12 +357,9 @@ ipq_receive_peer(struct ipq_peer_msg *pmsg,
 		break;
=20
 	case IPQM_VERDICT:
-		if (pmsg->msg.verdict.value > NF_MAX_VERDICT)
-			status =3D -EINVAL;
-		else
-			status =3D ipq_set_verdict(&pmsg->msg.verdict,
-						 len - sizeof(*pmsg));
-			break;
+		status =3D ipq_set_verdict(&pmsg->msg.verdict,
+					 len - sizeof(*pmsg));
+		break;
 	default:
 		status =3D -EINVAL;
 	}
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_=
queue.c
index fbfcd83..89cb76a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -645,8 +645,8 @@ verdicthdr_get(const struct nlattr * const nfqa[])
 		return NULL;
=20
 	vhdr =3D nla_data(nfqa[NFQA_VERDICT_HDR]);
-	verdict =3D ntohl(vhdr->verdict);
-	if ((verdict & NF_VERDICT_MASK) > NF_MAX_VERDICT)
+	verdict =3D ntohl(vhdr->verdict) & NF_VERDICT_MASK;
+	if (verdict > NF_MAX_VERDICT || verdict =3D=3D NF_STOLEN)
 		return NULL;
 	return vhdr;
 }
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
