From: Franz Ferdinand <mojo7777@yandex.ru>
Subject: [PATCH] EXPORT_SYMBOL_GPL in talk-conntrack-nat and
	quake3-conntrack-nat appears to be missing (kernel 2.6.12)
Date: Mon, 01 Aug 2005 19:37:34 +0200
Message-ID: <1122917854.5098.18.camel@acer.home.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Depmod reports missing symbols in the two modules. Below is the fix:

//////////////////////////
1. talk-conntrack-nat.
//////////////////////////

--- patch-o-matic-ng/patchlets/talk-conntrack-
nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_talk.c.orig	2005-07-28
22:39:52.000000000 +0200
+++ patch-o-matic-ng/patchlets/talk-conntrack-
nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_talk.c	2005-08-01
01:09:51.000000000 +0200
@@ -101,8 +101,11 @@
 
 void ip_ct_talk_expect(struct ip_conntrack *ct,
 		       struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_ct_talk_expect);
+
 void ip_ct_ntalk_expect(struct ip_conntrack *ct,
 			struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_ct_ntalk_expect);
 
 static void (*talk_expectfn[2])(struct ip_conntrack *ct,
 				struct ip_conntrack_expect *exp) = {

//////////////////////////
2. quake-conntrack-nat.
//////////////////////////

--- patch-o-matic-ng/patchlets/quake3-conntrack-
nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_quake3.c.orig
2005-08-01 00:58:08.000000000 +0200
+++ patch-o-matic-ng/patchlets/quake3-conntrack-
nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_quake3.c	2005-08-01
00:54:24.000000000 +0200
@@ -42,7 +42,8 @@
 static char quake3_buffer[65536];
 static DECLARE_LOCK(quake3_buffer_lock);
 
-static unsigned int (*ip_nat_quake3_hook)(struct ip_conntrack_expect
*exp);
+unsigned int (*ip_nat_quake3_hook)(struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_nat_quake3_hook);
 
 /* Quake3 master server reply will add > 100 expectations per reply
packet; when
    doing lots of printk's, klogd may not be able to read /proc/kmsg
fast enough */

//////////////////////////
and a small suggestion.
For those, who creates series of patches with pom2patch, the following
might be useful, freeing people from specifying kernel and iptables dirs
on the command line over and over again:
//////////////////////////

--- patch-o-matic-ng/pom2patch/pom2patch.orig	2005-08-01
17:20:05.000000000 +0200
+++ patch-o-matic-ng/pom2patch/pom2patch	2005-08-01 17:18:28.000000000
+0200
@@ -8,14 +8,30 @@
 
 POMDIR=`pwd`
 
-PLAINKERNEL=$1
-PATCH=$2
+# Is calling pom2patch from the POM root dir the usual way
+# to do it? If so, put dirname guard here.
+P2PPREFIX=`dirname $0`
 
-if [ "$1" = "" -o "$2" = "" ]; then
-	echo Please specify kernel and patch as parameters
+if [ -f $P2PPREFIX/pom2patch.conf ]; then 
+    . $P2PPREFIX/pom2patch.conf
+fi
+
+PLAINKERNEL=$KERNELDIR
+PATCH=$1
+
+if [ "$1" = "" ]; then
+	echo Please specify patch as parameter
 	exit 1
 fi
 
+if [ -z "$PLAINKERNEL" ]; then
+    if [ -z "$2" ]; then
+	echo "Please specify kernel path either as parameter or KERNELDIR in
pom2patch.conf"
+	exit 1
+    else
+	PLAINKERNEL=$2
+    fi    
+fi
 
 WORKDIR=`dirname $PLAINKERNEL`
 KERNEL=`basename $PLAINKERNEL`
@@ -45,7 +61,12 @@
 OLDPWD=`pwd`
 cd $POMDIR
 export KERNEL_DIR=$WORKDIR/$KERNEL_OUT
-export IPTABLES_DIR=/usr/src/iptables
+
+if [ ! -z "$IPTABLESDIR" ]; then
+    export IPTABLES_DIR=$IPTABLESDIR
+else
+    export IPTABLES_DIR=/usr/src/iptables
+fi
 echo "y" | ./runme $PATCH > /dev/null #2>&1
 cd $OLDPWD
 diff -Nru $KERNEL $KERNEL_OUT

//////////////////////////
and the config file itself
//////////////////////////

--- /dev/null	2005-08-01 16:31:38.363880520 +0200
+++ patch-o-matic-ng/pom2patch/pom2patch.conf	2005-08-01
19:30:30.000000000 +0200
@@ -0,0 +1,2 @@
+KERNELDIR=
+IPTABLESDIR=

//////////////////////////
Regards,
Michailow
