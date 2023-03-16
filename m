Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5536C6FD19
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Mar 2023 11:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCPLIM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Mar 2023 07:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjCPLIL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2023 07:08:11 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F5799240
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2023 04:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SDp7cREWNJcmQqSmQp3zU3uT6IywS6bQkUUoA2piVmo=; b=HpyGUgoPMmxer3B0ZGWpAXnDDf
        1cc0qPC2QJEJX/ssgNj/8oTalchLzhwghC4mfNBt9pcV9IeQqfQhLxxUjXZXToKSGr9xKmeoswZBj
        Iw5Jd/0ofbDk2mZFTk9UI0kHfeZZ5m/GSHuEqAHfJGGegrAVkt9UHSBp5AokrT6u7ep84ywaVfcra
        qR+QvTp70wxnVj+mN322TA6UiwlW4STHy2zdEF2oS6mUvJcKl8ztPfCbxudETOYdtJKnzMK4eFzKM
        nJE82QjPDws/TMnW0uM3TI2s74pydROpUAJwqH1qlQDaB5w/IOwJX22nQsuRvvjsccEvq/ObrfsPw
        hlY6Mjow==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pclSl-00AuPp-VJ
        for netfilter-devel@vger.kernel.org; Thu, 16 Mar 2023 11:08:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 1/2] pcap: simplify opening of output file
Date:   Thu, 16 Mar 2023 11:07:53 +0000
Message-Id: <20230316110754.260967-2-jeremy@azazel.net>
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

Instead of statting the file, and choosing the mode with which to open
it and whether to write the PCAP header based on the result, always open
it with mode "a" and _then_ stat it.  This simplifies the flow-control
and avoids a race between statting and opening.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/pcap/ulogd_output_PCAP.c | 42 ++++++++++++---------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index e7798f20c8fc..220fc6dec5fe 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -220,33 +220,21 @@ static int append_create_outfile(struct ulogd_pluginstance *upi)
 {
 	struct pcap_instance *pi = (struct pcap_instance *) &upi->private;
 	char *filename = upi->config_kset->ces[0].u.string;
-	struct stat st_dummy;
-	int exist = 0;
-
-	if (stat(filename, &st_dummy) == 0 && st_dummy.st_size > 0)
-		exist = 1;
-
-	if (!exist) {
-		pi->of = fopen(filename, "w");
-		if (!pi->of) {
-			ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",
-				  filename,
-				  strerror(errno));
-			return -EPERM;
-		}
-		if (!write_pcap_header(pi)) {
-			ulogd_log(ULOGD_ERROR, "can't write pcap header: %s\n",
-				  strerror(errno));
-			return -ENOSPC;
-		}
-	} else {
-		pi->of = fopen(filename, "a");
-		if (!pi->of) {
-			ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n", 
-				filename,
-				strerror(errno));
-			return -EPERM;
-		}		
+	struct stat st_of;
+
+	pi->of = fopen(filename, "a");
+	if (!pi->of) {
+		ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",
+			  filename,
+			  strerror(errno));
+		return -EPERM;
+	}
+	if (fstat(fileno(pi->of), &st_of) == 0 && st_of.st_size == 0) {
+	    if (!write_pcap_header(pi)) {
+		    ulogd_log(ULOGD_ERROR, "can't write pcap header: %s\n",
+			      strerror(errno));
+		    return -ENOSPC;
+	    }
 	}
 
 	return 0;
-- 
2.39.2

