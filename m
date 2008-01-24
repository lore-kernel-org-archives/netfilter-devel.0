From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 6/8] nf_conntrack-h323: sparse fixes
Date: Thu, 24 Jan 2008 19:35:30 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801241932270.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49164 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbYAXSfb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:35:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's fix up the style while at it. In-place modification below.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---------- Forwarded message ----------
Subject: [PATCH 6/8] nf_conntrack-h323: sparse fixes

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
+static unsigned int get_len(bitstr_t *bs)
 {
 	unsigned v;
 
@@ -166,7 +166,7 @@ unsigned get_len(bitstr_t * bs)
 }
 
 /****************************************************************************/
-unsigned get_bit(bitstr_t * bs)
+static unsigned int get_bit(bitstr_t *bs)
 {
 	unsigned b = (*bs->cur) & (0x80 >> bs->bit);
 
@@ -177,7 +177,7 @@ unsigned get_bit(bitstr_t * bs)
 
 /****************************************************************************/
 /* Assume b <= 8 */
-unsigned get_bits(bitstr_t * bs, unsigned b)
+static unsigned int get_bits(bitstr_t *bs, unsigned int b)
 {
 	unsigned v, l;
 
@@ -203,7 +203,7 @@ unsigned get_bits(bitstr_t * bs, unsigne
 
 /****************************************************************************/
 /* Assume b <= 32 */
-unsigned get_bitmap(bitstr_t * bs, unsigned b)
+static unsigned int get_bitmap(bitstr_t *bs, unsigned int b)
 {
 	unsigned v, l, shift, bytes;
 
@@ -242,7 +242,7 @@ unsigned get_bitmap(bitstr_t * bs, unsig
 /****************************************************************************
  * Assume bs is aligned and sizeof(unsigned int) == 4
  ****************************************************************************/
-unsigned get_uint(bitstr_t * bs, int b)
+static unsigned int get_uint(bitstr_t *bs, int b)
 {
 	unsigned v = 0;
 
@@ -264,7 +264,7 @@ unsigned get_uint(bitstr_t * bs, int b)
 }
 
 /****************************************************************************/
-int decode_nul(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_nul(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -272,7 +272,7 @@ int decode_nul(bitstr_t * bs, field_t * 
 }
 
 /****************************************************************************/
-int decode_bool(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bool(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -283,7 +283,7 @@ int decode_bool(bitstr_t * bs, field_t *
 }
 
 /****************************************************************************/
-int decode_oid(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_oid(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	int len;
 
@@ -299,7 +299,7 @@ int decode_oid(bitstr_t * bs, field_t * 
 }
 
 /****************************************************************************/
-int decode_int(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_int(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	unsigned len;
 
@@ -342,7 +342,7 @@ int decode_int(bitstr_t * bs, field_t * 
 }
 
 /****************************************************************************/
-int decode_enum(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_enum(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -357,7 +357,7 @@ int decode_enum(bitstr_t * bs, field_t *
 }
 
 /****************************************************************************/
-int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bitstr(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	unsigned len;
 
@@ -390,7 +390,7 @@ int decode_bitstr(bitstr_t * bs, field_t
 }
 
 /****************************************************************************/
-int decode_numstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_numstr(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	unsigned len;
 
@@ -407,7 +407,7 @@ int decode_numstr(bitstr_t * bs, field_t
 }
 
 /****************************************************************************/
-int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_octstr(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	unsigned len;
 
@@ -455,7 +455,7 @@ int decode_octstr(bitstr_t * bs, field_t
 }
 
 /****************************************************************************/
-int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bmpstr(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	unsigned len;
 
@@ -480,7 +480,7 @@ int decode_bmpstr(bitstr_t * bs, field_t
 }
 
 /****************************************************************************/
-int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_seq(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	unsigned ext, bmp, i, opt, len = 0, bmp2, bmp2_len;
 	int err;
@@ -596,7 +596,7 @@ int decode_seq(bitstr_t * bs, field_t * 
 }
 
 /****************************************************************************/
-int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_seqof(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	unsigned count, effective_count = 0, i, len = 0;
 	int err;
@@ -685,7 +685,7 @@ int decode_seqof(bitstr_t * bs, field_t 
 
 
 /****************************************************************************/
-int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_choice(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	unsigned type, ext, len = 0;
 	int err;

-- 
