From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH 1/8] ipfix: use nfct_bitmask
Date: Sat, 8 Mar 2014 10:07:12 +0900
Message-ID: <20140308010709.GB4415@gmail.com>
References: <20140308010344.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59657 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaCHBHW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:22 -0500
Received: by mail-pa0-f48.google.com with SMTP id hz1so4881642pad.7
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 17:07:22 -0800 (PST)
Received: from gmail.com (KD106159154146.ppp-bb.dion.ne.jp. [106.159.154.146])
        by mx.google.com with ESMTPSA id yo9sm17048849pab.16.2014.03.07.17.07.18
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 07 Mar 2014 17:07:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140308010344.GA4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

from libnetfilter_conntrack instead of original
---
 output/Makefile.am          |   6 ++-
 output/ulogd_output_IPFIX.c | 107 ++++++--------------------------------------
 2 files changed, 18 insertions(+), 95 deletions(-)

diff --git a/output/Makefile.am b/output/Makefile.am
index ff851ad..92f1233 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -7,7 +7,7 @@ SUBDIRS= pcap mysql pgsql sqlite3 dbi
 pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
 			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
 			 ulogd_output_NACCT.la ulogd_output_XML.la \
-			 ulogd_output_GRAPHITE.la
+			 ulogd_output_GRAPHITE.la ulogd_output_IPFIX.la
 
 if HAVE_JANSSON
 pkglib_LTLIBRARIES += ulogd_output_JSON.la
@@ -42,3 +42,7 @@ ulogd_output_JSON_la_SOURCES = ulogd_output_JSON.c
 ulogd_output_JSON_la_LIBADD  = ${libjansson_LIBS}
 ulogd_output_JSON_la_LDFLAGS = -avoid-version -module
 endif
+
+ulogd_output_IPFIX_la_SOURCES = ulogd_output_IPFIX.c
+ulogd_output_IPFIX_la_LDFLAGS = -avoid-version -module
+ulogd_output_IPFIX_la_LIBADD = ${LIBNETFILTER_CONNTRACK_LIBS}
diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 761d272..01ac9a0 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -36,6 +36,8 @@
 #include <sys/socket.h>
 #include <netdb.h>
 
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
 #include <ulogd/linuxlist.h>
 
 #ifdef IPPROTO_SCTP
