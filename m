Return-Path: <SRS0=IOUL=6E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B57C54FC9
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 02:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CFAE2076B
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 02:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgDTCax (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Apr 2020 22:30:53 -0400
Received: from mail.redfish-solutions.com ([45.33.216.244]:50894 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725865AbgDTCax (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Apr 2020 22:30:53 -0400
X-Greylist: delayed 7975 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Apr 2020 22:30:53 EDT
Received: from son-of-builder.redfish-solutions.com (son-of-builder.redfish-solutions.com [192.168.1.56])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.15.2/8.15.2) with ESMTPSA id 03JC3d8S010087
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Apr 2020 06:03:39 -0600
From:   "Philip Prindeville" <philipp@redfish-solutions.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Philip Prindeville <philipp@redfish-solutions.com>
Subject: [PATCH v1 1/1] xtables-addons: geoip: Update download script for DBIP database
Date:   Sun, 19 Apr 2020 20:24:41 -0600
Message-Id: <20200420022441.10941-1-philipp@redfish-solutions.com>
X-Mailer: git-send-email 2.17.2
X-Scanned-By: MIMEDefang 2.84 on 192.168.1.3
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Philip Prindeville <philipp@redfish-solutions.com>

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
---
 geoip/xt_geoip_dl | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/geoip/xt_geoip_dl b/geoip/xt_geoip_dl
old mode 100755
new mode 100644
index 1de60442a8040f55d775d134d7a8ea707582d71e..91aa95b650a968fb8cd989ac5b08ec890a45f008
--- a/geoip/xt_geoip_dl
+++ b/geoip/xt_geoip_dl
@@ -1,7 +1,11 @@
 #!/bin/sh
 
-rm -rf GeoLite2-Country-CSV_*
+timestamp=$(date "+%Y-%m")
 
-wget -q http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip
-unzip -q GeoLite2-Country-CSV.zip
-rm -f GeoLite2-Country-CSV.zip
+wget -q "https://download.db-ip.com/free/dbip-country-lite-${timestamp}.csv.gz"
+
+zcat dbip-country-lite-${timestamp}.csv.gz > dbip-country-lite.csv
+
+rm -f dbip-country-lite-${timestamp}.csv.gz
+
+exit 0
-- 
2.17.2

