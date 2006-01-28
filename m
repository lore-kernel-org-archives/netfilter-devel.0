From: Michael Rash <mbr@cipherdyne.org>
Subject: [PATCH] textsearch oops fix on 64-bit
Date: Sat, 28 Jan 2006 17:54:56 -0500
Message-ID: <20060128225456.GA14863@minastirith.cipherdyne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
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

Hi -

When using the string match on kernels 2.6.14 through 2.6.15.1, I get an
oops with Boyer-Moore on my AMD Athlon 64 processor (the Knuth-Morris-Pratt
algorithm works fine).  The oops happens at load time for any Netfilter
rule that attempts to use the string match.  I believe the problem stems
=66rom missing bounds checking on array indices in lib/ts_bm.c within
compute_prefix_tbl().  Here is a patch against 2.6.15.1; I have tested it
on both 32-bit and 64-bit processors and it seems to work.  If the patch
looks ok, I will submit it to the kernel mailing list:


--- linux-2.6.15.1/lib/ts_bm.c.orig     2006-01-27 18:22:44.000000000 -0500
+++ linux-2.6.15.1/lib/ts_bm.c  2006-01-27 18:22:50.000000000 -0500
@@ -107,8 +107,10 @@ static void compute_prefix_tbl(struct ts
        /* Compute the good shift array, used to match reocurrences
         * of a subpattern */
        for (i =3D 1; i < bm->patlen; i++) {
-               for (j =3D 0; j < bm->patlen && bm->pattern[bm->patlen - 1 =
- j]
-                               =3D=3D bm->pattern[bm->patlen - 1 - i - j];=
 j++);
+               for (j =3D 0; j < bm->patlen
+                               && (int)(bm->patlen - 1 - i - j) >=3D 0
+                               && bm->pattern[bm->patlen - 1 - j]
+                                       =3D=3D bm->pattern[bm->patlen - 1 -=
 i - j]; j++);
                l[i] =3D j;
        }


--
Michael Rash
http://www.cipherdyne.org/
Key fingerprint =3D 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F
