Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995EEEE49A0
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Aug 2023 02:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243860AbjHSCzP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 22:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244554AbjHSCzJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 22:55:09 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111D53C34
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 19:55:08 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-56ce1bd7fc4so1069896eaf.2
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 19:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692413707; x=1693018507;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ffgndxor3alc5NmlCuTnYrutKULW5tPtqKCrWJWboAI=;
        b=h4fPmyMsWS1aqCX1J05zQhyPbgPAh2vN6/lk0/J1Me5EoU73bLJqNBKk0nqtSFQSIv
         GE0xmpFbln/ggTRw2NJ+PZ2UkkiRr2B1wi6HQVSPVrfzaFf8gOvG7p2RviLe23ky8D7x
         7vYsk4QK067PRCwlH3JWVuhRf9JGCSZAMlzCyM1bMqftELJkaSEJ3tliqrzT+cJ5jZhv
         C+aQo1wnyOrWuT47qO0escwkpdP4RzV1vZRfMcNNCoThywZU87dCGP0/QkuDxA1n1BX4
         JyEnNVyAPbNd5OCn4B/IgwMqqt8Zqv00x4gbDpzXjPafqjmuHeyPawqjD1y716AIfuQJ
         A9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692413707; x=1693018507;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:to:date:from:sender:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ffgndxor3alc5NmlCuTnYrutKULW5tPtqKCrWJWboAI=;
        b=LYWo0i1hUhoTd88CPupiYSXNdGnT+3sDCge5W2fJGGbA83ChvmlG50DTkQiC13jIg/
         Fif4M1KngiJX4n/QuaaeFWiHCoCNxIz9a5stmXGM65Rimu/Yt9/H/2aTBOl7jC2ao3K2
         Z+ss/uXzI4XrC+cT0jWxsbRaoi7jiXCANzYRMhFcqvAiFcgtMOUnS0gplcxVZQ2oJCgB
         ux+XRv8b1JFpaKvEvhOaLtHWsyllFnPp3SeGTv6pMTFL2Q7agRWmz9H6U44xsIphiEKn
         Xaij2NzmKkHP/jqcuArQh8R7eo3xBl9NOAUxYyOsuIIx1cndkrGVqV/iik8poHyeFcB7
         KttA==
X-Gm-Message-State: AOJu0YwMJv+DstAix3XmrDlKvTAalDwIaNJcEl+qOtiZYa1rTHQvpry1
        knzCL9Kl75xXIhv8HpuAug8vXD8AKj0=
X-Google-Smtp-Source: AGHT+IFB72t3WoTl0cGJmbzMvddoRe5Z5ea8zaSM/T6Ty5O0UZc4ldcpovZs1MBmhzd9mNGPk8DOGQ==
X-Received: by 2002:a05:6359:2d99:b0:132:d07d:8f3b with SMTP id rn25-20020a0563592d9900b00132d07d8f3bmr930581rwb.28.1692413707043;
        Fri, 18 Aug 2023 19:55:07 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id z2-20020a170902ee0200b001bbb1eec92esm2470221plb.281.2023.08.18.19.55.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 19:55:06 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Sat, 19 Aug 2023 12:55:03 +1000
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: libnetfilter_queue patch ping
Message-ID: <ZOAvByRubG+0lVHX@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is a libnetfilter_queue patch of mine from the March 2022 that is still
under review in Patchwork:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220328024821.9927-1-duncan_roe@optusnet.com.au/

I tested recently with 63KB packets: overall CPU decrease 20%, user CPU decrease
50%.

This patch could open an avenue to having libnetfilter_queue handle tunneling.
E.g. for tcp over udp, you could have 2 pktbuff structs (because the data area
can be anywhere, rather than residing after the pktbuff head).

It would be great to get a yes / no / please do xxx.

Cheers ... Duncan.
