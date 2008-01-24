From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 6/8] nf_conntrack-h323: sparse fixes
Date: Thu, 24 Jan 2008 10:15:42 -0800
Message-ID: <20080124181628.392423639@vyatta.com>
References: <20080124181536.446214111@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:48258 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbYAXSYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:24:21 -0500
Content-Disposition: inline; filename=nf-conntrack-h323-sparse.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sparse complains when a function is not really static. Putting static
on the function prototype is not enough.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/net/netfilter/nf_conntrack_h323_asn1.c	2008-01-24 08:25:04.000000000 -0800
+++ b/net/netfilter/nf_conntrack_h323_asn1.c	2008-01-24 10:11:41.000000000 -0800
@@ -126,7 +126,7 @@ static int decode_choice(bitstr_t * bs, 
 
 /* Decoder Functions Vector */
 typedef int (*decoder_t) (bitstr_t *, field_t *, char *, int);
-static decoder_t Decoders[] = {
+static const decoder_t Decoders[] = {
 	decode_nul,
 	decode_bool,
 	decode_oid,
@@ -150,7 +150,7 @@ static decoder_t Decoders[] = {
  * Functions
  ****************************************************************************/
 /* Assume bs is aligned && v < 16384 */
-unsigned get_len(bitstr_t * bs)
+static unsigned get_len(bitstr_t * bs)
 {
 	unsigned v;
 
@@ -166,7 +166,7 @@ unsigned get_len(bitstr_t * bs)
 }
 
 /****************************************************************************/
-unsigned get_bit(bitstr_t * bs)
+static unsigned get_bit(bitstr_t * bs)
 {
 	unsigned b = (*bs->cur) & (0x80 >> bs->bit);
 
@@ -177,7 +177,7 @@ unsigned get_bit(bitstr_t * bs)
 
 /****************************************************************************/
 /* Assume b <= 8 */
-unsigned get_bits(bitstr_t * bs, unsigned b)
+static unsigned get_bits(bitstr_t * bs, unsigned b)
 {
 	unsigned v, l;
 
@@ -203,7 +203,7 @@ unsigned get_bits(bitstr_t * bs, unsigne
 
 /****************************************************************************/
 /* Assume b <= 32 */
-unsigned get_bitmap(bitstr_t * bs, unsigned b)
+static unsigned get_bitmap(bitstr_t * bs, unsigned b)
 {
 	unsigned v, l, shift, bytes;
 
@@ -242,7 +242,7 @@ unsigned get_bitmap(bitstr_t * bs, unsig
 /****************************************************************************
  * Assume bs is aligned and sizeof(unsigned int) == 4
  ****************************************************************************/
-unsigned get_uint(bitstr_t * bs, int b)
+static unsigned get_uint(bitstr_t * bs, int b)
 {
 	unsigned v = 0;
 
@@ -264,7 +264,7 @@ unsigned get_uint(bitstr_t * bs, int b)
 }
 
 /****************************************************************************/
-int decode_nul(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_nul(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -272,7 +272,7 @@ int decode_nul(bitstr_t * bs, field_t * 
 }
 
 /****************************************************************************/
-int decode_bool(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bool(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -283,7 +283,7 @@ int decode_bool(bitstr_t * bs, field_t *
 }
 
 /****************************************************************************/
-int decode_oid(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_oid(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	int len;
 
@@ -299,7 +299,7 @@ int decode_oid(bitstr_t * bs, field_t * 
 }
 
 /****************************************************************************/
-int decode_int(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_int(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned len;
 
@@ -342,7 +342,7 @@ int decode_int(bitstr_t * bs, field_t * 
 }
 
 /****************************************************************************/
-int decode_enum(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_enum(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -357,7 +357,7 @@ int decode_enum(bitstr_t * bs, field_t *
 }
 
 /****************************************************************************/
-int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned len;
 
@@ -390,7 +390,7 @@ int decode_bitstr(bitstr_t * bs, field_t
 }
 
 /****************************************************************************/
-int decode_numstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_numstr(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned len;
 
@@ -407,7 +407,7 @@ int decode_numstr(bitstr_t * bs, field_t
 }
 
 /****************************************************************************/
-int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned len;
 
@@ -455,7 +455,7 @@ int decode_octstr(bitstr_t * bs, field_t
 }
 
 /****************************************************************************/
-int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned len;
 
@@ -480,7 +480,7 @@ int decode_bmpstr(bitstr_t * bs, field_t
 }
 
 /****************************************************************************/
-int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned ext, bmp, i, opt, len = 0, bmp2, bmp2_len;
 	int err;
@@ -596,7 +596,7 @@ int decode_seq(bitstr_t * bs, field_t * 
 }
 
 /****************************************************************************/
-int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned count, effective_count = 0, i, len = 0;
 	int err;
@@ -685,7 +685,7 @@ int decode_seqof(bitstr_t * bs, field_t 
 
 
 /****************************************************************************/
-int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned type, ext, len = 0;
 	int err;

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>

