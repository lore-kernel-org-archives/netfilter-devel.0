Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682D6C04FF3
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 09:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4185F610C8
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 09:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhEXJzH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 May 2021 05:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhEXJzH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 May 2021 05:55:07 -0400
X-Greylist: delayed 336 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 May 2021 02:53:39 PDT
Received: from agnus.defensec.nl (agnus.defensec.nl [IPv6:2001:985:d55d::711])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC176C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 24 May 2021 02:53:39 -0700 (PDT)
Received: from brutus.. (brutus.lan [IPv6:2001:985:d55d::438])
        by agnus.defensec.nl (Postfix) with ESMTPSA id 7889E2A00D4;
        Mon, 24 May 2021 11:47:59 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 agnus.defensec.nl 7889E2A00D4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=defensec.nl;
        s=default; t=1621849679;
        bh=lio93LkWtssf5BsQ39mLjTM6VTB4kN6cnFex/OZcsVU=;
        h=From:To:Cc:Subject:Date:From;
        b=H+d4ALAsHHdnA+vJe2A9lECfsvPswoG9RL/BSeXdxXwXLz1jdZ4XjdAAIj6udNGJL
         E7oOubwtE4pJRtnUOYlKdaC2v3yojF6PFaGEMwxr+3n8BGGLuqwKQbJMf4wb9FHyhm
         +P7hO/VlrCKsUgv6cc0Fle5qSKqN0PFs6icKxhW0=
From:   Dominick Grift <dominick.grift@defensec.nl>
To:     netfilter-devel@vger.kernel.org
Cc:     Dominick Grift <dominick.grift@defensec.nl>
Subject: [nftables PATCH] files: improve secmark.nft example
Date:   Mon, 24 May 2021 11:47:51 +0200
Message-Id: <20210524094751.195065-1-dominick.grift@defensec.nl>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

use proper priorities to ensure that ct works properly

Signed-off-by: Dominick Grift <dominick.grift@defensec.nl>
---
 files/examples/secmark.nft | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/files/examples/secmark.nft b/files/examples/secmark.nft
index 16f9a368..c923cebb 100755
--- a/files/examples/secmark.nft
+++ b/files/examples/secmark.nft
@@ -10,7 +10,7 @@
 
 flush ruleset
 
-table inet filter {
+table inet x {
 	secmark ssh_server {
 		"system_u:object_r:ssh_server_packet_t:s0"
 	}
@@ -57,8 +57,8 @@ table inet filter {
 		elements = { 22 : "ssh_client", 53 : "dns_client", 80 : "http_client", 123 : "ntp_client", 443 : "http_client", 9418 : "git_client" }
 	}
 
-	chain input {
-		type filter hook input priority 0;
+	chain y {
+		type filter hook input priority -225;
 
 		# label new incoming packets and add to connection
 		ct state new meta secmark set tcp dport map @secmapping_in
@@ -71,8 +71,8 @@ table inet filter {
 		ct state established,related meta secmark set ct secmark
 	}
 
-	chain output {
-		type filter hook output priority 0;
+	chain z {
+		type filter hook output priority 225;
 
 		# label new outgoing packets and add to connection
 		ct state new meta secmark set tcp dport map @secmapping_out
-- 
2.31.1

