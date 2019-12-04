Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3F3C2BC73
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BFFB20675
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731786AbfLDSSe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 13:18:34 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:55755 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729752AbfLDSSb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 13:18:31 -0500
Received: by mail-wm1-f44.google.com with SMTP id q9so727603wmj.5
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2019 10:18:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=v1dEB226tVUhDoUO1O/MaZNX6Bpfsc6ehL5Xf+wDiCg=;
        b=MYitOAA8+/jwFLaCSln2orJYiFkuKDOkzJC4FgbfWCxBogj5Ei995ws7ZAHaUrYEtk
         FL+NsKnwaXyB4bwdTYyhrhpM6eJVIo+gBIhWmlIS+CT6Qz63+22o8OYq5j2o6XsitWmu
         Nf0Sc4S7bktbygt985DlvjGk3d25LKjEVyVvAR+ENSWDVRy1UCLr9wyheWLByZ+Uy7HQ
         Kfu+VqUzPhFaCncg5LBPcwxD+ZI4izsr8YFcDnxE7IDwRmujdB4wsrwQ8PeEgMZf8nOf
         PfrAxZITDV9E9F2YAO/q3aPUlA+INleNc36vVI5glHwL9X073Lk/YnY2+v28SRSItL9k
         YDDg==
X-Gm-Message-State: APjAAAUy/+n9VxgSqIpNJ/r7GyEigf3tG055Plc9zvqXpa3M1yhqCS5a
        EGSD6DqPl0xoUjYfiNH8J2TgXSk5NsI=
X-Google-Smtp-Source: APXvYqywPh+8fU/Fs9Q93iOOeR1cUgRPul7cYF/7+l/GTmgRAGrXdJQPmGeImbHVZaqE+T7GRqVQ/w==
X-Received: by 2002:a1c:6207:: with SMTP id w7mr972073wmb.16.1575483509666;
        Wed, 04 Dec 2019 10:18:29 -0800 (PST)
Received: from localhost (static.68.138.194.213.ibercom.com. [213.194.138.68])
        by smtp.gmail.com with ESMTPSA id i8sm9520307wro.47.2019.12.04.10.18.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:18:29 -0800 (PST)
Subject: [iptables PATCH 6/7] extensions: libxt_sctp: add manpage description
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 04 Dec 2019 19:18:28 +0100
Message-ID: <157548350795.125234.2883039836212323040.stgit@endurance>
In-Reply-To: <157548347377.125234.12163057581146113349.stgit@endurance>
References: <157548347377.125234.12163057581146113349.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Laurence J. Lane <ljlane@debian.org>

Add manpage description.

Arturo says:
 This patch is forwarded from the iptables Debian package, where it has been
 around for many years now.

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 extensions/libxt_sctp.man |    1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/libxt_sctp.man b/extensions/libxt_sctp.man
index 9c0bd8c3..3779d05a 100644
--- a/extensions/libxt_sctp.man
+++ b/extensions/libxt_sctp.man
@@ -1,3 +1,4 @@
+This module matches Stream Control Transmission Protocol headers.
 .TP
 [\fB!\fP] \fB\-\-source\-port\fP,\fB\-\-sport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP

