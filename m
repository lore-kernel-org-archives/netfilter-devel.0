From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: [PATCH] fix patch base/connlimit in pom-20040409
Date: Sun, 11 Apr 2004 13:35:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40792D9C.9030807@fl.priv.at>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040203070708070905020708"
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
--------------040203070708070905020708
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

Attached you will find a patch to remove the usage of
__MOD_INC_USE_COUNT from the base/connlimit patch which breaks
a kernel compilation because of the undefined variable
ip_conntrack_module.

__MOD_INC_USE_COUNT is depreciated anyway, as I was told.

PS: Apply with "-p1" in the pom directory.

-- 
MfG / Regards
Friedrich Lobenstock

--------------040203070708070905020708
Content-Type: text/plain;
 name="patch-base-connlimit-patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-base-connlimit-patch"

--- patch-o-matic-20040409/base/connlimit.patch.broken	2004-04-11 14:22:08.000000000 +0200
+++ patch-o-matic-20040409/base/connlimit.patch	2004-04-11 14:28:31.000000000 +0200
@@ -14,10 +14,9 @@
 +	struct ipt_connlimit_data *data;
 +};
 +#endif /* _IPT_CONNLIMIT_H */
-diff -urN -x *~ -x [Cc]onfig.* -x Makefile vanilla-2.4.0-test8/net/ipv4/netfilter/ipt_connlimit.c linux-2.4.0-test8/net/ipv4/netfilter/ipt_connlimit.c
---- vanilla-2.4.0-test8/net/ipv4/netfilter/ipt_connlimit.c	Thu Jan  1 01:00:00 1970
-+++ linux-2.4.0-test8/net/ipv4/netfilter/ipt_connlimit.c	Wed Nov 29 15:37:40 2000
-@@ -0,0 +1,232 @@
+--- linux-2.4.25/net/ipv4/netfilter/ipt_connlimit.c	2003-03-14 14:07:09.000000000 +0100
++++ linux-2.4.25/net/ipv4/netfilter/ipt_connlimit.c	2004-04-11 14:24:24.000000000 +0200
+@@ -0,0 +1,227 @@
 +/*
 + * netfilter module to limit the number of parallel tcp
 + * connections per IP address.
@@ -235,17 +234,12 @@
 +
 +static int __init init(void)
 +{
-+	/* NULL if ip_conntrack not a module */
-+	if (ip_conntrack_module)
-+		__MOD_INC_USE_COUNT(ip_conntrack_module);
 +	return ipt_register_match(&connlimit_match);
 +}
 +
 +static void __exit fini(void)
 +{
 +	ipt_unregister_match(&connlimit_match);
-+	if (ip_conntrack_module)
-+		__MOD_DEC_USE_COUNT(ip_conntrack_module);
 +}
 +
 +module_init(init);

--------------040203070708070905020708--
