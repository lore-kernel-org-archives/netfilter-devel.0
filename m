From: Jeff Hall <hall@vdata.com>
Subject: Re: PPTP connection tracking and NAT patches
Date: Tue, 8 Apr 2003 06:31:16 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.03.10304080611330.11290-100000@shemp.vdata.com>
References: <20030326154821.GC21953@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030326154821.GC21953@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald:

In testing these patches I had problems with unreplied connections
being created. Solving that problem let me to the two patches below.
The first corrects a housekeeping oversight. The second is to prevent
execution of a helper on an expected connection if the master connection
has no manips.

In response to a message from Phillip Craig about NAT'ing both local and
remote PPTP sessions you suggested a postrouting rule to match both
local and remote sessions. I was going to try testing that scenario but
found that while I could create a rule to match both types of connections
the code in the PPTP NAT helper functions would not get called unless the
NAT rule actually modified the packet (i.e. num_manips !0). I thought the
initialized field might provide an answer but I believe that initialized
will be non-zero when a connection doesn't match a rule but the chain 
policy is accept. If all this is true, then this might have wider impli-
cations to protocols other than PPTP and so I thought it worth mentioning.

Anyways, with the two patches below I was able to successfully make 
PPTP connections through and to a machine.

Jeff Hall


On Wed, 26 Mar 2003, Harald Welte wrote:

> On Thu, Mar 20, 2003 at 03:32:46AM -0500, Jeff Hall wrote:
> > +			if ( other_exp != exp )
> 
> I've changed this into 
> 			if (other_exp != exp && other_exp->seq == exp->seq)
> 
> to make sure we really delete only the corresponding expectation in the
> other direction.  At least theoretically we can have more than one call
> in a single session...
> 
> Can you please try (+test) ip_conntrack_pptp.c version 1.8 from
> netfilter-extensions CVS in combination with the
> 'pending/25_natcore_nohelper.patch' of patch-o-matic?
> 
> Thanks.
> 
> -- 
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
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
