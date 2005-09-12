From: Cory Visi <merlin@gentoo.org>
Subject: patchlets patch submission
Date: Mon, 12 Sep 2005 16:29:38 +0000
Message-ID: <20050912162938.GB15843@toucan.gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I did some work on fixing the conntrack pom addons for the lockhelp.h 
patch (2.6.13 support essentially). I think I got everything setup except 
for 2 files.

Attached is all my work in patch form against a full kernel source. I have 
a feeling you'd prefer I sent this in some other format or in some other 
structure of a diff. This is my first time contributing so just let me 
know how you'd prefer this in the future.

What's left is:
- rtsp (part of rsh)
- pptp (only the conntrack part)
- nat-hook symbols missing in quake3 and talk conntrack

I made some attempt at both of these, but I'm not sure how well I did. You 
should obviously check my work.

I'm willing to do more, so just let me know what I can do and how I did so 
far.

Thanks,
Cory

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pom-lockhelp-fixes.patch"

diff -Naur linux-2.6.13/include/linux/netfilter_ipv4/ip_conntrack_pptp.h linux-2.6.13-pomfix/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
--- linux-2.6.13/include/linux/netfilter_ipv4/ip_conntrack_pptp.h	2005-09-09 01:47:19.694178433 -0400
+++ linux-2.6.13-pomfix/include/linux/netfilter_ipv4/ip_conntrack_pptp.h	2005-09-07 00:42:31.849419352 -0400
@@ -50,8 +50,7 @@
 #ifdef __KERNEL__
 
 
-#include <linux/netfilter_ipv4/lockhelp.h>
-DECLARE_LOCK_EXTERN(ip_pptp_lock);
+extern spinlock_t ip_pptp_lock;
 
 #define IP_CONNTR_PPTP		PPTP_CONTROL_PORT
 
diff -Naur linux-2.6.13/include/linux/netfilter_ipv4/ip_conntrack_talk.h linux-2.6.13-pomfix/include/linux/netfilter_ipv4/ip_conntrack_talk.h
--- linux-2.6.13/include/linux/netfilter_ipv4/ip_conntrack_talk.h	2005-09-09 01:47:19.698178693 -0400
+++ linux-2.6.13-pomfix/include/linux/netfilter_ipv4/ip_conntrack_talk.h	2005-09-07 00:42:23.584879179 -0400
@@ -4,10 +4,9 @@
 
 #ifdef __KERNEL__
 #include <linux/in.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 /* Protects talk part of conntracks */
-DECLARE_LOCK_EXTERN(ip_talk_lock);
+extern spinlock_t ip_talk_lock;
 #endif
 
 
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_h323.c
--- linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323.c	2005-09-09 01:47:19.736181154 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_h323.c	2005-09-07 01:11:17.372396264 -0400
@@ -117,7 +117,7 @@
 				NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
 				NIPQUAD((*pskb)->nh.iph->saddr), ntohs(data_port));
 
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL) {
 				ret = NF_ACCEPT;
 				goto out;
@@ -134,18 +134,17 @@
 				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 
 			exp->expectfn = NULL;
-			exp->master = ct;
 
 			if (ip_nat_h245_hook != NULL) {
 				ret = ip_nat_h245_hook(pskb, ctinfo, i,
 						       exp);
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
-				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
+				if (ip_conntrack_expect_related(exp) != 0)
 					ret = NF_DROP;
-				} else
+				else
 					ret = NF_ACCEPT;
+				ip_conntrack_expect_put(exp);
 			}
 
 			break;
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h225.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_h323_h225.c
--- linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-09-09 01:47:19.738181284 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-09-07 01:29:43.651869727 -0400
@@ -108,7 +108,7 @@
 		}
 		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL)
 				return NF_ACCEPT;
 
@@ -123,7 +123,6 @@
 					  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 
 			exp->expectfn = ip_conntrack_h245_expect;
-			exp->master = ct;
 
 			/* call NAT hook and register expectation */
 			if (ip_nat_h225_hook != NULL) {
@@ -131,12 +130,13 @@
 							exp);
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
-				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					return NF_DROP;
-				} else {
-					return NF_ACCEPT;
-				}
+				if (ip_conntrack_expect_related(exp) != 0)
+					ret = NF_DROP;
+				else
+					ret = NF_ACCEPT;
+
+				ip_conntrack_expect_put(exp);
+				return ret;
 			}
 		}
 	}
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h245.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_h323_h245.c
--- linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h245.c	2005-09-09 01:47:19.740181413 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_h323_h245.c	2005-09-07 13:53:34.405584425 -0400
@@ -296,7 +296,7 @@
 			       NIPQUAD(ip), ntohs(port));
 		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL)
 				return NF_ACCEPT;
 
@@ -310,8 +310,6 @@
 					{ { 0xFFFFFFFF, { 0 } },
 					  { 0xFFFFFFFF, { .udp = { 0xFFFF } }, 0xFF }});
 
-			exp->master = ct;
-
 			/* call NAT hook and register expectation */
 			if (ip_nat_h245_hook != NULL) {
 				return ip_nat_h245_hook(pskb, ctinfo, i,
@@ -319,11 +317,13 @@
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
 				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					return NF_DROP;
+					ret = NF_DROP;
 				} else {
-					return NF_ACCEPT;
+					ret = NF_ACCEPT;
 				}
+
+				ip_conntrack_expect_put(exp);
+				return ret;
 			}
 		}
 	}
