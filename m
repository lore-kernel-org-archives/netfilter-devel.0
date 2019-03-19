Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44925C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 07:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07AB420857
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 07:04:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XanrUo4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbfCSHE2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 03:04:28 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:34584 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfCSHE2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 03:04:28 -0400
Received: by mail-it1-f196.google.com with SMTP id l4so11744796ite.1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2019 00:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6r79ocsQCHSvI0yHtIaNOibMz//q1bwMdriYmZTGAu0=;
        b=XanrUo4eXEEsrxlmL91J61JIyTGrQ3Dp6rKC07A9PK5P9UM5g9AcfsP22NXwloPaEJ
         WZpYC00jmhFRVEx/HNO3QekaZLGV8moXTWuKE3r83WRsO6+FgeA/AGHXQDJ4Kkl0WZ4V
         af0ZKLbKuHLAisvMh0hAY4sPFm4cABIhlNbcJMXhfdJAzptpHO1rChrYkaFYSPqA15uS
         S4ar2P5VFvUDPR2oE2l0dC5IJy4+3jEajnz+SCttIkOhxYGMDgEznMZ2N+NKklpQKeIm
         RCVogEg+TiLz/oHPdNlyfW5V3545zUgxdyU62OwBohqgCwL9pUf8UNGatwAo7aGpk7mk
         SA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6r79ocsQCHSvI0yHtIaNOibMz//q1bwMdriYmZTGAu0=;
        b=kn0S3MuUnjqCimyAIVdTK0Yb5TP6DKtQ+dKoaFcZp9pJeVVLE9+TKlIf5Z9NkTbqsU
         AYeJPvHZ9seg/xR1demJeGVQG05hiAYBzf/8pq6VrFsmGeBzBSULVIBhiPEsGKp3XHY1
         4BBfXoBlVELKqJ9He41wSPClvK3j48Rb8mxm/e2RQiEpqhQmwLpcaO9Zhld7nLDAJOTY
         N1GeOrTRjCWPQVJnBtuuwGgGWLuQnljJxyFTh32o4UBzbBfYK+Ksam++FIXt1nWdzYfN
         riUdeEkPBgr4IveuzepMQ1DS99vs8O3TwxCF42dubPeKhcxtvJjqCBB2LoHajHqx7soW
         dcNw==
X-Gm-Message-State: APjAAAU3pbXUTJd/VxIxWMJpKQjMHzJx8/bjFHVfsllOff8D5zZcTGxk
        gqige4RzOZKXfJNdDt9NATqTzpHG62kEf4nEIzzDh7ylMLo=
X-Google-Smtp-Source: APXvYqzj0b5a6mUygT2HwX1W25cyFiZ0IiGRBxZsEdu3TLhsj1Qn0IGGiPaHuxV3hWUi1z5ZAo5glvhFhl7LCzTVkIQ=
X-Received: by 2002:a24:4fc3:: with SMTP id c186mr495561itb.71.1552979067374;
 Tue, 19 Mar 2019 00:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190318094745.GA4394@nebula> <CAHRz_yZMsP2RQPu=8pTigq8SrYz9xYSef3S_d4ORAMkkYDEv4Q@mail.gmail.com>
 <20190318105545.qz5oddbjah4qc4fa@breakpoint.cc> <CAHRz_yYk_Yq5+Tp1J1jT2rVT0pHWjH37-F8Rdi1XCLWj79J6rg@mail.gmail.com>
 <20190318220923.5v64yccan6shhpnq@breakpoint.cc>
In-Reply-To: <20190318220923.5v64yccan6shhpnq@breakpoint.cc>
From:   Karuna Grewal <karunagrewal98@gmail.com>
Date:   Tue, 19 Mar 2019 12:34:15 +0530
Message-ID: <CAHRz_yY=yrrMJS98s6cq9sRP_nrSNrv5kKCPxKT+BAj_GGS5hw@mail.gmail.com>
Subject: Re: [nftables] tests/py: Add Test for `meta time`
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 19, 2019 at 3:39 AM Florian Westphal <fw@strlen.de> wrote:
>
> Karuna Grewal <karunagrewal98@gmail.com> wrote:
> > command: add rule ip test-ip4 input meta time 100
> > Error: Could not process rule: Operation not supported
>
> This means that nft_meta.c doesn't recognize the TIME key.
> You need to run the modified/patched kernel for this to work --
> it looks like nft_meta_get_init() hits the "default:" switch label.
I'm running the tests against the new modified kernel (I've applied
the patch to kernel 5.0.2) and when I logged a debug message it
confirms that it's indeed hitting the default switch.
But previously running nft against the nf-next fork of the kernel was
recognising the `meta time`. This leaves me in a bit of confusion.
Meanwhile I'm trying to verify other things, could you please confirm
if the kernel tree isn't any issue here.
