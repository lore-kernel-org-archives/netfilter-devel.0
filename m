From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.6.16]: Fix outgoing redirects to loopback
Date: Fri, 17 Feb 2006 18:25:59 +0100
Message-ID: <43F60727.9030407@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040903080305070204020400"
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
--------------040903080305070204020400
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Fix another regression from the IPsec patches.



--------------040903080305070204020400
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix outgoing redirects to loopback

When redirecting an outgoing packet to loopback, it keeps the original
conntrack reference and information from the outgoing path, which
falsely triggers the check for DNAT on input and the dst_entry is
released to trigger rerouting. ip_route_input refuses to route the
packet because it has a local source address and it is dropped.

Look at the packet itself to dermine if it was NATed. Also fix a
missing inversion that causes unneccesary xfrm lookups.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 32043a0e681a5d3289a3a189af5c52a3d9973867
tree 21f19259c32d1ae8f1581501cb42a264e0f02242
parent 7bf85ddc80546f9398599e80bf42e7419ef76513
author Patrick McHardy <kaber@trash.net> Fri, 17 Feb 2006 15:36:40 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 17 Feb 2006 15:36:40 +0100

 net/ipv4/netfilter/ip_nat_standalone.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index 7c3f7d3..ab1f88f 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -200,20 +200,14 @@ ip_nat_in(unsigned int hooknum,
           const struct net_device *out,
           int (*okfn)(struct sk_buff *))
 {
-	struct ip_conntrack *ct;
-	enum ip_conntrack_info ctinfo;
 	unsigned int ret;
+	u_int32_t daddr = (*pskb)->nh.iph->daddr;
 
 	ret = ip_nat_fn(hooknum, pskb, in, out, okfn);
 	if (ret != NF_DROP && ret != NF_STOLEN
-	    && (ct = ip_conntrack_get(*pskb, &ctinfo)) != NULL) {
-		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-
-		if (ct->tuplehash[dir].tuple.dst.ip !=
-		    ct->tuplehash[!dir].tuple.src.ip) {
-			dst_release((*pskb)->dst);
-			(*pskb)->dst = NULL;
-		}
+	    && daddr != (*pskb)->nh.iph->daddr) {
+		dst_release((*pskb)->dst);
+		(*pskb)->dst = NULL;
 	}
 	return ret;
 }
@@ -276,7 +270,7 @@ ip_nat_local_fn(unsigned int hooknum,
 		    ct->tuplehash[!dir].tuple.src.ip
 #ifdef CONFIG_XFRM
 		    || ct->tuplehash[dir].tuple.dst.u.all !=
-		       ct->tuplehash[dir].tuple.src.u.all
+		       ct->tuplehash[!dir].tuple.src.u.all
 #endif
 		    )
 			return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;

--------------040903080305070204020400--
