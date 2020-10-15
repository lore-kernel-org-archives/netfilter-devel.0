Return-Path: <SRS0=46WK=DW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16761C433E7
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 19:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFC32218AC
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 19:01:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="biGPjqwC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391386AbgJOTB0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Oct 2020 15:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730427AbgJOTB0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Oct 2020 15:01:26 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8A9C061755
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2020 12:01:26 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so85407ior.2
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2020 12:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=v8QJbk43RZKuJB3mWX9/L7CnpitIQ6DkcC6JKIIxnFo=;
        b=biGPjqwCQTZox6sVU8AaLnQkWkz5HMx1xMZWOxUF8vGTSgWckn4qQd2+qOhPfsxAtX
         xs/XWvBL6+RT5T1PGTVDO2/023OyiYJFkt8yCRilGlqPJnAQK6E4eC6ldeK7/u9HDetX
         PbOQ6oTRTelKusg78wajAJa60TjRyi+kBDd5aBUqKIDeCwcxznlovP7u7PyXJkf/p8W/
         Qtm3+LV24BMx7tHCpmXlbyjx38dHox+BLHhEgDipxN4Hg47bnSIWyuQI10qEnMLkBooF
         +Q7D8KIJ5tyGuW0Q4S7R5adXgZlukTCl0aIn0kU5vEqC698v36WNuhhpT96ZxyMUTnyP
         wBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=v8QJbk43RZKuJB3mWX9/L7CnpitIQ6DkcC6JKIIxnFo=;
        b=NWI93ovt7N+/jc4KlY7XkkmuI0vNjsh7aSCRsVm3e5xlKLxegu5NtxJ4RzY2mWtMwG
         eWsc7wKrp4w01Xw4rwNmSaNq8TMbjvvFbIvFyyzyNnHVs2pB596bS6ERpc7gpXnj4JXr
         exOQqyrwLlXo0KDGH34jmOnhN3xLNMUuaHednAg0wC3Kdm+8vVnewGCFEXZb4nelKYrz
         UaEPuk+Y6AQ41GPUbU7vucDn9LWTaYy2sNex36465b8DN2gj0DVtBGpHGwp1JNBCUArg
         /+rNTq54IRSzc5DIAL1BTPz7idoivBuvGd5MpXuCsfsMHuO9q5FHMyfLGbe//pg7Q8K2
         stEg==
X-Gm-Message-State: AOAM530gztx2NPtuaIc3d/5jK0O79ahN0q3vYB6vNu0UwYSrXgfkuVWp
        lAOVL5aveiE+4OFP4p1o4grV3++WIEorszjg9TCvka0qpSw=
X-Google-Smtp-Source: ABdhPJwgDmRzOjWicuKGq7oSOoHhYZegJhXPUKFXgeCEnOVBGBHR07LJym9Jqp9s7PhTSBz8RPymw804ESIY7XFjdzs=
X-Received: by 2002:a6b:8b92:: with SMTP id n140mr4119586iod.107.1602788484412;
 Thu, 15 Oct 2020 12:01:24 -0700 (PDT)
MIME-Version: 1.0
From:   Gopal Yadav <gopunop@gmail.com>
Date:   Fri, 16 Oct 2020 00:31:13 +0530
Message-ID: <CAAUOv8hTaseM_fSzQiscRS2=N-2bxSRuXEvwg-_RmTQS0BJ_Bg@mail.gmail.com>
Subject: [nft] Bug 1444 - Segfault
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In this bug https://bugzilla.netfilter.org/show_bug.cgi?id=1444
The segfault occurs when set_ref_expr_print() calls expr_print() with
expr->set->init as its argument because there is no space allocated
for expr->set->init.

See: http://git.netfilter.org/nftables/tree/src/expression.c#n1209

Will a simple if-check for expr->set->init be an appropriate solution for this?

Thanks