@@ -348,7 +348,7 @@
 			       NIPQUAD(ip), ntohs(port));
 		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL)
 				return NF_ACCEPT;
 
@@ -371,11 +371,13 @@
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
 				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					return NF_DROP;
+					ret = NF_DROP;
 				} else {
-					return NF_ACCEPT;
+					ret = NF_ACCEPT;
 				}
+
+				ip_conntrack_expect_put(exp);
+				return ret;
 			}
 		}
 	}
@@ -616,7 +618,7 @@
 		       ret, i, ip, port);
 		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL)
 				return NF_ACCEPT;
 
@@ -640,11 +642,13 @@
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
 				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					return NF_DROP;
+					ret = NF_DROP;
 				} else {
-					return NF_ACCEPT;
+					ret = NF_ACCEPT;
 				}
+
+				ip_conntrack_expect_put(exp);
+				return ret;
 			}
 		}
 	}
@@ -663,7 +667,7 @@
 		       ret, i, ip, port);
 		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL)
 				return NF_ACCEPT;
 
@@ -687,11 +691,13 @@
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
 				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					return NF_DROP;
+					ret = NF_DROP;
 				} else {
-					return NF_ACCEPT;
+					ret = NF_ACCEPT;
 				}
+
+				ip_conntrack_expect_put(exp);
+				return ret;
 			}
 		}
 	}
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_conntrack_mms.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_mms.c
--- linux-2.6.13/net/ipv4/netfilter/ip_conntrack_mms.c	2005-09-09 01:47:19.741181478 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_mms.c	2005-09-07 09:08:53.866045070 -0400
@@ -255,7 +255,7 @@
 
 		DEBUGP("ip_conntrack_mms: tcph->seq = %u\n", tcph->seq);
 
