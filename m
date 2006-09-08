From: Danny Rathjens <gmane@rathjens.org>
Subject: [PATCH] ipt_LOG split MAC
Date: Fri, 08 Sep 2006 14:09:44 -0400
Message-ID: <edsbl9$eq$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030700040009050102010106"
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
--------------030700040009050102010106
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Is a patch like this sensible?
with the log messages currently looking like:
  IN=eth0 OUT= MAC=00:c0:49:5f:9a:0d:00:00:c5:66:00:28:08:00 SRC=72.234.128.92 DST=72.1.142.189  ...
it's hard to tell what the source or destination MAC address is.

I just split the MAC header in half, but now that I am reading more about
variable length MAC addresses I don't think that is the right way to do it.

Just spitting out the raw header seems pretty efficient, too.  Perhaps that
is by design for efficienecy as opposed to laziness? :)

--------------030700040009050102010106
Content-Type: text/x-patch;
 name="ipt_LOG-split-MAC.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_LOG-split-MAC.patch"

--- net/ipv4/netfilter/ipt_LOG.c	2006-09-07 20:04:02.000000000 -0400
+++ net/ipv4/netfilter/ipt_LOG.c	2006-09-07 20:04:20.000000000 -0400
@@ -392,15 +392,19 @@
 
 	if (in && !out) {
 		/* MAC logging for input chain only. */
-		printk("MAC=");
 		if (skb->dev && skb->dev->hard_header_len
 		    && skb->mac.raw != (void*)skb->nh.iph) {
 			int i;
 			unsigned char *p = skb->mac.raw;
-			for (i = 0; i < skb->dev->hard_header_len; i++,p++)
+			for (i = 0; i < skb->dev->hard_header_len; i++,p++) {
+				if i == 0
+					printk("DSTMAC=");
+				if i == skb->dev->hard_header_len / 2
+					printk(" SRCMAC=");
 				printk("%02x%c", *p,
 				       i==skb->dev->hard_header_len - 1
 				       ? ' ':':');
+			}
 		} else
 			printk(" ");
 	}

--------------030700040009050102010106--
