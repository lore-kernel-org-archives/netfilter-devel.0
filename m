From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 20/20]: nf_conntrack_h323: turn some printks into DEBUGPs
Date: Fri, 29 Jun 2007 02:45:24 +0200 (MEST)
Message-ID: <20070629004422.25566.75551.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
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
commit 58044e9aa942648e81f52b57620c964545ac0923
tree bcab6f637ecf52327c2648ef421f4b571edeaba1
parent 67e311cc8a1824345d5ca10a403e93f02ffa5697
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:19:58 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:19:58 +0200

 net/netfilter/nf_conntrack_h323_main.c |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 8c57b81..075a3a4 100644
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
 
@@ -199,8 +197,7 @@ static int get_tpkt_data(struct sk_buff **pskb, unsigned int protoff,
 			return 0;
 		}
 
-		if (net_ratelimit())
-			printk("nf_ct_h323: incomplete TPKT (fragmented?)\n");
+		DEBUGP("nf_ct_h323: incomplete TPKT (fragmented?)\n");
 		goto clear_out;
 	}
 
@@ -596,10 +593,9 @@ static int h245_help(struct sk_buff **pskb, unsigned int protoff,
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
@@ -614,8 +610,7 @@ static int h245_help(struct sk_buff **pskb, unsigned int protoff,
 
       drop:
 	spin_unlock_bh(&nf_h323_lock);
-	if (net_ratelimit())
-		printk("nf_ct_h245: packet dropped\n");
+	printk("nf_ct_h245: packet dropped\n");
 	return NF_DROP;
 }
 
@@ -1137,10 +1132,9 @@ static int q931_help(struct sk_buff **pskb, unsigned int protoff,
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
@@ -1711,10 +1705,9 @@ static int ras_help(struct sk_buff **pskb, unsigned int protoff,
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
 
