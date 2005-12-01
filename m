From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] ctnetlink: Fix NAT info setting.
Date: Thu, 01 Dec 2005 13:39:42 +0100
Message-ID: <438EEF0E.60206@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090601000107030402000203"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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
--------------090601000107030402000203
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

this patch fixes a latent bug with the NAT info setting in ctnetlink.
(Currently I believe it's never triggered, as NAT info can not be
 changed on existing conntracks)

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/

--------------090601000107030402000203
Content-Type: text/x-patch;
 name="ctnetlink-nat.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctnetlink-nat.diff"

[NETFILTER] ctnetlink: Fix NAT info setting.

ip_nat_initialized() takes enum ip_nat_manip_type as it's second
argument, not a hook number. The current code was not only ugly,
but also broken as IP_NAT_MANIP_SRC != NF_IP_POST_ROUTING.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>

--- linux-2.6.15-rc4/net/ipv4/netfilter/ip_conntrack_netlink.c	2005/12/01 12:25:50	1.1
+++ linux/net/ipv4/netfilter/ip_conntrack_netlink.c	2005/12/01 12:25:54
@@ -855,6 +855,7 @@ ctnetlink_change_status(struct ip_conntr
 		return -EINVAL;
 #else
 		unsigned int hooknum;
+		enum ip_nat_manip_type manip;
 		struct ip_nat_range range;
 
 		if (ctnetlink_parse_nat(cda, ct, &range) < 0)
@@ -867,17 +868,19 @@ ctnetlink_change_status(struct ip_conntr
 		/* This is tricky but it works. ip_nat_setup_info needs the
 		 * hook number as parameter, so let's do the correct 
 		 * conversion and run away */
-		if (status & IPS_SRC_NAT_DONE)
-			hooknum = NF_IP_POST_ROUTING; /* IP_NAT_MANIP_SRC */
-		else if (status & IPS_DST_NAT_DONE)
-			hooknum = NF_IP_PRE_ROUTING;  /* IP_NAT_MANIP_DST */
-		else 
+		if (status & IPS_SRC_NAT_DONE) {
+			hooknum = NF_IP_POST_ROUTING;
+			manip = IP_NAT_MANIP_SRC;
+		} else if (status & IPS_DST_NAT_DONE) {
+			hooknum = NF_IP_PRE_ROUTING;
+			manip = IP_NAT_MANIP_DST;
+		} else 
 			return -EINVAL; /* Missing NAT flags */
 
 		DEBUGP("NAT status: %lu\n", 
 		       status & (IPS_NAT_MASK | IPS_NAT_DONE_MASK));
 		
-		if (ip_nat_initialized(ct, hooknum))
+		if (ip_nat_initialized(ct, manip))
 			return -EEXIST;
 		ip_nat_setup_info(ct, &range, hooknum);
 

--------------090601000107030402000203--
