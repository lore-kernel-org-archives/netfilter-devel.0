From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCh] Some ip6tables bugfixes
Date: Sun, 27 Mar 2005 07:40:17 +0300
Message-ID: <42463931.5030904@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080705000802010103010701"
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
--------------080705000802010103010701
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I had some problems with porting ipv4 modules to ipv6 and after doing a

~  diff -uw iptables.c ip6tables.c

I noticed that in ipv6, no checks are done to see if the "init" function of
a match or target is defined, whereas in ipv4 it's done.

So this patch changes ip6tables to also check if init != NULL before calling
it. Also updated some strings & comments to read "ip6tables" instead of
"iptables".

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCRjkwxyF48ZTvn+4RArMiAKDe7uqcW1Gm5p3C4G9sIwmgMK0ifwCeIKsW
Ur6LQfHkUtzlsV1TRBkeGBA=
=27ws
-----END PGP SIGNATURE-----

--------------080705000802010103010701
Content-Type: text/x-patch;
 name="ip6tables-initfix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip6tables-initfix.patch"

Index: iptables/ip6tables.c
===================================================================
--- iptables/ip6tables.c	(revision 3805)
+++ iptables/ip6tables.c	(working copy)
@@ -1,4 +1,4 @@
-/* Code to take an iptables-style command line and do it. */
+/* Code to take an ip6tables-style command line and do it. */
 
 /*
  * Author: Paul.Russell@rustcorp.com.au and mneuling@radlogic.com.au
@@ -266,7 +266,7 @@
 		exit_tryhelp(status);
 	if (status == VERSION_PROBLEM)
 		fprintf(stderr,
-			"Perhaps iptables or your kernel needs to be upgraded.\n");
+			"Perhaps ip6tables or your kernel needs to be upgraded.\n");
 	exit(status);
 }
 
@@ -1859,7 +1859,7 @@
 			if (!optarg)
 				optarg = argv[optind];
 
-			/* iptables -p icmp -h */
+			/* ip6tables -p icmp -h */
 			if (!matches && protocol)
 				find_match(protocol, TRY_LOAD, &matches);
 
@@ -1919,7 +1919,8 @@
 				target->t = fw_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
-				target->init(target->t, &fw.nfcache);
+				if (target->init != NULL)
+					target->init(target->t, &fw.nfcache);
 				opts = merge_options(opts, target->extra_opts, &target->option_offset);
 			}
 			break;
@@ -1963,7 +1964,8 @@
 			m->m = fw_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
-			m->init(m->m, &fw.nfcache);
+			if (m->init != NULL)
+				m->init(m->m, &fw.nfcache);
 			opts = merge_options(opts, m->extra_opts, &m->option_offset);
 		}
 		break;
@@ -2079,7 +2081,7 @@
 				 * - a protocol has been specified
 				 * - the protocol extension has not been
 				 *   loaded yet, or is loaded and unused
-				 *   [think of iptables-restore!]
+				 *   [think of ip6tables-restore!]
 				 * - the protocol extension can be successively
 				 *   loaded
 				 */
@@ -2104,7 +2106,8 @@
 					m->m = fw_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
-					m->init(m->m, &fw.nfcache);
+					if (m->init != NULL)
+						m->init(m->m, &fw.nfcache);
 
 					opts = merge_options(opts,
 					    m->extra_opts, &m->option_offset);
@@ -2232,7 +2235,8 @@
 			target->t = fw_calloc(1, size);
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
-			target->init(target->t, &fw.nfcache);
+			if (target->init != NULL)
+				target->init(target->t, &fw.nfcache);
 		}
 
 		if (!target) {

--------------080705000802010103010701--
