From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP connection tracking and Poptop on same box
Date: Tue, 09 Sep 2003 18:39:56 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F5D91DC.3030706@snapgear.com>
References: <3F542C4E.1000307@netbox.biz> <Pine.GSO.4.56.0309031853090.10914@shemp.vdata.com> <3F56E2E2.5040007@netbox.biz> <Pine.GSO.4.56.0309040327250.10914@shemp.vdata.com> <3F57D70B.3040307@netbox.biz> <20030905115534.GD665@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030402030600080208020904"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030905115534.GD665@obroa-skai.de.gnumonks.org>
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
--------------030402030600080208020904
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

Harald Welte wrote:
> I'm sorry for this whole mess.  Releasing a new version of the
> pptp-conntrack-nat patch is on my TODO list for quite some time.  I'll
> expect it to be done during the next week.

When you do this, you will need the attached patches.  Jeff Hall
posted them to the list on 2003/04/08, but I couldn't find them
in the netfilter CVS anywhere.

natcore-noexpecthelper.patch is related to 25natcore-nohelper.patch
which was applied in 2.4.22.  25natcore-nohelper.patch stopped us
from calling ip_nat_helper->help() when there were no manips, but
we were still calling ip_nat_helper->expect().  This was corrupting
the call IDs in the GRE packets.

pptp-grekeymapdestroy.patch does some more cleaning up when freeing
the unused second expectation.

I now have pptp connection tracking working using linux 2.4.22,
the latest patch from netfilter/patch-o-matic/extra, the latest
files from netfilter-extensions/helpers/pptp, and the attached
two patches.

I have two concerns with the current patches:

25natcore-nohelper.patch fixed the problem where we were doing
NAT for connections even if there was no matching NAT rules.
However, we now have the opposite problem in that we don't do
NAT even if we should.  This is because this patch bases the
decision on the number of manipulations, but it is possible to
match a NAT rule and have no manipulations.

The impact of this is that I cannot guarentee unique call IDs for
local connections when doing masquerading, since they usually have
no manipulations (they will occassionally have a port manip).

The only solution I can see for this problem is to add another
field to ip_nat_info to determine whether a NAT rule was matched.

The second concern is that I believe we choose the NATed call ID
based on the TCP source port prior to source NAT, which means we
may not get a unique call ID.  If you agree this is a problem
then I can try to fix it.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances

--------------030402030600080208020904
Content-Type: text/plain;
 name="natcore-noexpecthelper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="natcore-noexpecthelper.patch"

--- linux-2.4.x/net/ipv4/netfilter/ip_nat_standalone.c	25 Jun 2003 13:50:47 -0000	1.5
+++ linux-2.4.x/net/ipv4/netfilter/ip_nat_standalone.c	5 Sep 2003 05:29:24 -0000	1.6
@@ -121,8 +121,13 @@
 			if (ct->master
 			    && master_ct(ct)->nat.info.helper
 			    && master_ct(ct)->nat.info.helper->expect) {
-				ret = call_expect(master_ct(ct), pskb, 
+				if (master_ct(ct)->nat.info.num_manips) {
+					ret = call_expect(master_ct(ct), pskb, 
 						  hooknum, ct, info);
+				} else {
+					WRITE_UNLOCK(&ip_nat_lock);
+					return NF_ACCEPT;
+				}
 			} else {
 #ifdef CONFIG_IP_NF_NAT_LOCAL
 				/* LOCAL_IN hook doesn't have a chain!  */

--------------030402030600080208020904
Content-Type: text/plain;
 name="pptp-grekeymapdestroy.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pptp-grekeymapdestroy.patch"

--- linux-2.4.x/net/ipv4/netfilter/ip_conntrack_pptp.c	5 Sep 2003 04:24:24 -0000	1.12
+++ linux-2.4.x/net/ipv4/netfilter/ip_conntrack_pptp.c	5 Sep 2003 05:29:24 -0000	1.13
@@ -124,6 +124,7 @@
 			/* remove only if occurred at same sequence number */
 			if (other_exp != exp && other_exp->seq == exp->seq) {
 				DEBUGP("unexpecting other direction\n");
+				ip_ct_gre_keymap_destroy(exp);
 				ip_conntrack_unexpect_related(other_exp);
 			}
 		}

--------------030402030600080208020904--
