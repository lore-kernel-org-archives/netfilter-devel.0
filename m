Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04F3C432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 11:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E956322D
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 11:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhHPLnK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 07:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbhHPLnK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 07:43:10 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08146C061764
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2021 04:42:39 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so13565812pjb.3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2021 04:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=atH6VGpaDPtZsKgh86lWVkbFe0uBOuqI9XbFevpVA8Q=;
        b=laJtjNcimHUsnmpmVAfcJqegb2nvPI0rarxpSVQC1wYZoe7FsmRshKrINL24KrcSPI
         OooqKoo8mvcThpjS15tezB6F4hhIiBQlcelXGeqSwdyU4TifXUAXJweGw0DKYGJO+Up3
         AbBUn3Qi5AOezQsN/ymTA0av+jfmQKvDjbaWxVqaFLPCXNdwEEqUX6MG6L3/6Fm7qWOH
         IET62++xnPeukbvUMRD34mpDwJ8wlojRyc/L04RS0UB2lRZVeJ9jtaZGYoMYEr6hoG2s
         8JQ8rmyG6jijukWLrPq/WmcfKnNm+CwbhwvCkN7yCRVjtURjQLzsBqE+IGBhQZjBbOYl
         3eVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=atH6VGpaDPtZsKgh86lWVkbFe0uBOuqI9XbFevpVA8Q=;
        b=JrAiuS5PRoynjqLSqcZ0+PGyXtkoCY0qEEkKXaIvrEs7wbNSOWJRhYAcpbS02ZDD3K
         lec2NZt/PgpuWDra6N/iveRU+s1tJAknV1wPr0mkVd0uggAcTsJSkabLpYB8g36DAWp4
         c7fY/zbvW8nLb2cth/4wVwD/+8Bfr0IGYrK22PVkkbBtjXErnASs7rbhkcnJn0vrKE3s
         CUKwhOgZRpcbpN8hn3OIxfhZGPMtvJgTyh3amd3VqTYrjq8pQZ5R8b0P5vjZkshVSQCE
         3HQ5BpJgwkGhDzELZuRtZWnXTzCoVmg2trtRacbR9nBjb/s7A63Rs9EVEdc5UAoLErqR
         ErWA==
X-Gm-Message-State: AOAM532FNoMAqUviLRe+3LAVLci106rEkoV/42QTF3tfvaVp11ar6h74
        93hZhejNvK/0uirib9nz2jc=
X-Google-Smtp-Source: ABdhPJysgOIvSDVNhDbziPhGOf90+MdtUKFDSTXNklQxPpG5bJojcb2M8jRqQzZecejNMFkGEp0jDw==
X-Received: by 2002:a17:902:cece:b029:12c:72bb:4d64 with SMTP id d14-20020a170902ceceb029012c72bb4d64mr12940494plg.56.1629114158588;
        Mon, 16 Aug 2021 04:42:38 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id g202sm11272461pfb.125.2021.08.16.04.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 04:42:37 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 16 Aug 2021 21:42:31 +1000
To:     alexandre.ferrieux@orange.com
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: nfnetlink_queue -- why linear lookup ?
Message-ID: <YRpPJ8jZRI80ApTu@slk1.local.net>
Mail-Followup-To: alexandre.ferrieux@orange.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
 <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
 <20210815130716.GA21655@salvia>
 <4942_1629034317_6119174D_4942_150_1_d69d3f05-89f7-63b5-4759-ef1987aca476@orange.com>
 <20210815141204.GA22946@salvia>
 <5337_1629053191_61196107_5337_107_1_13003d18-0f95-f798-db9d-7182114b90c6@orange.com>
 <20210816090555.GA2364@salvia>
 <19560_1629111179_611A438B_19560_274_1_0633ee7a-2660-91b4-f1d7-adc727864376@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19560_1629111179_611A438B_19560_274_1_0633ee7a-2660-91b4-f1d7-adc727864376@orange.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 16, 2021 at 12:53:33PM +0200, alexandre.ferrieux@orange.com wrote:
>
>
> On 8/16/21 11:05 AM, Pablo Neira Ayuso wrote:
> > On Sun, Aug 15, 2021 at 08:47:04PM +0200, alexandre.ferrieux@orange.com wrote:
> > >
> > >
> > > [...] to maintain the hashtable, we need to bother the "normal" code path
> > > with hash_add/del. Not much, but still, some overhead...
> >
> > Probably you can collect some numbers to make sure this is not a
> > theoretical issue.
>
> 'k, will do :)
>
> > > Yes, a full spectrum of batching methods are possible. If we're to minimize
> > > the number of bytes crossing the kernel/user boundary though, an array of
> > > ids looks like the way to go (4 bytes per packet, assuming uint32 ids).
> >
> > Are you proposing a new batching mechanism?
>
> Well, the problem is backwards compatibility. Indeed I'd propose more
> flexible batching via an array of ids instead of a maxid. But the main added
> value of this flexibility is to enable reused-small-integers ids, like file
> descriptors. As long as the maxid API remains in place, this is impossible.
>
> > > That being said, the Doxygen of the userland nfqueue API mentions being
> > > DEPRECATED... So what is the recommended replacement ?
> >
> > What API are you refering to specifically?
>
>
> I'm referring to the nfq API documented here:
>
>
> https://www.netfilter.org/projects/libnetfilter_queue/doxygen/html/group__Queue.html
>
> It starts with "Queue handling [DEPRECATED]"...
>
The deprecated functions are not going away, it's just not recommended to use
them in new code.

The replacements are the non-deprecated functions.

Here's a bit of background: libnetfilter_queue is essentially a blend of 2
separate libraries. The older (and deprecated) library uses libnfnetlink to
communicate with the kernel. The newer (current) library uses libmnl to
communicate with the kernel. You either use functions from one library or the
other: they don't mix.

libnetfilter_queue is a wrapper for all libnfnetlink functions except
nfnl_rcvbufsiz(), while it only provides helpers for *some* libmnl functions.

The main new feature of the current libnetfilter_queue library is a suite of
helpers for packet mangling. These manage checksums and other required header
manipulation for ipv4 & ipv6 and the upb & tcp transport layers. Current
libnetfilter_queue also provides inclusion of a mangled packet in a verdict -
not available from the deprecated library AFAICS.

Current libnetfilter_queue doesn't provide batch verdicts. I don't know why -
perhaps Pablo can elaborate.

Userland support for any new featuer would normally go into libmnl.

Cheers ... Duncan.
