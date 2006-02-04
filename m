From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Fixed timeout for connections
Date: Sun, 05 Feb 2006 00:17:34 +0100
Message-ID: <43E5360E.8070900@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080605040106070909010405"
Cc: vincent@inl.fr
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

This is a multi-part message in MIME format.
--------------080605040106070909010405
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

This set of patches is an implementation of the feature discussed in :
https://lists.netfilter.org/pipermail/netfilter-devel/2006-January/023127.html

Basically, it adds the capability a fixed conntrack timeout from
userspace to be able to define an efficient connection expiration policy.

It only applies for now on ip_conntrack. I will work on nf_conntrack
support afterward if the current code seems correct.

The option -T has been added to the conntrack tool. The command :
 conntrack -U -p tcp -s 192.168.1.2 -d 81.8.121.136 \\
 --orig-port-src 33880 --orig-port-dst 993 -T 300
will force the connection to be destroyed 300 seconds after the call.

fixed_timeout.patch applies to linux git tree
libnetfilter_conntrack_fixed_timeout.patch to libnetfilter_conntrack svn
conntrack_fixed_timeout.patch to conntrack svn

Best regards,
- --
Eric Leblond


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD5TYOnxA7CdMWjzIRArFcAKCSY2jCP8upI+fon2c5u8xUEgc2jgCfYaX/
pcq6hw4hbx0bRs2TMCojpoE=
=+FUO
-----END PGP SIGNATURE-----

--------------080605040106070909010405
Content-Type: text/x-patch;
 name="fixed_timeout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fixed_timeout.patch"

Signed-off-by: Eric Leblond <eric@inl.fr>


---

 include/linux/netfilter/nfnetlink_conntrack.h |    3 ++
 include/linux/netfilter_ipv4/ip_conntrack.h   |    6 ++++
 net/ipv4/netfilter/Kconfig                    |   12 +++++++++
 net/ipv4/netfilter/ip_conntrack_core.c        |   29 ++++++++++++++++-----
 net/ipv4/netfilter/ip_conntrack_netlink.c     |   35 ++++++++++++++++++++++++-
 5 files changed, 77 insertions(+), 8 deletions(-)

