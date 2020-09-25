Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4DEC4727C
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE81321D7A
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:49:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="a4VBjnlB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgIYMtr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 08:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728944AbgIYMtq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:46 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B546C0613D3
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:46 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id u21so3495102eja.2
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Szcw+U76HIs6iefUa0ynf54phCV37I9aJ1dT8Lwzd5U=;
        b=a4VBjnlBTU7WVcRcF5weMpLGmJ9DpLZaHrcWgN6dQBph6xJazAiIoimc1HNlGwY7AH
         cYaxpSZrS7iNhj8DtlvLAgJMcMvC6zaNiQdQMvAJ2DqsmX1WECV8JZkdlppqeVFcL/wo
         xSz0POc8RVim58bdVZWn3UivFxVKNVDnYKhf03xp82kXjFg3oln1XaegCIeztz0L98KY
         o8wbgIi7AS7BCgyl1Jg72cozMTwJO1gA11NVhu3iZYadxH+qRerYvOQCxYmy9Utp0Rsm
         CzaiXNVVW4MERGFig9DJ9aWE9arznu93w+XkswCaU22Xoe3DiXHUS9DTBNR5GtiptgfM
         SjZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Szcw+U76HIs6iefUa0ynf54phCV37I9aJ1dT8Lwzd5U=;
        b=CHFZJfts+4ZcRRolr2rWTtGhnLLWNifULGPWgrVj15WmZngtsfLY4czwv2YFqEEaR4
         StJSBTf0+l0/0QkhjTGIP8is/WOHkEkqANd95tbCg4XPsjqSyf1jbX69No2myAvoacqZ
         y8BhRm1XbhcP3qDeoSSLEJ8ngCSw8NVbtocE6FM++ExQ0vaq6uOtAIR6c+C9qPGGzO8z
         552oVVAz5CFSru27PBnUYI4P74ImhybDdnEuOOqFtJxDrjC+5ptQPh5FKXZgW0S0HHC9
         qAtQSz895+6k8Mz1S71JHBvQAJenvMa+uhxo2yfRkPLZrkLcIE7+PjVqpF3TM4DyNwCC
         JBMA==
X-Gm-Message-State: AOAM532mSMwLlIcRMUL/4aR1O4I0FE4W/w/CCr0bQANIoXZMRqxqBwab
        K2tV+2YAkn6S9ILhUOfkRfcwPH0UKU1WFQ==
X-Google-Smtp-Source: ABdhPJzTqz+51Tr2jFY+0fN3RbcS0WXhiIP5W6VKB4ZfnKvEL60M2z3LN7Y5eHl9SCs36MLvjIpHDg==
X-Received: by 2002:a17:906:390d:: with SMTP id f13mr2531612eje.86.1601038184750;
        Fri, 25 Sep 2020 05:49:44 -0700 (PDT)
Received: from localhost.localdomain (dynamic-046-114-037-141.46.114.pool.telefonica.de. [46.114.37.141])
        by smtp.gmail.com with ESMTPSA id t3sm1761642edv.59.2020.09.25.05.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 05:49:44 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 4/8] conntrack.8: man update for stdin params support
Date:   Fri, 25 Sep 2020 14:49:15 +0200
Message-Id: <20200925124919.9389-5-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 conntrack.8 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/conntrack.8 b/conntrack.8
index 1174c6c..3db4849 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -135,6 +135,14 @@ to overrun the socket buffer. Note that using a big buffer reduces the chances
 to hit ENOBUFS, however, this results in more memory consumption.
 .
 This option can only be used in conjunction with "\-E, \-\-event".
+.TP
+.BI "-"
+Make conntrack accept multiple sets of ct entry-related parameters on stdin.
+This option is useful for the fast bulk conntrack entries updates.
+.
+This option can only be used in conjunction with "\-I, \-\-create",
+"\-U, \-\-update" and "\-D, \-\-delete".
+No other options are allowed to be present on the command line.
 
 .SS FILTER PARAMETERS
 .TP
-- 
2.25.1

