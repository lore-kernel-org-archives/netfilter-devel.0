Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BF1C54E76
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Nov 2023 01:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjKTBGx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Nov 2023 20:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjKTBGw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Nov 2023 20:06:52 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F4BF2
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Nov 2023 17:06:49 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6cb9dd2ab56so275051b3a.3
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Nov 2023 17:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700442408; x=1701047208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=cC71JIpv7ejrgGLyJtHWfW1MIZcnMyB0YlCyayKGi18=;
        b=VETsIGH+9nEcHEh6Pvdil2fleGSxuwFxO0ktuy82PtnOy03qxk4TMVCh5Hf2G7Oh7u
         flIe/DLMjYKc3Zc7/dhlkJthW/MUfB6A3W4/hOXfUMj80yXfSsM6bySNjMMNOFU8ilfs
         yjB5SQGFWmUdw0DEjHsUZw4xAuypCRJcyk5TcT1KonMA0eGLCgW1KFBGiS/FniHBpzkw
         ronE6rJLXleZZRgOU5Ihnl49Twp9c9kRE9MO8Vi7/6gbG3IAtshtOQHdSVvBqcFz32D2
         Jtsz29Mp9I0Xs1TPHUiVuRXoB5kGbS2/AGTjf9RlZEq8JoZzfdUwi3MugJQFfP/IVqQZ
         +Jdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700442408; x=1701047208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cC71JIpv7ejrgGLyJtHWfW1MIZcnMyB0YlCyayKGi18=;
        b=sMwRx9Ka2B6T9ftJc8elv7y+RchIooTULqOHY/IXsVjh1RlpcqJrvmLdYCd6lwP/WP
         6/wzC9VXZ6iuU3YpMoxz4aW/MrXGrZyaU+VwYFp+cWMZRhvJGBbTSUh8UA1ichcQc9/Y
         6c3U2xziLWtz/z+Z23sOf77rT6h4saiNSuezbyCXzGsdu0EE3Sjn6NT4qHlmCb/vQyGh
         I5xBSVa/X/SfZ/I4nclsWNg9x1Fs2yX95UH5CgEkeusvzfDZI0dIlCGO3quv90JPUBEj
         3+rmDRbV5o/2tvvRuTuMevzPirZ+P0Cg3h88e0bTEWOCQgfRF+WR6YMdAhpsI89jB/CC
         pl1w==
X-Gm-Message-State: AOJu0YwntLJX4ub3y7unOklkoZfUHHmGQJ+q8VFkzKGuONUMBIXvGOFI
        I142URcw23FsrCEG3bmFEdz+R+FcisM=
X-Google-Smtp-Source: AGHT+IGnUPbm40cyz7orPQtH26GlU0hV5unTvHNlkzkPsyTv3D31iew7zOlP7WOdhTyFuq9MNrMA+w==
X-Received: by 2002:a05:6a00:3687:b0:6be:b7c:f703 with SMTP id dw7-20020a056a00368700b006be0b7cf703mr5244273pfb.5.1700442408546;
        Sun, 19 Nov 2023 17:06:48 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id s14-20020a056a00178e00b006cb7bdbc3besm1605162pfg.17.2023.11.19.17.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 17:06:48 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] libnfnetlink dependency elimination
Date:   Mon, 20 Nov 2023 12:06:41 +1100
Message-Id: <20231120010643.11247-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

This is the next one for parking as RFC. LMK if I should leave nfq_errno
(would only be set in 1 place now).

Cheers ... Duncan.

Duncan Roe (1):
  Convert nfq_create_queue(), nfq_bind_pf() & nfq_unbind_pf() to use
    libmnl

 .../libnetfilter_queue/libnetfilter_queue.h   |  4 +-
 src/libnetfilter_queue.c                      | 37 ++++++++-----------
 2 files changed, 17 insertions(+), 24 deletions(-)

-- 
2.35.8

