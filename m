From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 29/69]: nf_conntrack_h3223: sparse fixes
Date: Wed, 30 Jan 2008 21:17:39 +0100 (MET)
Message-ID: <20080130201737.29874.4545.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60708 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764657AbYA3URk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:40 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_h3223: sparse fixes

Sparse complains when a function is not really static. Putting static
on the function prototype is not enough.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a0b8676ce8423a544c283c59ac3d0c97e2e64b21
tree db319ec2ba9e665323bb671638ebfcbc36dcc8d8
parent cba4c67b58eee186ca8ff3e4588a01406d96a886
author Stephen Hemminger <shemminger@vyatta.com> Tue, 29 Jan 2008 16:22:07 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:19 +0100

 net/netfilter/nf_conntrack_h323_asn1.c |   36 ++++++++++++++++----------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index ff66fba..f73e130 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -126,7 +126,7 @@ static int decode_choice(bitstr_t * bs, field_t * f, char *base, int level);
 
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
 
@@ -203,7 +203,7 @@ unsigned get_bits(bitstr_t * bs, unsigned b)
 
 /****************************************************************************/
 /* Assume b <= 32 */
-unsigned get_bitmap(bitstr_t * bs, unsigned b)
+static unsigned get_bitmap(bitstr_t * bs, unsigned b)
 {
 	unsigned v, l, shift, bytes;
 
@@ -242,7 +242,7 @@ unsigned get_bitmap(bitstr_t * bs, unsigned b)
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
 
@@ -272,7 +272,7 @@ int decode_nul(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int decode_bool(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bool(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -283,7 +283,7 @@ int decode_bool(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int decode_oid(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_oid(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	int len;
 
@@ -299,7 +299,7 @@ int decode_oid(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int decode_int(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_int(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned len;
 
@@ -342,7 +342,7 @@ int decode_int(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int decode_enum(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_enum(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -357,7 +357,7 @@ int decode_enum(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned len;
 
@@ -390,7 +390,7 @@ int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int decode_numstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_numstr(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned len;
 
@@ -407,7 +407,7 @@ int decode_numstr(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned len;
 
@@ -455,7 +455,7 @@ int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned len;
 
@@ -480,7 +480,7 @@ int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned ext, bmp, i, opt, len = 0, bmp2, bmp2_len;
 	int err;
@@ -596,7 +596,7 @@ int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
 }
 
 /****************************************************************************/
-int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned count, effective_count = 0, i, len = 0;
 	int err;
@@ -685,7 +685,7 @@ int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level)
 
 
 /****************************************************************************/
-int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)
+static int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)
 {
 	unsigned type, ext, len = 0;
 	int err;
