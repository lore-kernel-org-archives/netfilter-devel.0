From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP connection tracking fixes
Date: Tue, 21 Jan 2003 18:25:03 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E2D03DF.4090407@snapgear.com>
References: <200301180029.h0I0T3d29430@stilton.routefree.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060106020107010608010501"
Cc: netfilter-devel@lists.netfilter.org, paulm@broadon.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: paulm@routefree.com
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
--------------060106020107010608010501
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

paulm@routefree.com wrote:
> My solution was just to turn the
> 
> #ifdef CONFIG_IP_NF_NAT_LOCAL
> 
> into
> 
> #if 0
> 
> thus removing this section of code.  Things seem to work fine after
> this change, but perhaps there are other cases that I don't understand
> in which this change would break things.  Harald, do you see any harm
> in this solution?

If you do this and turn on CONFIG_NETFILTER_DEBUG, you get:

IP_NF_ASSERT: ipt_do_table:ip_tables.c:290

which is a result of ipt_do_table being called for the LOCAL_IN
hook in the nat table.

I've attached a patch that moves the #ifdef down a bit, so that
bindings can still be set up for expectations, but otherwise
we skip doing ip_nat_rule_find() for the LOCAL_IN hook.

-- 
Philip Craig     Software Engineer     http://www.SnapGear.com
philipc@snapgear.com  Ph: +61 7 3435 2821  Fx: +61 7 3891 3630
SnapGear  -  Custom Embedded Solutions and Security Appliances

--------------060106020107010608010501
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

--------------060106020107010608010501--
