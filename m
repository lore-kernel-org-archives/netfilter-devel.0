Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA94C7618A
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Mar 2023 11:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCPLIL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Mar 2023 07:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCPLIK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2023 07:08:10 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C8C87A05
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2023 04:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hQwuNC9p0IZkOfDDjFUJY85vEriMkjx5Ls2n/97tYUU=; b=i8uOIgmRr9KP7CdsBYdJGST4Zs
        iHFz12mKpkbym2mZatxHtf9lWU50SxgD5gHNTGg12iuh2XvnoA6yNrqFVBllN+EVcugJWCtO3MJui
        ZfLivyn3JgJD+vhNP0jND75+nhEyocE0sEPVq4oxRYFRSPz5yklB/keUBcm1vU43zTZDmAk8EKd4n
        IgopjEwydv9Sp1CLdz9mpT/acG2gmzyG24gNVsCUhpsOgT3agz0KvL5XZwgSzRZzXRJnMMh7/rFDv
        nkfARZuvEz69j6SWHg2I8lwC6+6dgIjH3FGSRuqLC2/scTplvogopVzc2hJs/mpZW2/dII4LZKEgi
        Ennd2utA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pclSm-00AuPp-3F
        for netfilter-devel@vger.kernel.org; Thu, 16 Mar 2023 11:08:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 2/2] pcap: prevent crashes when output `FILE *` is null
Date:   Thu, 16 Mar 2023 11:07:54 +0000
Message-Id: <20230316110754.260967-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316110754.260967-1-jeremy@azazel.net>
References: <20230316110754.260967-1-jeremy@azazel.net>
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

Instead, assign the return value of `fopen` to a local variable, and
only close the existing stream if `fopen` succeeded.

Link: https://bugs.launchpad.net/ubuntu/+source/ulogd2/+bug/1429778
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/pcap/ulogd_output_PCAP.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index 220fc6dec5fe..0bb1f32b53ed 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -221,14 +221,18 @@ static int append_create_outfile(struct ulogd_pluginstance *upi)
 	struct pcap_instance *pi = (struct pcap_instance *) &upi->private;
 	char *filename = upi->config_kset->ces[0].u.string;
 	struct stat st_of;
+	FILE *of;
 
-	pi->of = fopen(filename, "a");
-	if (!pi->of) {
+	of = fopen(filename, "a");
+	if (!of) {
 		ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",
 			  filename,
 			  strerror(errno));
 		return -EPERM;
 	}
+	if (pi->of)
+		fclose(pi->of);
+	pi->of = of;
 	if (fstat(fileno(pi->of), &st_of) == 0 && st_of.st_size == 0) {
 	    if (!write_pcap_header(pi)) {
 		    ulogd_log(ULOGD_ERROR, "can't write pcap header: %s\n",
@@ -236,18 +240,14 @@ static int append_create_outfile(struct ulogd_pluginstance *upi)
 		    return -ENOSPC;
 	    }
 	}
-
 	return 0;
 }
 
 static void signal_pcap(struct ulogd_pluginstance *upi, int signal)
 {
-	struct pcap_instance *pi = (struct pcap_instance *) &upi->private;
-
 	switch (signal) {
 	case SIGHUP:
 		ulogd_log(ULOGD_NOTICE, "reopening capture file\n");
-		fclose(pi->of);
 		append_create_outfile(upi);
 		break;
 	default:
-- 
2.39.2

