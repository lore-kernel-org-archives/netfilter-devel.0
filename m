From: Daniel De Graaf <danield@iastate.edu>
Subject: [PATCH] remove unneeded ip6tables-save source/destination address
 output
Date: Fri, 01 Dec 2006 18:50:12 -0600
Message-ID: <4570CDC4.2090205@iastate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

ip6tables-save outputs the source and destination IPs when it is not
needed. This
is caused by an incorrectly copied check from iptables-save. Example
output:
- -A INPUT -s ::/0 -d ::/0 -i lo -j ACCEPT instead of just -A INPUT -i
lo -j ACCEPT

This patch will not output the address if the mask length is zero.

- - Daniel De Graaf

Index: ip6tables-save.c
===================================================================
- --- ip6tables-save.c    (revision 6699)
+++ ip6tables-save.c    (working copy)
@@ -125,7 +125,7 @@
        char buf[51];
        int l = ipv6_prefix_length(mask);
 
- -       if (!mask && !ip)
+       if (l == 0)
                return;
 
        printf("%s %s%s",
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFcM3DZz9quLVV3/MRAuYSAJ9wUCXr8yEiClPeuVfANBISlzBGTACffYHh
dFqNciiAzKuvSTw7pXV2cAA=
=Ssso
-----END PGP SIGNATURE-----
