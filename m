From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] ctnetlink: Fix dumping of helper name.
Date: Tue, 27 Dec 2005 14:36:12 +0100
Message-ID: <43B1434C.8000005@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050800080005040409050205"
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
--------------050800080005040409050205
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

this patch fixes ctnetlink dumping of the helper name.

//Marcus
-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/

--------------050800080005040409050205
Content-Type: text/x-patch;
 name="ctnetlink-dump_helpinfo.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctnetlink-dump_helpinfo.diff"

[NETFILTER] ctnetlink: Fix dumping of helper name.

Properly dump the helper name instead of internal kernel data.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>

--- linux-2.6.15-rc7/net/ipv4/netfilter/ip_conntrack_netlink.c	2005/12/27 13:21:52	1.1
+++ linux-2.6.15-rc7/net/ipv4/netfilter/ip_conntrack_netlink.c	2005/12/27 13:21:54
@@ -160,7 +160,7 @@ ctnetlink_dump_helpinfo(struct sk_buff *
 		return 0;
 		
 	nest_helper = NFA_NEST(skb, CTA_HELP);
-	NFA_PUT(skb, CTA_HELP_NAME, CTA_HELP_MAXNAMESIZE, &ct->helper->name);
+	NFA_PUT(skb, CTA_HELP_NAME, CTA_HELP_MAXNAMESIZE, ct->helper->name);
 
 	if (ct->helper->to_nfattr)
 		ct->helper->to_nfattr(skb, ct);

--------------050800080005040409050205--