-		exp = ip_conntrack_expect_alloc();
+		exp = ip_conntrack_expect_alloc(ct);
 		if (!exp) {
 			ret = NF_DROP;
 			goto out;
@@ -280,12 +280,11 @@
 		             { { 0xFFFFFFFF, { 0 } },
 		               { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 		exp->expectfn = NULL;
-		exp->master = ct;
 
 		if (ip_nat_mms_hook)
 			ret = ip_nat_mms_hook(pskb, ctinfo, exp_mms_info, exp);
 		else if (ip_conntrack_expect_related(exp) != 0) {
-			ip_conntrack_expect_free(exp);
+			ip_conntrack_expect_put(exp);
 			ret = NF_DROP;
 		}
 		goto out;
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_conntrack_pptp.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_pptp.c
--- linux-2.6.13/net/ipv4/netfilter/ip_conntrack_pptp.c	2005-09-09 01:47:19.743181608 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_pptp.c	2005-09-07 14:52:21.455032059 -0400
@@ -51,7 +51,6 @@
 #include <net/checksum.h>
 #include <net/tcp.h>
 
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
@@ -64,7 +63,7 @@
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter connection tracking helper module for PPTP");
 
-DECLARE_LOCK(ip_pptp_lock);
+DEFINE_SPINLOCK(ip_pptp_lock);
 
 int
 (*ip_nat_pptp_hook_outbound)(struct sk_buff **pskb,
@@ -234,7 +233,7 @@
 
 	exp_reply = ip_conntrack_expect_alloc();
 	if (exp_reply == NULL) {
-		ip_conntrack_expect_free(exp_orig);
+		ip_conntrack_expect_put(exp_orig);
 		return 1;
 	}
 
@@ -247,7 +246,6 @@
 	exp_orig->mask.dst.ip = 0xffffffff;
 	exp_orig->mask.dst.protonum = 0xff;
 		
-	exp_orig->master = master;
 	exp_orig->expectfn = pptp_expectfn;
 
 	exp_orig->dir = IP_CT_DIR_ORIGINAL;
@@ -266,8 +264,8 @@
 		DUMP_TUPLE(&exp_orig->tuple);
 
 		if (ip_conntrack_expect_related(exp_orig) != 0) {
-			ip_conntrack_expect_free(exp_orig);
-			ip_conntrack_expect_free(exp_reply);
+			ip_conntrack_expect_put(exp_orig);
+			ip_conntrack_expect_put(exp_reply);
 			DEBUGP("cannot expect_related()\n");
 			return 1;
 		}
@@ -277,7 +275,7 @@
 
 		if (ip_conntrack_expect_related(exp_reply) != 0) {
 			ip_conntrack_unexpect_related(exp_orig);
-			ip_conntrack_expect_free(exp_reply);
+			ip_conntrack_expect_put(exp_reply);
 			DEBUGP("cannot expect_related()\n");
 			return 1;
 		}
@@ -711,7 +709,7 @@
 	oldsstate = info->sstate;
 	oldcstate = info->cstate;
 
-	LOCK_BH(&ip_pptp_lock);
+	spin_lock_bh(&ip_pptp_lock);
 
 	nexthdr_off += sizeof(_pptph);
 	/* FIXME: We just blindly assume that the control connection is always
@@ -726,7 +724,7 @@
 				       ctinfo);
 	DEBUGP("sstate: %d->%d, cstate: %d->%d\n",
 		oldsstate, info->sstate, oldcstate, info->cstate);
-	UNLOCK_BH(&ip_pptp_lock);
+	spin_unlock_bh(&ip_pptp_lock);
 
 	return ret;
 }
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_conntrack_proto_gre.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_proto_gre.c
--- linux-2.6.13/net/ipv4/netfilter/ip_conntrack_proto_gre.c	2005-09-09 01:47:19.745181737 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_proto_gre.c	2005-09-09 01:22:41.581421962 -0400
@@ -32,11 +32,12 @@
 #include <linux/in.h>
 #include <linux/list.h>
 
-#include <linux/netfilter_ipv4/lockhelp.h>
+DEFINE_RWLOCK(ip_ct_gre_lock);
 
-DECLARE_RWLOCK(ip_ct_gre_lock);
-#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_ct_gre_lock)
-#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_ct_gre_lock)
+/* ip_conntrack_lock protects the main hash table, protocol/helper/expected
+   registrations, conntrack timers*/
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
 
 #include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
@@ -82,12 +83,12 @@
 	struct ip_ct_gre_keymap *km;
 	u_int32_t key = 0;
 
-	READ_LOCK(&ip_ct_gre_lock);
+	read_lock_bh(&ip_ct_gre_lock);
 	km = LIST_FIND(&gre_keymap_list, gre_key_cmpfn,
 			struct ip_ct_gre_keymap *, t);
 	if (km)
 		key = km->tuple.src.u.gre.key;
-	READ_UNLOCK(&ip_ct_gre_lock);
+	read_unlock_bh(&ip_ct_gre_lock);
 	
 	DEBUGP("lookup src key 0x%x up key for ", key);
 	DUMP_TUPLE_GRE(t);
@@ -155,9 +156,9 @@
 	DEBUGP("adding new entry %p: ", km);
 	DUMP_TUPLE_GRE(&km->tuple);
 
-	WRITE_LOCK(&ip_ct_gre_lock);
+	write_lock_bh(&ip_ct_gre_lock);
 	list_append(&gre_keymap_list, km);
-	WRITE_UNLOCK(&ip_ct_gre_lock);
+	write_unlock_bh(&ip_ct_gre_lock);
 
 	return 0;
 }
@@ -172,7 +173,7 @@
 		return;
 	}
 
-	WRITE_LOCK(&ip_ct_gre_lock);
+	write_lock_bh(&ip_ct_gre_lock);
 	if (ct->help.ct_pptp_info.keymap_orig) {
 		DEBUGP("removing %p from list\n", 
 			ct->help.ct_pptp_info.keymap_orig);
@@ -187,7 +188,7 @@
 		kfree(ct->help.ct_pptp_info.keymap_reply);
 		ct->help.ct_pptp_info.keymap_reply = NULL;
 	}
-	WRITE_UNLOCK(&ip_ct_gre_lock);
+	write_unlock_bh(&ip_ct_gre_lock);
 }
 
 
@@ -351,13 +352,13 @@
 	struct list_head *pos, *n;
 
 	/* delete all keymap entries */
-	WRITE_LOCK(&ip_ct_gre_lock);
+	write_lock_bh(&ip_ct_gre_lock);
 	list_for_each_safe(pos, n, &gre_keymap_list) {
 		DEBUGP("deleting keymap %p at module unload time\n", pos);
 		list_del(pos);
 		kfree(pos);
 	}
-	WRITE_UNLOCK(&ip_ct_gre_lock);
+	write_unlock_bh(&ip_ct_gre_lock);
 
 	ip_conntrack_protocol_unregister(&gre); 
 }
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_conntrack_quake3.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_quake3.c
--- linux-2.6.13/net/ipv4/netfilter/ip_conntrack_quake3.c	2005-09-09 01:47:19.746181802 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_quake3.c	2005-09-08 21:34:53.617360260 -0400
@@ -40,7 +40,7 @@
 MODULE_PARM_DESC(ports, "port numbers of Quake III master servers");
 
 static char quake3_buffer[65536];
-static DECLARE_LOCK(quake3_buffer_lock);
+static DEFINE_SPINLOCK(quake3_buffer_lock);
 
 static unsigned int (*ip_nat_quake3_hook)(struct ip_conntrack_expect *exp);
 
@@ -89,7 +89,7 @@
 	if (dataoff >= (*pskb)->len)
 		return NF_ACCEPT;
 
-	LOCK_BH(&quake3_buffer_lock);
+	spin_lock_bh(&quake3_buffer_lock);
 	qb_ptr = skb_header_pointer(*pskb, dataoff,
 				    (*pskb)->len - dataoff, quake3_buffer);
 	BUG_ON(qb_ptr == NULL);
@@ -110,7 +110,7 @@
 			       NIPQUAD(*ip), ntohs(*port));
 #endif
 
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (!exp) { 
 				ret = NF_DROP;
 				goto out;
@@ -131,7 +131,7 @@
 			if (ip_nat_quake3_hook) 
 				ret = ip_nat_quake3_hook(exp);
 			else if (ip_conntrack_expect_related(exp) != 0) {
-				ip_conntrack_expect_free(exp);
+				ip_conntrack_expect_put(exp);
 				ret = NF_DROP;
 			}
 			goto out;
@@ -139,6 +139,7 @@
 	}
 	
 out:
