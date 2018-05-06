From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 49/51] netfilter: extract Passive OS fingerprint infrastructure from xt_osf
Date: Mon,  7 May 2018 00:47:07 +0200
Message-ID: <20180506224709.29100-50-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Add nf_osf_ttl() and nf_osf_match() into nf_osf.c to prepare for
nf_tables support.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_osf.h      |  27 +++++
 include/uapi/linux/netfilter/nf_osf.h |  90 ++++++++++++++
 include/uapi/linux/netfilter/xt_osf.h | 106 +++--------------
 net/netfilter/Kconfig                 |   4 +
 net/netfilter/Makefile                |   1 +
 net/netfilter/nf_osf.c                | 218 ++++++++++++++++++++++++++++++++++
 net/netfilter/xt_osf.c                | 202 +------------------------------
 7 files changed, 359 insertions(+), 289 deletions(-)
 create mode 100644 include/linux/netfilter/nf_osf.h
 create mode 100644 include/uapi/linux/netfilter/nf_osf.h
 create mode 100644 net/netfilter/nf_osf.c

diff --git a/include/linux/netfilter/nf_osf.h b/include/linux/netfilter/nf_osf.h
new file mode 100644
index 000000000000..a2b39602e87d
--- /dev/null
+++ b/include/linux/netfilter/nf_osf.h
@@ -0,0 +1,27 @@
+#include <uapi/linux/netfilter/nf_osf.h>
+
+/* Initial window size option state machine: multiple of mss, mtu or
+ * plain numeric value. Can also be made as plain numeric value which
+ * is not a multiple of specified value.
+ */
+enum nf_osf_window_size_options {
+	OSF_WSS_PLAIN   = 0,
+	OSF_WSS_MSS,
+	OSF_WSS_MTU,
+	OSF_WSS_MODULO,
+	OSF_WSS_MAX,
+};
+
+enum osf_fmatch_states {
+	/* Packet does not match the fingerprint */
+	FMATCH_WRONG = 0,
+	/* Packet matches the fingerprint */
+	FMATCH_OK,
+	/* Options do not match the fingerprint, but header does */
+	FMATCH_OPT_WRONG,
+};
+
+bool nf_osf_match(const struct sk_buff *skb, u_int8_t family,
+		  int hooknum, struct net_device *in, struct net_device *out,
+		  const struct nf_osf_info *info, struct net *net,
+		  const struct list_head *nf_osf_fingers);
diff --git a/include/uapi/linux/netfilter/nf_osf.h b/include/uapi/linux/netfilter/nf_osf.h
new file mode 100644
index 000000000000..45376eae31ef
--- /dev/null
+++ b/include/uapi/linux/netfilter/nf_osf.h
@@ -0,0 +1,90 @@
+#ifndef _NF_OSF_H
+#define _NF_OSF_H
+
+#define MAXGENRELEN	32
+
+#define NF_OSF_GENRE	(1 << 0)
+#define NF_OSF_TTL	(1 << 1)
+#define NF_OSF_LOG	(1 << 2)
+#define NF_OSF_INVERT	(1 << 3)
+
+#define NF_OSF_LOGLEVEL_ALL		0	/* log all matched fingerprints */
+#define NF_OSF_LOGLEVEL_FIRST		1	/* log only the first matced fingerprint */
+#define NF_OSF_LOGLEVEL_ALL_KNOWN	2	/* do not log unknown packets */
+
+#define NF_OSF_TTL_TRUE			0	/* True ip and fingerprint TTL comparison */
+
+/* Do not compare ip and fingerprint TTL at all */
+#define NF_OSF_TTL_NOCHECK		2
+
+/* Wildcard MSS (kind of).
+ * It is used to implement a state machine for the different wildcard values
+ * of the MSS and window sizes.
+ */
+struct nf_osf_wc {
+	__u32	wc;
+	__u32	val;
+};
+
+/* This struct represents IANA options
+ * http://www.iana.org/assignments/tcp-parameters
+ */
+struct nf_osf_opt {
+	__u16			kind, length;
+	struct nf_osf_wc	wc;
+};
+
+struct nf_osf_info {
+	char	genre[MAXGENRELEN];
+	__u32	len;
+	__u32	flags;
+	__u32	loglevel;
+	__u32	ttl;
+};
+
+struct nf_osf_user_finger {
+	struct nf_osf_wc	wss;
+
+	__u8	ttl, df;
+	__u16	ss, mss;
+	__u16	opt_num;
+
+	char	genre[MAXGENRELEN];
+	char	version[MAXGENRELEN];
+	char	subtype[MAXGENRELEN];
+
+	/* MAX_IPOPTLEN is maximum if all options are NOPs or EOLs */
+	struct nf_osf_opt	opt[MAX_IPOPTLEN];
+};
+
+struct nf_osf_finger {
+	struct rcu_head			rcu_head;
+	struct list_head		finger_entry;
+	struct nf_osf_user_finger	finger;
+};
+
+struct nf_osf_nlmsg {
+	struct nf_osf_user_finger	f;
+	struct iphdr			ip;
+	struct tcphdr			tcp;
+};
+
+/* Defines for IANA option kinds */
+enum iana_options {
+	OSFOPT_EOL = 0,		/* End of options */
+	OSFOPT_NOP,		/* NOP */
+	OSFOPT_MSS,		/* Maximum segment size */
+	OSFOPT_WSO,		/* Window scale option */
+	OSFOPT_SACKP,		/* SACK permitted */
+	OSFOPT_SACK,		/* SACK */
+	OSFOPT_ECHO,
+	OSFOPT_ECHOREPLY,
+	OSFOPT_TS,		/* Timestamp option */
+	OSFOPT_POCP,		/* Partial Order Connection Permitted */
+	OSFOPT_POSP,		/* Partial Order Service Profile */
+
+	/* Others are not used in the current OSF */
+	OSFOPT_EMPTY = 255,
+};
+
+#endif /* _NF_OSF_H */
diff --git a/include/uapi/linux/netfilter/xt_osf.h b/include/uapi/linux/netfilter/xt_osf.h
index dad197e2ab99..72956eceeb09 100644
--- a/include/uapi/linux/netfilter/xt_osf.h
+++ b/include/uapi/linux/netfilter/xt_osf.h
@@ -23,101 +23,29 @@
 #include <linux/types.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
