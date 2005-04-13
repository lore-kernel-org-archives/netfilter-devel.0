From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCH] goto update so that iptables-save and iptables -L work
	correctly
Date: Wed, 13 Apr 2005 00:33:08 +0000
Message-ID: <425C68C4.5000304@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000307080803060405070806"
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
--------------000307080803060405070806
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The attached file is meant to go into patch-o-matic-ng/goto/

In iptables -L it will show as [goto] in the match extension part (the
rightmost column). If you think it should be displayed somehow else, I'm
open to suggestions.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCXGjCxyF48ZTvn+4RAkWoAKCFDRH2lnUBGZZp8oP9ia0Ny1OOhACguSX5
KysCbKB06AmW+eX9bj8Hlvc=
=U7VR
-----END PGP SIGNATURE-----

--------------000307080803060405070806
Content-Type: text/plain;
 name="iptables.patch_2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables.patch_2"

diff --exclude-from=/tmp/srcdiff.excludes.C7Vgtq -Np -ur orig-iptables-1.3.1/iptables-save.c iptables-1.3.1/iptables-save.c
--- orig-iptables-1.3.1/iptables-save.c	2005-03-27 10:08:39.000000000 +0300
+++ iptables-1.3.1/iptables-save.c	2005-03-27 10:03:35.000000000 +0300
@@ -197,7 +197,7 @@ static void print_rule(const struct ipt_
 	/* Print target name */	
 	target_name = iptc_get_target(e, h);
 	if (target_name && (*target_name != '\0'))
-		printf("-j %s ", target_name);
+		printf("-%c %s ", e->ip.flags & IPT_F_GOTO ? 'g' : 'j', target_name);
 
 	/* Print targinfo part */
 	t = ipt_get_target((struct ipt_entry *)e);
diff --exclude-from=/tmp/srcdiff.excludes.C7Vgtq -Np -ur orig-iptables-1.3.1/iptables.c iptables-1.3.1/iptables.c
--- orig-iptables-1.3.1/iptables.c	2005-03-27 10:25:03.000000000 +0300
+++ iptables-1.3.1/iptables.c	2005-03-27 09:56:35.000000000 +0300
@@ -1398,6 +1398,9 @@ print_firewall(const struct ipt_entry *f
 	if (format & FMT_NOTABLE)
 		fputs("  ", stdout);
 
+	if(fw->ip.flags & IPT_F_GOTO)
+		printf("[goto] ");
+
 	IPT_MATCH_ITERATE(fw, print_match, &fw->ip, format & FMT_NUMERIC);
 
 	if (target) {

--------------000307080803060405070806--