+	spin_unlock_bh(&quake3_buffer_lock);
 	return ret;
 }
 
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_conntrack_rsh.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_rsh.c
--- linux-2.6.13/net/ipv4/netfilter/ip_conntrack_rsh.c	2005-09-09 01:47:19.747181867 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_rsh.c	2005-09-07 13:02:10.789435579 -0400
@@ -209,7 +209,7 @@
 		return NF_ACCEPT;
 	}
 
-	exp = ip_conntrack_expect_alloc();
+	exp = ip_conntrack_expect_alloc(ct);
 	if (!exp) {
 		ret = NF_DROP;
 		goto out;
@@ -238,7 +238,7 @@
 	if (ip_nat_rsh_hook)
 		ret = ip_nat_rsh_hook(pskb, ctinfo, rb_ptr - data, exp);
 	else if (ip_conntrack_expect_related(exp) != 0) {
-		ip_conntrack_expect_free(exp);
+		ip_conntrack_expect_put(exp);
 		ret = NF_DROP;
 	}
 
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_conntrack_rtsp.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_rtsp.c
--- linux-2.6.13/net/ipv4/netfilter/ip_conntrack_rtsp.c	2005-09-09 01:47:19.749181996 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_rtsp.c	2005-09-07 16:14:55.814152103 -0400
@@ -31,7 +31,6 @@
 #include <net/checksum.h>
 #include <net/tcp.h>
 
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_rtsp.h>
 
@@ -70,7 +69,7 @@
 MODULE_PARM_DESC(setup_timeout, "timeout on for unestablished data channels");
 
 static char rtsp_buffer[65536];
-static DECLARE_LOCK(rtsp_buffer_lock);
+static DEFINE_SPINLOCK(rtsp_buffer_lock);
 
 unsigned int (*ip_nat_rtsp_hook)(struct sk_buff **pskb,
 				 enum ip_conntrack_info ctinfo,
@@ -338,14 +337,13 @@
               expinfo.loport,
               expinfo.hiport);
 
-	exp = ip_conntrack_expect_alloc();
+	exp = ip_conntrack_expect_alloc(ct);
 	if (!exp) {
 		ret = NF_DROP;
 		goto out;
 	}
 
         //exp->seq = ntohl(tcph->seq) + hdrsoff; /* mark all the headers */
-	exp->master = ct;
         //exp.help.exp_rtsp_info.len = hdrslen;
 
         exp->tuple.src.ip = ct->tuplehash[!dir].tuple.src.ip;
@@ -369,7 +367,7 @@
 		ret = ip_nat_rtsp_hook(pskb, ctinfo, &expinfo, exp);
 	else if (ip_conntrack_expect_related(exp) != 0) {
   		INFOP("ip_conntrack_expect_related failed\n");
-		ip_conntrack_expect_free(exp);
+		ip_conntrack_expect_put(exp);
 		ret  = NF_DROP;
 	}
 	goto out;
@@ -415,7 +413,7 @@
     if (dataoff >= (*pskb)->len)
 	    return NF_ACCEPT;
 
-    LOCK_BH(&rtsp_buffer_lock);
+    spin_lock_bh(&rtsp_buffer_lock);
     rb_ptr = skb_header_pointer(*pskb, dataoff,
 		    		(*pskb)->len - dataoff, rtsp_buffer);
     BUG_ON(rb_ptr == NULL);
@@ -443,7 +441,7 @@
         break;
     }
 
-    UNLOCK_BH(&rtsp_buffer_lock);
+    spin_unlock_bh(&rtsp_buffer_lock);
 
     return ret;
 }
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_conntrack_talk.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_talk.c
--- linux-2.6.13/net/ipv4/netfilter/ip_conntrack_talk.c	2005-09-09 01:47:19.753182255 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_conntrack_talk.c	2005-09-07 16:10:33.892072406 -0400
@@ -56,7 +56,6 @@
 #include <net/checksum.h>
 #include <net/udp.h>
 
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
@@ -77,7 +76,8 @@
 MODULE_PARM_DESC(ntalk2, "support ntalk2 protocol");
 
 static char talk_buffer[65536];
