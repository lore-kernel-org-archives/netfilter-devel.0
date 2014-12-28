From: Steven Barth <cyrus@openwrt.org>
Subject: [PATCH 4/5] mini-gmp: add mini-gmp source and headers from gmplib 6.0
Date: Sun, 28 Dec 2014 18:17:44 +0100
Message-ID: <1419787065-26146-5-git-send-email-cyrus@openwrt.org>
References: <1419787065-26146-1-git-send-email-cyrus@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steven Barth <cyrus@openwrt.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.core-networks.de ([82.96.72.7]:52825 "EHLO
	mail.core-networks.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaL1RqP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Dec 2014 12:46:15 -0500
In-Reply-To: <1419787065-26146-1-git-send-email-cyrus@openwrt.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Steven Barth <cyrus@openwrt.org>
---
 include/mini-gmp.h |  294 ++++
 src/mini-gmp.c     | 4386 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++
 2 files changed, 4680 insertions(+)
 create mode 100644 include/mini-gmp.h
 create mode 100644 src/mini-gmp.c

diff --git a/include/mini-gmp.h b/include/mini-gmp.h
new file mode 100644
index 0000000..c043ca7
--- /dev/null
+++ b/include/mini-gmp.h
@@ -0,0 +1,294 @@
+/* mini-gmp, a minimalistic implementation of a GNU GMP subset.
+
+Copyright 2011-2014 Free Software Foundation, Inc.
+
+This file is part of the GNU MP Library.
+
+The GNU MP Library is free software; you can redistribute it and/or mo=
dify
+it under the terms of either:
+
+  * the GNU Lesser General Public License as published by the Free
+    Software Foundation; either version 3 of the License, or (at your
+    option) any later version.
+
+or
+
+  * the GNU General Public License as published by the Free Software
+    Foundation; either version 2 of the License, or (at your option) a=
ny
+    later version.
+
+or both in parallel, as here.
+
+The GNU MP Library is distributed in the hope that it will be useful, =
but
+WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABI=
LITY
+or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licen=
se
+for more details.
+
+You should have received copies of the GNU General Public License and =
the
+GNU Lesser General Public License along with the GNU MP Library.  If n=
ot,
+see https://www.gnu.org/licenses/.  */
+
+/* About mini-gmp: This is a minimal implementation of a subset of the
+   GMP interface. It is intended for inclusion into applications which
+   have modest bignums needs, as a fallback when the real GMP library
+   is not installed.
+
+   This file defines the public interface. */
+
+#ifndef __MINI_GMP_H__
+#define __MINI_GMP_H__
+
+/* For size_t */
+#include <stddef.h>
+
+#if defined (__cplusplus)
+extern "C" {
+#endif
+
+void mp_set_memory_functions (void *(*) (size_t),
+			      void *(*) (void *, size_t, size_t),
+			      void (*) (void *, size_t));
+
+void mp_get_memory_functions (void *(**) (size_t),
+			      void *(**) (void *, size_t, size_t),
+			      void (**) (void *, size_t));
+
+typedef unsigned long mp_limb_t;
+typedef long mp_size_t;
+typedef unsigned long mp_bitcnt_t;
+
+typedef mp_limb_t *mp_ptr;
+typedef const mp_limb_t *mp_srcptr;
+
+typedef struct
+{
+  int _mp_alloc;		/* Number of *limbs* allocated and pointed
+				   to by the _mp_d field.  */
+  int _mp_size;			/* abs(_mp_size) is the number of limbs the
+				   last field points to.  If _mp_size is
+				   negative this is a negative number.  */
+  mp_limb_t *_mp_d;		/* Pointer to the limbs.  */
+} __mpz_struct;
+
+typedef __mpz_struct mpz_t[1];
+
+typedef __mpz_struct *mpz_ptr;
+typedef const __mpz_struct *mpz_srcptr;
+
+extern const int mp_bits_per_limb;
+
+void mpn_copyi (mp_ptr, mp_srcptr, mp_size_t);
+void mpn_copyd (mp_ptr, mp_srcptr, mp_size_t);
+void mpn_zero (mp_ptr, mp_size_t);
+
+int mpn_cmp (mp_srcptr, mp_srcptr, mp_size_t);
+
+mp_limb_t mpn_add_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);
+mp_limb_t mpn_add_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);
+mp_limb_t mpn_add (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t)=
;
+
+mp_limb_t mpn_sub_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);
+mp_limb_t mpn_sub_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);
+mp_limb_t mpn_sub (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t)=
;
+
+mp_limb_t mpn_mul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);
+mp_limb_t mpn_addmul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);
+mp_limb_t mpn_submul_1 (mp_ptr, mp_srcptr, mp_size_t, mp_limb_t);
+
+mp_limb_t mpn_mul (mp_ptr, mp_srcptr, mp_size_t, mp_srcptr, mp_size_t)=
;
+void mpn_mul_n (mp_ptr, mp_srcptr, mp_srcptr, mp_size_t);
+void mpn_sqr (mp_ptr, mp_srcptr, mp_size_t);
+int mpn_perfect_square_p (mp_srcptr, mp_size_t);
+mp_size_t mpn_sqrtrem (mp_ptr, mp_ptr, mp_srcptr, mp_size_t);
+
+mp_limb_t mpn_lshift (mp_ptr, mp_srcptr, mp_size_t, unsigned int);
+mp_limb_t mpn_rshift (mp_ptr, mp_srcptr, mp_size_t, unsigned int);
+
+mp_bitcnt_t mpn_scan0 (mp_srcptr, mp_bitcnt_t);
+mp_bitcnt_t mpn_scan1 (mp_srcptr, mp_bitcnt_t);
+
+mp_bitcnt_t mpn_popcount (mp_srcptr, mp_size_t);
+
+mp_limb_t mpn_invert_3by2 (mp_limb_t, mp_limb_t);
+#define mpn_invert_limb(x) mpn_invert_3by2 ((x), 0)
+
+size_t mpn_get_str (unsigned char *, int, mp_ptr, mp_size_t);
+mp_size_t mpn_set_str (mp_ptr, const unsigned char *, size_t, int);
+
+void mpz_init (mpz_t);
+void mpz_init2 (mpz_t, mp_bitcnt_t);
+void mpz_clear (mpz_t);
+
+#define mpz_odd_p(z)   (((z)->_mp_size !=3D 0) & (int) (z)->_mp_d[0])
+#define mpz_even_p(z)  (! mpz_odd_p (z))
+
+int mpz_sgn (const mpz_t);
+int mpz_cmp_si (const mpz_t, long);
+int mpz_cmp_ui (const mpz_t, unsigned long);
+int mpz_cmp (const mpz_t, const mpz_t);
+int mpz_cmpabs_ui (const mpz_t, unsigned long);
+int mpz_cmpabs (const mpz_t, const mpz_t);
+int mpz_cmp_d (const mpz_t, double);
+int mpz_cmpabs_d (const mpz_t, double);
+
+void mpz_abs (mpz_t, const mpz_t);
+void mpz_neg (mpz_t, const mpz_t);
+void mpz_swap (mpz_t, mpz_t);
+
+void mpz_add_ui (mpz_t, const mpz_t, unsigned long);
+void mpz_add (mpz_t, const mpz_t, const mpz_t);
+void mpz_sub_ui (mpz_t, const mpz_t, unsigned long);
+void mpz_ui_sub (mpz_t, unsigned long, const mpz_t);
+void mpz_sub (mpz_t, const mpz_t, const mpz_t);
+
+void mpz_mul_si (mpz_t, const mpz_t, long int);
+void mpz_mul_ui (mpz_t, const mpz_t, unsigned long int);
+void mpz_mul (mpz_t, const mpz_t, const mpz_t);
+void mpz_mul_2exp (mpz_t, const mpz_t, mp_bitcnt_t);
+void mpz_addmul_ui (mpz_t, const mpz_t, unsigned long int);
+void mpz_addmul (mpz_t, const mpz_t, const mpz_t);
+void mpz_submul_ui (mpz_t, const mpz_t, unsigned long int);
+void mpz_submul (mpz_t, const mpz_t, const mpz_t);
+
+void mpz_cdiv_qr (mpz_t, mpz_t, const mpz_t, const mpz_t);
+void mpz_fdiv_qr (mpz_t, mpz_t, const mpz_t, const mpz_t);
+void mpz_tdiv_qr (mpz_t, mpz_t, const mpz_t, const mpz_t);
+void mpz_cdiv_q (mpz_t, const mpz_t, const mpz_t);
+void mpz_fdiv_q (mpz_t, const mpz_t, const mpz_t);
+void mpz_tdiv_q (mpz_t, const mpz_t, const mpz_t);
+void mpz_cdiv_r (mpz_t, const mpz_t, const mpz_t);
+void mpz_fdiv_r (mpz_t, const mpz_t, const mpz_t);
+void mpz_tdiv_r (mpz_t, const mpz_t, const mpz_t);
+
+void mpz_cdiv_q_2exp (mpz_t, const mpz_t, mp_bitcnt_t);
+void mpz_fdiv_q_2exp (mpz_t, const mpz_t, mp_bitcnt_t);
+void mpz_tdiv_q_2exp (mpz_t, const mpz_t, mp_bitcnt_t);
+void mpz_cdiv_r_2exp (mpz_t, const mpz_t, mp_bitcnt_t);
+void mpz_fdiv_r_2exp (mpz_t, const mpz_t, mp_bitcnt_t);
+void mpz_tdiv_r_2exp (mpz_t, const mpz_t, mp_bitcnt_t);
+
+void mpz_mod (mpz_t, const mpz_t, const mpz_t);
+
+void mpz_divexact (mpz_t, const mpz_t, const mpz_t);
+
+int mpz_divisible_p (const mpz_t, const mpz_t);
+int mpz_congruent_p (const mpz_t, const mpz_t, const mpz_t);
+
+unsigned long mpz_cdiv_qr_ui (mpz_t, mpz_t, const mpz_t, unsigned long=
);
+unsigned long mpz_fdiv_qr_ui (mpz_t, mpz_t, const mpz_t, unsigned long=
);
+unsigned long mpz_tdiv_qr_ui (mpz_t, mpz_t, const mpz_t, unsigned long=
);
+unsigned long mpz_cdiv_q_ui (mpz_t, const mpz_t, unsigned long);
+unsigned long mpz_fdiv_q_ui (mpz_t, const mpz_t, unsigned long);
+unsigned long mpz_tdiv_q_ui (mpz_t, const mpz_t, unsigned long);
+unsigned long mpz_cdiv_r_ui (mpz_t, const mpz_t, unsigned long);
+unsigned long mpz_fdiv_r_ui (mpz_t, const mpz_t, unsigned long);
+unsigned long mpz_tdiv_r_ui (mpz_t, const mpz_t, unsigned long);
+unsigned long mpz_cdiv_ui (const mpz_t, unsigned long);
+unsigned long mpz_fdiv_ui (const mpz_t, unsigned long);
+unsigned long mpz_tdiv_ui (const mpz_t, unsigned long);
+
+unsigned long mpz_mod_ui (mpz_t, const mpz_t, unsigned long);
+
+void mpz_divexact_ui (mpz_t, const mpz_t, unsigned long);
+
+int mpz_divisible_ui_p (const mpz_t, unsigned long);
+
+unsigned long mpz_gcd_ui (mpz_t, const mpz_t, unsigned long);
+void mpz_gcd (mpz_t, const mpz_t, const mpz_t);
+void mpz_gcdext (mpz_t, mpz_t, mpz_t, const mpz_t, const mpz_t);
+void mpz_lcm_ui (mpz_t, const mpz_t, unsigned long);
+void mpz_lcm (mpz_t, const mpz_t, const mpz_t);
+int mpz_invert (mpz_t, const mpz_t, const mpz_t);
+
+void mpz_sqrtrem (mpz_t, mpz_t, const mpz_t);
+void mpz_sqrt (mpz_t, const mpz_t);
+int mpz_perfect_square_p (const mpz_t);
+
+void mpz_pow_ui (mpz_t, const mpz_t, unsigned long);
+void mpz_ui_pow_ui (mpz_t, unsigned long, unsigned long);
+void mpz_powm (mpz_t, const mpz_t, const mpz_t, const mpz_t);
+void mpz_powm_ui (mpz_t, const mpz_t, unsigned long, const mpz_t);
+
+void mpz_rootrem (mpz_t, mpz_t, const mpz_t, unsigned long);
+int mpz_root (mpz_t, const mpz_t, unsigned long);
+
+void mpz_fac_ui (mpz_t, unsigned long);
+void mpz_bin_uiui (mpz_t, unsigned long, unsigned long);
+
+int mpz_probab_prime_p (const mpz_t, int);
+
+int mpz_tstbit (const mpz_t, mp_bitcnt_t);
+void mpz_setbit (mpz_t, mp_bitcnt_t);
+void mpz_clrbit (mpz_t, mp_bitcnt_t);
+void mpz_combit (mpz_t, mp_bitcnt_t);
+
+void mpz_com (mpz_t, const mpz_t);
+void mpz_and (mpz_t, const mpz_t, const mpz_t);
+void mpz_ior (mpz_t, const mpz_t, const mpz_t);
+void mpz_xor (mpz_t, const mpz_t, const mpz_t);
+
+mp_bitcnt_t mpz_popcount (const mpz_t);
+mp_bitcnt_t mpz_hamdist (const mpz_t, const mpz_t);
+mp_bitcnt_t mpz_scan0 (const mpz_t, mp_bitcnt_t);
+mp_bitcnt_t mpz_scan1 (const mpz_t, mp_bitcnt_t);
+
+int mpz_fits_slong_p (const mpz_t);
+int mpz_fits_ulong_p (const mpz_t);
+long int mpz_get_si (const mpz_t);
+unsigned long int mpz_get_ui (const mpz_t);
+double mpz_get_d (const mpz_t);
+size_t mpz_size (const mpz_t);
+mp_limb_t mpz_getlimbn (const mpz_t, mp_size_t);
+
+void mpz_realloc2 (mpz_t, mp_bitcnt_t);
+mp_srcptr mpz_limbs_read (mpz_srcptr);
+mp_ptr mpz_limbs_modify (mpz_t, mp_size_t);
+mp_ptr mpz_limbs_write (mpz_t, mp_size_t);
+void mpz_limbs_finish (mpz_t, mp_size_t);
+mpz_srcptr mpz_roinit_n (mpz_t, mp_srcptr, mp_size_t);
+
+#define MPZ_ROINIT_N(xp, xs) {{0, (xs),(xp) }}
+
+void mpz_set_si (mpz_t, signed long int);
+void mpz_set_ui (mpz_t, unsigned long int);
+void mpz_set (mpz_t, const mpz_t);
+void mpz_set_d (mpz_t, double);
+
+void mpz_init_set_si (mpz_t, signed long int);
+void mpz_init_set_ui (mpz_t, unsigned long int);
+void mpz_init_set (mpz_t, const mpz_t);
+void mpz_init_set_d (mpz_t, double);
+
+size_t mpz_sizeinbase (const mpz_t, int);
+char *mpz_get_str (char *, int, const mpz_t);
+int mpz_set_str (mpz_t, const char *, int);
+int mpz_init_set_str (mpz_t, const char *, int);
+
+/* This long list taken from gmp.h. */
+/* For reference, "defined(EOF)" cannot be used here.  In g++ 2.95.4,
+   <iostream> defines EOF but not FILE.  */
+#if defined (FILE)                                              \
+  || defined (H_STDIO)                                          \
+  || defined (_H_STDIO)               /* AIX */                 \
+  || defined (_STDIO_H)               /* glibc, Sun, SCO */     \
+  || defined (_STDIO_H_)              /* BSD, OSF */            \
+  || defined (__STDIO_H)              /* Borland */             \
+  || defined (__STDIO_H__)            /* IRIX */                \
+  || defined (_STDIO_INCLUDED)        /* HPUX */                \
+  || defined (__dj_include_stdio_h_)  /* DJGPP */               \
+  || defined (_FILE_DEFINED)          /* Microsoft */           \
+  || defined (__STDIO__)              /* Apple MPW MrC */       \
+  || defined (_MSL_STDIO_H)           /* Metrowerks */          \
+  || defined (_STDIO_H_INCLUDED)      /* QNX4 */		\
+  || defined (_ISO_STDIO_ISO_H)       /* Sun C++ */		\
+  || defined (__STDIO_LOADED)         /* VMS */
+size_t mpz_out_str (FILE *, int, const mpz_t);
+#endif
+
+void mpz_import (mpz_t, size_t, int, size_t, int, size_t, const void *=
);
+void *mpz_export (void *, size_t *, int, size_t, int, size_t, const mp=
z_t);
+
+#if defined (__cplusplus)
+}
+#endif
+#endif /* __MINI_GMP_H__ */
diff --git a/src/mini-gmp.c b/src/mini-gmp.c
new file mode 100644
index 0000000..acbe1be
--- /dev/null
+++ b/src/mini-gmp.c
@@ -0,0 +1,4386 @@
+/* mini-gmp, a minimalistic implementation of a GNU GMP subset.
+
+   Contributed to the GNU project by Niels M=C3=B6ller
+
+Copyright 1991-1997, 1999-2014 Free Software Foundation, Inc.
+
+This file is part of the GNU MP Library.
+
+The GNU MP Library is free software; you can redistribute it and/or mo=
dify
+it under the terms of either:
+
+  * the GNU Lesser General Public License as published by the Free
+    Software Foundation; either version 3 of the License, or (at your
+    option) any later version.
+
+or
+
+  * the GNU General Public License as published by the Free Software
+    Foundation; either version 2 of the License, or (at your option) a=
ny
+    later version.
+
+or both in parallel, as here.
+
+The GNU MP Library is distributed in the hope that it will be useful, =
but
+WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABI=
LITY
+or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licen=
se
+for more details.
+
+You should have received copies of the GNU General Public License and =
the
+GNU Lesser General Public License along with the GNU MP Library.  If n=
ot,
+see https://www.gnu.org/licenses/.  */
+
+/* NOTE: All functions in this file which are not declared in
+   mini-gmp.h are internal, and are not intended to be compatible
+   neither with GMP nor with future versions of mini-gmp. */
+
+/* Much of the material copied from GMP files, including: gmp-impl.h,
+   longlong.h, mpn/generic/add_n.c, mpn/generic/addmul_1.c,
+   mpn/generic/lshift.c, mpn/generic/mul_1.c,
+   mpn/generic/mul_basecase.c, mpn/generic/rshift.c,
+   mpn/generic/sbpi1_div_qr.c, mpn/generic/sub_n.c,
+   mpn/generic/submul_1.c. */
+
+#include <assert.h>
+#include <ctype.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "mini-gmp.h"
+
+=0C
+/* Macros */
+#define GMP_LIMB_BITS (sizeof(mp_limb_t) * CHAR_BIT)
+
+#define GMP_LIMB_MAX (~ (mp_limb_t) 0)
+#define GMP_LIMB_HIGHBIT ((mp_limb_t) 1 << (GMP_LIMB_BITS - 1))
+
+#define GMP_HLIMB_BIT ((mp_limb_t) 1 << (GMP_LIMB_BITS / 2))
+#define GMP_LLIMB_MASK (GMP_HLIMB_BIT - 1)
+
+#define GMP_ULONG_BITS (sizeof(unsigned long) * CHAR_BIT)
+#define GMP_ULONG_HIGHBIT ((unsigned long) 1 << (GMP_ULONG_BITS - 1))
+
+#define GMP_ABS(x) ((x) >=3D 0 ? (x) : -(x))
+#define GMP_NEG_CAST(T,x) (-((T)((x) + 1) - 1))
+
+#define GMP_MIN(a, b) ((a) < (b) ? (a) : (b))
+#define GMP_MAX(a, b) ((a) > (b) ? (a) : (b))
+
+#define gmp_assert_nocarry(x) do { \
+    mp_limb_t __cy =3D x;		   \
+    assert (__cy =3D=3D 0);		   \
+  } while (0)
+
+#define gmp_clz(count, x) do {						\
+    mp_limb_t __clz_x =3D (x);						\
+    unsigned __clz_c;							\
+    for (__clz_c =3D 0;							\
+	 (__clz_x & ((mp_limb_t) 0xff << (GMP_LIMB_BITS - 8))) =3D=3D 0;	\
+	 __clz_c +=3D 8)							\
+      __clz_x <<=3D 8;							\
+    for (; (__clz_x & GMP_LIMB_HIGHBIT) =3D=3D 0; __clz_c++)		\
+      __clz_x <<=3D 1;							\
+    (count) =3D __clz_c;							\
+  } while (0)
+
+#define gmp_ctz(count, x) do {						\
+    mp_limb_t __ctz_x =3D (x);						\
+    unsigned __ctz_c =3D 0;						\
+    gmp_clz (__ctz_c, __ctz_x & - __ctz_x);				\
+    (count) =3D GMP_LIMB_BITS - 1 - __ctz_c;				\
+  } while (0)
+
+#define gmp_add_ssaaaa(sh, sl, ah, al, bh, bl) \
+  do {									\
+    mp_limb_t __x;							\
+    __x =3D (al) + (bl);							\
+    (sh) =3D (ah) + (bh) + (__x < (al));					\
+    (sl) =3D __x;								\
+  } while (0)
+
+#define gmp_sub_ddmmss(sh, sl, ah, al, bh, bl) \
+  do {									\
+    mp_limb_t __x;							\
+    __x =3D (al) - (bl);							\
+    (sh) =3D (ah) - (bh) - ((al) < (bl));					\
+    (sl) =3D __x;								\
+  } while (0)
+
+#define gmp_umul_ppmm(w1, w0, u, v)					\
+  do {									\
+    mp_limb_t __x0, __x1, __x2, __x3;					\
+    unsigned __ul, __vl, __uh, __vh;					\
+    mp_limb_t __u =3D (u), __v =3D (v);					\
+									\
+    __ul =3D __u & GMP_LLIMB_MASK;					\
+    __uh =3D __u >> (GMP_LIMB_BITS / 2);					\
+    __vl =3D __v & GMP_LLIMB_MASK;					\
+    __vh =3D __v >> (GMP_LIMB_BITS / 2);					\
+									\
+    __x0 =3D (mp_limb_t) __ul * __vl;					\
+    __x1 =3D (mp_limb_t) __ul * __vh;					\
+    __x2 =3D (mp_limb_t) __uh * __vl;					\
+    __x3 =3D (mp_limb_t) __uh * __vh;					\
+									\
+    __x1 +=3D __x0 >> (GMP_LIMB_BITS / 2);/* this can't give carry */	=
\
+    __x1 +=3D __x2;		/* but this indeed can */		\
+    if (__x1 < __x2)		/* did we get it? */			\
+      __x3 +=3D GMP_HLIMB_BIT;	/* yes, add it in the proper pos. */	\
+									\
+    (w1) =3D __x3 + (__x1 >> (GMP_LIMB_BITS / 2));			\
+    (w0) =3D (__x1 << (GMP_LIMB_BITS / 2)) + (__x0 & GMP_LLIMB_MASK);	=
\
+  } while (0)
+
+#define gmp_udiv_qrnnd_preinv(q, r, nh, nl, d, di)			\
+  do {									\
+    mp_limb_t _qh, _ql, _r, _mask;					\
+    gmp_umul_ppmm (_qh, _ql, (nh), (di));				\
+    gmp_add_ssaaaa (_qh, _ql, _qh, _ql, (nh) + 1, (nl));		\
+    _r =3D (nl) - _qh * (d);						\
+    _mask =3D -(mp_limb_t) (_r > _ql); /* both > and >=3D are OK */		\
+    _qh +=3D _mask;							\
+    _r +=3D _mask & (d);							\
+    if (_r >=3D (d))							\
+      {									\
+	_r -=3D (d);							\
+	_qh++;								\
+      }									\
+									\
+    (r) =3D _r;								\
+    (q) =3D _qh;								\
+  } while (0)
+
+#define gmp_udiv_qr_3by2(q, r1, r0, n2, n1, n0, d1, d0, dinv)		\
+  do {									\
+    mp_limb_t _q0, _t1, _t0, _mask;					\
+    gmp_umul_ppmm ((q), _q0, (n2), (dinv));				\
+    gmp_add_ssaaaa ((q), _q0, (q), _q0, (n2), (n1));			\
+									\
+    /* Compute the two most significant limbs of n - q'd */		\
+    (r1) =3D (n1) - (d1) * (q);						\
+    gmp_sub_ddmmss ((r1), (r0), (r1), (n0), (d1), (d0));		\
+    gmp_umul_ppmm (_t1, _t0, (d0), (q));				\
+    gmp_sub_ddmmss ((r1), (r0), (r1), (r0), _t1, _t0);			\
+    (q)++;								\
+									\
+    /* Conditionally adjust q and the remainders */			\
+    _mask =3D - (mp_limb_t) ((r1) >=3D _q0);				\
+    (q) +=3D _mask;							\
+    gmp_add_ssaaaa ((r1), (r0), (r1), (r0), _mask & (d1), _mask & (d0)=
); \
+    if ((r1) >=3D (d1))							\
+      {									\
+	if ((r1) > (d1) || (r0) >=3D (d0))				\
+	  {								\
+	    (q)++;							\
+	    gmp_sub_ddmmss ((r1), (r0), (r1), (r0), (d1), (d0));	\
+	  }								\
+      }									\
+  } while (0)
+
+/* Swap macros. */
+#define MP_LIMB_T_SWAP(x, y)						\
+  do {									\
+    mp_limb_t __mp_limb_t_swap__tmp =3D (x);				\
+    (x) =3D (y);								\
+    (y) =3D __mp_limb_t_swap__tmp;					\
+  } while (0)
+#define MP_SIZE_T_SWAP(x, y)						\
+  do {									\
+    mp_size_t __mp_size_t_swap__tmp =3D (x);				\
+    (x) =3D (y);								\
+    (y) =3D __mp_size_t_swap__tmp;					\
+  } while (0)
+#define MP_BITCNT_T_SWAP(x,y)			\
+  do {						\
+    mp_bitcnt_t __mp_bitcnt_t_swap__tmp =3D (x);	\
+    (x) =3D (y);					\
+    (y) =3D __mp_bitcnt_t_swap__tmp;		\
+  } while (0)
+#define MP_PTR_SWAP(x, y)						\
+  do {									\
+    mp_ptr __mp_ptr_swap__tmp =3D (x);					\
+    (x) =3D (y);								\
+    (y) =3D __mp_ptr_swap__tmp;						\
+  } while (0)
+#define MP_SRCPTR_SWAP(x, y)						\
+  do {									\
+    mp_srcptr __mp_srcptr_swap__tmp =3D (x);				\
+    (x) =3D (y);								\
+    (y) =3D __mp_srcptr_swap__tmp;					\
+  } while (0)
+
+#define MPN_PTR_SWAP(xp,xs, yp,ys)					\
+  do {									\
+    MP_PTR_SWAP (xp, yp);						\
+    MP_SIZE_T_SWAP (xs, ys);						\
+  } while(0)
+#define MPN_SRCPTR_SWAP(xp,xs, yp,ys)					\
+  do {									\
+    MP_SRCPTR_SWAP (xp, yp);						\
+    MP_SIZE_T_SWAP (xs, ys);						\
+  } while(0)
+
+#define MPZ_PTR_SWAP(x, y)						\
+  do {									\
+    mpz_ptr __mpz_ptr_swap__tmp =3D (x);					\
+    (x) =3D (y);								\
+    (y) =3D __mpz_ptr_swap__tmp;						\
+  } while (0)
+#define MPZ_SRCPTR_SWAP(x, y)						\
+  do {									\
+    mpz_srcptr __mpz_srcptr_swap__tmp =3D (x);				\
+    (x) =3D (y);								\
+    (y) =3D __mpz_srcptr_swap__tmp;					\
+  } while (0)
+
+const int mp_bits_per_limb =3D GMP_LIMB_BITS;
+
+=0C
+/* Memory allocation and other helper functions. */
+static void
+gmp_die (const char *msg)
+{
+  fprintf (stderr, "%s\n", msg);
+  abort();
+}
+
+static void *
+gmp_default_alloc (size_t size)
+{
+  void *p;
+
+  assert (size > 0);
+
+  p =3D malloc (size);
+  if (!p)
+    gmp_die("gmp_default_alloc: Virtual memory exhausted.");
+
+  return p;
+}
+
+static void *
+gmp_default_realloc (void *old, size_t old_size, size_t new_size)
+{
+  mp_ptr p;
+
+  p =3D realloc (old, new_size);
+
+  if (!p)
+    gmp_die("gmp_default_realoc: Virtual memory exhausted.");
+
+  return p;
+}
+
+static void
+gmp_default_free (void *p, size_t size)
+{
+  free (p);
+}
+
+static void * (*gmp_allocate_func) (size_t) =3D gmp_default_alloc;
+static void * (*gmp_reallocate_func) (void *, size_t, size_t) =3D gmp_=
default_realloc;
+static void (*gmp_free_func) (void *, size_t) =3D gmp_default_free;
+
+void
+mp_get_memory_functions (void *(**alloc_func) (size_t),
+			 void *(**realloc_func) (void *, size_t, size_t),
+			 void (**free_func) (void *, size_t))
+{
+  if (alloc_func)
+    *alloc_func =3D gmp_allocate_func;
+
+  if (realloc_func)
+    *realloc_func =3D gmp_reallocate_func;
+
+  if (free_func)
+    *free_func =3D gmp_free_func;
+}
+
+void
+mp_set_memory_functions (void *(*alloc_func) (size_t),
+			 void *(*realloc_func) (void *, size_t, size_t),
+			 void (*free_func) (void *, size_t))
+{
+  if (!alloc_func)
+    alloc_func =3D gmp_default_alloc;
+  if (!realloc_func)
+    realloc_func =3D gmp_default_realloc;
+  if (!free_func)
+    free_func =3D gmp_default_free;
+
+  gmp_allocate_func =3D alloc_func;
+  gmp_reallocate_func =3D realloc_func;
+  gmp_free_func =3D free_func;
+}
+
+#define gmp_xalloc(size) ((*gmp_allocate_func)((size)))
+#define gmp_free(p) ((*gmp_free_func) ((p), 0))
+
+static mp_ptr
+gmp_xalloc_limbs (mp_size_t size)
+{
+  return gmp_xalloc (size * sizeof (mp_limb_t));
+}
+
+static mp_ptr
+gmp_xrealloc_limbs (mp_ptr old, mp_size_t size)
+{
+  assert (size > 0);
+  return (*gmp_reallocate_func) (old, 0, size * sizeof (mp_limb_t));
+}
+
+=0C
+/* MPN interface */
+
+void
+mpn_copyi (mp_ptr d, mp_srcptr s, mp_size_t n)
+{
+  mp_size_t i;
+  for (i =3D 0; i < n; i++)
+    d[i] =3D s[i];
+}
+
+void
+mpn_copyd (mp_ptr d, mp_srcptr s, mp_size_t n)
+{
+  while (n-- > 0)
+    d[n] =3D s[n];
+}
+
+int
+mpn_cmp (mp_srcptr ap, mp_srcptr bp, mp_size_t n)
+{
+  while (--n >=3D 0)
+    {
+      if (ap[n] !=3D bp[n])
+	return ap[n] > bp[n] ? 1 : -1;
+    }
+  return 0;
+}
+
+static int
+mpn_cmp4 (mp_srcptr ap, mp_size_t an, mp_srcptr bp, mp_size_t bn)
+{
+  if (an !=3D bn)
+    return an < bn ? -1 : 1;
+  else
+    return mpn_cmp (ap, bp, an);
+}
+
+static mp_size_t
+mpn_normalized_size (mp_srcptr xp, mp_size_t n)
+{
+  for (; n > 0 && xp[n-1] =3D=3D 0; n--)
+    ;
+  return n;
+}
+
+#define mpn_zero_p(xp, n) (mpn_normalized_size ((xp), (n)) =3D=3D 0)
+
+void
+mpn_zero (mp_ptr rp, mp_size_t n)
+{
+  mp_size_t i;
+
+  for (i =3D 0; i < n; i++)
+    rp[i] =3D 0;
+}
+
+mp_limb_t
+mpn_add_1 (mp_ptr rp, mp_srcptr ap, mp_size_t n, mp_limb_t b)
+{
+  mp_size_t i;
+
+  assert (n > 0);
+  i =3D 0;
+  do
+    {
+      mp_limb_t r =3D ap[i] + b;
+      /* Carry out */
+      b =3D (r < b);
+      rp[i] =3D r;
+    }
+  while (++i < n);
+
+  return b;
+}
+
+mp_limb_t
+mpn_add_n (mp_ptr rp, mp_srcptr ap, mp_srcptr bp, mp_size_t n)
+{
+  mp_size_t i;
+  mp_limb_t cy;
+
+  for (i =3D 0, cy =3D 0; i < n; i++)
+    {
+      mp_limb_t a, b, r;
+      a =3D ap[i]; b =3D bp[i];
+      r =3D a + cy;
+      cy =3D (r < cy);
+      r +=3D b;
+      cy +=3D (r < b);
+      rp[i] =3D r;
+    }
+  return cy;
+}
+
+mp_limb_t
+mpn_add (mp_ptr rp, mp_srcptr ap, mp_size_t an, mp_srcptr bp, mp_size_=
t bn)
+{
+  mp_limb_t cy;
+
+  assert (an >=3D bn);
+
+  cy =3D mpn_add_n (rp, ap, bp, bn);
+  if (an > bn)
+    cy =3D mpn_add_1 (rp + bn, ap + bn, an - bn, cy);
+  return cy;
+}
+
+mp_limb_t
+mpn_sub_1 (mp_ptr rp, mp_srcptr ap, mp_size_t n, mp_limb_t b)
+{
+  mp_size_t i;
+
+  assert (n > 0);
+
+  i =3D 0;
+  do
+    {
+      mp_limb_t a =3D ap[i];
+      /* Carry out */
+      mp_limb_t cy =3D a < b;;
+      rp[i] =3D a - b;
+      b =3D cy;
+    }
+  while (++i < n);
+
+  return b;
+}
+
+mp_limb_t
+mpn_sub_n (mp_ptr rp, mp_srcptr ap, mp_srcptr bp, mp_size_t n)
+{
+  mp_size_t i;
+  mp_limb_t cy;
+
+  for (i =3D 0, cy =3D 0; i < n; i++)
+    {
+      mp_limb_t a, b;
+      a =3D ap[i]; b =3D bp[i];
+      b +=3D cy;
+      cy =3D (b < cy);
+      cy +=3D (a < b);
+      rp[i] =3D a - b;
+    }
+  return cy;
+}
+
+mp_limb_t
+mpn_sub (mp_ptr rp, mp_srcptr ap, mp_size_t an, mp_srcptr bp, mp_size_=
t bn)
+{
+  mp_limb_t cy;
+
+  assert (an >=3D bn);
+
+  cy =3D mpn_sub_n (rp, ap, bp, bn);
+  if (an > bn)
+    cy =3D mpn_sub_1 (rp + bn, ap + bn, an - bn, cy);
+  return cy;
+}
+
+mp_limb_t
+mpn_mul_1 (mp_ptr rp, mp_srcptr up, mp_size_t n, mp_limb_t vl)
+{
+  mp_limb_t ul, cl, hpl, lpl;
+
+  assert (n >=3D 1);
+
+  cl =3D 0;
+  do
+    {
+      ul =3D *up++;
+      gmp_umul_ppmm (hpl, lpl, ul, vl);
+
+      lpl +=3D cl;
+      cl =3D (lpl < cl) + hpl;
+
+      *rp++ =3D lpl;
+    }
+  while (--n !=3D 0);
+
+  return cl;
+}
+
+mp_limb_t
+mpn_addmul_1 (mp_ptr rp, mp_srcptr up, mp_size_t n, mp_limb_t vl)
+{
+  mp_limb_t ul, cl, hpl, lpl, rl;
+
+  assert (n >=3D 1);
+
+  cl =3D 0;
+  do
+    {
+      ul =3D *up++;
+      gmp_umul_ppmm (hpl, lpl, ul, vl);
+
+      lpl +=3D cl;
+      cl =3D (lpl < cl) + hpl;
+
+      rl =3D *rp;
+      lpl =3D rl + lpl;
+      cl +=3D lpl < rl;
+      *rp++ =3D lpl;
+    }
+  while (--n !=3D 0);
+
+  return cl;
+}
+
+mp_limb_t
+mpn_submul_1 (mp_ptr rp, mp_srcptr up, mp_size_t n, mp_limb_t vl)
+{
+  mp_limb_t ul, cl, hpl, lpl, rl;
+
+  assert (n >=3D 1);
+
+  cl =3D 0;
+  do
+    {
+      ul =3D *up++;
+      gmp_umul_ppmm (hpl, lpl, ul, vl);
+
+      lpl +=3D cl;
+      cl =3D (lpl < cl) + hpl;
+
+      rl =3D *rp;
+      lpl =3D rl - lpl;
+      cl +=3D lpl > rl;
+      *rp++ =3D lpl;
+    }
+  while (--n !=3D 0);
+
+  return cl;
+}
+
+mp_limb_t
+mpn_mul (mp_ptr rp, mp_srcptr up, mp_size_t un, mp_srcptr vp, mp_size_=
t vn)
+{
+  assert (un >=3D vn);
+  assert (vn >=3D 1);
+
+  /* We first multiply by the low order limb. This result can be
+     stored, not added, to rp. We also avoid a loop for zeroing this
+     way. */
+
+  rp[un] =3D mpn_mul_1 (rp, up, un, vp[0]);
+  rp +=3D 1, vp +=3D 1, vn -=3D 1;
+
+  /* Now accumulate the product of up[] and the next higher limb from
+     vp[]. */
+
+  while (vn >=3D 1)
+    {
+      rp[un] =3D mpn_addmul_1 (rp, up, un, vp[0]);
+      rp +=3D 1, vp +=3D 1, vn -=3D 1;
+    }
+  return rp[un - 1];
+}
+
+void
+mpn_mul_n (mp_ptr rp, mp_srcptr ap, mp_srcptr bp, mp_size_t n)
+{
+  mpn_mul (rp, ap, n, bp, n);
+}
+
+void
+mpn_sqr (mp_ptr rp, mp_srcptr ap, mp_size_t n)
+{
+  mpn_mul (rp, ap, n, ap, n);
+}
+
+mp_limb_t
+mpn_lshift (mp_ptr rp, mp_srcptr up, mp_size_t n, unsigned int cnt)
+{
+  mp_limb_t high_limb, low_limb;
+  unsigned int tnc;
+  mp_size_t i;
+  mp_limb_t retval;
+
+  assert (n >=3D 1);
+  assert (cnt >=3D 1);
+  assert (cnt < GMP_LIMB_BITS);
+
+  up +=3D n;
+  rp +=3D n;
+
+  tnc =3D GMP_LIMB_BITS - cnt;
+  low_limb =3D *--up;
+  retval =3D low_limb >> tnc;
+  high_limb =3D (low_limb << cnt);
+
+  for (i =3D n; --i !=3D 0;)
+    {
+      low_limb =3D *--up;
+      *--rp =3D high_limb | (low_limb >> tnc);
+      high_limb =3D (low_limb << cnt);
+    }
+  *--rp =3D high_limb;
+
+  return retval;
+}
+
+mp_limb_t
+mpn_rshift (mp_ptr rp, mp_srcptr up, mp_size_t n, unsigned int cnt)
+{
+  mp_limb_t high_limb, low_limb;
+  unsigned int tnc;
+  mp_size_t i;
+  mp_limb_t retval;
+
+  assert (n >=3D 1);
+  assert (cnt >=3D 1);
+  assert (cnt < GMP_LIMB_BITS);
+
+  tnc =3D GMP_LIMB_BITS - cnt;
+  high_limb =3D *up++;
+  retval =3D (high_limb << tnc);
+  low_limb =3D high_limb >> cnt;
+
+  for (i =3D n; --i !=3D 0;)
+    {
+      high_limb =3D *up++;
+      *rp++ =3D low_limb | (high_limb << tnc);
+      low_limb =3D high_limb >> cnt;
+    }
+  *rp =3D low_limb;
+
+  return retval;
+}
+
+static mp_bitcnt_t
+mpn_common_scan (mp_limb_t limb, mp_size_t i, mp_srcptr up, mp_size_t =
un,
+		 mp_limb_t ux)
+{
+  unsigned cnt;
+
+  assert (ux =3D=3D 0 || ux =3D=3D GMP_LIMB_MAX);
+  assert (0 <=3D i && i <=3D un );
+
+  while (limb =3D=3D 0)
+    {
+      i++;
+      if (i =3D=3D un)
+	return (ux =3D=3D 0 ? ~(mp_bitcnt_t) 0 : un * GMP_LIMB_BITS);
+      limb =3D ux ^ up[i];
+    }
+  gmp_ctz (cnt, limb);
+  return (mp_bitcnt_t) i * GMP_LIMB_BITS + cnt;
+}
+
+mp_bitcnt_t
+mpn_scan1 (mp_srcptr ptr, mp_bitcnt_t bit)
+{
+  mp_size_t i;
+  i =3D bit / GMP_LIMB_BITS;
+
+  return mpn_common_scan ( ptr[i] & (GMP_LIMB_MAX << (bit % GMP_LIMB_B=
ITS)),
+			  i, ptr, i, 0);
+}
+
+mp_bitcnt_t
+mpn_scan0 (mp_srcptr ptr, mp_bitcnt_t bit)
+{
+  mp_size_t i;
+  i =3D bit / GMP_LIMB_BITS;
+
+  return mpn_common_scan (~ptr[i] & (GMP_LIMB_MAX << (bit % GMP_LIMB_B=
ITS)),
+			  i, ptr, i, GMP_LIMB_MAX);
+}
+
+=0C
+/* MPN division interface. */
+mp_limb_t
+mpn_invert_3by2 (mp_limb_t u1, mp_limb_t u0)
+{
+  mp_limb_t r, p, m;
+  unsigned ul, uh;
+  unsigned ql, qh;
+
+  /* First, do a 2/1 inverse. */
+  /* The inverse m is defined as floor( (B^2 - 1 - u1)/u1 ), so that 0=
 <
+   * B^2 - (B + m) u1 <=3D u1 */
+  assert (u1 >=3D GMP_LIMB_HIGHBIT);
+
+  ul =3D u1 & GMP_LLIMB_MASK;
+  uh =3D u1 >> (GMP_LIMB_BITS / 2);
+
+  qh =3D ~u1 / uh;
+  r =3D ((~u1 - (mp_limb_t) qh * uh) << (GMP_LIMB_BITS / 2)) | GMP_LLI=
MB_MASK;
+
+  p =3D (mp_limb_t) qh * ul;
+  /* Adjustment steps taken from udiv_qrnnd_c */
+  if (r < p)
+    {
+      qh--;
+      r +=3D u1;
+      if (r >=3D u1) /* i.e. we didn't get carry when adding to r */
+	if (r < p)
+	  {
+	    qh--;
+	    r +=3D u1;
+	  }
+    }
+  r -=3D p;
+
+  /* Do a 3/2 division (with half limb size) */
+  p =3D (r >> (GMP_LIMB_BITS / 2)) * qh + r;
+  ql =3D (p >> (GMP_LIMB_BITS / 2)) + 1;
+
+  /* By the 3/2 method, we don't need the high half limb. */
+  r =3D (r << (GMP_LIMB_BITS / 2)) + GMP_LLIMB_MASK - ql * u1;
+
+  if (r >=3D (p << (GMP_LIMB_BITS / 2)))
+    {
+      ql--;
+      r +=3D u1;
+    }
+  m =3D ((mp_limb_t) qh << (GMP_LIMB_BITS / 2)) + ql;
+  if (r >=3D u1)
+    {
+      m++;
+      r -=3D u1;
+    }
+
+  if (u0 > 0)
+    {
+      mp_limb_t th, tl;
+      r =3D ~r;
+      r +=3D u0;
+      if (r < u0)
+	{
+	  m--;
+	  if (r >=3D u1)
+	    {
+	      m--;
+	      r -=3D u1;
+	    }
+	  r -=3D u1;
+	}
+      gmp_umul_ppmm (th, tl, u0, m);
+      r +=3D th;
+      if (r < th)
+	{
+	  m--;
+	  m -=3D ((r > u1) | ((r =3D=3D u1) & (tl > u0)));
+	}
+    }
+
+  return m;
+}
+
+struct gmp_div_inverse
+{
+  /* Normalization shift count. */
+  unsigned shift;
+  /* Normalized divisor (d0 unused for mpn_div_qr_1) */
+  mp_limb_t d1, d0;
+  /* Inverse, for 2/1 or 3/2. */
+  mp_limb_t di;
+};
+
+static void
+mpn_div_qr_1_invert (struct gmp_div_inverse *inv, mp_limb_t d)
+{
+  unsigned shift;
+
+  assert (d > 0);
+  gmp_clz (shift, d);
+  inv->shift =3D shift;
+  inv->d1 =3D d << shift;
+  inv->di =3D mpn_invert_limb (inv->d1);
+}
+
+static void
+mpn_div_qr_2_invert (struct gmp_div_inverse *inv,
+		     mp_limb_t d1, mp_limb_t d0)
+{
+  unsigned shift;
+
+  assert (d1 > 0);
+  gmp_clz (shift, d1);
+  inv->shift =3D shift;
+  if (shift > 0)
+    {
+      d1 =3D (d1 << shift) | (d0 >> (GMP_LIMB_BITS - shift));
+      d0 <<=3D shift;
+    }
+  inv->d1 =3D d1;
+  inv->d0 =3D d0;
+  inv->di =3D mpn_invert_3by2 (d1, d0);
+}
+
+static void
+mpn_div_qr_invert (struct gmp_div_inverse *inv,
+		   mp_srcptr dp, mp_size_t dn)
+{
+  assert (dn > 0);
+
+  if (dn =3D=3D 1)
+    mpn_div_qr_1_invert (inv, dp[0]);
+  else if (dn =3D=3D 2)
+    mpn_div_qr_2_invert (inv, dp[1], dp[0]);
+  else
+    {
+      unsigned shift;
+      mp_limb_t d1, d0;
+
+      d1 =3D dp[dn-1];
+      d0 =3D dp[dn-2];
+      assert (d1 > 0);
+      gmp_clz (shift, d1);
+      inv->shift =3D shift;
+      if (shift > 0)
+	{
+	  d1 =3D (d1 << shift) | (d0 >> (GMP_LIMB_BITS - shift));
+	  d0 =3D (d0 << shift) | (dp[dn-3] >> (GMP_LIMB_BITS - shift));
+	}
+      inv->d1 =3D d1;
+      inv->d0 =3D d0;
+      inv->di =3D mpn_invert_3by2 (d1, d0);
+    }
+}
+
+/* Not matching current public gmp interface, rather corresponding to
+   the sbpi1_div_* functions. */
+static mp_limb_t
+mpn_div_qr_1_preinv (mp_ptr qp, mp_srcptr np, mp_size_t nn,
+		     const struct gmp_div_inverse *inv)
+{
+  mp_limb_t d, di;
+  mp_limb_t r;
+  mp_ptr tp =3D NULL;
+
+  if (inv->shift > 0)
+    {
+      tp =3D gmp_xalloc_limbs (nn);
+      r =3D mpn_lshift (tp, np, nn, inv->shift);
+      np =3D tp;
+    }
+  else
+    r =3D 0;
+
+  d =3D inv->d1;
+  di =3D inv->di;
+  while (nn-- > 0)
+    {
+      mp_limb_t q;
+
+      gmp_udiv_qrnnd_preinv (q, r, r, np[nn], d, di);
+      if (qp)
+	qp[nn] =3D q;
+    }
+  if (inv->shift > 0)
+    gmp_free (tp);
+
+  return r >> inv->shift;
+}
+
+static mp_limb_t
+mpn_div_qr_1 (mp_ptr qp, mp_srcptr np, mp_size_t nn, mp_limb_t d)
+{
+  assert (d > 0);
+
+  /* Special case for powers of two. */
+  if ((d & (d-1)) =3D=3D 0)
+    {
+      mp_limb_t r =3D np[0] & (d-1);
+      if (qp)
+	{
+	  if (d <=3D 1)
+	    mpn_copyi (qp, np, nn);
+	  else
+	    {
+	      unsigned shift;
+	      gmp_ctz (shift, d);
+	      mpn_rshift (qp, np, nn, shift);
+	    }
+	}
+      return r;
+    }
+  else
+    {
+      struct gmp_div_inverse inv;
+      mpn_div_qr_1_invert (&inv, d);
+      return mpn_div_qr_1_preinv (qp, np, nn, &inv);
+    }
+}
+
+static void
+mpn_div_qr_2_preinv (mp_ptr qp, mp_ptr rp, mp_srcptr np, mp_size_t nn,
+		     const struct gmp_div_inverse *inv)
+{
+  unsigned shift;
+  mp_size_t i;
+  mp_limb_t d1, d0, di, r1, r0;
+  mp_ptr tp;
+
+  assert (nn >=3D 2);
+  shift =3D inv->shift;
+  d1 =3D inv->d1;
+  d0 =3D inv->d0;
+  di =3D inv->di;
+
+  if (shift > 0)
+    {
+      tp =3D gmp_xalloc_limbs (nn);
+      r1 =3D mpn_lshift (tp, np, nn, shift);
+      np =3D tp;
+    }
+  else
+    r1 =3D 0;
+
+  r0 =3D np[nn - 1];
+
+  i =3D nn - 2;
+  do
+    {
+      mp_limb_t n0, q;
+      n0 =3D np[i];
+      gmp_udiv_qr_3by2 (q, r1, r0, r1, r0, n0, d1, d0, di);
+
+      if (qp)
+	qp[i] =3D q;
+    }
+  while (--i >=3D 0);
+
+  if (shift > 0)
+    {
+      assert ((r0 << (GMP_LIMB_BITS - shift)) =3D=3D 0);
+      r0 =3D (r0 >> shift) | (r1 << (GMP_LIMB_BITS - shift));
+      r1 >>=3D shift;
+
+      gmp_free (tp);
+    }
+
+  rp[1] =3D r1;
+  rp[0] =3D r0;
+}
+
+#if 0
+static void
+mpn_div_qr_2 (mp_ptr qp, mp_ptr rp, mp_srcptr np, mp_size_t nn,
+	      mp_limb_t d1, mp_limb_t d0)
+{
+  struct gmp_div_inverse inv;
+  assert (nn >=3D 2);
+
+  mpn_div_qr_2_invert (&inv, d1, d0);
+  mpn_div_qr_2_preinv (qp, rp, np, nn, &inv);
+}
+#endif
+
+static void
+mpn_div_qr_pi1 (mp_ptr qp,
+		mp_ptr np, mp_size_t nn, mp_limb_t n1,
+		mp_srcptr dp, mp_size_t dn,
+		mp_limb_t dinv)
+{
+  mp_size_t i;
+
+  mp_limb_t d1, d0;
+  mp_limb_t cy, cy1;
+  mp_limb_t q;
+
+  assert (dn > 2);
+  assert (nn >=3D dn);
+
+  d1 =3D dp[dn - 1];
+  d0 =3D dp[dn - 2];
+
+  assert ((d1 & GMP_LIMB_HIGHBIT) !=3D 0);
+  /* Iteration variable is the index of the q limb.
+   *
+   * We divide <n1, np[dn-1+i], np[dn-2+i], np[dn-3+i],..., np[i]>
+   * by            <d1,          d0,        dp[dn-3],  ..., dp[0] >
+   */
+
+  i =3D nn - dn;
+  do
+    {
+      mp_limb_t n0 =3D np[dn-1+i];
+
+      if (n1 =3D=3D d1 && n0 =3D=3D d0)
+	{
+	  q =3D GMP_LIMB_MAX;
+	  mpn_submul_1 (np+i, dp, dn, q);
+	  n1 =3D np[dn-1+i];	/* update n1, last loop's value will now be inva=
lid */
+	}
+      else
+	{
+	  gmp_udiv_qr_3by2 (q, n1, n0, n1, n0, np[dn-2+i], d1, d0, dinv);
+
+	  cy =3D mpn_submul_1 (np + i, dp, dn-2, q);
+
+	  cy1 =3D n0 < cy;
+	  n0 =3D n0 - cy;
+	  cy =3D n1 < cy1;
+	  n1 =3D n1 - cy1;
+	  np[dn-2+i] =3D n0;
+
+	  if (cy !=3D 0)
+	    {
+	      n1 +=3D d1 + mpn_add_n (np + i, np + i, dp, dn - 1);
+	      q--;
+	    }
+	}
+
+      if (qp)
+	qp[i] =3D q;
+    }
+  while (--i >=3D 0);
+
+  np[dn - 1] =3D n1;
+}
+
+static void
+mpn_div_qr_preinv (mp_ptr qp, mp_ptr np, mp_size_t nn,
+		   mp_srcptr dp, mp_size_t dn,
+		   const struct gmp_div_inverse *inv)
+{
+  assert (dn > 0);
+  assert (nn >=3D dn);
+
+  if (dn =3D=3D 1)
+    np[0] =3D mpn_div_qr_1_preinv (qp, np, nn, inv);
+  else if (dn =3D=3D 2)
+    mpn_div_qr_2_preinv (qp, np, np, nn, inv);
+  else
+    {
+      mp_limb_t nh;
+      unsigned shift;
+
+      assert (inv->d1 =3D=3D dp[dn-1]);
+      assert (inv->d0 =3D=3D dp[dn-2]);
+      assert ((inv->d1 & GMP_LIMB_HIGHBIT) !=3D 0);
+
+      shift =3D inv->shift;
+      if (shift > 0)
+	nh =3D mpn_lshift (np, np, nn, shift);
+      else
+	nh =3D 0;
+
+      mpn_div_qr_pi1 (qp, np, nn, nh, dp, dn, inv->di);
+
+      if (shift > 0)
+	gmp_assert_nocarry (mpn_rshift (np, np, dn, shift));
+    }
+}
+
+static void
+mpn_div_qr (mp_ptr qp, mp_ptr np, mp_size_t nn, mp_srcptr dp, mp_size_=
t dn)
+{
+  struct gmp_div_inverse inv;
+  mp_ptr tp =3D NULL;
+
+  assert (dn > 0);
+  assert (nn >=3D dn);
+
+  mpn_div_qr_invert (&inv, dp, dn);
+  if (dn > 2 && inv.shift > 0)
+    {
+      tp =3D gmp_xalloc_limbs (dn);
+      gmp_assert_nocarry (mpn_lshift (tp, dp, dn, inv.shift));
+      dp =3D tp;
+    }
+  mpn_div_qr_preinv (qp, np, nn, dp, dn, &inv);
+  if (tp)
+    gmp_free (tp);
+}
+
+=0C
+/* MPN base conversion. */
+static unsigned
+mpn_base_power_of_two_p (unsigned b)
+{
+  switch (b)
+    {
+    case 2: return 1;
+    case 4: return 2;
+    case 8: return 3;
+    case 16: return 4;
+    case 32: return 5;
+    case 64: return 6;
+    case 128: return 7;
+    case 256: return 8;
+    default: return 0;
+    }
+}
+
+struct mpn_base_info
+{
+  /* bb is the largest power of the base which fits in one limb, and
+     exp is the corresponding exponent. */
+  unsigned exp;
+  mp_limb_t bb;
+};
+
+static void
+mpn_get_base_info (struct mpn_base_info *info, mp_limb_t b)
+{
+  mp_limb_t m;
+  mp_limb_t p;
+  unsigned exp;
+
+  m =3D GMP_LIMB_MAX / b;
+  for (exp =3D 1, p =3D b; p <=3D m; exp++)
+    p *=3D b;
+
+  info->exp =3D exp;
+  info->bb =3D p;
+}
+
+static mp_bitcnt_t
+mpn_limb_size_in_base_2 (mp_limb_t u)
+{
+  unsigned shift;
+
+  assert (u > 0);
+  gmp_clz (shift, u);
+  return GMP_LIMB_BITS - shift;
+}
+
+static size_t
+mpn_get_str_bits (unsigned char *sp, unsigned bits, mp_srcptr up, mp_s=
ize_t un)
+{
+  unsigned char mask;
+  size_t sn, j;
+  mp_size_t i;
+  int shift;
+
+  sn =3D ((un - 1) * GMP_LIMB_BITS + mpn_limb_size_in_base_2 (up[un-1]=
)
+	+ bits - 1) / bits;
+
+  mask =3D (1U << bits) - 1;
+
+  for (i =3D 0, j =3D sn, shift =3D 0; j-- > 0;)
+    {
+      unsigned char digit =3D up[i] >> shift;
+
+      shift +=3D bits;
+
+      if (shift >=3D GMP_LIMB_BITS && ++i < un)
+	{
+	  shift -=3D GMP_LIMB_BITS;
+	  digit |=3D up[i] << (bits - shift);
+	}
+      sp[j] =3D digit & mask;
+    }
+  return sn;
+}
+
+/* We generate digits from the least significant end, and reverse at
+   the end. */
+static size_t
+mpn_limb_get_str (unsigned char *sp, mp_limb_t w,
+		  const struct gmp_div_inverse *binv)
+{
+  mp_size_t i;
+  for (i =3D 0; w > 0; i++)
+    {
+      mp_limb_t h, l, r;
+
+      h =3D w >> (GMP_LIMB_BITS - binv->shift);
+      l =3D w << binv->shift;
+
+      gmp_udiv_qrnnd_preinv (w, r, h, l, binv->d1, binv->di);
+      assert ( (r << (GMP_LIMB_BITS - binv->shift)) =3D=3D 0);
+      r >>=3D binv->shift;
+
+      sp[i] =3D r;
+    }
+  return i;
+}
+
+static size_t
+mpn_get_str_other (unsigned char *sp,
+		   int base, const struct mpn_base_info *info,
+		   mp_ptr up, mp_size_t un)
+{
+  struct gmp_div_inverse binv;
+  size_t sn;
+  size_t i;
+
+  mpn_div_qr_1_invert (&binv, base);
+
+  sn =3D 0;
+
+  if (un > 1)
+    {
+      struct gmp_div_inverse bbinv;
+      mpn_div_qr_1_invert (&bbinv, info->bb);
+
+      do
+	{
+	  mp_limb_t w;
+	  size_t done;
+	  w =3D mpn_div_qr_1_preinv (up, up, un, &bbinv);
+	  un -=3D (up[un-1] =3D=3D 0);
+	  done =3D mpn_limb_get_str (sp + sn, w, &binv);
+
+	  for (sn +=3D done; done < info->exp; done++)
+	    sp[sn++] =3D 0;
+	}
+      while (un > 1);
+    }
+  sn +=3D mpn_limb_get_str (sp + sn, up[0], &binv);
+
+  /* Reverse order */
+  for (i =3D 0; 2*i + 1 < sn; i++)
+    {
+      unsigned char t =3D sp[i];
+      sp[i] =3D sp[sn - i - 1];
+      sp[sn - i - 1] =3D t;
+    }
+
+  return sn;
+}
+
+size_t
+mpn_get_str (unsigned char *sp, int base, mp_ptr up, mp_size_t un)
+{
+  unsigned bits;
+
+  assert (un > 0);
+  assert (up[un-1] > 0);
+
+  bits =3D mpn_base_power_of_two_p (base);
+  if (bits)
+    return mpn_get_str_bits (sp, bits, up, un);
+  else
+    {
+      struct mpn_base_info info;
+
+      mpn_get_base_info (&info, base);
+      return mpn_get_str_other (sp, base, &info, up, un);
+    }
+}
+
+static mp_size_t
+mpn_set_str_bits (mp_ptr rp, const unsigned char *sp, size_t sn,
+		  unsigned bits)
+{
+  mp_size_t rn;
+  size_t j;
+  unsigned shift;
+
+  for (j =3D sn, rn =3D 0, shift =3D 0; j-- > 0; )
+    {
+      if (shift =3D=3D 0)
+	{
+	  rp[rn++] =3D sp[j];
+	  shift +=3D bits;
+	}
+      else
+	{
+	  rp[rn-1] |=3D (mp_limb_t) sp[j] << shift;
+	  shift +=3D bits;
+	  if (shift >=3D GMP_LIMB_BITS)
+	    {
+	      shift -=3D GMP_LIMB_BITS;
+	      if (shift > 0)
+		rp[rn++] =3D (mp_limb_t) sp[j] >> (bits - shift);
+	    }
+	}
+    }
+  rn =3D mpn_normalized_size (rp, rn);
+  return rn;
+}
+
+static mp_size_t
+mpn_set_str_other (mp_ptr rp, const unsigned char *sp, size_t sn,
+		   mp_limb_t b, const struct mpn_base_info *info)
+{
+  mp_size_t rn;
+  mp_limb_t w;
+  unsigned k;
+  size_t j;
+
+  k =3D 1 + (sn - 1) % info->exp;
+
+  j =3D 0;
+  w =3D sp[j++];
+  for (; --k > 0; )
+    w =3D w * b + sp[j++];
+
+  rp[0] =3D w;
+
+  for (rn =3D (w > 0); j < sn;)
+    {
+      mp_limb_t cy;
+
+      w =3D sp[j++];
+      for (k =3D 1; k < info->exp; k++)
+	w =3D w * b + sp[j++];
+
+      cy =3D mpn_mul_1 (rp, rp, rn, info->bb);
+      cy +=3D mpn_add_1 (rp, rp, rn, w);
+      if (cy > 0)
+	rp[rn++] =3D cy;
+    }
+  assert (j =3D=3D sn);
+
+  return rn;
+}
+
+mp_size_t
+mpn_set_str (mp_ptr rp, const unsigned char *sp, size_t sn, int base)
+{
+  unsigned bits;
+
+  if (sn =3D=3D 0)
+    return 0;
+
+  bits =3D mpn_base_power_of_two_p (base);
+  if (bits)
+    return mpn_set_str_bits (rp, sp, sn, bits);
+  else
+    {
+      struct mpn_base_info info;
+
+      mpn_get_base_info (&info, base);
+      return mpn_set_str_other (rp, sp, sn, base, &info);
+    }
+}
+
+=0C
+/* MPZ interface */
+void
+mpz_init (mpz_t r)
+{
+  r->_mp_alloc =3D 1;
+  r->_mp_size =3D 0;
+  r->_mp_d =3D gmp_xalloc_limbs (1);
+}
+
+/* The utility of this function is a bit limited, since many functions
+   assigns the result variable using mpz_swap. */
+void
+mpz_init2 (mpz_t r, mp_bitcnt_t bits)
+{
+  mp_size_t rn;
+
+  bits -=3D (bits !=3D 0);		/* Round down, except if 0 */
+  rn =3D 1 + bits / GMP_LIMB_BITS;
+
+  r->_mp_alloc =3D rn;
+  r->_mp_size =3D 0;
+  r->_mp_d =3D gmp_xalloc_limbs (rn);
+}
+
+void
+mpz_clear (mpz_t r)
+{
+  gmp_free (r->_mp_d);
+}
+
+static void *
+mpz_realloc (mpz_t r, mp_size_t size)
+{
+  size =3D GMP_MAX (size, 1);
+
+  r->_mp_d =3D gmp_xrealloc_limbs (r->_mp_d, size);
+  r->_mp_alloc =3D size;
+
+  if (GMP_ABS (r->_mp_size) > size)
+    r->_mp_size =3D 0;
+
+  return r->_mp_d;
+}
+
+/* Realloc for an mpz_t WHAT if it has less than NEEDED limbs.  */
+#define MPZ_REALLOC(z,n) ((n) > (z)->_mp_alloc			\
+			  ? mpz_realloc(z,n)			\
+			  : (z)->_mp_d)
+=0C
+/* MPZ assignment and basic conversions. */
+void
+mpz_set_si (mpz_t r, signed long int x)
+{
+  if (x >=3D 0)
+    mpz_set_ui (r, x);
+  else /* (x < 0) */
+    {
+      r->_mp_size =3D -1;
+      r->_mp_d[0] =3D GMP_NEG_CAST (unsigned long int, x);
+    }
+}
+
+void
+mpz_set_ui (mpz_t r, unsigned long int x)
+{
+  if (x > 0)
+    {
+      r->_mp_size =3D 1;
+      r->_mp_d[0] =3D x;
+    }
+  else
+    r->_mp_size =3D 0;
+}
+
+void
+mpz_set (mpz_t r, const mpz_t x)
+{
+  /* Allow the NOP r =3D=3D x */
+  if (r !=3D x)
+    {
+      mp_size_t n;
+      mp_ptr rp;
+
+      n =3D GMP_ABS (x->_mp_size);
+      rp =3D MPZ_REALLOC (r, n);
+
+      mpn_copyi (rp, x->_mp_d, n);
+      r->_mp_size =3D x->_mp_size;
+    }
+}
+
+void
+mpz_init_set_si (mpz_t r, signed long int x)
+{
+  mpz_init (r);
+  mpz_set_si (r, x);
+}
+
+void
+mpz_init_set_ui (mpz_t r, unsigned long int x)
+{
+  mpz_init (r);
+  mpz_set_ui (r, x);
+}
+
+void
+mpz_init_set (mpz_t r, const mpz_t x)
+{
+  mpz_init (r);
+  mpz_set (r, x);
+}
+
+int
+mpz_fits_slong_p (const mpz_t u)
+{
+  mp_size_t us =3D u->_mp_size;
+
+  if (us =3D=3D 0)
+    return 1;
+  else if (us =3D=3D 1)
+    return u->_mp_d[0] < GMP_LIMB_HIGHBIT;
+  else if (us =3D=3D -1)
+    return u->_mp_d[0] <=3D GMP_LIMB_HIGHBIT;
+  else
+    return 0;
+}
+
+int
+mpz_fits_ulong_p (const mpz_t u)
+{
+  mp_size_t us =3D u->_mp_size;
+
+  return (us =3D=3D (us > 0));
+}
+
+long int
+mpz_get_si (const mpz_t u)
+{
+  mp_size_t us =3D u->_mp_size;
+
+  if (us > 0)
+    return (long) (u->_mp_d[0] & ~GMP_LIMB_HIGHBIT);
+  else if (us < 0)
+    return (long) (- u->_mp_d[0] | GMP_LIMB_HIGHBIT);
+  else
+    return 0;
+}
+
+unsigned long int
+mpz_get_ui (const mpz_t u)
+{
+  return u->_mp_size =3D=3D 0 ? 0 : u->_mp_d[0];
+}
+
+size_t
+mpz_size (const mpz_t u)
+{
+  return GMP_ABS (u->_mp_size);
+}
+
+mp_limb_t
+mpz_getlimbn (const mpz_t u, mp_size_t n)
+{
+  if (n >=3D 0 && n < GMP_ABS (u->_mp_size))
+    return u->_mp_d[n];
+  else
+    return 0;
+}
+
+void
+mpz_realloc2 (mpz_t x, mp_bitcnt_t n)
+{
+  mpz_realloc (x, 1 + (n - (n !=3D 0)) / GMP_LIMB_BITS);
+}
+
+mp_srcptr
+mpz_limbs_read (mpz_srcptr x)
+{
+  return x->_mp_d;;
+}
+
+mp_ptr
+mpz_limbs_modify (mpz_t x, mp_size_t n)
+{
+  assert (n > 0);
+  return MPZ_REALLOC (x, n);
+}
+
+mp_ptr
+mpz_limbs_write (mpz_t x, mp_size_t n)
+{
+  return mpz_limbs_modify (x, n);
+}
+
+void
+mpz_limbs_finish (mpz_t x, mp_size_t xs)
+{
+  mp_size_t xn;
+  xn =3D mpn_normalized_size (x->_mp_d, GMP_ABS (xs));
+  x->_mp_size =3D xs < 0 ? -xn : xn;
+}
+
+mpz_srcptr
+mpz_roinit_n (mpz_t x, mp_srcptr xp, mp_size_t xs)
+{
+  x->_mp_alloc =3D 0;
+  x->_mp_d =3D (mp_ptr) xp;
+  mpz_limbs_finish (x, xs);
+  return x;
+}
+
+=0C
+/* Conversions and comparison to double. */
+void
+mpz_set_d (mpz_t r, double x)
+{
+  int sign;
+  mp_ptr rp;
+  mp_size_t rn, i;
+  double B;
+  double Bi;
+  mp_limb_t f;
+
+  /* x !=3D x is true when x is a NaN, and x =3D=3D x * 0.5 is true wh=
en x is
+     zero or infinity. */
+  if (x !=3D x || x =3D=3D x * 0.5)
+    {
+      r->_mp_size =3D 0;
+      return;
+    }
+
+  sign =3D x < 0.0 ;
+  if (sign)
+    x =3D - x;
+
+  if (x < 1.0)
+    {
+      r->_mp_size =3D 0;
+      return;
+    }
+  B =3D 2.0 * (double) GMP_LIMB_HIGHBIT;
+  Bi =3D 1.0 / B;
+  for (rn =3D 1; x >=3D B; rn++)
+    x *=3D Bi;
+
+  rp =3D MPZ_REALLOC (r, rn);
+
+  f =3D (mp_limb_t) x;
+  x -=3D f;
+  assert (x < 1.0);
+  i =3D rn-1;
+  rp[i] =3D f;
+  while (--i >=3D 0)
+    {
+      x =3D B * x;
+      f =3D (mp_limb_t) x;
+      x -=3D f;
+      assert (x < 1.0);
+      rp[i] =3D f;
+    }
+
+  r->_mp_size =3D sign ? - rn : rn;
+}
+
+void
+mpz_init_set_d (mpz_t r, double x)
+{
+  mpz_init (r);
+  mpz_set_d (r, x);
+}
+
+double
+mpz_get_d (const mpz_t u)
+{
+  mp_size_t un;
+  double x;
+  double B =3D 2.0 * (double) GMP_LIMB_HIGHBIT;
+
+  un =3D GMP_ABS (u->_mp_size);
+
+  if (un =3D=3D 0)
+    return 0.0;
+
+  x =3D u->_mp_d[--un];
+  while (un > 0)
+    x =3D B*x + u->_mp_d[--un];
+
+  if (u->_mp_size < 0)
+    x =3D -x;
+
+  return x;
+}
+
+int
+mpz_cmpabs_d (const mpz_t x, double d)
+{
+  mp_size_t xn;
+  double B, Bi;
+  mp_size_t i;
+
+  xn =3D x->_mp_size;
+  d =3D GMP_ABS (d);
+
+  if (xn !=3D 0)
+    {
+      xn =3D GMP_ABS (xn);
+
+      B =3D 2.0 * (double) GMP_LIMB_HIGHBIT;
+      Bi =3D 1.0 / B;
+
+      /* Scale d so it can be compared with the top limb. */
+      for (i =3D 1; i < xn; i++)
+	d *=3D Bi;
+
+      if (d >=3D B)
+	return -1;
+
+      /* Compare floor(d) to top limb, subtract and cancel when equal.=
 */
+      for (i =3D xn; i-- > 0;)
+	{
+	  mp_limb_t f, xl;
+
+	  f =3D (mp_limb_t) d;
+	  xl =3D x->_mp_d[i];
+	  if (xl > f)
+	    return 1;
+	  else if (xl < f)
+	    return -1;
+	  d =3D B * (d - f);
+	}
+    }
+  return - (d > 0.0);
+}
+
+int
+mpz_cmp_d (const mpz_t x, double d)
+{
+  if (x->_mp_size < 0)
+    {
+      if (d >=3D 0.0)
+	return -1;
+      else
+	return -mpz_cmpabs_d (x, d);
+    }
+  else
+    {
+      if (d < 0.0)
+	return 1;
+      else
+	return mpz_cmpabs_d (x, d);
+    }
+}
+
+=0C
+/* MPZ comparisons and the like. */
+int
+mpz_sgn (const mpz_t u)
+{
+  mp_size_t usize =3D u->_mp_size;
+
+  return (usize > 0) - (usize < 0);
+}
+
+int
+mpz_cmp_si (const mpz_t u, long v)
+{
+  mp_size_t usize =3D u->_mp_size;
+
+  if (usize < -1)
+    return -1;
+  else if (v >=3D 0)
+    return mpz_cmp_ui (u, v);
+  else if (usize >=3D 0)
+    return 1;
+  else /* usize =3D=3D -1 */
+    {
+      mp_limb_t ul =3D u->_mp_d[0];
+      if ((mp_limb_t)GMP_NEG_CAST (unsigned long int, v) < ul)
+	return -1;
+      else
+	return (mp_limb_t)GMP_NEG_CAST (unsigned long int, v) > ul;
+    }
+}
+
+int
+mpz_cmp_ui (const mpz_t u, unsigned long v)
+{
+  mp_size_t usize =3D u->_mp_size;
+
+  if (usize > 1)
+    return 1;
+  else if (usize < 0)
+    return -1;
+  else
+    {
+      mp_limb_t ul =3D (usize > 0) ? u->_mp_d[0] : 0;
+      return (ul > v) - (ul < v);
+    }
+}
+
+int
+mpz_cmp (const mpz_t a, const mpz_t b)
+{
+  mp_size_t asize =3D a->_mp_size;
+  mp_size_t bsize =3D b->_mp_size;
+
+  if (asize !=3D bsize)
+    return (asize < bsize) ? -1 : 1;
+  else if (asize >=3D 0)
+    return mpn_cmp (a->_mp_d, b->_mp_d, asize);
+  else
+    return mpn_cmp (b->_mp_d, a->_mp_d, -asize);
+}
+
+int
+mpz_cmpabs_ui (const mpz_t u, unsigned long v)
+{
+  mp_size_t un =3D GMP_ABS (u->_mp_size);
+  mp_limb_t ul;
+
+  if (un > 1)
+    return 1;
+
+  ul =3D (un =3D=3D 1) ? u->_mp_d[0] : 0;
+
+  return (ul > v) - (ul < v);
+}
+
+int
+mpz_cmpabs (const mpz_t u, const mpz_t v)
+{
+  return mpn_cmp4 (u->_mp_d, GMP_ABS (u->_mp_size),
+		   v->_mp_d, GMP_ABS (v->_mp_size));
+}
+
+void
+mpz_abs (mpz_t r, const mpz_t u)
+{
+  if (r !=3D u)
+    mpz_set (r, u);
+
+  r->_mp_size =3D GMP_ABS (r->_mp_size);
+}
+
+void
+mpz_neg (mpz_t r, const mpz_t u)
+{
+  if (r !=3D u)
+    mpz_set (r, u);
+
+  r->_mp_size =3D -r->_mp_size;
+}
+
+void
+mpz_swap (mpz_t u, mpz_t v)
+{
+  MP_SIZE_T_SWAP (u->_mp_size, v->_mp_size);
+  MP_SIZE_T_SWAP (u->_mp_alloc, v->_mp_alloc);
+  MP_PTR_SWAP (u->_mp_d, v->_mp_d);
+}
+
+=0C
+/* MPZ addition and subtraction */
+
+/* Adds to the absolute value. Returns new size, but doesn't store it.=
 */
