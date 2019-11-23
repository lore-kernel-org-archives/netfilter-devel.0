Return-Path: <SRS0=6h+B=ZP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B218AC43215
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 16:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 891B820679
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 16:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FY6GS1Tb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfKWQWy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 11:22:54 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:46039 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfKWQWy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 11:22:54 -0500
Received: by mail-wr1-f48.google.com with SMTP id z10so12244585wrs.12
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2019 08:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6+Qx/XmSwdlysotzxgiZiCxvFiFPZy8Ir9yDCPVjwwY=;
        b=FY6GS1Tbj5Y9NuC6K70PeRpDx7BvOuCRABaRXGUosAjoCCN9HPSpz9LTVG8YUPpMd6
         lKD5YXsifAzTRJsVOb4YYn3VTWu70RFaMCr7eMK94Q5LoiNrUDZ+0+vWwvw/Lg+6vdwR
         Vx2Fe5mdLpy6WnAnzEoc2lJ35l61aJsAe+4cS1Cm15/rcmKeRIT+xszCNMaLKReBTFmZ
         y1BY/Ij5r4PjwmtuIikskoDrQ1etm2X2j1UHjoSQU+awlkfEexfwC/jGQY6h1+Jwil52
         uQJYC2mB52d8JFkr6wVg2etfMiMJHIG7kmasGrLBN9SNEO28I12Bb/uunP8Yt/kbtNys
         ZKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6+Qx/XmSwdlysotzxgiZiCxvFiFPZy8Ir9yDCPVjwwY=;
        b=PTqQvpQ6nCkSxGcOH3920+iMC16wJnU+mGsGBndiS6xmgvNfro8at2WL1A1dAT0nDt
         h62VCSyLvViRVCGkUWRh9jgO5wQodgt5GPGV8+UmdXajNqLKMBEwLPuEnoh6hO1UKUVx
         M78M8zAUXdCg1uTiipF5C0BSSiPiYw3uuA0nutMLk3xda4LqNDmZpZPd2zAyPSDI2vdk
         3r6L/EQAGd3PyGpmtuTBcEJtXsAGx8D8GCK1zlu40JUl50n9NsPgYLPe7uLUQPILtf8s
         G4ILqB8zDb5pkSecKIwLl/ZuENME9sPiaSkgeQa5FrDWEn0mjNPS4K52uJQ7S9Oil0i1
         7bUg==
X-Gm-Message-State: APjAAAVQ81E38OolNhdX8RKPqAWacnH2v2bzA72Vgx1Uyz5bZjVuU8Z8
        +bJMB/gAw7ofK7c8oEHd2xvGfiyZ
X-Google-Smtp-Source: APXvYqyuvUlxGTcV4x3CHoVLp+abWdkFR0zIwkfkC4EXsgvSPVunuiS1SUyzFbdEaj6hnVBI0ig6zA==
X-Received: by 2002:adf:f987:: with SMTP id f7mr23165999wrr.284.1574526170848;
        Sat, 23 Nov 2019 08:22:50 -0800 (PST)
Received: from desktopdebian.localdomain (x5f708d68.dyn.telefonica.de. [95.112.141.104])
        by smtp.gmail.com with ESMTPSA id z15sm2286598wmi.12.2019.11.23.08.22.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 08:22:50 -0800 (PST)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables v2 2/2] files: add example secmark config
Date:   Sat, 23 Nov 2019 17:22:40 +0100
Message-Id: <20191123162240.14571-2-cgzones@googlemail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191123162240.14571-1-cgzones@googlemail.com>
References: <20191123162240.14571-1-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
v2: add note about SELinux requirements for this example

 files/examples/Makefile.am |  1 +
 files/examples/secmark.nft | 87 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)
 create mode 100755 files/examples/secmark.nft

diff --git a/files/examples/Makefile.am b/files/examples/Makefile.am
index c40e041e..b29e9f61 100644
--- a/files/examples/Makefile.am
+++ b/files/examples/Makefile.am
@@ -1,4 +1,5 @@
 pkgdocdir = ${docdir}/examples
 dist_pkgdoc_SCRIPTS = ct_helpers.nft \
 		load_balancing.nft \
+		secmark.nft \
 		sets_and_maps.nft
diff --git a/files/examples/secmark.nft b/files/examples/secmark.nft
new file mode 100755
index 00000000..16f9a368
--- /dev/null
+++ b/files/examples/secmark.nft
@@ -0,0 +1,87 @@
+#!/usr/sbin/nft -f
+
+# This example file shows how to use secmark labels with the nftables framework.
+# This script is meant to be loaded with `nft -f <file>`
+# You require linux kernel >= 4.20 and nft >= 0.9.3
+# This example is SELinux based, for the secmark objects you require
+# SELinux enabled and a SELinux policy defining the stated contexts
+# For up-to-date information please visit https://wiki.nftables.org
+
+
+flush ruleset
+
+table inet filter {
+	secmark ssh_server {
+		"system_u:object_r:ssh_server_packet_t:s0"
+	}
+
+	secmark dns_client {
+		"system_u:object_r:dns_client_packet_t:s0"
+	}
+
+	secmark http_client {
+		"system_u:object_r:http_client_packet_t:s0"
+	}
+
+	secmark https_client {
+		"system_u:object_r:http_client_packet_t:s0"
+	}
+
+	secmark ntp_client {
+		"system_u:object_r:ntp_client_packet_t:s0"
+	}
+
+	secmark icmp_client {
+		"system_u:object_r:icmp_client_packet_t:s0"
+	}
+
+	secmark icmp_server {
+		"system_u:object_r:icmp_server_packet_t:s0"
+	}
+
+	secmark ssh_client {
+		"system_u:object_r:ssh_client_packet_t:s0"
+	}
+
+	secmark git_client {
+		"system_u:object_r:git_client_packet_t:s0"
+	}
+
+	map secmapping_in {
+		type inet_service : secmark
+		elements = { 22 : "ssh_server" }
+	}
+
+	map secmapping_out {
+		type inet_service : secmark
+		elements = { 22 : "ssh_client", 53 : "dns_client", 80 : "http_client", 123 : "ntp_client", 443 : "http_client", 9418 : "git_client" }
+	}
+
+	chain input {
+		type filter hook input priority 0;
+
+		# label new incoming packets and add to connection
+		ct state new meta secmark set tcp dport map @secmapping_in
+		ct state new meta secmark set udp dport map @secmapping_in
+		ct state new ip protocol icmp meta secmark set "icmp_server"
+		ct state new ip6 nexthdr icmpv6 meta secmark set "icmp_server"
+		ct state new ct secmark set meta secmark
+
+		# set label for est/rel packets from connection
+		ct state established,related meta secmark set ct secmark
+	}
+
+	chain output {
+		type filter hook output priority 0;
+
+		# label new outgoing packets and add to connection
+		ct state new meta secmark set tcp dport map @secmapping_out
+		ct state new meta secmark set udp dport map @secmapping_out
+		ct state new ip protocol icmp meta secmark set "icmp_client"
+		ct state new ip6 nexthdr icmpv6 meta secmark set "icmp_client"
+		ct state new ct secmark set meta secmark
+
+		# set label for est/rel packets from connection
+		ct state established,related meta secmark set ct secmark
+	}
+}
-- 
2.24.0

