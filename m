From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP connection tracking
Date: Tue, 18 Feb 2003 10:50:51 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E51836B.8030207@snapgear.com>
References: <4.2.0.58.20030119145120.00b1c6f0@avocetgw> <20030217190023.GF11812@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000908000905050600000204"
Cc: Paul Mielke <paulm@routefree.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000908000905050600000204
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

Harald Welte wrote:
> I have put a proposed patch into CVS:
> (patch-o-matic/pending/10_local-nat-expectfn.patch)
> 
> This patch rather moves the particular piece of code a couple of lines
> down, so we assure that an expectfn (if it exists) gets called.
> 
> Can you please test if your setup works with this patch?

Paul and I have tested that the attached patch fixes the problem.
It is similar to yours, except that it returns earlier.  I don't
think the calls to place_in_hashes() and do_bindings() are
necessary if we just need to return NF_ACCEPT without doing any
NAT?

Regards,

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances

--------------000908000905050600000204
Content-Type: text/plain;
 name="nat_local.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nat_local.patch"

diff -u -r1.3 ip_nat_standalone.c
--- linux-2.4.x/net/ipv4/netfilter/ip_nat_standalone.c	9 Dec 2002 15:18:06 -0000	1.3
+++ linux-2.4.x/net/ipv4/netfilter/ip_nat_standalone.c	21 Jan 2003 08:20:45 -0000
@@ -109,12 +109,6 @@
 		}
 		/* Fall thru... (Only ICMPs can be IP_CT_IS_REPLY) */
 	case IP_CT_NEW:
-#ifdef CONFIG_IP_NF_NAT_LOCAL
-		/* LOCAL_IN hook doesn't have a chain and thus doesn't care
-		 * about new packets -HW */
-		if (hooknum == NF_IP_LOCAL_IN)
-			return NF_ACCEPT;
-#endif
 		info = &ct->nat.info;
 
 		WRITE_LOCK(&ip_nat_lock);
@@ -130,6 +124,14 @@
 				ret = call_expect(master_ct(ct), pskb, 
 						  hooknum, ct, info);
 			} else {
+#ifdef CONFIG_IP_NF_NAT_LOCAL
+				/* LOCAL_IN hook doesn't have a chain and thus
+				 * doesn't care about new packets -HW */
+				if (hooknum == NF_IP_LOCAL_IN) {
+					WRITE_UNLOCK(&ip_nat_lock);
+					return NF_ACCEPT;
+				}
+#endif
 				ret = ip_nat_rule_find(pskb, hooknum, in, out,
 						       ct, info);
 			}

--------------000908000905050600000204--
