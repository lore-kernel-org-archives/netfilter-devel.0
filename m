From: Patrick McHardy <kaber@trash.net>
Subject: Redundant locking / deadlock ?
Date: Fri, 19 Sep 2003 09:50:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F6AB535.7020008@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020503080909000609080607"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------020503080909000609080607
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I can't understand why ip_irc_lock and ip_amanda_lock are required.
Both are used to protect private data in the expectation between the
conntrack-helper and the nat-helper. The conntrack-helper holds the
lock while setting the data and calling ip_conntrack_expect_related,
the nat-helper holds the lock while reading the data. But since
- ip_conntrack_expect_related write-locks ip_conntrack_lock
- the nat-helpers are called under read-locked ip_conntrack lock
- the expectations private data can't change once it's registered
it seems to be unnceccessary.

Even worse, consider the following sequence

CPU1:
conntrack-helper:help: lock(private_lock)
ip_conntrack_expect_related: write_lock(ip_conntrack_lock)

CPU2:
nat-core:do_bindings: read_lock(ip_conntrack_lock)
nat-helper:help: lock(private_lock)

which will cause deadlock.

In case i'm not misguided by the late hour, attached is a patch which:
- removes the locks from amanda- and irc-helper
- fixes the ftp-helper to only use the lock to protect the 
per-connection data
- rename various ct_xxx_info variables to exp_xxx_info so it becomes
  clear it's expectation-data.

The patch is untested and only meant for review.

One problem remains, ip_nat_standalone dereferences ct->master->expectant
without holding ip_conntrack_lock before calling a nat helpers expect
function. The ftp helpers expect-function also dereferences
ct->master->expectant without the lock. ip_conntrack_lock probably needs
to be grabbed somewhere in ip_nat_standalone.

Regards,
Patrick

--------------020503080909000609080607
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/ipv4/netfilter/ip_conntrack_amanda.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ip_conntrack_amanda.c	Mon Apr 28 03:52:54 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_amanda.c	Fri Sep 19 09:03:23 2003
@@ -24,7 +24,6 @@
 #include <net/checksum.h>
 #include <net/udp.h>
 
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
 
@@ -36,7 +35,6 @@
 MODULE_PARM(master_timeout, "i");
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
 
-DECLARE_LOCK(ip_amanda_lock);
 struct module *ip_conntrack_amanda = THIS_MODULE;
 
 #define MAXMATCHLEN	6
@@ -148,8 +146,6 @@
 					"%u found\n", conns[i].match,
 					exp_amanda_info->port);
 
-				LOCK_BH(&ip_amanda_lock);
-
 				expect.tuple = ((struct ip_conntrack_tuple)
 						{ { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
 						  { 0 } },
@@ -184,7 +180,6 @@
 					 *       .seq.
 					 */
 				}
-				UNLOCK_BH(&ip_amanda_lock);
 			} /* if memcmp(conns) */
 		} /* for .. NUM_MSGS */
 		data++;
@@ -228,8 +223,6 @@
 	}
 	return 0;
 }
-
-EXPORT_SYMBOL(ip_amanda_lock);
 
 module_init(init);
 module_exit(fini);
===== net/ipv4/netfilter/ip_conntrack_ftp.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ip_conntrack_ftp.c	Wed Jun 25 00:19:42 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_ftp.c	Fri Sep 19 09:16:55 2003
@@ -11,7 +11,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 
-DECLARE_LOCK(ip_ftp_lock);
+static DECLARE_LOCK(ip_ftp_lock);
 struct module *ip_conntrack_ftp = THIS_MODULE;
 
 #define MAX_PORTS 8
@@ -338,7 +338,6 @@
 	memset(&expect, 0, sizeof(expect));
 
 	/* Update the ftp info */