e55274cbfe9a0ae13e1c78da1308eb25cbe04517
diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 668ec94..fefc11f 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -29,6 +29,9 @@ enum ctattr_type {
 	CTA_HELP,
 	CTA_NAT,
 	CTA_TIMEOUT,
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+	CTA_FIXED_TIMEOUT,
+#endif
 	CTA_MARK,
 	CTA_COUNTERS_ORIG,
 	CTA_COUNTERS_REPLY,
diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
index 215765f..9e2ad88 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -82,7 +82,11 @@ struct ip_conntrack
 
 	/* Timer function; drops refcnt when it goes off. */
 	struct timer_list timeout;
-
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+        /* Is timeout fixed ? */
+        uint32_t fixed_timeout;
+#endif
+        
 #ifdef CONFIG_IP_NF_CT_ACCT
 	/* Accounting Information (same cache line as other written members) */
 	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index db78303..3ad3355 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -46,6 +46,18 @@ config IP_NF_CT_ACCT
 
 	  If unsure, say `N'.
 
+config IP_NF_CT_FIXED_TIMEOUT
+	bool "Connection tracking fixed timeout"
+	depends on IP_NF_CONNTRACK
+	help
+	  If this option is enabled, the connection tracking code will
+	  be able to have connection that will expire automatically after
+          a given time.
+          
+	  This feature can be used with libnetfilter_conntrack library.
+
+	  If unsure, say `N'.
+
 config IP_NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
 	depends on IP_NF_CONNTRACK
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 84c66db..95f086b 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -488,6 +488,8 @@ __ip_conntrack_confirm(struct sk_buff **
 		   weird delay cases. */
 		ct->timeout.expires += jiffies;
 		add_timer(&ct->timeout);
+
+
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		CONNTRACK_STAT_INC(insert);
@@ -724,11 +726,20 @@ init_conntrack(struct ip_conntrack_tuple
 		/* this is ugly, but there is no other place where to put it */
 		conntrack->nat.masq_index = exp->master->nat.masq_index;
 #endif
+
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+                /* fixed_timeout of related connection is the one of master */
+                conntrack->fixed_timeout=exp->master->fixed_timeout;
+#endif
 		nf_conntrack_get(&conntrack->master->ct_general);
 		CONNTRACK_STAT_INC(expect_new);
 	} else {
 		conntrack->helper = __ip_conntrack_helper_find(&repl_tuple);
 
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+                /* init fixed_timeout to 0 (do not finish) */
+                conntrack->fixed_timeout=0;
+#endif
 		CONNTRACK_STAT_INC(new);
 	}
 
@@ -1135,12 +1146,18 @@ void __ip_ct_refresh_acct(struct ip_conn
 		ct->timeout.expires = extra_jiffies;
 		event = IPCT_REFRESH;
 	} else {
-		/* Need del_timer for race avoidance (may already be dying). */
-		if (del_timer(&ct->timeout)) {
-			ct->timeout.expires = jiffies + extra_jiffies;
-			add_timer(&ct->timeout);
-			event = IPCT_REFRESH;
-		}
+		        /* Need del_timer for race avoidance (may already be dying). */
+		        if (del_timer(&ct->timeout)) {
+			        ct->timeout.expires = jiffies + extra_jiffies;
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+                                if ((ct->fixed_timeout) &&
+                                        (ct->timeout.expires > jiffies+ ct->fixed_timeout *HZ)) {
+                                        ct->timeout.expires = jiffies + ct->fixed_timeout * HZ;
+                                }
+#endif
+			        add_timer(&ct->timeout);
+			        event = IPCT_REFRESH;
+		        }
 	}
 
 #ifdef CONFIG_IP_NF_CT_ACCT
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index c9ebbe0..10688cc 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -42,7 +42,7 @@
 
 MODULE_LICENSE("GPL");
 
-static char __initdata version[] = "0.90";
+static char __initdata version[] = "0.91";
 
 #if 0
 #define DEBUGP printk
@@ -942,6 +942,20 @@ ctnetlink_change_timeout(struct ip_connt
 }
 
 static inline int
+ctnetlink_check_timeout(struct ip_conntrack *ct)
+{
+        if (ct->timeout.expires > jiffies+ ct->fixed_timeout *HZ) {
+                if (!del_timer(&ct->timeout))
+                        return -ETIME;
+                ct->timeout.expires = jiffies + ct->fixed_timeout * HZ;
+                add_timer(&ct->timeout);
+        }
+	return 0;
+}
+
+
+
+static inline int
 ctnetlink_change_protoinfo(struct ip_conntrack *ct, struct nfattr *cda[])
 {
 	struct nfattr *tb[CTA_PROTOINFO_MAX], *attr = cda[CTA_PROTOINFO-1];
@@ -979,6 +993,15 @@ ctnetlink_change_conntrack(struct ip_con
 			return err;
 	}
 
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+	if (cda[CTA_FIXED_TIMEOUT-1]) {
+                ct->fixed_timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_FIXED_TIMEOUT-1]));
+		err = ctnetlink_check_timeout(ct);
+		if (err < 0)
+			return err;
+        }
+#endif
+
 	if (cda[CTA_STATUS-1]) {
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)
@@ -1018,7 +1041,17 @@ ctnetlink_create_conntrack(struct nfattr
 		goto err;
 	ct->timeout.expires = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
 
+        /* we admit jiffies delay on timeout even if is fixed */
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
+
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+	if (cda[CTA_FIXED_TIMEOUT-1]) {
+                ct->fixed_timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_FIXED_TIMEOUT-1]));
+        } else {
+                ct->fixed_timeout = 0;
+        }
+#endif
+        
 	ct->status |= IPS_CONFIRMED;
 
 	err = ctnetlink_change_status(ct, cda);
