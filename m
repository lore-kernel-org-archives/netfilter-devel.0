From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH] Re: find_appropriate_src() BUG also exist in 2.4.24
Date: Mon, 05 Apr 2004 14:56:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1081169784.1200.24.camel@nienna.balabit>
References: <20040405122020.40666.qmail@web41705.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-jMWDCzX8JOAJtMGsF2bP"
Cc: zhi wang <pangy2004@yahoo.com>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040405122020.40666.qmail@web41705.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-jMWDCzX8JOAJtMGsF2bP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


  Hi,

On Mon, 2004-04-05 at 14:20, zhi wang wrote:
> Yes, there are different. This bug is because get_unique_tuple blindly accepts
> whatever find_appropriate_src returns in 2.4.x. While 2.6.5 has the return
> tuple checked by ip_nat_used_tuple. You must have know this.:)

  Harald, would it be possible to apply the patch which adds this check
(attached), plus the in_range() fix from
pom/broken/74_nat-range-fix.patch to 2.4? They seem to be reliable in
2.6.

-- 
 Regards,
   Krisztian KOVACS

--=-jMWDCzX8JOAJtMGsF2bP
Content-Disposition: attachment; filename=check_find_appropriate_src_result.patch
Content-Type: text/x-patch; name=check_find_appropriate_src_result.patch; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Index: linux-2.4.25/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.4.25.orig/net/ipv4/netfilter/ip_nat_core.c	Wed Feb 18 14:36:32 2004
+++ linux-2.4.25/net/ipv4/netfilter/ip_nat_core.c	Mon Apr  5 14:50:10 2004
@@ -420,7 +420,8 @@
 			*tuple = ((struct ip_conntrack_tuple)
 				  { *manip, orig_tuple->dst });
 			DEBUGP("get_unique_tuple: Found current src map\n");
-			return 1;
+			if (!ip_nat_used_tuple(tuple, conntrack))
+				return 1;
 		}
 	}
 

--=-jMWDCzX8JOAJtMGsF2bP--
