Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB6EC54E76
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Jan 2023 12:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbjABMUw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Jan 2023 07:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbjABMUq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2023 07:20:46 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C71DB3
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2023 04:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BKDhozoSRW8qMHvQ71xko0j9HCsrzEOM7B+CkX7OzV0=; b=AyDTARzaGbJeJDp/yYqLIu1aoN
        xQmHXqeHRoToFYc+R6wcpeP0do59Xj1nOO10osMIa42RLNEMO7l6hlIQmIzR/SwjWYPjDuLQyXh+D
        0QGIyvfvOUOPRpTESe9xDE25PvLG7qculAlNoQyaLojnlmOzplAv/IQ1mCzJJ+mhrirT5dcGf25kL
        EHxiqFXphuvutkGURCJvZkb1Cg89ZcMgsY39aSivt7/eSwgIrUBaJeC0zZmU+LD/7RtlGOV92uLxy
        GRKFr2lrbo/pCav3bsXytBCQMjbB7sf2NDpIo0z4OdaMKB21MexAgPyahHXm7ZQUe/ZcYtJbNnJFQ
        eVzlVWHg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pCJnz-0018lw-F2
        for netfilter-devel@vger.kernel.org; Mon, 02 Jan 2023 12:20:39 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH] pcap: prevent crashes when output `FILE *` is null
Date:   Mon,  2 Jan 2023 12:19:41 +0000
Message-Id: <20230102121941.105586-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If ulogd2 receives a signal it will attempt to re-open the pcap output
file.  If this fails (because the permissions or ownership have changed
for example), the FILE pointer will be null and when the next packet
comes in, the null pointer will be passed to fwrite and ulogd will
crash.

Instead, check that the pointer is not null before using it.  If it is
null, then periodically attempt to open it again.  We only return an
error from interp_pcap on those occasions when we try and fail to open
the output file, in order to avoid spamming the ulogd log-file every
time a packet isn't written.

Link: https://bugs.launchpad.net/ubuntu/+source/ulogd2/+bug/1429778
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/pcap/ulogd_output_PCAP.c | 49 +++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index e7798f20c8fc..5b2ca64d3393 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -82,6 +82,8 @@ struct pcap_sf_pkthdr {
 #define ULOGD_PCAP_SYNC_DEFAULT	0
 #endif
 
+#define MAX_OUTFILE_CHECK_DELTA 64
+
 #define NIPQUAD(addr) \
 	((unsigned char *)&addr)[0], \
 	((unsigned char *)&addr)[1], \
@@ -107,6 +109,7 @@ static struct config_keyset pcap_kset = {
 };
 
 struct pcap_instance {
+	time_t last_outfile_check, next_outfile_check_delta;
 	FILE *of;
 };
 
@@ -142,12 +145,53 @@ static struct ulogd_key pcap_keys[INTR_IDS] = {
 
 #define GET_FLAGS(res, x)	(res[x].u.source->flags)
 
+static int append_create_outfile(struct ulogd_pluginstance *);
+
+static int
+check_outfile(struct ulogd_pluginstance *upi)
+{
+	struct pcap_instance *pi = (struct pcap_instance *) &upi->private;
+	time_t now;
+	int ret;
+
+	if (pi->of)
+		return 0;
+
+	now = time(NULL);
+
+	if (now < pi->last_outfile_check + pi->next_outfile_check_delta)
+		return -EAGAIN;
+
+	ret = append_create_outfile(upi);
+
+	if (!ret) {
+		pi->last_outfile_check = 0;
+		pi->next_outfile_check_delta = 1;
+		return 0;
+	}
+
+	pi->last_outfile_check = now;
+	if (pi->next_outfile_check_delta <= MAX_OUTFILE_CHECK_DELTA / 2)
+		pi->next_outfile_check_delta *= 2;
+
+	return ret;
+}
+
 static int interp_pcap(struct ulogd_pluginstance *upi)
 {
 	struct pcap_instance *pi = (struct pcap_instance *) &upi->private;
 	struct ulogd_key *res = upi->input.keys;
 	struct pcap_sf_pkthdr pchdr;
 
+	switch (check_outfile(upi)) {
+	case 0:
+		break;
+	case -EAGAIN:
+		return ULOGD_IRET_OK;
+	default:
+		return ULOGD_IRET_ERR;
+	}
+
 	pchdr.caplen = ikey_get_u32(&res[1]);
 
 	/* Try to set the len field correctly, if we know the protocol. */
@@ -275,6 +319,11 @@ static int configure_pcap(struct ulogd_pluginstance *upi,
 
 static int start_pcap(struct ulogd_pluginstance *upi)
 {
+	struct pcap_instance *pi = (struct pcap_instance *) &upi->private;
+
+	pi->last_outfile_check = 0;
+	pi->next_outfile_check_delta = 1;
+
 	return append_create_outfile(upi);
 }
 
-- 
2.39.0