-- 
1.1.5


--------------080605040106070909010405
Content-Type: text/x-patch; name="libnetfilter_conntrack_fixed_timeout.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
	filename="libnetfilter_conntrack_fixed_timeout.patch"

Index: include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
===================================================================
--- include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	(révision 6458)
+++ include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	(copie de travail)
@@ -29,6 +29,7 @@
 	CTA_HELP,
 	CTA_NAT,
 	CTA_TIMEOUT,
+	CTA_FIXED_TIMEOUT,
 	CTA_MARK,
 	CTA_COUNTERS_ORIG,
 	CTA_COUNTERS_REPLY,
@@ -120,7 +121,6 @@
 	CTA_EXPECT_TIMEOUT,
 	CTA_EXPECT_ID,
 	CTA_EXPECT_HELP_NAME,
-	CTA_EXPECT_QUEUENR,
 	__CTA_EXPECT_MAX
 };
 #define CTA_EXPECT_MAX (__CTA_EXPECT_MAX - 1)
Index: include/libnetfilter_conntrack/libnetfilter_conntrack.h
===================================================================
--- include/libnetfilter_conntrack/libnetfilter_conntrack.h	(révision 6458)
+++ include/libnetfilter_conntrack/libnetfilter_conntrack.h	(copie de travail)
@@ -89,6 +89,7 @@
 	struct nfct_tuple tuple[NFCT_DIR_MAX];
 	
 	u_int32_t 	timeout;
+	u_int32_t 	fixed_timeout;
 	u_int32_t	mark;
 	u_int32_t 	status;
 	u_int32_t	use;
@@ -125,19 +126,22 @@
 	NFCT_TIMEOUT_BIT = 2,
 	NFCT_TIMEOUT = (1 << NFCT_TIMEOUT_BIT),
 
-	NFCT_MARK_BIT = 3,
+        NFCT_FIXED_TIMEOUT_BIT = 3,
+	NFCT_FIXED_TIMEOUT = (1 << NFCT_FIXED_TIMEOUT_BIT),
+
+	NFCT_MARK_BIT = 4,
 	NFCT_MARK = (1 << NFCT_MARK_BIT),
 
-	NFCT_COUNTERS_ORIG_BIT = 4,
+	NFCT_COUNTERS_ORIG_BIT = 5,
 	NFCT_COUNTERS_ORIG = (1 << NFCT_COUNTERS_ORIG_BIT),
 
-	NFCT_COUNTERS_RPLY_BIT = 5,
+	NFCT_COUNTERS_RPLY_BIT = 6,
 	NFCT_COUNTERS_RPLY = (1 << NFCT_COUNTERS_RPLY_BIT),
 
-	NFCT_USE_BIT = 6,
+	NFCT_USE_BIT = 7,
 	NFCT_USE = (1 << NFCT_USE_BIT),
 
-	NFCT_ID_BIT = 7,
+	NFCT_ID_BIT = 8,
 	NFCT_ID = (1 << NFCT_ID_BIT)
 };
 
Index: src/libnetfilter_conntrack.c
===================================================================
--- src/libnetfilter_conntrack.c	(révision 6458)
+++ src/libnetfilter_conntrack.c	(copie de travail)
@@ -517,6 +517,11 @@
 		flags |= NFCT_TIMEOUT;
 	}
 	
