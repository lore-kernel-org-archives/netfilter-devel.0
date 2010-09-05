From: Jan Andres <jandres@gmx.net>
Subject: [PATCH] ulogd2: Fix length handling in PCAP output
Date: Sun, 5 Sep 2010 18:29:02 +0200
Message-ID: <20100905162857.GA9778@pitr.home.jan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:40913 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752993Ab0IEQ3K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:29:10 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, the PCAP output plugin uses ip.totlen to determine both the
"len" and "caplen" pcap header fields, as well as the amount of packet
data written to the file. There are two issues with this:

- For obvious reasons it doesn't work for IPv6.

- AFAICT, in case of an incompletely captured packet (--nflog-range)
  it will attempt to write out the whole packet, not just the part
  captured.

This patch changes the behavior to:

- Use raw.pktlen to set the "caplen" field, and the amount of data
  written.

- Determine the "len" (original length) field from ip.totlen or
  ip6.payload_len if possible, default to the same value as "caplen"
  otherwise.


Signed-off-by: Jan Andres <jandres@gmx.net>


diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index eb17a86..959919e 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -117,7 +117,7 @@ struct intr_id {
 	unsigned int id;		
 };
 
-#define INTR_IDS 	5
+#define INTR_IDS 	7
 static struct ulogd_key pcap_keys[INTR_IDS] = {
 	{ .type = ULOGD_RET_UINT32,
 	  .flags = ULOGD_RETF_NONE,
@@ -134,6 +134,12 @@ static struct ulogd_key pcap_keys[INTR_IDS] = {
 	{ .type = ULOGD_RET_UINT32,
 	  .flags = ULOGD_RETF_NONE,
 	  .name = "oob.time.usec" },
+	{ .type = ULOGD_RET_UINT8,
+	  .flags = ULOGD_RETF_NONE,
+	  .name = "oob.family" },
+	{ .type = ULOGD_RET_UINT16,
+	  .flags = ULOGD_RETF_NONE,
+	  .name = "ip6.payload_len" },
 };
 
 #define GET_FLAGS(res, x)	(res[x].u.source->flags)
@@ -144,8 +150,20 @@ static int interp_pcap(struct ulogd_pluginstance *upi)
 	struct ulogd_key *res = upi->input.keys;
 	struct pcap_sf_pkthdr pchdr;
 
-	pchdr.caplen = ikey_get_u32(&res[2]);
-	pchdr.len = ikey_get_u32(&res[2]);
+	pchdr.caplen = ikey_get_u32(&res[1]);
+
+	/* Try to set the len field correctly, if we know the protocol. */
+	switch (ikey_get_u8(&res[5])) {
+	case 2: /* INET */
+		pchdr.len = ikey_get_u16(&res[2]);
+		break;
+	case 10: /* INET6 -- payload length + header length */
+		pchdr.len = ikey_get_u16(&res[6]) + 40;
+		break;
+	default:
+		pchdr.len = pchdr.caplen;
+		break;
+	}
 
 	if (GET_FLAGS(res, 3) & ULOGD_RETF_VALID
 	    && GET_FLAGS(res, 4) & ULOGD_RETF_VALID) {
