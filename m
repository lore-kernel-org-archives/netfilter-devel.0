From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/3]: Fix HW checksum handling in ECN target
Date: Sat, 20 Aug 2005 03:40:04 +0200
Message-ID: <430689F4.6010004@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020703070001080702010007"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------020703070001080702010007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------020703070001080702010007
Content-Type: text/x-patch;
 name="02-2.6.13.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-2.6.13.diff"

[NETFILTER]: Fix HW checksum handling in ECN target

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b477e1c6defc1b0e1181350908714e11de5768dd
tree c30a6471018a9d8c91cfdcfdf829021428de4842
parent 0fdd261fea7da690726451e22e72845d2bcce50f
author Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 03:34:53 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 03:34:53 +0200

 net/ipv4/netfilter/ipt_ECN.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -71,6 +71,10 @@ set_ect_tcp(struct sk_buff **pskb, const
 		return 0;
 	tcph = (void *)(*pskb)->nh.iph + (*pskb)->nh.iph->ihl*4;
 
+	if ((*pskb)->ip_summed == CHECKSUM_HW &&
+	    skb_checksum_help(*pskb, inward))
+		return 0;
+
 	diffs[0] = ((u_int16_t *)tcph)[6];
 	if (einfo->operation & IPT_ECN_OP_SET_ECE)
 		tcph->ece = einfo->proto.tcp.ece;
@@ -79,13 +83,10 @@ set_ect_tcp(struct sk_buff **pskb, const
 	diffs[1] = ((u_int16_t *)tcph)[6];
 	diffs[0] = diffs[0] ^ 0xFFFF;
 
-	if ((*pskb)->ip_summed != CHECKSUM_HW)
+	if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
 		tcph->check = csum_fold(csum_partial((char *)diffs,
 						     sizeof(diffs),
 						     tcph->check^0xFFFF));
-	else
-		if (skb_checksum_help(*pskb, inward))
-			return 0;
 	(*pskb)->nfcache |= NFC_ALTERED;
 	return 1;
 }

--------------020703070001080702010007
Content-Type: text/x-patch;
 name="02-2.6.14.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-2.6.14.diff"

[NETFILTER]: Fix HW checksum handling in ECN target

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f1929b1a15a9a7d9761b344d3522698bd656154e
tree d2da13822149bfa1c49a8ae82930d4795f08f69f
parent a811712706846bff6ad796394ce4aa3abcc657b0
author Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 03:28:22 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 03:28:22 +0200

 net/ipv4/netfilter/ipt_ECN.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -70,6 +70,10 @@ set_ect_tcp(struct sk_buff **pskb, const
 		return 0;
 	tcph = (void *)(*pskb)->nh.iph + (*pskb)->nh.iph->ihl*4;
 
+	if ((*pskb)->ip_summed == CHECKSUM_HW &&
+	    skb_checksum_help(*pskb, inward))
+		return 0;
+
 	diffs[0] = ((u_int16_t *)tcph)[6];
 	if (einfo->operation & IPT_ECN_OP_SET_ECE)
 		tcph->ece = einfo->proto.tcp.ece;
@@ -78,13 +82,10 @@ set_ect_tcp(struct sk_buff **pskb, const
 	diffs[1] = ((u_int16_t *)tcph)[6];
 	diffs[0] = diffs[0] ^ 0xFFFF;
 
-	if ((*pskb)->ip_summed != CHECKSUM_HW)
+	if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
 		tcph->check = csum_fold(csum_partial((char *)diffs,
 						     sizeof(diffs),
 						     tcph->check^0xFFFF));
-	else
-		if (skb_checksum_help(*pskb, inward))
-			return 0;
 	return 1;
 }
 

--------------020703070001080702010007--
