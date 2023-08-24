Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85159C3DA6F
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 12:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241333AbjHXMKc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 08:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241370AbjHXMKX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 08:10:23 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0773519AD
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 05:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5VTIKm09kADhrbWz4WA7FCHjCXjjdFHzhdqvaF4It9w=; b=fiizLc7rNA1eVCioV+gjDhIqbV
        jXiJScj2oNJAwsRjd6MWyBGYtXVwpNX46sMNDzXahsgLu8hIhMYnHYbdZF8oZ3OGSPROj17oYZVU5
        VW59yfsn4fWiktECB6cDAEx6chBA/cmtGP/Ii0QmdBFtIBnbrx+mcWUcGl4XBcbEouikJs489yQI7
        LSRmVEhvfi8VJISrqUCK87W8be+QRSt50IDyTM6jT16zR9KeOhLrOi+nS02BEks/9/dcfd44xj+3A
        980S6Ocdu9vdjC+lqeJQOlhooWl1P9b6WiQP4w556SSYv1FVlNJT8A8OsjHAuUj33QcMR6pI7xltD
        NmXHoEHQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qZ9AE-00BlW7-2I
        for netfilter-devel@vger.kernel.org;
        Thu, 24 Aug 2023 13:10:14 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH conntrack-tools] conntrack, nfct: fix some typo's
Date:   Thu, 24 Aug 2023 13:10:07 +0100
Message-Id: <20230824121007.679770-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Four misspellings and a missing pronoun.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 conntrack.8       | 2 +-
 conntrackd.conf.5 | 4 ++--
 nfct.8            | 2 +-
 src/conntrack.c   | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index 6fbb41fe81fc..031eaa4e9fef 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -180,7 +180,7 @@ Specify the conntrack mark.  Optionally, a mask value can be specified.
 In "\-\-update" mode, this mask specifies the bits that should be zeroed before
 XORing the MARK value into the ctmark.
 Otherwise, the mask is logically ANDed with the existing mark before the
-comparision. In "\-\-create" mode, the mask is ignored.
+comparison. In "\-\-create" mode, the mask is ignored.
 .TP
 .BI "-l, --label " "LABEL"
 Specify a conntrack label.
diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index a73c3f715df9..50d7b989a942 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -52,7 +52,7 @@ You should consider this file as case-sensitive.
 Empty lines and lines starting with the '#' character are ignored.
 
 Before starting to develop a new configuration, you may want to learn the
-concepts behind this technlogy at
+concepts behind this technology at
 \fIhttp://conntrack-tools.netfilter.org/manual.html\fP.
 
 There are complete configuration examples at the end of this man page.
@@ -630,7 +630,7 @@ filter-sets in positive or negative logic depending on your needs.
 You can select if \fBconntrackd(8)\fP filters the event messages from
 user-space or kernel-space. The kernel-space event filtering saves some CPU
 cycles by avoiding the copy of the event message from kernel-space to
-user-space. The kernel-space event filtering is prefered, however, you require
+user-space. The kernel-space event filtering is preferred, however, you require
 a \fBLinux kernel >= 2.6.29\fP to filter from kernel-space.
 
 The syntax for this section is: \fBFilter From <from> { }\fP.
diff --git a/nfct.8 b/nfct.8
index c38bdbe45788..b130a8804c4a 100644
--- a/nfct.8
+++ b/nfct.8
@@ -8,7 +8,7 @@ nfct \- command line tool to configure with the connection tracking system
 .BR "nfct command subsystem [parameters]"
 .SH DESCRIPTION
 .B nfct
-is the command line tool that allows to configure the Connection Tracking
+is the command line tool that allows you to configure the Connection Tracking
 System.
 .SH COMMANDS
 .TP
diff --git a/src/conntrack.c b/src/conntrack.c
index 77c60b9391a5..f9758d78d39b 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -538,7 +538,7 @@ static const char usage_parameters[] =
 	"Common parameters and options:\n"
 	"  -s, --src, --orig-src ip\t\tSource address from original direction\n"
 	"  -d, --dst, --orig-dst ip\t\tDestination address from original direction\n"
-	"  -r, --reply-src ip\t\tSource addres from reply direction\n"
+	"  -r, --reply-src ip\t\tSource address from reply direction\n"
 	"  -q, --reply-dst ip\t\tDestination address from reply direction\n"
 	"  -p, --protonum proto\t\tLayer 4 Protocol, eg. 'tcp'\n"
 	"  -f, --family proto\t\tLayer 3 Protocol, eg. 'ipv6'\n"
-- 
2.40.1

