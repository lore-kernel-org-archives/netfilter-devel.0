Return-Path: <SRS0=U5qg=5O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C35EC43331
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Mar 2020 09:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4239120675
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Mar 2020 09:06:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UWxIKpyu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbgC2JG2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 05:06:28 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:43688 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbgC2JG2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 05:06:28 -0400
Received: by mail-lf1-f48.google.com with SMTP id n20so11346382lfl.10
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2020 02:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vdlCT5q50k7umXevaLEUeTdn9FMk6+4Gbjr1dO9FjA0=;
        b=UWxIKpyuPEzoVUJb+LGUwbHpY66exe48w8zXgnHl6B/K0DeWA0GPv+9syDatu3f5YO
         rT1W58FruWAPEMdPfFKScDUzlbHkUqJUxv8rx32cmXzaFeKeEYqhafH6Yh7IGBoSAjo6
         GQr5s91+GScAYdZ9n2FbdMag8McR4gIP9N9MiUWGPYcvcxzjC+NV9tQXU1nApkp3sFC6
         fAFF+ZfbLfM0PLGdd5qSS48PLAlpXMsqWBVefXakb3X7mm8q5DZPhE3T1jxJfPEKC7+M
         //4t34nakn++Fs81H6JFdvTR0KlsVKUC/VyNuWiF0A8ND8GSTRcjLpf387xRn8KlbXCA
         NwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vdlCT5q50k7umXevaLEUeTdn9FMk6+4Gbjr1dO9FjA0=;
        b=XC/Kd8XQnJdRBplPYacCa6A0Eu4xieOjRm6iKN/eqHEDPxdPwUA5hA+vuYthsIHWHl
         6RJIGWETepT7FnUBHm6sTGLgDA+RgqYCLwlxZZGEceGhPrgPiG+ARfv99e+4ssMGV5xE
         lMw44cXBTGyPlpIU0qc5xTEciV5O7Ke2raDoUmlaaXAXNaIjrvATXXfkmtCycBZ3eZ4U
         GAQvdHwrzTGGU0lFb1cTB9Acu8olWIytFA5XnJeAF4bfF9kP3QyANOvYz1N0Pvc0EyaG
         /il2U41Yq9ULQe3OBLHajOJ6qWOiXVv/3pwzn9TJAYJqZ+jt6zuLGuzp/eTki72F8AK7
         36HQ==
X-Gm-Message-State: AGi0PubvZAdz4n4abavtdqBDU4ssiGXDZrmVOGN98jai+XPiupD8SPOi
        y2BnMj4/KO26ZVnQMwMLcsLHcefR3htw1A==
X-Google-Smtp-Source: APiQypKxla/S0Arzfppiy3cbor8XbqPD7biY19Dig0FoEynby5HD1qMDmUOO1tpC+mIR+IPopiwKng==
X-Received: by 2002:ac2:5edc:: with SMTP id d28mr4805966lfq.59.1585472786280;
        Sun, 29 Mar 2020 02:06:26 -0700 (PDT)
Received: from localhost.lan ([45.131.71.14])
        by smtp.gmail.com with ESMTPSA id s14sm5793954ljs.63.2020.03.29.02.06.24
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sun, 29 Mar 2020 02:06:25 -0700 (PDT)
From:   Youfu Zhang <zhangyoufu@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Youfu Zhang <zhangyoufu@gmail.com>
Subject: [iptables] avoid raw sockets which requires CAP_NET_RAW
Date:   Sun, 29 Mar 2020 17:06:19 +0800
Message-Id: <20200329090619.64701-1-zhangyoufu@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CAP_NET_RAW is not necessary for xtables to function properly.
Netfilter socket options are reachable from TCP/UDP sockets.
Netlink is datagram-oriented, accept both SOCK_RAW and SOCK_DGRAM.

Signed-off-by: Youfu Zhang <zhangyoufu@gmail.com>
---
 extensions/libxt_set.h | 2 +-
 libipq/libipq.c        | 4 ++--
 libiptc/libiptc.c      | 2 +-
 libxtables/xtables.c   | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_set.h b/extensions/libxt_set.h
index 41dfbd30..9cdf3636 100644
--- a/extensions/libxt_set.h
+++ b/extensions/libxt_set.h
@@ -11,7 +11,7 @@
 static int
 get_version(unsigned *version)
 {
-	int res, sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
+	int res, sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
 	struct ip_set_req_version req_version;
 	socklen_t size = sizeof(req_version);
 	
diff --git a/libipq/libipq.c b/libipq/libipq.c
index fb65971a..e703a39c 100644
--- a/libipq/libipq.c
+++ b/libipq/libipq.c
@@ -220,9 +220,9 @@ struct ipq_handle *ipq_create_handle(uint32_t flags, uint32_t protocol)
 	memset(h, 0, sizeof(struct ipq_handle));
 	
         if (protocol == NFPROTO_IPV4)
-                h->fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_FIREWALL);
+                h->fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_FIREWALL);
         else if (protocol == NFPROTO_IPV6)
-                h->fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_IP6_FW);
+                h->fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_IP6_FW);
         else {
 		ipq_errno = IPQ_ERR_PROTOCOL;
 		free(h);
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 58882015..48f77e1a 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1309,7 +1309,7 @@ retry:
 		return NULL;
 	}
 
-	sockfd = socket(TC_AF, SOCK_RAW, IPPROTO_RAW);
+	sockfd = socket(TC_AF, SOCK_DGRAM, IPPROTO_UDP);
 	if (sockfd < 0)
 		return NULL;
 
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 777c2b08..ccc7f580 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -832,7 +832,7 @@ int xtables_compatible_revision(const char *name, uint8_t revision, int opt)
 	socklen_t s = sizeof(rev);
 	int max_rev, sockfd;
 
-	sockfd = socket(afinfo->family, SOCK_RAW, IPPROTO_RAW);
+	sockfd = socket(afinfo->family, SOCK_DGRAM, IPPROTO_UDP);
 	if (sockfd < 0) {
 		if (errno == EPERM) {
 			/* revision 0 is always supported. */
-- 
2.23.0

