Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED877C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jan 2022 02:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244394AbiAUCgl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 21:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbiAUCgk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 21:36:40 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59423C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 18:36:40 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so3687875pjt.5
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 18:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=Tjv97gxp2qjmJWODiC8BsWX49HRk79C8uQsjsHdRI+E=;
        b=Pa7T5ssZTAyTeNGYgHjaH/XeFn8NH81Jaox/A1o+RtEE/hLWKEXiVL7UBa4nqtiIVf
         EmhQudRzKI8XsftT2f3kkmoIBJe8pHjh9TW0VrIyS5962CiqPxfQBHLXfuFW/Mu7d4U5
         JUGZoi+4pAtvtJp/pqN/XlWUYndLSrlX8kIt81dNo2elwRwnWQAandQ27dhrEE8ycfB9
         73iGSK/q7E5oWWQvLCc0C580fgaLsIscz6vyc2WYMhqc7g677D5kwbu+N8ijh4AF+FEG
         qywsbPLKK6+7FYcUIAs0/ElEfD6AjpMswZufdErPtYTfCDp1kOsr7O8Q04xXGNP8BFrT
         7fdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :reply-to:mail-followup-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tjv97gxp2qjmJWODiC8BsWX49HRk79C8uQsjsHdRI+E=;
        b=pqEJ1tEJr++zL4A9kTaUHke1T3k5zy/jivzAXJ/8FKSuPzH9EAZpaBEkAPb7LSIfXL
         o/nsutxJmrCr1LnbiVmV38l1z5dh0IzofJujOQUgFz9KX6W7gkwP3K6konqczNX/rllw
         aL+an6YJoEIJXk2Bpw/TsBxgUVpYP2P40m69a7QccjS+bJ01ieApwVjfGBenUS8Mjjfh
         03XkQIC8GnJXG07mbEcNNXPMR3RO2drW3HjoQSuwatIOxdcHjs3KMOxb1WQC0vXGt3JF
         nMJsXw1hgAhbMSIg6kgA0hhM7DxwRueoGTDTA2JCfLe0dWvkIiKDFZXdloWwugHZg3vr
         nSVg==
X-Gm-Message-State: AOAM533f+Dl+ZFHFnNS0Nlo4zp0yM93EzVkXWv8ggfcCBxDVDAiG6jBt
        Iv6LYvoXHlSAhntR3KFPlGQ=
X-Google-Smtp-Source: ABdhPJxuG3MyGGPJZkbq7UC7HVyX8pkdVkDyBnFzsOwgcWArxRJ4SluaWiLE5snhfBReiYV+l4gZuQ==
X-Received: by 2002:a17:902:bd4b:b0:148:fdda:e85b with SMTP id b11-20020a170902bd4b00b00148fddae85bmr1823425plx.116.1642732599899;
        Thu, 20 Jan 2022 18:36:39 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id b2sm4862747pfv.134.2022.01.20.18.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 18:36:39 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Fri, 21 Jan 2022 13:36:34 +1100
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <YeocMjUD45w2THPh@slk1.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
 <YeYClrLxYGDeD8ua@slk1.local.net>
 <YeYTzwpxiqLz8ulb@salvia>
 <YejdVZaoUz+t1qRU@slk1.local.net>
 <20220120062725.GB31905@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120062725.GB31905@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 20, 2022 at 07:27:25AM +0100, Florian Westphal wrote:
> Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > On Tue, Jan 18, 2022 at 02:11:43AM +0100, Pablo Neira Ayuso wrote:
> > >
> > > This patch have a number of showstoppers such as exposing structure
> > > layout on the header files.
> > >
> > That's only in patch 5. You could apply 1-4. There are actually no other
> > showstoppers, right?
>
> Why does patch 3 exist? Shouldn't that just get squashed into patch 1?

Didn't think of that. I have a squashed version now.

Cheers ... Duncan.
