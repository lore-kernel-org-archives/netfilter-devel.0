From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [TRIVIAL PATCH] remove 'use of cast expressions as lvalues is deprecated' warning in XOR
Date: Wed, 26 May 2004 17:43:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1658365406.20040526174301@dns.toxicfilms.tv>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tim.Vandermeersch@pandora.be
Resent-Message-Id: <E1BT0Yl-0003dj-71@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

gcc-3.3.3 and later have deprecated using casts as lvalues.

This patch suggests removing casts in ipt_XOR.c and ip6t_XOR.c
from patch-o-matic.

Regards,
Maciej

Index: XOR/linux/net/ipv4/netfilter/ipt_XOR.c
===================================================================
RCS file: /cvspublic/patch-o-matic-ng/XOR/linux/net/ipv4/netfilter/ipt_XOR.c,v
retrieving revision 1.1
diff -u -r1.1 ipt_XOR.c
--- XOR/linux/net/ipv4/netfilter/ipt_XOR.c      18 Dec 2003 18:47:55 -0000      1.1
+++ XOR/linux/net/ipv4/netfilter/ipt_XOR.c      26 May 2004 15:36:33 -0000
@@ -34,7 +34,7 @@
                tcph = (struct tcphdr *) ((*pskb)->data + iph->ihl*4);
                for (i=0, j=0; i<(ntohs(iph->tot_len) - iph->ihl*4 - tcph->doff*4); ) {
                        for (k=0; k<=info->block_size; k++) {
-                               (char) (*pskb)->data[ iph->ihl*4 + tcph->doff*4 + i ] ^= 
+                               (*pskb)->data[ iph->ihl*4 + tcph->doff*4 + i ] ^= 
                                                info->key[j];
                                i++;
                        }
@@ -46,7 +46,7 @@
                udph = (struct udphdr *) ((*pskb)->data + iph->ihl*4);
                for (i=0, j=0; i<(ntohs(udph->len)-8); ) {
                        for (k=0; k<=info->block_size; k++) {
-                               (char) (*pskb)->data[ iph->ihl*4 + sizeof(struct udphdr) + i ] ^= 
+                               (*pskb)->data[ iph->ihl*4 + sizeof(struct udphdr) + i ] ^= 
                                                info->key[j];
                                i++;
                        }
Index: XOR/linux-2.6/net/ipv4/netfilter/ipt_XOR.c
===================================================================
RCS file: /cvspublic/patch-o-matic-ng/XOR/linux-2.6/net/ipv4/netfilter/ipt_XOR.c,v
retrieving revision 1.3
diff -u -r1.3 ipt_XOR.c
--- XOR/linux-2.6/net/ipv4/netfilter/ipt_XOR.c  25 Feb 2004 08:59:06 -0000      1.3
+++ XOR/linux-2.6/net/ipv4/netfilter/ipt_XOR.c  26 May 2004 15:36:33 -0000
@@ -40,7 +40,7 @@
                tcph = (struct tcphdr *) ((*pskb)->data + iph->ihl*4);
                for (i=0, j=0; i<(ntohs(iph->tot_len) - iph->ihl*4 - tcph->doff*4); ) {
                        for (k=0; k<=info->block_size; k++) {
-                               (char) (*pskb)->data[ iph->ihl*4 + tcph->doff*4 + i ] ^= 
+                               (*pskb)->data[ iph->ihl*4 + tcph->doff*4 + i ] ^= 
                                                info->key[j];
                                i++;
                        }
@@ -52,7 +52,7 @@
                udph = (struct udphdr *) ((*pskb)->data + iph->ihl*4);
                for (i=0, j=0; i<(ntohs(udph->len)-8); ) {
                        for (k=0; k<=info->block_size; k++) {
-                               (char) (*pskb)->data[ iph->ihl*4 + sizeof(struct udphdr) + i ] ^= 
+                               (*pskb)->data[ iph->ihl*4 + sizeof(struct udphdr) + i ] ^= 
                                                info->key[j];
                                i++;
                        }