+#include <linux/netfilter/nf_osf.h>
 
-#define MAXGENRELEN		32
+#define XT_OSF_GENRE		NF_OSF_GENRE
+#define XT_OSF_INVERT		NF_OSF_INVERT
 
-#define XT_OSF_GENRE		(1<<0)
-#define	XT_OSF_TTL		(1<<1)
-#define XT_OSF_LOG		(1<<2)
-#define XT_OSF_INVERT		(1<<3)
+#define XT_OSF_TTL		NF_OSF_TTL
+#define XT_OSF_LOG		NF_OSF_LOG
 
-#define XT_OSF_LOGLEVEL_ALL	0	/* log all matched fingerprints */
-#define XT_OSF_LOGLEVEL_FIRST	1	/* log only the first matced fingerprint */
-#define XT_OSF_LOGLEVEL_ALL_KNOWN	2 /* do not log unknown packets */
+#define XT_OSF_LOGLEVEL_ALL		NF_OSF_LOGLEVEL_ALL
+#define XT_OSF_LOGLEVEL_FIRST		NF_OSF_LOGLEVEL_FIRST
+#define XT_OSF_LOGLEVEL_ALL_KNOWN	NF_OSF_LOGLEVEL_ALL_KNOWN
 
-#define XT_OSF_TTL_TRUE		0	/* True ip and fingerprint TTL comparison */
-#define XT_OSF_TTL_LESS		1	/* Check if ip TTL is less than fingerprint one */
-#define XT_OSF_TTL_NOCHECK	2	/* Do not compare ip and fingerprint TTL at all */
+#define XT_OSF_TTL_TRUE		NF_OSF_TTL_TRUE
+#define XT_OSF_TTL_NOCHECK	NF_OSF_TTL_NOCHECK
 
