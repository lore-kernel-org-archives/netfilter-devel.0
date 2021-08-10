Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EA3C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 17:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9BB560E9B
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 17:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhHJRJR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 13:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhHJRJR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 13:09:17 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E83C061798
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Aug 2021 10:08:54 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id c5so15953997qtp.13
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Aug 2021 10:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=M0nMc32VdYeoROakqfdUuqdNeVnekYQ4hd5V8oDaN7M=;
        b=pgVJN2i7UW0gnI9xKl+qd1+UJbk1gvKBllUJjNMc9eYv01CFtXlOZsejG/mBg46Ka3
         dwcU/JR6gTtc2oO744Ojs2krSWB+9aCLGX7V9pCMRZUiM7nY94G383Ld3gWk3/ohKNPL
         LgJ68mkfhYBUVKQKLqvUoyp/t6SQNRmFbK6v2iBiVy20ZoaYz9LchiaSJWCEa6+wdn/i
         A+oWfBv7lw74wxLsb8Enfw0AGpgVlLcFzSB7j3YnN4KsTF/99dfKNfZM+pvbj16zNZij
         +WX0Qv/KN398U+DH/170VpHbZb2kdkzc8IDwI9xTGVLjdvS/g+RcmFo42B2NyLMRKOse
         esqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=M0nMc32VdYeoROakqfdUuqdNeVnekYQ4hd5V8oDaN7M=;
        b=lhP6o0KAhAUce8iwdZHmsn6+31LaCIBQ4CwTCJgEOYtCjmJs+FpvaSBbHfAGvymbA9
         CzSun5V0xqLH4Ulx/LVFa5MIp1QMpEyQiAJLpc4b+l1HV6Qm3lLvLu1DnIu8AvZQmxYx
         TPNzeqFNu6WZf/raJHcZA4iPetFArrsntpPWg83ubcz5I6rHyABIxLTsI+ZJ97ru6kyo
         H97hGls7LD9bbCbE4C39dWzfwkVMV5uam8JTbHQdr+wZrs2Znzry/mP2UowLMnpkylhs
         oTdw7U4+gQk2f4WugbSAe69tfWzjUvq3b6crBsLdTnauxmWRs63SriR3qiwi+SL2K7eD
         F7MQ==
X-Gm-Message-State: AOAM532DKVxSuhrBN3WmgRroP6YVRtgCTnBzFsvi5T34CCS7wjKSwgHi
        LxvFY1RxZrldUax86dYZXVYrgA==
X-Google-Smtp-Source: ABdhPJxKPrfTZqcK0gHuLOcyLYaxjm3Jy4sYYs8ctATrBZ7Mwl/gg2kJDtdAgx2mpAz7DsuayNYgEA==
X-Received: by 2002:ac8:73c9:: with SMTP id v9mr13551051qtp.12.1628615333996;
        Tue, 10 Aug 2021 10:08:53 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id c69sm2442113qkg.1.2021.08.10.10.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:08:53 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     people <people@netdevconf.org>
Cc:     lwn@lwn.net, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lartc@vger.kernel.org
Subject: Netdevconf 0x15 slides and papers up
Message-ID: <64ae0651-61b7-7a40-2eb4-8f1cb6dda87e@mojatatu.com>
Date:   Tue, 10 Aug 2021 13:08:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi folks,

The slides and papers are now up. The videos will come after.

Check the session pages for the links to the slides and papers
https://netdevconf.info/0x15/accepted-sessions.html

cheers,
jamal
