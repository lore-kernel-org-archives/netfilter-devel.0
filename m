From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: Idea: string replace
Date: Wed, 2 Oct 2002 01:33:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021001233327.GF22145@noir.cb.ac.at>
References: <20021001011306.GG16521@noir.cb.ac.at> <20021001072702.GA23302@oknodo.bof.de> <20021001210650.GC22145@noir.cb.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HuscSE0D68UGttcd"
Cc: Gianni Tedesco <gianni@ecsc.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20021001210650.GC22145@noir.cb.ac.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HuscSE0D68UGttcd
Content-Type: multipart/mixed; boundary="lQSB8Tqijvu1+4Ba"
Content-Disposition: inline


--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 01, 2002 at 11:06:50PM +0200, Peter Surda wrote:
> > Regarding the "is it difficult" question, that depends on whether you
> > want to replace with a string of identical length (piece of cake),
> Actually, I didn't think so far as to use different lengths, somehow I
> subconsiously assumed it is far from easy. Again, I only need this for a very
> specific purpose (disabling one virus), for which IMHO same-length-replace is
> sufficient.
Ok, so I tried, I tried really hard <g>, and it compiled, and it didn't crash,
and it seems to behave as expected (the virus attachment arrives or is
downloaded, but is artifically corrupt and doesn't work). Attached patches
(one userspace and one kernel) against cvs from end of July.

The string match has a new option, --replace-with, that takes one string as a
value. I think the code is straightforward, the checksumming stuff is pasted
from nat_helper.c (but it doesn't do conntrack of course).

Please test and report :-). I am sure there are more cool ways to use it than
fighting virii.

Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505122023

--
                            rm -f /bin/laden

--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-string.patch"
Content-Transfer-Encoding: quoted-printable

--- extensions/libipt_string.c	Wed May 29 15:08:16 2002
+++ ../userspace/extensions/libipt_string.c	Wed Oct  2 00:31:43 2002
@@ -23,7 +23,8 @@
 {
 	printf(
 "STRING match v%s options:\n"
-"--string [!] string             Match a string in a packet\n",
+"--string [!] string             Match a string in a packet\n"
+"--replace-with replace               Replace with replace\n",
 IPTABLES_VERSION);
=20
 	fputc('\n', stdout);
@@ -31,6 +32,7 @@
=20
 static struct option opts[] =3D {
 	{ "string", 1, 0, '1' },
+	{ "replace-with", 1, 0, '2' },
 	{0}
 };
=20
@@ -48,6 +50,13 @@
 	else exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 }
=20
+static void
+parse_replace(const unsigned char *s, struct ipt_string_info *info)
+{=09
+        if (strlen(s) <=3D BM_MAX_NLEN) strcpy(info->replace, s);
+	else exit_error(PARAMETER_PROBLEM, "Replace STRING too long `%s'", s);
+}
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -67,6 +76,10 @@
                 stringinfo->len=3Dstrlen((char *)&stringinfo->string);
 		*flags =3D 1;
 		break;
+	case '2':
+		parse_replace(argv[optind-1], stringinfo);
+    stringinfo->replace_len=3Dstrlen((char *)&stringinfo->replace);
+		break;
=20
 	default:
 		return 0;
@@ -83,6 +96,12 @@
 	printf("%s ",string);
 }
=20
+static void
+print_replace(char replace[], int numeric)
+{
+	printf("%s ",replace);
+}
+
 /* Final check; must have specified --string. */
 static void
 final_check(unsigned int flags)
@@ -101,6 +120,11 @@
 	printf("STRING match ");
 	print_string(((struct ipt_string_info *)match->data)->string,
 		  ((struct ipt_string_info *)match->data)->invert, numeric);
+	if (((struct ipt_string_info *)match->data)->replace_len > 0) {
+		printf(" replace-with ");
+		print_replace(((struct ipt_string_info *)match->data)->replace,
+			numeric);
+	}
 }
=20
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
@@ -110,6 +134,11 @@
 	printf("--string ");
 	print_string(((struct ipt_string_info *)match->data)->string,
 		  ((struct ipt_string_info *)match->data)->invert, 0);