+static mp_size_t
+mpz_abs_add_ui (mpz_t r, const mpz_t a, unsigned long b)
+{
+  mp_size_t an;
+  mp_ptr rp;
+  mp_limb_t cy;
+
+  an =3D GMP_ABS (a->_mp_size);
+  if (an =3D=3D 0)
+    {
+      r->_mp_d[0] =3D b;
+      return b > 0;
+    }
+
+  rp =3D MPZ_REALLOC (r, an + 1);
+
+  cy =3D mpn_add_1 (rp, a->_mp_d, an, b);
+  rp[an] =3D cy;
+  an +=3D cy;
+
+  return an;
+}
+
+/* Subtract from the absolute value. Returns new size, (or -1 on under=
flow),
+   but doesn't store it. */
+static mp_size_t
+mpz_abs_sub_ui (mpz_t r, const mpz_t a, unsigned long b)
+{
+  mp_size_t an =3D GMP_ABS (a->_mp_size);
+  mp_ptr rp =3D MPZ_REALLOC (r, an);
+
+  if (an =3D=3D 0)
+    {
+      rp[0] =3D b;
+      return -(b > 0);
+    }
+  else if (an =3D=3D 1 && a->_mp_d[0] < b)
+    {
+      rp[0] =3D b - a->_mp_d[0];
+      return -1;
+    }
+  else
+    {
+      gmp_assert_nocarry (mpn_sub_1 (rp, a->_mp_d, an, b));
+      return mpn_normalized_size (rp, an);
+    }
+}
+
+void
+mpz_add_ui (mpz_t r, const mpz_t a, unsigned long b)
+{
+  if (a->_mp_size >=3D 0)
+    r->_mp_size =3D mpz_abs_add_ui (r, a, b);
+  else
+    r->_mp_size =3D -mpz_abs_sub_ui (r, a, b);
+}
+
+void
+mpz_sub_ui (mpz_t r, const mpz_t a, unsigned long b)
+{
+  if (a->_mp_size < 0)
+    r->_mp_size =3D -mpz_abs_add_ui (r, a, b);
+  else
+    r->_mp_size =3D mpz_abs_sub_ui (r, a, b);
+}
+
+void
+mpz_ui_sub (mpz_t r, unsigned long a, const mpz_t b)
+{
+  if (b->_mp_size < 0)
+    r->_mp_size =3D mpz_abs_add_ui (r, b, a);
+  else
+    r->_mp_size =3D -mpz_abs_sub_ui (r, b, a);
+}
+
+static mp_size_t
+mpz_abs_add (mpz_t r, const mpz_t a, const mpz_t b)
+{
+  mp_size_t an =3D GMP_ABS (a->_mp_size);
+  mp_size_t bn =3D GMP_ABS (b->_mp_size);
+  mp_ptr rp;
+  mp_limb_t cy;
+
+  if (an < bn)
+    {
+      MPZ_SRCPTR_SWAP (a, b);
+      MP_SIZE_T_SWAP (an, bn);
+    }
+
+  rp =3D MPZ_REALLOC (r, an + 1);
+  cy =3D mpn_add (rp, a->_mp_d, an, b->_mp_d, bn);
+
+  rp[an] =3D cy;
+
+  return an + cy;
+}
+
+static mp_size_t
+mpz_abs_sub (mpz_t r, const mpz_t a, const mpz_t b)
+{
+  mp_size_t an =3D GMP_ABS (a->_mp_size);
+  mp_size_t bn =3D GMP_ABS (b->_mp_size);
+  int cmp;
+  mp_ptr rp;
+
+  cmp =3D mpn_cmp4 (a->_mp_d, an, b->_mp_d, bn);
+  if (cmp > 0)
+    {
+      rp =3D MPZ_REALLOC (r, an);
+      gmp_assert_nocarry (mpn_sub (rp, a->_mp_d, an, b->_mp_d, bn));
+      return mpn_normalized_size (rp, an);
+    }
+  else if (cmp < 0)
+    {
+      rp =3D MPZ_REALLOC (r, bn);
+      gmp_assert_nocarry (mpn_sub (rp, b->_mp_d, bn, a->_mp_d, an));
+      return -mpn_normalized_size (rp, bn);
+    }
+  else
+    return 0;
+}
+
+void
+mpz_add (mpz_t r, const mpz_t a, const mpz_t b)
+{
+  mp_size_t rn;
+
+  if ( (a->_mp_size ^ b->_mp_size) >=3D 0)
+    rn =3D mpz_abs_add (r, a, b);
+  else
+    rn =3D mpz_abs_sub (r, a, b);
+
+  r->_mp_size =3D a->_mp_size >=3D 0 ? rn : - rn;
+}
+
+void
+mpz_sub (mpz_t r, const mpz_t a, const mpz_t b)
+{
+  mp_size_t rn;
+
+  if ( (a->_mp_size ^ b->_mp_size) >=3D 0)
+    rn =3D mpz_abs_sub (r, a, b);
+  else
+    rn =3D mpz_abs_add (r, a, b);
+
+  r->_mp_size =3D a->_mp_size >=3D 0 ? rn : - rn;
+}
+
+=0C
+/* MPZ multiplication */
+void
+mpz_mul_si (mpz_t r, const mpz_t u, long int v)
+{
+  if (v < 0)
+    {
+      mpz_mul_ui (r, u, GMP_NEG_CAST (unsigned long int, v));
+      mpz_neg (r, r);
+    }
+  else
+    mpz_mul_ui (r, u, (unsigned long int) v);
+}
+
+void
+mpz_mul_ui (mpz_t r, const mpz_t u, unsigned long int v)
+{
+  mp_size_t un, us;
+  mp_ptr tp;
+  mp_limb_t cy;
+
+  us =3D u->_mp_size;
+
+  if (us =3D=3D 0 || v =3D=3D 0)
+    {
+      r->_mp_size =3D 0;
+      return;
+    }
+
+  un =3D GMP_ABS (us);
+
+  tp =3D MPZ_REALLOC (r, un + 1);
+  cy =3D mpn_mul_1 (tp, u->_mp_d, un, v);
+  tp[un] =3D cy;
+
+  un +=3D (cy > 0);
+  r->_mp_size =3D (us < 0) ? - un : un;
+}
+
+void
+mpz_mul (mpz_t r, const mpz_t u, const mpz_t v)
+{
+  int sign;
+  mp_size_t un, vn, rn;
+  mpz_t t;
+  mp_ptr tp;
+
+  un =3D u->_mp_size;
+  vn =3D v->_mp_size;
+
+  if (un =3D=3D 0 || vn =3D=3D 0)
+    {
+      r->_mp_size =3D 0;
+      return;
+    }
+
+  sign =3D (un ^ vn) < 0;
+
+  un =3D GMP_ABS (un);
+  vn =3D GMP_ABS (vn);
+
+  mpz_init2 (t, (un + vn) * GMP_LIMB_BITS);
+
+  tp =3D t->_mp_d;
+  if (un >=3D vn)
+    mpn_mul (tp, u->_mp_d, un, v->_mp_d, vn);
+  else
+    mpn_mul (tp, v->_mp_d, vn, u->_mp_d, un);
+
+  rn =3D un + vn;
+  rn -=3D tp[rn-1] =3D=3D 0;
+
+  t->_mp_size =3D sign ? - rn : rn;
+  mpz_swap (r, t);
+  mpz_clear (t);
+}
+
+void
+mpz_mul_2exp (mpz_t r, const mpz_t u, mp_bitcnt_t bits)
+{
+  mp_size_t un, rn;
+  mp_size_t limbs;
+  unsigned shift;
+  mp_ptr rp;
+
+  un =3D GMP_ABS (u->_mp_size);
+  if (un =3D=3D 0)
+    {
+      r->_mp_size =3D 0;
+      return;
+    }
+
+  limbs =3D bits / GMP_LIMB_BITS;
+  shift =3D bits % GMP_LIMB_BITS;
+
+  rn =3D un + limbs + (shift > 0);
+  rp =3D MPZ_REALLOC (r, rn);
+  if (shift > 0)
+    {
+      mp_limb_t cy =3D mpn_lshift (rp + limbs, u->_mp_d, un, shift);
+      rp[rn-1] =3D cy;
+      rn -=3D (cy =3D=3D 0);
+    }
+  else
+    mpn_copyd (rp + limbs, u->_mp_d, un);
+
+  while (limbs > 0)
+    rp[--limbs] =3D 0;
+
+  r->_mp_size =3D (u->_mp_size < 0) ? - rn : rn;
+}
+
+void
+mpz_addmul_ui (mpz_t r, const mpz_t u, unsigned long int v)
+{
+  mpz_t t;
+  mpz_init (t);
+  mpz_mul_ui (t, u, v);
+  mpz_add (r, r, t);
+  mpz_clear (t);
+}
+
+void
+mpz_submul_ui (mpz_t r, const mpz_t u, unsigned long int v)
+{
+  mpz_t t;
+  mpz_init (t);
+  mpz_mul_ui (t, u, v);
+  mpz_sub (r, r, t);
+  mpz_clear (t);
+}
+
+void
+mpz_addmul (mpz_t r, const mpz_t u, const mpz_t v)
+{
+  mpz_t t;
+  mpz_init (t);
+  mpz_mul (t, u, v);
+  mpz_add (r, r, t);
+  mpz_clear (t);
+}
+
+void
+mpz_submul (mpz_t r, const mpz_t u, const mpz_t v)
+{
+  mpz_t t;
+  mpz_init (t);
+  mpz_mul (t, u, v);
+  mpz_sub (r, r, t);
+  mpz_clear (t);
+}
+
+=0C
+/* MPZ division */
+enum mpz_div_round_mode { GMP_DIV_FLOOR, GMP_DIV_CEIL, GMP_DIV_TRUNC }=
;
+
+/* Allows q or r to be zero. Returns 1 iff remainder is non-zero. */
+static int
+mpz_div_qr (mpz_t q, mpz_t r,
+	    const mpz_t n, const mpz_t d, enum mpz_div_round_mode mode)
+{
+  mp_size_t ns, ds, nn, dn, qs;
+  ns =3D n->_mp_size;
+  ds =3D d->_mp_size;
+
+  if (ds =3D=3D 0)
+    gmp_die("mpz_div_qr: Divide by zero.");
+
+  if (ns =3D=3D 0)
+    {
+      if (q)
+	q->_mp_size =3D 0;
+      if (r)
+	r->_mp_size =3D 0;
+      return 0;
+    }
+
+  nn =3D GMP_ABS (ns);
+  dn =3D GMP_ABS (ds);
+
+  qs =3D ds ^ ns;
+
+  if (nn < dn)
+    {
+      if (mode =3D=3D GMP_DIV_CEIL && qs >=3D 0)
+	{
+	  /* q =3D 1, r =3D n - d */
+	  if (r)
+	    mpz_sub (r, n, d);
+	  if (q)
+	    mpz_set_ui (q, 1);
+	}
+      else if (mode =3D=3D GMP_DIV_FLOOR && qs < 0)
+	{
+	  /* q =3D -1, r =3D n + d */
+	  if (r)
+	    mpz_add (r, n, d);
+	  if (q)
+	    mpz_set_si (q, -1);
+	}
+      else
+	{
+	  /* q =3D 0, r =3D d */
+	  if (r)
+	    mpz_set (r, n);
+	  if (q)
+	    q->_mp_size =3D 0;
+	}
+      return 1;
+    }
+  else
+    {
+      mp_ptr np, qp;
+      mp_size_t qn, rn;
+      mpz_t tq, tr;
+
+      mpz_init_set (tr, n);
+      np =3D tr->_mp_d;
+
+      qn =3D nn - dn + 1;
+
+      if (q)
+	{
+	  mpz_init2 (tq, qn * GMP_LIMB_BITS);
+	  qp =3D tq->_mp_d;
+	}
+      else
+	qp =3D NULL;
+
+      mpn_div_qr (qp, np, nn, d->_mp_d, dn);
+
+      if (qp)
+	{
+	  qn -=3D (qp[qn-1] =3D=3D 0);
+
+	  tq->_mp_size =3D qs < 0 ? -qn : qn;
+	}
+      rn =3D mpn_normalized_size (np, dn);
+      tr->_mp_size =3D ns < 0 ? - rn : rn;
+
+      if (mode =3D=3D GMP_DIV_FLOOR && qs < 0 && rn !=3D 0)
+	{
+	  if (q)
+	    mpz_sub_ui (tq, tq, 1);
+	  if (r)
+	    mpz_add (tr, tr, d);
+	}
+      else if (mode =3D=3D GMP_DIV_CEIL && qs >=3D 0 && rn !=3D 0)
+	{
+	  if (q)
+	    mpz_add_ui (tq, tq, 1);
+	  if (r)
+	    mpz_sub (tr, tr, d);
+	}
+
+      if (q)
+	{
+	  mpz_swap (tq, q);
+	  mpz_clear (tq);
+	}
+      if (r)
+	mpz_swap (tr, r);
+
+      mpz_clear (tr);
+
+      return rn !=3D 0;
+    }
+}
+
+void
+mpz_cdiv_qr (mpz_t q, mpz_t r, const mpz_t n, const mpz_t d)
+{
+  mpz_div_qr (q, r, n, d, GMP_DIV_CEIL);
+}
+
+void
+mpz_fdiv_qr (mpz_t q, mpz_t r, const mpz_t n, const mpz_t d)
+{
+  mpz_div_qr (q, r, n, d, GMP_DIV_FLOOR);
+}
+
+void
+mpz_tdiv_qr (mpz_t q, mpz_t r, const mpz_t n, const mpz_t d)
+{
+  mpz_div_qr (q, r, n, d, GMP_DIV_TRUNC);
+}
+
+void
+mpz_cdiv_q (mpz_t q, const mpz_t n, const mpz_t d)
+{
+  mpz_div_qr (q, NULL, n, d, GMP_DIV_CEIL);
+}
+
+void
+mpz_fdiv_q (mpz_t q, const mpz_t n, const mpz_t d)
+{
+  mpz_div_qr (q, NULL, n, d, GMP_DIV_FLOOR);
+}
+
+void
+mpz_tdiv_q (mpz_t q, const mpz_t n, const mpz_t d)
+{
+  mpz_div_qr (q, NULL, n, d, GMP_DIV_TRUNC);
+}
+
+void
+mpz_cdiv_r (mpz_t r, const mpz_t n, const mpz_t d)
+{
+  mpz_div_qr (NULL, r, n, d, GMP_DIV_CEIL);
+}
+
+void
+mpz_fdiv_r (mpz_t r, const mpz_t n, const mpz_t d)
+{
+  mpz_div_qr (NULL, r, n, d, GMP_DIV_FLOOR);
+}
+
+void
+mpz_tdiv_r (mpz_t r, const mpz_t n, const mpz_t d)
+{
+  mpz_div_qr (NULL, r, n, d, GMP_DIV_TRUNC);
+}
+
+void
+mpz_mod (mpz_t r, const mpz_t n, const mpz_t d)
+{
+  mpz_div_qr (NULL, r, n, d, d->_mp_size >=3D 0 ? GMP_DIV_FLOOR : GMP_=
DIV_CEIL);
+}
+
+static void
+mpz_div_q_2exp (mpz_t q, const mpz_t u, mp_bitcnt_t bit_index,
+		enum mpz_div_round_mode mode)
+{
+  mp_size_t un, qn;
+  mp_size_t limb_cnt;
+  mp_ptr qp;
+  int adjust;
+
+  un =3D u->_mp_size;
+  if (un =3D=3D 0)
+    {
+      q->_mp_size =3D 0;
+      return;
+    }
+  limb_cnt =3D bit_index / GMP_LIMB_BITS;
+  qn =3D GMP_ABS (un) - limb_cnt;
+  bit_index %=3D GMP_LIMB_BITS;
+
+  if (mode =3D=3D ((un > 0) ? GMP_DIV_CEIL : GMP_DIV_FLOOR)) /* un !=3D=
 0 here. */
+    /* Note: Below, the final indexing at limb_cnt is valid because at
+       that point we have qn > 0. */
+    adjust =3D (qn <=3D 0
+	      || !mpn_zero_p (u->_mp_d, limb_cnt)
+	      || (u->_mp_d[limb_cnt]
+		  & (((mp_limb_t) 1 << bit_index) - 1)));
+  else
+    adjust =3D 0;
+
+  if (qn <=3D 0)
+    qn =3D 0;
+
+  else
+    {
+      qp =3D MPZ_REALLOC (q, qn);
+
+      if (bit_index !=3D 0)
+	{
+	  mpn_rshift (qp, u->_mp_d + limb_cnt, qn, bit_index);
+	  qn -=3D qp[qn - 1] =3D=3D 0;
+	}
+      else
+	{
+	  mpn_copyi (qp, u->_mp_d + limb_cnt, qn);
+	}
+    }
+
+  q->_mp_size =3D qn;
+
+  if (adjust)
+    mpz_add_ui (q, q, 1);
+  if (un < 0)
+    mpz_neg (q, q);
+}
+
+static void
+mpz_div_r_2exp (mpz_t r, const mpz_t u, mp_bitcnt_t bit_index,
+		enum mpz_div_round_mode mode)
+{
+  mp_size_t us, un, rn;
+  mp_ptr rp;
+  mp_limb_t mask;
+
+  us =3D u->_mp_size;
+  if (us =3D=3D 0 || bit_index =3D=3D 0)
+    {
+      r->_mp_size =3D 0;
+      return;
+    }
+  rn =3D (bit_index + GMP_LIMB_BITS - 1) / GMP_LIMB_BITS;
+  assert (rn > 0);
+
+  rp =3D MPZ_REALLOC (r, rn);
+  un =3D GMP_ABS (us);
+
+  mask =3D GMP_LIMB_MAX >> (rn * GMP_LIMB_BITS - bit_index);
+
+  if (rn > un)
+    {
+      /* Quotient (with truncation) is zero, and remainder is
+	 non-zero */
+      if (mode =3D=3D ((us > 0) ? GMP_DIV_CEIL : GMP_DIV_FLOOR)) /* us=
 !=3D 0 here. */
+	{
+	  /* Have to negate and sign extend. */
+	  mp_size_t i;
+	  mp_limb_t cy;
+
+	  for (cy =3D 1, i =3D 0; i < un; i++)
+	    {
+	      mp_limb_t s =3D ~u->_mp_d[i] + cy;
+	      cy =3D s < cy;
+	      rp[i] =3D s;
+	    }
+	  assert (cy =3D=3D 0);
+	  for (; i < rn - 1; i++)
+	    rp[i] =3D GMP_LIMB_MAX;
+
+	  rp[rn-1] =3D mask;
+	  us =3D -us;
+	}
+      else
+	{
+	  /* Just copy */
+	  if (r !=3D u)
+	    mpn_copyi (rp, u->_mp_d, un);
+
+	  rn =3D un;
+	}
+    }
+  else
+    {
+      if (r !=3D u)
+	mpn_copyi (rp, u->_mp_d, rn - 1);
+
+      rp[rn-1] =3D u->_mp_d[rn-1] & mask;
+
+      if (mode =3D=3D ((us > 0) ? GMP_DIV_CEIL : GMP_DIV_FLOOR)) /* us=
 !=3D 0 here. */
+	{
+	  /* If r !=3D 0, compute 2^{bit_count} - r. */
+	  mp_size_t i;
+
+	  for (i =3D 0; i < rn && rp[i] =3D=3D 0; i++)
+	    ;
+	  if (i < rn)
+	    {
+	      /* r > 0, need to flip sign. */
+	      rp[i] =3D ~rp[i] + 1;
+	      while (++i < rn)
+		rp[i] =3D ~rp[i];
+
+	      rp[rn-1] &=3D mask;
+
+	      /* us is not used for anything else, so we can modify it
+		 here to indicate flipped sign. */
+	      us =3D -us;
+	    }
+	}
+    }
+  rn =3D mpn_normalized_size (rp, rn);
+  r->_mp_size =3D us < 0 ? -rn : rn;
+}
+
+void
+mpz_cdiv_q_2exp (mpz_t r, const mpz_t u, mp_bitcnt_t cnt)
+{
+  mpz_div_q_2exp (r, u, cnt, GMP_DIV_CEIL);
+}
+
+void
+mpz_fdiv_q_2exp (mpz_t r, const mpz_t u, mp_bitcnt_t cnt)
+{
+  mpz_div_q_2exp (r, u, cnt, GMP_DIV_FLOOR);
+}
+
+void
+mpz_tdiv_q_2exp (mpz_t r, const mpz_t u, mp_bitcnt_t cnt)
+{
+  mpz_div_q_2exp (r, u, cnt, GMP_DIV_TRUNC);
+}
+
+void
+mpz_cdiv_r_2exp (mpz_t r, const mpz_t u, mp_bitcnt_t cnt)
+{
+  mpz_div_r_2exp (r, u, cnt, GMP_DIV_CEIL);
+}
+
+void
+mpz_fdiv_r_2exp (mpz_t r, const mpz_t u, mp_bitcnt_t cnt)
+{
+  mpz_div_r_2exp (r, u, cnt, GMP_DIV_FLOOR);
+}
+
+void
+mpz_tdiv_r_2exp (mpz_t r, const mpz_t u, mp_bitcnt_t cnt)
+{
+  mpz_div_r_2exp (r, u, cnt, GMP_DIV_TRUNC);
+}
+
+void
+mpz_divexact (mpz_t q, const mpz_t n, const mpz_t d)
+{
+  gmp_assert_nocarry (mpz_div_qr (q, NULL, n, d, GMP_DIV_TRUNC));
+}
+
+int
+mpz_divisible_p (const mpz_t n, const mpz_t d)
+{
+  return mpz_div_qr (NULL, NULL, n, d, GMP_DIV_TRUNC) =3D=3D 0;
+}
+
+int
+mpz_congruent_p (const mpz_t a, const mpz_t b, const mpz_t m)
+{
+  mpz_t t;
+  int res;
+
+  /* a =3D=3D b (mod 0) iff a =3D=3D b */
+  if (mpz_sgn (m) =3D=3D 0)
+    return (mpz_cmp (a, b) =3D=3D 0);
+
+  mpz_init (t);
+  mpz_sub (t, a, b);
+  res =3D mpz_divisible_p (t, m);
+  mpz_clear (t);
+
+  return res;
+}
+
+static unsigned long
+mpz_div_qr_ui (mpz_t q, mpz_t r,
+	       const mpz_t n, unsigned long d, enum mpz_div_round_mode mode)
+{
+  mp_size_t ns, qn;
+  mp_ptr qp;
+  mp_limb_t rl;
+  mp_size_t rs;
+
+  ns =3D n->_mp_size;
+  if (ns =3D=3D 0)
+    {
+      if (q)
+	q->_mp_size =3D 0;
+      if (r)
+	r->_mp_size =3D 0;
+      return 0;
+    }
+
+  qn =3D GMP_ABS (ns);
+  if (q)
+    qp =3D MPZ_REALLOC (q, qn);
+  else
+    qp =3D NULL;
+
+  rl =3D mpn_div_qr_1 (qp, n->_mp_d, qn, d);
+  assert (rl < d);
+
+  rs =3D rl > 0;
+  rs =3D (ns < 0) ? -rs : rs;
+
+  if (rl > 0 && ( (mode =3D=3D GMP_DIV_FLOOR && ns < 0)
+		  || (mode =3D=3D GMP_DIV_CEIL && ns >=3D 0)))
+    {
+      if (q)
+	gmp_assert_nocarry (mpn_add_1 (qp, qp, qn, 1));
+      rl =3D d - rl;
+      rs =3D -rs;
+    }
+
+  if (r)
+    {
+      r->_mp_d[0] =3D rl;
+      r->_mp_size =3D rs;
+    }
+  if (q)
+    {
+      qn -=3D (qp[qn-1] =3D=3D 0);
+      assert (qn =3D=3D 0 || qp[qn-1] > 0);
+
+      q->_mp_size =3D (ns < 0) ? - qn : qn;
+    }
+
+  return rl;
+}
+
+unsigned long
+mpz_cdiv_qr_ui (mpz_t q, mpz_t r, const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (q, r, n, d, GMP_DIV_CEIL);
+}
+
+unsigned long
+mpz_fdiv_qr_ui (mpz_t q, mpz_t r, const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (q, r, n, d, GMP_DIV_FLOOR);
+}
+
+unsigned long
+mpz_tdiv_qr_ui (mpz_t q, mpz_t r, const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (q, r, n, d, GMP_DIV_TRUNC);
+}
+
+unsigned long
+mpz_cdiv_q_ui (mpz_t q, const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (q, NULL, n, d, GMP_DIV_CEIL);
+}
+
+unsigned long
+mpz_fdiv_q_ui (mpz_t q, const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (q, NULL, n, d, GMP_DIV_FLOOR);
+}
+
+unsigned long
+mpz_tdiv_q_ui (mpz_t q, const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (q, NULL, n, d, GMP_DIV_TRUNC);
+}
+
+unsigned long
+mpz_cdiv_r_ui (mpz_t r, const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (NULL, r, n, d, GMP_DIV_CEIL);
+}
+unsigned long
+mpz_fdiv_r_ui (mpz_t r, const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (NULL, r, n, d, GMP_DIV_FLOOR);
+}
+unsigned long
+mpz_tdiv_r_ui (mpz_t r, const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (NULL, r, n, d, GMP_DIV_TRUNC);
+}
+
+unsigned long
+mpz_cdiv_ui (const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (NULL, NULL, n, d, GMP_DIV_CEIL);
+}
+
+unsigned long
+mpz_fdiv_ui (const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (NULL, NULL, n, d, GMP_DIV_FLOOR);
+}
+
+unsigned long
+mpz_tdiv_ui (const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (NULL, NULL, n, d, GMP_DIV_TRUNC);
+}
+
+unsigned long
+mpz_mod_ui (mpz_t r, const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (NULL, r, n, d, GMP_DIV_FLOOR);
+}
+
+void
+mpz_divexact_ui (mpz_t q, const mpz_t n, unsigned long d)
+{
+  gmp_assert_nocarry (mpz_div_qr_ui (q, NULL, n, d, GMP_DIV_TRUNC));
+}
+
+int
+mpz_divisible_ui_p (const mpz_t n, unsigned long d)
+{
+  return mpz_div_qr_ui (NULL, NULL, n, d, GMP_DIV_TRUNC) =3D=3D 0;
+}
+
+=0C
+/* GCD */
+static mp_limb_t
+mpn_gcd_11 (mp_limb_t u, mp_limb_t v)
+{
+  unsigned shift;
+
+  assert ( (u | v) > 0);
+
+  if (u =3D=3D 0)
+    return v;
+  else if (v =3D=3D 0)
+    return u;
+
+  gmp_ctz (shift, u | v);
+
+  u >>=3D shift;
+  v >>=3D shift;
+
+  if ( (u & 1) =3D=3D 0)
+    MP_LIMB_T_SWAP (u, v);
+
+  while ( (v & 1) =3D=3D 0)
+    v >>=3D 1;
+
+  while (u !=3D v)
+    {
+      if (u > v)
+	{
+	  u -=3D v;
+	  do
+	    u >>=3D 1;
+	  while ( (u & 1) =3D=3D 0);
+	}
+      else
+	{
+	  v -=3D u;
+	  do
+	    v >>=3D 1;
+	  while ( (v & 1) =3D=3D 0);
+	}
+    }
+  return u << shift;
+}
+
+unsigned long
+mpz_gcd_ui (mpz_t g, const mpz_t u, unsigned long v)
+{
+  mp_size_t un;
+
+  if (v =3D=3D 0)
+    {
+      if (g)
+	mpz_abs (g, u);
+    }
+  else
+    {
+      un =3D GMP_ABS (u->_mp_size);
+      if (un !=3D 0)
+	v =3D mpn_gcd_11 (mpn_div_qr_1 (NULL, u->_mp_d, un, v), v);
+
+      if (g)
+	mpz_set_ui (g, v);
+    }
+
+  return v;
+}
+
+static mp_bitcnt_t
+mpz_make_odd (mpz_t r)
+{
+  mp_bitcnt_t shift;
+
+  assert (r->_mp_size > 0);
+  /* Count trailing zeros, equivalent to mpn_scan1, because we know th=
at there is a 1 */
+  shift =3D mpn_common_scan (r->_mp_d[0], 0, r->_mp_d, 0, 0);
+  mpz_tdiv_q_2exp (r, r, shift);
+
+  return shift;
+}
+
+void
+mpz_gcd (mpz_t g, const mpz_t u, const mpz_t v)
+{
+  mpz_t tu, tv;
+  mp_bitcnt_t uz, vz, gz;
+
+  if (u->_mp_size =3D=3D 0)
+    {
+      mpz_abs (g, v);
+      return;
+    }
+  if (v->_mp_size =3D=3D 0)
+    {
+      mpz_abs (g, u);
+      return;
+    }
+
+  mpz_init (tu);
+  mpz_init (tv);
+
+  mpz_abs (tu, u);
+  uz =3D mpz_make_odd (tu);
+  mpz_abs (tv, v);
+  vz =3D mpz_make_odd (tv);
+  gz =3D GMP_MIN (uz, vz);
+
+  if (tu->_mp_size < tv->_mp_size)
+    mpz_swap (tu, tv);
+
+  mpz_tdiv_r (tu, tu, tv);
+  if (tu->_mp_size =3D=3D 0)
+    {
+      mpz_swap (g, tv);
+    }
+  else
+    for (;;)
+      {
+	int c;
+
+	mpz_make_odd (tu);
+	c =3D mpz_cmp (tu, tv);
+	if (c =3D=3D 0)
+	  {
+	    mpz_swap (g, tu);
+	    break;
+	  }
+	if (c < 0)
+	  mpz_swap (tu, tv);
+
+	if (tv->_mp_size =3D=3D 1)
+	  {
+	    mp_limb_t vl =3D tv->_mp_d[0];
+	    mp_limb_t ul =3D mpz_tdiv_ui (tu, vl);
+	    mpz_set_ui (g, mpn_gcd_11 (ul, vl));
+	    break;
+	  }
+	mpz_sub (tu, tu, tv);
+      }
+  mpz_clear (tu);
+  mpz_clear (tv);
+  mpz_mul_2exp (g, g, gz);
+}
+
+void
+mpz_gcdext (mpz_t g, mpz_t s, mpz_t t, const mpz_t u, const mpz_t v)
+{
+  mpz_t tu, tv, s0, s1, t0, t1;
+  mp_bitcnt_t uz, vz, gz;
+  mp_bitcnt_t power;
+
+  if (u->_mp_size =3D=3D 0)
+    {
+      /* g =3D 0 u + sgn(v) v */
+      signed long sign =3D mpz_sgn (v);
+      mpz_abs (g, v);
+      if (s)
+	mpz_set_ui (s, 0);
+      if (t)
+	mpz_set_si (t, sign);
+      return;
+    }
+
+  if (v->_mp_size =3D=3D 0)
+    {
+      /* g =3D sgn(u) u + 0 v */
+      signed long sign =3D mpz_sgn (u);
+      mpz_abs (g, u);
+      if (s)
+	mpz_set_si (s, sign);
+      if (t)
+	mpz_set_ui (t, 0);
+      return;
+    }
+
+  mpz_init (tu);
+  mpz_init (tv);
+  mpz_init (s0);
+  mpz_init (s1);
+  mpz_init (t0);
+  mpz_init (t1);
+
+  mpz_abs (tu, u);
+  uz =3D mpz_make_odd (tu);
+  mpz_abs (tv, v);
+  vz =3D mpz_make_odd (tv);
+  gz =3D GMP_MIN (uz, vz);
+
+  uz -=3D gz;
+  vz -=3D gz;
+
+  /* Cofactors corresponding to odd gcd. gz handled later. */
+  if (tu->_mp_size < tv->_mp_size)
+    {
+      mpz_swap (tu, tv);
+      MPZ_SRCPTR_SWAP (u, v);
+      MPZ_PTR_SWAP (s, t);
+      MP_BITCNT_T_SWAP (uz, vz);
+    }
+
+  /* Maintain
+   *
+   * u =3D t0 tu + t1 tv
+   * v =3D s0 tu + s1 tv
+   *
+   * where u and v denote the inputs with common factors of two
+   * eliminated, and det (s0, t0; s1, t1) =3D 2^p. Then
+   *
+   * 2^p tu =3D  s1 u - t1 v
+   * 2^p tv =3D -s0 u + t0 v
+   */
+
+  /* After initial division, tu =3D q tv + tu', we have
+   *
+   * u =3D 2^uz (tu' + q tv)
+   * v =3D 2^vz tv
+   *
+   * or
+   *
+   * t0 =3D 2^uz, t1 =3D 2^uz q
+   * s0 =3D 0,    s1 =3D 2^vz
+   */
+
+  mpz_setbit (t0, uz);
+  mpz_tdiv_qr (t1, tu, tu, tv);
+  mpz_mul_2exp (t1, t1, uz);
+
+  mpz_setbit (s1, vz);
+  power =3D uz + vz;
+
+  if (tu->_mp_size > 0)
+    {
+      mp_bitcnt_t shift;
+      shift =3D mpz_make_odd (tu);
+      mpz_mul_2exp (t0, t0, shift);
+      mpz_mul_2exp (s0, s0, shift);
+      power +=3D shift;
+
+      for (;;)
+	{
+	  int c;
+	  c =3D mpz_cmp (tu, tv);
+	  if (c =3D=3D 0)
+	    break;
+
+	  if (c < 0)
+	    {
+	      /* tv =3D tv' + tu
+	       *
+	       * u =3D t0 tu + t1 (tv' + tu) =3D (t0 + t1) tu + t1 tv'
+	       * v =3D s0 tu + s1 (tv' + tu) =3D (s0 + s1) tu + s1 tv' */
+
+	      mpz_sub (tv, tv, tu);
+	      mpz_add (t0, t0, t1);
+	      mpz_add (s0, s0, s1);
+
+	      shift =3D mpz_make_odd (tv);
+	      mpz_mul_2exp (t1, t1, shift);
+	      mpz_mul_2exp (s1, s1, shift);
+	    }
+	  else
+	    {
+	      mpz_sub (tu, tu, tv);
+	      mpz_add (t1, t0, t1);
+	      mpz_add (s1, s0, s1);
+
+	      shift =3D mpz_make_odd (tu);
+	      mpz_mul_2exp (t0, t0, shift);
+	      mpz_mul_2exp (s0, s0, shift);
+	    }
+	  power +=3D shift;
+	}
+    }
+
+  /* Now tv =3D odd part of gcd, and -s0 and t0 are corresponding
+     cofactors. */
+
+  mpz_mul_2exp (tv, tv, gz);
+  mpz_neg (s0, s0);
+
+  /* 2^p g =3D s0 u + t0 v. Eliminate one factor of two at a time. To
+     adjust cofactors, we need u / g and v / g */
+
+  mpz_divexact (s1, v, tv);
+  mpz_abs (s1, s1);
+  mpz_divexact (t1, u, tv);
+  mpz_abs (t1, t1);
+
+  while (power-- > 0)
+    {
+      /* s0 u + t0 v =3D (s0 - v/g) u - (t0 + u/g) v */
+      if (mpz_odd_p (s0) || mpz_odd_p (t0))
+	{
+	  mpz_sub (s0, s0, s1);
+	  mpz_add (t0, t0, t1);
+	}
+      mpz_divexact_ui (s0, s0, 2);
+      mpz_divexact_ui (t0, t0, 2);
+    }
+
+  /* Arrange so that |s| < |u| / 2g */
+  mpz_add (s1, s0, s1);
+  if (mpz_cmpabs (s0, s1) > 0)
+    {
+      mpz_swap (s0, s1);
+      mpz_sub (t0, t0, t1);
+    }
+  if (u->_mp_size < 0)
+    mpz_neg (s0, s0);
+  if (v->_mp_size < 0)
+    mpz_neg (t0, t0);
+
+  mpz_swap (g, tv);
+  if (s)
+    mpz_swap (s, s0);
+  if (t)
+    mpz_swap (t, t0);
+
+  mpz_clear (tu);
+  mpz_clear (tv);
+  mpz_clear (s0);
+  mpz_clear (s1);
+  mpz_clear (t0);
+  mpz_clear (t1);
+}
+
+void
+mpz_lcm (mpz_t r, const mpz_t u, const mpz_t v)
+{
+  mpz_t g;
+
+  if (u->_mp_size =3D=3D 0 || v->_mp_size =3D=3D 0)
+    {
+      r->_mp_size =3D 0;
+      return;
+    }
+
+  mpz_init (g);
+
+  mpz_gcd (g, u, v);
+  mpz_divexact (g, u, g);
+  mpz_mul (r, g, v);
+
+  mpz_clear (g);
+  mpz_abs (r, r);
+}
+
+void
+mpz_lcm_ui (mpz_t r, const mpz_t u, unsigned long v)
+{
+  if (v =3D=3D 0 || u->_mp_size =3D=3D 0)
+    {
+      r->_mp_size =3D 0;
+      return;
+    }
+
+  v /=3D mpz_gcd_ui (NULL, u, v);
+  mpz_mul_ui (r, u, v);
+
+  mpz_abs (r, r);
+}
+
+int
+mpz_invert (mpz_t r, const mpz_t u, const mpz_t m)
+{
+  mpz_t g, tr;
+  int invertible;
+
+  if (u->_mp_size =3D=3D 0 || mpz_cmpabs_ui (m, 1) <=3D 0)
+    return 0;
+
+  mpz_init (g);
+  mpz_init (tr);
+
+  mpz_gcdext (g, tr, NULL, u, m);
+  invertible =3D (mpz_cmp_ui (g, 1) =3D=3D 0);
+
+  if (invertible)
+    {
+      if (tr->_mp_size < 0)
+	{
+	  if (m->_mp_size >=3D 0)
+	    mpz_add (tr, tr, m);
+	  else
+	    mpz_sub (tr, tr, m);
+	}
+      mpz_swap (r, tr);
+    }
+
+  mpz_clear (g);
+  mpz_clear (tr);
+  return invertible;
+}
+
+=0C
+/* Higher level operations (sqrt, pow and root) */
+
+void
+mpz_pow_ui (mpz_t r, const mpz_t b, unsigned long e)
+{
+  unsigned long bit;
+  mpz_t tr;
+  mpz_init_set_ui (tr, 1);
+
+  bit =3D GMP_ULONG_HIGHBIT;
+  do
+    {
+      mpz_mul (tr, tr, tr);
+      if (e & bit)
+	mpz_mul (tr, tr, b);
+      bit >>=3D 1;
+    }
+  while (bit > 0);
+
+  mpz_swap (r, tr);
+  mpz_clear (tr);
+}
+
+void
+mpz_ui_pow_ui (mpz_t r, unsigned long blimb, unsigned long e)
+{
+  mpz_t b;
+  mpz_init_set_ui (b, blimb);
+  mpz_pow_ui (r, b, e);
+  mpz_clear (b);
+}
+
+void
+mpz_powm (mpz_t r, const mpz_t b, const mpz_t e, const mpz_t m)
+{
+  mpz_t tr;
+  mpz_t base;
+  mp_size_t en, mn;
+  mp_srcptr mp;
+  struct gmp_div_inverse minv;
+  unsigned shift;
+  mp_ptr tp =3D NULL;
+
+  en =3D GMP_ABS (e->_mp_size);
+  mn =3D GMP_ABS (m->_mp_size);
+  if (mn =3D=3D 0)
+    gmp_die ("mpz_powm: Zero modulo.");
+
+  if (en =3D=3D 0)
+    {
+      mpz_set_ui (r, 1);
+      return;
+    }
+
+  mp =3D m->_mp_d;
+  mpn_div_qr_invert (&minv, mp, mn);
+  shift =3D minv.shift;
+
+  if (shift > 0)
+    {
+      /* To avoid shifts, we do all our reductions, except the final
+	 one, using a *normalized* m. */
+      minv.shift =3D 0;
+
+      tp =3D gmp_xalloc_limbs (mn);
+      gmp_assert_nocarry (mpn_lshift (tp, mp, mn, shift));
+      mp =3D tp;
+    }
+
+  mpz_init (base);
+
+  if (e->_mp_size < 0)
+    {
+      if (!mpz_invert (base, b, m))
+	gmp_die ("mpz_powm: Negative exponent and non-invertible base.");
+    }
+  else
+    {
+      mp_size_t bn;
+      mpz_abs (base, b);
+
+      bn =3D base->_mp_size;
+      if (bn >=3D mn)
+	{
+	  mpn_div_qr_preinv (NULL, base->_mp_d, base->_mp_size, mp, mn, &minv=
);
+	  bn =3D mn;
+	}
+
+      /* We have reduced the absolute value. Now take care of the
+	 sign. Note that we get zero represented non-canonically as
+	 m. */
+      if (b->_mp_size < 0)
+	{
+	  mp_ptr bp =3D MPZ_REALLOC (base, mn);
+	  gmp_assert_nocarry (mpn_sub (bp, mp, mn, bp, bn));
+	  bn =3D mn;
+	}
+      base->_mp_size =3D mpn_normalized_size (base->_mp_d, bn);
+    }
+  mpz_init_set_ui (tr, 1);
+
+  while (en-- > 0)
+    {
+      mp_limb_t w =3D e->_mp_d[en];
+      mp_limb_t bit;
+
+      bit =3D GMP_LIMB_HIGHBIT;
+      do
+	{
+	  mpz_mul (tr, tr, tr);
+	  if (w & bit)
+	    mpz_mul (tr, tr, base);
+	  if (tr->_mp_size > mn)
+	    {
+	      mpn_div_qr_preinv (NULL, tr->_mp_d, tr->_mp_size, mp, mn, &minv=
);
+	      tr->_mp_size =3D mpn_normalized_size (tr->_mp_d, mn);
+	    }
+	  bit >>=3D 1;
+	}
+      while (bit > 0);
+    }
+
+  /* Final reduction */
+  if (tr->_mp_size >=3D mn)
+    {
+      minv.shift =3D shift;
+      mpn_div_qr_preinv (NULL, tr->_mp_d, tr->_mp_size, mp, mn, &minv)=
;
+      tr->_mp_size =3D mpn_normalized_size (tr->_mp_d, mn);
+    }
+  if (tp)
+    gmp_free (tp);
+
+  mpz_swap (r, tr);
+  mpz_clear (tr);
+  mpz_clear (base);
+}
+
+void
+mpz_powm_ui (mpz_t r, const mpz_t b, unsigned long elimb, const mpz_t =
m)
+{
+  mpz_t e;
+  mpz_init_set_ui (e, elimb);
+  mpz_powm (r, b, e, m);
+  mpz_clear (e);
+}
+
+/* x=3Dtrunc(y^(1/z)), r=3Dy-x^z */
+void
+mpz_rootrem (mpz_t x, mpz_t r, const mpz_t y, unsigned long z)
+{
+  int sgn;
+  mpz_t t, u;
+
+  sgn =3D y->_mp_size < 0;
+  if ((~z & sgn) !=3D 0)
+    gmp_die ("mpz_rootrem: Negative argument, with even root.");
+  if (z =3D=3D 0)
+    gmp_die ("mpz_rootrem: Zeroth root.");
+
+  if (mpz_cmpabs_ui (y, 1) <=3D 0) {
+    if (x)
+      mpz_set (x, y);
+    if (r)
+      r->_mp_size =3D 0;
+    return;
+  }
+
+  mpz_init (u);
+  {
+    mp_bitcnt_t tb;
+    tb =3D mpz_sizeinbase (y, 2) / z + 1;
+    mpz_init2 (t, tb);
+    mpz_setbit (t, tb);
+  }
+
+  if (z =3D=3D 2) /* simplify sqrt loop: z-1 =3D=3D 1 */
+    do {
+      mpz_swap (u, t);			/* u =3D x */
+      mpz_tdiv_q (t, y, u);		/* t =3D y/x */
+      mpz_add (t, t, u);		/* t =3D y/x + x */
+      mpz_tdiv_q_2exp (t, t, 1);	/* x'=3D (y/x + x)/2 */
+    } while (mpz_cmpabs (t, u) < 0);	/* |x'| < |x| */
+  else /* z !=3D 2 */ {
+    mpz_t v;
+
+    mpz_init (v);
+    if (sgn)
+      mpz_neg (t, t);
+
+    do {
+      mpz_swap (u, t);			/* u =3D x */
+      mpz_pow_ui (t, u, z - 1);		/* t =3D x^(z-1) */
+      mpz_tdiv_q (t, y, t);		/* t =3D y/x^(z-1) */
+      mpz_mul_ui (v, u, z - 1);		/* v =3D x*(z-1) */
+      mpz_add (t, t, v);		/* t =3D y/x^(z-1) + x*(z-1) */
+      mpz_tdiv_q_ui (t, t, z);		/* x'=3D(y/x^(z-1) + x*(z-1))/z */
+    } while (mpz_cmpabs (t, u) < 0);	/* |x'| < |x| */
+
+    mpz_clear (v);
+  }
+
+  if (r) {
+    mpz_pow_ui (t, u, z);
+    mpz_sub (r, y, t);
+  }
+  if (x)
+    mpz_swap (x, u);
+  mpz_clear (u);
+  mpz_clear (t);
+}
+
+int
+mpz_root (mpz_t x, const mpz_t y, unsigned long z)
+{
+  int res;
+  mpz_t r;
+
+  mpz_init (r);
+  mpz_rootrem (x, r, y, z);
+  res =3D r->_mp_size =3D=3D 0;
+  mpz_clear (r);
+
+  return res;
+}
+
+/* Compute s =3D floor(sqrt(u)) and r =3D u - s^2. Allows r =3D=3D NUL=
L */
+void
+mpz_sqrtrem (mpz_t s, mpz_t r, const mpz_t u)
+{
+  mpz_rootrem (s, r, u, 2);
+}
+
+void
+mpz_sqrt (mpz_t s, const mpz_t u)
+{
+  mpz_rootrem (s, NULL, u, 2);
+}
+
+int
+mpz_perfect_square_p (const mpz_t u)
+{
+  if (u->_mp_size <=3D 0)
+    return (u->_mp_size =3D=3D 0);
+  else
+    return mpz_root (NULL, u, 2);
+}
+
+int
+mpn_perfect_square_p (mp_srcptr p, mp_size_t n)
+{
+  mpz_t t;
+
+  assert (n > 0);
+  assert (p [n-1] !=3D 0);
+  return mpz_root (NULL, mpz_roinit_n (t, p, n), 2);
+}
+
+mp_size_t
+mpn_sqrtrem (mp_ptr sp, mp_ptr rp, mp_srcptr p, mp_size_t n)
+{
+  mpz_t s, r, u;
+  mp_size_t res;
+
+  assert (n > 0);
+  assert (p [n-1] !=3D 0);
+
+  mpz_init (r);
+  mpz_init (s);
+  mpz_rootrem (s, r, mpz_roinit_n (u, p, n), 2);
+
+  assert (s->_mp_size =3D=3D (n+1)/2);
+  mpn_copyd (sp, s->_mp_d, s->_mp_size);
+  mpz_clear (s);
+  res =3D r->_mp_size;
+  if (rp)
+    mpn_copyd (rp, r->_mp_d, res);
+  mpz_clear (r);
+  return res;
+}
+=0C
+/* Combinatorics */
+
+void
+mpz_fac_ui (mpz_t x, unsigned long n)
+{
+  mpz_set_ui (x, n + (n =3D=3D 0));
+  for (;n > 2;)
+    mpz_mul_ui (x, x, --n);
+}
+
+void
+mpz_bin_uiui (mpz_t r, unsigned long n, unsigned long k)
+{
+  mpz_t t;
+
+  mpz_set_ui (r, k <=3D n);
+
+  if (k > (n >> 1))
+    k =3D (k <=3D n) ? n - k : 0;
+
+  mpz_init (t);
+  mpz_fac_ui (t, k);
+
+  for (; k > 0; k--)
+      mpz_mul_ui (r, r, n--);
+
+  mpz_divexact (r, r, t);
+  mpz_clear (t);
+}
+
+=0C
+/* Primality testing */
+static int
+gmp_millerrabin (const mpz_t n, const mpz_t nm1, mpz_t y,
+		 const mpz_t q, mp_bitcnt_t k)
+{
+  assert (k > 0);
+
+  /* Caller must initialize y to the base. */
+  mpz_powm (y, y, q, n);
+
+  if (mpz_cmp_ui (y, 1) =3D=3D 0 || mpz_cmp (y, nm1) =3D=3D 0)
+    return 1;
+
+  while (--k > 0)
+    {
+      mpz_powm_ui (y, y, 2, n);
+      if (mpz_cmp (y, nm1) =3D=3D 0)
+	return 1;
+      /* y =3D=3D 1 means that the previous y was a non-trivial square=
 root
+	 of 1 (mod n). y =3D=3D 0 means that n is a power of the base.
+	 In either case, n is not prime. */
+      if (mpz_cmp_ui (y, 1) <=3D 0)
+	return 0;
+    }
+  return 0;
+}
+
+/* This product is 0xc0cfd797, and fits in 32 bits. */
+#define GMP_PRIME_PRODUCT \
+  (3UL*5UL*7UL*11UL*13UL*17UL*19UL*23UL*29UL)
+
+/* Bit (p+1)/2 is set, for each odd prime <=3D 61 */
+#define GMP_PRIME_MASK 0xc96996dcUL
+
+int
+mpz_probab_prime_p (const mpz_t n, int reps)
+{
+  mpz_t nm1;
+  mpz_t q;
+  mpz_t y;
+  mp_bitcnt_t k;
+  int is_prime;
+  int j;
+
+  /* Note that we use the absolute value of n only, for compatibility
+     with the real GMP. */
+  if (mpz_even_p (n))
+    return (mpz_cmpabs_ui (n, 2) =3D=3D 0) ? 2 : 0;
+
+  /* Above test excludes n =3D=3D 0 */
+  assert (n->_mp_size !=3D 0);
+
+  if (mpz_cmpabs_ui (n, 64) < 0)
+    return (GMP_PRIME_MASK >> (n->_mp_d[0] >> 1)) & 2;
+
+  if (mpz_gcd_ui (NULL, n, GMP_PRIME_PRODUCT) !=3D 1)
+    return 0;
+
+  /* All prime factors are >=3D 31. */
+  if (mpz_cmpabs_ui (n, 31*31) < 0)
+    return 2;
+
+  /* Use Miller-Rabin, with a deterministic sequence of bases, a[j] =3D
+     j^2 + j + 41 using Euler's polynomial. We potentially stop early,
+     if a[j] >=3D n - 1. Since n >=3D 31*31, this can happen only if r=
eps >
+     30 (a[30] =3D=3D 971 > 31*31 =3D=3D 961). */
+
+  mpz_init (nm1);
+  mpz_init (q);
+  mpz_init (y);
+
+  /* Find q and k, where q is odd and n =3D 1 + 2**k * q.  */
+  nm1->_mp_size =3D mpz_abs_sub_ui (nm1, n, 1);
+  k =3D mpz_scan1 (nm1, 0);
+  mpz_tdiv_q_2exp (q, nm1, k);
+
+  for (j =3D 0, is_prime =3D 1; is_prime & (j < reps); j++)
+    {
+      mpz_set_ui (y, (unsigned long) j*j+j+41);
+      if (mpz_cmp (y, nm1) >=3D 0)
+	{
+	  /* Don't try any further bases. This "early" break does not affect
+	     the result for any reasonable reps value (<=3D5000 was tested) *=
/
+	  assert (j >=3D 30);
+	  break;
+	}
+      is_prime =3D gmp_millerrabin (n, nm1, y, q, k);
+    }
+  mpz_clear (nm1);
+  mpz_clear (q);
+  mpz_clear (y);
+
+  return is_prime;
+}
+
+=0C
+/* Logical operations and bit manipulation. */
+
+/* Numbers are treated as if represented in two's complement (and
+   infinitely sign extended). For a negative values we get the two's
+   complement from -x =3D ~x + 1, where ~ is bitwise complement.
+   Negation transforms
+
+     xxxx10...0
+
+   into
+
+     yyyy10...0
+
+   where yyyy is the bitwise complement of xxxx. So least significant
+   bits, up to and including the first one bit, are unchanged, and
+   the more significant bits are all complemented.
+
+   To change a bit from zero to one in a negative number, subtract the
+   corresponding power of two from the absolute value. This can never
+   underflow. To change a bit from one to zero, add the corresponding
+   power of two, and this might overflow. E.g., if x =3D -001111, the
+   two's complement is 110001. Clearing the least significant bit, we
+   get two's complement 110000, and -010000. */
+
+int
+mpz_tstbit (const mpz_t d, mp_bitcnt_t bit_index)
+{
+  mp_size_t limb_index;
+  unsigned shift;
+  mp_size_t ds;
+  mp_size_t dn;
+  mp_limb_t w;
+  int bit;
+
+  ds =3D d->_mp_size;
+  dn =3D GMP_ABS (ds);
+  limb_index =3D bit_index / GMP_LIMB_BITS;
+  if (limb_index >=3D dn)
+    return ds < 0;
+
+  shift =3D bit_index % GMP_LIMB_BITS;
+  w =3D d->_mp_d[limb_index];
+  bit =3D (w >> shift) & 1;
+
+  if (ds < 0)
+    {
+      /* d < 0. Check if any of the bits below is set: If so, our bit
+	 must be complemented. */
+      if (shift > 0 && (w << (GMP_LIMB_BITS - shift)) > 0)
+	return bit ^ 1;
+      while (limb_index-- > 0)
+	if (d->_mp_d[limb_index] > 0)
+	  return bit ^ 1;
+    }
+  return bit;
+}
+
+static void
+mpz_abs_add_bit (mpz_t d, mp_bitcnt_t bit_index)
+{
+  mp_size_t dn, limb_index;
+  mp_limb_t bit;
+  mp_ptr dp;
+
+  dn =3D GMP_ABS (d->_mp_size);
+
+  limb_index =3D bit_index / GMP_LIMB_BITS;
+  bit =3D (mp_limb_t) 1 << (bit_index % GMP_LIMB_BITS);
+
+  if (limb_index >=3D dn)
+    {
+      mp_size_t i;
+      /* The bit should be set outside of the end of the number.
+	 We have to increase the size of the number. */
+      dp =3D MPZ_REALLOC (d, limb_index + 1);
+
+      dp[limb_index] =3D bit;
+      for (i =3D dn; i < limb_index; i++)
+	dp[i] =3D 0;
+      dn =3D limb_index + 1;
+    }
+  else
+    {
+      mp_limb_t cy;
+
+      dp =3D d->_mp_d;
+
+      cy =3D mpn_add_1 (dp + limb_index, dp + limb_index, dn - limb_in=
dex, bit);
+      if (cy > 0)
+	{
+	  dp =3D MPZ_REALLOC (d, dn + 1);
+	  dp[dn++] =3D cy;
+	}
+    }
+
+  d->_mp_size =3D (d->_mp_size < 0) ? - dn : dn;
+}
+
+static void
+mpz_abs_sub_bit (mpz_t d, mp_bitcnt_t bit_index)
+{
+  mp_size_t dn, limb_index;
+  mp_ptr dp;
+  mp_limb_t bit;
+
+  dn =3D GMP_ABS (d->_mp_size);
+  dp =3D d->_mp_d;
+
+  limb_index =3D bit_index / GMP_LIMB_BITS;
+  bit =3D (mp_limb_t) 1 << (bit_index % GMP_LIMB_BITS);
+
+  assert (limb_index < dn);
+
+  gmp_assert_nocarry (mpn_sub_1 (dp + limb_index, dp + limb_index,
+				 dn - limb_index, bit));
+  dn =3D mpn_normalized_size (dp, dn);
+  d->_mp_size =3D (d->_mp_size < 0) ? - dn : dn;
+}
+
+void
+mpz_setbit (mpz_t d, mp_bitcnt_t bit_index)
+{
+  if (!mpz_tstbit (d, bit_index))
+    {
+      if (d->_mp_size >=3D 0)
+	mpz_abs_add_bit (d, bit_index);
+      else
+	mpz_abs_sub_bit (d, bit_index);
+    }
+}
+
+void
+mpz_clrbit (mpz_t d, mp_bitcnt_t bit_index)
+{
+  if (mpz_tstbit (d, bit_index))
+    {
+      if (d->_mp_size >=3D 0)
+	mpz_abs_sub_bit (d, bit_index);
+      else
+	mpz_abs_add_bit (d, bit_index);
+    }
+}
+
+void
+mpz_combit (mpz_t d, mp_bitcnt_t bit_index)
+{
+  if (mpz_tstbit (d, bit_index) ^ (d->_mp_size < 0))
+    mpz_abs_sub_bit (d, bit_index);
+  else
+    mpz_abs_add_bit (d, bit_index);
+}
+
+void
+mpz_com (mpz_t r, const mpz_t u)
+{
+  mpz_neg (r, u);
+  mpz_sub_ui (r, r, 1);
+}
+
+void
+mpz_and (mpz_t r, const mpz_t u, const mpz_t v)
+{
+  mp_size_t un, vn, rn, i;
+  mp_ptr up, vp, rp;
+
+  mp_limb_t ux, vx, rx;
+  mp_limb_t uc, vc, rc;
+  mp_limb_t ul, vl, rl;
+
+  un =3D GMP_ABS (u->_mp_size);
+  vn =3D GMP_ABS (v->_mp_size);
+  if (un < vn)
+    {
+      MPZ_SRCPTR_SWAP (u, v);
+      MP_SIZE_T_SWAP (un, vn);
+    }
+  if (vn =3D=3D 0)
+    {
+      r->_mp_size =3D 0;
+      return;
+    }
+
+  uc =3D u->_mp_size < 0;
+  vc =3D v->_mp_size < 0;
+  rc =3D uc & vc;
+
+  ux =3D -uc;
+  vx =3D -vc;
+  rx =3D -rc;
+
+  /* If the smaller input is positive, higher limbs don't matter. */
+  rn =3D vx ? un : vn;
+
+  rp =3D MPZ_REALLOC (r, rn + rc);
+
+  up =3D u->_mp_d;
+  vp =3D v->_mp_d;
+
+  i =3D 0;
+  do
+    {
+      ul =3D (up[i] ^ ux) + uc;
+      uc =3D ul < uc;
+
+      vl =3D (vp[i] ^ vx) + vc;
+      vc =3D vl < vc;
+
+      rl =3D ( (ul & vl) ^ rx) + rc;
+      rc =3D rl < rc;
+      rp[i] =3D rl;
+    }
+  while (++i < vn);
+  assert (vc =3D=3D 0);
+
+  for (; i < rn; i++)
+    {
+      ul =3D (up[i] ^ ux) + uc;
+      uc =3D ul < uc;
+
+      rl =3D ( (ul & vx) ^ rx) + rc;
+      rc =3D rl < rc;
+      rp[i] =3D rl;
+    }
+  if (rc)
+    rp[rn++] =3D rc;
+  else
+    rn =3D mpn_normalized_size (rp, rn);
+
+  r->_mp_size =3D rx ? -rn : rn;
+}
+
+void
+mpz_ior (mpz_t r, const mpz_t u, const mpz_t v)
+{
+  mp_size_t un, vn, rn, i;
+  mp_ptr up, vp, rp;
+
+  mp_limb_t ux, vx, rx;
+  mp_limb_t uc, vc, rc;
+  mp_limb_t ul, vl, rl;
+
+  un =3D GMP_ABS (u->_mp_size);
+  vn =3D GMP_ABS (v->_mp_size);
+  if (un < vn)
+    {
+      MPZ_SRCPTR_SWAP (u, v);
+      MP_SIZE_T_SWAP (un, vn);
+    }
+  if (vn =3D=3D 0)
+    {
+      mpz_set (r, u);
+      return;
+    }
+
+  uc =3D u->_mp_size < 0;
+  vc =3D v->_mp_size < 0;
+  rc =3D uc | vc;
+
+  ux =3D -uc;
+  vx =3D -vc;
+  rx =3D -rc;
+
+  /* If the smaller input is negative, by sign extension higher limbs
+     don't matter. */
+  rn =3D vx ? vn : un;
+
+  rp =3D MPZ_REALLOC (r, rn + rc);
+
+  up =3D u->_mp_d;
+  vp =3D v->_mp_d;
+
+  i =3D 0;
+  do
+    {
+      ul =3D (up[i] ^ ux) + uc;
+      uc =3D ul < uc;
+
+      vl =3D (vp[i] ^ vx) + vc;
+      vc =3D vl < vc;
+
+      rl =3D ( (ul | vl) ^ rx) + rc;
+      rc =3D rl < rc;
+      rp[i] =3D rl;
+    }
+  while (++i < vn);
+  assert (vc =3D=3D 0);
+
+  for (; i < rn; i++)
+    {
+      ul =3D (up[i] ^ ux) + uc;
+      uc =3D ul < uc;
+
+      rl =3D ( (ul | vx) ^ rx) + rc;
+      rc =3D rl < rc;
+      rp[i] =3D rl;
+    }
+  if (rc)
+    rp[rn++] =3D rc;
+  else
+    rn =3D mpn_normalized_size (rp, rn);
+
+  r->_mp_size =3D rx ? -rn : rn;
+}
+
+void
+mpz_xor (mpz_t r, const mpz_t u, const mpz_t v)
+{
+  mp_size_t un, vn, i;
+  mp_ptr up, vp, rp;
+
+  mp_limb_t ux, vx, rx;
+  mp_limb_t uc, vc, rc;
+  mp_limb_t ul, vl, rl;
+
+  un =3D GMP_ABS (u->_mp_size);
+  vn =3D GMP_ABS (v->_mp_size);
+  if (un < vn)
+    {
+      MPZ_SRCPTR_SWAP (u, v);
+      MP_SIZE_T_SWAP (un, vn);
+    }
+  if (vn =3D=3D 0)
+    {
+      mpz_set (r, u);
+      return;
+    }
+
+  uc =3D u->_mp_size < 0;
+  vc =3D v->_mp_size < 0;
+  rc =3D uc ^ vc;
+
+  ux =3D -uc;
+  vx =3D -vc;
+  rx =3D -rc;
+
+  rp =3D MPZ_REALLOC (r, un + rc);
+
+  up =3D u->_mp_d;
+  vp =3D v->_mp_d;
+
+  i =3D 0;
+  do
+    {
+      ul =3D (up[i] ^ ux) + uc;
+      uc =3D ul < uc;
+
+      vl =3D (vp[i] ^ vx) + vc;
+      vc =3D vl < vc;
+
+      rl =3D (ul ^ vl ^ rx) + rc;
+      rc =3D rl < rc;
+      rp[i] =3D rl;
+    }
+  while (++i < vn);
+  assert (vc =3D=3D 0);
+
+  for (; i < un; i++)
+    {
+      ul =3D (up[i] ^ ux) + uc;
+      uc =3D ul < uc;
+
+      rl =3D (ul ^ ux) + rc;
+      rc =3D rl < rc;
+      rp[i] =3D rl;
+    }
+  if (rc)
+    rp[un++] =3D rc;
+  else
+    un =3D mpn_normalized_size (rp, un);
+
+  r->_mp_size =3D rx ? -un : un;
+}
+
+static unsigned
+gmp_popcount_limb (mp_limb_t x)
+{
+  unsigned c;
+
+  /* Do 16 bits at a time, to avoid limb-sized constants. */
+  for (c =3D 0; x > 0; x >>=3D 16)
+    {
+      unsigned w =3D ((x >> 1) & 0x5555) + (x & 0x5555);
+      w =3D ((w >> 2) & 0x3333) + (w & 0x3333);
+      w =3D ((w >> 4) & 0x0f0f) + (w & 0x0f0f);
+      w =3D (w >> 8) + (w & 0x00ff);
+      c +=3D w;
+    }
+  return c;
+}
+
+mp_bitcnt_t
+mpn_popcount (mp_srcptr p, mp_size_t n)
+{
+  mp_size_t i;
+  mp_bitcnt_t c;
+
+  for (c =3D 0, i =3D 0; i < n; i++)
+    c +=3D gmp_popcount_limb (p[i]);
+
+  return c;
+}
+
+mp_bitcnt_t
+mpz_popcount (const mpz_t u)
+{
+  mp_size_t un;
+
+  un =3D u->_mp_size;
+
+  if (un < 0)
+    return ~(mp_bitcnt_t) 0;
+
+  return mpn_popcount (u->_mp_d, un);
+}
+
+mp_bitcnt_t
+mpz_hamdist (const mpz_t u, const mpz_t v)
+{
+  mp_size_t un, vn, i;
+  mp_limb_t uc, vc, ul, vl, comp;
+  mp_srcptr up, vp;
+  mp_bitcnt_t c;
+
+  un =3D u->_mp_size;
+  vn =3D v->_mp_size;
+
+  if ( (un ^ vn) < 0)
+    return ~(mp_bitcnt_t) 0;
+
+  comp =3D - (uc =3D vc =3D (un < 0));
+  if (uc)
+    {
+      assert (vn < 0);
+      un =3D -un;
+      vn =3D -vn;
+    }
+
+  up =3D u->_mp_d;
+  vp =3D v->_mp_d;
+
+  if (un < vn)
+    MPN_SRCPTR_SWAP (up, un, vp, vn);
+
+  for (i =3D 0, c =3D 0; i < vn; i++)
+    {
+      ul =3D (up[i] ^ comp) + uc;
+      uc =3D ul < uc;
+
+      vl =3D (vp[i] ^ comp) + vc;
+      vc =3D vl < vc;
+
+      c +=3D gmp_popcount_limb (ul ^ vl);
+    }
+  assert (vc =3D=3D 0);
+
+  for (; i < un; i++)
+    {
+      ul =3D (up[i] ^ comp) + uc;
+      uc =3D ul < uc;
+
+      c +=3D gmp_popcount_limb (ul ^ comp);
+    }
+
+  return c;
+}
+
+mp_bitcnt_t
+mpz_scan1 (const mpz_t u, mp_bitcnt_t starting_bit)
+{
+  mp_ptr up;
+  mp_size_t us, un, i;
+  mp_limb_t limb, ux;
+
+  us =3D u->_mp_size;
+  un =3D GMP_ABS (us);
+  i =3D starting_bit / GMP_LIMB_BITS;
+
+  /* Past the end there's no 1 bits for u>=3D0, or an immediate 1 bit
+     for u<0. Notice this test picks up any u=3D=3D0 too. */
+  if (i >=3D un)
+    return (us >=3D 0 ? ~(mp_bitcnt_t) 0 : starting_bit);
+
+  up =3D u->_mp_d;
+  ux =3D 0;
+  limb =3D up[i];
+
+  if (starting_bit !=3D 0)
+    {
+      if (us < 0)
+	{
+	  ux =3D mpn_zero_p (up, i);
+	  limb =3D ~ limb + ux;
+	  ux =3D - (mp_limb_t) (limb >=3D ux);
+	}
+
+      /* Mask to 0 all bits before starting_bit, thus ignoring them. *=
/
+      limb &=3D (GMP_LIMB_MAX << (starting_bit % GMP_LIMB_BITS));
+    }
+
+  return mpn_common_scan (limb, i, up, un, ux);
+}
+
+mp_bitcnt_t
+mpz_scan0 (const mpz_t u, mp_bitcnt_t starting_bit)
+{
+  mp_ptr up;
+  mp_size_t us, un, i;
+  mp_limb_t limb, ux;
+
+  us =3D u->_mp_size;
+  ux =3D - (mp_limb_t) (us >=3D 0);
+  un =3D GMP_ABS (us);
+  i =3D starting_bit / GMP_LIMB_BITS;
+
+  /* When past end, there's an immediate 0 bit for u>=3D0, or no 0 bit=
s for
+     u<0.  Notice this test picks up all cases of u=3D=3D0 too. */
+  if (i >=3D un)
+    return (ux ? starting_bit : ~(mp_bitcnt_t) 0);
+
+  up =3D u->_mp_d;
+  limb =3D up[i] ^ ux;
+
+  if (ux =3D=3D 0)
+    limb -=3D mpn_zero_p (up, i); /* limb =3D ~(~limb + zero_p) */
+
+  /* Mask all bits before starting_bit, thus ignoring them. */
+  limb &=3D (GMP_LIMB_MAX << (starting_bit % GMP_LIMB_BITS));
+
+  return mpn_common_scan (limb, i, up, un, ux);
+}
+
+=0C
+/* MPZ base conversion. */
+
+size_t
+mpz_sizeinbase (const mpz_t u, int base)
+{
+  mp_size_t un;
+  mp_srcptr up;
+  mp_ptr tp;
+  mp_bitcnt_t bits;
+  struct gmp_div_inverse bi;
+  size_t ndigits;
+
+  assert (base >=3D 2);
+  assert (base <=3D 36);
+
+  un =3D GMP_ABS (u->_mp_size);
+  if (un =3D=3D 0)
+    return 1;
+
+  up =3D u->_mp_d;
+
+  bits =3D (un - 1) * GMP_LIMB_BITS + mpn_limb_size_in_base_2 (up[un-1=
]);
+  switch (base)
+    {
+    case 2:
+      return bits;
+    case 4:
+      return (bits + 1) / 2;
+    case 8:
+      return (bits + 2) / 3;
+    case 16:
+      return (bits + 3) / 4;
+    case 32:
+      return (bits + 4) / 5;
+      /* FIXME: Do something more clever for the common case of base
+	 10. */
+    }
+
+  tp =3D gmp_xalloc_limbs (un);
+  mpn_copyi (tp, up, un);
+  mpn_div_qr_1_invert (&bi, base);
+
+  ndigits =3D 0;
+  do
+    {
+      ndigits++;
+      mpn_div_qr_1_preinv (tp, tp, un, &bi);
+      un -=3D (tp[un-1] =3D=3D 0);
+    }
+  while (un > 0);
+
+  gmp_free (tp);
+  return ndigits;
+}
+
+char *
+mpz_get_str (char *sp, int base, const mpz_t u)
+{
+  unsigned bits;
+  const char *digits;
+  mp_size_t un;
+  size_t i, sn;
+
+  if (base >=3D 0)
+    {
+      digits =3D "0123456789abcdefghijklmnopqrstuvwxyz";
+    }
+  else
+    {
+      base =3D -base;
+      digits =3D "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
+    }
+  if (base <=3D 1)
+    base =3D 10;
+  if (base > 36)
+    return NULL;
+
+  sn =3D 1 + mpz_sizeinbase (u, base);
+  if (!sp)
+    sp =3D gmp_xalloc (1 + sn);
+
+  un =3D GMP_ABS (u->_mp_size);
+
+  if (un =3D=3D 0)
+    {
+      sp[0] =3D '0';
+      sp[1] =3D '\0';
+      return sp;
+    }
+
+  i =3D 0;
+
+  if (u->_mp_size < 0)
+    sp[i++] =3D '-';
+
+  bits =3D mpn_base_power_of_two_p (base);
+
+  if (bits)
+    /* Not modified in this case. */
+    sn =3D i + mpn_get_str_bits ((unsigned char *) sp + i, bits, u->_m=
p_d, un);
+  else
+    {
+      struct mpn_base_info info;
+      mp_ptr tp;
+
+      mpn_get_base_info (&info, base);
+      tp =3D gmp_xalloc_limbs (un);
+      mpn_copyi (tp, u->_mp_d, un);
+
+      sn =3D i + mpn_get_str_other ((unsigned char *) sp + i, base, &i=
nfo, tp, un);
+      gmp_free (tp);
+    }
+
+  for (; i < sn; i++)
+    sp[i] =3D digits[(unsigned char) sp[i]];
+
+  sp[sn] =3D '\0';
+  return sp;
+}
+
+int
+mpz_set_str (mpz_t r, const char *sp, int base)
+{
+  unsigned bits;
+  mp_size_t rn, alloc;
+  mp_ptr rp;
+  size_t sn;
+  int sign;
+  unsigned char *dp;
+
+  assert (base =3D=3D 0 || (base >=3D 2 && base <=3D 36));
+
+  while (isspace( (unsigned char) *sp))
+    sp++;
+
+  sign =3D (*sp =3D=3D '-');
+  sp +=3D sign;
+
+  if (base =3D=3D 0)
+    {
+      if (*sp =3D=3D '0')
+	{
+	  sp++;
+	  if (*sp =3D=3D 'x' || *sp =3D=3D 'X')
+	    {
+	      base =3D 16;
+	      sp++;
+	    }
+	  else if (*sp =3D=3D 'b' || *sp =3D=3D 'B')
+	    {
+	      base =3D 2;
+	      sp++;
+	    }
+	  else
+	    base =3D 8;
+	}
+      else
+	base =3D 10;
+    }
+
+  sn =3D strlen (sp);
+  dp =3D gmp_xalloc (sn + (sn =3D=3D 0));
+
+  for (sn =3D 0; *sp; sp++)
+    {
+      unsigned digit;
+
+      if (isspace ((unsigned char) *sp))
+	continue;
+      if (*sp >=3D '0' && *sp <=3D '9')
+	digit =3D *sp - '0';
+      else if (*sp >=3D 'a' && *sp <=3D 'z')
+	digit =3D *sp - 'a' + 10;
+      else if (*sp >=3D 'A' && *sp <=3D 'Z')
+	digit =3D *sp - 'A' + 10;
+      else
+	digit =3D base; /* fail */
+
+      if (digit >=3D base)
+	{
+	  gmp_free (dp);
+	  r->_mp_size =3D 0;
+	  return -1;
+	}
+
+      dp[sn++] =3D digit;
+    }
+
+  bits =3D mpn_base_power_of_two_p (base);
+
+  if (bits > 0)
+    {
+      alloc =3D (sn * bits + GMP_LIMB_BITS - 1) / GMP_LIMB_BITS;
+      rp =3D MPZ_REALLOC (r, alloc);
+      rn =3D mpn_set_str_bits (rp, dp, sn, bits);
+    }
+  else
+    {
+      struct mpn_base_info info;
+      mpn_get_base_info (&info, base);
+      alloc =3D (sn + info.exp - 1) / info.exp;
+      rp =3D MPZ_REALLOC (r, alloc);
+      rn =3D mpn_set_str_other (rp, dp, sn, base, &info);
+    }
+  assert (rn <=3D alloc);
+  gmp_free (dp);
+
+  r->_mp_size =3D sign ? - rn : rn;
+
+  return 0;
+}
+
+int
+mpz_init_set_str (mpz_t r, const char *sp, int base)
+{
+  mpz_init (r);
+  return mpz_set_str (r, sp, base);
+}
+
+size_t
+mpz_out_str (FILE *stream, int base, const mpz_t x)
+{
+  char *str;
+  size_t len;
+
+  str =3D mpz_get_str (NULL, base, x);
+  len =3D strlen (str);
+  len =3D fwrite (str, 1, len, stream);
+  gmp_free (str);
+  return len;
+}
+
+=0C
+static int
+gmp_detect_endian (void)
+{
+  static const int i =3D 2;
+  const unsigned char *p =3D (const unsigned char *) &i;
+  return 1 - *p;
+}
+
+/* Import and export. Does not support nails. */
+void
+mpz_import (mpz_t r, size_t count, int order, size_t size, int endian,
+	    size_t nails, const void *src)
+{
+  const unsigned char *p;
+  ptrdiff_t word_step;
+  mp_ptr rp;
+  mp_size_t rn;
+
+  /* The current (partial) limb. */
+  mp_limb_t limb;
+  /* The number of bytes already copied to this limb (starting from
+     the low end). */
+  size_t bytes;
+  /* The index where the limb should be stored, when completed. */
+  mp_size_t i;
+
+  if (nails !=3D 0)
+    gmp_die ("mpz_import: Nails not supported.");
+
+  assert (order =3D=3D 1 || order =3D=3D -1);
+  assert (endian >=3D -1 && endian <=3D 1);
+
+  if (endian =3D=3D 0)
+    endian =3D gmp_detect_endian ();
+
+  p =3D (unsigned char *) src;
+
+  word_step =3D (order !=3D endian) ? 2 * size : 0;
+
+  /* Process bytes from the least significant end, so point p at the
+     least significant word. */
+  if (order =3D=3D 1)
+    {
+      p +=3D size * (count - 1);
+      word_step =3D - word_step;
+    }
+
+  /* And at least significant byte of that word. */
+  if (endian =3D=3D 1)
+    p +=3D (size - 1);
+
+  rn =3D (size * count + sizeof(mp_limb_t) - 1) / sizeof(mp_limb_t);
+  rp =3D MPZ_REALLOC (r, rn);
+
+  for (limb =3D 0, bytes =3D 0, i =3D 0; count > 0; count--, p +=3D wo=
rd_step)
+    {
+      size_t j;
+      for (j =3D 0; j < size; j++, p -=3D (ptrdiff_t) endian)
+	{
+	  limb |=3D (mp_limb_t) *p << (bytes++ * CHAR_BIT);
+	  if (bytes =3D=3D sizeof(mp_limb_t))
+	    {
+	      rp[i++] =3D limb;
+	      bytes =3D 0;
+	      limb =3D 0;
+	    }
+	}
+    }
+  assert (i + (bytes > 0) =3D=3D rn);
+  if (limb !=3D 0)
+    rp[i++] =3D limb;
+  else
+    i =3D mpn_normalized_size (rp, i);
+
+  r->_mp_size =3D i;
+}
+
+void *
+mpz_export (void *r, size_t *countp, int order, size_t size, int endia=
n,
+	    size_t nails, const mpz_t u)
+{
+  size_t count;
+  mp_size_t un;
+
+  if (nails !=3D 0)
+    gmp_die ("mpz_import: Nails not supported.");
+
+  assert (order =3D=3D 1 || order =3D=3D -1);
+  assert (endian >=3D -1 && endian <=3D 1);
+  assert (size > 0 || u->_mp_size =3D=3D 0);
+
+  un =3D u->_mp_size;
+  count =3D 0;
+  if (un !=3D 0)
+    {
+      size_t k;
+      unsigned char *p;
+      ptrdiff_t word_step;
+      /* The current (partial) limb. */
+      mp_limb_t limb;
+      /* The number of bytes left to to in this limb. */
+      size_t bytes;
+      /* The index where the limb was read. */
+      mp_size_t i;
+
+      un =3D GMP_ABS (un);
+
+      /* Count bytes in top limb. */
+      limb =3D u->_mp_d[un-1];
+      assert (limb !=3D 0);
+
+      k =3D 0;
+      do {
+	k++; limb >>=3D CHAR_BIT;
+      } while (limb !=3D 0);
+
+      count =3D (k + (un-1) * sizeof (mp_limb_t) + size - 1) / size;
+
+      if (!r)
+	r =3D gmp_xalloc (count * size);
+
+      if (endian =3D=3D 0)
+	endian =3D gmp_detect_endian ();
+
+      p =3D (unsigned char *) r;
+
+      word_step =3D (order !=3D endian) ? 2 * size : 0;
+
+      /* Process bytes from the least significant end, so point p at t=
he
+	 least significant word. */
+      if (order =3D=3D 1)
+	{
+	  p +=3D size * (count - 1);
+	  word_step =3D - word_step;
+	}
+
+      /* And at least significant byte of that word. */
+      if (endian =3D=3D 1)
+	p +=3D (size - 1);
+
+      for (bytes =3D 0, i =3D 0, k =3D 0; k < count; k++, p +=3D word_=
step)
+	{
+	  size_t j;
+	  for (j =3D 0; j < size; j++, p -=3D (ptrdiff_t) endian)
+	    {
+	      if (bytes =3D=3D 0)
+		{
+		  if (i < un)
+		    limb =3D u->_mp_d[i++];
+		  bytes =3D sizeof (mp_limb_t);
+		}
+	      *p =3D limb;
+	      limb >>=3D CHAR_BIT;
+	      bytes--;
+	    }
+	}
+      assert (i =3D=3D un);
+      assert (k =3D=3D count);
+    }
+
+  if (countp)
+    *countp =3D count;
+
+  return r;
+}
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
