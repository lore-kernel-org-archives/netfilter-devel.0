Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEAEC43215
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 17:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 741782080F
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 17:44:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="OnsNRxoK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfKTRoM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 12:44:12 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:40878 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbfKTRoL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 12:44:11 -0500
Received: by mail-wm1-f45.google.com with SMTP id y5so555514wmi.5
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 09:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SIsJUnddEFQqRA11q2ufP8j3idr4nSBEYlG7RuUdNHE=;
        b=OnsNRxoK8Hd5parWLLwdagivEQztSWcYesdItL5l76R6DE0lM0+MFYGYAxTfEnuZ6R
         pnxpxVWah2Dir+dUzpJjw49mrJ1ZeMR7sfr+bvg3k6Um5Sb192TKCYvUAh3WZX2i1Y6w
         uXqRZz0z8ropH8Vu0+nURYKOwtCjyBqDTxGPIzb/SEQJfeNgggyFgsyhu0BZBE/LpcEK
         AepogozjquKNtkspah+1cTqK5KjgN+qAHT2FenIQMI43GxWt0Qxm4BHtOz0ioHSPsoAK
         54wSiGwEnUY7tu+63F5+74OhQEEy5kTzYyyO3/jS1r4xZKg/SHWWHQHOEe6A4kYu1yO6
         e0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SIsJUnddEFQqRA11q2ufP8j3idr4nSBEYlG7RuUdNHE=;
        b=Y4JfUIqAXMgvhfKfMuDQvBpjVL1X8wHOw0ek1ldlwn909/baqrWa3k1eF/T50DJMKv
         B6HRXvvpI5HvFiPces04NguPR2O9pmuxq2WNW2hYRUW2E+6XwRTAaYkKuuHFhlwYBV1L
         dFb/qiB3ioKGFUIhPn/+k/sBaHKwVz2tSNpBN3jfeklPqyhdFqBeXloIJ4q19iVLaQD3
         aL/dY1m2KVVHandOMkNEjOVp/TwjUVkqRORAxOzFzB/QIavf9kLIJcjUw3sXO+mM2mPL
         fQ2icQscEgEgTlGNvMQBvaB1cTNm5D+ai37r0HE7AmMnitlkwQ1z8YXmSTDJi9+YNmD6
         49UQ==
X-Gm-Message-State: APjAAAW0Pz6jivhabyOlRcDgjMI3BAYQUzWLMNJeWV4NemDFm6a/wnpP
        h7UcAP/s9zvfjiTA0xxgi40xvPNs
X-Google-Smtp-Source: APXvYqyE2F4prXhQ3yOeI06iAxTVCl33VbKIDEXzRtemwMWryUdV3iK0FVF9JzLmuQUwIcBtANpBpQ==
X-Received: by 2002:a1c:152:: with SMTP id 79mr4584160wmb.70.1574271849274;
        Wed, 20 Nov 2019 09:44:09 -0800 (PST)
Received: from desktopdebian.localdomain (x4d06663e.dyn.telefonica.de. [77.6.102.62])
        by smtp.gmail.com with ESMTPSA id m3sm34558580wrb.67.2019.11.20.09.44.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 09:44:08 -0800 (PST)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [RFC 3/4] files: add example secmark config
Date:   Wed, 20 Nov 2019 18:43:56 +0100
Message-Id: <20191120174357.26112-3-cgzones@googlemail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120174357.26112-1-cgzones@googlemail.com>
References: <20191120174357.26112-1-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 files/examples/Makefile.am |  1 +
 files/examples/secmark.nft | 85 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)
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
index 00000000..0e010056
--- /dev/null
+++ b/files/examples/secmark.nft
@@ -0,0 +1,85 @@
+#!/usr/sbin/nft -f
+
+# This example file shows how to use secmark labels with the nftables framework.
+# This script is meant to be loaded with `nft -f <file>`
+# You require linux kernel >= 4.20 and nft >= 0.9.3
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

