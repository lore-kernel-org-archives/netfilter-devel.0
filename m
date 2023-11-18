Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7318AC072A2
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Nov 2023 00:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbjKRAHN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Nov 2023 19:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjKRAHM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Nov 2023 19:07:12 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3007D7E
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 16:07:08 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6bd73395bceso1945238b3a.0
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 16:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700266028; x=1700870828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=cC71JIpv7ejrgGLyJtHWfW1MIZcnMyB0YlCyayKGi18=;
        b=VBGPCsD9KSbwd1ontkdrJzWhLcZBfXr/3E5BVVKb2Yjg5kDpFebIAlBBP2G8eIc6NH
         8Pvo9xJYObS2oOQ2mLeDogYoDvspSsIYcycWNvYkpwpx2hKv+UEiBes+coFCfEeIaa0i
         t+oiXeSYMVdBstcHLt/1VwWMxPndr+Vjp9i3a9DBwg0j0jdiwVJFZKqe6veW1KpL9IGH
         9Dzkj1GwhjV+S+1RzRm3bqSOPhGargIQN0SMmXw8oC1C8iMz0SfRri5/4jy+BpLk4xF6
         gEWcz+sDmVodu1VElYrkNcg+/CjtRQYQPMh4E2Ecqa1KanHhhQVIMQUj5K4r7CL1mRts
         JV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700266028; x=1700870828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cC71JIpv7ejrgGLyJtHWfW1MIZcnMyB0YlCyayKGi18=;
        b=KLQL4FRvSL8wpid3EWr/ndTHrfQR4DouX1jmmzAFOF0FEBASTsTW8JzergXYqNsF9j
         Kmv4sTMJIosxfRV3fU74DHOYyC6czFREIrJY5JjNhi0eBhcO2YRTrGFEbCRiXwWsnp67
         MdDKk0R4DcQ5d2qX+/0ABCGM56GurayCSePYxlwziC3wvr6f6FXm+KEzOpsdQ4kqn/vG
         Cq2UWznq8vYHJfneLZkjbsS1Fw5FemD08lj0cC0J10tOICItaPu3/5iraAyotcsYt7uy
         +errBAMrIQSnkkOSRwsjwcZTbN6cY9OI+jpHbKwzlQSOH5FNIackyJeAbdBqdtgxBvHX
         cg4Q==
X-Gm-Message-State: AOJu0YxztAWG1z9sU68h+mmIbQfLN248QqgdjnuF3001Wfi4S8GM+DLm
        PS5FCaI3gNFMmsn+Y1hDoe7I6YrYsIo=
X-Google-Smtp-Source: AGHT+IHD2LoD7+PR+WJ7uthIhK3x895Dqzhm0Gq5edDTsSBzAvsUHgJpJ9unHwRAZEscwFfcjz353w==
X-Received: by 2002:a05:6a00:1d84:b0:68c:44ed:fb6 with SMTP id z4-20020a056a001d8400b0068c44ed0fb6mr876329pfw.16.1700266028031;
        Fri, 17 Nov 2023 16:07:08 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b006c003d9897bsm1936979pfh.138.2023.11.17.16.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 16:07:07 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] libnfnetlink dependency elimination
Date:   Sat, 18 Nov 2023 11:07:01 +1100
Message-Id: <20231118000702.9202-1-duncan_roe@optusnet.com.au>
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

