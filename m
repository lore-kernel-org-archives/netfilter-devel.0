Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC9EC07E96
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 02:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E354661C9C
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 02:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhGGCWm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 22:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhGGCWm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 22:22:42 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08795C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jul 2021 19:20:01 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id a14so223320pls.4
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Jul 2021 19:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=C8iGp9K3bVmqfyoTP/awlpDLxqoOqJzX2QaZF9WiOA8=;
        b=P2mj/+VzHMeeVr+xwQDlRlAzACkYtClSd3E8lhE2JhbkHwuoebXP8Z9vJxMJ7Wk460
         9izmXJIZR6Ts+rSdfDW1OJZbb/fqV5UjcXfTWtqQDnfb4TIr0o/3+RIaRBb5tYQX+cWH
         VoSD7KZ0VNaW3iJMNJZgMiTwp0x6UbV9LM8jnxYwFOBmMUGdPee+MWzIj55jbmf0j7Pa
         4jpl1m2MmlzTzcLMZH74KNW2iawpO7GB46CL9xtnVwATfmX3+2AOnXS80Xh0Ix3b/jD9
         iO34H5ovSYgD0k/Iw7s4fxLM94Pj/mS8c0eAScXv4Ny38lSL4UnQNL90kGIlhc+AH2VM
         Vs8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=C8iGp9K3bVmqfyoTP/awlpDLxqoOqJzX2QaZF9WiOA8=;
        b=FRsHoyYEgSdoNtFSTeOjZBnLuO9sNVJ8J+aXJNXjTyKDdJ1d1TG39U99z8KV09PYop
         kJT4AAQ2F93vVIcIeY1MNUS8zQqDFIfkSViYzn6hkHzXCP0hOpvawRAcJd//a2LYZ9se
         3rv2aPyEp4p+DlRAssMV/91L0Hsxq7qk9wqj3qsUKaTGc9tzlz7SBxQO8wGLVFwz4A5J
         +rofbcnFxAo68GaPLp8Ps3XKBzTDlyF9hmhqpXbIj90VUFlokZCuxGdKZY0vkdVE4SsH
         YhrCqIsCSANCYUFpbtYKBi11f5Af8OkMfQuzFSk97F2KZhS/Mi0iahUMUDX+ucOBMAm6
         yBZA==
X-Gm-Message-State: AOAM532aKZ4D1kqkLX93i+FiqyIZb6ZZZP2BHP9eKnQwQpDWsrNGlPZT
        LnT5/+l/x18iba8q/OsxiTs=
X-Google-Smtp-Source: ABdhPJxFHGpl8jyi2qJqNItnjZIzN37GfxyuXSYNzhQzzO5/YYrPW2+079Ww6Z99MbGIwFcSQ0i5KQ==
X-Received: by 2002:a17:90b:792:: with SMTP id l18mr3518291pjz.55.1625624401371;
        Tue, 06 Jul 2021 19:20:01 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id z20sm21095133pgk.36.2021.07.06.19.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 19:20:00 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 7 Jul 2021 12:19:56 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl 1/1] build: doc: "make" builds & installs a full
 set of man pages
Message-ID: <YOUPTGuIGRKhkKFU@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
 <20210622041933.25654-2-duncan_roe@optusnet.com.au>
 <20210623172621.GA25266@salvia>
 <YNf+/1rOavTjxvQ7@slk1.local.net>
 <20210629093837.GA23185@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629093837.GA23185@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 29, 2021 at 11:38:37AM +0200, Pablo Neira Ayuso wrote: [...]
> Do you know of any other software
> following this approach of converting doxygen to manpage?

No I do not. Otherwise I would have based my patches on them.

Doxygen does not play nicely with GNU autools. The best post I found on the
subject is
http://chris-miceli.blogspot.com/2011/01/integrating-doxygen-with-autotools.html
Please be sure to read the comments at the end if you go there ;)

Cheers ... Duncan.
