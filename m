From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] ctnetlink: Make expect events work
Date: Thu, 12 Jan 2006 20:08:54 +0100
Message-ID: <43C6A946.5070009@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030206000408060504010305"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------030206000408060504010305
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

expectation events are improperly tagged in the current ctnetlink
code, this patch makes them work.

//Marcus
-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/

--------------030206000408060504010305
Content-Type: text/x-patch;
 name="ctnetlink-expect-event.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctnetlink-expect-event.diff"

[NETFILTER] ctnetlink: Make expect events work

The ctnetlink expectation events should use the NFNL_SUBSYS_CTNETLINK_EXP
subsystem, not NFNL_SUBSYS_CTNETLINK.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>

--- linux-2.6.15/net/ipv4/netfilter/ip_conntrack_netlink.c	2006/01/12 18:59:57	1.1
+++ linux-2.6.15/net/ipv4/netfilter/ip_conntrack_netlink.c	2006/01/12 19:00:03
@@ -1223,7 +1223,7 @@ static int ctnetlink_expect_event(struct
 
 	b = skb->tail;
 
-	type |= NFNL_SUBSYS_CTNETLINK << 8;
+	type |= NFNL_SUBSYS_CTNETLINK_EXP << 8;
 	nlh   = NLMSG_PUT(skb, 0, 0, type, sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
 

--------------030206000408060504010305--
