From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ipt_XOR fails to compile in gcc4
Date: Mon, 10 Jan 2005 16:36:32 -0800
Message-ID: <20050111003632.GA14332@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

As reported by Pawe³ Sikora, the attached fix is required by
GCC 4 due to elimination of lvalue in assignments.

Resolves bugzilla #264

Phil


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-xor

diff -ru pom-orig/XOR/linux-2.6/net/ipv4/netfilter/ipt_XOR.c pom-new/XOR/linux-2.6/net/ipv4/netfilter/ipt_XOR.c
--- pom-orig/XOR/linux-2.6/net/ipv4/netfilter/ipt_XOR.c	2004-02-25 03:59:06.000000000 -0500
+++ pom-new/XOR/linux-2.6/net/ipv4/netfilter/ipt_XOR.c	2005-01-10 19:34:01.218767184 -0500
@@ -40,7 +40,7 @@
 		tcph = (struct tcphdr *) ((*pskb)->data + iph->ihl*4);
 		for (i=0, j=0; i<(ntohs(iph->tot_len) - iph->ihl*4 - tcph->doff*4); ) {
 			for (k=0; k<=info->block_size; k++) {
-				(char) (*pskb)->data[ iph->ihl*4 + tcph->doff*4 + i ] ^= 
+				(*pskb)->data[ iph->ihl*4 + tcph->doff*4 + i ] ^=
 						info->key[j];
 				i++;
 			}
@@ -52,7 +52,7 @@
 		udph = (struct udphdr *) ((*pskb)->data + iph->ihl*4);
 		for (i=0, j=0; i<(ntohs(udph->len)-8); ) {
 			for (k=0; k<=info->block_size; k++) {
-				(char) (*pskb)->data[ iph->ihl*4 + sizeof(struct udphdr) + i ] ^= 
+				(*pskb)->data[ iph->ihl*4 + sizeof(struct udphdr) + i ] ^= 
 						info->key[j];
 				i++;
 			}

--AhhlLboLdkugWU4S--
