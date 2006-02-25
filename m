From: Gregor Maier <gregor@net.in.tum.de>
Subject: nf_log.c patch: use different logger for each NF_LOG_TYPE_x
Date: Sat, 25 Feb 2006 18:59:46 +0100
Message-ID: <44009B12.1070206@net.in.tum.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigC0E91E0EB8623B468FEFB8AB"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC0E91E0EB8623B468FEFB8AB
Content-Type: multipart/mixed; boundary="------------010302060402030204020308"

This is a multi-part message in MIME format.
--------------010302060402030204020308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

here's a patch against 2.6.16-rc4 that incorporates my thoughts about
logging in netfilter.

A logger is now registered per LOG_TYPE (NF_LOG_TYPE_LOG,
NF_LOG_TYPE_ULOG) _and_ per protocol family. This allows ipt_LOG.c
et.al. to register a handler for NF_LOG_TYPE_LOG which will work as it
always has.

nfnetlink_log (and the obsolete ipt_ULOG) register as NF_LOG_TYPE_ULOG.
So that the userspace libnetfilter_log library can no longer interfere
with the LOG target and the logging code in contrack et.al.

nf_log_packet now examines the loginfo struct (if present) and calls the
appropriate logger for either NF_LOG_TYPE_LOG or NF_LOG_TYPE_ULOG.


