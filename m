From: Jeff Hall <hall@vdata.com>
Subject: Problems with 25_natcore-nohelper patch
Date: Fri, 9 May 2003 03:14:09 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.03.10305090250510.7371-100000@shemp.vdata.com>
References: <200305081512.31038.raivis@mt.lv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Raivis Bucis <raivis@mt.lv>
In-Reply-To: <200305081512.31038.raivis@mt.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Did you also apply the patches below? They're from a message to Harald
Welte on 2003/4/8 and I believe they pertain to the problem you're
having.

I tested the pptp client from sourceforge.net on a machine also running
a PoPToP server and was able to make a successful outgoing connection from
that machine.

If these patches don't solve your problem, let me know and I'll send you
all the pertinent sources.

On Thu, 8 May 2003, Raivis Bucis wrote:

> Hello,
> 
> I would like to inform you that width 25_natcore-nohelper patch PPTP NAT stops 
> working correctly. Specifically PPTP client (PAC) on the box that has 
> ip_nat_pptp.o loaded doesn't work.
> 
> Since PPTP NAT allways changes callerID, it is required that pptp_nat helper 
> is also allways called, but pptp client TCP controlling connection doesn't 
> have any manips, and only associated GRE conntrack has manips for callerID 
> changing. So pptp_nat helper can not change callerID in controll connection 
> and PPTP doesn't work anymore.
> 
> Is this a known problem?
> 
> Raivis
> 

--- ip_conntrack_pptp.v1_8      Tue Apr  8 06:02:29 2003
+++ ip_conntrack_pptp.c Thu Apr  3 03:56:59 2003
@@ -124,6 +124,7 @@
 			/* remove only if occurred at same sequence number */
 			if (other_exp != exp && other_exp->seq == exp->seq) {
 				DEBUGP("unexpecting other direction\n");
+				ip_ct_gre_keymap_destroy(other_exp);
 				ip_conntrack_unexpect_related(other_exp);
 			}
 		}

--- ip_nat_standalone.c.prepatch        Sun Mar 16 01:41:45 2003
+++ ip_nat_standalone.c Thu Apr  3 19:52:09 2003
@@ -121,8 +121,13 @@
 			if (ct->master
 			    && master_ct(ct)->nat.info.helper
 			    && master_ct(ct)->nat.info.helper->expect) {
-				ret = call_expect(master_ct(ct), pskb, 
+				if(master_ct(ct)->nat.info.num_manips) {
+					ret = call_expect(master_ct(ct), pskb, 
 						hooknum, ct, info);
+				} else {
+					WRITE_UNLOCK(&ip_nat_lock);
+					return NF_ACCEPT;
+				}
 			} else {
 #ifdef CONFIG_IP_NF_NAT_LOCAL
 				/* LOCAL_IN hook doesn't have a chain and thus
