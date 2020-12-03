Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E43C63777
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 774B822259
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgLCNLQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 08:11:16 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36023 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgLCNLQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 08:11:16 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so1829737wrn.3
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Dec 2020 05:10:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=2fE6i7u3zGj2K6fkoxgzeaY0HiswHLbrchd7PK61o5c=;
        b=dZ3CB3vLujy9thi5eLQ6HBozT24O2jS9HUkoBwPVYWNfGcsvQoa3aF889x6qH2RGvP
         sZBa05m7VctbjJB8z1gMA1nLo+mihGrIHF/IZXvMtTwZah/ltzd9nmXyukzf8pRhUacQ
         o0IRTmQzm24BrPkzdbcg4ua3ucTzeD+eDWcF1AVwQsKHeReMb+QZ4arPLxMEODno62WZ
         CwUUjW1bRVmncOlZaSJ5fI7YvQKm4D9GYGIRCrWfqc6DSAx354Z1wo9NpcYswJTIcZ7p
         blFRijm1UR7VlsBlsV71H00a6JY+Zng3CeY8ltv3XwUUL2Fs6fCM698IEB+4+enusAAT
         IXMA==
X-Gm-Message-State: AOAM5325M8eegLZ8jp6QzBXMAtjn+cR6c0bjf2aIlfJkg4sf0+bDnjk+
        IOCNmxGAFCpjMKtJexg2xI0t3alJiixZ9w==
X-Google-Smtp-Source: ABdhPJw0202QH9D2HTUrtphmYn4yEjGJbt1zRLj/hpulUWmUx/K9t8fpZuxXczbg8NoyxxuRTOBG5Q==
X-Received: by 2002:a5d:634d:: with SMTP id b13mr3744765wrw.310.1607001033631;
        Thu, 03 Dec 2020 05:10:33 -0800 (PST)
Received: from localhost ([213.194.141.17])
        by smtp.gmail.com with ESMTPSA id t188sm1448734wmf.9.2020.12.03.05.10.32
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 05:10:32 -0800 (PST)
Subject: [conntrack-tools PATCH 1/2] .gitignore: add nano swap file
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Thu, 03 Dec 2020 14:10:32 +0100
Message-ID: <160700103220.39855.6588996986767666395.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ignore the nano swap file.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 .gitignore |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index f7a5fc7..d061ad7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -13,3 +13,5 @@ Makefile.in
 /config.*
 /configure
 /libtool
+
+*.swp