@@ -68,89 +70,6 @@ struct sctp_sndrcvinfo {
 
 #define IPFIX_DEFAULT_TCPUDP_PORT	4739
 
-/* bitmask stuff */
-struct bitmask {
-	int size_bits;
-	char *buf;
-};
-
-#define SIZE_OCTETS(x)	((x/8)+1)
-
-void bitmask_clear(struct bitmask *bm)
-{
-	memset(bm->buf, 0, SIZE_OCTETS(bm->size_bits));
-}
-
-struct bitmask *bitmask_alloc(unsigned int num_bits)
-{
-	struct bitmask *bm;
-	unsigned int size_octets = SIZE_OCTETS(num_bits);
-
-	bm = malloc(sizeof(*bm) + size_octets);
-	if (!bm)
-		return NULL;
-
-	bm->size_bits = num_bits;
-	bm->buf = (void *)bm + sizeof(*bm);
-
-	bitmask_clear(bm);
-
-	return bm;
-}
-
-void bitmask_free(struct bitmask *bm)
-{
-	free(bm);
-}
-
-int bitmask_set_bit_to(struct bitmask *bm, unsigned int bits, int to)
-{
-	unsigned int byte = bits / 8;
-	unsigned int bit = bits % 8;
-	unsigned char *ptr;
-
-	if (byte > SIZE_OCTETS(bm->size_bits))
-		return -EINVAL;
-
-	if (to == 0)
-		bm->buf[byte] &= ~(1 << bit);
-	else
-		bm->buf[byte] |= (1 << bit);
-
-	return 0;
-}
-
-#define bitmask_clear_bit(bm, bit) \
-	bitmask_set_bit_to(bm, bit, 0)
-
-#define bitmask_set_bit(bm, bit) \
-	bitmask_set_bit_to(bm, bit, 1)
-
-int bitmasks_equal(const struct bitmask *bm1, const struct bitmask *bm2)
-{
-	if (bm1->size_bits != bm2->size_bits)
-		return -1;
-
-	if (!memcmp(bm1->buf, bm2->buf, SIZE_OCTETS(bm1->size_bits)))
-		return 1;
-	else
-		return 0;
-}
-
-struct bitmask *bitmask_dup(const struct bitmask *bm_orig)
-{
-	struct bitmask *bm_new;
-	int size = sizeof(*bm_new) + SIZE_OCTETS(bm_orig->size_bits);
-
-	bm_new = malloc(size);
-	if (!bm_new)
-		return NULL;
-
-	memcpy(bm_new, bm_orig, size);
-
-	return bm_new;
-}
-
 static struct config_keyset ipfix_kset = {
 	.num_ces = 3,
 	.ces = {
@@ -185,7 +104,7 @@ struct ipfix_template {
 
 struct ulogd_ipfix_template {
 	struct llist_head list;
-	struct bitmask *bitmask;
+	struct nfct_bitmask *bitmask;
 	unsigned int total_length;	/* length of the DATA */
 	char *tmpl_cur;		/* cursor into current template position */
 	struct ipfix_template tmpl;
@@ -201,7 +120,7 @@ struct ipfix_instance {
 	struct ipfix_template *tmpl;
 	unsigned int tmpl_len;
 
-	struct bitmask *valid_bitmask;	/* bitmask of valid keys */
+	struct nfct_bitmask *valid_bitmask;	/* bitmask of valid keys */
 
 	unsigned int total_length;	/* total size of all data elements */
 };
@@ -212,7 +131,7 @@ static u_int16_t next_template_id = ULOGD_IPFIX_TEMPL_BASE;
 /* Build the IPFIX template from the input keys */
 struct ulogd_ipfix_template *
 build_template_for_bitmask(struct ulogd_pluginstance *upi,
-			   struct bitmask *bm)
+			   struct nfct_bitmask *bm)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
 	struct ipfix_templ_rec_hdr *rhdr;
@@ -226,7 +145,7 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 		return NULL;
 	memset(tmpl, 0, size);
 
-	tmpl->bitmask = bitmask_dup(bm);
+	tmpl->bitmask = nfct_bitmask_clone(bm);
 	if (!tmpl->bitmask) {
 		free(tmpl);
 		return NULL;
@@ -288,14 +207,14 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 
 static struct ulogd_ipfix_template *
 find_template_for_bitmask(struct ulogd_pluginstance *upi,
-			  struct bitmask *bm)
+			  struct nfct_bitmask *bm)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
 	struct ulogd_ipfix_template *tmpl;
 	
 	/* FIXME: this can be done more efficient! */
 	llist_for_each_entry(tmpl, &ii->template_list, list) {
-		if (bitmasks_equal(bm, tmpl->bitmask))
+		if (nfct_bitmask_equal(bm, tmpl->bitmask))
 			return tmpl;
 	}
 	return NULL;
@@ -313,13 +232,13 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 	 * ulogd core could very easily flush it after every packet,
 	 * too. */
 
-	bitmask_clear(ii->valid_bitmask);
+	nfct_bitmask_clear(ii->valid_bitmask);
 
 	for (i = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *key = upi->input.keys[i].u.source;
 
 		if (key->flags & ULOGD_RETF_VALID)
-			bitmask_set_bit(ii->valid_bitmask, i);
+			nfct_bitmask_set_bit(ii->valid_bitmask, i);
 	}
 	
 	/* lookup template ID for this bitmask */
@@ -430,7 +349,7 @@ static int start_ipfix(struct ulogd_pluginstance *pi)
 
 	ulogd_log(ULOGD_DEBUG, "starting ipfix\n");
 
-	ii->valid_bitmask = bitmask_alloc(pi->input.num_keys);
+	ii->valid_bitmask = nfct_bitmask_new(pi->input.num_keys);
 	if (!ii->valid_bitmask)
 		return -ENOMEM;
 
@@ -443,7 +362,7 @@ static int start_ipfix(struct ulogd_pluginstance *pi)
 	return 0;
 
 out_bm_free:
-	bitmask_free(ii->valid_bitmask);
+	nfct_bitmask_destroy(ii->valid_bitmask);
 	ii->valid_bitmask = NULL;
 
 	return ret;
@@ -455,7 +374,7 @@ static int stop_ipfix(struct ulogd_pluginstance *pi)
 
 	close(ii->fd);
 
-	bitmask_free(ii->valid_bitmask);
+	nfct_bitmask_destroy(ii->valid_bitmask);
 	ii->valid_bitmask = NULL;
 
 	return 0;
-- 
1.8.5.3
