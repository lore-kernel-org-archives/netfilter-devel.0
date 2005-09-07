From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.4 1/1]: Handle NAT module load race
Date: Wed, 07 Sep 2005 03:06:04 +0200
Message-ID: <431E3CFC.7060303@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060901090105050907080800"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------060901090105050907080800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is the backport of the NAT race fix which prevents
a crash with CONFIG_NETFILTER_DEBUG when conntracks
are established before the nat module is loaded.

--------------060901090105050907080800
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: Handle NAT module load race

When the NAT module is loaded when connections are already confirmed
it must not change their tuples anymore. This is especially important
with CONFIG_NETFILTER_DEBUG, the netfilter listhelp functions will
refuse to remove an entry from a list when it can not be found on
the list, so when a changed tuple hashes to a new bucket the entry
is kept in the list until and after the conntrack is freed.

Allocate the exact conntrack tuple for NAT for already confirmed
connections or drop them if that fails.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6fa066570cf415817cd317d3f968b769a3b8cce6
tree a7ce08e43fc79d31c292a300128235565dec18f9
parent 7cbdf66daf8a9b9aa9b1e2bc2c1404511414c5c6
author Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 23:18:14 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 23:18:14 +0200

 include/linux/netfilter_ipv4/ip_nat_rule.h |    5 +++++
 net/ipv4/netfilter/ip_nat_rule.c           |   21 +++++++++++++++++++++
 net/ipv4/netfilter/ip_nat_standalone.c     |    8 ++++++--
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_nat_rule.h b/include/linux/netfilter_ipv4/ip_nat_rule.h
--- a/include/linux/netfilter_ipv4/ip_nat_rule.h
+++ b/include/linux/netfilter_ipv4/ip_nat_rule.h
@@ -19,5 +19,10 @@ extern unsigned int
 alloc_null_binding(struct ip_conntrack *conntrack,
 		   struct ip_nat_info *info,
 		   unsigned int hooknum);
+
+extern unsigned int
+alloc_null_binding_confirmed(struct ip_conntrack *conntrack,
+			     struct ip_nat_info *info,
+			     unsigned int hooknum);
 #endif
 #endif /* _IP_NAT_RULE_H */
diff --git a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
--- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -241,6 +241,27 @@ alloc_null_binding(struct ip_conntrack *
 	return ip_nat_setup_info(conntrack, &mr, hooknum);
 }
 
+unsigned int
+alloc_null_binding_confirmed(struct ip_conntrack *conntrack,
+                             struct ip_nat_info *info,
+                             unsigned int hooknum)
+{
+	u_int32_t ip
+		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
+		   ? conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip
+		   : conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip);
+	u_int16_t all
+		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
+		   ? conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.all
+		   : conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.all);
+	struct ip_nat_multi_range mr
+		= { 1, { { IP_NAT_RANGE_MAP_IPS, ip, ip, { all }, { all } } } };
+
+	DEBUGP("Allocating NULL binding for confirmed %p (%u.%u.%u.%u)\n",
+	       conntrack, NIPQUAD(ip));
+	return ip_nat_setup_info(conntrack, &mr, hooknum);
+}
+
 int ip_nat_rule_find(struct sk_buff **pskb,
 		     unsigned int hooknum,
 		     const struct net_device *in,
diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -123,8 +123,12 @@ ip_nat_fn(unsigned int hooknum,
 				ret = call_expect(master_ct(ct), pskb, 
 						  hooknum, ct, info);
 			} else {
-				/* LOCAL_IN hook doesn't have a chain!  */
-				if (hooknum == NF_IP_LOCAL_IN)
+				if (unlikely(is_confirmed(ct)))
+					/* NAT module was loaded late */
+					ret = alloc_null_binding_confirmed(ct, info,
+		        		                                   hooknum);
+				else if (hooknum == NF_IP_LOCAL_IN)
+					/* LOCAL_IN hook doesn't have a chain */
 					ret = alloc_null_binding(ct, info,
 								 hooknum);
 				else

--------------060901090105050907080800--
