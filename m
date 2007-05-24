From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/07]: nf_conntrack_h323: remove unnecessary process of
	Information signal
Date: Fri, 25 May 2007 00:02:13 +0200 (MEST)
Message-ID: <20070524215840.14308.13646.sendpatchset@localhost.localdomain>
References: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack_h323: remove unnecessary process of Information signal

According to the implementation of H.323, it's not necessary to check the
addresses in Information signals.

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6fdca918957ecf41e1b5c416df341cfa48080fcd
tree 16a0761c152686fb74b89e81d4d67d6a329ab540
parent e71d7c2a5a69f20bd077b91bcc240f7bada53e48
author Jing Min Zhao <zhaojingmin@vivecode.com> Thu, 24 May 2007 23:49:58 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 23:49:58 +0200

 net/netfilter/nf_conntrack_h323_main.c |   29 -----------------------------
 1 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 8bb99b3..6d668af 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -977,30 +977,6 @@ static int process_alerting(struct sk_buff **pskb, struct nf_conn *ct,
 }
 
 /****************************************************************************/
-static int process_information(struct sk_buff **pskb,
-			       struct nf_conn *ct,
-			       enum ip_conntrack_info ctinfo,
-			       unsigned char **data, int dataoff,
-			       Information_UUIE *info)
-{
-	int ret;
-	int i;
-
-	DEBUGP("nf_ct_q931: Information\n");
-
-	if (info->options & eInformation_UUIE_fastStart) {
-		for (i = 0; i < info->fastStart.count; i++) {
-			ret = process_olc(pskb, ct, ctinfo, data, dataoff,
-					  &info->fastStart.item[i]);
-			if (ret < 0)
-				return -1;
-		}
-	}
-
-	return 0;
-}
-
-/****************************************************************************/
 static int process_facility(struct sk_buff **pskb, struct nf_conn *ct,
 			    enum ip_conntrack_info ctinfo,
 			    unsigned char **data, int dataoff,
@@ -1096,11 +1072,6 @@ static int process_q931(struct sk_buff **pskb, struct nf_conn *ct,
 		ret = process_alerting(pskb, ct, ctinfo, data, dataoff,
 				       &pdu->h323_message_body.alerting);
 		break;
-	case eH323_UU_PDU_h323_message_body_information:
-		ret = process_information(pskb, ct, ctinfo, data, dataoff,
-					  &pdu->h323_message_body.
-					  information);
-		break;
 	case eH323_UU_PDU_h323_message_body_facility:
 		ret = process_facility(pskb, ct, ctinfo, data, dataoff,
 				       &pdu->h323_message_body.facility);
