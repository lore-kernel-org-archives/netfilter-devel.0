Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766EEC3DA78
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Jan 2023 20:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjANU76 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Jan 2023 15:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjANU7v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Jan 2023 15:59:51 -0500
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6499847
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Jan 2023 12:59:49 -0800 (PST)
Received: by mail-wm1-f49.google.com with SMTP id q8so5615349wmo.5
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Jan 2023 12:59:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :to:from:subject:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lj2ZNj66zjzzJpYKqa3ZUs3MYaS51cNAbtCYzDkPhcc=;
        b=MLptS7ZYFXOCLHoT/dowiEoX0gy29DQ6vswx98BUpeKbUkd7QRod+PENsmuBqZEXWK
         52qC4yECBAUYKlDSl0Wg4YAuld48KB2dq2wDuZkSPYKM4+orCImIBcVXNJsXf3gGyXEy
         dqlqiYrQDJ05L3hyhkoziGDV3yQjPRWPkF8hwiJE3KaHVXsfxnPL2TV5zaKbvcOyYIJC
         sJuR8HXOtZpehQo6xsbrbyt0cTeGDFJwC32zmggLSnx42TZD5KbEzNGJk7Z7IExsgMhs
         eclWz2BcJ4dcWMNzlf+SEZfvq9//fNVGF5HoudAovbiJMnAv+AT3yUQUmXcfuwmgCPxY
         xT8Q==
X-Gm-Message-State: AFqh2krTGd6nwFEF3xD+xhPKIXl+X79GRtk+75BIRsYcfZfs1mluY+XH
        5KRE02P7V9Tn0ONrruE0ixPV2113l9o=
X-Google-Smtp-Source: AMrXdXscBubZn997CAKuCKnKyBBtX7muYJItd3yzSjxcU2AjWKp9+53nahKqMBVu1U2K1mE5kdlgcQ==
X-Received: by 2002:a05:600c:540d:b0:3da:f678:1d47 with SMTP id he13-20020a05600c540d00b003daf6781d47mr194315wmb.14.1673729988257;
        Sat, 14 Jan 2023 12:59:48 -0800 (PST)
Received: from localhost ([2a0c:5a85:a202:ef00:af78:1e88:4132:af3])
        by smtp.gmail.com with ESMTPSA id bh13-20020a05600c3d0d00b003d358beab9dsm28708948wmb.47.2023.01.14.12.59.47
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 12:59:47 -0800 (PST)
Subject: [iptables PATCH] iptables-test.py: make explicit use of python3
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Sat, 14 Jan 2023 21:59:47 +0100
Message-ID: <167372998704.237931.14378651440204180182.stgit@nostromo>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In most distros 'python' means python2, which is not available anywhere.
This is a problem when, for example, building the Debian package. This
script is called as part of the build but 'python' is not available.

Mention python3 explictly. The script runs just fine in python3.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 iptables-test.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables-test.py b/iptables-test.py
index de1e1e95..ef0a35d3 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
 #