-	LOCK_BH(&ip_ftp_lock);
 	if (htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3])
 	    == ct->tuplehash[dir].tuple.src.ip) {
 		exp->seq = ntohl(tcph->seq) + matchoff;
@@ -358,7 +357,8 @@
 		   <lincoln@cesar.org.br> for reporting this potential
 		   problem (DMZ machines opening holes to internal
 		   networks, or the packet filter itself). */
-		if (!loose) goto out;
+		if (!loose)
+			return NF_ACCEPT;
 	}
 
 	exp->tuple = ((struct ip_conntrack_tuple)
@@ -376,8 +376,6 @@
 
 	/* Ignore failure; should only happen with NAT */
 	ip_conntrack_expect_related(ct, &expect);
- out:
-	UNLOCK_BH(&ip_ftp_lock);
 
 	return NF_ACCEPT;
 }
@@ -434,8 +432,6 @@
 	}
 	return 0;
 }
-
-EXPORT_SYMBOL(ip_ftp_lock);
 
 MODULE_LICENSE("GPL");
 module_init(init);
===== net/ipv4/netfilter/ip_conntrack_irc.c 1.9 vs edited =====
--- 1.9/net/ipv4/netfilter/ip_conntrack_irc.c	Fri Jul 25 23:10:37 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_irc.c	Fri Sep 19 09:00:54 2003
@@ -29,7 +29,6 @@
 #include <net/checksum.h>
 #include <net/tcp.h>
 
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
 
@@ -61,7 +60,6 @@
 };
 #define MINMATCHLEN	5
 
-DECLARE_LOCK(ip_irc_lock);
 struct module *ip_conntrack_irc = THIS_MODULE;
 
 #if 0
@@ -205,8 +203,6 @@
 			
 			memset(&expect, 0, sizeof(expect));
 
-			LOCK_BH(&ip_irc_lock);
-
 			/* save position of address in dcc string,
 			 * neccessary for NAT */
 			DEBUGP("tcph->seq = %u\n", tcph->seq);
@@ -233,8 +229,6 @@
 				ntohs(exp->tuple.dst.u.tcp.port));
 
 			ip_conntrack_expect_related(ct, &expect);
-			UNLOCK_BH(&ip_irc_lock);
-
 			return NF_ACCEPT;
 		} /* for .. NUM_DCCPROTO */
 	} /* while data < ... */
@@ -311,8 +305,6 @@
 		ip_conntrack_helper_unregister(&irc_helpers[i]);
 	}
 }
-
-EXPORT_SYMBOL(ip_irc_lock);
 
 module_init(init);
 module_exit(fini);
===== net/ipv4/netfilter/ip_nat_amanda.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/ip_nat_amanda.c	Sat Sep 13 06:05:49 2003
+++ edited/net/ipv4/netfilter/ip_nat_amanda.c	Fri Sep 19 09:03:56 2003
@@ -38,9 +38,6 @@
 MODULE_DESCRIPTION("Amanda network address translation module");
 MODULE_LICENSE("GPL");
 
