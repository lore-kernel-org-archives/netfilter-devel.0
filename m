Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E165C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 03:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiAIDRA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 22:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiAIDQ7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 22:16:59 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EC6C06173F
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 19:16:59 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso12299902pjb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jan 2022 19:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mCSSP5O7X41zzf82hZjs00+AGU7cDtFaTTQSY2VWgNc=;
        b=n+p8lUeTBBtds4M3IUnnCtGCOg8DPwcm50gRWVmIsPcYz8eT+okf4RG2/D2NqD3lYF
         LbvDhZS1hp8dZDilfjd/DSULwtVIsqXD7Vs5Ur1rlf7SMEE8gn6U2CtMZi/S6BppuUj7
         c9h0yg+dEhYrAo5QyEQFM07Cc+ofl4qDVz96q6etZ4pGZyko9cIVicDqF44ABNmCbcI+
         3oJVjHo7BmDKXgauzWjiHIiyHfUO5SKstlpUk5c4Yi28ic/OVs4l6hMZZSuQAFaMMNFC
         zr6dOIDhH5P77ZjfOwtycm7r33fnFBQJ1DpRCmrbS7RPElgddM85ncHjkmI/BbSNCzWD
         TNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=mCSSP5O7X41zzf82hZjs00+AGU7cDtFaTTQSY2VWgNc=;
        b=Tz2BdLhzIpQQUJBgIQo8lSpLk4dx3Khw1HpGGClfA8Gkc63OGf+dgN3zTvEnzgA9bO
         7RCq3YO8q/61Zi2HDLfEUSHvQ6a8YpQrLu6rW9ZbH8rBCrHNg6RWw9rj8P/jQdYmLVsp
         N5g+aEoRbxcM59yS5L4YHVYjsg45nG0tUodeiTRZrw9pscJWWst5NltVWBZL0HiiglKq
         qB7i+43+/Ad/kZpSU9QTFVpX10Om6B/J3v0xjQKpugR1qzq2tZ9LTX/X8CM0nnUPWlWD
         ZO/v4sITUCgbCwsaOr4jQfNaFVubpdT3HHI5yx7k5EDjq3jQEycBejt5xYzbpmB2oy5i
         cerw==
X-Gm-Message-State: AOAM530/VNCzA6cBDfwrkeYkZQxlh/Js7pilkEsUtsqD6JO3F9Y/0Ymf
        zjq+l9ZNWY44TLjz+JZCVHIcpUTYVUQ=
X-Google-Smtp-Source: ABdhPJx/IBcSCMUEI0GBuOGDvRevmePN7Ezh7Wg+ANs2aIJkRCR+OVu2vb2RAAA5YaRN/MQf4Vu0tQ==
X-Received: by 2002:a17:90a:b108:: with SMTP id z8mr23396485pjq.99.1641698218581;
        Sat, 08 Jan 2022 19:16:58 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id me18sm3881864pjb.3.2022.01.08.19.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 19:16:57 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 0/5] Speed-up
Date:   Sun,  9 Jan 2022 14:16:48 +1100
Message-Id: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a re-issue of the patch I submitted  18th May 2021, with some extras.

Patch #1 is the original patch, rebased
Patch #2 is a new patch to get rid of a compiler warning
Patch #3 is a new patch to rename 'struct qwerty' to something meaningful
Patch #4 is a new patch to get rid of doxygen warnings
Patch #5 is a new patch to expose 'struct pktbuff' (to simplify code,
         since there is never a buffer tacked on the end of one any more)

Duncan Roe (5):
  Eliminate packet copy when constructing struct pkt_buff
  src: Avoid compiler warning
  src: Use more meaningful name in callback.c
  build: doc: Eliminate doxygen warnings
  src: struct pktbuff is no longer opaque

-- 
2.17.5

