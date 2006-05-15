From: Philip Craig <philipc@snapgear.com>
Subject: Re: ulogd2 and nflog prefix
Date: Mon, 15 May 2006 17:59:55 +1000
Message-ID: <446834FB.9070402@snapgear.com>
References: <4467EC50.3030907@snapgear.com> <44681346.3000301@trash.net>
	<446826EF.1070004@snapgear.com> <44682889.107@trash.net>
	<44682EE0.6020003@snapgear.com> <4468303F.4030004@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020801000102000603000108"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4468303F.4030004@trash.net>
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
--------------020801000102000603000108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/15/2006 05:39 PM, Patrick McHardy wrote:
> I agree. A few nitpicks though ..

Okay, here's a better version.


--------------020801000102000603000108
Content-Type: text/plain;
 name="nflog-prefix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nflog-prefix.patch"

Null terminate the prefix in netfilter netlink log messages,
and remove the artificial limit on the prefix length.

Signed-off-by: Philip Craig <philipc@snapgear.com>

Index: linux-2.6.x/net/netfilter/nfnetlink_log.c
===================================================================
RCS file: /cvs/sw/linux-2.6.x/net/netfilter/nfnetlink_log.c,v
retrieving revision 1.1.1.3
diff -u -p -r1.1.1.3 nfnetlink_log.c
--- linux-2.6.x/net/netfilter/nfnetlink_log.c	21 Mar 2006 01:35:42 -0000	1.1.1.3
+++ linux-2.6.x/net/netfilter/nfnetlink_log.c	15 May 2006 07:54:59 -0000
@@ -386,7 +386,8 @@ __build_packet_message(struct nfulnl_ins
 			const struct net_device *indev,
 			const struct net_device *outdev,
 			const struct nf_loginfo *li,
-			const char *prefix)
+			const char *prefix,
+			unsigned int prefix_len)
 {
 	unsigned char *old_tail;
 	struct nfulnl_msg_packet_hdr pmsg;
@@ -410,12 +411,8 @@ __build_packet_message(struct nfulnl_ins
 
 	NFA_PUT(inst->skb, NFULA_PACKET_HDR, sizeof(pmsg), &pmsg);
 
-	if (prefix) {
-		int slen = strlen(prefix);
-		if (slen > NFULNL_PREFIXLEN)
-			slen = NFULNL_PREFIXLEN;
-		NFA_PUT(inst->skb, NFULA_PREFIX, slen, prefix);
-	}
+	if (prefix)
+		NFA_PUT(inst->skb, NFULA_PREFIX, prefix_len, prefix);
 
 	if (indev) {
 		tmp_uint = htonl(indev->ifindex);
@@ -565,7 +562,7 @@ nfulnl_log_packet(unsigned int pf,
 		  const struct nf_loginfo *li_user,
 		  const char *prefix)
 {
-	unsigned int size, data_len;
+	unsigned int size, data_len, prefix_len;
 	struct nfulnl_instance *inst;
 	const struct nf_loginfo *li;
 	unsigned int qthreshold;
@@ -599,10 +596,15 @@ nfulnl_log_packet(unsigned int pf,
 #endif
 		+ NFA_SPACE(sizeof(u_int32_t))	/* mark */
 		+ NFA_SPACE(sizeof(u_int32_t))	/* uid */
-		+ NFA_SPACE(NFULNL_PREFIXLEN)	/* prefix */
 		+ NFA_SPACE(sizeof(struct nfulnl_msg_packet_hw))
 		+ NFA_SPACE(sizeof(struct nfulnl_msg_packet_timestamp));
 
+	if (prefix) {
+		prefix_len = strlen(prefix) + 1;
+		size += NFA_SPACE(prefix_len);
+	} else
+		prefix_len = 0;
+
 	UDEBUG("initial size=%u\n", size);
 
 	spin_lock_bh(&inst->lock);
@@ -665,7 +667,7 @@ nfulnl_log_packet(unsigned int pf,
 	inst->qlen++;
 
 	__build_packet_message(inst, skb, data_len, pf,
-				hooknum, in, out, li, prefix);
+				hooknum, in, out, li, prefix, prefix_len);
 
 	/* timer_pending always called within inst->lock, so there
 	 * is no chance of a race here */

--------------020801000102000603000108--
