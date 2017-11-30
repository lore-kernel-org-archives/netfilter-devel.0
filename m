From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nf-next] net: netfilter: nf_conntrack_h323: Remove unwanted comments.
Date: Thu, 30 Nov 2017 19:34:36 +0530
Message-ID: <20171130140436.22047-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:33785 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdK3OFq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 09:05:46 -0500
Received: by mail-pl0-f65.google.com with SMTP id q7so4314306plk.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Nov 2017 06:05:46 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Change old multi-line comment style to kernel comment style and
remove unwanted comments.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 37 +++++++-------------------
 net/netfilter/nf_conntrack_h323_main.c | 47 +++-------------------------------
 2 files changed, 13 insertions(+), 71 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 38cf5e4f30bd..1601275efe2d 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -1,4 +1,4 @@
-/****************************************************************************
+/*
  * ip_conntrack_helper_h323_asn1.c - BER and PER decoding library for H.323
  * 			      	     conntrack/NAT module.
  *
@@ -8,7 +8,7 @@
  *
  * See ip_conntrack_helper_h323_asn1.h for details.
  *
- ****************************************************************************/
+ */
 
 #ifdef __KERNEL__
 #include <linux/kernel.h>
@@ -140,14 +140,15 @@ static const decoder_t Decoders[] = {
 	decode_choice,
 };
 
-/****************************************************************************
+/*
  * H.323 Types
- ****************************************************************************/
+ */
 #include "nf_conntrack_h323_types.c"
 
-/****************************************************************************
+/*
  * Functions
- ****************************************************************************/
+ */
+
 /* Assume bs is aligned && v < 16384 */
 static unsigned int get_len(struct bitstr *bs)
 {
@@ -177,7 +178,6 @@ static int nf_h323_error_boundary(struct bitstr *bs, size_t bytes, size_t bits)
 	return 0;
 }
 
-/****************************************************************************/
 static unsigned int get_bit(struct bitstr *bs)
 {
 	unsigned int b = (*bs->cur) & (0x80 >> bs->bit);
@@ -187,7 +187,6 @@ static unsigned int get_bit(struct bitstr *bs)
 	return b;
 }
 
-/****************************************************************************/
 /* Assume b <= 8 */
 static unsigned int get_bits(struct bitstr *bs, unsigned int b)
 {
@@ -213,7 +212,6 @@ static unsigned int get_bits(struct bitstr *bs, unsigned int b)
 	return v;
 }
 
-/****************************************************************************/
 /* Assume b <= 32 */
 static unsigned int get_bitmap(struct bitstr *bs, unsigned int b)
 {
@@ -251,9 +249,9 @@ static unsigned int get_bitmap(struct bitstr *bs, unsigned int b)
 	return v;
 }
 
-/****************************************************************************
+/*
  * Assume bs is aligned and sizeof(unsigned int) == 4
- ****************************************************************************/
+ */
 static unsigned int get_uint(struct bitstr *bs, int b)
 {
 	unsigned int v = 0;
@@ -278,7 +276,6 @@ static unsigned int get_uint(struct bitstr *bs, int b)
 	return v;
 }
 
