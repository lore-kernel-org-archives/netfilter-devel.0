Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,BODY_SINGLE_WORD,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B5FC433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 03:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4EC61360
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 03:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhDTDLV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 23:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTDLV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 23:11:21 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992D4C06174A
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2021 20:10:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e2so14571173plh.8
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2021 20:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=zxAJWLDa9XPFQITp0KDGL2kt09mQdEiOUNQYpXWQivs=;
        b=CTsevJ36XXOBp2fPbyWmd65OobOjXbVO9fZq1UgoCM12D4vDL3/HsncTihQIpa/IhW
         /8uoIiuNLf/DRXe9ffvYCNiDrnWiTj2tixRGhIns2wdajA7MK6do4SbuPPAQ+VQX7dVC
         EUdvdJfDC10pS+2Fc286/EkncT4P108vx+lgGE8OagD4FGOh/dp4CLEQDHLov2A67+tj
         +xuHnkEJprVlbpOueH4pNbugB77H8srfwdFomCmo9Ll1k2/l4sZnygsHHxJDKQ5m6KyB
         Pt/T9N6KhTJvd3wDciBZ7+rQCVsU9hQIZVgYrmtVgd1aJ/8eQtl5sWSPT1n16utHwfVg
         I3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=zxAJWLDa9XPFQITp0KDGL2kt09mQdEiOUNQYpXWQivs=;
        b=lKu8atKalnDOypaGuQX/yRhXb2ylmRVDHCmTVYsKZ8sTxJ1TZwGaTdWYyEbCRvTZ2I
         PmBiUS2pbaaPdkNZ4MI2vyvkE2pojYi+kDBd2GxBRNPpiMMrSeS4/95jE223hm8l/Ywd
         N2+BFnNXaNymvhcTK5Al+sU0HpCM/78uRRP61qlgU85PVJIX76GTFJ8Tm8ttz9mTAZsK
         L5CaLH4v4UA1LL5XmS6uCpC1Odo1LK/VG0Mpwm6P5HcBZEBenN8TCminKFcMMWiZpmMj
         VMPUA6msvW66M5kq56TM/0M+w3Wjj6ZhTQwB6sFWTtOheSgLCkwd2bgMbSWB5bzjA1Sm
         IF/w==
X-Gm-Message-State: AOAM530XTcpLDoeLLQcta8ZI30B2882Lab4XBmZap7oNZUWQs0JCnXi6
        VZvo/lUBp3dpsMXY/x28oUDlBzlr3c7hbg==
X-Google-Smtp-Source: ABdhPJzDLwepmGma31E2yz7UD9vnNIR/A47mnfYUFvARqd0qiJX7U+1HdEfWZhaZradYFXdkKBkBDQ==
X-Received: by 2002:a17:90b:1208:: with SMTP id gl8mr2571709pjb.12.1618888249735;
        Mon, 19 Apr 2021 20:10:49 -0700 (PDT)
Received: from smallstar.local.net (n49-192-36-100.sun3.vic.optusnet.com.au. [49.192.36.100])
        by smtp.gmail.com with ESMTPSA id y14sm6922083pfm.123.2021.04.19.20.10.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Apr 2021 20:10:49 -0700 (PDT)
From:   Duncan Roe <duncan.roe2@gmail.com>
X-Google-Original-From: Duncan Roe <dunc@smallstar.local.net>
Date:   Tue, 20 Apr 2021 13:10:44 +1000
To:     netfilter-devel@vger.kernel.org
Cc:     duncan_roe@optusnet.com.au, duncan.roe2@gmail.com
Subject: Test message - please ignore
Message-ID: <20210420031044.GA3841@smallstar.local.net>
Mail-Followup-To: netfilter-devel@vger.kernel.org,
        duncan_roe@optusnet.com.au, duncan.roe2@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

xxx
