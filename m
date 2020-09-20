Return-Path: <SRS0=lHVQ=C5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F19EC43463
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Sep 2020 13:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D284F21531
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Sep 2020 13:36:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20150623.gappssmtp.com header.i=@mojatatu-com.20150623.gappssmtp.com header.b="tHTcgXDN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgITNgF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Sep 2020 09:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgITNgC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Sep 2020 09:36:02 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19660C061755
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2020 06:36:02 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id k25so9927803qtu.4
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2020 06:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=AlcJoneKXNfJvO8U/304wgnJFZRKZ49gwNcmCkuy6kI=;
        b=tHTcgXDNp5QrYl8zImaCTIIBq7jn625bpXdEk8AnTT37aMC+arTYuR0O8MOyHEzbUo
         joEk6PPh/iPRH5L8Yr8Zjq9KcETr6IEAwFVoYYpGBdnk39TajehNtYwUz8M+BmQFii9a
         16B86+hDuuuXO6sQ3vmhWS1DZG7BRW8iLHK7LWUhI+ZyYYF9m34kKLsw1ZdJcrL+qXTO
         r7NWWEtoN0cIcfmdyCqo3mRpYV72dOK0vz3ngTaQgw0guhNEqUlGcDvkwqEOJk+k7r8h
         siHgCr93AfSDMVLXyuNxjfb4sQo3lSJjpJcrNc3gbplQYMtynkUvqYc23H1ONx+LScMy
         YYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AlcJoneKXNfJvO8U/304wgnJFZRKZ49gwNcmCkuy6kI=;
        b=bl8EAw/bEC/5U7cgi7cxKML6D9CzsytHx9m81EsgqvTFgvzRWs9sICxI4GCQ4NDl7u
         /WfnM4oCF90EgkameBphz1QZjIscAx+CFznGbM7sc/WlH28bK1NQp++sD2h0PKdQyxzX
         mv8JbzYUygUotzBYvzymD8FPFZYGVWzZj2l/tWgTdAnL0sKQ2EKFzxNtS2IK7U+Ob6P1
         F2LmWGh9wj013bia+aFXa6AmVW3SailSvoCilZ/bvR+fEBoky/+P0P0WvUmfd41X7vNG
         GpXMYcMbsqh87a9yh6oVh1f+/+wdl64/1tNN4DF8bS48u9WuNJvZFmz7iD7Dgjg6D3KR
         pgzQ==
X-Gm-Message-State: AOAM5317pkYdquWEbpxfkbG+aZHwTxmWDAaYxBDvwlDY1YY3eL7hDyVl
        9o4jrpWoaud5grEDuCK9jsU3hA==
X-Google-Smtp-Source: ABdhPJwD2ou54XRXZOzqX1B5Na/2NQVUqBGtTBGB9AvVWlo94bq11Pv0Fifo2tzLeJ4CgeCKwwlKwQ==
X-Received: by 2002:ac8:7b2b:: with SMTP id l11mr40177140qtu.126.1600608958971;
        Sun, 20 Sep 2020 06:35:58 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id 205sm6490316qki.118.2020.09.20.06.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 06:35:58 -0700 (PDT)
To:     people <people@netdevconf.info>
Cc:     speakers-0x14@netdevconf.info, prog-committee-0x14@netdevconf.info,
        attendees-0x14@netdevconf.info,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lwn@lwn.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: 0x14: slides and papers posted
Message-ID: <0257b321-cf56-ef33-5c4a-1cce0fc4c877@mojatatu.com>
Date:   Sun, 20 Sep 2020 09:35:48 -0400
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
Tutors, sponsors, and attendees) - thank you for making the
conference the success it was!

The slides and papers are now up. The videos will come after.

The sessions page is at:
https://netdevconf.info/0x14/accepted-sessions.html

cheers,
jamal

PS: apologies if you receive this multiple times...