-static DECLARE_LOCK(talk_buffer_lock);
+static DEFINE_SPINLOCK(talk_buffer_lock);
+
 
 unsigned int (*ip_nat_talk_resp_hook)(struct sk_buff **pskb,
 				      struct ip_conntrack_expect *exp,
@@ -130,7 +130,7 @@
 	if (!(answer == SUCCESS && type == mode))
 		return NF_ACCEPT;
 	
-	exp = ip_conntrack_expect_alloc();
+	exp = ip_conntrack_expect_alloc(ct);
 	if (exp == NULL) {
 		return NF_DROP;
 	}
@@ -154,7 +154,6 @@
 			  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 		
 		exp->expectfn = talk_expectfn[talk_port - TALK_PORT];
-		exp->master = ct;
 
 		DEBUGP("ip_ct_talk_help_response: callee client "
 		       "%u.%u.%u.%u:%u -> caller daemon %u.%u.%u.%u:%u!\n",
@@ -167,7 +166,7 @@
 			ret = ip_nat_talk_resp_hook(pskb, exp, type, answer, 
 						    addr);
 		else if (ip_conntrack_expect_related(exp) != 0) {
-			ip_conntrack_expect_free(exp);
+			ip_conntrack_expect_put(exp);
 			ret = NF_DROP;
 		}
 	} else if (type == LOOK_UP) {
@@ -188,7 +187,6 @@
 			{ { 0xFFFFFFFF, { 0 } },
 			  { 0xFFFFFFFF, { 0xFFFF }, 0xFF }});
 		exp->expectfn = NULL;
-		exp->master = ct;
 
 		DEBUGP("ip_ct_talk_help_response: callee client "
 		       "%u.%u.%u.%u:%u -> caller client %u.%u.%u.%u:%u!\n",
@@ -201,7 +199,7 @@
 			ret = ip_nat_talk_resp_hook(pskb, exp, type, answer, 
 						    addr);
 		else if (ip_conntrack_expect_related(exp) != 0) {
-			ip_conntrack_expect_free(exp);
+			ip_conntrack_expect_put(exp);
 			ret = NF_DROP;
 		}
 	}
@@ -247,7 +245,7 @@
 	if (dataoff >= (*pskb)->len)
 		return NF_ACCEPT;
 
-	LOCK_BH(&talk_buffer_lock);
+	spin_lock_bh(&talk_buffer_lock);
 	tb_ptr = skb_header_pointer(*pskb, dataoff,
 				    (*pskb)->len - dataoff, talk_buffer);
 	BUG_ON(tb_ptr == NULL);
@@ -317,7 +315,7 @@
 		       sizeof(struct ntalk_response), sizeof(struct ntalk2_response));
 		ret = NF_ACCEPT;
 	}
-	UNLOCK_BH(&talk_buffer_lock);
+	spin_unlock_bh(&talk_buffer_lock);
 	return ret;
 }
 
@@ -368,18 +366,18 @@
 		       struct ip_conntrack_expect *exp)
 {
 	DEBUGP("ip_conntrack_talk: calling talk_expectfn for ct %p\n", ct);
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	ct->helper = &lookup_helpers[0];
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 }
 
 void ip_ct_ntalk_expect(struct ip_conntrack *ct,
 		        struct ip_conntrack_expect *exp)
 {
 	DEBUGP("ip_conntrack_talk: calling ntalk_expectfn for ct %p\n", ct);
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	ct->helper = &lookup_helpers[1];
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 }
 
 static int help(struct sk_buff **pskb,
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_nat_h323.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_nat_h323.c
--- linux-2.6.13/net/ipv4/netfilter/ip_nat_h323.c	2005-09-09 01:47:19.754182320 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_nat_h323.c	2005-09-07 13:46:07.596841985 -0400
@@ -107,10 +107,8 @@
 			break;
 	}
 
-	if (port == 0) {
-		ip_conntrack_expect_free(exp);
+	if (port == 0)
 		return NF_DROP;
-	}
 
 	newdata.port = htons(port);
 
@@ -155,10 +153,8 @@
 			break;
 	}
 
-	if (port == 0) {
-		ip_conntrack_expect_free(exp);
+	if (port == 0)
 		return NF_DROP;
-	}
 
 	newdata.port = htons(port);
 
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_nat_mms.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_nat_mms.c
--- linux-2.6.13/net/ipv4/netfilter/ip_nat_mms.c	2005-09-09 01:47:19.755182385 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_nat_mms.c	2005-09-07 13:48:04.880384207 -0400
@@ -114,10 +114,8 @@
 		}
 	}
 	
-	if (port == 0) {
-		ip_conntrack_expect_free(expect);
+	if (port == 0)
 		return NF_DROP;
-	}
 
 	sprintf(buffer, "\\\\%u.%u.%u.%u\\%s\\%u",
 	        NIPQUAD(newip),
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_nat_pptp.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_nat_pptp.c
--- linux-2.6.13/net/ipv4/netfilter/ip_nat_pptp.c	2005-09-09 01:47:19.756182450 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_nat_pptp.c	2005-09-07 13:48:48.426185292 -0400
@@ -223,7 +223,6 @@
 		DEBUGP("successfully registered expect\n");
 	} else {
 		DEBUGP("can't expect_related(expect_orig)\n");
-		ip_conntrack_expect_free(expect_orig);
 		return 1;
 	}
 
@@ -242,7 +241,6 @@
 	} else {
 		DEBUGP("can't expect_related(expect_reply)\n");
 		ip_conntrack_unexpect_related(expect_orig);
-		ip_conntrack_expect_free(expect_reply);
 		return 1;
 	}
 
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_nat_quake3.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_nat_quake3.c
--- linux-2.6.13/net/ipv4/netfilter/ip_nat_quake3.c	2005-09-09 01:47:19.757182514 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_nat_quake3.c	2005-09-07 13:49:24.794524802 -0400
@@ -72,10 +72,8 @@
 	exp->expectfn = ip_nat_follow_master;
 	//exp->dir = !dir;
 
-	if (ip_conntrack_expect_related(exp) != 0) {
-		ip_conntrack_expect_free(exp);
+	if (ip_conntrack_expect_related(exp) != 0)
 		return NF_DROP;
-	}
 
 	return NF_ACCEPT;
 }
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_nat_talk.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_nat_talk.c
--- linux-2.6.13/net/ipv4/netfilter/ip_nat_talk.c	2005-09-09 01:47:19.761182774 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_nat_talk.c	2005-09-07 13:50:09.923427997 -0400
@@ -193,10 +193,8 @@
 			break;
 		}
 	}
