From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 01/10] [NETFILTER]: constify and annotate nf_conntrack_h323
Date: Sat, 26 Jan 2008 02:36:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801260236250.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48206 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYAZBgz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:36:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Constify data tables (predominantly in nf_conntrack_h323_types.c, but
also a few in nf_conntrack_h323_asn1.c) and use const qualifiers on
variables where possible in the h323 sources.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/ipv4/netfilter/nf_nat_h323.c        |    5 +-
 net/netfilter/nf_conntrack_h323_asn1.c  |   76 +++--
 net/netfilter/nf_conntrack_h323_main.c  |   19 +-
 net/netfilter/nf_conntrack_h323_types.c |  346 +++++++++++-----------
 4 files changed, 230 insertions(+), 216 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index a121989..ee47bf2 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -32,7 +32,8 @@ static int set_addr(struct sk_buff *skb,
 		__be32 ip;
 		__be16 port;
 	} __attribute__ ((__packed__)) buf;
-	struct tcphdr _tcph, *th;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
 
 	buf.ip = ip;
 	buf.port = port;
@@ -99,7 +100,7 @@ static int set_sig_addr(struct sk_buff *skb, struct nf_conn *ct,
 			unsigned char **data,
 			TransportAddress *taddr, int count)
 {
-	struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
+	const struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
 	int dir = CTINFO2DIR(ctinfo);
 	int i;
 	__be16 port;
diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index ef02262..8678823 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -87,7 +87,7 @@ typedef struct field_t {
 	unsigned char ub;
 	unsigned short attr;
 	unsigned short offset;
-	struct field_t *fields;
+	const struct field_t *fields;
 } field_t;
 
 /* Bit Stream */
@@ -111,21 +111,21 @@ static unsigned int get_bitmap(bitstr_t *bs, unsigned int b);
 static unsigned int get_uint(bitstr_t *bs, int b);
 
 /* Decoder Functions */
-static int decode_nul(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_bool(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_oid(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_int(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_enum(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_bitstr(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_numstr(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_octstr(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_bmpstr(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_seq(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_seqof(bitstr_t *bs, field_t *f, char *base, int level);
-static int decode_choice(bitstr_t *bs, field_t *f, char *base, int level);
+static int decode_nul(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_bool(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_oid(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_int(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_enum(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_bitstr(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_numstr(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_octstr(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_bmpstr(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_seq(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_seqof(bitstr_t *bs, const struct field_t *f, char *base, int level);
+static int decode_choice(bitstr_t *bs, const struct field_t *f, char *base, int level);
 
 /* Decoder Functions Vector */
-typedef int (*decoder_t)(bitstr_t *, field_t *, char *, int);
+typedef int (*decoder_t)(bitstr_t *, const struct field_t *, char *, int);
 static const decoder_t Decoders[] = {
 	decode_nul,
 	decode_bool,
@@ -264,7 +264,8 @@ static unsigned int get_uint(bitstr_t *bs, int b)
 }
 
 /****************************************************************************/
-static int decode_nul(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_nul(bitstr_t *bs, const struct field_t *f,
+                      char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -272,7 +273,8 @@ static int decode_nul(bitstr_t *bs, field_t *f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_bool(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_bool(bitstr_t *bs, const struct field_t *f,
+                       char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -283,7 +285,8 @@ static int decode_bool(bitstr_t *bs, field_t *f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_oid(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_oid(bitstr_t *bs, const struct field_t *f,
+                      char *base, int level)
 {
 	int len;
 
@@ -299,7 +302,8 @@ static int decode_oid(bitstr_t *bs, field_t *f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_int(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_int(bitstr_t *bs, const struct field_t *f,
+                      char *base, int level)
 {
 	unsigned int len;
 
@@ -342,7 +346,8 @@ static int decode_int(bitstr_t *bs, field_t *f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_enum(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_enum(bitstr_t *bs, const struct field_t *f,
+                       char *base, int level)
 {
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
@@ -357,7 +362,8 @@ static int decode_enum(bitstr_t *bs, field_t *f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_bitstr(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_bitstr(bitstr_t *bs, const struct field_t *f,
+                         char *base, int level)
 {
 	unsigned int len;
 
@@ -390,7 +396,8 @@ static int decode_bitstr(bitstr_t *bs, field_t *f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_numstr(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_numstr(bitstr_t *bs, const struct field_t *f,
+                         char *base, int level)
 {
 	unsigned int len;
 
@@ -407,7 +414,8 @@ static int decode_numstr(bitstr_t *bs, field_t *f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_octstr(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_octstr(bitstr_t *bs, const struct field_t *f,
+                         char *base, int level)
 {
 	unsigned int len;
 
@@ -455,7 +463,8 @@ static int decode_octstr(bitstr_t *bs, field_t *f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_bmpstr(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_bmpstr(bitstr_t *bs, const struct field_t *f,
+                         char *base, int level)
 {
 	unsigned int len;
 
@@ -480,11 +489,12 @@ static int decode_bmpstr(bitstr_t *bs, field_t *f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_seq(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_seq(bitstr_t *bs, const struct field_t *f,
+                      char *base, int level)
 {
 	unsigned int ext, bmp, i, opt, len = 0, bmp2, bmp2_len;
 	int err;
-	field_t *son;
+	const struct field_t *son;
 	unsigned char *beg = NULL;
 
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
@@ -596,11 +606,12 @@ static int decode_seq(bitstr_t *bs, field_t *f, char *base, int level)
 }
 
 /****************************************************************************/
-static int decode_seqof(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_seqof(bitstr_t *bs, const struct field_t *f,
+                        char *base, int level)
 {
 	unsigned int count, effective_count = 0, i, len = 0;
 	int err;
-	field_t *son;
+	const struct field_t *son;
 	unsigned char *beg = NULL;
 
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
@@ -685,11 +696,12 @@ static int decode_seqof(bitstr_t *bs, field_t *f, char *base, int level)
 
 
 /****************************************************************************/
-static int decode_choice(bitstr_t *bs, field_t *f, char *base, int level)
+static int decode_choice(bitstr_t *bs, const struct field_t *f,
+                         char *base, int level)
 {
 	unsigned int type, ext, len = 0;
 	int err;
-	field_t *son;
+	const struct field_t *son;
 	unsigned char *beg = NULL;
 
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
@@ -756,7 +768,7 @@ static int decode_choice(bitstr_t *bs, field_t *f, char *base, int level)
 /****************************************************************************/
 int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage *ras)
 {
-	static field_t ras_message = {
+	static const struct field_t ras_message = {
 		FNAME("RasMessage") CHOICE, 5, 24, 32, DECODE | EXT,
 		0, _RasMessage
 	};
@@ -773,7 +785,7 @@ int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage *ras)
 static int DecodeH323_UserInformation(unsigned char *buf, unsigned char *beg,
 				      size_t sz, H323_UserInformation *uuie)
 {
-	static field_t h323_userinformation = {
+	static const struct field_t h323_userinformation = {
 		FNAME("H323-UserInformation") SEQ, 1, 2, 2, DECODE | EXT,
 		0, _H323_UserInformation
 	};
@@ -792,7 +804,7 @@ int DecodeMultimediaSystemControlMessage(unsigned char *buf, size_t sz,
 					 MultimediaSystemControlMessage *
 					 mscm)
 {
-	static field_t multimediasystemcontrolmessage = {
+	static const struct field_t multimediasystemcontrolmessage = {
 		FNAME("MultimediaSystemControlMessage") CHOICE, 2, 4, 4,
 		DECODE | EXT, 0, _MultimediaSystemControlMessage
 	};
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 872c1aa..3df85c1 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -114,7 +114,8 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 {
 	struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
 	int dir = CTINFO2DIR(ctinfo);
-	struct tcphdr _tcph, *th;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
 	int tcpdatalen;
 	int tcpdataoff;
 	unsigned char *tpkt;
@@ -212,11 +213,11 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 }
 
 /****************************************************************************/
-static int get_h245_addr(struct nf_conn *ct, unsigned char *data,
+static int get_h245_addr(struct nf_conn *ct, const unsigned char *data,
 			 H245_TransportAddress *taddr,
 			 union nf_inet_addr *addr, __be16 *port)
 {
-	unsigned char *p;
+	const unsigned char *p;
 	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int len;
 
@@ -625,7 +626,7 @@ int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 		  TransportAddress *taddr,
 		  union nf_inet_addr *addr, __be16 *port)
 {
-	unsigned char *p;
+	const unsigned char *p;
 	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int len;
 
@@ -704,9 +705,8 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 
 /* If the calling party is on the same side of the forward-to party,
  * we don't need to track the second call */
-static int callforward_do_filter(union nf_inet_addr *src,
-				 union nf_inet_addr *dst,
-				 int family)
+static int callforward_do_filter(const union nf_inet_addr *src,
+                                 const union nf_inet_addr *dst, int family)
 {
 	const struct nf_afinfo *afinfo;
 	struct flowi fl1, fl2;
@@ -1185,7 +1185,8 @@ static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
 static unsigned char *get_udp_data(struct sk_buff *skb, unsigned int protoff,
 				   int *datalen)
 {
-	struct udphdr _uh, *uh;
+	const struct udphdr *uh;
+	struct udphdr _uh;
 	int dataoff;
 
 	uh = skb_header_pointer(skb, protoff, sizeof(_uh), &_uh);
@@ -1468,7 +1469,7 @@ static int process_arq(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned char **data, AdmissionRequest *arq)
 {
-	struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
+	const struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
 	int dir = CTINFO2DIR(ctinfo);
 	__be16 port;
 	union nf_inet_addr addr;
diff --git a/net/netfilter/nf_conntrack_h323_types.c b/net/netfilter/nf_conntrack_h323_types.c
index 3a21fdf..d880f35 100644
--- a/net/netfilter/nf_conntrack_h323_types.c
+++ b/net/netfilter/nf_conntrack_h323_types.c
@@ -5,22 +5,22 @@
  * This source code is licensed under General Public License version 2.
  */
 
-static field_t _TransportAddress_ipAddress[] = {	/* SEQUENCE */
+static const struct field_t _TransportAddress_ipAddress[] = {	/* SEQUENCE */
 	{FNAME("ip") OCTSTR, FIXD, 4, 0, DECODE,
 	 offsetof(TransportAddress_ipAddress, ip), NULL},
 	{FNAME("port") INT, WORD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _TransportAddress_ipSourceRoute_route[] = {	/* SEQUENCE OF */
+static const struct field_t _TransportAddress_ipSourceRoute_route[] = {	/* SEQUENCE OF */
 	{FNAME("item") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},
 };
 
-static field_t _TransportAddress_ipSourceRoute_routing[] = {	/* CHOICE */
+static const struct field_t _TransportAddress_ipSourceRoute_routing[] = {	/* CHOICE */
 	{FNAME("strict") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("loose") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _TransportAddress_ipSourceRoute[] = {	/* SEQUENCE */
+static const struct field_t _TransportAddress_ipSourceRoute[] = {	/* SEQUENCE */
 	{FNAME("ip") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},
 	{FNAME("port") INT, WORD, 0, 0, SKIP, 0, NULL},
 	{FNAME("route") SEQOF, SEMI, 0, 0, SKIP, 0,
@@ -29,37 +29,37 @@ static field_t _TransportAddress_ipSourceRoute[] = {	/* SEQUENCE */
 	 _TransportAddress_ipSourceRoute_routing},
 };
 
-static field_t _TransportAddress_ipxAddress[] = {	/* SEQUENCE */
+static const struct field_t _TransportAddress_ipxAddress[] = {	/* SEQUENCE */
 	{FNAME("node") OCTSTR, FIXD, 6, 0, SKIP, 0, NULL},
 	{FNAME("netnum") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},
 	{FNAME("port") OCTSTR, FIXD, 2, 0, SKIP, 0, NULL},
 };
 
-static field_t _TransportAddress_ip6Address[] = {	/* SEQUENCE */
+static const struct field_t _TransportAddress_ip6Address[] = {	/* SEQUENCE */
 	{FNAME("ip") OCTSTR, FIXD, 16, 0, DECODE,
 	 offsetof(TransportAddress_ip6Address, ip), NULL},
 	{FNAME("port") INT, WORD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H221NonStandard[] = {	/* SEQUENCE */
+static const struct field_t _H221NonStandard[] = {	/* SEQUENCE */
 	{FNAME("t35CountryCode") INT, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("t35Extension") INT, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("manufacturerCode") INT, WORD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _NonStandardIdentifier[] = {	/* CHOICE */
+static const struct field_t _NonStandardIdentifier[] = {	/* CHOICE */
 	{FNAME("object") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("h221NonStandard") SEQ, 0, 3, 3, SKIP | EXT, 0,
 	 _H221NonStandard},
 };
 
-static field_t _NonStandardParameter[] = {	/* SEQUENCE */
+static const struct field_t _NonStandardParameter[] = {	/* SEQUENCE */
 	{FNAME("nonStandardIdentifier") CHOICE, 1, 2, 2, SKIP | EXT, 0,
 	 _NonStandardIdentifier},
 	{FNAME("data") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _TransportAddress[] = {	/* CHOICE */
+static const struct field_t _TransportAddress[] = {	/* CHOICE */
 	{FNAME("ipAddress") SEQ, 0, 2, 2, DECODE,
 	 offsetof(TransportAddress, ipAddress), _TransportAddress_ipAddress},
 	{FNAME("ipSourceRoute") SEQ, 0, 4, 4, SKIP | EXT, 0,
@@ -75,7 +75,7 @@ static field_t _TransportAddress[] = {	/* CHOICE */
 	 _NonStandardParameter},
 };
 
-static field_t _AliasAddress[] = {	/* CHOICE */
+static const struct field_t _AliasAddress[] = {	/* CHOICE */
 	{FNAME("dialedDigits") NUMDGT, 7, 1, 0, SKIP, 0, NULL},
 	{FNAME("h323-ID") BMPSTR, BYTE, 1, 0, SKIP, 0, NULL},
 	{FNAME("url-ID") IA5STR, WORD, 1, 0, SKIP, 0, NULL},
@@ -85,78 +85,78 @@ static field_t _AliasAddress[] = {	/* CHOICE */
 	{FNAME("mobileUIM") CHOICE, 1, 2, 2, SKIP | EXT, 0, NULL},
 };
 
-static field_t _Setup_UUIE_sourceAddress[] = {	/* SEQUENCE OF */
+static const struct field_t _Setup_UUIE_sourceAddress[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 };
 
-static field_t _VendorIdentifier[] = {	/* SEQUENCE */
+static const struct field_t _VendorIdentifier[] = {	/* SEQUENCE */
 	{FNAME("vendor") SEQ, 0, 3, 3, SKIP | EXT, 0, _H221NonStandard},
 	{FNAME("productId") OCTSTR, BYTE, 1, 0, SKIP | OPT, 0, NULL},
 	{FNAME("versionId") OCTSTR, BYTE, 1, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _GatekeeperInfo[] = {	/* SEQUENCE */
+static const struct field_t _GatekeeperInfo[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 };
 
-static field_t _H310Caps[] = {	/* SEQUENCE */
+static const struct field_t _H310Caps[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H320Caps[] = {	/* SEQUENCE */
+static const struct field_t _H320Caps[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H321Caps[] = {	/* SEQUENCE */
+static const struct field_t _H321Caps[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H322Caps[] = {	/* SEQUENCE */
+static const struct field_t _H322Caps[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H323Caps[] = {	/* SEQUENCE */
+static const struct field_t _H323Caps[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H324Caps[] = {	/* SEQUENCE */
+static const struct field_t _H324Caps[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _VoiceCaps[] = {	/* SEQUENCE */
+static const struct field_t _VoiceCaps[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _T120OnlyCaps[] = {	/* SEQUENCE */
+static const struct field_t _T120OnlyCaps[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _SupportedProtocols[] = {	/* CHOICE */
+static const struct field_t _SupportedProtocols[] = {	/* CHOICE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP, 0,
 	 _NonStandardParameter},
 	{FNAME("h310") SEQ, 1, 1, 3, SKIP | EXT, 0, _H310Caps},
@@ -171,29 +171,29 @@ static field_t _SupportedProtocols[] = {	/* CHOICE */
 	{FNAME("t38FaxAnnexbOnly") SEQ, 2, 5, 5, SKIP | EXT, 0, NULL},
 };
 
-static field_t _GatewayInfo_protocol[] = {	/* SEQUENCE OF */
+static const struct field_t _GatewayInfo_protocol[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 4, 9, 11, SKIP | EXT, 0, _SupportedProtocols},
 };
 
-static field_t _GatewayInfo[] = {	/* SEQUENCE */
+static const struct field_t _GatewayInfo[] = {	/* SEQUENCE */
 	{FNAME("protocol") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,
 	 _GatewayInfo_protocol},
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 };
 
-static field_t _McuInfo[] = {	/* SEQUENCE */
+static const struct field_t _McuInfo[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("protocol") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _TerminalInfo[] = {	/* SEQUENCE */
+static const struct field_t _TerminalInfo[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 };
 
-static field_t _EndpointType[] = {	/* SEQUENCE */
+static const struct field_t _EndpointType[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("vendor") SEQ, 2, 3, 3, SKIP | EXT | OPT, 0,
@@ -210,19 +210,19 @@ static field_t _EndpointType[] = {	/* SEQUENCE */
 	 0, NULL},
 };
 
-static field_t _Setup_UUIE_destinationAddress[] = {	/* SEQUENCE OF */
+static const struct field_t _Setup_UUIE_destinationAddress[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 };
 
-static field_t _Setup_UUIE_destExtraCallInfo[] = {	/* SEQUENCE OF */
+static const struct field_t _Setup_UUIE_destExtraCallInfo[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 };
 
-static field_t _Setup_UUIE_destExtraCRV[] = {	/* SEQUENCE OF */
+static const struct field_t _Setup_UUIE_destExtraCRV[] = {	/* SEQUENCE OF */
 	{FNAME("item") INT, WORD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _Setup_UUIE_conferenceGoal[] = {	/* CHOICE */
+static const struct field_t _Setup_UUIE_conferenceGoal[] = {	/* CHOICE */
 	{FNAME("create") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("join") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("invite") NUL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -231,12 +231,12 @@ static field_t _Setup_UUIE_conferenceGoal[] = {	/* CHOICE */
 	 0, NULL},
 };
 
-static field_t _Q954Details[] = {	/* SEQUENCE */
+static const struct field_t _Q954Details[] = {	/* SEQUENCE */
 	{FNAME("conferenceCalling") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("threePartyService") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _QseriesOptions[] = {	/* SEQUENCE */
+static const struct field_t _QseriesOptions[] = {	/* SEQUENCE */
 	{FNAME("q932Full") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("q951Full") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("q952Full") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -247,32 +247,32 @@ static field_t _QseriesOptions[] = {	/* SEQUENCE */
 	{FNAME("q954Info") SEQ, 0, 2, 2, SKIP | EXT, 0, _Q954Details},
 };
 
-static field_t _CallType[] = {	/* CHOICE */
+static const struct field_t _CallType[] = {	/* CHOICE */
 	{FNAME("pointToPoint") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("oneToN") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("nToOne") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("nToN") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H245_NonStandardIdentifier_h221NonStandard[] = {	/* SEQUENCE */
+static const struct field_t _H245_NonStandardIdentifier_h221NonStandard[] = {	/* SEQUENCE */
 	{FNAME("t35CountryCode") INT, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("t35Extension") INT, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("manufacturerCode") INT, WORD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H245_NonStandardIdentifier[] = {	/* CHOICE */
+static const struct field_t _H245_NonStandardIdentifier[] = {	/* CHOICE */
 	{FNAME("object") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("h221NonStandard") SEQ, 0, 3, 3, SKIP, 0,
 	 _H245_NonStandardIdentifier_h221NonStandard},
 };
 
-static field_t _H245_NonStandardParameter[] = {	/* SEQUENCE */
+static const struct field_t _H245_NonStandardParameter[] = {	/* SEQUENCE */
 	{FNAME("nonStandardIdentifier") CHOICE, 1, 2, 2, SKIP, 0,
 	 _H245_NonStandardIdentifier},
 	{FNAME("data") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H261VideoCapability[] = {	/* SEQUENCE */
+static const struct field_t _H261VideoCapability[] = {	/* SEQUENCE */
 	{FNAME("qcifMPI") INT, 2, 1, 0, SKIP | OPT, 0, NULL},
 	{FNAME("cifMPI") INT, 2, 1, 0, SKIP | OPT, 0, NULL},
 	{FNAME("temporalSpatialTradeOffCapability") BOOL, FIXD, 0, 0, SKIP, 0,
@@ -282,7 +282,7 @@ static field_t _H261VideoCapability[] = {	/* SEQUENCE */
 	{FNAME("videoBadMBsCap") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H262VideoCapability[] = {	/* SEQUENCE */
+static const struct field_t _H262VideoCapability[] = {	/* SEQUENCE */
 	{FNAME("profileAndLevel-SPatML") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("profileAndLevel-MPatLL") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("profileAndLevel-MPatML") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -304,7 +304,7 @@ static field_t _H262VideoCapability[] = {	/* SEQUENCE */
 	{FNAME("videoBadMBsCap") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H263VideoCapability[] = {	/* SEQUENCE */
+static const struct field_t _H263VideoCapability[] = {	/* SEQUENCE */
 	{FNAME("sqcifMPI") INT, 5, 1, 0, SKIP | OPT, 0, NULL},
 	{FNAME("qcifMPI") INT, 5, 1, 0, SKIP | OPT, 0, NULL},
 	{FNAME("cifMPI") INT, 5, 1, 0, SKIP | OPT, 0, NULL},
@@ -330,7 +330,7 @@ static field_t _H263VideoCapability[] = {	/* SEQUENCE */
 	{FNAME("h263Options") SEQ, 5, 29, 31, SKIP | EXT | OPT, 0, NULL},
 };
 
-static field_t _IS11172VideoCapability[] = {	/* SEQUENCE */
+static const struct field_t _IS11172VideoCapability[] = {	/* SEQUENCE */
 	{FNAME("constrainedBitstream") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("videoBitRate") INT, CONS, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("vbvBufferSize") INT, CONS, 0, 0, SKIP | OPT, 0, NULL},
@@ -341,7 +341,7 @@ static field_t _IS11172VideoCapability[] = {	/* SEQUENCE */
 	{FNAME("videoBadMBsCap") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _VideoCapability[] = {	/* CHOICE */
+static const struct field_t _VideoCapability[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,
 	 _H245_NonStandardParameter},
 	{FNAME("h261VideoCapability") SEQ, 2, 5, 6, SKIP | EXT, 0,
@@ -355,12 +355,12 @@ static field_t _VideoCapability[] = {	/* CHOICE */
 	{FNAME("genericVideoCapability") SEQ, 5, 6, 6, SKIP | EXT, 0, NULL},
 };
 
-static field_t _AudioCapability_g7231[] = {	/* SEQUENCE */
+static const struct field_t _AudioCapability_g7231[] = {	/* SEQUENCE */
 	{FNAME("maxAl-sduAudioFrames") INT, BYTE, 1, 0, SKIP, 0, NULL},
 	{FNAME("silenceSuppression") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _IS11172AudioCapability[] = {	/* SEQUENCE */
+static const struct field_t _IS11172AudioCapability[] = {	/* SEQUENCE */
 	{FNAME("audioLayer1") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("audioLayer2") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("audioLayer3") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -372,7 +372,7 @@ static field_t _IS11172AudioCapability[] = {	/* SEQUENCE */
 	{FNAME("bitRate") INT, WORD, 1, 0, SKIP, 0, NULL},
 };
 
-static field_t _IS13818AudioCapability[] = {	/* SEQUENCE */
+static const struct field_t _IS13818AudioCapability[] = {	/* SEQUENCE */
 	{FNAME("audioLayer1") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("audioLayer2") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("audioLayer3") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -396,7 +396,7 @@ static field_t _IS13818AudioCapability[] = {	/* SEQUENCE */
 	{FNAME("bitRate") INT, WORD, 1, 0, SKIP, 0, NULL},
 };
 
-static field_t _AudioCapability[] = {	/* CHOICE */
+static const struct field_t _AudioCapability[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,
 	 _H245_NonStandardParameter},
 	{FNAME("g711Alaw64k") INT, BYTE, 1, 0, SKIP, 0, NULL},
@@ -424,7 +424,7 @@ static field_t _AudioCapability[] = {	/* CHOICE */
 	{FNAME("g729Extensions") SEQ, 1, 8, 8, SKIP | EXT, 0, NULL},
 };
 
-static field_t _DataProtocolCapability[] = {	/* CHOICE */
+static const struct field_t _DataProtocolCapability[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,
 	 _H245_NonStandardParameter},
 	{FNAME("v14buffered") NUL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -442,7 +442,7 @@ static field_t _DataProtocolCapability[] = {	/* CHOICE */
 	{FNAME("udp") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _T84Profile_t84Restricted[] = {	/* SEQUENCE */
+static const struct field_t _T84Profile_t84Restricted[] = {	/* SEQUENCE */
 	{FNAME("qcif") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("cif") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("ccir601Seq") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -464,25 +464,25 @@ static field_t _T84Profile_t84Restricted[] = {	/* SEQUENCE */
 	{FNAME("digPhotoHighProg") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _T84Profile[] = {	/* CHOICE */
+static const struct field_t _T84Profile[] = {	/* CHOICE */
 	{FNAME("t84Unrestricted") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("t84Restricted") SEQ, 0, 19, 19, SKIP | EXT, 0,
 	 _T84Profile_t84Restricted},
 };
 
-static field_t _DataApplicationCapability_application_t84[] = {	/* SEQUENCE */
+static const struct field_t _DataApplicationCapability_application_t84[] = {	/* SEQUENCE */
 	{FNAME("t84Protocol") CHOICE, 3, 7, 14, SKIP | EXT, 0,
 	 _DataProtocolCapability},
 	{FNAME("t84Profile") CHOICE, 1, 2, 2, SKIP, 0, _T84Profile},
 };
 
-static field_t _DataApplicationCapability_application_nlpid[] = {	/* SEQUENCE */
+static const struct field_t _DataApplicationCapability_application_nlpid[] = {	/* SEQUENCE */
 	{FNAME("nlpidProtocol") CHOICE, 3, 7, 14, SKIP | EXT, 0,
 	 _DataProtocolCapability},
 	{FNAME("nlpidData") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _DataApplicationCapability_application[] = {	/* CHOICE */
+static const struct field_t _DataApplicationCapability_application[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,
 	 _H245_NonStandardParameter},
 	{FNAME("t120") CHOICE, 3, 7, 14, DECODE | EXT,
@@ -509,20 +509,20 @@ static field_t _DataApplicationCapability_application[] = {	/* CHOICE */
 	{FNAME("genericDataCapability") SEQ, 5, 6, 6, SKIP | EXT, 0, NULL},
 };
 
-static field_t _DataApplicationCapability[] = {	/* SEQUENCE */
+static const struct field_t _DataApplicationCapability[] = {	/* SEQUENCE */
 	{FNAME("application") CHOICE, 4, 10, 14, DECODE | EXT,
 	 offsetof(DataApplicationCapability, application),
 	 _DataApplicationCapability_application},
 	{FNAME("maxBitRate") INT, CONS, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _EncryptionMode[] = {	/* CHOICE */
+static const struct field_t _EncryptionMode[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,
 	 _H245_NonStandardParameter},
 	{FNAME("h233Encryption") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _DataType[] = {	/* CHOICE */
+static const struct field_t _DataType[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,
 	 _H245_NonStandardParameter},
 	{FNAME("nullData") NUL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -538,7 +538,7 @@ static field_t _DataType[] = {	/* CHOICE */
 	{FNAME("multiplexedStream") SEQ, 0, 2, 2, SKIP | EXT, 0, NULL},
 };
 
-static field_t _H222LogicalChannelParameters[] = {	/* SEQUENCE */
+static const struct field_t _H222LogicalChannelParameters[] = {	/* SEQUENCE */
 	{FNAME("resourceID") INT, WORD, 0, 0, SKIP, 0, NULL},
 	{FNAME("subChannelID") INT, WORD, 0, 0, SKIP, 0, NULL},
 	{FNAME("pcr-pid") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},
@@ -546,12 +546,12 @@ static field_t _H222LogicalChannelParameters[] = {	/* SEQUENCE */
 	{FNAME("streamDescriptors") OCTSTR, SEMI, 0, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _H223LogicalChannelParameters_adaptationLayerType_al3[] = {	/* SEQUENCE */
+static const struct field_t _H223LogicalChannelParameters_adaptationLayerType_al3[] = {	/* SEQUENCE */
 	{FNAME("controlFieldOctets") INT, 2, 0, 0, SKIP, 0, NULL},
 	{FNAME("sendBufferSize") INT, CONS, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H223LogicalChannelParameters_adaptationLayerType[] = {	/* CHOICE */
+static const struct field_t _H223LogicalChannelParameters_adaptationLayerType[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,
 	 _H245_NonStandardParameter},
 	{FNAME("al1Framed") NUL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -565,53 +565,53 @@ static field_t _H223LogicalChannelParameters_adaptationLayerType[] = {	/* CHOICE
 	{FNAME("al3M") SEQ, 0, 5, 6, SKIP | EXT, 0, NULL},
 };
 
-static field_t _H223LogicalChannelParameters[] = {	/* SEQUENCE */
+static const struct field_t _H223LogicalChannelParameters[] = {	/* SEQUENCE */
 	{FNAME("adaptationLayerType") CHOICE, 3, 6, 9, SKIP | EXT, 0,
 	 _H223LogicalChannelParameters_adaptationLayerType},
 	{FNAME("segmentableFlag") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CRCLength[] = {	/* CHOICE */
+static const struct field_t _CRCLength[] = {	/* CHOICE */
 	{FNAME("crc8bit") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("crc16bit") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("crc32bit") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _V76HDLCParameters[] = {	/* SEQUENCE */
+static const struct field_t _V76HDLCParameters[] = {	/* SEQUENCE */
 	{FNAME("crcLength") CHOICE, 2, 3, 3, SKIP | EXT, 0, _CRCLength},
 	{FNAME("n401") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("loopbackTestProcedure") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _V76LogicalChannelParameters_suspendResume[] = {	/* CHOICE */
+static const struct field_t _V76LogicalChannelParameters_suspendResume[] = {	/* CHOICE */
 	{FNAME("noSuspendResume") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("suspendResumewAddress") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("suspendResumewoAddress") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _V76LogicalChannelParameters_mode_eRM_recovery[] = {	/* CHOICE */
+static const struct field_t _V76LogicalChannelParameters_mode_eRM_recovery[] = {	/* CHOICE */
 	{FNAME("rej") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("sREJ") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("mSREJ") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _V76LogicalChannelParameters_mode_eRM[] = {	/* SEQUENCE */
+static const struct field_t _V76LogicalChannelParameters_mode_eRM[] = {	/* SEQUENCE */
 	{FNAME("windowSize") INT, 7, 1, 0, SKIP, 0, NULL},
 	{FNAME("recovery") CHOICE, 2, 3, 3, SKIP | EXT, 0,
 	 _V76LogicalChannelParameters_mode_eRM_recovery},
 };
 
-static field_t _V76LogicalChannelParameters_mode[] = {	/* CHOICE */
+static const struct field_t _V76LogicalChannelParameters_mode[] = {	/* CHOICE */
 	{FNAME("eRM") SEQ, 0, 2, 2, SKIP | EXT, 0,
 	 _V76LogicalChannelParameters_mode_eRM},
 	{FNAME("uNERM") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _V75Parameters[] = {	/* SEQUENCE */
+static const struct field_t _V75Parameters[] = {	/* SEQUENCE */
 	{FNAME("audioHeaderPresent") BOOL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _V76LogicalChannelParameters[] = {	/* SEQUENCE */
+static const struct field_t _V76LogicalChannelParameters[] = {	/* SEQUENCE */
 	{FNAME("hdlcParameters") SEQ, 0, 3, 3, SKIP | EXT, 0,
 	 _V76HDLCParameters},
 	{FNAME("suspendResume") CHOICE, 2, 3, 3, SKIP | EXT, 0,
@@ -622,38 +622,38 @@ static field_t _V76LogicalChannelParameters[] = {	/* SEQUENCE */
 	{FNAME("v75Parameters") SEQ, 0, 1, 1, SKIP | EXT, 0, _V75Parameters},
 };
 
-static field_t _H2250LogicalChannelParameters_nonStandard[] = {	/* SEQUENCE OF */
+static const struct field_t _H2250LogicalChannelParameters_nonStandard[] = {	/* SEQUENCE OF */
 	{FNAME("item") SEQ, 0, 2, 2, SKIP, 0, _H245_NonStandardParameter},
 };
 
-static field_t _UnicastAddress_iPAddress[] = {	/* SEQUENCE */
+static const struct field_t _UnicastAddress_iPAddress[] = {	/* SEQUENCE */
 	{FNAME("network") OCTSTR, FIXD, 4, 0, DECODE,
 	 offsetof(UnicastAddress_iPAddress, network), NULL},
 	{FNAME("tsapIdentifier") INT, WORD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _UnicastAddress_iPXAddress[] = {	/* SEQUENCE */
+static const struct field_t _UnicastAddress_iPXAddress[] = {	/* SEQUENCE */
 	{FNAME("node") OCTSTR, FIXD, 6, 0, SKIP, 0, NULL},
 	{FNAME("netnum") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},
 	{FNAME("tsapIdentifier") OCTSTR, FIXD, 2, 0, SKIP, 0, NULL},
 };
 
-static field_t _UnicastAddress_iP6Address[] = {	/* SEQUENCE */
+static const struct field_t _UnicastAddress_iP6Address[] = {	/* SEQUENCE */
 	{FNAME("network") OCTSTR, FIXD, 16, 0, DECODE,
 	 offsetof(UnicastAddress_iP6Address, network), NULL},
 	{FNAME("tsapIdentifier") INT, WORD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _UnicastAddress_iPSourceRouteAddress_routing[] = {	/* CHOICE */
+static const struct field_t _UnicastAddress_iPSourceRouteAddress_routing[] = {	/* CHOICE */
 	{FNAME("strict") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("loose") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _UnicastAddress_iPSourceRouteAddress_route[] = {	/* SEQUENCE OF */
+static const struct field_t _UnicastAddress_iPSourceRouteAddress_route[] = {	/* SEQUENCE OF */
 	{FNAME("item") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},
 };
 
-static field_t _UnicastAddress_iPSourceRouteAddress[] = {	/* SEQUENCE */
+static const struct field_t _UnicastAddress_iPSourceRouteAddress[] = {	/* SEQUENCE */
 	{FNAME("routing") CHOICE, 1, 2, 2, SKIP, 0,
 	 _UnicastAddress_iPSourceRouteAddress_routing},
 	{FNAME("network") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},
@@ -662,7 +662,7 @@ static field_t _UnicastAddress_iPSourceRouteAddress[] = {	/* SEQUENCE */
 	 _UnicastAddress_iPSourceRouteAddress_route},
 };
 
-static field_t _UnicastAddress[] = {	/* CHOICE */
+static const struct field_t _UnicastAddress[] = {	/* CHOICE */
 	{FNAME("iPAddress") SEQ, 0, 2, 2, DECODE | EXT,
 	 offsetof(UnicastAddress, iPAddress), _UnicastAddress_iPAddress},
 	{FNAME("iPXAddress") SEQ, 0, 3, 3, SKIP | EXT, 0,
@@ -676,17 +676,17 @@ static field_t _UnicastAddress[] = {	/* CHOICE */
 	{FNAME("nonStandardAddress") SEQ, 0, 2, 2, SKIP, 0, NULL},
 };
 
-static field_t _MulticastAddress_iPAddress[] = {	/* SEQUENCE */
+static const struct field_t _MulticastAddress_iPAddress[] = {	/* SEQUENCE */
 	{FNAME("network") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},
 	{FNAME("tsapIdentifier") INT, WORD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _MulticastAddress_iP6Address[] = {	/* SEQUENCE */
+static const struct field_t _MulticastAddress_iP6Address[] = {	/* SEQUENCE */
 	{FNAME("network") OCTSTR, FIXD, 16, 0, SKIP, 0, NULL},
 	{FNAME("tsapIdentifier") INT, WORD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _MulticastAddress[] = {	/* CHOICE */
+static const struct field_t _MulticastAddress[] = {	/* CHOICE */
 	{FNAME("iPAddress") SEQ, 0, 2, 2, SKIP | EXT, 0,
 	 _MulticastAddress_iPAddress},
 	{FNAME("iP6Address") SEQ, 0, 2, 2, SKIP | EXT, 0,
@@ -695,14 +695,14 @@ static field_t _MulticastAddress[] = {	/* CHOICE */
 	{FNAME("nonStandardAddress") SEQ, 0, 2, 2, SKIP, 0, NULL},
 };
 
-static field_t _H245_TransportAddress[] = {	/* CHOICE */
+static const struct field_t _H245_TransportAddress[] = {	/* CHOICE */
 	{FNAME("unicastAddress") CHOICE, 3, 5, 7, DECODE | EXT,
 	 offsetof(H245_TransportAddress, unicastAddress), _UnicastAddress},
 	{FNAME("multicastAddress") CHOICE, 1, 2, 4, SKIP | EXT, 0,
 	 _MulticastAddress},
 };
 
-static field_t _H2250LogicalChannelParameters[] = {	/* SEQUENCE */
+static const struct field_t _H2250LogicalChannelParameters[] = {	/* SEQUENCE */
 	{FNAME("nonStandard") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,
 	 _H2250LogicalChannelParameters_nonStandard},
 	{FNAME("sessionID") INT, BYTE, 0, 0, SKIP, 0, NULL},
@@ -728,7 +728,7 @@ static field_t _H2250LogicalChannelParameters[] = {	/* SEQUENCE */
 	{FNAME("source") SEQ, 0, 2, 2, SKIP | EXT | OPT, 0, NULL},
 };
 
-static field_t _OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters[] = {	/* CHOICE */
+static const struct field_t _OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters[] = {	/* CHOICE */
 	{FNAME("h222LogicalChannelParameters") SEQ, 3, 5, 5, SKIP | EXT, 0,
 	 _H222LogicalChannelParameters},
 	{FNAME("h223LogicalChannelParameters") SEQ, 0, 2, 2, SKIP | EXT, 0,
@@ -742,7 +742,7 @@ static field_t _OpenLogicalChannel_forwardLogicalChannelParameters_multiplexPara
 	{FNAME("none") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _OpenLogicalChannel_forwardLogicalChannelParameters[] = {	/* SEQUENCE */
+static const struct field_t _OpenLogicalChannel_forwardLogicalChannelParameters[] = {	/* SEQUENCE */
 	{FNAME("portNumber") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("dataType") CHOICE, 3, 6, 9, DECODE | EXT,
 	 offsetof(OpenLogicalChannel_forwardLogicalChannelParameters,
@@ -756,7 +756,7 @@ static field_t _OpenLogicalChannel_forwardLogicalChannelParameters[] = {	/* SEQU
 	{FNAME("replacementFor") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters[] = {	/* CHOICE */
+static const struct field_t _OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters[] = {	/* CHOICE */
 	{FNAME("h223LogicalChannelParameters") SEQ, 0, 2, 2, SKIP | EXT, 0,
 	 _H223LogicalChannelParameters},
 	{FNAME("v76LogicalChannelParameters") SEQ, 0, 5, 5, SKIP | EXT, 0,
@@ -767,7 +767,7 @@ static field_t _OpenLogicalChannel_reverseLogicalChannelParameters_multiplexPara
 	  h2250LogicalChannelParameters), _H2250LogicalChannelParameters},
 };
 
-static field_t _OpenLogicalChannel_reverseLogicalChannelParameters[] = {	/* SEQUENCE */
+static const struct field_t _OpenLogicalChannel_reverseLogicalChannelParameters[] = {	/* SEQUENCE */
 	{FNAME("dataType") CHOICE, 3, 6, 9, SKIP | EXT, 0, _DataType},
 	{FNAME("multiplexParameters") CHOICE, 1, 2, 3, DECODE | EXT | OPT,
 	 offsetof(OpenLogicalChannel_reverseLogicalChannelParameters,
@@ -778,23 +778,23 @@ static field_t _OpenLogicalChannel_reverseLogicalChannelParameters[] = {	/* SEQU
 	{FNAME("replacementFor") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _NetworkAccessParameters_distribution[] = {	/* CHOICE */
+static const struct field_t _NetworkAccessParameters_distribution[] = {	/* CHOICE */
 	{FNAME("unicast") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("multicast") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _Q2931Address_address[] = {	/* CHOICE */
+static const struct field_t _Q2931Address_address[] = {	/* CHOICE */
 	{FNAME("internationalNumber") NUMSTR, 4, 1, 0, SKIP, 0, NULL},
 	{FNAME("nsapAddress") OCTSTR, 5, 1, 0, SKIP, 0, NULL},
 };
 
-static field_t _Q2931Address[] = {	/* SEQUENCE */
+static const struct field_t _Q2931Address[] = {	/* SEQUENCE */
 	{FNAME("address") CHOICE, 1, 2, 2, SKIP | EXT, 0,
 	 _Q2931Address_address},
 	{FNAME("subaddress") OCTSTR, 5, 1, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _NetworkAccessParameters_networkAddress[] = {	/* CHOICE */
+static const struct field_t _NetworkAccessParameters_networkAddress[] = {	/* CHOICE */
 	{FNAME("q2931Address") SEQ, 1, 2, 2, SKIP | EXT, 0, _Q2931Address},
 	{FNAME("e164Address") NUMDGT, 7, 1, 0, SKIP, 0, NULL},
 	{FNAME("localAreaAddress") CHOICE, 1, 2, 2, DECODE | EXT,
@@ -802,7 +802,7 @@ static field_t _NetworkAccessParameters_networkAddress[] = {	/* CHOICE */
 	 _H245_TransportAddress},
 };
 
-static field_t _NetworkAccessParameters[] = {	/* SEQUENCE */
+static const struct field_t _NetworkAccessParameters[] = {	/* SEQUENCE */
 	{FNAME("distribution") CHOICE, 1, 2, 2, SKIP | EXT | OPT, 0,
 	 _NetworkAccessParameters_distribution},
 	{FNAME("networkAddress") CHOICE, 2, 3, 3, DECODE | EXT,
@@ -814,7 +814,7 @@ static field_t _NetworkAccessParameters[] = {	/* SEQUENCE */
 	 NULL},
 };
 
-static field_t _OpenLogicalChannel[] = {	/* SEQUENCE */
+static const struct field_t _OpenLogicalChannel[] = {	/* SEQUENCE */
 	{FNAME("forwardLogicalChannelNumber") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("forwardLogicalChannelParameters") SEQ, 1, 3, 5, DECODE | EXT,
 	 offsetof(OpenLogicalChannel, forwardLogicalChannelParameters),
@@ -829,13 +829,13 @@ static field_t _OpenLogicalChannel[] = {	/* SEQUENCE */
 	{FNAME("encryptionSync") SEQ, 2, 4, 4, STOP | EXT | OPT, 0, NULL},
 };
 
-static field_t _Setup_UUIE_fastStart[] = {	/* SEQUENCE OF */
+static const struct field_t _Setup_UUIE_fastStart[] = {	/* SEQUENCE OF */
 	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,
 	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}
 	,
 };
 
-static field_t _Setup_UUIE[] = {	/* SEQUENCE */
+static const struct field_t _Setup_UUIE[] = {	/* SEQUENCE */
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("h245Address") CHOICE, 3, 7, 7, DECODE | EXT | OPT,
 	 offsetof(Setup_UUIE, h245Address), _TransportAddress},
@@ -894,13 +894,13 @@ static field_t _Setup_UUIE[] = {	/* SEQUENCE */
 	 NULL},
 };
 
-static field_t _CallProceeding_UUIE_fastStart[] = {	/* SEQUENCE OF */
+static const struct field_t _CallProceeding_UUIE_fastStart[] = {	/* SEQUENCE OF */
 	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,
 	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}
 	,
 };
 
-static field_t _CallProceeding_UUIE[] = {	/* SEQUENCE */
+static const struct field_t _CallProceeding_UUIE[] = {	/* SEQUENCE */
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("destinationInfo") SEQ, 6, 8, 10, SKIP | EXT, 0,
 	 _EndpointType},
@@ -920,13 +920,13 @@ static field_t _CallProceeding_UUIE[] = {	/* SEQUENCE */
 	{FNAME("featureSet") SEQ, 3, 4, 4, SKIP | EXT | OPT, 0, NULL},
 };
 
-static field_t _Connect_UUIE_fastStart[] = {	/* SEQUENCE OF */
+static const struct field_t _Connect_UUIE_fastStart[] = {	/* SEQUENCE OF */
 	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,
 	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}
 	,
 };
 
-static field_t _Connect_UUIE[] = {	/* SEQUENCE */
+static const struct field_t _Connect_UUIE[] = {	/* SEQUENCE */
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("h245Address") CHOICE, 3, 7, 7, DECODE | EXT | OPT,
 	 offsetof(Connect_UUIE, h245Address), _TransportAddress},
@@ -954,13 +954,13 @@ static field_t _Connect_UUIE[] = {	/* SEQUENCE */
 	{FNAME("featureSet") SEQ, 3, 4, 4, SKIP | EXT | OPT, 0, NULL},
 };
 
-static field_t _Alerting_UUIE_fastStart[] = {	/* SEQUENCE OF */
+static const struct field_t _Alerting_UUIE_fastStart[] = {	/* SEQUENCE OF */
 	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,
 	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}
 	,
 };
 
-static field_t _Alerting_UUIE[] = {	/* SEQUENCE */
+static const struct field_t _Alerting_UUIE[] = {	/* SEQUENCE */
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("destinationInfo") SEQ, 6, 8, 10, SKIP | EXT, 0,
 	 _EndpointType},
@@ -986,7 +986,7 @@ static field_t _Alerting_UUIE[] = {	/* SEQUENCE */
 	{FNAME("featureSet") SEQ, 3, 4, 4, SKIP | EXT | OPT, 0, NULL},
 };
 
-static field_t _Information_UUIE[] = {	/* SEQUENCE */
+static const struct field_t _Information_UUIE[] = {	/* SEQUENCE */
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("callIdentifier") SEQ, 0, 1, 1, SKIP | EXT, 0, NULL},
 	{FNAME("tokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},
@@ -996,7 +996,7 @@ static field_t _Information_UUIE[] = {	/* SEQUENCE */
 	{FNAME("circuitInfo") SEQ, 3, 3, 3, SKIP | EXT | OPT, 0, NULL},
 };
 
-static field_t _ReleaseCompleteReason[] = {	/* CHOICE */
+static const struct field_t _ReleaseCompleteReason[] = {	/* CHOICE */
 	{FNAME("noBandwidth") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("gatekeeperResources") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("unreachableDestination") NUL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -1022,7 +1022,7 @@ static field_t _ReleaseCompleteReason[] = {	/* CHOICE */
 	{FNAME("tunnelledSignallingRejected") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _ReleaseComplete_UUIE[] = {	/* SEQUENCE */
+static const struct field_t _ReleaseComplete_UUIE[] = {	/* SEQUENCE */
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("reason") CHOICE, 4, 12, 22, SKIP | EXT | OPT, 0,
 	 _ReleaseCompleteReason},
@@ -1039,11 +1039,11 @@ static field_t _ReleaseComplete_UUIE[] = {	/* SEQUENCE */
 	{FNAME("featureSet") SEQ, 3, 4, 4, SKIP | EXT | OPT, 0, NULL},
 };
 
-static field_t _Facility_UUIE_alternativeAliasAddress[] = {	/* SEQUENCE OF */
+static const struct field_t _Facility_UUIE_alternativeAliasAddress[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 };
 
-static field_t _FacilityReason[] = {	/* CHOICE */
+static const struct field_t _FacilityReason[] = {	/* CHOICE */
 	{FNAME("routeCallToGatekeeper") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("callForwarded") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("routeCallToMC") NUL, FIXD, 0, 0, SKIP, 0, NULL},
@@ -1057,13 +1057,13 @@ static field_t _FacilityReason[] = {	/* CHOICE */
 	{FNAME("transportedInformation") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _Facility_UUIE_fastStart[] = {	/* SEQUENCE OF */
+static const struct field_t _Facility_UUIE_fastStart[] = {	/* SEQUENCE OF */
 	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,
 	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}
 	,
 };
 
-static field_t _Facility_UUIE[] = {	/* SEQUENCE */
+static const struct field_t _Facility_UUIE[] = {	/* SEQUENCE */
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("alternativeAddress") CHOICE, 3, 7, 7, DECODE | EXT | OPT,
 	 offsetof(Facility_UUIE, alternativeAddress), _TransportAddress},
@@ -1094,17 +1094,17 @@ static field_t _Facility_UUIE[] = {	/* SEQUENCE */
 	 NULL},
 };
 
-static field_t _CallIdentifier[] = {	/* SEQUENCE */
+static const struct field_t _CallIdentifier[] = {	/* SEQUENCE */
 	{FNAME("guid") OCTSTR, FIXD, 16, 0, SKIP, 0, NULL},
 };
 
-static field_t _SecurityServiceMode[] = {	/* CHOICE */
+static const struct field_t _SecurityServiceMode[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0, _NonStandardParameter},
 	{FNAME("none") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("default") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _SecurityCapabilities[] = {	/* SEQUENCE */
+static const struct field_t _SecurityCapabilities[] = {	/* SEQUENCE */
 	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("encryption") CHOICE, 2, 3, 3, SKIP | EXT, 0,
@@ -1115,30 +1115,30 @@ static field_t _SecurityCapabilities[] = {	/* SEQUENCE */
 	 _SecurityServiceMode},
 };
 
-static field_t _H245Security[] = {	/* CHOICE */
+static const struct field_t _H245Security[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0, _NonStandardParameter},
 	{FNAME("noSecurity") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("tls") SEQ, 1, 4, 4, SKIP | EXT, 0, _SecurityCapabilities},
 	{FNAME("ipsec") SEQ, 1, 4, 4, SKIP | EXT, 0, _SecurityCapabilities},
 };
 
-static field_t _DHset[] = {	/* SEQUENCE */
+static const struct field_t _DHset[] = {	/* SEQUENCE */
 	{FNAME("halfkey") BITSTR, WORD, 0, 0, SKIP, 0, NULL},
 	{FNAME("modSize") BITSTR, WORD, 0, 0, SKIP, 0, NULL},
 	{FNAME("generator") BITSTR, WORD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _TypedCertificate[] = {	/* SEQUENCE */
+static const struct field_t _TypedCertificate[] = {	/* SEQUENCE */
 	{FNAME("type") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("certificate") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _H235_NonStandardParameter[] = {	/* SEQUENCE */
+static const struct field_t _H235_NonStandardParameter[] = {	/* SEQUENCE */
 	{FNAME("nonStandardIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("data") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _ClearToken[] = {	/* SEQUENCE */
+static const struct field_t _ClearToken[] = {	/* SEQUENCE */
 	{FNAME("tokenOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("timeStamp") INT, CONS, 1, 0, SKIP | OPT, 0, NULL},
 	{FNAME("password") BMPSTR, 7, 1, 0, SKIP | OPT, 0, NULL},
@@ -1154,120 +1154,120 @@ static field_t _ClearToken[] = {	/* SEQUENCE */
 	{FNAME("sendersID") BMPSTR, 7, 1, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _Progress_UUIE_tokens[] = {	/* SEQUENCE OF */
+static const struct field_t _Progress_UUIE_tokens[] = {	/* SEQUENCE OF */
 	{FNAME("item") SEQ, 8, 9, 11, SKIP | EXT, 0, _ClearToken},
 };
 
-static field_t _Params[] = {	/* SEQUENCE */
+static const struct field_t _Params[] = {	/* SEQUENCE */
 	{FNAME("ranInt") INT, UNCO, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("iv8") OCTSTR, FIXD, 8, 0, SKIP | OPT, 0, NULL},
 	{FNAME("iv16") OCTSTR, FIXD, 16, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _CryptoH323Token_cryptoEPPwdHash_token[] = {	/* SEQUENCE */
+static const struct field_t _CryptoH323Token_cryptoEPPwdHash_token[] = {	/* SEQUENCE */
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("hash") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoH323Token_cryptoEPPwdHash[] = {	/* SEQUENCE */
+static const struct field_t _CryptoH323Token_cryptoEPPwdHash[] = {	/* SEQUENCE */
 	{FNAME("alias") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 	{FNAME("timeStamp") INT, CONS, 1, 0, SKIP, 0, NULL},
 	{FNAME("token") SEQ, 0, 3, 3, SKIP, 0,
 	 _CryptoH323Token_cryptoEPPwdHash_token},
 };
 
-static field_t _CryptoH323Token_cryptoGKPwdHash_token[] = {	/* SEQUENCE */
+static const struct field_t _CryptoH323Token_cryptoGKPwdHash_token[] = {	/* SEQUENCE */
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("hash") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoH323Token_cryptoGKPwdHash[] = {	/* SEQUENCE */
+static const struct field_t _CryptoH323Token_cryptoGKPwdHash[] = {	/* SEQUENCE */
 	{FNAME("gatekeeperId") BMPSTR, 7, 1, 0, SKIP, 0, NULL},
 	{FNAME("timeStamp") INT, CONS, 1, 0, SKIP, 0, NULL},
 	{FNAME("token") SEQ, 0, 3, 3, SKIP, 0,
 	 _CryptoH323Token_cryptoGKPwdHash_token},
 };
 
-static field_t _CryptoH323Token_cryptoEPPwdEncr[] = {	/* SEQUENCE */
+static const struct field_t _CryptoH323Token_cryptoEPPwdEncr[] = {	/* SEQUENCE */
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("encryptedData") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoH323Token_cryptoGKPwdEncr[] = {	/* SEQUENCE */
+static const struct field_t _CryptoH323Token_cryptoGKPwdEncr[] = {	/* SEQUENCE */
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("encryptedData") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoH323Token_cryptoEPCert[] = {	/* SEQUENCE */
+static const struct field_t _CryptoH323Token_cryptoEPCert[] = {	/* SEQUENCE */
 	{FNAME("toBeSigned") SEQ, 8, 9, 11, SKIP | OPEN | EXT, 0, NULL},
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("signature") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoH323Token_cryptoGKCert[] = {	/* SEQUENCE */
+static const struct field_t _CryptoH323Token_cryptoGKCert[] = {	/* SEQUENCE */
 	{FNAME("toBeSigned") SEQ, 8, 9, 11, SKIP | OPEN | EXT, 0, NULL},
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("signature") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoH323Token_cryptoFastStart[] = {	/* SEQUENCE */
+static const struct field_t _CryptoH323Token_cryptoFastStart[] = {	/* SEQUENCE */
 	{FNAME("toBeSigned") SEQ, 8, 9, 11, SKIP | OPEN | EXT, 0, NULL},
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("signature") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoToken_cryptoEncryptedToken_token[] = {	/* SEQUENCE */
+static const struct field_t _CryptoToken_cryptoEncryptedToken_token[] = {	/* SEQUENCE */
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("encryptedData") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoToken_cryptoEncryptedToken[] = {	/* SEQUENCE */
+static const struct field_t _CryptoToken_cryptoEncryptedToken[] = {	/* SEQUENCE */
 	{FNAME("tokenOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("token") SEQ, 0, 3, 3, SKIP, 0,
 	 _CryptoToken_cryptoEncryptedToken_token},
 };
 
-static field_t _CryptoToken_cryptoSignedToken_token[] = {	/* SEQUENCE */
+static const struct field_t _CryptoToken_cryptoSignedToken_token[] = {	/* SEQUENCE */
 	{FNAME("toBeSigned") SEQ, 8, 9, 11, SKIP | OPEN | EXT, 0, NULL},
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("signature") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoToken_cryptoSignedToken[] = {	/* SEQUENCE */
+static const struct field_t _CryptoToken_cryptoSignedToken[] = {	/* SEQUENCE */
 	{FNAME("tokenOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("token") SEQ, 0, 4, 4, SKIP, 0,
 	 _CryptoToken_cryptoSignedToken_token},
 };
 
-static field_t _CryptoToken_cryptoHashedToken_token[] = {	/* SEQUENCE */
+static const struct field_t _CryptoToken_cryptoHashedToken_token[] = {	/* SEQUENCE */
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("hash") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoToken_cryptoHashedToken[] = {	/* SEQUENCE */
+static const struct field_t _CryptoToken_cryptoHashedToken[] = {	/* SEQUENCE */
 	{FNAME("tokenOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("hashedVals") SEQ, 8, 9, 11, SKIP | EXT, 0, _ClearToken},
 	{FNAME("token") SEQ, 0, 3, 3, SKIP, 0,
 	 _CryptoToken_cryptoHashedToken_token},
 };
 
-static field_t _CryptoToken_cryptoPwdEncr[] = {	/* SEQUENCE */
+static const struct field_t _CryptoToken_cryptoPwdEncr[] = {	/* SEQUENCE */
 	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},
 	{FNAME("encryptedData") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _CryptoToken[] = {	/* CHOICE */
+static const struct field_t _CryptoToken[] = {	/* CHOICE */
 	{FNAME("cryptoEncryptedToken") SEQ, 0, 2, 2, SKIP, 0,
 	 _CryptoToken_cryptoEncryptedToken},
 	{FNAME("cryptoSignedToken") SEQ, 0, 2, 2, SKIP, 0,
@@ -1278,7 +1278,7 @@ static field_t _CryptoToken[] = {	/* CHOICE */
 	 _CryptoToken_cryptoPwdEncr},
 };
 
-static field_t _CryptoH323Token[] = {	/* CHOICE */
+static const struct field_t _CryptoH323Token[] = {	/* CHOICE */
 	{FNAME("cryptoEPPwdHash") SEQ, 0, 3, 3, SKIP, 0,
 	 _CryptoH323Token_cryptoEPPwdHash},
 	{FNAME("cryptoGKPwdHash") SEQ, 0, 3, 3, SKIP, 0,
@@ -1297,17 +1297,17 @@ static field_t _CryptoH323Token[] = {	/* CHOICE */
 	 _CryptoToken},
 };
 
-static field_t _Progress_UUIE_cryptoTokens[] = {	/* SEQUENCE OF */
+static const struct field_t _Progress_UUIE_cryptoTokens[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 3, 8, 8, SKIP | EXT, 0, _CryptoH323Token},
 };
 
-static field_t _Progress_UUIE_fastStart[] = {	/* SEQUENCE OF */
+static const struct field_t _Progress_UUIE_fastStart[] = {	/* SEQUENCE OF */
 	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,
 	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}
 	,
 };
 
-static field_t _Progress_UUIE[] = {	/* SEQUENCE */
+static const struct field_t _Progress_UUIE[] = {	/* SEQUENCE */
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("destinationInfo") SEQ, 6, 8, 10, SKIP | EXT, 0,
 	 _EndpointType},
@@ -1328,7 +1328,7 @@ static field_t _Progress_UUIE[] = {	/* SEQUENCE */
 	{FNAME("fastConnectRefused") NUL, FIXD, 0, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _H323_UU_PDU_h323_message_body[] = {	/* CHOICE */
+static const struct field_t _H323_UU_PDU_h323_message_body[] = {	/* CHOICE */
 	{FNAME("setup") SEQ, 7, 13, 39, DECODE | EXT,
 	 offsetof(H323_UU_PDU_h323_message_body, setup), _Setup_UUIE},
 	{FNAME("callProceeding") SEQ, 1, 3, 12, DECODE | EXT,
@@ -1352,7 +1352,7 @@ static field_t _H323_UU_PDU_h323_message_body[] = {	/* CHOICE */
 	{FNAME("notify") SEQ, 2, 4, 4, SKIP | EXT, 0, NULL},
 };
 
-static field_t _RequestMessage[] = {	/* CHOICE */
+static const struct field_t _RequestMessage[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},
 	{FNAME("masterSlaveDetermination") SEQ, 0, 2, 2, STOP | EXT, 0, NULL},
 	{FNAME("terminalCapabilitySet") SEQ, 3, 5, 5, STOP | EXT, 0, NULL},
@@ -1372,7 +1372,7 @@ static field_t _RequestMessage[] = {	/* CHOICE */
 	 NULL},
 };
 
-static field_t _OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters[] = {	/* CHOICE */
+static const struct field_t _OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters[] = {	/* CHOICE */
 	{FNAME("h222LogicalChannelParameters") SEQ, 3, 5, 5, SKIP | EXT, 0,
 	 _H222LogicalChannelParameters},
 	{FNAME("h2250LogicalChannelParameters") SEQ, 10, 11, 14, DECODE | EXT,
@@ -1381,7 +1381,7 @@ static field_t _OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexP
 	  h2250LogicalChannelParameters), _H2250LogicalChannelParameters},
 };
 
-static field_t _OpenLogicalChannelAck_reverseLogicalChannelParameters[] = {	/* SEQUENCE */
+static const struct field_t _OpenLogicalChannelAck_reverseLogicalChannelParameters[] = {	/* SEQUENCE */
 	{FNAME("reverseLogicalChannelNumber") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("portNumber") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},
 	{FNAME("multiplexParameters") CHOICE, 0, 1, 2, DECODE | EXT | OPT,
@@ -1391,11 +1391,11 @@ static field_t _OpenLogicalChannelAck_reverseLogicalChannelParameters[] = {	/* S
 	{FNAME("replacementFor") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _H2250LogicalChannelAckParameters_nonStandard[] = {	/* SEQUENCE OF */
+static const struct field_t _H2250LogicalChannelAckParameters_nonStandard[] = {	/* SEQUENCE OF */
 	{FNAME("item") SEQ, 0, 2, 2, SKIP, 0, _H245_NonStandardParameter},
 };
 
-static field_t _H2250LogicalChannelAckParameters[] = {	/* SEQUENCE */
+static const struct field_t _H2250LogicalChannelAckParameters[] = {	/* SEQUENCE */
 	{FNAME("nonStandard") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,
 	 _H2250LogicalChannelAckParameters_nonStandard},
 	{FNAME("sessionID") INT, 8, 1, 0, SKIP | OPT, 0, NULL},
@@ -1410,14 +1410,14 @@ static field_t _H2250LogicalChannelAckParameters[] = {	/* SEQUENCE */
 	{FNAME("portNumber") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},
 };
 
-static field_t _OpenLogicalChannelAck_forwardMultiplexAckParameters[] = {	/* CHOICE */
+static const struct field_t _OpenLogicalChannelAck_forwardMultiplexAckParameters[] = {	/* CHOICE */
 	{FNAME("h2250LogicalChannelAckParameters") SEQ, 5, 5, 7, DECODE | EXT,
 	 offsetof(OpenLogicalChannelAck_forwardMultiplexAckParameters,
 		  h2250LogicalChannelAckParameters),
 	 _H2250LogicalChannelAckParameters},
 };
 
-static field_t _OpenLogicalChannelAck[] = {	/* SEQUENCE */
+static const struct field_t _OpenLogicalChannelAck[] = {	/* SEQUENCE */
 	{FNAME("forwardLogicalChannelNumber") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("reverseLogicalChannelParameters") SEQ, 2, 3, 4,
 	 DECODE | EXT | OPT, offsetof(OpenLogicalChannelAck,
@@ -1433,7 +1433,7 @@ static field_t _OpenLogicalChannelAck[] = {	/* SEQUENCE */
 	{FNAME("encryptionSync") SEQ, 2, 4, 4, STOP | EXT | OPT, 0, NULL},
 };
 
-static field_t _ResponseMessage[] = {	/* CHOICE */
+static const struct field_t _ResponseMessage[] = {	/* CHOICE */
 	{FNAME("nonStandard") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},
 	{FNAME("masterSlaveDeterminationAck") SEQ, 0, 1, 1, STOP | EXT, 0,
 	 NULL},
@@ -1469,7 +1469,7 @@ static field_t _ResponseMessage[] = {	/* CHOICE */
 	{FNAME("logicalChannelRateReject") SEQ, 1, 4, 4, STOP | EXT, 0, NULL},
 };
 
-static field_t _MultimediaSystemControlMessage[] = {	/* CHOICE */
+static const struct field_t _MultimediaSystemControlMessage[] = {	/* CHOICE */
 	{FNAME("request") CHOICE, 4, 11, 15, DECODE | EXT,
 	 offsetof(MultimediaSystemControlMessage, request), _RequestMessage},
 	{FNAME("response") CHOICE, 5, 19, 24, DECODE | EXT,
@@ -1479,14 +1479,14 @@ static field_t _MultimediaSystemControlMessage[] = {	/* CHOICE */
 	{FNAME("indication") CHOICE, 4, 14, 23, STOP | EXT, 0, NULL},
 };
 
-static field_t _H323_UU_PDU_h245Control[] = {	/* SEQUENCE OF */
+static const struct field_t _H323_UU_PDU_h245Control[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 2, 4, 4, DECODE | OPEN | EXT,
 	 sizeof(MultimediaSystemControlMessage),
 	 _MultimediaSystemControlMessage}
 	,
 };
 
-static field_t _H323_UU_PDU[] = {	/* SEQUENCE */
+static const struct field_t _H323_UU_PDU[] = {	/* SEQUENCE */
 	{FNAME("h323-message-body") CHOICE, 3, 7, 13, DECODE | EXT,
 	 offsetof(H323_UU_PDU, h323_message_body),
 	 _H323_UU_PDU_h323_message_body},
@@ -1507,13 +1507,13 @@ static field_t _H323_UU_PDU[] = {	/* SEQUENCE */
 	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},
 };
 
-static field_t _H323_UserInformation[] = {	/* SEQUENCE */
+static const struct field_t _H323_UserInformation[] = {	/* SEQUENCE */
 	{FNAME("h323-uu-pdu") SEQ, 1, 2, 11, DECODE | EXT,
 	 offsetof(H323_UserInformation, h323_uu_pdu), _H323_UU_PDU},
 	{FNAME("user-data") SEQ, 0, 2, 2, STOP | EXT | OPT, 0, NULL},
 };
 
-static field_t _GatekeeperRequest[] = {	/* SEQUENCE */
+static const struct field_t _GatekeeperRequest[] = {	/* SEQUENCE */
 	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
@@ -1537,7 +1537,7 @@ static field_t _GatekeeperRequest[] = {	/* SEQUENCE */
 	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},
 };
 
-static field_t _GatekeeperConfirm[] = {	/* SEQUENCE */
+static const struct field_t _GatekeeperConfirm[] = {	/* SEQUENCE */
 	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
@@ -1557,23 +1557,23 @@ static field_t _GatekeeperConfirm[] = {	/* SEQUENCE */
 	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},
 };
 
-static field_t _RegistrationRequest_callSignalAddress[] = {	/* SEQUENCE OF */
+static const struct field_t _RegistrationRequest_callSignalAddress[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 3, 7, 7, DECODE | EXT,
 	 sizeof(TransportAddress), _TransportAddress}
 	,
 };
 
-static field_t _RegistrationRequest_rasAddress[] = {	/* SEQUENCE OF */
+static const struct field_t _RegistrationRequest_rasAddress[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 3, 7, 7, DECODE | EXT,
 	 sizeof(TransportAddress), _TransportAddress}
 	,
 };
 
-static field_t _RegistrationRequest_terminalAlias[] = {	/* SEQUENCE OF */
+static const struct field_t _RegistrationRequest_terminalAlias[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 };
 
-static field_t _RegistrationRequest[] = {	/* SEQUENCE */
+static const struct field_t _RegistrationRequest[] = {	/* SEQUENCE */
 	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
@@ -1621,17 +1621,17 @@ static field_t _RegistrationRequest[] = {	/* SEQUENCE */
 	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},
 };
 
-static field_t _RegistrationConfirm_callSignalAddress[] = {	/* SEQUENCE OF */
+static const struct field_t _RegistrationConfirm_callSignalAddress[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 3, 7, 7, DECODE | EXT,
 	 sizeof(TransportAddress), _TransportAddress}
 	,
 };
 
-static field_t _RegistrationConfirm_terminalAlias[] = {	/* SEQUENCE OF */
+static const struct field_t _RegistrationConfirm_terminalAlias[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 };
 
-static field_t _RegistrationConfirm[] = {	/* SEQUENCE */
+static const struct field_t _RegistrationConfirm[] = {	/* SEQUENCE */
 	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
@@ -1667,13 +1667,13 @@ static field_t _RegistrationConfirm[] = {	/* SEQUENCE */
 	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},
 };
 
-static field_t _UnregistrationRequest_callSignalAddress[] = {	/* SEQUENCE OF */
+static const struct field_t _UnregistrationRequest_callSignalAddress[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 3, 7, 7, DECODE | EXT,
 	 sizeof(TransportAddress), _TransportAddress}
 	,
 };
 
-static field_t _UnregistrationRequest[] = {	/* SEQUENCE */
+static const struct field_t _UnregistrationRequest[] = {	/* SEQUENCE */
 	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("callSignalAddress") SEQOF, SEMI, 0, 10, DECODE,
 	 offsetof(UnregistrationRequest, callSignalAddress),
@@ -1694,24 +1694,24 @@ static field_t _UnregistrationRequest[] = {	/* SEQUENCE */
 	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},
 };
 
-static field_t _CallModel[] = {	/* CHOICE */
+static const struct field_t _CallModel[] = {	/* CHOICE */
 	{FNAME("direct") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 	{FNAME("gatekeeperRouted") NUL, FIXD, 0, 0, SKIP, 0, NULL},
 };
 
-static field_t _AdmissionRequest_destinationInfo[] = {	/* SEQUENCE OF */
+static const struct field_t _AdmissionRequest_destinationInfo[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 };
 
-static field_t _AdmissionRequest_destExtraCallInfo[] = {	/* SEQUENCE OF */
+static const struct field_t _AdmissionRequest_destExtraCallInfo[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 };
 
-static field_t _AdmissionRequest_srcInfo[] = {	/* SEQUENCE OF */
+static const struct field_t _AdmissionRequest_srcInfo[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 };
 
-static field_t _AdmissionRequest[] = {	/* SEQUENCE */
+static const struct field_t _AdmissionRequest[] = {	/* SEQUENCE */
 	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("callType") CHOICE, 2, 4, 4, SKIP | EXT, 0, _CallType},
 	{FNAME("callModel") CHOICE, 1, 2, 2, SKIP | EXT | OPT, 0, _CallModel},
@@ -1755,7 +1755,7 @@ static field_t _AdmissionRequest[] = {	/* SEQUENCE */
 	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},
 };
 
-static field_t _AdmissionConfirm[] = {	/* SEQUENCE */
+static const struct field_t _AdmissionConfirm[] = {	/* SEQUENCE */
 	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("bandWidth") INT, CONS, 0, 0, SKIP, 0, NULL},
 	{FNAME("callModel") CHOICE, 1, 2, 2, SKIP | EXT, 0, _CallModel},
@@ -1790,11 +1790,11 @@ static field_t _AdmissionConfirm[] = {	/* SEQUENCE */
 	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},
 };
 
-static field_t _LocationRequest_destinationInfo[] = {	/* SEQUENCE OF */
+static const struct field_t _LocationRequest_destinationInfo[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},
 };
 
-static field_t _LocationRequest[] = {	/* SEQUENCE */
+static const struct field_t _LocationRequest[] = {	/* SEQUENCE */
 	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("endpointIdentifier") BMPSTR, 7, 1, 0, SKIP | OPT, 0, NULL},
 	{FNAME("destinationInfo") SEQOF, SEMI, 0, 0, SKIP, 0,
@@ -1818,7 +1818,7 @@ static field_t _LocationRequest[] = {	/* SEQUENCE */
 	{FNAME("circuitInfo") SEQ, 3, 3, 3, STOP | EXT | OPT, 0, NULL},
 };
 
-static field_t _LocationConfirm[] = {	/* SEQUENCE */
+static const struct field_t _LocationConfirm[] = {	/* SEQUENCE */
 	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},
 	{FNAME("callSignalAddress") CHOICE, 3, 7, 7, DECODE | EXT,
 	 offsetof(LocationConfirm, callSignalAddress), _TransportAddress},
@@ -1844,13 +1844,13 @@ static field_t _LocationConfirm[] = {	/* SEQUENCE */
 	{FNAME("serviceControl") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},
 };
 
-static field_t _InfoRequestResponse_callSignalAddress[] = {	/* SEQUENCE OF */
+static const struct field_t _InfoRequestResponse_callSignalAddress[] = {	/* SEQUENCE OF */
 	{FNAME("item") CHOICE, 3, 7, 7, DECODE | EXT,
 	 sizeof(TransportAddress), _TransportAddress}
 	,
 };
 
-static field_t _InfoRequestResponse[] = {	/* SEQUENCE */
+static const struct field_t _InfoRequestResponse[] = {	/* SEQUENCE */
 	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,
 	 _NonStandardParameter},
 	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},
@@ -1873,7 +1873,7 @@ static field_t _InfoRequestResponse[] = {	/* SEQUENCE */
 	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},
 };
 
-static field_t _RasMessage[] = {	/* CHOICE */
+static const struct field_t _RasMessage[] = {	/* CHOICE */
 	{FNAME("gatekeeperRequest") SEQ, 4, 8, 18, DECODE | EXT,
 	 offsetof(RasMessage, gatekeeperRequest), _GatekeeperRequest},
 	{FNAME("gatekeeperConfirm") SEQ, 2, 5, 14, DECODE | EXT,
-- 
1.5.3.4