-/* protects amanda part of conntracks */
-DECLARE_LOCK_EXTERN(ip_amanda_lock);
-
 static unsigned int
 amanda_nat_expected(struct sk_buff **pskb,
 		 unsigned int hooknum,
@@ -103,17 +100,10 @@
 	struct ip_conntrack_tuple t = exp->tuple;
 	u_int16_t port;
 
-	MUST_BE_LOCKED(&ip_amanda_lock);
-
 	newip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
 	DEBUGP ("ip_nat_amanda_help: newip = %u.%u.%u.%u\n", NIPQUAD(newip));
 
 	/* Alter conntrack's expectations. */
-
-	/* We can read expect here without conntrack lock, since it's
-	   only set in ip_conntrack_amanda, with ip_amanda_lock held
-	   writable */
-
 	t.dst.ip = newip;
 	for (port = ct_amanda_info->port; port != 0; port++) {
 		t.dst.u.tcp.port = htons(port);
@@ -163,17 +153,14 @@
 		       : hooknum == NF_IP_LOCAL_IN ? "INPUT" : "???");
 	DUMP_TUPLE(&exp->tuple);
 
-	LOCK_BH(&ip_amanda_lock);
 // XXX	if (exp->seq != 0)
 	if (exp->help.exp_amanda_info.offset != 0)
 		/*  if this packet has a "seq" it needs to have it's content mangled */
 		if (!amanda_data_fixup(ct, pskb, ctinfo, exp)) {
-			UNLOCK_BH(&ip_amanda_lock);
 			DEBUGP("ip_nat_amanda: NF_DROP\n");
 			return NF_DROP;
 		}
 	exp->help.exp_amanda_info.offset = 0;
-	UNLOCK_BH(&ip_amanda_lock);
 
 	DEBUGP("ip_nat_amanda: NF_ACCEPT\n");
 	return NF_ACCEPT;
===== net/ipv4/netfilter/ip_nat_ftp.c 1.8 vs edited =====
--- 1.8/net/ipv4/netfilter/ip_nat_ftp.c	Wed Jun 25 00:19:42 2003
+++ edited/net/ipv4/netfilter/ip_nat_ftp.c	Fri Sep 19 09:17:12 2003
@@ -24,8 +24,6 @@
 MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
 #endif
 
-DECLARE_LOCK_EXTERN(ip_ftp_lock);
-
 /* FIXME: Time out? --RR */
 
 static unsigned int
@@ -48,8 +46,6 @@
 	DEBUGP("nat_expected: We have a connection!\n");
 	exp_ftp_info = &ct->master->help.exp_ftp_info;
 
-	LOCK_BH(&ip_ftp_lock);
-
 	if (exp_ftp_info->ftptype == IP_CT_FTP_PORT
 	    || exp_ftp_info->ftptype == IP_CT_FTP_EPRT) {
 		/* PORT command: make connection go to the client. */
@@ -64,7 +60,6 @@
 		DEBUGP("nat_expected: PASV cmd. %u.%u.%u.%u->%u.%u.%u.%u\n",
 		       NIPQUAD(newsrcip), NIPQUAD(newdstip));
 	}
-	UNLOCK_BH(&ip_ftp_lock);
 
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
 		newip = newsrcip;
@@ -100,8 +95,6 @@
 {
 	char buffer[sizeof("nnn,nnn,nnn,nnn,nnn,nnn")];
 
-	MUST_BE_LOCKED(&ip_ftp_lock);
-
 	sprintf(buffer, "%u,%u,%u,%u,%u,%u",
 		NIPQUAD(newip), port>>8, port&0xFF);
 
@@ -123,8 +116,6 @@
 {
 	char buffer[sizeof("|1|255.255.255.255|65535|")];
 
-	MUST_BE_LOCKED(&ip_ftp_lock);
-
 	sprintf(buffer, "|1|%u.%u.%u.%u|%u|", NIPQUAD(newip), port);
 
 	DEBUGP("calling ip_nat_mangle_tcp_packet\n");
@@ -145,8 +136,6 @@
 {
 	char buffer[sizeof("|||65535|")];
 
-	MUST_BE_LOCKED(&ip_ftp_lock);
-
 	sprintf(buffer, "|||%u|", port);
 
 	DEBUGP("calling ip_nat_mangle_tcp_packet\n");
@@ -166,7 +155,7 @@
     [IP_CT_FTP_EPSV] mangle_epsv_packet
 };
 
-static int ftp_data_fixup(const struct ip_ct_ftp_expect *ct_ftp_info,
+static int ftp_data_fixup(const struct ip_ct_ftp_expect *exp_ftp_info,
 			  struct ip_conntrack *ct,
 			  struct sk_buff **pskb,
 			  enum ip_conntrack_info ctinfo,
@@ -178,15 +167,14 @@
 	u_int16_t port;
 	struct ip_conntrack_tuple newtuple;
 
-	MUST_BE_LOCKED(&ip_ftp_lock);
 	DEBUGP("FTP_NAT: seq %u + %u in %u\n",
-	       expect->seq, ct_ftp_info->len,
+	       expect->seq, exp_ftp_info->len,
 	       ntohl(tcph->seq));
 
 	/* Change address inside packet to match way we're mapping
 	   this connection. */
-	if (ct_ftp_info->ftptype == IP_CT_FTP_PASV
-	    || ct_ftp_info->ftptype == IP_CT_FTP_EPSV) {
+	if (exp_ftp_info->ftptype == IP_CT_FTP_PASV
+	    || exp_ftp_info->ftptype == IP_CT_FTP_EPSV) {
 		/* PASV/EPSV response: must be where client thinks server
 		   is */
 		newip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
@@ -208,7 +196,7 @@
 	newtuple.src.u.tcp.port = expect->tuple.src.u.tcp.port;
 
 	/* Try to get same port: if not, try to change it. */
-	for (port = ct_ftp_info->port; port != 0; port++) {
+	for (port = exp_ftp_info->port; port != 0; port++) {
 		newtuple.dst.u.tcp.port = htons(port);
 
 		if (ip_conntrack_change_expect(expect, &newtuple) == 0)
@@ -217,9 +205,9 @@
 	if (port == 0)
 		return 0;
 
-	if (!mangle[ct_ftp_info->ftptype](pskb, newip, port,
+	if (!mangle[exp_ftp_info->ftptype](pskb, newip, port,
 					  expect->seq - ntohl(tcph->seq),
-					  ct_ftp_info->len, ct, ctinfo))
+					  exp_ftp_info->len, ct, ctinfo))
 		return 0;
 
 	return 1;
@@ -236,12 +224,12 @@
 	struct tcphdr *tcph = (void *)iph + iph->ihl*4;
 	unsigned int datalen;
 	int dir;
-	struct ip_ct_ftp_expect *ct_ftp_info;
+	struct ip_ct_ftp_expect *exp_ftp_info;
 
 	if (!exp)
 		DEBUGP("ip_nat_ftp: no exp!!");
 
-	ct_ftp_info = &exp->help.exp_ftp_info;
+	exp_ftp_info = &exp->help.exp_ftp_info;
 
 	/* Only mangle things once: original direction in POST_ROUTING
 	   and reply direction on PRE_ROUTING. */
@@ -257,28 +245,23 @@
 	}
 
 	datalen = (*pskb)->len - iph->ihl * 4 - tcph->doff * 4;
-	LOCK_BH(&ip_ftp_lock);
 	/* If it's in the right range... */
-	if (between(exp->seq + ct_ftp_info->len,
+	if (between(exp->seq + exp_ftp_info->len,
 		    ntohl(tcph->seq),
 		    ntohl(tcph->seq) + datalen)) {
-		if (!ftp_data_fixup(ct_ftp_info, ct, pskb, ctinfo, exp)) {
-			UNLOCK_BH(&ip_ftp_lock);
+		if (!ftp_data_fixup(exp_ftp_info, ct, pskb, ctinfo, exp))
 			return NF_DROP;
-		}
 	} else {
 		/* Half a match?  This means a partial retransmisison.
 		   It's a cracker being funky. */
 		if (net_ratelimit()) {
 			printk("FTP_NAT: partial packet %u/%u in %u/%u\n",
-			       exp->seq, ct_ftp_info->len,
+			       exp->seq, exp_ftp_info->len,
 			       ntohl(tcph->seq),
 			       ntohl(tcph->seq) + datalen);
 		}
-		UNLOCK_BH(&ip_ftp_lock);
 		return NF_DROP;
 	}
-	UNLOCK_BH(&ip_ftp_lock);
 
 	return NF_ACCEPT;
 }
===== net/ipv4/netfilter/ip_nat_irc.c 1.5 vs edited =====
--- 1.5/net/ipv4/netfilter/ip_nat_irc.c	Sat Sep 13 06:05:49 2003
+++ edited/net/ipv4/netfilter/ip_nat_irc.c	Fri Sep 19 09:05:53 2003
@@ -46,9 +46,6 @@
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
 #endif
 
-/* protects irc part of conntracks */
-DECLARE_LOCK_EXTERN(ip_irc_lock);
-
 /* FIXME: Time out? --RR */
 
 static unsigned int
@@ -89,7 +86,7 @@
 	return ip_nat_setup_info(ct, &mr, hooknum);
 }
 
-static int irc_data_fixup(const struct ip_ct_irc_expect *ct_irc_info,
+static int irc_data_fixup(const struct ip_ct_irc_expect *exp_irc_info,
 			  struct ip_conntrack *ct,
 			  struct sk_buff **pskb,
 			  enum ip_conntrack_info ctinfo,
@@ -104,23 +101,17 @@
 	/* "4294967296 65635 " */
 	char buffer[18];
 
-	MUST_BE_LOCKED(&ip_irc_lock);
-
 	DEBUGP("IRC_NAT: info (seq %u + %u) in %u\n",
-	       expect->seq, ct_irc_info->len,
+	       expect->seq, exp_irc_info->len,
 	       ntohl(tcph->seq));
 
 	newip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
 
 	/* Alter conntrack's expectations. */
 
-	/* We can read expect here without conntrack lock, since it's
-	   only set in ip_conntrack_irc, with ip_irc_lock held
-	   writable */
-
 	t = expect->tuple;
 	t.dst.ip = newip;
-	for (port = ct_irc_info->port; port != 0; port++) {
+	for (port = exp_irc_info->port; port != 0; port++) {
 		t.dst.u.tcp.port = htons(port);
 		if (ip_conntrack_change_expect(expect, &t) == 0) {
 			DEBUGP("using port %d", port);
@@ -150,7 +141,7 @@
 
 	return ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, 
 					expect->seq - ntohl(tcph->seq),
-					ct_irc_info->len, buffer, 
+					exp_irc_info->len, buffer, 
 					strlen(buffer));
 }
 
@@ -165,12 +156,12 @@
 	struct tcphdr *tcph = (void *) iph + iph->ihl * 4;
 	unsigned int datalen;
 	int dir;
-	struct ip_ct_irc_expect *ct_irc_info;
+	struct ip_ct_irc_expect *exp_irc_info;
 
 	if (!exp)
 		DEBUGP("ip_nat_irc: no exp!!");
 		
-	ct_irc_info = &exp->help.exp_irc_info;
+	exp_irc_info = &exp->help.exp_irc_info;
 
 	/* Only mangle things once: original direction in POST_ROUTING
 	   and reply direction on PRE_ROUTING. */
@@ -187,29 +178,24 @@
 	DEBUGP("got beyond not touching\n");
 
 	datalen = (*pskb)->len - iph->ihl * 4 - tcph->doff * 4;
-	LOCK_BH(&ip_irc_lock);
 	/* Check wether the whole IP/address pattern is carried in the payload */
-	if (between(exp->seq + ct_irc_info->len,
+	if (between(exp->seq + exp_irc_info->len,
 		    ntohl(tcph->seq),
 		    ntohl(tcph->seq) + datalen)) {
-		if (!irc_data_fixup(ct_irc_info, ct, pskb, ctinfo, exp)) {
-			UNLOCK_BH(&ip_irc_lock);
+		if (!irc_data_fixup(exp_irc_info, ct, pskb, ctinfo, exp))
 			return NF_DROP;
-		}
 	} else { 
 		/* Half a match?  This means a partial retransmisison.
 		   It's a cracker being funky. */
 		if (net_ratelimit()) {
 			printk
 			    ("IRC_NAT: partial packet %u/%u in %u/%u\n",
-			     exp->seq, ct_irc_info->len,
+			     exp->seq, exp_irc_info->len,
 			     ntohl(tcph->seq),
 			     ntohl(tcph->seq) + datalen);
 		}
-		UNLOCK_BH(&ip_irc_lock);
 		return NF_DROP;
 	}
-	UNLOCK_BH(&ip_irc_lock);
 
 	return NF_ACCEPT;
 }

--------------020503080909000609080607--
