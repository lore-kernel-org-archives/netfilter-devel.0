From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 48/69]: nf_conntrack_h323: clean up code a bit
Date: Wed, 30 Jan 2008 21:18:08 +0100 (MET)
Message-ID: <20080130201805.29874.68144.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60779 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbYA3USJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:09 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_h323: clean up code a bit

-total: 81 errors, 3 warnings, 876 lines checked
+total: 44 errors, 3 warnings, 876 lines checked

There is still work to be done, but that's for another patch.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bc81193022f55c5cc719728b1bdf67648054bce6
tree 3fe9a6ef417db3eacdcb20c160f57b38c80feade
parent 5cf331a51d8fed16e2e12142d8dc66eef5cb7bca
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 29 Jan 2008 16:22:15 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:10 +0100

 net/netfilter/nf_conntrack_h323_asn1.c |  128 ++++++++++++++++----------------
 1 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index f73e130..ef02262 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -96,7 +96,7 @@ typedef struct {
 	unsigned char *beg;
 	unsigned char *end;
 	unsigned char *cur;
-	unsigned bit;
+	unsigned int bit;
 } bitstr_t;
 
 /* Tool Functions */
@@ -104,28 +104,28 @@ typedef struct {
 #define INC_BITS(bs,b) if(((bs)->bit+=(b))>7){(bs)->cur+=(bs)->bit>>3;(bs)->bit&=7;}
 #define BYTE_ALIGN(bs) if((bs)->bit){(bs)->cur++;(bs)->bit=0;}
 #define CHECK_BOUND(bs,n) if((bs)->cur+(n)>(bs)->end)return(H323_ERROR_BOUND)
-static unsigned get_len(bitstr_t * bs);
-static unsigned get_bit(bitstr_t * bs);
-static unsigned get_bits(bitstr_t * bs, unsigned b);
-static unsigned get_bitmap(bitstr_t * bs, unsigned b);
-static unsigned get_uint(bitstr_t * bs, int b);
+static unsigned int get_len(bitstr_t *bs);
+static unsigned int get_bit(bitstr_t *bs);
+static unsigned int get_bits(bitstr_t *bs, unsigned int b);
+static unsigned int get_bitmap(bitstr_t *bs, unsigned int b);
+static unsigned int get_uint(bitstr_t *bs, int b);
 
 /* Decoder Functions */
-static int decode_nul(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_bool(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_oid(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_int(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_enum(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_numstr(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_seq(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level);
-static int decode_choice(bitstr_t * bs, field_t * f, char *base, int level);
+static int decode_nul(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_bool(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_oid(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_int(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_enum(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_bitstr(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_numstr(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_octstr(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_bmpstr(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_seq(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_seqof(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_choice(bitstr_t *bs, field_t *f, char *base, int level);
 
 /* Decoder Functions Vector */
-typedef int (*decoder_t) (bitstr_t *, field_t *, char *, int);
+typedef int (*decoder_t)(bitstr_t *, field_t *, char *, int);
 static const decoder_t Decoders[] = {
 	decode_nul,
 	decode_bool,
@@ -150,9 +150,9 @@ static const decoder_t Decoders[] = {
  * Functions
  ****************************************************************************/
 /* Assume bs is aligned && v < 16384 */
-static unsigned get_len(bitstr_t * bs)
+static unsigned int get_len(bitstr_t *bs)
 {
-	unsigned v;
+	unsigned int v;
 
 	v = *bs->cur++;
 
@@ -166,9 +166,9 @@ static unsigned get_len(bitstr_t * bs)
 }
 
 /****************************************************************************/
-static unsigned get_bit(bitstr_t * bs)
+static unsigned int get_bit(bitstr_t *bs)
 {
-	unsigned b = (*bs->cur) & (0x80 >> bs->bit);
+	unsigned int b = (*bs->cur) & (0x80 >> bs->bit);
 
 	INC_BIT(bs);
 
@@ -177,9 +177,9 @@ static unsigned get_bit(bitstr_t * bs)
 
 /****************************************************************************/
 /* Assume b <= 8 */
-static unsigned get_bits(bitstr_t * bs, unsigned b)
+static unsigned int get_bits(bitstr_t *bs, unsigned int b)
 {
-	unsigned v, l;
+	unsigned int v, l;
 
 	v = (*bs->cur) & (0xffU >> bs->bit);
 	l = b + bs->bit;
@@ -203,9 +203,9 @@ static unsigned get_bits(bitstr_t * bs, unsigned b)
 
 /****************************************************************************/
 /* Assume b <= 32 */
-static unsigned get_bitmap(bitstr_t * bs, unsigned b)
+static unsigned int get_bitmap(bitstr_t *bs, unsigned int b)
 {
-	unsigned v, l, shift, bytes;
+	unsigned int v, l, shift, bytes;
 
 	if (!b)
 		return 0;
@@ -213,18 +213,18 @@ static unsigned get_bitmap(bitstr_t * bs, unsigned b)
 	l = bs->bit + b;
 
 	if (l < 8) {
-		v = (unsigned) (*bs->cur) << (bs->bit + 24);
+		v = (unsigned int)(*bs->cur) << (bs->bit + 24);
 		bs->bit = l;
 	} else if (l == 8) {
-		v = (unsigned) (*bs->cur++) << (bs->bit + 24);
+		v = (unsigned int)(*bs->cur++) << (bs->bit + 24);
 		bs->bit = 0;
 	} else {
 		for (bytes = l >> 3, shift = 24, v = 0; bytes;
 		     bytes--, shift -= 8)
-			v |= (unsigned) (*bs->cur++) << shift;
+			v |= (unsigned int)(*bs->cur++) << shift;
 
 		if (l < 32) {
-			v |= (unsigned) (*bs->cur) << shift;
+			v |= (unsigned int)(*bs->cur) << shift;
 			v <<= bs->bit;
 		} else if (l > 32) {
 			v <<= bs->bit;
@@ -242,9 +242,9 @@ static unsigned get_bitmap(bitstr_t * bs, unsigned b)
 /****************************************************************************
  * Assume bs is aligned and sizeof(unsigned int) == 4
  ****************************************************************************/
-static unsigned get_uint(bitstr_t * bs, int b)
+static unsigned int get_uint(bitstr_t *bs, int b)
 {
-	unsigned v = 0;
+	unsigned int v = 0;
 
 	switch (b) {
 	case 4:
@@ -264,7 +264,7 @@ static unsigned get_uint(bitstr_t * bs, int b)
 }
 
 /****************************************************************************/
-static int decode_nul(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_nul(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -272,7 +272,7 @@ static int decode_nul(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_bool(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bool(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -283,7 +283,7 @@ static int decode_bool(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_oid(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_oid(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	int len;
 
@@ -299,9 +299,9 @@ static int decode_oid(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_int(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_int(bitstr_t *bs, field_t *f, char *base, int level)
 {
-	unsigned len;
+	unsigned int len;
 
 	PRINT("%*.s%s", level * TAB_SIZE, " ", f->name);
 
@@ -318,9 +318,9 @@ static int decode_int(bitstr_t * bs, field_t * f, char *base, int level)
 		len = get_bits(bs, 2) + 1;
 		BYTE_ALIGN(bs);
 		if (base && (f->attr & DECODE)) {	/* timeToLive */
-			unsigned v = get_uint(bs, len) + f->lb;
+			unsigned int v = get_uint(bs, len) + f->lb;
 			PRINT(" = %u", v);
-			*((unsigned *) (base + f->offset)) = v;
+			*((unsigned int *)(base + f->offset)) = v;
 		}
 		bs->cur += len;
 		break;
@@ -342,7 +342,7 @@ static int decode_int(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_enum(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_enum(bitstr_t *bs, field_t *f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -357,9 +357,9 @@ static int decode_enum(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bitstr(bitstr_t *bs, field_t *f, char *base, int level)
 {
-	unsigned len;
+	unsigned int len;
 
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -390,9 +390,9 @@ static int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_numstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_numstr(bitstr_t *bs, field_t *f, char *base, int level)
 {
-	unsigned len;
+	unsigned int len;
 
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -407,9 +407,9 @@ static int decode_numstr(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_octstr(bitstr_t *bs, field_t *f, char *base, int level)
 {
-	unsigned len;
+	unsigned int len;
 
 	PRINT("%*.s%s", level * TAB_SIZE, " ", f->name);
 
@@ -424,7 +424,7 @@ static int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level)
 					     bs->cur[0], bs->cur[1],
 					     bs->cur[2], bs->cur[3],
 					     bs->cur[4] * 256 + bs->cur[5]));
-				*((unsigned *) (base + f->offset)) =
+				*((unsigned int *)(base + f->offset)) =
 				    bs->cur - bs->buf;
 			}
 		}
@@ -455,9 +455,9 @@ static int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bmpstr(bitstr_t *bs, field_t *f, char *base, int level)
 {
-	unsigned len;
+	unsigned int len;
 
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -480,9 +480,9 @@ static int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_seq(bitstr_t *bs, field_t *f, char *base, int level)
 {
-	unsigned ext, bmp, i, opt, len = 0, bmp2, bmp2_len;
+	unsigned int ext, bmp, i, opt, len = 0, bmp2, bmp2_len;
 	int err;
 	field_t *son;
 	unsigned char *beg = NULL;
@@ -498,7 +498,7 @@ static int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
 	/* Get fields bitmap */
 	bmp = get_bitmap(bs, f->sz);
 	if (base)
-		*(unsigned *) base = bmp;
+		*(unsigned int *)base = bmp;
 
 	/* Decode the root components */
 	for (i = opt = 0, son = f->fields; i < f->lb; i++, son++) {
@@ -550,7 +550,7 @@ static int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
 	bmp2 = get_bitmap(bs, bmp2_len);
 	bmp |= bmp2 >> f->sz;
 	if (base)
-		*(unsigned *) base = bmp;
+		*(unsigned int *)base = bmp;
 	BYTE_ALIGN(bs);
 
 	/* Decode the extension components */
@@ -596,9 +596,9 @@ static int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_seqof(bitstr_t *bs, field_t *f, char *base, int level)
 {
-	unsigned count, effective_count = 0, i, len = 0;
+	unsigned int count, effective_count = 0, i, len = 0;
 	int err;
 	field_t *son;
 	unsigned char *beg = NULL;
@@ -636,8 +636,8 @@ static int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level)
 	/* Write Count */
 	if (base) {
 		effective_count = count > f->ub ? f->ub : count;
-		*(unsigned *) base = effective_count;
-		base += sizeof(unsigned);
+		*(unsigned int *)base = effective_count;
+		base += sizeof(unsigned int);
 	}
 
 	/* Decode nested field */
@@ -685,9 +685,9 @@ static int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level)
 
 
 /****************************************************************************/
-static int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_choice(bitstr_t *bs, field_t *f, char *base, int level)
 {
-	unsigned type, ext, len = 0;
+	unsigned int type, ext, len = 0;
 	int err;
 	field_t *son;
 	unsigned char *beg = NULL;
@@ -710,7 +710,7 @@ static int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)
 
 	/* Write Type */
 	if (base)
-		*(unsigned *) base = type;
+		*(unsigned int *)base = type;
 
 	/* Check Range */
 	if (type >= f->ub) {	/* Newer version? */
@@ -754,7 +754,7 @@ static int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage * ras)
+int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage *ras)
 {
 	static field_t ras_message = {
 		FNAME("RasMessage") CHOICE, 5, 24, 32, DECODE | EXT,
@@ -771,7 +771,7 @@ int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage * ras)
 
 /****************************************************************************/
 static int DecodeH323_UserInformation(unsigned char *buf, unsigned char *beg,
-				      size_t sz, H323_UserInformation * uuie)
+				      size_t sz, H323_UserInformation *uuie)
 {
 	static field_t h323_userinformation = {
 		FNAME("H323-UserInformation") SEQ, 1, 2, 2, DECODE | EXT,
@@ -807,7 +807,7 @@ int DecodeMultimediaSystemControlMessage(unsigned char *buf, size_t sz,
 }
 
 /****************************************************************************/
-int DecodeQ931(unsigned char *buf, size_t sz, Q931 * q931)
+int DecodeQ931(unsigned char *buf, size_t sz, Q931 *q931)
 {
 	unsigned char *p = buf;
 	int len;
