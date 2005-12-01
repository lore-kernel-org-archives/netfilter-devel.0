From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH] ctnetlink: Fix NAT info setting.
Date: Thu, 01 Dec 2005 14:22:45 +0100
Message-ID: <438EF925.4050802@eurodev.net>
References: <438EEF0E.60206@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080502010708010205000308"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <438EEF0E.60206@ingate.com>
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
--------------080502010708010205000308
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Marcus Sundberg wrote:
> [NETFILTER] ctnetlink: Fix NAT info setting.
> 
> ip_nat_initialized() takes enum ip_nat_manip_type as it's second
> argument, not a hook number. The current code was not only ugly,
> but also broken as IP_NAT_MANIP_SRC != NF_IP_POST_ROUTING.

Thanks for the bugfix but I don't like it, it's a bit bloated. Harald,
please submit the patch attached. It uses HOOK2MANIP macro instead.

-- 
Pablo

--------------080502010708010205000308
Content-Type: text/plain;
 name="x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x.patch"

[NETFILTER] ip_nat_initialized takes wrong parameter

ip_nat_initialized() takes enum ip_nat_manip_type as it's second
argument, not a hook number.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-01 14:15:09.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-01 14:16:44.000000000 +0100
@@ -876,7 +876,7 @@ ctnetlink_change_status(struct ip_conntr
 		DEBUGP("NAT status: %lu\n", 
 		       status & (IPS_NAT_MASK | IPS_NAT_DONE_MASK));
 		
-		if (ip_nat_initialized(ct, hooknum))
+		if (ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
 			return -EEXIST;
 		ip_nat_setup_info(ct, &range, hooknum);
 

--------------080502010708010205000308--