-	if (port == 0) {
-		ip_conntrack_expect_free(exp);
+	if (port == 0)
 		return NF_DROP;
-	}
 
 	if (!mangle_packet(pskb, ct, newip, htons(port), addr, NULL)) {
 		ip_conntrack_unexpect_related(exp);
diff -Naur linux-2.6.13/net/ipv4/netfilter/ip_set.c linux-2.6.13-pomfix/net/ipv4/netfilter/ip_set.c
--- linux-2.6.13/net/ipv4/netfilter/ip_set.c	2005-09-09 01:47:19.766183097 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ip_set.c	2005-09-08 22:48:23.810975299 -0400
@@ -32,7 +32,7 @@
 
 static struct list_head set_type_list;		/* all registered sets */
 static struct ip_set **ip_set_list;		/* all individual sets */
-static DECLARE_RWLOCK(ip_set_lock);		/* protects the lists and the hash */
+static DEFINE_RWLOCK(ip_set_lock);		/* protects the lists and the hash */
 static DECLARE_MUTEX(ip_set_app_mutex);		/* serializes user access */
 static ip_set_id_t ip_set_max = CONFIG_IP_NF_SET_MAX;
 static ip_set_id_t ip_set_bindings_hash_size =  CONFIG_IP_NF_SET_HASHSIZE;
@@ -83,7 +83,7 @@
 				% ip_set_bindings_hash_size;
 	struct ip_set_hash *set_hash;
 
-	MUST_BE_READ_LOCKED(&ip_set_lock);
+	ASSERT_READ_LOCK(&ip_set_lock);
 	IP_SET_ASSERT(ip_set_list[id]);
 	DP("set: %s, ip: %u.%u.%u.%u", ip_set_list[id]->name, HIPQUAD(ip));	
 	
@@ -100,7 +100,7 @@
 static inline void 
 __set_hash_del(struct ip_set_hash *set_hash)
 {
-	MUST_BE_WRITE_LOCKED(&ip_set_lock);
+	ASSERT_WRITE_LOCK(&ip_set_lock);
 	IP_SET_ASSERT(ip_set_list[set_hash->binding]);	
 
 	__ip_set_put(set_hash->binding);
@@ -117,7 +117,7 @@
 	
 	IP_SET_ASSERT(ip_set_list[id]);
 	DP("set: %s, ip: %u.%u.%u.%u", ip_set_list[id]->name, HIPQUAD(ip));	
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	set_hash = LIST_FIND(&ip_set_hash[key], ip_hash_cmp,
 			     struct ip_set_hash *, id, ip);
 	DP("set: %s, ip: %u.%u.%u.%u, binding: %s", ip_set_list[id]->name,
@@ -126,7 +126,7 @@
 
 	if (set_hash != NULL)
 		__set_hash_del(set_hash);
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return 0;
 }
 
@@ -142,7 +142,7 @@
 	IP_SET_ASSERT(ip_set_list[binding]);
 	DP("set: %s, ip: %u.%u.%u.%u, binding: %s", ip_set_list[id]->name, 
 	   HIPQUAD(ip), ip_set_list[binding]->name);
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	set_hash = LIST_FIND(&ip_set_hash[key], ip_hash_cmp,
 			     struct ip_set_hash *, id, ip);
 	if (!set_hash) {
@@ -164,7 +164,7 @@
 	set_hash->binding = binding;
 	__ip_set_get(set_hash->binding);
     unlock:
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return ret;
 }
 
@@ -184,7 +184,7 @@
 	ip_set_id_t __key;							\
 	struct ip_set_hash *__set_hash, *__n;					\
 										\
-	MUST_BE_WRITE_LOCKED(&ip_set_lock);					\
+	ASSERT_WRITE_LOCK(&ip_set_lock);					\
 	for (__key = 0; __key < ip_set_bindings_hash_size; __key++) {		\
 		list_for_each_entry_safe(__set_hash, __n, &ip_set_hash[__key], list)\
 			fn(__set_hash , ## args);				\
@@ -207,7 +207,7 @@
 	int res, i = 0;
 	
 	IP_SET_ASSERT(flags[i]);
-	READ_LOCK(&ip_set_lock);
+	read_lock_bh(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -218,7 +218,7 @@
 	} while (res > 0 
 		 && flags[++i] 
 		 && follow_bindings(index, set, ip));
-	READ_UNLOCK(&ip_set_lock);
+	read_unlock_bh(&ip_set_lock);
 
 	return res;
 }
@@ -234,7 +234,7 @@
 
 	IP_SET_ASSERT(flags[i]);
    retry:
-	READ_LOCK(&ip_set_lock);
+	read_lock_bh(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -245,7 +245,7 @@
 	} while ((res == 0 || res == -EEXIST)
 		 && flags[++i] 
 		 && follow_bindings(index, set, ip));
-	READ_UNLOCK(&ip_set_lock);
+	read_unlock_bh(&ip_set_lock);
 
 	if (res == -EAGAIN
 	    && set->type->retry
@@ -263,7 +263,7 @@
 	int res, i = 0;
 
 	IP_SET_ASSERT(flags[i]);
-	READ_LOCK(&ip_set_lock);
+	read_lock_bh(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -274,7 +274,7 @@
 	} while ((res == 0 || res == -EEXIST)
 		 && flags[++i] 
 		 && follow_bindings(index, set, ip));
-	READ_UNLOCK(&ip_set_lock);
+	read_unlock_bh(&ip_set_lock);
 }
 
 /* Register and deregister settype */
@@ -307,7 +307,7 @@
 		return -EINVAL;
 	}
 
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	if (find_set_type(set_type->typename)) {
 		/* Duplicate! */
 		ip_set_printk("'%s' already registered!", 
@@ -322,14 +322,14 @@
 	list_append(&set_type_list, set_type);
 	DP("'%s' registered.", set_type->typename);
    unlock:
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return ret;
 }
 
 void
 ip_set_unregister_set_type(struct ip_set_type *set_type)
 {
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	if (!find_set_type(set_type->typename)) {
 		ip_set_printk("'%s' not registered?",
 			      set_type->typename);
@@ -339,7 +339,7 @@
 	module_put(THIS_MODULE);
 	DP("'%s' unregistered.", set_type->typename);
    unlock:
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 
 }
 
@@ -551,13 +551,13 @@
 		if (binding == IP_SET_INVALID_ID)
 			return -ENOENT;
 
-		WRITE_LOCK(&ip_set_lock);
+		write_lock_bh(&ip_set_lock);
 		/* Sets as binding values are referenced */
 		if (set->binding != IP_SET_INVALID_ID)
 			__ip_set_put(set->binding);
 		set->binding = binding;
 		__ip_set_get(set->binding);
-		WRITE_UNLOCK(&ip_set_lock);
+		write_unlock_bh(&ip_set_lock);
 
 		return 0;
 	}
@@ -629,15 +629,15 @@
 		/* unbind :all: */
 		if (strcmp(req_bind->binding, IPSET_TOKEN_DEFAULT) == 0) {
 			/* Default binding of sets */
-			WRITE_LOCK(&ip_set_lock);
+			write_lock_bh(&ip_set_lock);
 			FOREACH_SET_DO(__unbind_default);
-			WRITE_UNLOCK(&ip_set_lock);
+			write_unlock_bh(&ip_set_lock);
 			return 0;
 		} else if (strcmp(req_bind->binding, IPSET_TOKEN_ALL) == 0) {
 			/* Flush all bindings of all sets*/
-			WRITE_LOCK(&ip_set_lock);
+			write_lock_bh(&ip_set_lock);
 			FOREACH_HASH_RW_DO(__set_hash_del);
-			WRITE_UNLOCK(&ip_set_lock);
+			write_unlock_bh(&ip_set_lock);
 			return 0;
 		}
 		DP("unreachable reached!");
@@ -653,19 +653,19 @@
 		if (binding == IP_SET_INVALID_ID)
 			return -ENOENT;
 			
-		WRITE_LOCK(&ip_set_lock);
+		write_lock_bh(&ip_set_lock);
 		/* Sets in hash values are referenced */
 		__ip_set_put(set->binding);
 		set->binding = IP_SET_INVALID_ID;
-		WRITE_UNLOCK(&ip_set_lock);
+		write_unlock_bh(&ip_set_lock);
 
 		return 0;
 	} else if (strcmp(req_bind->binding, IPSET_TOKEN_ALL) == 0) {
 		/* Flush all bindings */
 
-		WRITE_LOCK(&ip_set_lock);
+		write_lock_bh(&ip_set_lock);
 		FOREACH_HASH_RW_DO(__set_hash_del_byid, set->id);
-		WRITE_UNLOCK(&ip_set_lock);
+		write_unlock_bh(&ip_set_lock);
 		return 0;
 	}
 	
@@ -741,10 +741,10 @@
 {
 	struct ip_set_type *type;
 	
-	READ_LOCK(&ip_set_lock);
+	read_lock_bh(&ip_set_lock);
 	type = find_set_type(typename);
 	if (type == NULL)
-		READ_UNLOCK(&ip_set_lock);
+		read_unlock_bh(&ip_set_lock);
 
 	return type;
 }
@@ -832,11 +832,11 @@
 		goto out;
 	}
 	if (!try_module_get(set->type->me)) {
-		READ_UNLOCK(&ip_set_lock);
+		read_unlock_bh(&ip_set_lock);
 		res = -EFAULT;
 		goto out;
 	}
-	READ_UNLOCK(&ip_set_lock);
+	read_unlock_bh(&ip_set_lock);
 
 	/*
 	 * Without holding any locks, create private part.
@@ -852,7 +852,7 @@
 	 * find free id/index and check that it is not already in 
 	 * ip_set_list.
 	 */
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	if ((res = find_free_id(set->name, &index, &id)) != 0) {
 		DP("no free id!");
 		goto cleanup;
@@ -871,11 +871,11 @@
 	DP("create: '%s' created with index %u, id %u!", set->name, index, id);
 	set->id = id;
 	ip_set_list[index] = set;
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return res;
 	
     cleanup:
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	set->type->destroy(set);
     put_out:
 	module_put(set->type->me);
@@ -894,12 +894,12 @@
 
 	IP_SET_ASSERT(set);
 	DP("set: %s",  set->name);
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	FOREACH_HASH_RW_DO(__set_hash_del_byid, set->id);
 	if (set->binding != IP_SET_INVALID_ID)
 		__ip_set_put(set->binding);
 	ip_set_list[index] = NULL;
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 
 	/* Must call it without holding any lock */
 	set->type->destroy(set);
@@ -970,7 +970,7 @@
 	int res = 0;
 
 	DP("set: %s to %s",  set->name, name);
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	for (i = 0; i < ip_set_max; i++) {
 		if (ip_set_list[i] != NULL
 		    && strncmp(ip_set_list[i]->name, 
@@ -982,7 +982,7 @@
 	}
 	strncpy(set->name, name, IP_SET_MAXNAMELEN);
     unlock:
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return res;
 }
 
@@ -1004,7 +1004,7 @@
 		return -ENOEXEC;
 
 	/* No magic here: ref munging protected by the mutex */	
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	strncpy(from_name, from->name, IP_SET_MAXNAMELEN);
 	from_ref = atomic_read(&from->ref);
 
@@ -1016,7 +1016,7 @@
 	ip_set_list[from_index] = to;
 	ip_set_list[to_index] = from;
 	
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return 0;
 }
 
@@ -1332,10 +1332,10 @@
 					      hash_save->binding);
 		else {
 			IP_SET_ASSERT(set->binding == IP_SET_INVALID_ID);
-			WRITE_LOCK(&ip_set_lock);
+			write_lock_bh(&ip_set_lock);
 			set->binding = hash_save->binding;
 			__ip_set_get(set->binding);
-			WRITE_UNLOCK(&ip_set_lock);
+			write_unlock_bh(&ip_set_lock);
 			DP("default binding: %u", set->binding);
 		}
 		if (res != 0)
diff -Naur linux-2.6.13/net/ipv4/netfilter/ipt_u32.c linux-2.6.13-pomfix/net/ipv4/netfilter/ipt_u32.c
--- linux-2.6.13/net/ipv4/netfilter/ipt_u32.c	2005-09-09 01:47:19.804185559 -0400
+++ linux-2.6.13-pomfix/net/ipv4/netfilter/ipt_u32.c	2005-09-08 21:56:17.344315166 -0400
@@ -105,7 +105,6 @@
 
 #include <linux/netfilter_ipv4/ipt_u32.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 /* #include <asm-i386/timex.h> for timing */
 
@@ -115,7 +114,7 @@
 
 /* This is slow, but it's simple. --RR */
 static char u32_buffer[65536];
-static DECLARE_LOCK(u32_lock);
+static DEFINE_SPINLOCK(u32_lock);
 
 static int
 match(const struct sk_buff *skb,
@@ -136,7 +135,7 @@
 
 	u_int32_t AttPos;
 
-	LOCK_BH(&u32_lock);
+	spin_lock_bh(&u32_lock);
 
 	head = skb_header_pointer(skb, 0, skb->len, u32_buffer);
 	BUG_ON(head == NULL);
@@ -148,7 +147,7 @@
 	        AttPos = 0;
 		pos = data->tests[testind].location[0].number;
 		if (AttPos + pos + 3 > skb->len || AttPos + pos < 0){
-			UNLOCK_BH(&u32_lock);
+			spin_unlock_bh(&u32_lock);
 			return 0;
 		}
 		val = (base[pos]<<24) + (base[pos+1]<<16) +
@@ -190,13 +189,13 @@
 			/* cycles2 = get_cycles(); 
 			   printk("failed %d in %d cycles\n", testind, 
 				  cycles2-cycles1); */
-			UNLOCK_BH(&u32_lock);
+			spin_unlock_bh(&u32_lock);
 			return 0;
 		}
 	}
 	/* cycles2 = get_cycles();
 	   printk("succeeded in %d cycles\n", cycles2-cycles1); */
