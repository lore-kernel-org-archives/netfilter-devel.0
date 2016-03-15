From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: [PATCH] nft: Removed ^L characters
Date: Tue, 15 Mar 2016 08:43:30 +0530
Message-ID: <20160315031330.GA4185@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33238 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577AbcCODNT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 23:13:19 -0400
Received: by mail-pf0-f170.google.com with SMTP id 124so8288924pfg.0
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 20:13:18 -0700 (PDT)
Received: from fate ([117.255.60.200])
        by smtp.gmail.com with ESMTPSA id p74sm35261076pfa.11.2016.03.14.20.13.15
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 14 Mar 2016 20:13:17 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Unnecessary line-feed characters removed.

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
 COPYING        |  8 ++++----
 src/mini-gmp.c | 25 ++++++-------------------
 2 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/COPYING b/COPYING
index bf7f06e..b9e45a5 100644
--- a/COPYING
+++ b/COPYING
@@ -63,7 +63,7 @@ patent must be licensed for everyone's free use or not licensed at all.
 
   The precise terms and conditions for copying, distribution and
 modification follow.
-

+
 		    GNU GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
@@ -118,7 +118,7 @@ above, provided that you also meet all of these conditions:
     License.  (Exception: if the Program itself is interactive but
     does not normally print such an announcement, your work based on
     the Program is not required to print an announcement.)
-

+
 These requirements apply to the modified work as a whole.  If
 identifiable sections of that work are not derived from the Program,
 and can be reasonably considered independent and separate works in
@@ -176,7 +176,7 @@ access to copy from a designated place, then offering equivalent
 access to copy the source code from the same place counts as
 distribution of the source code, even though third parties are not
 compelled to copy the source along with the object code.
-

+
   4. You may not copy, modify, sublicense, or distribute the Program
 except as expressly provided under this License.  Any attempt
 otherwise to copy, modify, sublicense or distribute the Program is
@@ -233,7 +233,7 @@ impose that choice.
 
 This section is intended to make thoroughly clear what is believed to
 be a consequence of the rest of this License.
-

+
   8. If the distribution and/or use of the Program is restricted in
 certain countries either by patents or by copyrighted interfaces, the
 original copyright holder who places the Program under this License
diff --git a/src/mini-gmp.c b/src/mini-gmp.c
index acbe1be..1a679a0 100644
--- a/src/mini-gmp.c
+++ b/src/mini-gmp.c
@@ -50,7 +50,6 @@ see https://www.gnu.org/licenses/.  */
 
 #include "mini-gmp.h"
 
-

 /* Macros */
 #define GMP_LIMB_BITS (sizeof(mp_limb_t) * CHAR_BIT)
 
@@ -238,7 +237,6 @@ see https://www.gnu.org/licenses/.  */
 
 const int mp_bits_per_limb = GMP_LIMB_BITS;
 
-

 /* Memory allocation and other helper functions. */
 static void
 gmp_die (const char *msg)
@@ -332,7 +330,6 @@ gmp_xrealloc_limbs (mp_ptr old, mp_size_t size)
   return (*gmp_reallocate_func) (old, 0, size * sizeof (mp_limb_t));
 }
 
-

 /* MPN interface */
 
 void
@@ -702,7 +699,6 @@ mpn_scan0 (mp_srcptr ptr, mp_bitcnt_t bit)
 			  i, ptr, i, GMP_LIMB_MAX);
 }
 
-

 /* MPN division interface. */
 mp_limb_t
 mpn_invert_3by2 (mp_limb_t u1, mp_limb_t u0)
@@ -1102,7 +1098,6 @@ mpn_div_qr (mp_ptr qp, mp_ptr np, mp_size_t nn, mp_srcptr dp, mp_size_t dn)
     gmp_free (tp);
 }
 
-

 /* MPN base conversion. */
 static unsigned
 mpn_base_power_of_two_p (unsigned b)
@@ -1357,7 +1352,6 @@ mpn_set_str (mp_ptr rp, const unsigned char *sp, size_t sn, int base)
     }
 }
 
