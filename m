From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH][CTNETLINK] Include the id in conntrack netlink events.
Date: Tue, 14 Aug 2007 15:07:56 +1000
Message-ID: <46C138AC.1000106@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050102090002090000030708"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------050102090002090000030708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I need the id in ctnetlink events for my application, so here's a
patch to add it in case this wasn't left out intentionally.

--------------050102090002090000030708
Content-Type: text/x-diff;
 name="ctnl-event-id.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctnl-event-id.patch"

Include the id in conntrack netlink events.

Signed-off-by: Philip Craig <philipc@snapgear.com>

--- linux-2.6.x/net/netfilter/nf_conntrack_netlink.c	9 Jul 2007 04:54:43 -0000
+++ linux-2.6.x/net/netfilter/nf_conntrack_netlink.c	14 Aug 2007 04:51:22 -0000
@@ -362,6 +362,9 @@ static int ctnetlink_conntrack_event(str
 	nfmsg->version	= NFNETLINK_V0;
 	nfmsg->res_id	= 0;
 
+	if (ctnetlink_dump_id(skb, ct) < 0)
+		goto nfattr_failure;
+
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_ORIG);
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
 		goto nfattr_failure;

--------------050102090002090000030708--
