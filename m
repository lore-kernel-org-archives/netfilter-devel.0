From: Gregor Maier <gregor@net.in.tum.de>
Subject: Re: [RFC] [PATCH] clean up nf_log API
Date: Thu, 11 May 2006 17:36:36 +1200
Message-ID: <4462CD64.1060507@net.in.tum.de>
References: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000409080202090402090902"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Holger Eitzenberger <heitzenberger@astaro.com>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
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
--------------000409080202090402090902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I wrote a patch about 2 month ago, that does something similiar.
Maybe some of it is usefull. If you are interested I would venture to 
update the patch.

The patch uses only a modified version of the normal LOG target, but I 
wanted to change this to a NF_LOG target anyway.


Regards
Gregor

--------------000409080202090402090902
Content-Type: text/plain;
 name="nf-log-unification-take1.1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf-log-unification-take1.1.patch"

[PATCH][RFC] Unifiy logging in netfilter using nf_log, take #1

Although nf_log is meant as a general logging API for netfilter, not 
every module uses it. Furthermore modules can interfere with the logging
of other modules. This patch (against net-2.6.17) tries to eliminate these
problems.
 
* Everything uses nf_log.c as logging API (excpect the obsolete ULOG targets)
* Loggers in nf_log.c are stackable. More than one logger can be registered
    per PF
* nf_loginfo struct has been changed. Instead of the type field and the
    union there is a "backends" field now that contains a bitmask specifing
    which backends should process/log this packet. 
* ipt_LOGc and ip6t_LOG.c have been splitted: 
    * xt_LOG.c  now contains the targets. The targets
        always use nf_log for logging. These should be the only
        logging targets. They take care of setting up nf_loginfo for
        logging to syslog and/or to other backends
    * ip_log_syslog.c and ip6_log_syslog.c are new and contain the
        syslog log backends. When these modules are loaded, the syslog
        backend is registered with nf_log
* The backends (nfnetlink_log, ip_log_syslog, ip6_log_syslog, ebt_LOG) check
    the backends field of nf_loginfo to see if they should handle the packet
* The ULOG targets have been changed to be self-contained and independent
    from nf_log API. They are the _only_ modules that do not use nf_log

What the LOG targets for v4 and v6 can do from a userspace / iptables 
point of view:
* Log to syslog (allows you to specify the flags)
* Log to nfnetlink_log (allows you to specify the loggroup)
* Log to syslog and nfnetlink_log
 ===> One LOG target fits all. 

Things TODO: 
* ebt_log is always using the syslog backend. Furthermore the code there
    isn't split into the syslog logger and the target
* change userspace iptables, so it can utilize the new stuff. Patch will 
    follow soon
* thoroughly test the patch

POTENTIAL PROBLEMS / ALTERNATIVE SOLUTION
* ipt_log_info and ip6t_log_info have been replaced by xt_log_info (which
    has changed in size). This means iptables must be recompiled and older
    iptables versions won't work with these changes. 
    If this is considered a problem the only solution I can think of, is
    not to change the old LOG targets and introduce a new, general purpose 
    target, that can do what the LOG target in this patch can to.

Signed-off-by: Gregor Maier <gregor@net.in.tum.de>

=====================================================================
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 4688969..53540df 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -123,22 +123,19 @@ extern struct list_head nf_hooks[NPROTO]
 #define NF_LOG_UID		0x08	/* Log UID owning local socket */
 #define NF_LOG_MASK		0x0f
 