-/****************************************************************************/
 static int decode_nul(struct bitstr *bs, const struct field_t *f,
                       char *base, int level)
 {
@@ -287,7 +284,6 @@ static int decode_nul(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 static int decode_bool(struct bitstr *bs, const struct field_t *f,
                        char *base, int level)
 {
@@ -299,7 +295,6 @@ static int decode_bool(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 static int decode_oid(struct bitstr *bs, const struct field_t *f,
                       char *base, int level)
 {
@@ -319,7 +314,6 @@ static int decode_oid(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 static int decode_int(struct bitstr *bs, const struct field_t *f,
                       char *base, int level)
 {
@@ -367,7 +361,6 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 static int decode_enum(struct bitstr *bs, const struct field_t *f,
                        char *base, int level)
 {
@@ -384,7 +377,6 @@ static int decode_enum(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 static int decode_bitstr(struct bitstr *bs, const struct field_t *f,
                          char *base, int level)
 {
@@ -421,7 +413,6 @@ static int decode_bitstr(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 static int decode_numstr(struct bitstr *bs, const struct field_t *f,
                          char *base, int level)
 {
@@ -442,7 +433,6 @@ static int decode_numstr(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 static int decode_octstr(struct bitstr *bs, const struct field_t *f,
                          char *base, int level)
 {
@@ -496,7 +486,6 @@ static int decode_octstr(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 static int decode_bmpstr(struct bitstr *bs, const struct field_t *f,
                          char *base, int level)
 {
@@ -526,7 +515,6 @@ static int decode_bmpstr(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 static int decode_seq(struct bitstr *bs, const struct field_t *f,
                       char *base, int level)
 {
@@ -656,7 +644,6 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 static int decode_seqof(struct bitstr *bs, const struct field_t *f,
                         char *base, int level)
 {
@@ -753,8 +740,6 @@ static int decode_seqof(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-
-/****************************************************************************/
 static int decode_choice(struct bitstr *bs, const struct field_t *f,
                          char *base, int level)
 {
@@ -836,7 +821,6 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
 	return H323_ERROR_NONE;
 }
 
-/****************************************************************************/
 int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage *ras)
 {
 	static const struct field_t ras_message = {
@@ -852,7 +836,6 @@ int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage *ras)
 	return decode_choice(&bs, &ras_message, (char *) ras, 0);
 }
 
-/****************************************************************************/
 static int DecodeH323_UserInformation(unsigned char *buf, unsigned char *beg,
 				      size_t sz, H323_UserInformation *uuie)
 {
@@ -870,7 +853,6 @@ static int DecodeH323_UserInformation(unsigned char *buf, unsigned char *beg,
 	return decode_seq(&bs, &h323_userinformation, (char *) uuie, 0);
 }
 
-/****************************************************************************/
 int DecodeMultimediaSystemControlMessage(unsigned char *buf, size_t sz,
 					 MultimediaSystemControlMessage *
 					 mscm)
@@ -889,7 +871,6 @@ int DecodeMultimediaSystemControlMessage(unsigned char *buf, size_t sz,
 			     (char *) mscm, 0);
 }
 
-/****************************************************************************/
 int DecodeQ931(unsigned char *buf, size_t sz, Q931 *q931)
 {
 	unsigned char *p = buf;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index f71f0d2558fd..7f0e0f66e488 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -115,7 +115,6 @@ static struct nf_conntrack_helper nf_conntrack_helper_h245;
 static struct nf_conntrack_helper nf_conntrack_helper_q931[];
 static struct nf_conntrack_helper nf_conntrack_helper_ras[];
 
-/****************************************************************************/
 static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 			 struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			 unsigned char **data, int *datalen, int *dataoff)
@@ -219,7 +218,6 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 	return 0;
 }
 
-/****************************************************************************/
 static int get_h245_addr(struct nf_conn *ct, const unsigned char *data,
 			 H245_TransportAddress *taddr,
 			 union nf_inet_addr *addr, __be16 *port)
@@ -254,7 +252,6 @@ static int get_h245_addr(struct nf_conn *ct, const unsigned char *data,
 	return 1;
 }
 
-/****************************************************************************/
 static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 			   enum ip_conntrack_info ctinfo,
 			   unsigned int protoff,
@@ -328,7 +325,6 @@ static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 	return ret;
 }
 
-/****************************************************************************/
 static int expect_t120(struct sk_buff *skb,
 		       struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
@@ -380,7 +376,6 @@ static int expect_t120(struct sk_buff *skb,
 	return ret;
 }
 
-/****************************************************************************/
 static int process_h245_channel(struct sk_buff *skb,
 				struct nf_conn *ct,
 				enum ip_conntrack_info ctinfo,
@@ -410,7 +405,6 @@ static int process_h245_channel(struct sk_buff *skb,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_olc(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -472,7 +466,6 @@ static int process_olc(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_olca(struct sk_buff *skb, struct nf_conn *ct,
 			enum ip_conntrack_info ctinfo,
 			unsigned int protoff, unsigned char **data, int dataoff,
@@ -542,7 +535,6 @@ static int process_olca(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_h245(struct sk_buff *skb, struct nf_conn *ct,
 			enum ip_conntrack_info ctinfo,
 			unsigned int protoff, unsigned char **data, int dataoff,
@@ -578,7 +570,6 @@ static int process_h245(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int h245_help(struct sk_buff *skb, unsigned int protoff,
 		     struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
@@ -628,7 +619,6 @@ static int h245_help(struct sk_buff *skb, unsigned int protoff,
 	return NF_DROP;
 }
 
-/****************************************************************************/
 static const struct nf_conntrack_expect_policy h245_exp_policy = {
 	.max_expected	= H323_RTP_CHANNEL_MAX * 4 + 2 /* T.120 */,
 	.timeout	= 240,
@@ -643,7 +633,6 @@ static struct nf_conntrack_helper nf_conntrack_helper_h245 __read_mostly = {
 	.expect_policy		= &h245_exp_policy,
 };
 
-/****************************************************************************/
 int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 		  TransportAddress *taddr,
 		  union nf_inet_addr *addr, __be16 *port)
@@ -675,7 +664,6 @@ int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 	return 1;
 }
 
-/****************************************************************************/
 static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff, unsigned char **data, int dataoff,
@@ -726,7 +714,8 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 }
 
 /* If the calling party is on the same side of the forward-to party,
- * we don't need to track the second call */
+ * we don't need to track the second call
+ */
 static int callforward_do_filter(struct net *net,
 				 const union nf_inet_addr *src,
 				 const union nf_inet_addr *dst,
@@ -794,7 +783,6 @@ static int callforward_do_filter(struct net *net,
 
 }
 
-/****************************************************************************/
 static int expect_callforwarding(struct sk_buff *skb,
 				 struct nf_conn *ct,
 				 enum ip_conntrack_info ctinfo,
@@ -815,7 +803,8 @@ static int expect_callforwarding(struct sk_buff *skb,
 		return 0;
 
 	/* If the calling party is on the same side of the forward-to party,
-	 * we don't need to track the second call */
+	 * we don't need to track the second call
+	 */
 	if (callforward_filter &&
 	    callforward_do_filter(net, &addr, &ct->tuplehash[!dir].tuple.src.u3,
 				  nf_ct_l3num(ct))) {
@@ -854,7 +843,6 @@ static int expect_callforwarding(struct sk_buff *skb,
 	return ret;
 }
 
-/****************************************************************************/
 static int process_setup(struct sk_buff *skb, struct nf_conn *ct,
 			 enum ip_conntrack_info ctinfo,
 			 unsigned int protoff,
@@ -925,7 +913,6 @@ static int process_setup(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_callproceeding(struct sk_buff *skb,
 				  struct nf_conn *ct,
 				  enum ip_conntrack_info ctinfo,
@@ -958,7 +945,6 @@ static int process_callproceeding(struct sk_buff *skb,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_connect(struct sk_buff *skb, struct nf_conn *ct,
 			   enum ip_conntrack_info ctinfo,
 			   unsigned int protoff,
@@ -990,7 +976,6 @@ static int process_connect(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_alerting(struct sk_buff *skb, struct nf_conn *ct,
 			    enum ip_conntrack_info ctinfo,
 			    unsigned int protoff,
@@ -1022,7 +1007,6 @@ static int process_alerting(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_facility(struct sk_buff *skb, struct nf_conn *ct,
 			    enum ip_conntrack_info ctinfo,
 			    unsigned int protoff,
@@ -1063,7 +1047,6 @@ static int process_facility(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_progress(struct sk_buff *skb, struct nf_conn *ct,
 			    enum ip_conntrack_info ctinfo,
 			    unsigned int protoff,
@@ -1095,7 +1078,6 @@ static int process_progress(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_q931(struct sk_buff *skb, struct nf_conn *ct,
 			enum ip_conntrack_info ctinfo,
 			unsigned int protoff, unsigned char **data, int dataoff,
@@ -1154,7 +1136,6 @@ static int process_q931(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int q931_help(struct sk_buff *skb, unsigned int protoff,
 		     struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
@@ -1203,7 +1184,6 @@ static int q931_help(struct sk_buff *skb, unsigned int protoff,
 	return NF_DROP;
 }
 
-/****************************************************************************/
 static const struct nf_conntrack_expect_policy q931_exp_policy = {
 	/* T.120 and H.245 */
 	.max_expected		= H323_RTP_CHANNEL_MAX * 4 + 4,
@@ -1231,7 +1211,6 @@ static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
 	},
 };
 
-/****************************************************************************/
 static unsigned char *get_udp_data(struct sk_buff *skb, unsigned int protoff,
 				   int *datalen)
 {
@@ -1249,7 +1228,6 @@ static unsigned char *get_udp_data(struct sk_buff *skb, unsigned int protoff,
 	return skb_header_pointer(skb, dataoff, *datalen, h323_buffer);
 }
 
-/****************************************************************************/
 static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
 					       union nf_inet_addr *addr,
 					       __be16 port)
@@ -1270,7 +1248,6 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
 	return NULL;
 }
 
-/****************************************************************************/
 static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff, unsigned char **data,
@@ -1328,7 +1305,6 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 	return ret;
 }
 
-/****************************************************************************/
 static int process_grq(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1346,7 +1322,6 @@ static int process_grq(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1391,7 +1366,6 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	return ret;
 }
 
-/****************************************************************************/
 static int process_rrq(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1428,7 +1402,6 @@ static int process_rrq(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1480,7 +1453,6 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_urq(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1514,7 +1486,6 @@ static int process_urq(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_arq(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1559,7 +1530,6 @@ static int process_arq(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1608,7 +1578,6 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 	return ret;
 }
 
-/****************************************************************************/
 static int process_lrq(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1626,7 +1595,6 @@ static int process_lrq(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1666,7 +1634,6 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 	return ret;
 }
 
-/****************************************************************************/
 static int process_irr(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1700,7 +1667,6 @@ static int process_irr(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int process_ras(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1745,7 +1711,6 @@ static int process_ras(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-/****************************************************************************/
 static int ras_help(struct sk_buff *skb, unsigned int protoff,
 		    struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
@@ -1788,7 +1753,6 @@ static int ras_help(struct sk_buff *skb, unsigned int protoff,
 	return NF_DROP;
 }
 
-/****************************************************************************/
 static const struct nf_conntrack_expect_policy ras_exp_policy = {
 	.max_expected		= 32,
 	.timeout		= 240,
@@ -1849,7 +1813,6 @@ static void __exit h323_helper_exit(void)
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
 }
 
-/****************************************************************************/
 static void __exit nf_conntrack_h323_fini(void)
 {
 	h323_helper_exit();
@@ -1857,7 +1820,6 @@ static void __exit nf_conntrack_h323_fini(void)
 	pr_debug("nf_ct_h323: fini\n");
 }
 
-/****************************************************************************/
 static int __init nf_conntrack_h323_init(void)
 {
 	int ret;
@@ -1877,7 +1839,6 @@ static int __init nf_conntrack_h323_init(void)
 	return ret;
 }
 
-/****************************************************************************/
 module_init(nf_conntrack_h323_init);
 module_exit(nf_conntrack_h323_fini);
 
-- 
2.14.3

