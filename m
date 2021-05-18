Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54477C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 03:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3440B61166
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 03:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbhERDKp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 May 2021 23:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbhERDKo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 May 2021 23:10:44 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D1FC061573
        for <netfilter-devel@vger.kernel.org>; Mon, 17 May 2021 20:09:26 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id j12so6003643pgh.7
        for <netfilter-devel@vger.kernel.org>; Mon, 17 May 2021 20:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qvdZEIyNSsDfQKmoM5EVxJ5df5x9/5HdUSDKrkdltco=;
        b=IluwaqWIkburlI2csZnCdufNGzgKOuxxvUxYetV360LZmWs9AfN/ePjVFx+0NAc7sx
         5a/AWXUkoj3b4IkGY+GwHnon1hHMLouixeWeNeuOD6vkdiT99dDqNA6n8smRfAD2f4Gi
         +wrTnkdCi58AYGvTbwnQISmYV4MX79fH0zd42ykuTDV613cBps7V3AsRAgzvgCWgO5E7
         OikhdKF4DRUXCSyZGCZdxub+Bse9vOBGragnKHzjfR+5eGwpqgbxJwJwKJvzRX1KUDal
         O/GZJNIJjfgI8YXlPr7hFvhkwy5J/gmmBBPlhK4zKcet7ZwFNeu5cngDGrDt4vLI6gmg
         z6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=qvdZEIyNSsDfQKmoM5EVxJ5df5x9/5HdUSDKrkdltco=;
        b=f504nYmXS4r8g3rfohT1Bx0XL19N9L9bjkLlhDIPRxq/w3zfKNuXt1Be/COEDTQlSn
         Up6ahhM9Sy42z5CUNJUDTs/wWY2nQh/4rc/+1p9h6hV+hmf8u8+nh+c+YQ6N4N1OEwiN
         3yqePASc43tW9vT25UtWq6aVJOJ8bSYrLiNOkKCGhvPjMaiZoka+XYHD/dH6dWSUwdN+
         +WpbkXp+mnOZ/Ni5YzEPxYdNbU2uTj9DJeefmBx5cr6apwEQCnzmrstCpp0SLsOTHpSm
         N2PRBzM3xQrYZyG/YfvoXLpWnUXSNbY4QOmnpgFcNGc1Cf3Ozhs56/SB0RmbJaH2MzfP
         ADQw==
X-Gm-Message-State: AOAM530+0FnxaA1vXzIPhZtpNuHRL7gWoxDfIZIv6X9pQXGa/RUEFjn8
        mNhLdyCtX0v/3VI4BMO9nqb6WK9VVt7Tig==
X-Google-Smtp-Source: ABdhPJzG/mgRK1UILJE4dKr/TtWpEGfk98gFx2tLq3XhtlJnRNCV584oWFni9XAAxe31zbb9qtFe0g==
X-Received: by 2002:a62:3101:0:b029:2de:4f8d:2ca0 with SMTP id x1-20020a6231010000b02902de4f8d2ca0mr982328pfx.65.1621307365957;
        Mon, 17 May 2021 20:09:25 -0700 (PDT)
Received: from slk1.local.net (n49-192-89-29.sun3.vic.optusnet.com.au. [49.192.89.29])
        by smtp.gmail.com with ESMTPSA id i2sm611197pjj.25.2021.05.17.20.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 20:09:25 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libnetfilter_queue v2 0/1] Speed-up
Date:   Tue, 18 May 2021 13:08:47 +1000
Message-Id: <20210518030848.17694-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210504023431.19358-2-duncan_roe@optusnet.com.au>
References: <20210504023431.19358-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

The RFC didn't elicit any comments in 2 weeks so I guess the new function
prototypes are acceptable.

This update replaces use of __thread variables wih passing down the needed info
via the data arg. This saves 5 seconds CPU over 100,000,000 packets on my AMD
Ryzen 7. The original data arg is also passed down.

Please apply this patch when next you find time to look at user space,

Cheers ... Duncan.

Duncan Roe (1):
  Eliminate packet copy when constructing struct pkt_buff

 examples/nf-queue.c                    | 22 ++++++-
 include/libnetfilter_queue/Makefile.am |  1 +
 include/libnetfilter_queue/callback.h  | 11 ++++
 include/libnetfilter_queue/pktbuff.h   |  2 +
 src/Makefile.am                        |  1 +
 src/extra/callback.c                   | 60 +++++++++++++++++++
 src/extra/pktbuff.c                    | 80 ++++++++++++++++++--------
 7 files changed, 149 insertions(+), 28 deletions(-)
 create mode 100644 include/libnetfilter_queue/callback.h
 create mode 100644 src/extra/callback.c

--
2.17.5

