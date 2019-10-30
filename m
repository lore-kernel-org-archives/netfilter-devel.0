Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DADDCA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 11:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E267420862
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 11:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfJ3LZs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 07:25:48 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:41140 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfJ3LZs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 07:25:48 -0400
Received: by mail-wr1-f49.google.com with SMTP id p4so1855633wrm.8
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 04:25:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=5bc/+9X5RthPFQUS+u1D3DTphTBlkOG9MODeuDZovY8=;
        b=ROuhcSfwLUyv+Fff54EyfwH3ZZE57YPlLd6JwYI9TLXyUEXydoA/c71Z0eYQc32C1x
         s1lcH1eM/3JLB8BN+FFe6NMqmAWVtJlcVaL/EMytOnD83jaxjd+P68CmOQfJHLXmv4QT
         RMdXFjZqiOI4IZdvuMeZejvgFxwWC7xD+Sb5rYS2epmIKo0298HiL+s2ZlJSyCFn5Eq1
         JdKvgXl1LWbPY6DRkvYHXBEft4FdzPLa7CJaDcmLPu16OMNped5cOSTpCWC9MISA0eCB
         OH9jREaIIPlNHLZEZS2mwxQJw+HbspiwBS2bi0CSX7SCt6gFYeCBiwnz+0LMRjTApjws
         S9mQ==
X-Gm-Message-State: APjAAAU2Op4kqZK2kD/jyv1sDf641vB9CcPWb36wQx+QDyrRWi+OqPKC
        3yyQcq8kNqH1E1llGeiSbw1SRGkvrkE=
X-Google-Smtp-Source: APXvYqxrndsCXZzDnvUocjSxkjAlWWhoMHG4JLDl8YQawratFYhupbpUQHi+Wsrk3ZIGRKxRkOo9tA==
X-Received: by 2002:adf:f2d1:: with SMTP id d17mr23432549wrp.353.1572434746340;
        Wed, 30 Oct 2019 04:25:46 -0700 (PDT)
Received: from localhost ([213.194.137.137])
        by smtp.gmail.com with ESMTPSA id r3sm2085342wmh.9.2019.10.30.04.25.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 04:25:45 -0700 (PDT)
Subject: [conntrack-tools PATCH] docs: refresh references to
 /proc/net/core/rmem_default
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 30 Oct 2019 12:25:44 +0100
Message-ID: <157243474476.18436.2577872078650825326.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In recent kernel versions, /proc/net/core/rmem_default is now
/proc/sys/net/core/rmem_default instead.

Refresh docs that mention this file.

Reported-by: Raphaël Bazaud <rbazaud@gmail.com>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 conntrackd.conf.5                |    2 +-
 doc/sync/alarm/conntrackd.conf   |    2 +-
 doc/sync/ftfw/conntrackd.conf    |    2 +-
 doc/sync/notrack/conntrackd.conf |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 2634a7f..673f895 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -530,7 +530,7 @@ Default is \fB/var/lock/conntrack.lock\fP.
 .TP
 .BI "NetlinkBufferSize <value>"
 Netlink event socket buffer size. If you do not specify this clause, the
-default buffer size value in \fB/proc/net/core/rmem_default\fP is used. This
+default buffer size value in \fB/proc/sys/net/core/rmem_default\fP is used. This
 default value is usually around \fB100 Kbytes\fP which is fairly small for
 busy firewalls. This leads to event message dropping and high CPU consumption.
 
diff --git a/doc/sync/alarm/conntrackd.conf b/doc/sync/alarm/conntrackd.conf
index b689ae6..53af4f2 100644
--- a/doc/sync/alarm/conntrackd.conf
+++ b/doc/sync/alarm/conntrackd.conf
@@ -266,7 +266,7 @@ General {
 
 	#
 	# Netlink event socket buffer size. If you do not specify this clause,
-	# the default buffer size value in /proc/net/core/rmem_default is
+	# the default buffer size value in /proc/sys/net/core/rmem_default is
 	# used. This default value is usually around 100 Kbytes which is
 	# fairly small for busy firewalls. This leads to event message dropping
 	# and high CPU consumption. This example configuration file sets the
diff --git a/doc/sync/ftfw/conntrackd.conf b/doc/sync/ftfw/conntrackd.conf
index 8267659..8733834 100644
--- a/doc/sync/ftfw/conntrackd.conf
+++ b/doc/sync/ftfw/conntrackd.conf
@@ -289,7 +289,7 @@ General {
 
 	#
 	# Netlink event socket buffer size. If you do not specify this clause,
-	# the default buffer size value in /proc/net/core/rmem_default is
+	# the default buffer size value in /proc/sys/net/core/rmem_default is
 	# used. This default value is usually around 100 Kbytes which is
 	# fairly small for busy firewalls. This leads to event message dropping
 	# and high CPU consumption. This example configuration file sets the
diff --git a/doc/sync/notrack/conntrackd.conf b/doc/sync/notrack/conntrackd.conf
index 8445b7d..23bee92 100644
--- a/doc/sync/notrack/conntrackd.conf
+++ b/doc/sync/notrack/conntrackd.conf
@@ -328,7 +328,7 @@ General {
 
 	#
 	# Netlink event socket buffer size. If you do not specify this clause,
-	# the default buffer size value in /proc/net/core/rmem_default is
+	# the default buffer size value in /proc/sys/net/core/rmem_default is
 	# used. This default value is usually around 100 Kbytes which is
 	# fairly small for busy firewalls. This leads to event message dropping
 	# and high CPU consumption. This example configuration file sets the

