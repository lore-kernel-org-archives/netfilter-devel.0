From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6.10]: Fix memory leak in ip_conntrack_ftp
Date: Wed, 08 Dec 2004 22:40:58 +0100
Message-ID: <41B774EA.9030002@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040400070107030803080009"
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
--------------040400070107030803080009
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

this patch fixes a remotely triggerable memory leak in ip_conntrack_ftp.
exp leaks when a FTP date connection to a host different from the client
(FXP) is attempted and the loose option is not set. It should go in
2.6.10 in my opinion.

Regards
Patrick


--------------040400070107030803080009
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/08 02:00:45+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix memory leak in ip_conntrack_ftp
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_ftp.c
#   2004/12/08 02:00:39+01:00 kaber@coreworks.de +1 -0
#   [NETFILTER]: Fix memory leak in ip_conntrack_ftp
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-12-08 22:22:37 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-12-08 22:22:37 +01:00
@@ -381,6 +381,7 @@
 		   problem (DMZ machines opening holes to internal
 		   networks, or the packet filter itself). */
 		if (!loose) {
+			ip_conntrack_expect_put(exp);
 			ret = NF_ACCEPT;
 			goto out;
 		}

--------------040400070107030803080009--
