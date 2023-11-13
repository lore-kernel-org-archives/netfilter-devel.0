Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27518C4167D
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjKMKcZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjKMKcY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:32:24 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A0910CA
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:32:20 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id C36BD587264C0; Mon, 13 Nov 2023 11:32:16 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id B53B558725FCB
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:32:14 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/7] man: consistent use of \(em in Name sections
Date:   Mon, 13 Nov 2023 11:30:06 +0100
Message-ID: <20231113103156.57745-2-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113103156.57745-1-jengelh@inai.de>
References: <20231113103156.57745-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/arptables-nft-restore.8 | 2 +-
 iptables/arptables-nft-save.8    | 2 +-
 iptables/arptables-nft.8         | 2 +-
 iptables/ebtables-nft.8          | 2 +-
 iptables/iptables-apply.8.in     | 2 +-
 utils/nfbpf_compile.8.in         | 2 +-
 utils/nfnl_osf.8.in              | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/iptables/arptables-nft-restore.8 b/iptables/arptables-nft-restore.8
index 09d9082c..0e525fe3 100644
--- a/iptables/arptables-nft-restore.8
+++ b/iptables/arptables-nft-restore.8
@@ -20,7 +20,7 @@
 .\"
 .\"
 .SH NAME
-arptables-restore \- Restore ARP Tables (nft-based)
+arptables-restore \(em Restore ARP Tables (nft-based)
 .SH SYNOPSIS
 \fBarptables\-restore
 .SH DESCRIPTION
diff --git a/iptables/arptables-nft-save.8 b/iptables/arptables-nft-save.8
index 905e5985..e9171d5d 100644
--- a/iptables/arptables-nft-save.8
+++ b/iptables/arptables-nft-save.8
@@ -20,7 +20,7 @@
 .\"
 .\"
 .SH NAME
-arptables-save \- dump arptables rules to stdout (nft-based)
+arptables-save \(em dump arptables rules to stdout (nft-based)
 .SH SYNOPSIS
 \fBarptables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
 .P
diff --git a/iptables/arptables-nft.8 b/iptables/arptables-nft.8
index ea31e084..659a2542 100644
--- a/iptables/arptables-nft.8
+++ b/iptables/arptables-nft.8
@@ -22,7 +22,7 @@
 .\"
 .\"
 .SH NAME
-arptables \- ARP table administration (nft-based)
+arptables \(em ARP table administration (nft-based)
 .SH SYNOPSIS
 .BR "arptables " [ "-t table" ] " -" [ AD ] " chain rule-specification " [ options ]
 .br
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index ca12e2df..9fc845a1 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -24,7 +24,7 @@
 .\"     
 .\"
 .SH NAME
-ebtables \- Ethernet bridge frame table administration (nft-based)
+ebtables \(em Ethernet bridge frame table administration (nft-based)
 .SH SYNOPSIS
 .BR "ebtables " [ -t " table ] " - [ ACDI "] chain rule specification [match extensions] [watcher extensions] target"
 .br
diff --git a/iptables/iptables-apply.8.in b/iptables/iptables-apply.8.in
index f0ed4e5f..5485199c 100644
--- a/iptables/iptables-apply.8.in
+++ b/iptables/iptables-apply.8.in
@@ -6,7 +6,7 @@
 .\" disable hyphenation
 .nh
 .SH NAME
-iptables-apply \- a safer way to update iptables remotely
+iptables-apply \(em a safer way to update iptables remotely
 .SH SYNOPSIS
 \fBiptables\-apply\fP [\-\fBhV\fP] [\fB-t\fP \fItimeout\fP] [\fB-w\fP \fIsavefile\fP] {[\fIrulesfile]|-c [runcmd]}\fP
 .SH "DESCRIPTION"
diff --git a/utils/nfbpf_compile.8.in b/utils/nfbpf_compile.8.in
index d02979a5..b19d4fbb 100644
--- a/utils/nfbpf_compile.8.in
+++ b/utils/nfbpf_compile.8.in
@@ -1,7 +1,7 @@
 .TH NFBPF_COMPILE 8 "" "@PACKAGE_STRING@" "@PACKAGE_STRING@"
 
 .SH NAME
-nfbpf_compile \- generate bytecode for use with xt_bpf
+nfbpf_compile \(em generate bytecode for use with xt_bpf
 .SH SYNOPSIS
 
 .ad l
diff --git a/utils/nfnl_osf.8.in b/utils/nfnl_osf.8.in
index 140b5c3f..7ade705a 100644
--- a/utils/nfnl_osf.8.in
+++ b/utils/nfnl_osf.8.in
@@ -1,7 +1,7 @@
 .TH NFNL_OSF 8 "" "@PACKAGE_STRING@" "@PACKAGE_STRING@"
 
 .SH NAME
-nfnl_osf \- OS fingerprint loader utility
+nfnl_osf \(em OS fingerprint loader utility
 .SH SYNOPSIS
 
 .ad l
-- 
2.42.1

