Return-Path: <SRS0=iLnO=B5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59542C433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 13:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3113020738
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 13:16:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GagE6qKN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgHSNQK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Aug 2020 09:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727932AbgHSNOF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 09:14:05 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6543C061757
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2020 06:14:04 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d22so11666098pfn.5
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2020 06:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Xh+wWgJC0wYpeMZ/FY8pgcf4puZM1cXJxYtp4LJjjI0=;
        b=GagE6qKNfCtfKu4aKmCduw3VOPdPWQp9kMYXypDj2XjE5f9zUtJEmgUSfwwroOTENW
         3FIV+ybylLsBEmDmJdOlvyT/0OyaJVQwK1RzBnVkO4k8Jv6XzF3ftaOrn+q6V0sAfX21
         z9XtHENiCXci4Ua5uzOZtdPxDyLfHz1bmAHdtlAKWaADrzUIPydEJmW69hWyg/2SW7JU
         jVBPLYXn0Zx8uIjuB8gJF0vvoFn23MmPS9APKyk7nanK+sHXk+7LiBGVT0lQkjm+50lM
         aayYYB01oH7ZSTQ2+xztkgZNQllu8SuCHnMd1g15u2AAwFHFo7tbBApMeI/MobDC6feB
         HwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Xh+wWgJC0wYpeMZ/FY8pgcf4puZM1cXJxYtp4LJjjI0=;
        b=P4Pt0XvnOEQYKTMSdQz3EV5JzWNfkhSm/UGtHTivL6tUEsb5MvuALMe3nYUySrOnY4
         tLP0J/alNlTQ5M9/JNHqNC9fHKfnyxMkN/2qR7OHw8Z8lmsadthBI2o0Y9giYQUE1LC0
         bGxGNPK7xYXE9YgqWOyGIbO+V23cOU07Lrg2skpK5BPV4olJF6nqNpjja989jpLwCmZh
         xL0EBS16rtSOZshwiY2OejF9mhLVEDWl3SNDLlsHjt2dUjQlTevw1QIubppfnSgue4IO
         pVlVRZfV0bbMhXhevfF6r1wncg/RZK/rXQ2l+5ozqi4/ewGxE84Ddc6wtPQRhARTTyJS
         VKsQ==
X-Gm-Message-State: AOAM531coWsHC1BrQ/D/fKiFj2i+RnM29Ai24nZzE3zii1fK5nL6/or1
        1X2rHsRAMIwrDDBBKWQwKnrulKp3WcDvUY8lD7fsywhN8T0E9A==
X-Google-Smtp-Source: ABdhPJwHLHifyH+GHP6kJoxZQtXkZ4BZ5wj0hWsnXMXpadeEe4AwclPJcg7L/Kji0yJhIhBd+RRWMjUgaICrhT5Pxbc=
X-Received: by 2002:a63:d517:: with SMTP id c23mr16591660pgg.65.1597842843600;
 Wed, 19 Aug 2020 06:14:03 -0700 (PDT)
MIME-Version: 1.0
From:   Amiq Nahas <m992493@gmail.com>
Date:   Wed, 19 Aug 2020 18:43:52 +0530
Message-ID: <CAPicJaEusDtr9ODxdFvRwS1HyQicKbU=cbGbKLx+nk_DcucL1Q@mail.gmail.com>
Subject: [iptables] connlabel, increase the number of labels supported
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Guys,

While nftables has got a solution for this https://lwn.net/Articles/524593/
I am interested in doing something similar for iptables. If I am not
wrong currently 128 labels are supported. I would like to increase the
number of labels to 4096 or 8192 or make it dynamic if possible.

I see that libnetfilter_conntrack has some macros which seem to govern
the number of labels supported. Ex: MAX_BITS and HASH_SIZE.

Any suggestions on how this can be done?
Please pardon and correct my conceptual and factual errors. I am new
here and have very little idea of what I am doing.

Thanks
Amiq
