From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: latest pom: base/connlimit breaks kernel 2.4.25 compile (+possible
 fix)
Date: Sat, 10 Apr 2004 17:03:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40780CAD.6080305@fl.priv.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020705070304070800010207"
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
--------------020705070304070800010207
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

Applying the latest pom-20040409 to kernel 2.4.25 breaks the compile:

gcc -D__KERNEL__ -I/data/build/tmp/linux-2.4.25/include -Wall 
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common 
-fomit-frame-pointer  -pipe -mpreferred-stack-boundary=2 -march
=i586 -DMODULE -DMODVERSIONS -include 
/data/build/tmp/linux-2.4.25/include/linux/modversions.h  -nostdinc 
-iwithprefix include -DKBUILD_BASENAME=ipt_connlimit  -c -o ipt_connlimit.o 
ipt_connlimit.c
ipt_connlimit.c: In function `init':
ipt_connlimit.c:219: error: `ip_conntrack_module' undeclared (first use in 
this function)
ipt_connlimit.c:219: error: (Each undeclared identifier is reported only once
ipt_connlimit.c:219: error: for each function it appears in.)
ipt_connlimit.c:220: warning: value computed is not used
ipt_connlimit.c: In function `fini':
ipt_connlimit.c:227: error: `ip_conntrack_module' undeclared (first use in 
this function)
ipt_connlimit.c:228: warning: value computed is not used
make[3]: *** [ipt_connlimit.o] Error 1
make[3]: Leaving directory `/data/build/tmp/linux-2.4.25/net/ipv4/netfilter'
make[2]: *** [_modsubdir_ipv4/netfilter] Error 2
make[2]: Leaving directory `/data/build/tmp/linux-2.4.25/net'
make[1]: *** [_mod_net] Error 2
make[1]: Leaving directory `/data/build/tmp/linux-2.4.25'

I was woundering if the correct way to fix this is to create the
   struct module *ip_connlimit_module
variable in ipt_connlimit.c and use it instead of the undefined
variable "ip_conntrack_module". See also attached patch for how
I think I would do it.

What do you think?

-- 
MfG / Regards
Friedrich Lobenstock

--------------020705070304070800010207
Content-Type: text/plain;
 name="patch-broken-ipt_connlimit.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-broken-ipt_connlimit.c"

--- linux-2.4.25/net/ipv4/netfilter/ipt_connlimit.c.broken	2004-04-10 17:01:40.000000000 +0200
+++ linux-2.4.25/net/ipv4/netfilter/ipt_connlimit.c	2004-04-10 17:02:18.000000000 +0200
@@ -23,6 +23,8 @@
 
 MODULE_LICENSE("GPL");
 
+struct module *ip_connlimit_module = THIS_MODULE;
+
 /* we'll save the tuples of all connections we care about */
 struct ipt_connlimit_conn
 {
@@ -215,17 +217,17 @@
 
 static int __init init(void)
 {
-	/* NULL if ip_conntrack not a module */
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
+	/* NULL if ip_connlimit not a module */
+	if (ip_connlimit_module)
+		__MOD_INC_USE_COUNT(ip_connlimit_module);
 	return ipt_register_match(&connlimit_match);
 }
 
 static void __exit fini(void)
 {
 	ipt_unregister_match(&connlimit_match);
-	if (ip_conntrack_module)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
+	if (ip_connlimit_module)
+		__MOD_DEC_USE_COUNT(ip_connlimit_module);
 }
 
 module_init(init);

--------------020705070304070800010207--