-struct xt_osf_info {
-	char			genre[MAXGENRELEN];
-	__u32			len;
-	__u32			flags;
-	__u32			loglevel;
-	__u32			ttl;
-};
-
-/*
- * Wildcard MSS (kind of).
- * It is used to implement a state machine for the different wildcard values
- * of the MSS and window sizes.
- */
-struct xt_osf_wc {
-	__u32			wc;
-	__u32			val;
-};
-
-/*
- * This struct represents IANA options
- * http://www.iana.org/assignments/tcp-parameters
- */
-struct xt_osf_opt {
-	__u16			kind, length;
-	struct xt_osf_wc	wc;
-};
-
-struct xt_osf_user_finger {
-	struct xt_osf_wc	wss;
-
-	__u8			ttl, df;
-	__u16			ss, mss;
-	__u16			opt_num;
-
-	char			genre[MAXGENRELEN];
-	char			version[MAXGENRELEN];
-	char			subtype[MAXGENRELEN];
+#define XT_OSF_TTL_LESS	1	/* Check if ip TTL is less than fingerprint one */
 
-	/* MAX_IPOPTLEN is maximum if all options are NOPs or EOLs */
-	struct xt_osf_opt	opt[MAX_IPOPTLEN];
-};
-
-struct xt_osf_nlmsg {
-	struct xt_osf_user_finger	f;
-	struct iphdr		ip;
-	struct tcphdr		tcp;
-};
-
-/* Defines for IANA option kinds */
-
-enum iana_options {
-	OSFOPT_EOL = 0,		/* End of options */
-	OSFOPT_NOP, 		/* NOP */
-	OSFOPT_MSS, 		/* Maximum segment size */
-	OSFOPT_WSO, 		/* Window scale option */
-	OSFOPT_SACKP,		/* SACK permitted */
-	OSFOPT_SACK,		/* SACK */
-	OSFOPT_ECHO,
-	OSFOPT_ECHOREPLY,
-	OSFOPT_TS,		/* Timestamp option */
-	OSFOPT_POCP,		/* Partial Order Connection Permitted */
-	OSFOPT_POSP,		/* Partial Order Service Profile */
-
-	/* Others are not used in the current OSF */
-	OSFOPT_EMPTY = 255,
-};
-
-/*
- * Initial window size option state machine: multiple of mss, mtu or
- * plain numeric value. Can also be made as plain numeric value which
- * is not a multiple of specified value.
- */
-enum xt_osf_window_size_options {
-	OSF_WSS_PLAIN	= 0,
-	OSF_WSS_MSS,
-	OSF_WSS_MTU,
-	OSF_WSS_MODULO,
-	OSF_WSS_MAX,
-};
+#define xt_osf_wc		nf_osf_wc
+#define xt_osf_opt		nf_osf_opt
+#define xt_osf_info		nf_osf_info
+#define xt_osf_user_finger	nf_osf_user_finger
+#define xt_osf_finger		nf_osf_finger
+#define xt_osf_nlmsg		nf_osf_nlmsg
 
 /*
  * Add/remove fingerprint from the kernel.
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f66586fb41cd..e25cdb3d51cb 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -444,6 +444,9 @@ config NETFILTER_SYNPROXY
 
 endif # NF_CONNTRACK
 
+config NF_OSF
+	tristate 'Passive OS fingerprint infrastructure'
+
 config NF_TABLES
 	select NETFILTER_NETLINK
 	tristate "Netfilter nf_tables support"
@@ -1358,6 +1361,7 @@ config NETFILTER_XT_MATCH_NFACCT
 config NETFILTER_XT_MATCH_OSF
 	tristate '"osf" Passive OS fingerprint match'
 	depends on NETFILTER_ADVANCED && NETFILTER_NETLINK
+	select NF_OSF
 	help
 	  This option selects the Passive OS Fingerprinting match module
 	  that allows to passively match the remote operating system by
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index b37ce0bc9ab7..1aa710b5d384 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
 obj-$(CONFIG_NFT_FIB)		+= nft_fib.o
 obj-$(CONFIG_NFT_FIB_INET)	+= nft_fib_inet.o
 obj-$(CONFIG_NFT_FIB_NETDEV)	+= nft_fib_netdev.o
+obj-$(CONFIG_NF_OSF)		+= nf_osf.o
 
 # nf_tables netdev
 obj-$(CONFIG_NFT_DUP_NETDEV)	+= nft_dup_netdev.o
diff --git a/net/netfilter/nf_osf.c b/net/netfilter/nf_osf.c
new file mode 100644
index 000000000000..5ba5c7bef2f9
--- /dev/null
+++ b/net/netfilter/nf_osf.c
@@ -0,0 +1,218 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+#include <linux/capability.h>
+#include <linux/if.h>
+#include <linux/inetdevice.h>
+#include <linux/ip.h>
+#include <linux/list.h>
+#include <linux/rculist.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/tcp.h>
+
+#include <net/ip.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/x_tables.h>
+#include <net/netfilter/nf_log.h>
+#include <linux/netfilter/nf_osf.h>
+
+static inline int nf_osf_ttl(const struct sk_buff *skb,
+			     const struct nf_osf_info *info,
+			     unsigned char f_ttl)
+{
+	const struct iphdr *ip = ip_hdr(skb);
+
+	if (info->flags & NF_OSF_TTL) {
+		if (info->ttl == NF_OSF_TTL_TRUE)
+			return ip->ttl == f_ttl;
+		if (info->ttl == NF_OSF_TTL_NOCHECK)
+			return 1;
+		else if (ip->ttl <= f_ttl)
+			return 1;
+		else {
+			struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
+			int ret = 0;
+
+			for_ifa(in_dev) {
+				if (inet_ifa_match(ip->saddr, ifa)) {
+					ret = (ip->ttl == f_ttl);
+					break;
+				}
+			}
+			endfor_ifa(in_dev);
+
+			return ret;
+		}
+	}
+
+	return ip->ttl == f_ttl;
+}
+
+bool
+nf_osf_match(const struct sk_buff *skb, u_int8_t family,
+	     int hooknum, struct net_device *in, struct net_device *out,
+	     const struct nf_osf_info *info, struct net *net,
+	     const struct list_head *nf_osf_fingers)
+{
+	const unsigned char *optp = NULL, *_optp = NULL;
+	unsigned int optsize = 0, check_WSS = 0;
+	int fmatch = FMATCH_WRONG, fcount = 0;
+	const struct iphdr *ip = ip_hdr(skb);
+	const struct nf_osf_user_finger *f;
+	unsigned char opts[MAX_IPOPTLEN];
+	const struct nf_osf_finger *kf;
+	u16 window, totlen, mss = 0;
+	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
+	bool df;
+
+	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), &_tcph);
+	if (!tcp)
+		return false;
+
+	if (!tcp->syn)
+		return false;
+
+	totlen = ntohs(ip->tot_len);
+	df = ntohs(ip->frag_off) & IP_DF;
+	window = ntohs(tcp->window);
+
+	if (tcp->doff * 4 > sizeof(struct tcphdr)) {
+		optsize = tcp->doff * 4 - sizeof(struct tcphdr);
+
+		_optp = optp = skb_header_pointer(skb, ip_hdrlen(skb) +
+				sizeof(struct tcphdr), optsize, opts);
+	}
+
+	list_for_each_entry_rcu(kf, &nf_osf_fingers[df], finger_entry) {
+		int foptsize, optnum;
+
+		f = &kf->finger;
+
+		if (!(info->flags & NF_OSF_LOG) && strcmp(info->genre, f->genre))
+			continue;
+
+		optp = _optp;
+		fmatch = FMATCH_WRONG;
+
+		if (totlen != f->ss || !nf_osf_ttl(skb, info, f->ttl))
+			continue;
+
+		/*
+		 * Should not happen if userspace parser was written correctly.
+		 */
+		if (f->wss.wc >= OSF_WSS_MAX)
+			continue;
+
+		/* Check options */
+
+		foptsize = 0;
+		for (optnum = 0; optnum < f->opt_num; ++optnum)
+			foptsize += f->opt[optnum].length;
+
+		if (foptsize > MAX_IPOPTLEN ||
+		    optsize > MAX_IPOPTLEN ||
+		    optsize != foptsize)
+			continue;
+
+		check_WSS = f->wss.wc;
+
+		for (optnum = 0; optnum < f->opt_num; ++optnum) {
+			if (f->opt[optnum].kind == (*optp)) {
+				__u32 len = f->opt[optnum].length;
+				const __u8 *optend = optp + len;
+
+				fmatch = FMATCH_OK;
+
+				switch (*optp) {
+				case OSFOPT_MSS:
+					mss = optp[3];
+					mss <<= 8;
+					mss |= optp[2];
+
+					mss = ntohs((__force __be16)mss);
+					break;
+				case OSFOPT_TS:
+					break;
+				}
+
+				optp = optend;
+			} else
+				fmatch = FMATCH_OPT_WRONG;
+
+			if (fmatch != FMATCH_OK)
+				break;
+		}
+
+		if (fmatch != FMATCH_OPT_WRONG) {
+			fmatch = FMATCH_WRONG;
+
+			switch (check_WSS) {
+			case OSF_WSS_PLAIN:
+				if (f->wss.val == 0 || window == f->wss.val)
+					fmatch = FMATCH_OK;
+				break;
+			case OSF_WSS_MSS:
+				/*
+				 * Some smart modems decrease mangle MSS to
+				 * SMART_MSS_2, so we check standard, decreased
+				 * and the one provided in the fingerprint MSS
+				 * values.
+				 */
+#define SMART_MSS_1	1460
+#define SMART_MSS_2	1448
+				if (window == f->wss.val * mss ||
+				    window == f->wss.val * SMART_MSS_1 ||
+				    window == f->wss.val * SMART_MSS_2)
+					fmatch = FMATCH_OK;
+				break;
+			case OSF_WSS_MTU:
+				if (window == f->wss.val * (mss + 40) ||
+				    window == f->wss.val * (SMART_MSS_1 + 40) ||
+				    window == f->wss.val * (SMART_MSS_2 + 40))
+					fmatch = FMATCH_OK;
+				break;
+			case OSF_WSS_MODULO:
+				if ((window % f->wss.val) == 0)
+					fmatch = FMATCH_OK;
+				break;
+			}
+		}
+
+		if (fmatch != FMATCH_OK)
+			continue;
+
+		fcount++;
+
+		if (info->flags & NF_OSF_LOG)
+			nf_log_packet(net, family, hooknum, skb,
+				      in, out, NULL,
+				      "%s [%s:%s] : %pI4:%d -> %pI4:%d hops=%d\n",
+				      f->genre, f->version, f->subtype,
+				      &ip->saddr, ntohs(tcp->source),
+				      &ip->daddr, ntohs(tcp->dest),
+				      f->ttl - ip->ttl);
+
+		if ((info->flags & NF_OSF_LOG) &&
+		    info->loglevel == NF_OSF_LOGLEVEL_FIRST)
+			break;
+	}
+
+	if (!fcount && (info->flags & NF_OSF_LOG))
+		nf_log_packet(net, family, hooknum, skb, in, out, NULL,
+			      "Remote OS is not known: %pI4:%u -> %pI4:%u\n",
+			      &ip->saddr, ntohs(tcp->source),
+			      &ip->daddr, ntohs(tcp->dest));
+
+	if (fcount)
+		fmatch = FMATCH_OK;
+
+	return fmatch == FMATCH_OK;
+}
+EXPORT_SYMBOL_GPL(nf_osf_match);
+
+MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index a34f314a8c23..9cfef73b4107 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -37,21 +37,6 @@
 #include <net/netfilter/nf_log.h>
 #include <linux/netfilter/xt_osf.h>
 
