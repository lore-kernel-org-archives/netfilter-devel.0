Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3737DC43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 149CA206DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbfLDSSH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 13:18:07 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:34785 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731922AbfLDSSE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 13:18:04 -0500
Received: by mail-wr1-f48.google.com with SMTP id t2so377163wrr.1
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2019 10:18:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=kj7IN6qWXM5ZAsPIqVihLSWx0mjsdTOya/XoVSKMexc=;
        b=PWUOLaXKlizth8RcMLmyXQTYzMkpfvlP8tJ/EZt1y2KMlEKUHU7E6InVhvYflLx8CA
         6iItk7fIeBxWREEsM3XQbbjX+hgH47115wulbhJOkU0and+GXDzNVALTRtpb2SLvbP7/
         cI0oWZHgcQWq9eEYX2IF//5DaC8BhWotk/LXfw67431eif3ukvHo9U+K9FUREu7mEqNf
         u29CvnCg0NokTcXLlbWrTa0ryigpNYlxnCRQUB4UzgYV+T9XQ1N8R6jTb1SRcLvxUrHK
         1FiN8B0LCG5HEE3xvogMxID5sG73f8QiMpAM+BC7n+jmNdz1p8S71MOF+VwM27niMMbA
         9bDQ==
X-Gm-Message-State: APjAAAUhmIefVzNdOC8N9tNHnm7O4xOzjh1lxQOGD3ajdy5Q48ZcKJ8s
        Awjb4e2LrXYTxRVmsxSld09Ljz/Qzdw=
X-Google-Smtp-Source: APXvYqznLDBAYEMDLk2YC5sKMXONw1aTY832YwnUfPYN1FQ8zOTUDykgKiwL2o1Qay58CP/00jyTgg==
X-Received: by 2002:a05:6000:f:: with SMTP id h15mr5310472wrx.90.1575483482656;
        Wed, 04 Dec 2019 10:18:02 -0800 (PST)
Received: from localhost (static.68.138.194.213.ibercom.com. [213.194.138.68])
        by smtp.gmail.com with ESMTPSA id f1sm9193640wrp.93.2019.12.04.10.18.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:18:02 -0800 (PST)
Subject: [iptables PATCH 2/7] iptables: cleanup "allows to" usage
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 04 Dec 2019 19:18:00 +0100
Message-ID: <157548348081.125234.8160382864595983342.stgit@endurance>
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

Gramatical cleanup.

Arturo says:
 This patch is forwarded from the iptables Debian package, where it has been
 around for many years now.

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 extensions/libipt_ECN.man     |    2 +-
 extensions/libxt_AUDIT.man    |    2 +-
 extensions/libxt_CHECKSUM.man |    2 +-
 extensions/libxt_CT.man       |    2 +-
 extensions/libxt_DSCP.man     |    2 +-
 extensions/libxt_TCPMSS.man   |    2 +-
 extensions/libxt_osf.c        |    2 +-
 iptables/iptables.8.in        |    4 ++--
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/extensions/libipt_ECN.man b/extensions/libipt_ECN.man
index a9cbe109..8ae7996e 100644
--- a/extensions/libipt_ECN.man
+++ b/extensions/libipt_ECN.man
@@ -1,4 +1,4 @@
-This target allows to selectively work around known ECN blackholes.
+This target selectively works around known ECN blackholes.
 It can only be used in the mangle table.
 .TP
 \fB\-\-ecn\-tcp\-remove\fP
diff --git a/extensions/libxt_AUDIT.man b/extensions/libxt_AUDIT.man
index 4f5562e8..57cce8c4 100644
--- a/extensions/libxt_AUDIT.man
+++ b/extensions/libxt_AUDIT.man
@@ -1,4 +1,4 @@
-This target allows to create audit records for packets hitting the target.
+This target allows creates audit records for packets hitting the target.
 It can be used to record accepted, dropped, and rejected packets. See
 auditd(8) for additional details.
 .TP
