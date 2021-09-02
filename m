Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14676C432BE
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Sep 2021 11:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3A2F61057
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Sep 2021 11:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhIBLel (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Sep 2021 07:34:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230256AbhIBLel (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 07:34:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630582422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0IkJJbZarL//uauAt3uDY9E0KiRtiDoJT6xqsdLvpMU=;
        b=cfDvxqNBGd3zak56JNpoHLCMxEcdUysvi/em0M30th5fih9GS5f+t5KWID2BL9lPGaqzuL
        3ZTpxlec51sM3JtXqEMV/kEi3qaC1htnd2aRmkCyU+SmNbCr99cis8ct1DcKAHuy61wGnt
        RF0/3En/mDSLziWzxFSu7gIG9olRRNs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-NMvh2nQXMNe61uM2EkhUTg-1; Thu, 02 Sep 2021 07:33:41 -0400
X-MC-Unique: NMvh2nQXMNe61uM2EkhUTg-1
Received: by mail-wr1-f72.google.com with SMTP id p10-20020a5d68ca000000b001552bf8b9daso427349wrw.22
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Sep 2021 04:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0IkJJbZarL//uauAt3uDY9E0KiRtiDoJT6xqsdLvpMU=;
        b=Cwgp5niaUv/IT0VYJxD7RyTp/2F+ZocOmr86UD9oHSOoUFjyo8y/gqWawguyFOqV4W
         o3ATkkdmyJ5v5Fd9u3xhzcyJtBPMXdVqQdHvwxiQaCHQBL8r7FvpxzrVcWIJmy3aHZz+
         J5fDmu9eSrBhXSnAz8PBUwin2IFEouMUwh2m1agkKWyrSrBifLJ5zh6QJpGrUAFP4d4i
         f0x42BN/rv2NE0qLmy4wzssbnbe8HsJOir7zNfLP4b7c41fGGFv/GO0a0yOtE5Bs0jCB
         P7gunKqTlSS2TM+8AXKa+vidfT/puzxbe31mJlzsswtgKabaizP90I9JiffVzClZoqao
         UcXg==
X-Gm-Message-State: AOAM531mqbgIdILAN2xaGTbfvNiaIMuxc8JBZvdn2R9MSYZOinoh2TFi
        JOoW4zndiAQh7KSqUDOStomKHG3Yoa7ozN8Jc+D3oFynoNailXOLa7Hb90hiLlQTKkrnyssa9MD
        wB6euQldGUNTIvFguQrC099O1Sl2t0HEal5PzPnb6r+vbN9eWY4Y817+hVwN+JZyyLAYZL/1gva
        a8jg==
X-Received: by 2002:adf:82a9:: with SMTP id 38mr3203338wrc.82.1630582420312;
        Thu, 02 Sep 2021 04:33:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG0DhqeDcX52kq4UIGDPPaUY//mLQOulpufVedU1sem+lTagMsXeEnMRTKdsrfyrPnODsyzA==
X-Received: by 2002:adf:82a9:: with SMTP id 38mr3203313wrc.82.1630582420102;
        Thu, 02 Sep 2021 04:33:40 -0700 (PDT)
Received: from localhost ([185.112.167.33])
        by smtp.gmail.com with ESMTPSA id t5sm1621638wra.95.2021.09.02.04.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 04:33:39 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] Fix a few doc typos
Date:   Thu,  2 Sep 2021 13:33:59 +0200
Message-Id: <20210902113359.2369296-1-snemec@redhat.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 extensions/libxt_devgroup.man | 2 +-
 iptables/xtables-monitor.8.in | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_devgroup.man b/extensions/libxt_devgroup.man
index 4a66c9fe2635..480ee3512188 100644
--- a/extensions/libxt_devgroup.man
+++ b/extensions/libxt_devgroup.man
@@ -1,4 +1,4 @@
-Match device group of a packets incoming/outgoing interface.
+Match device group of a packet's incoming/outgoing interface.
 .TP
 [\fB!\fP] \fB\-\-src\-group\fP \fIname\fP
 Match device group of incoming device
diff --git a/iptables/xtables-monitor.8.in b/iptables/xtables-monitor.8.in
index b647a79eb64e..a7f22c0d8c08 100644
--- a/iptables/xtables-monitor.8.in
+++ b/iptables/xtables-monitor.8.in
@@ -51,9 +51,9 @@ The second line dumps information about the packet. Incoming interface
 and packet headers such as source and destination addresses are shown.
 
 The third line shows that the packet completed traversal of the raw table
-PREROUTING chain, and is returning, followed by use the chain policy to make accept/drop
+PREROUTING chain, and is returning, followed by use of the chain policy to make accept/drop
 decision (the example shows accept being applied).
-The fifth line shows that the packet leaves the filter INPUT chain, i.e., no rules in the filter tables
+The fifth line shows that the packet leaves the filter INPUT chain, i.e., no rules in the filter table's
 INPUT chain matched the packet.
 It then got DROPPED by the policy of the INPUT table, as shown by line six.
 The last line shows another packet arriving \-\- the packet id is different.
@@ -81,7 +81,7 @@ by three base hooks INPUT, FORWARD and OUTPUT.  The iptables-nftables tools all
 chains automatically when needed, so this is expected when a table was not yet initialized or when it is
 re-created from scratch by iptables-nftables-restore.  Line five shows a new user-defined chain (TCP)
 being added, followed by addition a few rules. the last line shows that a new ruleset generation has
-become active, i.e., the rule set changes are now active.  This also lists the process id and the programs name.
+become active, i.e., the rule set changes are now active.  This also lists the process id and the program name.
 .SH LIMITATIONS
 .B xtables-monitor
 only works with rules added using iptables-nftables, rules added using

base-commit: e438b9766fcc86d9847312ff05f1d1dac61acf1f
-- 
2.33.0