-struct xt_osf_finger {
-	struct rcu_head			rcu_head;
-	struct list_head		finger_entry;
-	struct xt_osf_user_finger	finger;
-};
-
-enum osf_fmatch_states {
-	/* Packet does not match the fingerprint */
-	FMATCH_WRONG = 0,
-	/* Packet matches the fingerprint */
-	FMATCH_OK,
-	/* Options do not match the fingerprint, but header does */
-	FMATCH_OPT_WRONG,
-};
-
 /*
  * Indexed by dont-fragment bit.
  * It is the only constant value in the fingerprint.
@@ -164,200 +149,17 @@ static const struct nfnetlink_subsystem xt_osf_nfnetlink = {
 	.cb			= xt_osf_nfnetlink_callbacks,
 };
 
-static inline int xt_osf_ttl(const struct sk_buff *skb, const struct xt_osf_info *info,
-			    unsigned char f_ttl)
-{
-	const struct iphdr *ip = ip_hdr(skb);
-
-	if (info->flags & XT_OSF_TTL) {
-		if (info->ttl == XT_OSF_TTL_TRUE)
-			return ip->ttl == f_ttl;
-		if (info->ttl == XT_OSF_TTL_NOCHECK)
-			return 1;
-		else if (ip->ttl <= f_ttl)
-			return 1;
-		else {
-			struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
-			int ret = 0;
-
-			for_ifa(in_dev) {
-				if (inet_ifa_match(ip->saddr, ifa)) {
-					ret = (ip->ttl == f_ttl);
-					break;
-				}
-			}
-			endfor_ifa(in_dev);
-
-			return ret;
-		}
-	}
-
-	return ip->ttl == f_ttl;
-}
-
 static bool
 xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 {
 	const struct xt_osf_info *info = p->matchinfo;
-	const struct iphdr *ip = ip_hdr(skb);
-	const struct tcphdr *tcp;
-	struct tcphdr _tcph;
-	int fmatch = FMATCH_WRONG, fcount = 0;
-	unsigned int optsize = 0, check_WSS = 0;
-	u16 window, totlen, mss = 0;
-	bool df;
-	const unsigned char *optp = NULL, *_optp = NULL;
-	unsigned char opts[MAX_IPOPTLEN];
-	const struct xt_osf_finger *kf;
-	const struct xt_osf_user_finger *f;
 	struct net *net = xt_net(p);
 
 	if (!info)
 		return false;
 
-	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), &_tcph);
-	if (!tcp)
-		return false;
-
-	if (!tcp->syn)
-		return false;
-
-	totlen = ntohs(ip->tot_len);
-	df = ntohs(ip->frag_off) & IP_DF;
-	window = ntohs(tcp->window);
-
-	if (tcp->doff * 4 > sizeof(struct tcphdr)) {
-		optsize = tcp->doff * 4 - sizeof(struct tcphdr);
-
-		_optp = optp = skb_header_pointer(skb, ip_hdrlen(skb) +
-				sizeof(struct tcphdr), optsize, opts);
-	}
-
-	list_for_each_entry_rcu(kf, &xt_osf_fingers[df], finger_entry) {
-		int foptsize, optnum;
-
-		f = &kf->finger;
-
-		if (!(info->flags & XT_OSF_LOG) && strcmp(info->genre, f->genre))
-			continue;
-
-		optp = _optp;
-		fmatch = FMATCH_WRONG;
-
-		if (totlen != f->ss || !xt_osf_ttl(skb, info, f->ttl))
-			continue;
-
-		/*
-		 * Should not happen if userspace parser was written correctly.
-		 */
-		if (f->wss.wc >= OSF_WSS_MAX)
-			continue;
-
-		/* Check options */
-
-		foptsize = 0;
-		for (optnum = 0; optnum < f->opt_num; ++optnum)
-			foptsize += f->opt[optnum].length;
-
-		if (foptsize > MAX_IPOPTLEN ||
-		    optsize > MAX_IPOPTLEN ||
-		    optsize != foptsize)
-			continue;
-
-		check_WSS = f->wss.wc;
-
-		for (optnum = 0; optnum < f->opt_num; ++optnum) {
-			if (f->opt[optnum].kind == (*optp)) {
-				__u32 len = f->opt[optnum].length;
-				const __u8 *optend = optp + len;
-
-				fmatch = FMATCH_OK;
-
-				switch (*optp) {
-				case OSFOPT_MSS:
-					mss = optp[3];
-					mss <<= 8;
-					mss |= optp[2];
-
-					mss = ntohs((__force __be16)mss);
-					break;
-				case OSFOPT_TS:
-					break;
-				}
-
-				optp = optend;
-			} else
-				fmatch = FMATCH_OPT_WRONG;
-
-			if (fmatch != FMATCH_OK)
-				break;
-		}
-
-		if (fmatch != FMATCH_OPT_WRONG) {
-			fmatch = FMATCH_WRONG;
-
-			switch (check_WSS) {
-			case OSF_WSS_PLAIN:
-				if (f->wss.val == 0 || window == f->wss.val)
-					fmatch = FMATCH_OK;
-				break;
-			case OSF_WSS_MSS:
-				/*
-				 * Some smart modems decrease mangle MSS to
-				 * SMART_MSS_2, so we check standard, decreased
-				 * and the one provided in the fingerprint MSS
-				 * values.
-				 */
-#define SMART_MSS_1	1460
-#define SMART_MSS_2	1448
-				if (window == f->wss.val * mss ||
-				    window == f->wss.val * SMART_MSS_1 ||
-				    window == f->wss.val * SMART_MSS_2)
-					fmatch = FMATCH_OK;
-				break;
-			case OSF_WSS_MTU:
-				if (window == f->wss.val * (mss + 40) ||
-				    window == f->wss.val * (SMART_MSS_1 + 40) ||
-				    window == f->wss.val * (SMART_MSS_2 + 40))
-					fmatch = FMATCH_OK;
-				break;
-			case OSF_WSS_MODULO:
-				if ((window % f->wss.val) == 0)
-					fmatch = FMATCH_OK;
-				break;
-			}
-		}
-
-		if (fmatch != FMATCH_OK)
-			continue;
-
-		fcount++;
-
-		if (info->flags & XT_OSF_LOG)
-			nf_log_packet(net, xt_family(p), xt_hooknum(p), skb,
-				      xt_in(p), xt_out(p), NULL,
-				      "%s [%s:%s] : %pI4:%d -> %pI4:%d hops=%d\n",
-				      f->genre, f->version, f->subtype,
-				      &ip->saddr, ntohs(tcp->source),
-				      &ip->daddr, ntohs(tcp->dest),
-				      f->ttl - ip->ttl);
-
-		if ((info->flags & XT_OSF_LOG) &&
-		    info->loglevel == XT_OSF_LOGLEVEL_FIRST)
-			break;
-	}
-
-	if (!fcount && (info->flags & XT_OSF_LOG))
-		nf_log_packet(net, xt_family(p), xt_hooknum(p), skb, xt_in(p),
-			      xt_out(p), NULL,
-			"Remote OS is not known: %pI4:%u -> %pI4:%u\n",
-				&ip->saddr, ntohs(tcp->source),
-				&ip->daddr, ntohs(tcp->dest));
-
-	if (fcount)
-		fmatch = FMATCH_OK;
-
-	return fmatch == FMATCH_OK;
+	return nf_osf_match(skb, xt_family(p), xt_hooknum(p), xt_in(p),
+			    xt_out(p), info, net, xt_osf_fingers);
 }
 
 static struct xt_match xt_osf_match = {
-- 
2.11.0
