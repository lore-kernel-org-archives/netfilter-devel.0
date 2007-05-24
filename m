From: Philip Craig <philipc@snapgear.com>
Subject: [RFC][PATCH] optimise iptables interface matching
Date: Thu, 24 May 2007 15:55:23 +1000
Message-ID: <465528CB.4020108@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020801080003080603000306"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------020801080003080603000306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Optimise iptables for rules that specify 0 or 1 interface matches,
which is the more common case (at least for my rulesets).

Below are the oprofile cpu cycle percentages from a 30 second
period of an iperf throughput test on a 667MHz IXP465 with
Realtek 8169 network interfaces.

rules	iface	% cpu before	% cpu after	saving (adjusted)
0		 7.7662		 4.9191		 2.8471
10 	0	15.9798		 9.8453		 3.2874
20 	0	23.6914		14.2051		 6.6392
10	1	14.6068		11.7332		 0.0265
20	1	21.1646		17.1905		 1.1270
10	2	14.6497		13.0306		-1.2280
20	2	21.1647		20.3536		-2.0360

- saving with 0 rules is due to policies
- adjusted saving means with the 0 rules saving subtracted
- iface 0 means "iptables -I FORWARD"
- iface 1 means "iptables -I FORWARD -i eth0"
- iface 2 means "iptables -I FORWARD -i eth0 -o eth1"

If you think this is an acceptable approach then I can update
the patch for IPv6.  Any suggestions for other parts of
netfilter/iptables to look at optimising are also welcome.

Signed-off-by: Philip Craig <philipc@snapgear.com>

--------------020801080003080603000306
Content-Type: text/plain;
 name="iptables-iface-optim.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-iface-optim.patch"

--- linux-2.6.x/include/linux/netfilter_ipv4/ip_tables.h	26 Apr 2007 13:13:50 -0000	1.2
+++ linux-2.6.x/include/linux/netfilter_ipv4/ip_tables.h	24 May 2007 04:46:59 -0000
@@ -63,6 +63,10 @@ struct ipt_ip {
 #define IPT_F_GOTO		0x02	/* Set if jump is a goto */
 #define IPT_F_MASK		0x03	/* All possible flag bits mask. */
 
+/* Internal values used for optimisation */
+#define IPT_F_VIA_IN		0x10	/* Set if rule has iif match */
+#define IPT_F_VIA_OUT		0x20	/* Set if rule has oif match */
+
 /* Values for "inv" field in struct ipt_ip. */
 #define IPT_INV_VIA_IN		0x01	/* Invert the sense of IN IFACE. */
 #define IPT_INV_VIA_OUT		0x02	/* Invert the sense of OUT IFACE */
--- linux-2.6.x/net/ipv4/netfilter/ip_tables.c	26 Apr 2007 11:17:49 -0000	1.1.1.29
+++ linux-2.6.x/net/ipv4/netfilter/ip_tables.c	24 May 2007 04:46:59 -0000
@@ -112,30 +112,34 @@ ip_packet_match(const struct iphdr *ip,
 	}
 
 	/* Look for ifname matches; this should unroll nicely. */
-	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
-		ret |= (((const unsigned long *)indev)[i]
-			^ ((const unsigned long *)ipinfo->iniface)[i])
-			& ((const unsigned long *)ipinfo->iniface_mask)[i];
-	}
+	if (ipinfo->flags & IPT_F_VIA_IN) {
+		for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
+			ret |= (((const unsigned long *)indev)[i]
+				^ ((const unsigned long *)ipinfo->iniface)[i])
+				& ((const unsigned long *)ipinfo->iniface_mask)[i];
+		}
 
-	if (FWINV(ret != 0, IPT_INV_VIA_IN)) {
-		dprintf("VIA in mismatch (%s vs %s).%s\n",
-			indev, ipinfo->iniface,
-			ipinfo->invflags&IPT_INV_VIA_IN ?" (INV)":"");
-		return 0;
+		if (FWINV(ret != 0, IPT_INV_VIA_IN)) {
+			dprintf("VIA in mismatch (%s vs %s).%s\n",
+				indev, ipinfo->iniface,
+				ipinfo->invflags&IPT_INV_VIA_IN ?" (INV)":"");
+			return 0;
+		}
 	}
 
-	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
-		ret |= (((const unsigned long *)outdev)[i]
-			^ ((const unsigned long *)ipinfo->outiface)[i])
-			& ((const unsigned long *)ipinfo->outiface_mask)[i];
-	}
+	if (ipinfo->flags & IPT_F_VIA_OUT) {
+		for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
+			ret |= (((const unsigned long *)outdev)[i]
+				^ ((const unsigned long *)ipinfo->outiface)[i])
+				& ((const unsigned long *)ipinfo->outiface_mask)[i];
+		}
 
-	if (FWINV(ret != 0, IPT_INV_VIA_OUT)) {
-		dprintf("VIA out mismatch (%s vs %s).%s\n",
-			outdev, ipinfo->outiface,
-			ipinfo->invflags&IPT_INV_VIA_OUT ?" (INV)":"");
-		return 0;
+		if (FWINV(ret != 0, IPT_INV_VIA_OUT)) {
+			dprintf("VIA out mismatch (%s vs %s).%s\n",
+				outdev, ipinfo->outiface,
+				ipinfo->invflags&IPT_INV_VIA_OUT ?" (INV)":"");
+			return 0;
+		}
 	}
 
 	/* Check specific protocol */
@@ -159,13 +163,21 @@ ip_packet_match(const struct iphdr *ip,
 }
 
 static inline int
-ip_checkentry(const struct ipt_ip *ip)
+ip_checkentry(struct ipt_ip *ip)
 {
+	size_t i;
+
 	if (ip->flags & ~IPT_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 ip->flags & ~IPT_F_MASK);
 		return 0;
 	}
+	for (i = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
+		if (ip->iniface_mask[i])
+			ip->flags |= IPT_F_VIA_IN;
+		if (ip->outiface_mask[i])
+			ip->flags |= IPT_F_VIA_OUT;
+	}
 	if (ip->invflags & ~IPT_INV_MASK) {
 		duprintf("Unknown invflag bits set: %08X\n",
 			 ip->invflags & ~IPT_INV_MASK);
@@ -869,8 +881,9 @@ copy_entries_to_user(unsigned int total_
 	}
 
 	/* FIXME: use iterator macros --RR */
-	/* ... then go back and fix counters and names */
+	/* ... then go back and fix counters, flags, and names */
 	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
+		u_int8_t flags;
 		unsigned int i;
 		struct ipt_entry_match *m;
 		struct ipt_entry_target *t;
@@ -884,6 +897,15 @@ copy_entries_to_user(unsigned int total_
 			goto free_counters;
 		}
 
+		flags = e->ip.flags & IPT_F_MASK;
+		if (copy_to_user(userptr + off
+				 + offsetof(struct ipt_entry, ip.flags),
+				 &flags,
+				 sizeof(flags)) != 0) {
+			ret = -EFAULT;
+			goto free_counters;
+		}
+
 		for (i = sizeof(struct ipt_entry);
 		     i < e->target_offset;
 		     i += m->u.match_size) {

--------------020801080003080603000306--
