From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] ip_conntrack_irc:parse_dcc should be static
Date: Wed, 15 Dec 2004 14:56:28 +1100
Message-ID: <1103082989.8016.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: ip_conntrack_irc:parse_dcc should be static
Status: Trivial
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Found by nfsim (-Wmissing-prototypes is your friend).

Index: linux-2.6.10-rc3-bk6-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c
===================================================================
--- linux-2.6.10-rc3-bk6-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2004-12-15 14:37:16.143447512 +1100
+++ linux-2.6.10-rc3-bk6-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c	2004-12-15 14:51:38.447357392 +1100
@@ -65,8 +65,8 @@
 #define DEBUGP(format, args...)
 #endif
 
-int parse_dcc(char *data, char *data_end, u_int32_t * ip, u_int16_t * port,
-	      char **ad_beg_p, char **ad_end_p)
+static int parse_dcc(char *data, char *data_end, u_int32_t *ip,
+		     u_int16_t *port, char **ad_beg_p, char **ad_end_p)
 /* tries to get the ip_addr and port out of a dcc command
    return value: -1 on failure, 0 on success 
 	data		pointer to first byte of DCC command data

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
