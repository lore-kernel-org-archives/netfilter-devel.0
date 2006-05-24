From: philipc@snapgear.com
Subject: [PATCH 4/4] drop ftp bounce attacks
Date: Wed, 24 May 2006 14:04:45 +1000
Message-ID: <20060524040951.217594000@snapgear.com>
References: <20060524040441.111049000@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename=dropftpbounce.patch
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

FTP bounce attacks work by specifying a different IP address in
the PORT command for active mode.  This causes the FTP server to
open a connection to another machine.

The best solution for this problem is to fix the FTP server.
This is a well known problem, and all major FTP servers should
have been fixed.

An alternative solution is to drop the packet in connection tracking.  
Dropping packets isn't the intended use of connection tracking,
but creating a new match to do this seems inefficient.

Signed-off-by: Philip Craig <philipc@snapgear.com>

Index: linux-2.6.17-rc4.orig/net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- linux-2.6.17-rc4.orig.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2006-05-24 11:57:28.000000000 +1000
+++ linux-2.6.17-rc4.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2006-05-24 13:09:44.000000000 +1000
@@ -405,8 +405,14 @@ static int help(struct sk_buff **pskb,
 		   problem (DMZ machines opening holes to internal
 		   networks, or the packet filter itself). */
 		if (!loose) {
-			ret = NF_ACCEPT;
-			goto out_put_expect;
+			if (net_ratelimit())
+				printk("conntrack_ftp: ip mismatch: "
+				       "%u,%u,%u,%u != %u.%u.%u.%u\n",
+				       array[0], array[1], array[2], array[3],
+				       NIPQUAD(ct->tuplehash[dir].tuple.src.ip));
+			ret = NF_DROP;
+			ip_conntrack_expect_put(exp);
+			goto out;
 		}
 		exp->tuple.dst.ip = htonl((array[0] << 24) | (array[1] << 16)
 					 | (array[2] << 8) | array[3]);
@@ -436,7 +442,6 @@ static int help(struct sk_buff **pskb,
 			ret = NF_ACCEPT;
 	}
 
-out_put_expect:
 	ip_conntrack_expect_put(exp);
 
 out_update_nl:

--