+        if (cda[CTA_FIXED_TIMEOUT-1]) {
+		ct.fixed_timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_FIXED_TIMEOUT-1]));
+		flags |= NFCT_FIXED_TIMEOUT;
+	}
+
 	if (cda[CTA_MARK-1]) {
 		ct.mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 		flags |= NFCT_MARK;
@@ -633,6 +638,9 @@
 	if (flags & NFCT_TIMEOUT)
 		size += nfct_sprintf_timeout(buf+size, ct);
 
+	if (flags & NFCT_FIXED_TIMEOUT)
+		size += nfct_sprintf_timeout(buf+size, ct);
+
         if (flags & NFCT_PROTOINFO)
 		size += nfct_sprintf_protoinfo(buf+size, ct);
 
@@ -922,6 +930,7 @@
 	char buf[NFCT_BUFSIZE];
 	u_int32_t status = htonl(ct->status | IPS_CONFIRMED);
 	u_int32_t timeout = htonl(ct->timeout);
+	u_int32_t fixed_timeout = htonl(ct->fixed_timeout);
 	u_int32_t mark = htonl(ct->mark);
 	u_int8_t l3num = ct->tuple[NFCT_DIR_ORIGINAL].l3protonum;
 
@@ -943,6 +952,10 @@
 
 	nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_TIMEOUT, &timeout, 
 		       sizeof(u_int32_t));
+
+        if (fixed_timeout)
+	        nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_FIXED_TIMEOUT, &fixed_timeout, 
+		               sizeof(u_int32_t));
 	
 	if (ct->mark != 0)
 		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_MARK, &mark,
@@ -962,6 +975,7 @@
 	int err;
 	u_int32_t status = htonl(ct->status | IPS_CONFIRMED);
 	u_int32_t timeout = htonl(ct->timeout);
+	u_int32_t fixed_timeout = htonl(ct->fixed_timeout);
 	u_int32_t id = htonl(ct->id);
 	u_int32_t mark = htonl(ct->mark);
 	u_int8_t l3num = ct->tuple[NFCT_DIR_ORIGINAL].l3protonum;
@@ -984,7 +998,12 @@
 	if (ct->timeout != 0)
 		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_TIMEOUT, &timeout, 
 			       sizeof(u_int32_t));
+
+        if (ct->fixed_timeout != 0)
+		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_FIXED_TIMEOUT, &fixed_timeout, 
+			       sizeof(u_int32_t));
 	
+	
 	if (ct->mark != 0)
 		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_MARK, &mark,
 			       sizeof(u_int32_t));

--------------080605040106070909010405
Content-Type: text/x-patch;
 name="conntrack_fixed_timeout.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="conntrack_fixed_timeout.patch"

Index: include/conntrack.h
===================================================================
--- include/conntrack.h	(révision 6458)
+++ include/conntrack.h	(copie de travail)
@@ -85,37 +85,40 @@
 	CT_OPT_TIMEOUT_BIT	= 5,
 	CT_OPT_TIMEOUT		= (1 << CT_OPT_TIMEOUT_BIT),
 
-	CT_OPT_STATUS_BIT	= 6,
+	CT_OPT_FIXED_TIMEOUT_BIT	= 6,
+	CT_OPT_FIXED_TIMEOUT		= (1 << CT_OPT_FIXED_TIMEOUT_BIT),
+
+	CT_OPT_STATUS_BIT	= 7,
 	CT_OPT_STATUS		= (1 << CT_OPT_STATUS_BIT),
 
-	CT_OPT_ZERO_BIT		= 7,
+	CT_OPT_ZERO_BIT		= 8,
 	CT_OPT_ZERO		= (1 << CT_OPT_ZERO_BIT),
 
-	CT_OPT_EVENT_MASK_BIT	= 8,
+	CT_OPT_EVENT_MASK_BIT	= 9,
 	CT_OPT_EVENT_MASK	= (1 << CT_OPT_EVENT_MASK_BIT),
 
-	CT_OPT_EXP_SRC_BIT	= 9,
+	CT_OPT_EXP_SRC_BIT	= 10,
 	CT_OPT_EXP_SRC		= (1 << CT_OPT_EXP_SRC_BIT),
 
-	CT_OPT_EXP_DST_BIT	= 10,
+	CT_OPT_EXP_DST_BIT	= 11,
 	CT_OPT_EXP_DST		= (1 << CT_OPT_EXP_DST_BIT),
 
-	CT_OPT_MASK_SRC_BIT	= 11,
+	CT_OPT_MASK_SRC_BIT	= 12,
 	CT_OPT_MASK_SRC		= (1 << CT_OPT_MASK_SRC_BIT),
 
