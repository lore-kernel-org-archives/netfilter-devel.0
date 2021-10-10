Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBF5C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Oct 2021 10:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5270060F43
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Oct 2021 10:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhJJKlz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Oct 2021 06:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhJJKly (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Oct 2021 06:41:54 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA076C061570
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Oct 2021 03:39:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r2so7989354pgl.10
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Oct 2021 03:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rm2/vCVxOFua6EuktdHeSsPSjG6kitx/tJHtaL4aKMg=;
        b=nxs/TyszoFDDlUPIukyQuOzm5RvLENqJ11Iar7vj26M/rxI6f5HJnTQzGm72pXCM7Q
         QddYJz5J7QPGbjBGp7ZTYZrKlelHHX8MWlgi1Hu5psYy4lkZaxMatkBdlBVq+VT/4FCt
         vTbhfca64U6ALWN6Wx8AIWyp7hYo4t3QKHKAUA6FTRXzK0LgF5uaSxljLrX04MXsJrBr
         WI73nRZ3vlnLjfv7ltKo2oAQXeJTCbI/76eAN1eXZOLh2eNNaf5gtRL5NIu30nnGgizP
         CxX2MJlWGIAZSiA4x2xqax/0JeoIB+OJawrXWt/m8hKXihZaMEwbS3nPdRFala4Ounqk
         Gagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Rm2/vCVxOFua6EuktdHeSsPSjG6kitx/tJHtaL4aKMg=;
        b=ltp6CwER9qskmfMSdcWsEy37dLWMpM4NKpjL119THkE2NYpdjQ2YzmBuWzOZv80an/
         5IzAYTv7QfiKHz3wYvob8dnrBzNp/761WovxbHZr6AgWY5DisqHVoxGjhKqg9lNH85nY
         uQhY5MrzTSWjmlU4EYOMDUehJbnaV07A6Sje9jr6DztNkhqgW6nA0PYIgRmncsN2QKel
         PKCaXQzn65Mn7pN72s39LL1lhhYAVF++9h39oNtllgTvXQteCq67p2aj2BHJeUDtLM/R
         FlGk17LkJpSPUkiWkkFBOEL9jzOcv9nlu4D1xkFEwY+yaWA66/bg6KC3TnxZyRyrAuTM
         q9BA==
X-Gm-Message-State: AOAM531gZw5QR8nwLMdDNXTaufZrv/QgVNpKvyh5RY+H1cjUD37oCoiR
        DzWjG1drZf4R0jG80EFJWsXrX9cw6ts=
X-Google-Smtp-Source: ABdhPJxBzR6s/JVxgRU+mC4XIV2KwOlJIjH3erjiFKktKDb3AUcbEOIL5V+KW3kjeREVOQT7YIxdZw==
X-Received: by 2002:a63:b00e:: with SMTP id h14mr13408236pgf.135.1633862396362;
        Sun, 10 Oct 2021 03:39:56 -0700 (PDT)
Received: from faith.kottiga.ml ([240f:82:1adf:1:cee1:d5ff:fe3f:5153])
        by smtp.gmail.com with ESMTPSA id 197sm4294803pfv.6.2021.10.10.03.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 03:39:56 -0700 (PDT)
Sender: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
From:   Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
To:     netfilter-devel@vger.kernel.org
Cc:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: [PATCH] conntrack: fix invmap_icmpv6 entries
Date:   Sun, 10 Oct 2021 19:39:15 +0900
Message-Id: <20211010103914.43598-1-chamas@h4.dion.ne.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/conntrack/proto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/conntrack/proto.c b/src/conntrack/proto.c
index ba79b9b..03b37c0 100644
--- a/src/conntrack/proto.c
+++ b/src/conntrack/proto.c
@@ -15,8 +15,8 @@ static const uint8_t invmap_icmp[] = {
 static const uint8_t invmap_icmpv6[] = {
 	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
 	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
-	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
-	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_REPLY + 1
+	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_REPLY + 1,
+	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_QUERY + 1
 };
 
 uint8_t __icmp_reply_type(uint8_t type)
-- 
2.30.2