-

 /* MPZ interface */
 void
 mpz_init (mpz_t r)
@@ -1406,7 +1400,7 @@ mpz_realloc (mpz_t r, mp_size_t size)
 #define MPZ_REALLOC(z,n) ((n) > (z)->_mp_alloc			\
 			  ? mpz_realloc(z,n)			\
 			  : (z)->_mp_d)
-

+
 /* MPZ assignment and basic conversions. */
 void
 mpz_set_si (mpz_t r, signed long int x)
@@ -1569,7 +1563,6 @@ mpz_roinit_n (mpz_t x, mp_srcptr xp, mp_size_t xs)
   return x;
 }
 
-

 /* Conversions and comparison to double. */
 void
 mpz_set_d (mpz_t r, double x)
@@ -1711,7 +1704,6 @@ mpz_cmp_d (const mpz_t x, double d)
     }
 }
 
-

 /* MPZ comparisons and the like. */
 int
 mpz_sgn (const mpz_t u)
@@ -1819,7 +1811,6 @@ mpz_swap (mpz_t u, mpz_t v)
   MP_PTR_SWAP (u->_mp_d, v->_mp_d);
 }
 
-

 /* MPZ addition and subtraction */
 
 /* Adds to the absolute value. Returns new size, but doesn't store it. */
@@ -1971,7 +1962,6 @@ mpz_sub (mpz_t r, const mpz_t a, const mpz_t b)
   r->_mp_size = a->_mp_size >= 0 ? rn : - rn;
 }
 
-

 /* MPZ multiplication */
 void
 mpz_mul_si (mpz_t r, const mpz_t u, long int v)
@@ -2123,7 +2113,6 @@ mpz_submul (mpz_t r, const mpz_t u, const mpz_t v)
   mpz_clear (t);
 }
 
-

 /* MPZ division */
 enum mpz_div_round_mode { GMP_DIV_FLOOR, GMP_DIV_CEIL, GMP_DIV_TRUNC };
 
@@ -2652,7 +2641,6 @@ mpz_divisible_ui_p (const mpz_t n, unsigned long d)
   return mpz_div_qr_ui (NULL, NULL, n, d, GMP_DIV_TRUNC) == 0;
 }
 
-

 /* GCD */
 static mp_limb_t
 mpn_gcd_11 (mp_limb_t u, mp_limb_t v)
@@ -3046,7 +3034,6 @@ mpz_invert (mpz_t r, const mpz_t u, const mpz_t m)
   return invertible;
 }
 
-

 /* Higher level operations (sqrt, pow and root) */
 
 void
@@ -3326,7 +3313,7 @@ mpn_sqrtrem (mp_ptr sp, mp_ptr rp, mp_srcptr p, mp_size_t n)
   mpz_clear (r);
   return res;
 }
-

+
 /* Combinatorics */
 
 void
@@ -3357,7 +3344,7 @@ mpz_bin_uiui (mpz_t r, unsigned long n, unsigned long k)
   mpz_clear (t);
 }
 
-

+
 /* Primality testing */
 static int
 gmp_millerrabin (const mpz_t n, const mpz_t nm1, mpz_t y,
@@ -3453,7 +3440,7 @@ mpz_probab_prime_p (const mpz_t n, int reps)
   return is_prime;
 }
 
-

+
 /* Logical operations and bit manipulation. */
 
 /* Numbers are treated as if represented in two's complement (and
@@ -3985,7 +3972,7 @@ mpz_scan0 (const mpz_t u, mp_bitcnt_t starting_bit)
   return mpn_common_scan (limb, i, up, un, ux);
 }
 
-

+
 /* MPZ base conversion. */
 
 size_t
@@ -4218,7 +4205,7 @@ mpz_out_str (FILE *stream, int base, const mpz_t x)
   return len;
 }
 
-

+
 static int
 gmp_detect_endian (void)
 {
-- 
1.9.1


-- 

With regards,
Piyush Pangtey <gokuvsvegita@gmail.com>
