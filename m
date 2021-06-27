Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A52BC49EA6
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Jun 2021 16:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 530836024A
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Jun 2021 16:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhF0QWH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Jun 2021 12:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhF0QWC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Jun 2021 12:22:02 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F83C061574
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Jun 2021 09:19:37 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id o33-20020a05600c5121b02901e360c98c08so10157072wms.5
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Jun 2021 09:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kU2Mk8uSDc2zxU3chWaXpx2d5lLNYMiHXfviaQ8+BzA=;
        b=k2YI6Osm7GH9FKEK2zhDXC/pW+DEixAaH7KPObh56kUOkZFA+OapovPGE9q9yDi9q1
         OKUtViNJJHPzgQC6bsa5gO9XyjAQbmjGlJMTvEM33foOlQCi9lt2uXuuMwXJJfDv3rcz
         WXb9Mlg4zYNUeChk41a36yj5PB6rwiGVwCzry+XhcYrmSkwz+ohldC4Pdd/vCJ9SKjKP
         C10gXUPU1ZrOIl6evr6O7kVY635ydRpL4FRtb/0Mylo33RfV02StwfpfStgJRdIiAEi+
         HfRtNGpW6fA5MAFI6G8SJ8l8nRc/DFEl44kZ285wnORz+g991j1nghM2Wk42DS+aoNO0
         zMNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kU2Mk8uSDc2zxU3chWaXpx2d5lLNYMiHXfviaQ8+BzA=;
        b=NEGe/vjfrU8hqG8yOj8yD7duEgRX0XI4PpN5nR+m29ytdKJnqc34EIUJejjouadyX2
         GkMyRRKfJGavCoFVU8WPSfGdvH9x+YB5ufD/Zg5Hw+fFwWVur6ZEeRnNz6l0oubLJzfs
         4Gr+6ndoQ6yw8eELBtyoFd0yHXHLPPEHDNhmMHifbkrqzwr/pL2o88gVwLAXq81ztJNl
         2qMROqt1v4Ja95hJPJNWCkIo28WjNGV7P26rCzaQ16ktR0BDntrHBwK3aCibb38G8tD4
         q3i94nwg0DHEzA7LRSDMqphOT9Xm4FLkWS/ovorW3PEcpojpzzKXVEhb6bfccQa69vT9
         edyw==
X-Gm-Message-State: AOAM5307kFOEYejlXOU3eH+uFlT3n7KFGYLyO3u24WNTi12O23DsOPWh
        knIKVMn8Hsurm/L6IhFZUyN1Tw==
X-Google-Smtp-Source: ABdhPJxcIct+WOtglb3B3eV4J/ZzGCw8s9V53PABXvOiW4D26zE3RmryQXXnwL8FMvbaUh4YRZz0rQ==
X-Received: by 2002:a05:600c:354d:: with SMTP id i13mr21983769wmq.143.1624810775864;
        Sun, 27 Jun 2021 09:19:35 -0700 (PDT)
Received: from localhost.localdomain (p200300d9974f98002cd84be72c5877b5.dip0.t-ipconnect.de. [2003:d9:974f:9800:2cd8:4be7:2c58:77b5])
        by smtp.googlemail.com with ESMTPSA id f22sm10820384wmb.46.2021.06.27.09.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 09:19:35 -0700 (PDT)
From:   Manfred Spraul <manfred@colorfullife.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netfilter-devel@vger.kernel.org
Cc:     Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E . McKenney" <paulmck@kernel.org>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/2] Fixes for KCSAN findings
Date:   Sun, 27 Jun 2021 18:19:17 +0200
Message-Id: <20210627161919.3196-1-manfred@colorfullife.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extended patch, derived from a KCSAN finding:

- Fix for nf_conntrack_core.
  Unfortunately not tested, I don't have a conntrack setup.
- Fix for ipc/semc.c

@Netfilter-team: Could you integrate patch #1?

@Andrew: Could you add the ipc patch to your mm tree, as candidate for
linux-next?

--
	Manfred

