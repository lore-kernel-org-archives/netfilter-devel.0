From: "juergen baumann" <jb@moenia.de>
Subject: design-feature of nat?
Date: Fri, 1 Nov 2002 23:52:45 +0100 (MET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200211012254.ERB510IOAA@gate.tbc.sub.de>
Reply-To: jb@is-kassel.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


possible design-problem within snat.

connecting with certain source-port to any destination.
normal stop of this connection.

establishing a snat-rule which replaces the address used by the connection before.

conencting again with same source-port to same destination.

neither the established snat-rule will be used, nor any further packet-counter will be increased.

problem will not occure, if the corresponding conntrack-entry is deleted before.

to fix this problem I've patched ip_nat_rule.c

the patch is rather a quick hack than a distributable patch, cause the comparisons taken, aren't done
with enough precision to prevent stopping established connections, not touched by the changed rules.
but it helps for now for our certain local problem and maybe is a possible start for a real solution.

the patch itself:
=====================================================================================================
--- net/ipv4/netfilter/ip_nat_rule.c.dist	Sat Aug  3 02:39:46 2002
+++ net/ipv4/netfilter/ip_nat_rule.c	Fri Nov  1 22:19:46 2002
@@ -155,6 +155,22 @@ static unsigned int ipt_dnat_target(stru
 	return ip_nat_setup_info(ct, targinfo, hooknum);
 }
 
+static int ipt_nat_cmpiptip(const struct ip_conntrack *i, void *iptip)
+{
+	struct ipt_ip *ip = iptip;
+	u_int32_t sip, dip;
+
+	sip = i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	dip = i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+
+	if (((sip & ip->smsk.s_addr) == ip->src.s_addr) && ((dip & ip->dmsk.s_addr) == ip->dst.s_addr)) {
+		DEBUGP("SNAT: ctentry from %u.%u.%u.%u to %u.%u.%u.%u matches rule SRC: %u.%u.%u.%u/%u.%u.%u.%u DST: %u.%u.%u.%u/%u.%u.%u.%u\n",
+			NIPQUAD(sip), NIPQUAD(dip), NIPQUAD(ip->src.s_addr), NIPQUAD(ip->smsk.s_addr), NIPQUAD(ip->dst.s_addr), NIPQUAD(ip->dmsk.s_addr));
+		return 1;
+	}
+	return 0;
+}
+
 static int ipt_snat_checkentry(const char *tablename,
 			       const struct ipt_entry *e,
 			       void *targinfo,
@@ -187,9 +203,51 @@ static int ipt_snat_checkentry(const cha
 		DEBUGP("SNAT: hook mask 0x%x bad\n", hook_mask);
 		return 0;
 	}
+	if (e)
+		ip_ct_selective_cleanup(ipt_nat_cmpiptip, &(e->ip));
 	return 1;
 }
 
+static int ipt_snat_cmptinfo(const struct ip_conntrack *i, void *targetinfo)
+{
+	struct ip_nat_multi_range *mr = targetinfo;	/* validity already checked in ipt_snat_destroyentry() */
+	u_int32_t ctip, minip, maxip;
+	int n;
+
+	ctip = ntohl(i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip);
+
+	for (n = 0; n < mr->rangesize; n++) {
+		minip = ntohl(mr->range[n].min_ip);
+		maxip = ntohl(mr->range[n].max_ip);
+		if ((ctip >= minip) && (ctip <= maxip)) {
+			DEBUGP("SNAT: %u.%u.%u.%u is within range[%d] %u.%u.%u.%u - %u.%u.%u.%u \n",
+				HIPQUAD(ctip), n, HIPQUAD(minip), HIPQUAD(maxip));
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static void ipt_snat_destroyentry(void *targetinfo, unsigned int targetinfosize)
+{
+	struct ip_nat_multi_range *mr = targetinfo;
+
+	/* Must be a valid range */
+	if (targetinfosize < sizeof(struct ip_nat_multi_range)) {
+		DEBUGP("SNAT: (destroy) Target size %u too small\n", targetinfosize);
+		return;
+	}
+
+	if (targetinfosize != IPT_ALIGN((sizeof(struct ip_nat_multi_range)
+				       + (sizeof(struct ip_nat_range)
+					  * (mr->rangesize - 1))))) {
+		DEBUGP("SNAT: (destroy) Target size %u wrong for %u ranges\n",
+		       targetinfosize, mr->rangesize);
+		return;
+	}
+	ip_ct_selective_cleanup(ipt_snat_cmptinfo, targetinfo);
+}
+
 static int ipt_dnat_checkentry(const char *tablename,
 			       const struct ipt_entry *e,
 			       void *targinfo,
@@ -230,9 +288,51 @@ static int ipt_dnat_checkentry(const cha
 	}
 #endif
 
+	if (e)
+		ip_ct_selective_cleanup(ipt_nat_cmpiptip, &(e->ip));
 	return 1;
 }
 
+static int ipt_dnat_cmptinfo(const struct ip_conntrack *i, void *targetinfo)
+{
+	struct ip_nat_multi_range *mr = targetinfo;	/* validity already checked in ipt_snat_destroyentry() */
+	u_int32_t ctip, minip, maxip;
+	int n;
+
+	ctip = ntohl(i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip);
+
+	for (n = 0; n < mr->rangesize; n++) {
+		minip = ntohl(mr->range[n].min_ip);
+		maxip = ntohl(mr->range[n].max_ip);
+		if ((ctip >= minip) && (ctip <= maxip)) {
+			DEBUGP("DNAT: %u.%u.%u.%u is within range[%d] %u.%u.%u.%u - %u.%u.%u.%u \n",
+				HIPQUAD(ctip), n, HIPQUAD(minip), HIPQUAD(maxip));
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static void ipt_dnat_destroyentry(void *targetinfo, unsigned int targetinfosize)
+{
+	struct ip_nat_multi_range *mr = targetinfo;
+
+	/* Must be a valid range */
+	if (targetinfosize < sizeof(struct ip_nat_multi_range)) {
+		DEBUGP("DNAT: (destroy) Target size %u too small\n", targetinfosize);
+		return;
+	}
+
+	if (targetinfosize != IPT_ALIGN((sizeof(struct ip_nat_multi_range)
+				       + (sizeof(struct ip_nat_range)
+					  * (mr->rangesize - 1))))) {
+		DEBUGP("DNAT: (destroy) Target size %u wrong for %u ranges\n",
+		       targetinfosize, mr->rangesize);
+		return;
+	}
+	ip_ct_selective_cleanup(ipt_dnat_cmptinfo, targetinfo);
+}
+
 static inline unsigned int
 alloc_null_binding(struct ip_conntrack *conntrack,
 		   struct ip_nat_info *info,
@@ -314,9 +417,9 @@ void ip_nat_expect_unregister(struct ip_
 }
 
 static struct ipt_target ipt_snat_reg
-= { { NULL, NULL }, "SNAT", ipt_snat_target, ipt_snat_checkentry, NULL };
+= { { NULL, NULL }, "SNAT", ipt_snat_target, ipt_snat_checkentry, ipt_snat_destroyentry, NULL };
 static struct ipt_target ipt_dnat_reg
-= { { NULL, NULL }, "DNAT", ipt_dnat_target, ipt_dnat_checkentry, NULL };
+= { { NULL, NULL }, "DNAT", ipt_dnat_target, ipt_dnat_checkentry, ipt_dnat_destroyentry, NULL };
 
 int __init ip_nat_rule_init(void)
 {
=====================================================================================================

maybe you can fix a small bug in iptables-user, too:

in iptables.c (iptables6.c)

the long-option "rename-chain" should have a second arg of '1', not '2', or the option will fail.
short option 'E' does work normally.

greetings

jb

-- 

26.hesekiel/31/10.txt (19396)
Darum - so spricht Gott der HERR: Weil er so hoch geworden war, daﬂ sein Wipfel bis in die Wolken ragte, und weil sein Herz sich erhob, da er so hoch geworden war,
