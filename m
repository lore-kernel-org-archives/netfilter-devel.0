Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEE8C00A8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 00:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjJXAvU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 20:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjJXAvT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 20:51:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E9DC0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 17:51:15 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6b2018a11efso3819488b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 17:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698108675; x=1698713475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Rx+NYSMQLKncZ9DsNSCnZDiVltv1MslaEdc9dFB//Y8=;
        b=VmhRQjMILRP2n9j3i0F3YtUOAuLIGzhUkkoJ/O2S8IvIuksRC9x66nwepmz51is60N
         6ADxI0I0LcBNgB5LR0W43RYO88gaznhrPLYIZne7FYN11RFErm6X7w1bjvR4+n0U9Xw7
         r774ATQ58fRXZuTbXp3SO5SwrCMW7qmHjngfooG+I2OzsjrfcYXXDZeJU9lH+Ye53Pfr
         QTQ4cRIASgKufifL1IT/tW/OxEGKNkjDrFGGOvBs/amGx5+UU6jJWZcOHDwCNORYaurh
         KKntZfW9fyw1qz7GOfzy2ZQ1C/vVNhtkqYHW9aFu24+6OnTtdaPnxmQ+vXaTFs0OFSGh
         gN5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698108675; x=1698713475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rx+NYSMQLKncZ9DsNSCnZDiVltv1MslaEdc9dFB//Y8=;
        b=F1NvkOF9vi7mE/FXcGhUew+rsA6Yis4bn6SBhA9ZieUaLvsVxuuIDb05ZUXib1eJZ7
         yFwEPqz+2zADgNB5MPOf1vjOCh5i6V5zvbildxZZMvsnZFY5Zvo2PEMHOwdyLA5caqFo
         HgU3CdoPn/naMDNC37av2FBfHDkTfZRCF0TFgMT20moRBZtEBY0UlI8RA6jXtLNfkBfD
         B/B4RHUA0EXguluBn4ebq08dyYf4I3B8IfBVJjWn3sQl6LkrutlYVh/abf+T+Bm8pT0u
         TS8XhehSRpYvoBIAs4j83tzLtMOfhivlNErHxGm4RhYndIGLfRx2aQIZ4P9miTb9xwhA
         XCIw==
X-Gm-Message-State: AOJu0YzI/58uaEzVVNHGmuj4ImmpFEPJjuNTfogJyHl3nvOGR1PZH/7o
        Ri1H6gMbp6USWFuVDSPjOBtIxjX4swQ=
X-Google-Smtp-Source: AGHT+IGWV+PZdj3AeXYtHT37AoXi01oGPCfP5Parcue4BjZPmwpn5h3SY6mhaoHXnfxddaj9kfjq2w==
X-Received: by 2002:a05:6a00:1747:b0:6b1:c1c4:ae98 with SMTP id j7-20020a056a00174700b006b1c1c4ae98mr13071258pfc.18.1698108674695;
        Mon, 23 Oct 2023 17:51:14 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id q12-20020aa7982c000000b006bfb91ac2afsm1809497pfl.140.2023.10.23.17.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 17:51:14 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] libnfnetlink dependency elimination
Date:   Tue, 24 Oct 2023 11:51:09 +1100
Message-Id: <20231024005110.19686-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

This is the first step towards moving to 100% libmnl use.

AFAICS these 2 funtions just have to go otherwise we are stuck with
libnfnetlink for ever.

Cheers ... Duncan.

Duncan Roe (1):
  Retire 2 libnfnetlink-specific functions

 .gitignore                                      | 1 +
 include/libnetfilter_queue/libnetfilter_queue.h | 2 --
 src/libnetfilter_queue.c                        | 5 +++--
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.35.8