-	CT_OPT_MASK_DST_BIT	= 12,
+	CT_OPT_MASK_DST_BIT	= 13,
 	CT_OPT_MASK_DST		= (1 << CT_OPT_MASK_DST_BIT),
 
-	CT_OPT_NATRANGE_BIT	= 13,
+	CT_OPT_NATRANGE_BIT	= 14,
 	CT_OPT_NATRANGE		= (1 << CT_OPT_NATRANGE_BIT),
 
-	CT_OPT_MARK_BIT		= 14,
+	CT_OPT_MARK_BIT		= 15,
 	CT_OPT_MARK		= (1 << CT_OPT_MARK_BIT),
 
-	CT_OPT_ID_BIT		= 15,
+	CT_OPT_ID_BIT		= 16,
 	CT_OPT_ID		= (1 << CT_OPT_ID_BIT),
 
-	CT_OPT_FAMILY_BIT	= 16,
+	CT_OPT_FAMILY_BIT	= 17,
 	CT_OPT_FAMILY		= (1 << CT_OPT_FAMILY_BIT),
 
 	CT_OPT_MAX_BIT		= CT_OPT_FAMILY_BIT
Index: src/conntrack.c
===================================================================
--- src/conntrack.c	(révision 6458)
+++ src/conntrack.c	(copie de travail)
@@ -80,6 +80,7 @@
 	{"reply-dst", 1, 0, 'q'},
 	{"protonum", 1, 0, 'p'},
 	{"timeout", 1, 0, 't'},
+	{"Timeout", 1, 0, 'T'},
 	{"status", 1, 0, 'u'},
 	{"zero", 0, 0, 'z'},
 	{"event-mask", 1, 0, 'e'},
@@ -569,6 +570,7 @@
 	"  -p, --protonum proto\t\tLayer 4 Protocol, eg. 'tcp'\n"
 	"  -f, --family proto\t\tLayer 3 Protocol, eg. 'ipv6'\n"
 	"  -t, --timeout timeout\t\tSet timeout\n"
+	"  -T, --Timeout fixed timeout\t\tSet fixed timeout\n"
 	"  -u, --status status\t\tSet status, eg. ASSURED\n"
 	"  -i, --id [id]\t\t\tShow or set conntrack ID\n"
 	;
@@ -595,6 +597,7 @@
 static struct nfct_conntrack *ct;
 static struct nfct_expect *exp;
 static unsigned long timeout;
+static unsigned long fixed_timeout;
 static unsigned int status;
 static unsigned int mark;
 static unsigned int id = NFCT_ANY_ID;
@@ -611,7 +614,7 @@
 	struct nfct_conntrack_compare *pcmp;
 
 	while ((c = getopt_long(argc, argv, 
-		"L::I::U::D::G::E::F::hVs:d:r:q:p:t:u:e:a:z[:]:{:}:m:i::f:", 
+		"L::I::U::D::G::E::F::hVs:d:r:q:p:t:T:u:e:a:z[:]:{:}:m:i::f:", 
 		opts, NULL)) != -1) {
 	switch(c) {
 		case 'L':
@@ -735,6 +738,12 @@
 			if (optarg)
 				timeout = atol(optarg);
 			break;
+		case 'T':
+			options |= CT_OPT_FIXED_TIMEOUT;
+			if (optarg)
+				fixed_timeout = atol(optarg);
+			break;
+
 		case 'u': {
 			if (!optarg)
 				continue;
@@ -974,6 +983,9 @@
 		ct = nfct_conntrack_alloc(&orig, &reply, timeout,
 					  &proto, status, mark, id,
 					  NULL);
+                if (options & CT_OPT_FIXED_TIMEOUT) {
+                        ct->fixed_timeout = fixed_timeout;
+                }
 		if (!ct)
 			exit_error(OTHER_PROBLEM, "Not enough memory");
 		

--------------080605040106070909010405--
