Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A0BCCA473
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jun 2022 22:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbiFUW5B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jun 2022 18:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238330AbiFUW5A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jun 2022 18:57:00 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE48432044
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 15:56:59 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id g25so30461535ejh.9
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 15:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MlfRZWb7QGLWUfuHHtkw8dNMfDhu1u3P3HhTkcoZyGs=;
        b=Y/JyHDuWIFEj5BZGw6NpaWgmdv2gkE+cPigdC+Q/6F83CFWVPlEzWNqldMIeBUlKF6
         C1vZaEc0jghV/Kaf0sP6ADYmcDREoZeY9mdvlzqyhFKdunCMYZHQlo8uVOqKIFvYHkAi
         UlEoJPnP2bcKYN/oBooQyqnvLfW3mb9aTUSn6g+ElYb8WjoFa1HfE5nM8g4RvmtBWatR
         Z2rGH65epkgcasiJR5wDCic3JhLv4/29ah8dhz2ubzZzywtEnoMsoID6RslzxKivikdc
         7pmDi9jLl5VXwqqr6PbchbmQ6pqDSTO9yGxliNWBdK8FIw7aHI+ZHsq1KbQvF46WT5Uz
         R4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MlfRZWb7QGLWUfuHHtkw8dNMfDhu1u3P3HhTkcoZyGs=;
        b=XdxCfGv5yq9b0bTKi3B2Ef4pai98OjuHQsk6ICQq8VIcnwmD2C6BDrf9tUy+vbe+wf
         8ybMd2istWZ+RdfpNJhacg9/iU8al2VZ8enBT9UBeVBALWwneJmzdBqaGF7GhecUhWZ/
         VYtk21YFugRhSKUFXbflS9DpFSd30B23afLcu2FABqMjs/qZJt2wCeyVDn1BN/4n2Byb
         UmPpPE0/erld265L6aaMNDhO07dnzep8TN4CF+2vodcnWB2L89AGO/XwtI97ZQq0XDBY
         VHD38apDJVgCK72+IiKdH7NftmFYe7MHrfYFGkxQ5VlvB8sfETW67NO2wdpPorPuN7bn
         gDyQ==
X-Gm-Message-State: AJIora9teLCpPgYlo/7jGST//Yfn0uJN/v0/Hpk4TfvfXAsOrlOOixlc
        EDk/UVneul7+Q+1grpvEsGvAb/2U5dYIhQ==
X-Google-Smtp-Source: AGRyM1vfQay2Llpsfl4OvQeb1ZqGrsNAZjIQJCkJ6dNlEvVivTY2Y7NXfO00N7VlnbssTi3DNUA4fQ==
X-Received: by 2002:a17:906:ca91:b0:70d:52ca:7e7d with SMTP id js17-20020a170906ca9100b0070d52ca7e7dmr374338ejb.552.1655852217771;
        Tue, 21 Jun 2022 15:56:57 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id z12-20020a50e68c000000b004358c3bfb4csm4540118edm.31.2022.06.21.15.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:56:56 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 2/3] conntrack.8: man update for -A command support
Date:   Wed, 22 Jun 2022 00:55:46 +0200
Message-Id: <20220621225547.69349-3-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220621225547.69349-1-mikhail.sennikovskii@ionos.com>
References: <20220621225547.69349-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 conntrack.8     | 11 ++++++++---
 src/conntrack.c |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index 0db427b..b1d859f 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -14,6 +14,8 @@ conntrack \- command line interface for netfilter connection tracking
 .br
 .BR "conntrack -I [table] parameters"
 .br
+.BR "conntrack -A [table] parameters"
+.br
 .BR "conntrack -U [table] parameters"
 .br
 .BR "conntrack -E [table] [options]"
@@ -90,6 +92,9 @@ Delete an entry from the given table.
 .BI "-I, --create "
 Create a new entry from the given table.
 .TP
+.BI "-A, --add "
+Same as -I but do not fail if entry exists.
+.TP
 .BI "-U, --update "
 Update an entry from the given table.
 .TP
@@ -186,8 +191,8 @@ Use multiple \-l options to specify multiple labels that need to be set.
 .TP
 .BI "--label-add " "LABEL"
 Specify the conntrack label to add to the selected conntracks.
-This option is only available in conjunction with "\-I, \-\-create" or
-"\-U, \-\-update".
+This option is only available in conjunction with "\-I, \-\-create",
+"\-A, \-\-add" or "\-U, \-\-update".
 .TP
 .BI "--label-del " "[LABEL]"
 Specify the conntrack label to delete from the selected conntracks.
@@ -233,7 +238,7 @@ Specify the source address mask.
 For conntracks this option is only available in conjunction with
 "\-L, \-\-dump", "\-E, \-\-event", "\-U \-\-update" or "\-D \-\-delete".
 For expectations this option is only available in conjunction with
-"\-I, \-\-create".
+"\-I, \-\-create" or "\-A, \-\-add".
 .TP
 .BI "--mask-dst " IP_ADDRESS
 Specify the destination address mask.
diff --git a/src/conntrack.c b/src/conntrack.c
index 465a4f9..eace281 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -359,6 +359,7 @@ static const char *optflags[NUMBER_OF_OPT] = {
 static struct option original_opts[] = {
 	{"dump", 2, 0, 'L'},
 	{"create", 2, 0, 'I'},
+	{"add", 2, 0, 'A'},
 	{"delete", 2, 0, 'D'},
 	{"update", 2, 0, 'U'},
 	{"get", 2, 0, 'G'},
-- 
2.25.1

