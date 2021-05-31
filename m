Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D827C47093
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 May 2021 03:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07BBF60FF1
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 May 2021 03:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhEaDNP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 30 May 2021 23:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhEaDNN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 May 2021 23:13:13 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAADC061574
        for <netfilter-devel@vger.kernel.org>; Sun, 30 May 2021 20:11:31 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d16so7928281pfn.12
        for <netfilter-devel@vger.kernel.org>; Sun, 30 May 2021 20:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=8yZlYrTPOfQ8YcywmKNT/AfrL2733n2CsR7O9h0YpY0=;
        b=fvk73uU9QFsjJ2D0TLlXMvU8w49FYCxAHsKop5OvmSgVBPe86Sfn0+s05hMScpgq00
         wBwnUnP/a5fGBX0ZWYCgO8Soj+EQZCmYISjjLL3SGTm+HCX2uJNuP0sylz6/MOdWW86R
         oewMqjofRrliOw2Ch8moJO+QV0cjMXnM4PME6r2t70e/JFwYUdFnuozQZYQQOBHDerfO
         bpFYolmk+uUhGlnfgInExDgen4Hb2XzaDPHH6ilTduc1Lwcl5auxSajhvcod/sUS7FRO
         a3OI6q+skpadjrieMEF0FMhNf1thENJWGdaWiIMPfskA8FtldSEE6944PebnVvA727S5
         2FxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=8yZlYrTPOfQ8YcywmKNT/AfrL2733n2CsR7O9h0YpY0=;
        b=DyaJHIANHGBIZQj+ex4uAOH7Qa1opINQCWl5JLSByVRvBeKyHTDtk9jDkZYNbZfUvL
         7EWzRXxCCd9fKA2+qDxaE7N+thq/CPRbqaAo/5hjVXsQUaaDQJ2CDjygLaLmHEOlmhkJ
         Vdqk0Y6DEBT0Ehmrb/d/qpVvj6iif0jRPy0emeMjJa1bckAnhXhnz+bjf3+GM33H/HMV
         VKMGW+yavtRg4q+ulEISYOvU8S/UuKnaFso6fOYasgL5S0KyHF+p0T3uuaJIgte8c6HL
         wp+BV6MEP5ZXXomhDMh2DJwrANzAbLVYtv1HZ2Lyip/ofxzsWpClxTwXIhzgfyknzwY9
         Q6cg==
X-Gm-Message-State: AOAM530mfrdNk6FM/2E3nxKYDOtOp5SOOVV5DjFy/cH29+EnByb1wgZW
        oPCxe4l0yXtro4XCL4d3rHcKOZwax48=
X-Google-Smtp-Source: ABdhPJw7ORAci45gB5g47XsVF5dlzFYJKvJbsAec9lWEQgF7Uf/2XbxVLKPLwB73zovJ4kUlgtylrQ==
X-Received: by 2002:aa7:8b56:0:b029:2b9:77be:d305 with SMTP id i22-20020aa78b560000b02902b977bed305mr15092881pfd.61.1622430691406;
        Sun, 30 May 2021 20:11:31 -0700 (PDT)
Received: from slk1.local.net (n49-192-209-119.sun4.vic.optusnet.com.au. [49.192.209.119])
        by smtp.gmail.com with ESMTPSA id h1sm9460246pfh.72.2021.05.30.20.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 20:11:30 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 31 May 2021 13:11:26 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH RFC libnetfilter_queue 0/1] Eliminate packet copy when
 constructing struct pkt_buff
Message-ID: <YLRT3kDFMv7jj3Et@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210504023431.19358-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504023431.19358-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, May 04, 2021 at 12:34:30PM +1000, Duncan Roe wrote:
> Hi Pablo,
>
> This is item 2 of 4 after which I think we could do a new release.
>
> Item 3 is to eliminate packet copy when returning a mangled packet
> in a verdict.
> I have this working in inline code, not yet factored into function calls.
>
[SNIP]

I have abandoned item 3. Timing tests showed sendmsg() of 3 or 4 buffers to be
slower than memcpy() them into 1 buf and send that (i.e. use
nfq_nlmsg_verdict_put_pkt() and mnl_socket_sendto()).

Instead, I'll take a look at stopping the automatic load of libnfnetlink, as we
discussed a while back.

Cheers ... Duncan.