+	if (((struct ipt_string_info *)match->data)->replace_len > 0) {
+		printf(" --replace-with ");
+		print_replace(((struct ipt_string_info *)match->data)->replace,
+			0);
+	}
 }
=20
 static

--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="replace-kernel.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.4.19-rc3-ac3-mppe-netfilter-htb-noreplace/include/linux/ne=
tfilter_ipv4/ipt_string.h linux-2.4.19-rc3-ac3-mppe-netfilter-htb/include/l=
inux/netfilter_ipv4/ipt_string.h
--- linux-2.4.19-rc3-ac3-mppe-netfilter-htb-noreplace/include/linux/netfilt=
er_ipv4/ipt_string.h	Tue Oct  1 02:20:32 2002
+++ linux-2.4.19-rc3-ac3-mppe-netfilter-htb/include/linux/netfilter_ipv4/ip=
t_string.h	Tue Oct  1 23:44:00 2002
@@ -14,8 +14,10 @@
=20
 struct ipt_string_info {
     char string[BM_MAX_NLEN];
+		char replace[BM_MAX_NLEN];
     u_int16_t invert;
     u_int16_t len;
+		u_int16_t replace_len;
 };
=20
 #endif /* _IPT_STRING_H */
diff -ur linux-2.4.19-rc3-ac3-mppe-netfilter-htb-noreplace/net/ipv4/netfilt=
er/ipt_string.c linux-2.4.19-rc3-ac3-mppe-netfilter-htb/net/ipv4/netfilter/=
ipt_string.c
--- linux-2.4.19-rc3-ac3-mppe-netfilter-htb-noreplace/net/ipv4/netfilter/ip=
t_string.c	Thu Jul 25 20:38:15 2002
+++ linux-2.4.19-rc3-ac3-mppe-netfilter-htb/net/ipv4/netfilter/ipt_string.c=
	Wed Oct  2 01:01:50 2002
@@ -21,7 +21,10 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/file.h>
+#include <linux/ip.h>
 #include <net/sock.h>
+#include <net/checksum.h>
+#include <net/tcp.h>
=20
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_string.h>
@@ -110,7 +113,7 @@
 	const struct ipt_string_info *info =3D matchinfo;
 	struct iphdr *ip =3D skb->nh.iph;
 	int hlen, nlen;
-	char *needle, *haystack;
+	char *needle, *haystack, *result;
 	proc_ipt_search search=3Dsearch_linear;
=20
 	if ( !ip ) return 0;
@@ -137,7 +140,22 @@
 		}
 	}
 =09
-    return ((search(needle, haystack, nlen, hlen)!=3DNULL) ^ info->invert);
+	if ((result =3D search(needle, haystack, nlen, hlen)) !=3D NULL &&
+		info->replace_len > 0) {
+			struct tcphdr *tcph =3D (void *)ip + ip->ihl*4;
+		  u_int32_t tcplen =3D skb->len - ip->ihl*4;
+		  u_int32_t datalen =3D tcplen - tcph->doff*4;
+
+			memcpy (result, info->replace, min (info->len, info->replace_len));
+
+		  skb->csum =3D csum_partial((char *)tcph + tcph->doff*4, datalen, 0);
+		  tcph->check =3D 0;
+		  tcph->check =3D tcp_v4_check(tcph, tcplen, ip->saddr, ip->daddr,
+				csum_partial((char *)tcph, tcph->doff*4, skb->csum));
+			ip_send_check(ip);
+	}
+
+  return ((result !=3D NULL) ^ info->invert);
 }
=20
 static int

--lQSB8Tqijvu1+4Ba--

--HuscSE0D68UGttcd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9mjDHzogxsPZwLzcRAituAJ9u1nwn7riBjdXjjvq0J0HX6f9rvACfdEvH
M5n2vGK12nZmIBMUX6Q9RjI=
=Q3V6
-----END PGP SIGNATURE-----

--HuscSE0D68UGttcd--
