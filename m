Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_40,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1174EC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 12:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A793964F72
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 12:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhCQMfv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 08:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhCQMfp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 08:35:45 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178CBC06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 05:35:35 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id 97so682572uav.7
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 05:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=QwsAjQLxUD72ITp6Yoik/DTr4IvxLHd3h3K1Js+v8Kw=;
        b=rXa6oD5nScDidxtwE+i/Qoeb7pZGl3VGJiD6q9T/R6xIf4NaaTHDWVzQpScAX5bzr/
         XU4PFsHwPd3hBn4l9XU/NcdZRPUfYlG11+uTx4MSJFdw5SaSVk+afLayRZ0StylZhHAq
         fhQkm4ZpVhBroBbrvXJJ6ehJox65qk4LTEZG53u78xqyYof93kcJfugES1zr4qf46RzT
         mTAVF0Rf/wHDfzQfrQBey75qObwWWzx2BF+A1nXs2i1pKK0jds545pevockBJRf41zCB
         IVK4xVYLuAlT0EjrgXsnxLpTMI2+kmdMmLQCQn5RsVy68n2M6pfPFGIs2UsSoPmdKAon
         kudw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=QwsAjQLxUD72ITp6Yoik/DTr4IvxLHd3h3K1Js+v8Kw=;
        b=BbE5bgp2j48la+OxsdrEKmNwTWMl+X+fbVbWyejDUV9oQABuIQvwLzrCAc/hVVxcwZ
         /VSnHELXRxRGlhhWObvvHmUf3xhdVF1nKDx4X8rUZFfhYmuoG6fMJ3RWUs/79cvveNI4
         RunSmtqg9bjYMxwUS9jHHeWlEo4MKQmhkP06/qnvZ8+FRJvl1/gAlOdTEqHQIRLfSsy2
         rOR+TWZut/deAVDXU223+zj2VDvWyG8NgnmO5bRzjPFCrjmbfDWN4jrI/vO5xX+Khsde
         FJdpPraqyKs/p65JrJh+KI89aATuHtE3cXRIYGdJ4SfCmZB1izP8MBSQDPdBcLIFoVbN
         BkYw==
X-Gm-Message-State: AOAM5311aHoDjIXY8asXvikslMTXdq//lG3l1vIfcb05c61s4b6dmHl3
        7Fo5slVCXNWvM7mTaXXTXTjF/YnXD1X7ptyN+zg8sbUGA4IN9A==
X-Google-Smtp-Source: ABdhPJxMRdemGmiNyUe/MDTAN0lNass/jTq308pHB5Gz3gGM9QfO12jpxOTthuJDCJbHdSHRXl6t2aK8ZvokbxZySiU=
X-Received: by 2002:ab0:1327:: with SMTP id g36mr2454616uae.16.1615984534042;
 Wed, 17 Mar 2021 05:35:34 -0700 (PDT)
MIME-Version: 1.0
From:   ilker <ilkery@gmail.com>
Date:   Wed, 17 Mar 2021 15:35:23 +0300
Message-ID: <CADtAAp4gS5oshZT=E7=C7ydxvpB-EhCXw=evETzjf-yyCdf_MA@mail.gmail.com>
Subject: Ethernet Frame capture with nfqueue
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi All,

I am working on nfqueue to capture packets from networks.
I am not able to capture destination MAC addresses using NFQUEUE.
Is there a way to capture a full ethernet frame (especially
destination MAC address) using NFQUEUE library?

Thanks for your help
Regards,