diff --git a/extensions/libxt_CHECKSUM.man b/extensions/libxt_CHECKSUM.man
index 92ae700f..726f4ea6 100644
--- a/extensions/libxt_CHECKSUM.man
+++ b/extensions/libxt_CHECKSUM.man
@@ -1,4 +1,4 @@
-This target allows to selectively work around broken/old applications.
+This target selectively works around broken/old applications.
 It can only be used in the mangle table.
 .TP
 \fB\-\-checksum\-fill\fP
diff --git a/extensions/libxt_CT.man b/extensions/libxt_CT.man
index e992120a..fc692f9a 100644
--- a/extensions/libxt_CT.man
+++ b/extensions/libxt_CT.man
@@ -1,4 +1,4 @@
-The CT target allows to set parameters for a packet or its associated
+The CT target sets parameters for a packet or its associated
 connection. The target attaches a "template" connection tracking entry to
 the packet, which is then used by the conntrack core when initializing
 a new ct entry. This target is thus only valid in the "raw" table.
diff --git a/extensions/libxt_DSCP.man b/extensions/libxt_DSCP.man
index 551ba2e1..5385c97a 100644
--- a/extensions/libxt_DSCP.man
+++ b/extensions/libxt_DSCP.man
@@ -1,4 +1,4 @@
-This target allows to alter the value of the DSCP bits within the TOS
+This target alters the value of the DSCP bits within the TOS
 header of the IPv4 packet.  As this manipulates a packet, it can only
 be used in the mangle table.
 .TP
diff --git a/extensions/libxt_TCPMSS.man b/extensions/libxt_TCPMSS.man
index 8da8e761..25b480dd 100644
--- a/extensions/libxt_TCPMSS.man
+++ b/extensions/libxt_TCPMSS.man
@@ -1,4 +1,4 @@
-This target allows to alter the MSS value of TCP SYN packets, to control
+This target alters the MSS value of TCP SYN packets, to control
 the maximum size for that connection (usually limiting it to your
 outgoing interface's MTU minus 40 for IPv4 or 60 for IPv6, respectively).
 Of course, it can only be used
diff --git a/extensions/libxt_osf.c b/extensions/libxt_osf.c
index 496b4805..c567d9e0 100644
--- a/extensions/libxt_osf.c
+++ b/extensions/libxt_osf.c
@@ -40,7 +40,7 @@ static void osf_help(void)
 		"--ttl level            Use some TTL check extensions to determine OS:\n"
 		"       0                       true ip and fingerprint TTL comparison. Works for LAN.\n"
 		"       1                       check if ip TTL is less than fingerprint one. Works for global addresses.\n"
-		"       2                       do not compare TTL at all. Allows to detect NMAP, but can produce false results.\n"
+		"       2                       do not compare TTL at all. This allows NMAP detection, but can produce false results.\n"
 		"--log level            Log determined genres into dmesg even if they do not match desired one:\n"
 		"       0                       log all matched or unknown signatures.\n"
 		"       1                       log only first one.\n"
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 78df8f08..054564b3 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -245,13 +245,13 @@ add, delete, insert, replace and append commands).
 This option has no effect in iptables and iptables-restore.
 If a rule using the \fB\-4\fP option is inserted with (and only with)
 ip6tables-restore, it will be silently ignored. Any other uses will throw an
-error. This option allows to put both IPv4 and IPv6 rules in a single rule file
+error. This option allows IPv4 and IPv6 rules in a single rule file
 for use with both iptables-restore and ip6tables-restore.
 .TP
 \fB\-6\fP, \fB\-\-ipv6\fP
 If a rule using the \fB\-6\fP option is inserted with (and only with)
 iptables-restore, it will be silently ignored. Any other uses will throw an
-error. This option allows to put both IPv4 and IPv6 rules in a single rule file
+error. This option allows IPv4 and IPv6 rules in a single rule file
 for use with both iptables-restore and ip6tables-restore.
 This option has no effect in ip6tables and ip6tables-restore.
 .TP

