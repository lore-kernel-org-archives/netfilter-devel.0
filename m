Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SHORT_SHORTNER,SPF_HELO_NONE,SPF_PASS,
	TONOM_EQ_TOLOC_SHRT_SHRTNER,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C82FC43457
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 12:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22122222C3
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 12:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20150623.gappssmtp.com header.i=@mojatatu-com.20150623.gappssmtp.com header.b="Lv+1KPQk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgJIMzs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 08:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387854AbgJIMzr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 08:55:47 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8A4C0613D2
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2020 05:55:45 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id z6so10424079qkz.4
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Oct 2020 05:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gHpUJmDZonPV5j8bU/1gBGhpCio2vFsUWRF9qpU9vW8=;
        b=Lv+1KPQkmVCaxhltL1Bptxe2IohBZ8ELxZYbQe/XYjACfOACvHXKhaHyOm8IR0GUew
         wat8Nj2Kwua/hznueUu76ai46V0xbmWtGqGpay8TEGG3L6pIlpW4gQYKFpBSgfA2vS+z
         9E68uw+n3AT99JdnfW9e4IN0hpwEPbhb6qmGJF7AY1/4uooFoN8UYUvXXaX5eZ2StaXW
         jjPAsYOcCPkui18mRBdvgTk/w/ew74rkYLDr+A5UusbAblZBRZ4CENgT5jXB793qRjrl
         smtWElf1b/JVS6VPvhfcX7WOPh2LvFnmOYbXcdi65lLTWZdbuIXdoHxhBGNEmAIFgp4r
         OMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gHpUJmDZonPV5j8bU/1gBGhpCio2vFsUWRF9qpU9vW8=;
        b=gHSwSYDnEztKUNX2B0md7nzBFDBfSaJiHzz015uUu52DYTvRVUYgV3QGvNBPg7ZRLT
         9i/LykF7mOmrrMp0YcXQG/AV7lAUr9EHBc/ZFTxuNMQmn199ryM3DfpdQgVbRX+bb12H
         zJwVPAvIQaSlO/KAUc7bHj4ihzfTNXbCaH6XxR6m+REcXZeEccj3zgEdD85Db60t0T4T
         /qeATlzGB+DLU+nbrS9bnFCGJ7LmmPWuXkmjGCQqhlIN+ZFqklW2BH/ENM26pcp4W8hI
         maDiLeO7Mdb1VchCpocB/FQUMUxBQUhjQCzfi3NUl606agghu/epUc4CgRh3mst55x0g
         Tpcw==
X-Gm-Message-State: AOAM531x289Y97Mk4xKANz7tfpE+k8O7bW4k1P1tz8MkM+aGh0Vdd9JX
        Ow/D8bQWZRA2e3TuT7OOnoSnNg==
X-Google-Smtp-Source: ABdhPJyEXSEu+fLH6EcqCWM/nDKyRAe6bzO6Hgdk8YDlZ9eCtXjIZcw4aQ6Gim1mSBxKZLtFvn/A1w==
X-Received: by 2002:a37:c51:: with SMTP id 78mr13313885qkm.30.1602248144600;
        Fri, 09 Oct 2020 05:55:44 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id d78sm5775681qke.83.2020.10.09.05.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 05:55:44 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: 0x14: Videos posted
To:     people <people@netdevconf.info>
Cc:     speakers-0x14@netdevconf.info, prog-committee-0x14@netdevconf.info,
        attendees-0x14@netdevconf.info,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lwn@lwn.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>
Message-ID: <95981c19-d157-0f13-ed3f-ce82b612e12c@mojatatu.com>
Date:   Fri, 9 Oct 2020 08:55:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


To everyone (PC, organizing committee, speakers, workshop chairs,
Tutors, sponsors, and attendees) - thank one more time
for making the conference the success it was!

The videos are now up.

The sessions page is at:
https://netdevconf.info/0x14/accepted-sessions.html

The videos can be viewed directly on the 0x14 playlist here:
https://bit.ly/2SHJWow

cheers,
jamal

PS: apologies if you receive this multiple times...
