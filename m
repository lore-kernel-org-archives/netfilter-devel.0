From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 45/50]: nf_conntrack_h323: turn some printks into DEBUGPs
Date: Sat,  7 Jul 2007 14:24:03 +0200 (MEST)
Message-ID: <20070707122319.1589.15191.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_h323: turn some printks into DEBUGPs

Don't spam the ringbuffer with decoding errors. The only printks remaining
are for dropped packets when we're certain they are H.323.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 312f613cf94327c5e48fb0dbcae03f15397258c6
tree 2515a5a3cfee1a2bccc0b585e775b5193c76f7d6
parent 65f869fe5a53f98a1d8cc1ff1c819102e8173bbe
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:05 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:05 +0200

 net/netfilter/nf_conntrack_h323_main.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 8c57b81..aa5ba99 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -163,9 +163,7 @@ static int get_tpkt_data(struct sk_buff **pskb, unsigned int protoff,
 				}
 
 				/* Fragmented TPKT */
-				if (net_ratelimit())
-					printk("nf_ct_h323: "
-					       "fragmented TPKT\n");
+				DEBUGP("nf_ct_h323: fragmented TPKT\n");
 				goto clear_out;
 			}
 
@@ -596,10 +594,9 @@ static int h245_help(struct sk_buff **pskb, unsigned int protoff,
 		ret = DecodeMultimediaSystemControlMessage(data, datalen,
 							   &mscm);
 		if (ret < 0) {
-			if (net_ratelimit())
-				printk("nf_ct_h245: decoding error: %s\n",
-				       ret == H323_ERROR_BOUND ?
-				       "out of bound" : "out of range");
+			DEBUGP("nf_ct_h245: decoding error: %s\n",
+			       ret == H323_ERROR_BOUND ?
+			       "out of bound" : "out of range");
 			/* We don't drop when decoding error */
 			break;
 		}
@@ -1137,10 +1134,9 @@ static int q931_help(struct sk_buff **pskb, unsigned int protoff,
 		/* Decode Q.931 signal */
 		ret = DecodeQ931(data, datalen, &q931);
 		if (ret < 0) {
-			if (net_ratelimit())
-				printk("nf_ct_q931: decoding error: %s\n",
-				       ret == H323_ERROR_BOUND ?
-				       "out of bound" : "out of range");
+			DEBUGP("nf_ct_q931: decoding error: %s\n",
+			       ret == H323_ERROR_BOUND ?
+			       "out of bound" : "out of range");
 			/* We don't drop when decoding error */
 			break;
 		}
@@ -1711,10 +1707,9 @@ static int ras_help(struct sk_buff **pskb, unsigned int protoff,
 	/* Decode RAS message */
 	ret = DecodeRasMessage(data, datalen, &ras);
 	if (ret < 0) {
-		if (net_ratelimit())
-			printk("nf_ct_ras: decoding error: %s\n",
-			       ret == H323_ERROR_BOUND ?
-			       "out of bound" : "out of range");
+		DEBUGP("nf_ct_ras: decoding error: %s\n",
+		       ret == H323_ERROR_BOUND ?
+		       "out of bound" : "out of range");
 		goto accept;
 	}
 
