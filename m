From: Patrick Schaaf <bof@bof.de>
Subject: [PATCH] ROUTE target 2.6 correction
Date: Sat, 20 Nov 2004 09:23:44 +0100
Message-ID: <20041120082344.GA15784@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Cc: delaunois@info.ucl.ac.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello World,

find appended a correction, as a patch against pom-ng, for the linux-2.6
ROUTE target.

The first hunk, setting skb->protocol in the route() function, is
neccessary for correct operation of the target in mangle/OUTPUT.
Without this hunk, the outgoing packets have their ethernet
type field set to 0x0000, instead of 0x0800.

The second hunk is probably not strictly neccessary; it faithfully
duplicates what's in ipv4/ip_output.c:ip_finish_output2() in the
2.6.10-rc1 kernel, where the ROUTE target stole the relevant code.

BTW, cvs.netfilter.org gives me 'Connection Refused'. Maybe the patch
is a bit off, because I work against a slightly outdated pom-ng copy.

The patch has only seen very light testing by me, only testing the
--gw option. But Cedric indicated that I should send it to netfilter-devel
right away. So here it is.

best regards
  Patrick

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ROUTE.fix.20041119.patch"

--- bof-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	Mon Nov 15 10:13:33 2004
+++ ../build-pom-tee-2.6.10-rc1/net/ipv4/netfilter/ipt_ROUTE.c	Sat Nov 20 08:32:21 2004
@@ -88,6 +88,7 @@
 	if (!ifindex || rt->u.dst.dev->ifindex == ifindex) {
 		skb->dst = &rt->u.dst;
 		skb->dev = skb->dst->dev;
+		skb->protocol = htons(ETH_P_IP);
 		return 1;
 	}
 	
@@ -113,10 +114,30 @@
 {
 	struct dst_entry *dst = skb->dst;
 	struct hh_cache *hh = dst->hh;
+	struct net_device *dev = dst->dev;
+	int hh_len = LL_RESERVED_SPACE(dev);
+
+	/* Be paranoid, rather than too clever. */
+	if (unlikely(skb_headroom(skb) < hh_len && dev->hard_header)) {
+		struct sk_buff *skb2;
+
+		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
+		if (skb2 == NULL) {
+			kfree_skb(skb);
+			return;
+		}
+		if (skb->sk)
+			skb_set_owner_w(skb2, skb->sk);
+		kfree_skb(skb);
+		skb = skb2;
+	}
 
 	if (hh) {
+		int hh_alen;
+
 		read_lock_bh(&hh->hh_lock);
-		memcpy(skb->data - 16, hh->hh_data, 16);
+		hh_alen = HH_DATA_ALIGN(hh->hh_len);
+  		memcpy(skb->data - hh_alen, hh->hh_data, hh_alen);
 		read_unlock_bh(&hh->hh_lock);
 		skb_push(skb, hh->hh_len);
 		hh->hh_output(skb);

--MGYHOYXEY6WxJCY8--
