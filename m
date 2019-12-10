Return-Path: <SRS0=RCn+=2A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD71C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 11:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1905B20663
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 11:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfLJLAu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:00:50 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37968 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfLJLAu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 06:00:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so19516921wrh.5
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2019 03:00:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=5bmrwKXupxytirc7k+S5eJwkTlGagR3Za65bLOXDe9k=;
        b=TqKBUdqxR8UTM8gwOeIHnTiEQdyp8mbtqS/0Q024uxV1DDIwMAcsphcxCEYqwq95ws
         56DYsg9oxbZtzOdnLIPN+coaAFSKwu84HDcj+UZcgfRI94uxUbWlsnjmuRRmqCez5DDj
         Gm6poAn6cEYGJ03q9E8mghYsFBPIzJBjpvhDjNLP/zoM3wj06ejZAd8kCaI03LpmXCGq
         K9tU6pICY08hIeupK7LWP8QjphQ+y9xj/GPOs08XcbTCLfFZVcQ3w77ZAZ7tCr9sSVkb
         rFZXYnKbLxGgd9XTCQvExRJwMMTwG5aazW8go8yFRdyaHz/FwW9Zf3Phug5UU9QgYW0E
         l2QA==
X-Gm-Message-State: APjAAAVAXFb4nRCMc+e0g8sFFvdPMW3qkv5+Edv0GRETsH03kP+XuRw7
        mUmhz0swQ0S2wlJgl6u16B6G392u
X-Google-Smtp-Source: APXvYqx8iE5xYfSVA1ZzGmFYL/KqsCVwhDFM7ehKndMdmwq/d17boFc32ijI6wKAh+R+mPIljNBCCA==
X-Received: by 2002:adf:9b83:: with SMTP id d3mr2529473wrc.54.1575975647764;
        Tue, 10 Dec 2019 03:00:47 -0800 (PST)
Received: from localhost ([213.194.138.68])
        by smtp.gmail.com with ESMTPSA id a84sm2656957wme.44.2019.12.10.03.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:00:47 -0800 (PST)
Subject: [nft PATCH] py: load the SONAME-versioned shared object
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     biebl@debian.org, phil@nwl.cc, eric@garver.life
Date:   Tue, 10 Dec 2019 12:00:45 +0100
Message-ID: <157597564558.35612.1732679016499221966.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instruct the python module to load the SONAME versioned shared object.

Normal end-user systems may only have available libnftables.so.1.0.0 and not
libnftables.so which is usually only present in developer systems.

In Debian systems, for example:

 % dpkg -L libnftables1 | grep so.1
 /usr/lib/x86_64-linux-gnu/libnftables.so.1.0.0
 /usr/lib/x86_64-linux-gnu/libnftables.so.1

 % dpkg -L libnftables-dev | grep so
 /usr/lib/x86_64-linux-gnu/libnftables.so

The "1" is not a magic number, is the SONAME of libnftables in the current
version, as stated in Make_global.am.

Reported-by: Michael Biebl <biebl@debian.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 py/nftables.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/py/nftables.py b/py/nftables.py
index 48eb54fe..2a0a1e89 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -64,7 +64,7 @@ class Nftables:
 
     validator = None
 
-    def __init__(self, sofile="libnftables.so"):
+    def __init__(self, sofile="libnftables.so.1"):
         """Instantiate a new Nftables class object.
 
         Accepts a shared object file to open, by default standard search path

