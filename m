From: Anatoly Pugachev <mator@rootshell.ru>
Subject: [PATCH pom-ng] string match on 2.6 kernel
Date: Wed, 6 Apr 2005 19:16:45 +0400
Message-ID: <20050406151645.GA3921@helminth.linuxhacker.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
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


--dc+cDN39EJAMEtIO
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This kernel-2.6 patch is over cvs version of patch-o-matic, i'm used patch-=
o-
matic-ng-20050316. Since i'm not a kernel programmer, this patch isn't SMP
clean - noticed this in string/linux-2.6/info.=20
'diff -ru string/linux string/linux-2.6' for my changes over original sourc=
es.=20
Someone please fix my lameness.

I've tested it over my linux 2.6.10 kernel and it "works for me".

PS: maybe smp_num_cpus =3D num_booting_cpus() can help?
--=20
Anatoly Pugachev

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="pom-string-kernel26-no-SMP-clean.patch"
Content-Transfer-Encoding: quoted-printable

diff -ruN patch-o-matic-ng-20050316/string/help pom/string/help
--- patch-o-matic-ng-20050316/string/help	2003-12-18 21:47:52.000000000 +03=
00
+++ pom/string/help	2005-03-18 19:58:44.000000000 +0300
@@ -4,3 +4,6 @@
=20
 THIS PATCH DOES NOT WORK WITH KERNEL 2.4.9 !!!
=20
+ Doesn't work with SMP kernel 2.6.x
+
+Usage example:
+# iptables -A INPUT -m string --string 'cmd.exe' -j QUEUE
+
diff -ruN patch-o-matic-ng-20050316/string/info pom/string/info
--- patch-o-matic-ng-20050316/string/info	2005-02-21 23:05:18.000000000 +03=
00
+++ pom/string/info	2005-03-17 10:20:56.000000000 +0300
@@ -2,4 +2,3 @@
 Author: Emmanuel Roger <winfield@freegates.be>
 Status: Working, not with kernel 2.4.9
 Repository: extra
