From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6.11 2/4]: fix iptables userspace build
Date: Fri, 04 Feb 2005 04:05:12 +0100
Message-ID: <4202E668.6030005@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070505080408050200000509"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------070505080408050200000509
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Netfilter uses u_intXX_t types in it's headers shared with userspace. 
Some patch
added uXX types to a header, but iptables userspace doesn't know these 
types. This
breaks compilation with recent kernels. I know netfilter shouldn't use 
these types
in headers shared with userspace, but it currently does so in all files, 
so the
simple fix is to replace uXX by u_intXX_t.



--------------070505080408050200000509
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/01 14:16:17+01:00 pablo@eurodev.net 
#   [NETFILTER]: fix iptables userspace build
#   
#   Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack_tuple.h
#   2005/02/01 14:16:09+01:00 pablo@eurodev.net +2 -2
#   [NETFILTER]: fix iptables userspace build
#   
#   Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_tuple.h b/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-02-03 20:43:01 +01:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-02-03 20:43:01 +01:00
@@ -64,10 +64,10 @@
 		} u;
 
 		/* The protocol. */
-		u8 protonum;
+		u_int8_t protonum;
 
 		/* The direction (for tuplehash) */
-		u8 dir;
+		u_int8_t dir;
 	} dst;
 };
 

--------------070505080408050200000509--
