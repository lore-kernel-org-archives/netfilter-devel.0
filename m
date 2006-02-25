From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: h323 helper: fix excessive stack usage
Date: Sat, 25 Feb 2006 10:03:44 +0100
Message-ID: <44001D70.3050108@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060401090309010001050509"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
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
--------------060401090309010001050509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

See Changelog entry. The kernel stack is very small, we can't use that
much.


--------------060401090309010001050509
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: h323 helper: fix excessive stack usage

The decoded messages are too large to be declared on the stack:

sizeof(RasMessage)=256
sizeof(Q931)=3360
sizeof(MultimediaSystemControlMessage)=104

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7206cd2e0c2c0a0c650c83ab4a10e1f54728d42d
tree da44f016a7046b3e5920a6120b29693046c6390c
parent 812edb2b2ad20ef6f774bdd95e868885e7eb0790
author Patrick McHardy <kaber@trash.net> Thu, 23 Feb 2006 14:10:19 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 23 Feb 2006 14:10:19 +0100

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 7fe387d..8d49e74 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -417,7 +417,7 @@ static int h245_help(struct sk_buff **ps
 	unsigned char *data;
 	int datalen;
 	int ret;
-	MultimediaSystemControlMessage mscm;
+	static MultimediaSystemControlMessage mscm;
 
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
@@ -434,15 +434,16 @@ static int h245_help(struct sk_buff **ps
 	       NIPQUAD((*pskb)->nh.iph->saddr),
 	       NIPQUAD((*pskb)->nh.iph->daddr), datalen);
 
+	spin_lock_bh(&ip_h245_lock);
 	ret = DecodeMultimediaSystemControlMessage(data, datalen, &mscm);
 	if (ret < 0) {
 		DEBUGP("ip_ct_h245: decoding error: %s\n",
 		       ret ==
 		       H323_ERROR_BOUND ? "out of bound" : "out of range");
+		spin_unlock_bh(&ip_h245_lock);
 		return NF_ACCEPT;
 	}
 
-	spin_lock_bh(&ip_h245_lock);
 	ret = process_h245(pskb, ct, ctinfo, &data, &mscm);
 	spin_unlock_bh(&ip_h245_lock);
 
@@ -874,7 +875,7 @@ static int q931_help(struct sk_buff **ps
 	unsigned char *data;
 	int datalen;
 	int ret;
-	Q931 q931;
+	static Q931 q931;
 
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
@@ -891,16 +892,17 @@ static int q931_help(struct sk_buff **ps
 	       NIPQUAD((*pskb)->nh.iph->saddr),
 	       NIPQUAD((*pskb)->nh.iph->daddr), datalen);
 
+	spin_lock_bh(&ip_q931_lock);
 	ret = DecodeQ931(data, datalen, &q931);
 	if (ret < 0) {
 		if (net_ratelimit())
 			printk("ip_ct_q931: decoding error: %s\n",
 			       ret == H323_ERROR_BOUND ?
 			       "out of bound" : "out of range");
+		spin_unlock_bh(&ip_q931_lock);
 		return NF_ACCEPT;
 	}
 
-	spin_lock_bh(&ip_q931_lock);
 	ret = process_q931(pskb, ct, ctinfo, &data, &q931);
 	spin_unlock_bh(&ip_q931_lock);
 
@@ -1454,7 +1456,6 @@ static int process_ras(struct sk_buff **
 	return 0;
 }
 
-
 /****************************************************************************/
 static int ras_help(struct sk_buff **pskb, struct ip_conntrack *ct,
 		    enum ip_conntrack_info ctinfo)
@@ -1462,7 +1463,7 @@ static int ras_help(struct sk_buff **psk
 	unsigned char *data;
 	int datalen;
 	int ret;
-	RasMessage ras;
+	static RasMessage ras;
 
 	data = get_udp_data(pskb, &datalen);
 	if (data == NULL) {
@@ -1473,16 +1474,17 @@ static int ras_help(struct sk_buff **psk
 	       NIPQUAD((*pskb)->nh.iph->saddr),
 	       NIPQUAD((*pskb)->nh.iph->daddr), datalen);
 
+	spin_lock_bh(&ip_ras_lock);
 	ret = DecodeRasMessage(data, datalen, &ras);
 	if (ret < 0) {
 		if (net_ratelimit())
 			printk("ip_ct_ras: decoding error: %s\n",
 			       ret == H323_ERROR_BOUND ?
 			       "out of bound" : "out of range");
+		spin_unlock_bh(&ip_ras_lock);
 		return NF_ACCEPT;
 	}
 
-	spin_lock_bh(&ip_ras_lock);
 	ret = process_ras(pskb, ct, ctinfo, &data, &ras);
 	spin_unlock_bh(&ip_ras_lock);
 

--------------060401090309010001050509--
