From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/4]: Add inversion to multiport match
Date: Tue, 25 Jan 2005 05:48:38 +0100
Message-ID: <41F5CFA6.7030400@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070904090907020600010505"
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
--------------070904090907020600010505
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------070904090907020600010505
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/25 04:31:49+01:00 kernel@linuxace.com 
#   [NETFILTER]: Add inversion to multiport match
#   
#   Should add this to rev1 of multiport before 2.6.11 comes out.
#   
#   Signed-off-by: Phil Oester <kernel@linuxace.com>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_multiport.c
#   2005/01/25 04:31:40+01:00 kernel@linuxace.com +8 -7
#   [NETFILTER]: Add inversion to multiport match
#   
#   Should add this to rev1 of multiport before 2.6.11 comes out.
#   
#   Signed-off-by: Phil Oester <kernel@linuxace.com>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ipt_multiport.h
#   2005/01/25 04:31:40+01:00 kernel@linuxace.com +1 -0
#   [NETFILTER]: Add inversion to multiport match
#   
#   Should add this to rev1 of multiport before 2.6.11 comes out.
#   
#   Signed-off-by: Phil Oester <kernel@linuxace.com>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ipt_multiport.h b/include/linux/netfilter_ipv4/ipt_multiport.h
--- a/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-25 04:37:23 +01:00
+++ b/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-25 04:37:23 +01:00
@@ -25,5 +25,6 @@
 	u_int8_t count;				/* Number of ports */
 	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
 	u_int8_t pflags[IPT_MULTI_PORTS];	/* Port flags */
+	u_int8_t invert;			/* Invert flag */
 };
 #endif /*_IPT_MULTIPORT_H*/
diff -Nru a/net/ipv4/netfilter/ipt_multiport.c b/net/ipv4/netfilter/ipt_multiport.c
--- a/net/ipv4/netfilter/ipt_multiport.c	2005-01-25 04:37:23 +01:00
+++ b/net/ipv4/netfilter/ipt_multiport.c	2005-01-25 04:37:23 +01:00
@@ -64,30 +64,31 @@
 
 			if (minfo->flags == IPT_MULTIPORT_SOURCE
 			    && src >= s && src <= e)
-				return 1;
+				return 1 ^ minfo->invert;
 			if (minfo->flags == IPT_MULTIPORT_DESTINATION
 			    && dst >= s && dst <= e)
-				return 1;
+				return 1 ^ minfo->invert;
 			if (minfo->flags == IPT_MULTIPORT_EITHER
 			    && ((dst >= s && dst <= e)
 				|| (src >= s && src <= e)))
-				return 1;
+				return 1 ^ minfo->invert;
 		} else {
 			/* exact port matching */
 			duprintf("src or dst matches with %d?\n", s);
+
 			if (minfo->flags == IPT_MULTIPORT_SOURCE
 			    && src == s)
-				return 1;
+				return 1 ^ minfo->invert;
 			if (minfo->flags == IPT_MULTIPORT_DESTINATION
 			    && dst == s)
-				return 1;
+				return 1 ^ minfo->invert;
 			if (minfo->flags == IPT_MULTIPORT_EITHER
 			    && (src == s || dst == s))
-				return 1;
+				return 1 ^ minfo->invert;
 		}
 	}
  
- 	return 0;
+ 	return minfo->invert;
 }
 
 static int

--------------070904090907020600010505--