-	UNLOCK_BH(&u32_lock);
+	spin_unlock_bh(&u32_lock);
 	return 1;
 }
 
diff -Naur linux-2.6.13/net/mpls/af_mpls.c linux-2.6.13-pomfix/net/mpls/af_mpls.c
--- linux-2.6.13/net/mpls/af_mpls.c	2005-09-09 01:47:18.736116376 -0400
+++ linux-2.6.13-pomfix/net/mpls/af_mpls.c	2005-09-09 00:22:06.666529286 -0400
@@ -34,6 +34,12 @@
 
 static kmem_cache_t *mpls_sk_cachep;
 
+static struct proto mpls_proto = {
+	.name =		"MPLS",
+	.owner =	THIS_MODULE,
+	.obj_size =	sizeof(struct mpls_sock),
+};
+
 struct proto_ops mpls_sk_ops = {
 	.family =	PF_MPLS,
 	.owner =	THIS_MODULE,
@@ -81,16 +87,15 @@
 	sock->state = SS_UNCONNECTED;
 	sock->ops = &mpls_sk_ops;
 
-	sk = sk_alloc(PF_INET, GFP_KERNEL, sizeof(struct sock),
-		mpls_sk_cachep);
+	sk = sk_alloc(PF_INET, GFP_KERNEL, &mpls_proto, 
+		sizeof(struct sock));
         if (!sk)
                 return -1;
 
 	sock_init_data(sock, sk);
-	sk_set_owner(sk, THIS_MODULE);
+	sock_reset_flag(sk, SOCK_ZAPPED);
 
 	sk->sk_destruct    = mpls_sock_destruct;
-	sk->sk_zapped      = 0;
 	sk->sk_family      = PF_MPLS;
 	sk->sk_protocol    = 0;
 	sk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;

--gBBFr7Ir9EOA20Yy--
