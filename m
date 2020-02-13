Return-Path: <SRS0=+t1+=4B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MALFORMED_FREEMAIL,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5BAC2BA83
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 14:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D55920873
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 14:13:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RBJ012Rs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbgBMONA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Feb 2020 09:13:00 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]:34427 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730079AbgBMOM7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 09:12:59 -0500
Received: by mail-qt1-f170.google.com with SMTP id h12so4472305qtu.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Feb 2020 06:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :mime-version:content-transfer-encoding;
        bh=StZokD5W5ArfrLbxR8zHaZmIlXYBoE9ALI4qPSfWqL4=;
        b=RBJ012RsCpofCzP6Ttd8GXXGu1KbflM05JGV7YgezY8MkegdGP5mdADdqYjaIrFtl5
         yHKSgEngLSPXwWIaowaJ4eNGyiPs+4+0b6dySy+ocf4O3sM3ABUdKdX1ZInywOi7uwta
         mpkfs2QV6hpVha4DL5NCX/6cuRiSp45L3gjixWkhfI4HmPQK8vfCKd0HghD1z+/fbLxf
         a7296WJ3ZCH9U5lhqL/yjmwg0IBWAYI/yClQeOQtDRoEkpe2fCFnMk0PIbDpqHPlqxWE
         N2e2diHOwxTYUDf3MbVSMzUEss+mJnaXQHeCZN4xHjhuh9vymuUaef1sBYr169dtjyqb
         yvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:mime-version:content-transfer-encoding;
        bh=StZokD5W5ArfrLbxR8zHaZmIlXYBoE9ALI4qPSfWqL4=;
        b=iyVk69hrkM/hTSZFlfDTfst8shtRR1TnsTqwx+mFZZ24fwu6Tn0uyAB9kJah8yRewg
         pbZqWafedCj/fY1bgDDPX4DI9hh56riqODpZkx+Z+LOQ3iU/+o5CsPfnRpeMOnUT28ts
         6EfCNAS4dfpj95xoIoIxgmBrBuhId6OZVqAmVrzlJfC6KAm7gKIVId6YpvuEAAusY9fc
         sbIXkwzdMdBSMGGJFuSFbUto1ebtrDsZGm5IgmSn728RHaNybf4soml0louMjbzDsOd3
         HbQozvTfu8OVajYfBNvL2+NEBvMwTVBQsSq3x5+PZm6evbaP3GKsleYCEjPIQhvvIxfT
         X60g==
X-Gm-Message-State: APjAAAUPIkZn/DT9LbgRJIr+pbm4Mu0Ki1cxtliUzFgrGQe2j0h/d7m6
        G9ov/GkeEQlcXe1Vn7eUp7byco3/tEo=
X-Google-Smtp-Source: APXvYqytKfiOJt6szc2iWXUecXJu+GC95mi6er0mJa9AnpWZt/tiHzDHbkq+2278WwZoVmNlpeYpXA==
X-Received: by 2002:aed:2022:: with SMTP id 31mr11176095qta.321.1581603179025;
        Thu, 13 Feb 2020 06:12:59 -0800 (PST)
Received: from [10.117.94.148] ([173.38.117.65])
        by smtp.gmail.com with ESMTPSA id p26sm1336666qkp.34.2020.02.13.06.12.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 06:12:58 -0800 (PST)
User-Agent: Microsoft-MacOutlook/10.22.0.200209
Date:   Thu, 13 Feb 2020 09:12:57 -0500
Subject: Proposing to add a structure to UserData
From:   sbezverk <sbezverk@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <169CDFEB-A792-4063-AEC5-05B1714AED91@gmail.com>
Thread-Topic: Proposing to add a structure to UserData
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Pablo,

I would like to propose to add some structure to UserData. Currently nft tool uses UserData to carry comments and it prints out whatever is stored in it without much of processing. Since UserData is the only available mechanism to store some metadata for a rule, if it is used, then comments in nft cli get totally screwed up.

What do you think about to add a little structure to userdata in order to preserve nft comments and at the same time allow developers to use UserData for other things.

If we could add attributes to UserData indicating type NFT_USERDATA_COMMENT with length, then we could preserve nft comments and at the same time allow to use UserData for other things.

What do you think?

Thank you
Serguei

   