This patch removes ambiguities, like the following:
	* when ipt_LOG is loaded (everything logs to syslog via ipt_LOG)
	because ipt_LOG registers a logger for PF_INET.
	* Then, when nfnetlink_log is loaded the ipt_LOG target
	continues to log via printk (Patrick's patch) but everything
	else, like conntrack, will send it's log messages to
	nfnetlink_log/userspace (assuming that a user has
	bound/registered nfnetlink_log to PF_INET)



Things that could be added to the code:
- make it possible for nfnetlink_log to also register for
NF_LOG_TYPE_LOG if the user really wants to do so (and thus disable all
direct printk logging)


cu
Gregor
-- 
Gregor Maier                                      Lehrstuhl Informatik 8
gregor@net.in.tum.de                              Tel: +49 89  289-18010
http://www.net.in.tum.de                                     TU Muenchen

--------------010302060402030204020308
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
	name="nf_log_register_logger_by_type.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf_log_register_logger_by_type.patch"

diff -aur linux-2.6.16-rc4.orig/include/linux/netfilter.h linux-2.6.16-rc4.xxx/include/linux/netfilter.h
--- linux-2.6.16-rc4.orig/include/linux/netfilter.h	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.xxx/include/linux/netfilter.h	2006-02-25 16:56:23.000000000 +0100
@@ -125,6 +125,7 @@
 
 #define NF_LOG_TYPE_LOG		0x01
 #define NF_LOG_TYPE_ULOG	0x02
+#define NF_LOG_TYPE_MAX		NF_LOG_TYPE_ULOG
 
 struct nf_loginfo {
 	u_int8_t type;
@@ -156,8 +157,8 @@
 };
 
 /* Function to register/unregister log function. */
-int nf_log_register(int pf, struct nf_logger *logger);
-int nf_log_unregister_pf(int pf);
+int nf_log_register(int pf, int log_type, struct nf_logger *logger);
+int nf_log_unregister_pf(int pf, int log_type);
 void nf_log_unregister_logger(struct nf_logger *logger);
 
 /* Calls the registered backend logging function */
diff -aur linux-2.6.16-rc4.orig/net/bridge/netfilter/ebt_log.c linux-2.6.16-rc4.xxx/net/bridge/netfilter/ebt_log.c
--- linux-2.6.16-rc4.orig/net/bridge/netfilter/ebt_log.c	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.xxx/net/bridge/netfilter/ebt_log.c	2006-02-25 16:37:47.000000000 +0100
@@ -190,7 +190,7 @@
 	ret = ebt_register_watcher(&log);
 	if (ret < 0)
 		return ret;
-	if (nf_log_register(PF_BRIDGE, &ebt_log_logger) < 0) {
+	if (nf_log_register(PF_BRIDGE, NF_LOG_TYPE_LOG, &ebt_log_logger) < 0) {
 		printk(KERN_WARNING "ebt_log: not logging via system console "
 		       "since somebody else already registered for PF_INET\n");
 		/* we cannot make module load fail here, since otherwise 
diff -aur linux-2.6.16-rc4.orig/net/bridge/netfilter/ebt_ulog.c linux-2.6.16-rc4.xxx/net/bridge/netfilter/ebt_ulog.c
--- linux-2.6.16-rc4.orig/net/bridge/netfilter/ebt_ulog.c	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.xxx/net/bridge/netfilter/ebt_ulog.c	2006-02-25 16:38:01.000000000 +0100
@@ -306,7 +306,7 @@
 	else if ((ret = ebt_register_watcher(&ulog)))
 		sock_release(ebtulognl->sk_socket);
 
-	if (nf_log_register(PF_BRIDGE, &ebt_ulog_logger) < 0) {
+	if (nf_log_register(PF_BRIDGE, NF_LOG_TYPE_LOG, &ebt_ulog_logger) < 0) {
 		printk(KERN_WARNING "ebt_ulog: not logging via ulog "
 		       "since somebody else already registered for PF_BRIDGE\n");
 		/* we cannot make module load fail here, since otherwise
diff -aur linux-2.6.16-rc4.orig/net/ipv4/netfilter/ipt_LOG.c linux-2.6.16-rc4.xxx/net/ipv4/netfilter/ipt_LOG.c
--- linux-2.6.16-rc4.orig/net/ipv4/netfilter/ipt_LOG.c	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.xxx/net/ipv4/netfilter/ipt_LOG.c	2006-02-25 16:38:10.000000000 +0100
@@ -475,7 +475,7 @@
 {
 	if (ipt_register_target(&ipt_log_reg))
 		return -EINVAL;
-	if (nf_log_register(PF_INET, &ipt_log_logger) < 0) {
+	if (nf_log_register(PF_INET, NF_LOG_TYPE_LOG,  &ipt_log_logger) < 0) {
 		printk(KERN_WARNING "ipt_LOG: not logging via system console "
 		       "since somebody else already registered for PF_INET\n");
 		/* we cannot make module load fail here, since otherwise
diff -aur linux-2.6.16-rc4.orig/net/ipv4/netfilter/ipt_ULOG.c linux-2.6.16-rc4.xxx/net/ipv4/netfilter/ipt_ULOG.c
--- linux-2.6.16-rc4.orig/net/ipv4/netfilter/ipt_ULOG.c	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.xxx/net/ipv4/netfilter/ipt_ULOG.c	2006-02-25 16:38:21.000000000 +0100
@@ -406,7 +406,7 @@
 		return -EINVAL;
 	}
 	if (nflog)
-		nf_log_register(PF_INET, &ipt_ulog_logger);
+		nf_log_register(PF_INET, NF_LOG_TYPE_ULOG, &ipt_ulog_logger);
 	
 	return 0;
 }
diff -aur linux-2.6.16-rc4.orig/net/ipv6/netfilter/ip6t_LOG.c linux-2.6.16-rc4.xxx/net/ipv6/netfilter/ip6t_LOG.c
--- linux-2.6.16-rc4.orig/net/ipv6/netfilter/ip6t_LOG.c	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.xxx/net/ipv6/netfilter/ip6t_LOG.c	2006-02-25 16:38:38.000000000 +0100
@@ -487,7 +487,7 @@
 {
 	if (ip6t_register_target(&ip6t_log_reg))
 		return -EINVAL;
-	if (nf_log_register(PF_INET6, &ip6t_logger) < 0) {
+	if (nf_log_register(PF_INET6, NF_LOG_TYPE_LOG, &ip6t_logger) < 0) {
 		printk(KERN_WARNING "ip6t_LOG: not logging via system console "
 		       "since somebody else already registered for PF_INET6\n");
 		/* we cannot make module load fail here, since otherwise
diff -aur linux-2.6.16-rc4.orig/net/netfilter/nf_log.c linux-2.6.16-rc4.xxx/net/netfilter/nf_log.c
--- linux-2.6.16-rc4.orig/net/netfilter/nf_log.c	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.xxx/net/netfilter/nf_log.c	2006-02-25 18:26:21.000000000 +0100
@@ -15,25 +15,29 @@
 
 #define NF_LOG_PREFIXLEN		128
 
-static struct nf_logger *nf_logging[NPROTO]; /* = NULL */
+static struct nf_logger *nf_logging[NPROTO][NF_LOG_TYPE_MAX]; /* = NULL */
 static DEFINE_SPINLOCK(nf_log_lock);
 
 /* return EBUSY if somebody else is registered, EEXIST if the same logger
  * is registred, 0 on success. */
-int nf_log_register(int pf, struct nf_logger *logger)
+int nf_log_register(int pf, int log_type, struct nf_logger *logger)
 {
 	int ret = -EBUSY;
+	
+	log_type--; /* Min LOG_TYPE is 1 */
 
 	if (pf >= NPROTO)
 		return -EINVAL;
+	if (log_type >=  NF_LOG_TYPE_MAX)
+		return -EINVAL;
 
 	/* Any setup of logging members must be done before
 	 * substituting pointer. */
 	spin_lock(&nf_log_lock);
-	if (!nf_logging[pf]) {
-		rcu_assign_pointer(nf_logging[pf], logger);
+	if (!nf_logging[pf][log_type]) {
+		rcu_assign_pointer(nf_logging[pf][log_type], logger);
 		ret = 0;
-	} else if (nf_logging[pf] == logger)
+	} else if (nf_logging[pf][log_type] == logger)
 		ret = -EEXIST;
 
 	spin_unlock(&nf_log_lock);
@@ -41,13 +45,17 @@
 }		
 EXPORT_SYMBOL(nf_log_register);
 
-int nf_log_unregister_pf(int pf)
+int nf_log_unregister_pf(int pf, int log_type)
 {
+	log_type--; 
+
 	if (pf >= NPROTO)
 		return -EINVAL;
+	if (log_type >=  NF_LOG_TYPE_MAX)
+		return -EINVAL;
 
 	spin_lock(&nf_log_lock);
-	nf_logging[pf] = NULL;
+	nf_logging[pf][log_type] = NULL;
 	spin_unlock(&nf_log_lock);
 
 	/* Give time to concurrent readers. */
@@ -59,12 +67,14 @@
 
 void nf_log_unregister_logger(struct nf_logger *logger)
 {
-	int i;
+	int i,j;
 
 	spin_lock(&nf_log_lock);
 	for (i = 0; i < NPROTO; i++) {
-		if (nf_logging[i] == logger)
-			nf_logging[i] = NULL;
+		for (j = 0; j < NF_LOG_TYPE_MAX; j++) {
+			if (nf_logging[i][j] == logger)
+				nf_logging[i][j] = NULL;
+		}
 	}
 	spin_unlock(&nf_log_lock);
 
@@ -83,14 +93,20 @@
 	va_list args;
 	char prefix[NF_LOG_PREFIXLEN];
 	struct nf_logger *logger;
+	int log_type;
+	
+	if (!loginfo || (loginfo->type > NF_LOG_TYPE_MAX))
+		log_type = NF_LOG_TYPE_LOG-1; /* default: log to syslog */
+	else
+		log_type = loginfo->type-1;  /* mintype is 1, array starts at 0 */
 	
 	rcu_read_lock();
-	logger = rcu_dereference(nf_logging[pf]);
+	logger = rcu_dereference(nf_logging[pf][log_type]);
 	if (logger) {
 		va_start(args, fmt);
 		vsnprintf(prefix, sizeof(prefix), fmt, args);
 		va_end(args);
-		/* We must read logging before nf_logfn[pf] */
+		/* We must read logging before nf_logfn[pf][log_type] */
 		logger->logfn(pf, hooknum, skb, in, out, loginfo, prefix);
 	} else if (net_ratelimit()) {
 		printk(KERN_WARNING "nf_log_packet: can\'t log since "
@@ -129,15 +145,25 @@
 
 static int seq_show(struct seq_file *s, void *v)
 {
+	int i;
 	loff_t *pos = v;
 	const struct nf_logger *logger;
 
-	logger = rcu_dereference(nf_logging[*pos]);
+	if (seq_printf(s, "%2lld", *pos) < 0)
+		return -1;
+	for (i = 0; i < NF_LOG_TYPE_MAX; i++) {
+		logger = rcu_dereference(nf_logging[*pos][i]);
 
-	if (!logger)
-		return seq_printf(s, "%2lld NONE\n", *pos);
-	
-	return seq_printf(s, "%2lld %s\n", *pos, logger->name);
+		if (!logger) {
+			if (seq_printf(s, " NONE") < 0)
+				return -1;
+		}
+		else {
+			if (seq_printf(s, " %s", logger->name)) 
+				return -1;
+		}
+	}
+	return seq_putc(s, '\n');
 }
 
 static struct seq_operations nflog_seq_ops = {
diff -aur linux-2.6.16-rc4.orig/net/netfilter/nfnetlink_log.c linux-2.6.16-rc4.xxx/net/netfilter/nfnetlink_log.c
--- linux-2.6.16-rc4.orig/net/netfilter/nfnetlink_log.c	2006-02-17 23:23:45.000000000 +0100
+++ linux-2.6.16-rc4.xxx/net/netfilter/nfnetlink_log.c	2006-02-25 16:38:50.000000000 +0100
@@ -802,13 +802,13 @@
 			break;
 		case NFULNL_CFG_CMD_PF_BIND:
 			UDEBUG("registering log handler for pf=%u\n", pf);
-			ret = nf_log_register(pf, &nfulnl_logger);
+			ret = nf_log_register(pf, NF_LOG_TYPE_ULOG, &nfulnl_logger);
 			break;
 		case NFULNL_CFG_CMD_PF_UNBIND:
 			UDEBUG("unregistering log handler for pf=%u\n", pf);
 			/* This is a bug and a feature.  We cannot unregister
 			 * other handlers, like nfnetlink_inst can */
-			nf_log_unregister_pf(pf);
+			nf_log_unregister_pf(pf, NF_LOG_TYPE_ULOG);
 			break;
 		default:
 			ret = -EINVAL;

--------------010302060402030204020308--

--------------enigC0E91E0EB8623B468FEFB8AB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEAJsVdGiwgbikMYMRAvieAJ9SEhTI6hQjqBs74PHoEXp+bu2hLACdHv8k
qunpRe3rAY1qS3URqnCNI3A=
=n8Cc
-----END PGP SIGNATURE-----

--------------enigC0E91E0EB8623B468FEFB8AB--
