From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] Fix libipt_DSCP.c help message
Date: Wed, 3 Mar 2004 21:04:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <997190872.20040303210409@dns.toxicfilms.tv>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

this patch is pretty self-explanatory, fixes the way
the help message is displayed.

Best regards,
Maciej

Index: libipt_DSCP.c
===================================================================
RCS file: /cvspublic/iptables/extensions/libipt_DSCP.c,v
retrieving revision 1.6
diff -u -r1.6 libipt_DSCP.c
--- libipt_DSCP.c       7 Aug 2002 09:55:37 -0000       1.6
+++ libipt_DSCP.c       3 Mar 2004 20:02:22 -0000
@@ -35,7 +35,7 @@
 "                              or in hex (ex: 0x20)\n"
 "  --set-dscp-class class      Set the DSCP field in packet header to the\n"
 "                              value represented by the DiffServ class value.\n"
-"                              This class may be EF,BE or any of the CSxx "
+"                              This class may be EF,BE or any of the CSxx\n"
 "                              or AFxx classes.\n"
 "\n"
 "                              These two options are mutually exclusive !\

 
