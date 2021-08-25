Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371CFC4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 02:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0455560FD9
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 02:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhHYCVm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Aug 2021 22:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbhHYCVl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Aug 2021 22:21:41 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEF8C061757
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 19:20:56 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y11so19996483pfl.13
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 19:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=/YNXYcouWDvFkJeVwVMjC+BOk8j/33nPx6Zqsvlspgw=;
        b=avpbF3n2QwJe43WskJzVZYVDya2XmoBDSJaB6SoIaKtQCUndqNcntYVtZmhMq3zh8i
         tffbljmhfGIVM9plDx9QN9055oTdv6m2EBUP0yqC/SzAL3fXExL9q0Uy1eE4dE8bDnbS
         3CZ65oAepx1LAqKhU3cPxen+gZGkRRoT5avFHWoCiNHjVRGlGFZu/0rd1SGUXUVc8cdZ
         4TYfteVcasXU1H/E5H6lyvDvJXWuc+6VoZjD/kOmUqc7T1A7TA76yjcvqB8tY7wHnFxg
         nk8iTpwNHkZr7OSyLuxj+PbtlKeZP5ov5Bqd7FIwA1NTB/S2Goo8IpQhFnbtOmSsseZp
         3tgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=/YNXYcouWDvFkJeVwVMjC+BOk8j/33nPx6Zqsvlspgw=;
        b=DdIHvJmc4uLIaX2BmRlALWD493EzM0dTe8Z/K7j6CgngrrwFALQpADeoHhSR7GzoMT
         w3Ru1dRsyONOS2v3oswJSfSsu/2mcLs9sxGmOZEbjFTscNerS2GL2zUmZwv7PJepETh+
         q4vpBHVIEQVxvgOFR4HzIVpE6TIy8Xv9iHLodny3KkSlHgkfcoxbu7oh2z2TK+nTh5X6
         SXTV0ErwvLWL9SUPoVqTtUewrT8W9nTYnBBgVtRtwSxJjFoPnYL0bnHuMCC3oHdd6orB
         poq/xobMTU21jxgOcMWg7OoHX7noiaX9sX1Q4dkZs2Bx6A7kO5eYh7XQYe/Oqj1GpeA/
         0WSA==
X-Gm-Message-State: AOAM532ztcp4OKzZ4jv8Yfm7UIuji+pj4HQmQTYGUrD8lVaRyRi777gl
        QFtiJeOieREJC64mG1TA+6w=
X-Google-Smtp-Source: ABdhPJxCEYu3BWrZ0PbKt3nRXDNui2rc7Tx1uwNcf5JS3zxPTs5U/W8sOT2yZ2Q7kjFF00gD9HBmSQ==
X-Received: by 2002:a05:6a00:1a4b:b0:3ee:d49a:d615 with SMTP id h11-20020a056a001a4b00b003eed49ad615mr3158859pfv.81.1629858056316;
        Tue, 24 Aug 2021 19:20:56 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id u24sm21684668pfm.27.2021.08.24.19.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 19:20:55 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 25 Aug 2021 12:20:51 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v4 3/4] build: doc: VPATH builds work
 again
Message-ID: <YSWpAwfcgSmvxc0N@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
 <20210822041442.8394-3-duncan_roe@optusnet.com.au>
 <20210824102840.GA30322@salvia>
 <YSWjkN/8Bp23ZITM@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSWjkN/8Bp23ZITM@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 25, 2021 at 11:57:36AM +1000, Duncan Roe wrote:
> On Tue, Aug 24, 2021 at 12:28:40PM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Aug 22, 2021 at 02:14:41PM +1000, Duncan Roe wrote:
> > > Also get make distcleancheck to pass (only applies to VPATH builds).
> >
> > Not sure I follow. What commit broke this?
>
> No idea. make distcleancheck fails in current master. Never tested it before.
>                   ^^^^^
> > Why does this need a separated patch?
>
> That's what it took to get make distcleancheck to pass.

Sorry - meant to say this is for a VPATH build (e.g. mkdir build; cd build;
../configure).

After that, `make` is fine at master but `make distcleancheck` fails.

Cheers ... Duncan.
