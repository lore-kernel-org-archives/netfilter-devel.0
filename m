From: Balazs Scheidler <bazsi@balabit.hu>
Subject: possible bug in ip_nat_fn()
Date: Sun, 10 Aug 2003 16:14:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030810141425.GA4906@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PEIAKu/WMn1b1Hv9"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

Hi,

The last bug I've found in my TPROXY patches might apply to core NAT code as
well, possibly causing either an Oops or an infinite loop in the network
softirq.

The relevant code is in the function ip_nat_fn(), more precisely the
IP_CT_NEW case, where three possible branches are used to decide how the
current session is to be NATed:

1) the current connection is an expected connection, the NAT helper expect
   function is called, which possibly calls ip_nat_setup_info() 

2) the current connection is destined to LOCAL_IN (only when
   CONFIG_IP_NF_NAT_LOCAL is defined), no ip_nat_setup_info() is called this
   time

3) the nat table is looked up, and if nothing is found a null-mapping is applied

The problem occurs if no ip_nat_setup_info() is called (or it fails) _AND_
ret == NF_ACCEPT. This is always the case in 2), when 'ret' is simply set to
NF_ACCEPT, and might possibly also happen if the NAT helper does not check
the return value of ip_nat_setup_info(), or it simply does not set up a NAT
mapping for the current connection.

In the case outlined above, ct->nat.info.initialized will not be set, but
the NAT hash entry will be added. As ct->nat.info.initialized is used to
check whether a connection is hashed, this might result in conntracks added
to the NAT hash multiple times (when the current SYN is retransmitted for
instance). 

In my experience this usually results in an infinite loop in
find_appropriate_src() where this list is traversed, practically rendering
the box completely unresponsive.

I think the solution for this problem would be a separate flag in
ip_nat_info->initialized which tells whether this conntrack has already been
hashed, or to move the hash update code to ip_nat_setup_info. I've attached
a patch which does the latter, and makes the place_in_hashes and
replace_in_hashes functions static.

Independent of this, it might also make sense to move the manip check to the
ip_nat_setup_info() as well. (To add a new NAT manip if and only if
(!(info->initialized & (1 << HOOK2MANIP(hooknum)))) is 0). This would
prevent the ip_nat_info->manips array to overflow. If this is agreed upon,
I'm willing to provide patches.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="linux-2.4.21-nathashfix.diff"

diff -urN --exclude-from=kernel-exclude linux-2.4.21/net/ipv4/netfilter/ip_fw_compat_masq.c linux-2.4.21-natfix/net/ipv4/netfilter/ip_fw_compat_masq.c
--- linux-2.4.21/net/ipv4/netfilter/ip_fw_compat_masq.c	Fri Nov 29 00:53:15 2002
+++ linux-2.4.21-natfix/net/ipv4/netfilter/ip_fw_compat_masq.c	Sun Aug 10 16:03:22 2003
@@ -92,7 +92,6 @@
 			return ret;
 		}
 
-		place_in_hashes(ct, info);
 		info->initialized = 1;
 	} else
 		DEBUGP("Masquerading already done on this conn.\n");
diff -urN --exclude-from=kernel-exclude linux-2.4.21/net/ipv4/netfilter/ip_nat_core.c linux-2.4.21-natfix/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.4.21/net/ipv4/netfilter/ip_nat_core.c	Fri Jun 13 16:51:39 2003
+++ linux-2.4.21-natfix/net/ipv4/netfilter/ip_nat_core.c	Sun Aug 10 16:04:01 2003
@@ -636,13 +636,18 @@
 		info->helper = LIST_FIND(&helpers, helper_cmp, struct ip_nat_helper *,
 					 &reply);
 
+	if (info->initialized)
+		replace_in_hashes(conntrack, info);
+	else
+		place_in_hashes(conntrack, info);
 	/* It's done. */
 	info->initialized |= (1 << HOOK2MANIP(hooknum));
 	return NF_ACCEPT;
 }
 
-void replace_in_hashes(struct ip_conntrack *conntrack,
-		       struct ip_nat_info *info)
+static void 
+replace_in_hashes(struct ip_conntrack *conntrack,
+		  struct ip_nat_info *info)
 {
 	/* Source has changed, so replace in hashes. */
 	unsigned int srchash
@@ -670,8 +675,9 @@
 	list_prepend(&byipsproto[ipsprotohash], &info->byipsproto);
 }
 
-void place_in_hashes(struct ip_conntrack *conntrack,
-		     struct ip_nat_info *info)
+static void 
+place_in_hashes(struct ip_conntrack *conntrack,
+		struct ip_nat_info *info)
 {
 	unsigned int srchash
 		= hash_by_src(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
diff -urN --exclude-from=kernel-exclude linux-2.4.21/net/ipv4/netfilter/ip_nat_standalone.c linux-2.4.21-natfix/net/ipv4/netfilter/ip_nat_standalone.c
--- linux-2.4.21/net/ipv4/netfilter/ip_nat_standalone.c	Fri Jun 13 16:51:39 2003
+++ linux-2.4.21-natfix/net/ipv4/netfilter/ip_nat_standalone.c	Sun Aug 10 16:01:50 2003
@@ -115,7 +115,6 @@
 		/* Seen it before?  This can happen for loopback, retrans,
 		   or local packets.. */
 		if (!(info->initialized & (1 << maniptype))) {
-			int in_hashes = info->initialized;
 			unsigned int ret;
 
 			if (ct->master
@@ -139,12 +138,6 @@
 				return ret;
 			}
 
-			if (in_hashes) {
-				IP_NF_ASSERT(info->bysource.conntrack);
-				replace_in_hashes(ct, info);
-			} else {
-				place_in_hashes(ct, info);
-			}
 		} else
 			DEBUGP("Already setup manip %s for ct %p\n",
 			       maniptype == IP_NAT_MANIP_SRC ? "SRC" : "DST",

--PEIAKu/WMn1b1Hv9--