-#define NF_LOG_TYPE_LOG		0x01
-#define NF_LOG_TYPE_ULOG	0x02
+/* make sure not to change this without changing xt_LOG.h:NF_LOG_BACKEND_* */
+#define NF_LOG_BACKEND_SYSLOG	0x01
+#define NF_LOG_BACKEND_NFLOG	0x02
+#define NF_LOG_BACKEND_MASK (NF_LOG_BACKEND_SYSLOG|NF_LOG_BACKEND_NFLOG)
 
 struct nf_loginfo {
-	u_int8_t type;
-	union {
-		struct {
-			u_int32_t copy_len;
-			u_int16_t group;
-			u_int16_t qthreshold;
-		} ulog;
-		struct {
-			u_int8_t level;
-			u_int8_t logflags;
-		} log;
-	} u;
+	u_int8_t backends; /* ORed from NF_LOG_BACKEND* */
+	/* nflog backend */
+	u_int16_t group;
+	u_int16_t qthreshold;
+	/* SYSLOG backend */
+	u_int8_t level;
+	u_int8_t logflags;
 };
 
 typedef void nf_logfn(unsigned int pf,
@@ -157,7 +154,7 @@ struct nf_logger {
 
 /* Function to register/unregister log function. */
 int nf_log_register(int pf, struct nf_logger *logger);
-int nf_log_unregister_pf(int pf);
+int nf_log_unregister_pf(int pf, struct nf_logger *logger);
 void nf_log_unregister_logger(struct nf_logger *logger);
 
 /* Calls the registered backend logging function */
diff --git a/include/linux/netfilter/xt_LOG.h b/include/linux/netfilter/xt_LOG.h
new file mode 100644
index 0000000..c3a2255
--- /dev/null
+++ b/include/linux/netfilter/xt_LOG.h
@@ -0,0 +1,43 @@
+/* iptables module for logging / LOG target
+ *
+ * (C) 2006 Gregor Maier <gregor@majordomus.org>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ * 
+*/
+#ifndef _XT_LOG_TARGET_H
+#define _XT_LOG_TARGET_H
+
+/* make sure not to change this without changing netfilter.h:XT_LOG_* (!) */
+#define XT_LOG_BACKEND_SYSLOG	0x01
+#define XT_LOG_BACKEND_NFLOG	0x02
+#define XT_LOG_BACKEND_MASK (XT_LOG_BACKEND_SYSLOG|XT_LOG_BACKEND_NFLOG)
+
+/* make sure not to change this without changing netfilter.h:XT_LOG_* (!) */
+#define XT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define XT_LOG_TCPOPT		0x02	/* Log TCP options */
+#define XT_LOG_IPOPT		0x04	/* Log IP options */
+#define XT_LOG_UID		0x08	/* Log UID owning local socket */
+#define XT_LOG_MASK		0x0f
+
+#define IPT_LOG_TCPSEQ		XT_LOG_TCPSEQ	/* Log TCP sequence numbers */
+#define IPT_LOG_TCPOPT		XT_LOG_TCPOPT	/* Log TCP options */
+#define IPT_LOG_IPOPT		XT_LOG_IPOPT	/* Log IP options */
+#define IPT_LOG_UID		XT_LOG_UID	/* Log UID owning local socket */
+#define IPT_LOG_MASK		XT_LOG_MASK
+
+#define IP6T_LOG_TCPSEQ		XT_LOG_TCPSEQ	/* Log TCP sequence numbers */
+#define IP6T_LOG_TCPOPT		XT_LOG_TCPOPT	/* Log TCP options */
+#define IP6T_LOG_IPOPT		XT_LOG_IPOPT	/* Log IP options */
+#define IP6T_LOG_UID		XT_LOG_UID	/* Log UID owning local socket */
+#define IP6T_LOG_MASK		XT_LOG_MASK
+
+struct xt_log_info {
+	u_int16_t group;
+	unsigned char backends;
+	unsigned char level;
+	unsigned char logflags;
+	char prefix[30];
+};
+
+#endif /* _XT_LOG_TARGET_H */
diff --git a/include/linux/netfilter_bridge/ebt_log.h b/include/linux/netfilter_bridge/ebt_log.h
index 96e231a..936e5d9 100644
--- a/include/linux/netfilter_bridge/ebt_log.h
+++ b/include/linux/netfilter_bridge/ebt_log.h
@@ -4,7 +4,7 @@
 #define EBT_LOG_IP 0x01 /* if the frame is made by ip, log the ip information */
 #define EBT_LOG_ARP 0x02
 #define EBT_LOG_NFLOG 0x04
-#define EBT_LOG_MASK (EBT_LOG_IP | EBT_LOG_ARP)
+#define EBT_LOG_MASK (EBT_LOG_IP | EBT_LOG_ARP | EBT_LOG_NFLOG)
 #define EBT_LOG_PREFIX_SIZE 30
 #define EBT_LOG_WATCHER "log"
 
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 8bf6d9f..905087e 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -29,4 +29,4 @@ obj-$(CONFIG_BRIDGE_EBT_SNAT) += ebt_sna
 
 # watchers
 obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_log.o
-obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_ulog.o
+obj-$(CONFIG_BRIDGE_EBT_ULOG) += ebt_ulog.o
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 288ff1d..a1cb46a 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -67,8 +67,13 @@ ebt_log_packet(unsigned int pf, unsigned
 {
 	unsigned int bitmask;
 
+	if (!loginfo)
+		return;  /* FIXME: we should add a default_loginfo here */
+	if (!(loginfo->backends & NF_LOG_BACKEND_SYSLOG))
+		return;
+
 	spin_lock_bh(&ebt_log_lock);
-	printk("<%c>%s IN=%s OUT=%s MAC source = ", '0' + loginfo->u.log.level,
+	printk("<%c>%s IN=%s OUT=%s MAC source = ", '0' + loginfo->level,
 	       prefix, in ? in->name : "", out ? out->name : "");
 
 	print_MAC(eth_hdr(skb)->h_source);
@@ -77,10 +82,7 @@ ebt_log_packet(unsigned int pf, unsigned
 
 	printk("proto = 0x%04x", ntohs(eth_hdr(skb)->h_proto));
 
-	if (loginfo->type == NF_LOG_TYPE_LOG)
-		bitmask = loginfo->u.log.logflags;
-	else
-		bitmask = NF_LOG_MASK;
+	bitmask = loginfo->logflags;
 
 	if ((bitmask & EBT_LOG_IP) && eth_hdr(skb)->h_proto ==
 	   htons(ETH_P_IP)){
@@ -162,16 +164,14 @@ static void ebt_log(const struct sk_buff
 	struct ebt_log_info *info = (struct ebt_log_info *)data;
 	struct nf_loginfo li;
 
-	li.type = NF_LOG_TYPE_LOG;
-	li.u.log.level = info->loglevel;
-	li.u.log.logflags = info->bitmask;
+	li.backends = NF_LOG_BACKEND_SYSLOG; /* currently only syslog backend supported */
+	li.level = info->loglevel;
+	/* XXX: info->bitmask is 32 bit, logflas only 8 
+	 * Currently it's not a problem, since only 3 falgs are defined, but nevertheless */
+	li.logflags = info->bitmask;
 
-	if (info->bitmask & EBT_LOG_NFLOG)
-		nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
+	nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
 		              info->prefix);
-	else
-		ebt_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
-		               info->prefix);
 }
 
 static struct ebt_watcher log =
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 802baf7..d06c67d 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -218,28 +218,6 @@ alloc_failure:
 	goto unlock;
 }
 
-/* this function is registered with the netfilter core */
-static void ebt_log_packet(unsigned int pf, unsigned int hooknum,
-   const struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out, const struct nf_loginfo *li,
-   const char *prefix)
-{
-	struct ebt_ulog_info loginfo;
-
-	if (!li || li->type != NF_LOG_TYPE_ULOG) {
-		loginfo.nlgroup = EBT_ULOG_DEFAULT_NLGROUP;
-		loginfo.cprange = 0;
-		loginfo.qthreshold = EBT_ULOG_DEFAULT_QTHRESHOLD;
-		loginfo.prefix[0] = '\0';
-	} else {
-		loginfo.nlgroup = li->u.ulog.group;
-		loginfo.cprange = li->u.ulog.copy_len;
-		loginfo.qthreshold = li->u.ulog.qthreshold;
-		strlcpy(loginfo.prefix, prefix, sizeof(loginfo.prefix));
-	}
-
-	ebt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
-}
 
 static void ebt_ulog(const struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
@@ -275,12 +253,6 @@ static struct ebt_watcher ulog = {
 	.me		= THIS_MODULE,
 };
 
-static struct nf_logger ebt_ulog_logger = {
-	.name		= EBT_ULOG_WATCHER,
-	.logfn		= &ebt_log_packet,
-	.me		= THIS_MODULE,
-};
-
 static int __init init(void)
 {
 	int i, ret = 0;
@@ -306,13 +278,6 @@ static int __init init(void)
 	else if ((ret = ebt_register_watcher(&ulog)))
 		sock_release(ebtulognl->sk_socket);
 
-	if (nf_log_register(PF_BRIDGE, &ebt_ulog_logger) < 0) {
-		printk(KERN_WARNING "ebt_ulog: not logging via ulog "
-		       "since somebody else already registered for PF_BRIDGE\n");
-		/* we cannot make module load fail here, since otherwise
-		 * ebtables userspace would abort */
-	}
-
 	return ret;
 }
 
@@ -321,7 +286,6 @@ static void __exit fini(void)
 	ebt_ulog_buff_t *ub;
 	int i;
 
-	nf_log_unregister_logger(&ebt_ulog_logger);
 	ebt_unregister_watcher(&ulog);
 	for (i = 0; i < EBT_ULOG_MAXNLGROUPS; i++) {
 		ub = &ulog_buffers[i];
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 933ee7a..a875596 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -313,6 +313,17 @@ config IP_NF_FILTER
 	  local output.  See the man page for iptables(8).
 
 	  To compile it as a module, choose M here.  If unsure, say N.
+	  
+config IP_NF_LOG_SYSLOG
+	tristate "Syslog backend for LOG target"
+	depends on IP_NF_IPTABLES
+	help
+	  This option adds a log backend, which allows you to create rules in
+	  any iptables table which records the packet header to the syslog.
+	  See NF_XTABLES_TARGET_LOG
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 
 config IP_NF_TARGET_REJECT
 	tristate "REJECT target support"
@@ -324,15 +335,6 @@ config IP_NF_TARGET_REJECT
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_TARGET_LOG
-	tristate "LOG target support"
-	depends on IP_NF_IPTABLES
-	help
-	  This option adds a `LOG' target, which allows you to create rules in
-	  any iptables table which records the packet header to the syslog.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_TARGET_ULOG
 	tristate "ULOG target support (OBSOLETE)"
 	depends on IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 3fe8092..8032d65 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -45,6 +45,9 @@ obj-$(CONFIG_IP_NF_MANGLE) += iptable_ma
 obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 
+# Syslog backend support
+obj-$(CONFIG_IP_NF_LOG_SYSLOG) += ip_log_syslog.o
+
 # matches
 obj-$(CONFIG_IP_NF_MATCH_HASHLIMIT) += ipt_hashlimit.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
@@ -68,7 +71,6 @@ obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += i
 obj-$(CONFIG_IP_NF_TARGET_NETMAP) += ipt_NETMAP.o
 obj-$(CONFIG_IP_NF_TARGET_SAME) += ipt_SAME.o
 obj-$(CONFIG_IP_NF_NAT_SNMP_BASIC) += ip_nat_snmp_basic.o
-obj-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 obj-$(CONFIG_IP_NF_TARGET_TCPMSS) += ipt_TCPMSS.o
 obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) += ipt_CLUSTERIP.o
diff --git a/net/ipv4/netfilter/ip_log_syslog.c b/net/ipv4/netfilter/ip_log_syslog.c
new file mode 100644
index 0000000..8463ba9
--- /dev/null
+++ b/net/ipv4/netfilter/ip_log_syslog.c
@@ -0,0 +1,437 @@
+/*
+ * This is a module which is used for logging packets.
+ */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * 2006-03-04 Gregor Maier <greogr@majordomus.org>
+ * 	Unified logging. Use nf_log for everything. Create xt_LOG target
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/icmp.h>
+#include <net/udp.h>
+#include <net/tcp.h>
+#include <net/route.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/xt_LOG.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables syslog logging module");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+/* Use lock to serialize, so printks don't overlap */
+static DEFINE_SPINLOCK(log_lock);
+
+/* One level of recursion won't kill us */
+static void dump_packet(const struct nf_loginfo *info,
+			const struct sk_buff *skb,
+			unsigned int iphoff)
+{
+	struct iphdr _iph, *ih;
+	unsigned int logflags;
+
+	logflags = info->logflags;
+
+	ih = skb_header_pointer(skb, iphoff, sizeof(_iph), &_iph);
+	if (ih == NULL) {
+		printk("TRUNCATED");
+		return;
+	}
+
+	/* Important fields:
+	 * TOS, len, DF/MF, fragment offset, TTL, src, dst, options. */
+	/* Max length: 40 "SRC=255.255.255.255 DST=255.255.255.255 " */
+	printk("SRC=%u.%u.%u.%u DST=%u.%u.%u.%u ",
+	       NIPQUAD(ih->saddr), NIPQUAD(ih->daddr));
+
+	/* Max length: 46 "LEN=65535 TOS=0xFF PREC=0xFF TTL=255 ID=65535 " */
+	printk("LEN=%u TOS=0x%02X PREC=0x%02X TTL=%u ID=%u ",
+	       ntohs(ih->tot_len), ih->tos & IPTOS_TOS_MASK,
+	       ih->tos & IPTOS_PREC_MASK, ih->ttl, ntohs(ih->id));
+
+	/* Max length: 6 "CE DF MF " */
+	if (ntohs(ih->frag_off) & IP_CE)
+		printk("CE ");
+	if (ntohs(ih->frag_off) & IP_DF)
+		printk("DF ");
+	if (ntohs(ih->frag_off) & IP_MF)
+		printk("MF ");
+
+	/* Max length: 11 "FRAG:65535 " */
+	if (ntohs(ih->frag_off) & IP_OFFSET)
+		printk("FRAG:%u ", ntohs(ih->frag_off) & IP_OFFSET);
+
+	if ((logflags & XT_LOG_IPOPT)
+	    && ih->ihl * 4 > sizeof(struct iphdr)) {
+		unsigned char _opt[4 * 15 - sizeof(struct iphdr)], *op;
+		unsigned int i, optsize;
+
+		optsize = ih->ihl * 4 - sizeof(struct iphdr);
+		op = skb_header_pointer(skb, iphoff+sizeof(_iph),
+					optsize, _opt);
+		if (op == NULL) {
+			printk("TRUNCATED");
+			return;
+		}
+
+		/* Max length: 127 "OPT (" 15*4*2chars ") " */
+		printk("OPT (");
+		for (i = 0; i < optsize; i++)
+			printk("%02X", op[i]);
+		printk(") ");
+	}
+
+	switch (ih->protocol) {
+	case IPPROTO_TCP: {
+		struct tcphdr _tcph, *th;
+
+		/* Max length: 10 "PROTO=TCP " */
+		printk("PROTO=TCP ");
+
+		if (ntohs(ih->frag_off) & IP_OFFSET)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		th = skb_header_pointer(skb, iphoff + ih->ihl * 4,
+					sizeof(_tcph), &_tcph);
+		if (th == NULL) {
+			printk("INCOMPLETE [%u bytes] ",
+			       skb->len - iphoff - ih->ihl*4);
+			break;
+		}
+
+		/* Max length: 20 "SPT=65535 DPT=65535 " */
+		printk("SPT=%u DPT=%u ",
+		       ntohs(th->source), ntohs(th->dest));
+		/* Max length: 30 "SEQ=4294967295 ACK=4294967295 " */
+		if (logflags & XT_LOG_TCPSEQ)
+			printk("SEQ=%u ACK=%u ",
+			       ntohl(th->seq), ntohl(th->ack_seq));
+		/* Max length: 13 "WINDOW=65535 " */
+		printk("WINDOW=%u ", ntohs(th->window));
+		/* Max length: 9 "RES=0x3F " */
+		printk("RES=0x%02x ", (u8)(ntohl(tcp_flag_word(th) & TCP_RESERVED_BITS) >> 22));
+		/* Max length: 32 "CWR ECE URG ACK PSH RST SYN FIN " */
+		if (th->cwr)
+			printk("CWR ");
+		if (th->ece)
+			printk("ECE ");
+		if (th->urg)
+			printk("URG ");
+		if (th->ack)
+			printk("ACK ");
+		if (th->psh)
+			printk("PSH ");
+		if (th->rst)
+			printk("RST ");
+		if (th->syn)
+			printk("SYN ");
+		if (th->fin)
+			printk("FIN ");
+		/* Max length: 11 "URGP=65535 " */
+		printk("URGP=%u ", ntohs(th->urg_ptr));
+
+		if ((logflags & XT_LOG_TCPOPT)
+		    && th->doff * 4 > sizeof(struct tcphdr)) {
+			unsigned char _opt[4 * 15 - sizeof(struct tcphdr)];
+			unsigned char *op;
+			unsigned int i, optsize;
+
+			optsize = th->doff * 4 - sizeof(struct tcphdr);
+			op = skb_header_pointer(skb,
+						iphoff+ih->ihl*4+sizeof(_tcph),
+						optsize, _opt);
+			if (op == NULL) {
+				printk("TRUNCATED");
+				return;
+			}
+
+			/* Max length: 127 "OPT (" 15*4*2chars ") " */
+			printk("OPT (");
+			for (i = 0; i < optsize; i++)
+				printk("%02X", op[i]);
+			printk(") ");
+		}
+		break;
+	}
+	case IPPROTO_UDP: {
+		struct udphdr _udph, *uh;
+
+		/* Max length: 10 "PROTO=UDP " */
+		printk("PROTO=UDP ");
+
+		if (ntohs(ih->frag_off) & IP_OFFSET)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		uh = skb_header_pointer(skb, iphoff+ih->ihl*4,
+					sizeof(_udph), &_udph);
+		if (uh == NULL) {
+			printk("INCOMPLETE [%u bytes] ",
+			       skb->len - iphoff - ih->ihl*4);
+			break;
+		}
+
+		/* Max length: 20 "SPT=65535 DPT=65535 " */
+		printk("SPT=%u DPT=%u LEN=%u ",
+		       ntohs(uh->source), ntohs(uh->dest),
+		       ntohs(uh->len));
+		break;
+	}
+	case IPPROTO_ICMP: {
+		struct icmphdr _icmph, *ich;
+		static const size_t required_len[NR_ICMP_TYPES+1]
+			= { [ICMP_ECHOREPLY] = 4,
+			    [ICMP_DEST_UNREACH]
+			    = 8 + sizeof(struct iphdr),
+			    [ICMP_SOURCE_QUENCH]
+			    = 8 + sizeof(struct iphdr),
+			    [ICMP_REDIRECT]
+			    = 8 + sizeof(struct iphdr),
+			    [ICMP_ECHO] = 4,
+			    [ICMP_TIME_EXCEEDED]
+			    = 8 + sizeof(struct iphdr),
+			    [ICMP_PARAMETERPROB]
+			    = 8 + sizeof(struct iphdr),
+			    [ICMP_TIMESTAMP] = 20,
+			    [ICMP_TIMESTAMPREPLY] = 20,
+			    [ICMP_ADDRESS] = 12,
+			    [ICMP_ADDRESSREPLY] = 12 };
+
+		/* Max length: 11 "PROTO=ICMP " */
+		printk("PROTO=ICMP ");
+
+		if (ntohs(ih->frag_off) & IP_OFFSET)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		ich = skb_header_pointer(skb, iphoff + ih->ihl * 4,
+					 sizeof(_icmph), &_icmph);
+		if (ich == NULL) {
+			printk("INCOMPLETE [%u bytes] ",
+			       skb->len - iphoff - ih->ihl*4);
+			break;
+		}
+
+		/* Max length: 18 "TYPE=255 CODE=255 " */
+		printk("TYPE=%u CODE=%u ", ich->type, ich->code);
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		if (ich->type <= NR_ICMP_TYPES
+		    && required_len[ich->type]
+		    && skb->len-iphoff-ih->ihl*4 < required_len[ich->type]) {
+			printk("INCOMPLETE [%u bytes] ",
+			       skb->len - iphoff - ih->ihl*4);
+			break;
+		}
+
+		switch (ich->type) {
+		case ICMP_ECHOREPLY:
+		case ICMP_ECHO:
+			/* Max length: 19 "ID=65535 SEQ=65535 " */
+			printk("ID=%u SEQ=%u ",
+			       ntohs(ich->un.echo.id),
+			       ntohs(ich->un.echo.sequence));
+			break;
+
+		case ICMP_PARAMETERPROB:
+			/* Max length: 14 "PARAMETER=255 " */
+			printk("PARAMETER=%u ",
+			       ntohl(ich->un.gateway) >> 24);
+			break;
+		case ICMP_REDIRECT:
+			/* Max length: 24 "GATEWAY=255.255.255.255 " */
+			printk("GATEWAY=%u.%u.%u.%u ",
+			       NIPQUAD(ich->un.gateway));
+			/* Fall through */
+		case ICMP_DEST_UNREACH:
+		case ICMP_SOURCE_QUENCH:
+		case ICMP_TIME_EXCEEDED:
+			/* Max length: 3+maxlen */
+			if (!iphoff) { /* Only recurse once. */
+				printk("[");
+				dump_packet(info, skb,
+					    iphoff + ih->ihl*4+sizeof(_icmph));
+				printk("] ");
+			}
+
+			/* Max length: 10 "MTU=65535 " */
+			if (ich->type == ICMP_DEST_UNREACH
+			    && ich->code == ICMP_FRAG_NEEDED)
+				printk("MTU=%u ", ntohs(ich->un.frag.mtu));
+		}
+		break;
+	}
+	/* Max Length */
+	case IPPROTO_AH: {
+		struct ip_auth_hdr _ahdr, *ah;
+
+		if (ntohs(ih->frag_off) & IP_OFFSET)
+			break;
+		
+		/* Max length: 9 "PROTO=AH " */
+		printk("PROTO=AH ");
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		ah = skb_header_pointer(skb, iphoff+ih->ihl*4,
+					sizeof(_ahdr), &_ahdr);
+		if (ah == NULL) {
+			printk("INCOMPLETE [%u bytes] ",
+			       skb->len - iphoff - ih->ihl*4);
+			break;
+		}
+
+		/* Length: 15 "SPI=0xF1234567 " */
+		printk("SPI=0x%x ", ntohl(ah->spi));
+		break;
+	}
+	case IPPROTO_ESP: {
+		struct ip_esp_hdr _esph, *eh;
+
+		/* Max length: 10 "PROTO=ESP " */
+		printk("PROTO=ESP ");
+
+		if (ntohs(ih->frag_off) & IP_OFFSET)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		eh = skb_header_pointer(skb, iphoff+ih->ihl*4,
+					sizeof(_esph), &_esph);
+		if (eh == NULL) {
+			printk("INCOMPLETE [%u bytes] ",
+			       skb->len - iphoff - ih->ihl*4);
+			break;
+		}
+
+		/* Length: 15 "SPI=0xF1234567 " */
+		printk("SPI=0x%x ", ntohl(eh->spi));
+		break;
+	}
+	/* Max length: 10 "PROTO 255 " */
+	default:
+		printk("PROTO=%u ", ih->protocol);
+	}
+
+	/* Max length: 15 "UID=4294967295 " */
+ 	if ((logflags & XT_LOG_UID) && !iphoff && skb->sk) {
+		read_lock_bh(&skb->sk->sk_callback_lock);
+		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
+ 			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+		read_unlock_bh(&skb->sk->sk_callback_lock);
+	}
+
+	/* Proto    Max log string length */
+	/* IP:      40+46+6+11+127 = 230 */
+	/* TCP:     10+max(25,20+30+13+9+32+11+127) = 252 */
+	/* UDP:     10+max(25,20) = 35 */
+	/* ICMP:    11+max(25, 18+25+max(19,14,24+3+n+10,3+n+10)) = 91+n */
+	/* ESP:     10+max(25)+15 = 50 */
+	/* AH:      9+max(25)+15 = 49 */
+	/* unknown: 10 */
+
+	/* (ICMP allows recursion one level deep) */
+	/* maxlen =  IP + ICMP +  IP + max(TCP,UDP,ICMP,unknown) */
+	/* maxlen = 230+   91  + 230 + 252 = 803 */
+}
+
+static struct nf_loginfo default_loginfo = {
+	.backends = NF_LOG_BACKEND_SYSLOG,
+	.level    = 0,
+	.logflags = NF_LOG_MASK,
+	/* other fields ignores, since only using SYSLOG backend */
+};
+
+static void
+ip_log_syslog_packet(unsigned int pf,
+	       unsigned int hooknum,
+	       const struct sk_buff *skb,
+	       const struct net_device *in,
+	       const struct net_device *out,
+	       const struct nf_loginfo *loginfo,
+	       const char *prefix)
+{
+	/* Syslog backend is responsible if no loginfo has be specified */
+	if (!loginfo)
+		loginfo = &default_loginfo;
+	/* Are we responsible for this packet ? */
+	if (!(loginfo->backends & NF_LOG_BACKEND_SYSLOG))
+		return;
+
+	spin_lock_bh(&log_lock);
+	printk("<%d>%sIN=%s OUT=%s ", loginfo->level,
+	       prefix,
+	       in ? in->name : "",
+	       out ? out->name : "");
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (skb->nf_bridge) {
+		struct net_device *physindev = skb->nf_bridge->physindev;
+		struct net_device *physoutdev = skb->nf_bridge->physoutdev;
+
+		if (physindev && in != physindev)
+			printk("PHYSIN=%s ", physindev->name);
+		if (physoutdev && out != physoutdev)
+			printk("PHYSOUT=%s ", physoutdev->name);
+	}
+#endif
+
+	if (in && !out) {
+		/* MAC logging for input chain only. */
+		printk("MAC=");
+		if (skb->dev && skb->dev->hard_header_len
+		    && skb->mac.raw != (void*)skb->nh.iph) {
+			int i;
+			unsigned char *p = skb->mac.raw;
+			for (i = 0; i < skb->dev->hard_header_len; i++,p++)
+				printk("%02x%c", *p,
+				       i==skb->dev->hard_header_len - 1
+				       ? ' ':':');
+		} else
+			printk(" ");
+	}
+
+	dump_packet(loginfo, skb, 0);
+	printk("\n");
+	spin_unlock_bh(&log_lock);
+}
+
+static struct nf_logger ip_syslog_logger ={
+	.name		= "ip_log_syslog",
+	.logfn		= &ip_log_syslog_packet,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	if (nf_log_register(PF_INET, &ip_syslog_logger) < 0) {
+		printk(KERN_WARNING "ip_log_syslog: not logging via system console "
+		       "since somebody else already registered for PF_INET\n");
+		/* we cannot make module load fail here, since otherwise
+		 * iptables userspace would abort */
+	}
+	
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	nf_log_unregister_logger(&ip_syslog_logger);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index a82a32e..1c184c7 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -15,6 +15,7 @@
  * 2002/10/30 fix uninitialized mac_len field - <Anders K. Pedersen>
  * 2004/10/25 fix erroneous calculation of 'len' parameter to NLMSG_PUT
  *	      resulting in bogus 'error during NLMSG_PUT' messages.
+ *	2006/03/04 make ULOG self-contained without interaction with nf_log
  *
  * (C) 1999-2001 Paul `Rusty' Russell
  * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
@@ -313,31 +314,6 @@ static unsigned int ipt_ulog_target(stru
  	return IPT_CONTINUE;
 }
  
-static void ipt_logfn(unsigned int pf,
-		      unsigned int hooknum,
-		      const struct sk_buff *skb,
-		      const struct net_device *in,
-		      const struct net_device *out,
-		      const struct nf_loginfo *li,
-		      const char *prefix)
-{
-	struct ipt_ulog_info loginfo;
-
-	if (!li || li->type != NF_LOG_TYPE_ULOG) {
-		loginfo.nl_group = ULOG_DEFAULT_NLGROUP;
-		loginfo.copy_range = 0;
-		loginfo.qthreshold = ULOG_DEFAULT_QTHRESHOLD;
-		loginfo.prefix[0] = '\0';
-	} else {
-		loginfo.nl_group = li->u.ulog.group;
-		loginfo.copy_range = li->u.ulog.copy_len;
-		loginfo.qthreshold = li->u.ulog.qthreshold;
-		strlcpy(loginfo.prefix, prefix, sizeof(loginfo.prefix));
-	}
-
-	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
-}
-
 static int ipt_ulog_checkentry(const char *tablename,
 			       const void *e,
 			       const struct xt_target *target,
@@ -368,12 +344,6 @@ static struct ipt_target ipt_ulog_reg = 
 	.me		= THIS_MODULE,
 };
 
-static struct nf_logger ipt_ulog_logger = {
-	.name		= "ipt_ULOG",
-	.logfn		= ipt_logfn,
-	.me		= THIS_MODULE,
-};
-
 static int __init init(void)
 {
 	int i;
@@ -401,8 +371,6 @@ static int __init init(void)
 		sock_release(nflognl->sk_socket);
 		return -EINVAL;
 	}
-	if (nflog)
-		nf_log_register(PF_INET, &ipt_ulog_logger);
 	
 	return 0;
 }
@@ -414,8 +382,6 @@ static void __exit fini(void)
 
 	DEBUGP("ipt_ULOG: cleanup_module\n");
 
-	if (nflog)
-		nf_log_unregister_logger(&ipt_ulog_logger);
 	ipt_unregister_target(&ipt_ulog_reg);
 	sock_release(nflognl->sk_socket);
 
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 98f7875..db49c5c 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -144,15 +144,17 @@ config IP6_NF_FILTER
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP6_NF_TARGET_LOG
-	tristate "LOG target support"
-	depends on IP6_NF_FILTER
+config IP6_NF_LOG_SYSLOG
+	tristate "Syslog backend for LOG target"
+	depends on IP_NF_IPTABLES
 	help
-	  This option adds a `LOG' target, which allows you to create rules in
+	  This option adds a log backend, which allows you to create rules in
 	  any iptables table which records the packet header to the syslog.
+	  See NF_XTABLES_TARGET_LOG
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+
 config IP6_NF_TARGET_REJECT
 	tristate "REJECT target support"
 	depends on IP6_NF_FILTER
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 8436a1a..418dfa4 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -4,6 +4,7 @@
 
 # Link order matters here.
 obj-$(CONFIG_IP6_NF_IPTABLES) += ip6_tables.o
+obj-$(CONFIG_IP6_NF_LOG_SYSLOG) += ip6_log_syslog.o
 obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
 obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o ip6t_dst.o
 obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) += ip6t_ipv6header.o
@@ -16,7 +17,6 @@ obj-$(CONFIG_IP6_NF_FILTER) += ip6table_
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
 obj-$(CONFIG_IP6_NF_TARGET_HL) += ip6t_HL.o
 obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
-obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
 obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
 obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
 obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
diff --git a/net/ipv6/netfilter/ip6_log_syslog.c b/net/ipv6/netfilter/ip6_log_syslog.c
new file mode 100644
index 0000000..0a1d62c
--- /dev/null
+++ b/net/ipv6/netfilter/ip6_log_syslog.c
@@ -0,0 +1,449 @@
+/*
+ * This is a module which is used for logging packets.
+ */
+
+/* (C) 2001 Jan Rekorajski <baggins@pld.org.pl>
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * 2006-03-04 Gregor Maier <greogr@majordomus.org>
+ * 	Unified logging. Use nf_log for everything. Create xt_LOG target
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/skbuff.h>
+#include <linux/if_arp.h>
+#include <linux/ip.h>
+#include <linux/spinlock.h>
+#include <linux/icmpv6.h>
+#include <net/udp.h>
+#include <net/tcp.h>
+#include <net/ipv6.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+MODULE_AUTHOR("Jan Rekorajski <baggins@pld.org.pl>");
+MODULE_DESCRIPTION("IP6 tables syslog logging module");
+MODULE_LICENSE("GPL");
+
+struct in_device;
+#include <net/route.h>
+#include <linux/netfilter/xt_LOG.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+/* Use lock to serialize, so printks don't overlap */
+static DEFINE_SPINLOCK(log_lock);
+
+/* One level of recursion won't kill us */
+static void dump_packet(const struct nf_loginfo *info,
+			const struct sk_buff *skb, unsigned int ip6hoff,
+			int recurse)
+{
+	u_int8_t currenthdr;
+	int fragment;
+	struct ipv6hdr _ip6h, *ih;
+	unsigned int ptr;
+	unsigned int hdrlen = 0;
+	unsigned int logflags;
+
+	logflags = info->logflags;
+
+	ih = skb_header_pointer(skb, ip6hoff, sizeof(_ip6h), &_ip6h);
+	if (ih == NULL) {
+		printk("TRUNCATED");
+		return;
+	}
+
+	/* Max length: 88 "SRC=0000.0000.0000.0000.0000.0000.0000.0000 DST=0000.0000.0000.0000.0000.0000.0000.0000 " */
+	printk("SRC=" NIP6_FMT " DST=" NIP6_FMT " ", NIP6(ih->saddr), NIP6(ih->daddr));
+
+	/* Max length: 44 "LEN=65535 TC=255 HOPLIMIT=255 FLOWLBL=FFFFF " */
+	printk("LEN=%Zu TC=%u HOPLIMIT=%u FLOWLBL=%u ",
+	       ntohs(ih->payload_len) + sizeof(struct ipv6hdr),
+	       (ntohl(*(u_int32_t *)ih) & 0x0ff00000) >> 20,
+	       ih->hop_limit,
+	       (ntohl(*(u_int32_t *)ih) & 0x000fffff));
+
+	fragment = 0;
+	ptr = ip6hoff + sizeof(struct ipv6hdr);
+	currenthdr = ih->nexthdr;
+	while (currenthdr != NEXTHDR_NONE && ip6t_ext_hdr(currenthdr)) {
+		struct ipv6_opt_hdr _hdr, *hp;
+
+		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
+		if (hp == NULL) {
+			printk("TRUNCATED");
+			return;
+		}
+
+		/* Max length: 48 "OPT (...) " */
+		if (logflags & XT_LOG_IPOPT)
+			printk("OPT ( ");
+
+		switch (currenthdr) {
+		case IPPROTO_FRAGMENT: {
+			struct frag_hdr _fhdr, *fh;
+
+			printk("FRAG:");
+			fh = skb_header_pointer(skb, ptr, sizeof(_fhdr),
+						&_fhdr);
+			if (fh == NULL) {
+				printk("TRUNCATED ");
+				return;
+			}
+
+			/* Max length: 6 "65535 " */
+			printk("%u ", ntohs(fh->frag_off) & 0xFFF8);
+
+			/* Max length: 11 "INCOMPLETE " */
+			if (fh->frag_off & htons(0x0001))
+				printk("INCOMPLETE ");
+
+			printk("ID:%08x ", ntohl(fh->identification));
+
+			if (ntohs(fh->frag_off) & 0xFFF8)
+				fragment = 1;
+
+			hdrlen = 8;
+
+			break;
+		}
+		case IPPROTO_DSTOPTS:
+		case IPPROTO_ROUTING:
+		case IPPROTO_HOPOPTS:
+			if (fragment) {
+				if (logflags & XT_LOG_IPOPT)
+					printk(")");
+				return;
+			}
+			hdrlen = ipv6_optlen(hp);
+			break;
+		/* Max Length */
+		case IPPROTO_AH:
+			if (logflags & XT_LOG_IPOPT) {
+				struct ip_auth_hdr _ahdr, *ah;
+
+				/* Max length: 3 "AH " */
+				printk("AH ");
+
+				if (fragment) {
+					printk(")");
+					return;
+				}
+
+				ah = skb_header_pointer(skb, ptr, sizeof(_ahdr),
+							&_ahdr);
+				if (ah == NULL) {
+					/*
+					 * Max length: 26 "INCOMPLETE [65535 	
+					 *  bytes] )"
+					 */
+					printk("INCOMPLETE [%u bytes] )",
+					       skb->len - ptr);
+					return;
+				}
+
+				/* Length: 15 "SPI=0xF1234567 */
+				printk("SPI=0x%x ", ntohl(ah->spi));
+
+			}
+
+			hdrlen = (hp->hdrlen+2)<<2;
+			break;
+		case IPPROTO_ESP:
+			if (logflags & XT_LOG_IPOPT) {
+				struct ip_esp_hdr _esph, *eh;
+
+				/* Max length: 4 "ESP " */
+				printk("ESP ");
+
+				if (fragment) {
+					printk(")");
+					return;
+				}
+
+				/*
+				 * Max length: 26 "INCOMPLETE [65535 bytes] )"
+				 */
+				eh = skb_header_pointer(skb, ptr, sizeof(_esph),
+							&_esph);
+				if (eh == NULL) {
+					printk("INCOMPLETE [%u bytes] )",
+					       skb->len - ptr);
+					return;
+				}
+
+				/* Length: 16 "SPI=0xF1234567 )" */
+				printk("SPI=0x%x )", ntohl(eh->spi) );
+
+			}
+			return;
+		default:
+			/* Max length: 20 "Unknown Ext Hdr 255" */
+			printk("Unknown Ext Hdr %u", currenthdr);
+			return;
+		}
+		if (logflags & XT_LOG_IPOPT)
+			printk(") ");
+
+		currenthdr = hp->nexthdr;
+		ptr += hdrlen;
+	}
+
+	switch (currenthdr) {
+	case IPPROTO_TCP: {
+		struct tcphdr _tcph, *th;
+
+		/* Max length: 10 "PROTO=TCP " */
+		printk("PROTO=TCP ");
+
+		if (fragment)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		th = skb_header_pointer(skb, ptr, sizeof(_tcph), &_tcph);
+		if (th == NULL) {
+			printk("INCOMPLETE [%u bytes] ", skb->len - ptr);
+			return;
+		}
+
+		/* Max length: 20 "SPT=65535 DPT=65535 " */
+		printk("SPT=%u DPT=%u ",
+		       ntohs(th->source), ntohs(th->dest));
+		/* Max length: 30 "SEQ=4294967295 ACK=4294967295 " */
+		if (logflags & XT_LOG_TCPSEQ)
+			printk("SEQ=%u ACK=%u ",
+			       ntohl(th->seq), ntohl(th->ack_seq));
+		/* Max length: 13 "WINDOW=65535 " */
+		printk("WINDOW=%u ", ntohs(th->window));
+		/* Max length: 9 "RES=0x3C " */
+		printk("RES=0x%02x ", (u_int8_t)(ntohl(tcp_flag_word(th) & TCP_RESERVED_BITS) >> 22));
+		/* Max length: 32 "CWR ECE URG ACK PSH RST SYN FIN " */
+		if (th->cwr)
+			printk("CWR ");
+		if (th->ece)
+			printk("ECE ");
+		if (th->urg)
+			printk("URG ");
+		if (th->ack)
+			printk("ACK ");
+		if (th->psh)
+			printk("PSH ");
+		if (th->rst)
+			printk("RST ");
+		if (th->syn)
+			printk("SYN ");
+		if (th->fin)
+			printk("FIN ");
+		/* Max length: 11 "URGP=65535 " */
+		printk("URGP=%u ", ntohs(th->urg_ptr));
+
+		if ((logflags & XT_LOG_TCPOPT)
+		    && th->doff * 4 > sizeof(struct tcphdr)) {
+			u_int8_t _opt[60 - sizeof(struct tcphdr)], *op;
+			unsigned int i;
+			unsigned int optsize = th->doff * 4
+					       - sizeof(struct tcphdr);
+
+			op = skb_header_pointer(skb,
+						ptr + sizeof(struct tcphdr),
+						optsize, _opt);
+			if (op == NULL) {
+				printk("OPT (TRUNCATED)");
+				return;
+			}
+
+			/* Max length: 127 "OPT (" 15*4*2chars ") " */
+			printk("OPT (");
+			for (i =0; i < optsize; i++)
+				printk("%02X", op[i]);
+			printk(") ");
+		}
+		break;
+	}
+	case IPPROTO_UDP: {
+		struct udphdr _udph, *uh;
+
+		/* Max length: 10 "PROTO=UDP " */
+		printk("PROTO=UDP ");
+
+		if (fragment)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		uh = skb_header_pointer(skb, ptr, sizeof(_udph), &_udph);
+		if (uh == NULL) {
+			printk("INCOMPLETE [%u bytes] ", skb->len - ptr);
+			return;
+		}
+
+		/* Max length: 20 "SPT=65535 DPT=65535 " */
+		printk("SPT=%u DPT=%u LEN=%u ",
+		       ntohs(uh->source), ntohs(uh->dest),
+		       ntohs(uh->len));
+		break;
+	}
+	case IPPROTO_ICMPV6: {
+		struct icmp6hdr _icmp6h, *ic;
+
+		/* Max length: 13 "PROTO=ICMPv6 " */
+		printk("PROTO=ICMPv6 ");
+
+		if (fragment)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		ic = skb_header_pointer(skb, ptr, sizeof(_icmp6h), &_icmp6h);
+		if (ic == NULL) {
+			printk("INCOMPLETE [%u bytes] ", skb->len - ptr);
+			return;
+		}
+
+		/* Max length: 18 "TYPE=255 CODE=255 " */
+		printk("TYPE=%u CODE=%u ", ic->icmp6_type, ic->icmp6_code);
+
+		switch (ic->icmp6_type) {
+		case ICMPV6_ECHO_REQUEST:
+		case ICMPV6_ECHO_REPLY:
+			/* Max length: 19 "ID=65535 SEQ=65535 " */
+			printk("ID=%u SEQ=%u ",
+				ntohs(ic->icmp6_identifier),
+				ntohs(ic->icmp6_sequence));
+			break;
+		case ICMPV6_MGM_QUERY:
+		case ICMPV6_MGM_REPORT:
+		case ICMPV6_MGM_REDUCTION:
+			break;
+
+		case ICMPV6_PARAMPROB:
+			/* Max length: 17 "POINTER=ffffffff " */
+			printk("POINTER=%08x ", ntohl(ic->icmp6_pointer));
+			/* Fall through */
+		case ICMPV6_DEST_UNREACH:
+		case ICMPV6_PKT_TOOBIG:
+		case ICMPV6_TIME_EXCEED:
+			/* Max length: 3+maxlen */
+			if (recurse) {
+				printk("[");
+				dump_packet(info, skb, ptr + sizeof(_icmp6h),
+					    0);
+				printk("] ");
+			}
+
+			/* Max length: 10 "MTU=65535 " */
+			if (ic->icmp6_type == ICMPV6_PKT_TOOBIG)
+				printk("MTU=%u ", ntohl(ic->icmp6_mtu));
+		}
+		break;
+	}
+	/* Max length: 10 "PROTO=255 " */
+	default:
+		printk("PROTO=%u ", currenthdr);
+	}
+
+	/* Max length: 15 "UID=4294967295 " */
+	if ((logflags & XT_LOG_UID) && recurse && skb->sk) {
+		read_lock_bh(&skb->sk->sk_callback_lock);
+		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
+			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+		read_unlock_bh(&skb->sk->sk_callback_lock);
+	}
+}
+
+static struct nf_loginfo default_loginfo = {
+	.backends = NF_LOG_BACKEND_SYSLOG,
+	.level	  = 0,
+	.logflags = NF_LOG_MASK,
+	/* other fields ignores, since only using SYSLOG backend */
+};
+
+static void
+ip6_log_syslog_packet(unsigned int pf,
+		unsigned int hooknum,
+		const struct sk_buff *skb,
+		const struct net_device *in,
+		const struct net_device *out,
+		const struct nf_loginfo *loginfo,
+		const char *prefix)
+{
+	/* Syslog backend is responsible if no loginfo has be specified */
+	if (!loginfo)
+		loginfo = &default_loginfo;
+	/* Are we responsible for this packet ? */
+	if (!(loginfo->backends & NF_LOG_BACKEND_SYSLOG))
+		return;
+
+	spin_lock_bh(&log_lock);
+	printk("<%d>%sIN=%s OUT=%s ", loginfo->level, 
+		prefix,
+		in ? in->name : "",
+		out ? out->name : "");
+	if (in && !out) {
+		unsigned int len;
+		/* MAC logging for input chain only. */
+		printk("MAC=");
+		if (skb->dev && (len = skb->dev->hard_header_len) &&
+		    skb->mac.raw != skb->nh.raw) {
+			unsigned char *p = skb->mac.raw;
+			int i;
+
+			if (skb->dev->type == ARPHRD_SIT &&
+			    (p -= ETH_HLEN) < skb->head)
+				p = NULL;
+
+			if (p != NULL) {
+				for (i = 0; i < len; i++)
+					printk("%02x%s", p[i],
+					       i == len - 1 ? "" : ":");
+			}
+			printk(" ");
+
+			if (skb->dev->type == ARPHRD_SIT) {
+				struct iphdr *iph = (struct iphdr *)skb->mac.raw;
+				printk("TUNNEL=%u.%u.%u.%u->%u.%u.%u.%u ",
+				       NIPQUAD(iph->saddr),
+				       NIPQUAD(iph->daddr));
+			}
+		} else
+			printk(" ");
+	}
+
+	dump_packet(loginfo, skb, (u8*)skb->nh.ipv6h - skb->data, 1);
+	printk("\n");
+	spin_unlock_bh(&log_lock);
+}
+
+static struct nf_logger ip6_syslog_logger = {
+	.name		= "ip6_log_syslog",
+	.logfn		= &ip6_log_syslog_packet,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	if (nf_log_register(PF_INET6, &ip6_syslog_logger) < 0) {
+		printk(KERN_WARNING "ip6_log_syslog: not logging via system console "
+		       "since somebody else already registered for PF_INET6\n");
+		/* we cannot make module load fail here, since otherwise
+		 * ip6tables userspace would abort */
+	}
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	nf_log_unregister_logger(&ip6_syslog_logger);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1e6e311..e66fb3a 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -136,6 +136,17 @@ config NETFILTER_XT_TARGET_CONNMARK
 	  <file:Documentation/modules.txt>.  The module will be called
 	  ipt_CONNMARK.o.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_LOG
+	tristate '"LOG" target Support'
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `LOG' target, which allows you to create rules in
+	  any iptables table which records the packet registered loggers like
+	  NETFILTER_NETLINK_LOG, IP_NF_LOG_SYSLOG or IP6_NF_LOG_SYSLOG.
+
+	  To compile it as a module, choose M here. If unsure, say `N'.
+
+
 config NETFILTER_XT_TARGET_MARK
 	tristate '"MARK" target support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 9558727..f84601f 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_NETFILTER_XTABLES) += x_tab
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNMARK) += xt_CONNMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_LOG) += xt_LOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 3e76bd0..7a7ddb4 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -6,6 +6,8 @@
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
 #include <linux/seq_file.h>
+#include <linux/list.h>
+#include <linux/slab.h> /* for kmalloc */
 #include <net/protocol.h>
 
 #include "nf_internals.h"
@@ -15,14 +17,19 @@
 
 #define NF_LOG_PREFIXLEN		128
 
-static struct nf_logger *nf_logging[NPROTO]; /* = NULL */
+struct nf_logging_node {
+	struct list_head list;
+	struct nf_logger *logger;
+};
+
+static struct list_head nf_logging[NPROTO]; /* = NULL */
 static DEFINE_SPINLOCK(nf_log_lock);
 
-/* return EBUSY if somebody else is registered, EEXIST if the same logger
- * is registred, 0 on success. */
+/* EEXIST if the same logger is registred, 0 on success. */
 int nf_log_register(int pf, struct nf_logger *logger)
 {
-	int ret = -EBUSY;
+	struct nf_logging_node *node;
+	int ret = 0;
 
 	if (pf >= NPROTO)
 		return -EINVAL;
@@ -30,28 +37,50 @@ int nf_log_register(int pf, struct nf_lo
 	/* Any setup of logging members must be done before
 	 * substituting pointer. */
 	spin_lock(&nf_log_lock);
-	if (!nf_logging[pf]) {
-		rcu_assign_pointer(nf_logging[pf], logger);
-		ret = 0;
-	} else if (nf_logging[pf] == logger)
-		ret = -EEXIST;
-
+	/* Check if we are already registered */
+	list_for_each_entry(node, &nf_logging[pf], list) {
+		if (node->logger == logger) {
+			ret = -EEXIST;
+			goto reg_out;
+		}
+	}
+	node = kmalloc(sizeof(struct nf_logging_node), GFP_KERNEL);
+	if (!node) {
+		ret = -ENOMEM;
+		goto reg_out;
+	}
+	node->logger = logger;
+	list_add_rcu(&node->list, &nf_logging[pf]);
+	
+reg_out:
 	spin_unlock(&nf_log_lock);
+	synchronize_net();
 	return ret;
 }		
 EXPORT_SYMBOL(nf_log_register);
 
-int nf_log_unregister_pf(int pf)
+int nf_log_unregister_pf(int pf, struct nf_logger *logger)
 {
+	struct nf_logging_node *node; 
+	int do_kfree = 0;
+	
 	if (pf >= NPROTO)
 		return -EINVAL;
 
 	spin_lock(&nf_log_lock);
-	nf_logging[pf] = NULL;
+	list_for_each_entry(node, &nf_logging[pf], list) {
+		if (node->logger == logger) {
+			list_del_rcu(&node->list);
+			do_kfree=1;
+			break;
+		}
+	}
 	spin_unlock(&nf_log_lock);
 
 	/* Give time to concurrent readers. */
 	synchronize_net();
+	if (do_kfree)
+		kfree(node);
 
 	return 0;
 }
@@ -61,14 +90,10 @@ void nf_log_unregister_logger(struct nf_
 {
 	int i;
 
-	spin_lock(&nf_log_lock);
 	for (i = 0; i < NPROTO; i++) {
-		if (nf_logging[i] == logger)
-			nf_logging[i] = NULL;
+		nf_log_unregister_pf(i, logger);
 	}
-	spin_unlock(&nf_log_lock);
 
-	synchronize_net();
 }
 EXPORT_SYMBOL(nf_log_unregister_logger);
 
@@ -82,20 +107,25 @@ void nf_log_packet(int pf,
 {
 	va_list args;
 	char prefix[NF_LOG_PREFIXLEN];
-	struct nf_logger *logger;
+	struct nf_logging_node *node;
+	
+	if (pf >= NPROTO)
+		return;
 	
+	va_start(args, fmt);
+	vsnprintf(prefix, sizeof(prefix), fmt, args);
+	va_end(args);
+
 	rcu_read_lock();
-	logger = rcu_dereference(nf_logging[pf]);
-	if (logger) {
-		va_start(args, fmt);
-		vsnprintf(prefix, sizeof(prefix), fmt, args);
-		va_end(args);
-		/* We must read logging before nf_logfn[pf] */
-		logger->logfn(pf, hooknum, skb, in, out, loginfo, prefix);
-	} else if (net_ratelimit()) {
+	if (list_empty(&nf_logging[pf]) && net_ratelimit()) {
 		printk(KERN_WARNING "nf_log_packet: can\'t log since "
 		       "no backend logging module loaded in! Please either "
 		       "load one, or disable logging explicitly\n");
+		rcu_read_unlock();
+		return;
+	}
+	list_for_each_entry_rcu(node, &nf_logging[pf], list) {
+		node->logger->logfn(pf, hooknum, skb, in, out, loginfo, prefix);
 	}
 	rcu_read_unlock();
 }
@@ -130,14 +160,20 @@ static void seq_stop(struct seq_file *s,
 static int seq_show(struct seq_file *s, void *v)
 {
 	loff_t *pos = v;
-	const struct nf_logger *logger;
+	struct nf_logging_node *node;
 
-	logger = rcu_dereference(nf_logging[*pos]);
 
-	if (!logger)
+	if (list_empty(&nf_logging[*pos])) 
 		return seq_printf(s, "%2lld NONE\n", *pos);
+	if  (seq_printf(s, "%2lld", *pos) < 0)
+		return -1;
+
+	list_for_each_entry_rcu(node, &nf_logging[*pos], list) {
+		if (seq_printf(s, " %s", node->logger->name) < 0)
+			return -1; 
+	}
 	
-	return seq_printf(s, "%2lld %s\n", *pos, logger->name);
+	return seq_putc(s, '\n');
 }
 
 static struct seq_operations nflog_seq_ops = {
@@ -165,6 +201,8 @@ static struct file_operations nflog_file
 
 int __init netfilter_log_init(void)
 {
+	int i;
+
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *pde;
 
@@ -174,5 +212,9 @@ int __init netfilter_log_init(void)
 
 	pde->proc_fops = &nflog_file_ops;
 #endif
+
+	for (i = 0; i < NPROTO; i++) {
+		INIT_LIST_HEAD(&nf_logging[i]);
+	}
 	return 0;
 }
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index dfb25fd..e24a058 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -574,6 +574,7 @@ nfattr_failure:
 
 #define RCV_SKB_FAIL(err) do { netlink_ack(skb, nlh, (err)); return; } while (0)
 
+/*
 static struct nf_loginfo default_loginfo = {
 	.type =		NF_LOG_TYPE_ULOG,
 	.u = {
@@ -584,6 +585,7 @@ static struct nf_loginfo default_loginfo
 		},
 	},
 };
+*/
 
 /* log handler for internal netfilter logging api */
 static void
@@ -601,17 +603,17 @@ nfulnl_log_packet(unsigned int pf,
 	unsigned int qthreshold;
 	unsigned int nlbufsiz;
 
-	if (li_user && li_user->type == NF_LOG_TYPE_ULOG) 
+	if (li_user && (li_user->backends & NF_LOG_BACKEND_NFLOG)) 
 		li = li_user;
-	else
-		li = &default_loginfo;
+	else /* This packet  is none of our buisness */
+		return; 
 
-	inst = instance_lookup_get(li->u.ulog.group);
+	inst = instance_lookup_get(li->group);
 	if (!inst)
 		inst = instance_lookup_get(0);
 	if (!inst) {
 		PRINTR("nfnetlink_log: trying to log packet, "
-			"but no instance for group %u\n", li->u.ulog.group);
+			"but no instance for group %u\n", li->group);
 		return;
 	}
 
@@ -644,8 +646,8 @@ nfulnl_log_packet(unsigned int pf,
 
 	qthreshold = inst->qthreshold;
 	/* per-rule qthreshold overrides per-instance */
-	if (qthreshold > li->u.ulog.qthreshold)
-		qthreshold = li->u.ulog.qthreshold;
+	if (qthreshold > li->qthreshold)
+		qthreshold = li->qthreshold;
 	
 	switch (inst->copy_mode) {
 	case NFULNL_COPY_META:
@@ -848,7 +850,7 @@ nfulnl_recv_config(struct sock *ctnl, st
 			UDEBUG("unregistering log handler for pf=%u\n", pf);
 			/* This is a bug and a feature.  We cannot unregister
 			 * other handlers, like nfnetlink_inst can */
-			nf_log_unregister_pf(pf);
+			nf_log_unregister_pf(pf, &nfulnl_logger);
 			break;
 		default:
 			ret = -EINVAL;
diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
new file mode 100644
index 0000000..c33ae0f
--- /dev/null
+++ b/net/netfilter/xt_LOG.c
@@ -0,0 +1,136 @@
+/*
+ * This is a module which is used for logging packets.
+ */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * 2006-03-04 Gregor Maier <greogr@majordomus.org>
+ * 	Unified logging. Use nf_log for everything. Create xt_LOG target
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/icmp.h>
+#include <net/udp.h>
+#include <net/tcp.h>
+#include <net/route.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_LOG.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("[ip,ip6]_tables LOG module");
+MODULE_ALIAS("ipt_LOG");
+MODULE_ALIAS("ip6t_LOG");
+
+static struct xt_target ipt_LOG_reg;
+static struct xt_target ip6t_LOG_reg;
+
+static unsigned int
+xt_log_target(struct sk_buff **pskb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const struct xt_target *target,
+       const void *targinfo,
+       void *userinfo)
+{
+	const struct xt_log_info *loginfo = targinfo;
+	
+	struct nf_loginfo li;
+	li.backends = loginfo->backends;
+	li.group = loginfo->group;
+	li.level = loginfo->level;
+	li.logflags = loginfo->logflags;
+	li.qthreshold = 1;
+
+	if (target == &ipt_LOG_reg)
+		nf_log_packet(PF_INET, hooknum, *pskb, in, out, &li, loginfo->prefix);
+	else if (target == &ip6t_LOG_reg)
+		nf_log_packet(PF_INET6, hooknum, *pskb, in, out, &li, loginfo->prefix);
+
+	return XT_CONTINUE;
+}
+
+
+static int xt_log_checkentry(const char *tablename,
+			      const void *e,
+					const struct xt_target *target,
+			      void *targinfo,
+			      unsigned int targinfosize,
+			      unsigned int hook_mask)
+{
+	const struct xt_log_info *loginfo = targinfo;
+
+
+	if (loginfo->level >= 8) {
+		printk(KERN_WARNING "LOG: level %u >= 8\n", loginfo->level);
+		return 0;
+	}
+	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
+		printk(KERN_WARNING "LOG: prefix term %i\n",
+		       loginfo->prefix[sizeof(loginfo->prefix) - 1]);
+		return 0;
+	}
+	printk(KERN_WARNING "LOG: group setting is: %d\n", loginfo->group);
+	
+
+	
+	return 1;
+}
+
+static struct xt_target ipt_LOG_reg = {
+	.name		= "LOG",
+	.target		= xt_log_target,
+	.checkentry	= xt_log_checkentry,
+	.targetsize	= sizeof(struct xt_log_info),
+	.me		= THIS_MODULE,
+};
+
+static struct xt_target ip6t_LOG_reg = {
+	.name		= "LOG",
+	.target		= xt_log_target,
+	.checkentry	= xt_log_checkentry,
+	.targetsize	= sizeof(struct xt_log_info),
+	.me		= THIS_MODULE,
+};
+
+
+static int __init init(void)
+{
+	int ret;
+
+	printk(KERN_WARNING "LOG init called\n");
+	ret = xt_register_target(AF_INET, &ipt_LOG_reg);
+	if (ret)
+		return ret;
+	ret = xt_register_target(AF_INET6, &ip6t_LOG_reg);
+	if (ret)
+		goto out_ip;
+
+	printk(KERN_WARNING "LOG loaded\n");
+	return ret;
+
+out_ip:
+	xt_unregister_target(AF_INET, &ipt_LOG_reg);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_target(AF_INET, &ipt_LOG_reg);
+	xt_unregister_target(AF_INET6, &ip6t_LOG_reg);
+}
+
+module_init(init);
+module_exit(fini);

--------------000409080202090402090902--