-Requires: linux < 2.6.0
diff -ruN patch-o-matic-ng-20050316/string/linux-2.6/include/linux/netfilte=
r_ipv4/ipt_string.h pom/string/linux-2.6/include/linux/netfilter_ipv4/ipt_s=
tring.h
--- patch-o-matic-ng-20050316/string/linux-2.6/include/linux/netfilter_ipv4=
/ipt_string.h	1970-01-01 03:00:00.000000000 +0300
+++ pom/string/linux-2.6/include/linux/netfilter_ipv4/ipt_string.h	2003-12-=
18 21:47:52.000000000 +0300
@@ -0,0 +1,21 @@
+#ifndef _IPT_STRING_H
+#define _IPT_STRING_H
+
+/* *** PERFORMANCE TWEAK ***
+ * Packet size and search string threshold,
+ * above which sublinear searches is used. */
+#define IPT_STRING_HAYSTACK_THRESH	100
+#define IPT_STRING_NEEDLE_THRESH	20
+
+#define BM_MAX_NLEN 256
+#define BM_MAX_HLEN 1024
+
+typedef char *(*proc_ipt_search) (char *, char *, int, int);
+
+struct ipt_string_info {
+    char string[BM_MAX_NLEN];
+    u_int16_t invert;
+    u_int16_t len;
+};
+
+#endif /* _IPT_STRING_H */
diff -ruN patch-o-matic-ng-20050316/string/linux-2.6/net/ipv4/netfilter/ipt=
_string.c pom/string/linux-2.6/net/ipv4/netfilter/ipt_string.c
--- patch-o-matic-ng-20050316/string/linux-2.6/net/ipv4/netfilter/ipt_strin=
g.c	1970-01-01 03:00:00.000000000 +0300
+++ pom/string/linux-2.6/net/ipv4/netfilter/ipt_string.c	2005-03-17 11:24:4=
3.000000000 +0300
@@ -0,0 +1,223 @@
+/* Kernel module to match a string into a packet.
+ *
+ * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>
+ *=20
+ * ChangeLog
+ *	19.02.2002: Gianni Tedesco <gianni@ecsc.co.uk>
+ *		Fixed SMP re-entrancy problem using per-cpu data areas
+ *		for the skip/shift tables.
+ *	02.05.2001: Gianni Tedesco <gianni@ecsc.co.uk>
+ *		Fixed kernel panic, due to overrunning boyer moore string
+ *		tables. Also slightly tweaked heuristic for deciding what
+ * 		search algo to use.
+ * 	27.01.2001: Gianni Tedesco <gianni@ecsc.co.uk>
+ * 		Implemented Boyer Moore Sublinear search algorithm
+ * 		alongside the existing linear search based on memcmp().
+ * 		Also a quick check to decide which method to use on a per
+ * 		packet basis.
+ */
+
+#include <linux/smp.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/file.h>
+#include <net/sock.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_string.h>
+
+MODULE_LICENSE("GPL");
+
+struct string_per_cpu {
+	int *skip;
+	int *shift;
+	int *len;
+};
+
+struct string_per_cpu *bm_string_data=3DNULL;
+
+/* Boyer Moore Sublinear string search - VERY FAST */
+char *search_sublinear (char *needle, char *haystack, int needle_len, int =
haystack_len)=20
+{
+	int M1, right_end, sk, sh; =20
+	int ended, j, i;
+
+	int *skip, *shift, *len;
+=09
+	/* use data suitable for this CPU */
+	shift=3Dbm_string_data[smp_processor_id()].shift;
+	skip=3Dbm_string_data[smp_processor_id()].skip;
+	len=3Dbm_string_data[smp_processor_id()].len;
+=09
+	/* Setup skip/shift tables */
+	M1 =3D right_end =3D needle_len-1;
+	for (i =3D 0; i < BM_MAX_HLEN; i++) skip[i] =3D needle_len; =20
+	for (i =3D 0; needle[i]; i++) skip[needle[i]] =3D M1 - i; =20
+
+	for (i =3D 1; i < needle_len; i++) {  =20
+		for (j =3D 0; j < needle_len && needle[M1 - j] =3D=3D needle[M1 - i - j]=
; j++); =20
+		len[i] =3D j; =20
+	} =20
+
+	shift[0] =3D 1; =20
+	for (i =3D 1; i < needle_len; i++) shift[i] =3D needle_len; =20
+	for (i =3D M1; i > 0; i--) shift[len[i]] =3D i; =20
+	ended =3D 0; =20
+=09
+	for (i =3D 0; i < needle_len; i++) { =20
+		if (len[i] =3D=3D M1 - i) ended =3D i; =20
+		if (ended) shift[i] =3D ended; =20
+	} =20
+
+	/* Do the search*/ =20
+	while (right_end < haystack_len)
+	{
+		for (i =3D 0; i < needle_len && haystack[right_end - i] =3D=3D needle[M1=
 - i]; i++); =20
+		if (i =3D=3D needle_len) {
+			return haystack+(right_end - M1);
+		}
+	=09
+		sk =3D skip[haystack[right_end - i]]; =20
+		sh =3D shift[i];
+		right_end =3D max(right_end - i + sk, right_end + sh); =20
+	}
+
+	return NULL;
+} =20
+
+/* Linear string search based on memcmp() */
+char *search_linear (char *needle, char *haystack, int needle_len, int hay=
stack_len)=20
+{
+	char *k =3D haystack + (haystack_len-needle_len);
+	char *t =3D haystack;
+=09
+	while ( t <=3D k ) {
+		if (memcmp(t, needle, needle_len) =3D=3D 0)
+			return t;
+		t++;
+	}
+
+	return NULL;
+}
+
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *hdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+	const struct ipt_string_info *info =3D matchinfo;
+	struct iphdr *ip =3D skb->nh.iph;
+	int hlen, nlen;
+	char *needle, *haystack;
+	proc_ipt_search search=3Dsearch_linear;
+
+	if ( !ip ) return 0;
+
+	/* get lenghts, and validate them */
+	nlen=3Dinfo->len;
+	hlen=3Dntohs(ip->tot_len)-(ip->ihl*4);
+	if ( nlen > hlen ) return 0;
+
+	needle=3D(char *)&info->string;
+	haystack=3D(char *)ip+(ip->ihl*4);
+
+	/* The sublinear search comes in to its own
+	 * on the larger packets */
+	if ( (hlen>IPT_STRING_HAYSTACK_THRESH) &&
+	  	(nlen>IPT_STRING_NEEDLE_THRESH) ) {
+		if ( hlen < BM_MAX_HLEN ) {
+			search=3Dsearch_sublinear;
+		}else{
+			if (net_ratelimit())
+				printk(KERN_INFO "ipt_string: Packet too big "
+					"to attempt sublinear string search "
+					"(%d bytes)\n", hlen );
+		}
+	}
+=09
+    return ((search(needle, haystack, nlen, hlen)!=3DNULL) ^ info->invert);
+}
+
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+
+       if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_string_info)))
+               return 0;
+
+       return 1;
+}
+
+void string_freeup_data(void)
+{
+	int c;
+=09
+	if ( bm_string_data ) {
+#if defined(CONFIG_SMP)
+		for(c=3D0; c<smp_num_cpus; c++) {
+			if ( bm_string_data[c].shift ) kfree(bm_string_data[c].shift);
+			if ( bm_string_data[c].skip ) kfree(bm_string_data[c].skip);
+			if ( bm_string_data[c].len ) kfree(bm_string_data[c].len);
+		}
+#endif
+		kfree(bm_string_data);
+	}
+}
+
+static struct ipt_match string_match
+=3D { { NULL, NULL }, "string", &match, &checkentry, NULL, THIS_MODULE };
+
+static int __init init(void)
+{
+	int c;
+	size_t tlen;
+	size_t alen;
+
+#ifndef CONFIG_SMP
+  #define smp_num_cpus 1
+#endif
+	tlen=3Dsizeof(struct string_per_cpu)*smp_num_cpus;
+	alen=3Dsizeof(int)*BM_MAX_HLEN;
+=09
+	/* allocate array of structures */
+	if ( !(bm_string_data=3Dkmalloc(tlen,GFP_KERNEL)) ) {
+		return 0;
+	}
+=09
+	memset(bm_string_data, 0, tlen);
+=09
+	/* allocate our skip/shift tables */
+	for(c=3D0; c<smp_num_cpus; c++) {
+		if ( !(bm_string_data[c].shift=3Dkmalloc(alen, GFP_KERNEL)) )
+			goto alloc_fail;
+		if ( !(bm_string_data[c].skip=3Dkmalloc(alen, GFP_KERNEL)) )
+			goto alloc_fail;
+		if ( !(bm_string_data[c].len=3Dkmalloc(alen, GFP_KERNEL)) )
+			goto alloc_fail;
+	}
+=09
+	return ipt_register_match(&string_match);
+
+alloc_fail:
+	string_freeup_data();
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&string_match);
+	string_freeup_data();
+}
+
+module_init(init);
+module_exit(fini);
diff -ruN patch-o-matic-ng-20050316/string/linux-2.6/net/ipv4/netfilter/Kco=
nfig.ladd pom/string/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
--- patch-o-matic-ng-20050316/string/linux-2.6/net/ipv4/netfilter/Kconfig.l=
add	1970-01-01 03:00:00.000000000 +0300
+++ pom/string/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	2004-05-06 17:45:4=
3.000000000 +0400
@@ -0,0 +1,9 @@
+config IP_NF_MATCH_STRING
+	tristate  'String match support'
+	depends on IP_NF_IPTABLES
+	help
+	  String matching alows you to match packets which contain a
+	  specified string of characters.
+=09
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
diff -ruN patch-o-matic-ng-20050316/string/linux-2.6/net/ipv4/netfilter/Mak=
efile.ladd pom/string/linux-2.6/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng-20050316/string/linux-2.6/net/ipv4/netfilter/Makefile.=
ladd	1970-01-01 03:00:00.000000000 +0300
+++ pom/string/linux-2.6/net/ipv4/netfilter/Makefile.ladd	2005-03-17 12:35:=
01.000000000 +0300
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_HELPER) +=3D ipt_helper.o
+obj-$(CONFIG_IP_NF_MATCH_STRING) +=3D ipt_string.o

--n8g4imXOkfNTN/H1--

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFCU/1boubiDytudlARAqXCAJ9WXZHscbnTOYOaxVbPxeT9nKeePwCfcCub
VAgcV+kRyGf549IthsSuGdQ=
=4k8q
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
