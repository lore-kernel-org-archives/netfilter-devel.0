From: zhaojingmin@vivecode.com (Jing Min Zhao)
Subject: [PATCH 3/4] H.323: Remove unnecessary process of Information signal
Date: Thu, 17 May 2007 15:17:56 -0400 (EDT)
Message-ID: <20070517191756.D5C8C3DA1FA@jzhao.vivecode.com>
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

According to the implementation of H.323, it's not necessary to check the addresses in Information signals.

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
---
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
-- 
1.4.4.3
