From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: [PATCH] [POM-NG] missing spin_unlock_bh in u32 match
Date: Fri, 25 Nov 2005 04:07:13 +0100
Message-ID: <43867FE1.9050406@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060504010901080007010007"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------060504010901080007010007
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Fix missing spin_unlock_bh in exit path in u32. This problem only
affects the 2.6 branch.

-- 
Pablo

--------------060504010901080007010007
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: patchlets/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c
===================================================================
--- patchlets/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c	(revision 4547)
+++ patchlets/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c	(working copy)
@@ -166,8 +166,10 @@
 			case IPT_U32_AT:
 				AttPos += val;
 				pos = number;
-				if (AttPos + pos + 3 > skb->len || AttPos + pos < 0) 
+				if (AttPos + pos + 3 > skb->len || AttPos + pos < 0) {
+					spin_unlock_bh(&u32_lock);
 					return 0;
+				}
 
 				val = (base[AttPos + pos]<<24) 
 				     +(base[AttPos + pos + 1]<<16)

--------------060504010901080007010007--
