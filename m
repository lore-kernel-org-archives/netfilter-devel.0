Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D37C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 01:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F83161357
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 01:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhHYB61 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Aug 2021 21:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhHYB61 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Aug 2021 21:58:27 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8671CC061757
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 18:57:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u15so13356015plg.13
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 18:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=rgixwHhOyrt3Qc6EZVMliXQlti6hVzNVQh1zruMHLp8=;
        b=ak3Ax8qy5/u1LnOxvHeVdx8wKhdt6IrE1Nt0iBzwUYLbVxmICrfuoGjP4HzmgcmrzN
         qQwgqqGdvuuUhvs5css3qgOcyi8T9d3sU5yheuebcEubKKy/85ICiOVRaVXz0PMjPgzs
         cvcZ5CvA10VG1psOyJw4nECzFu9FqlpKe9SgWNJN5G6Wkke1vqrA7T7cscR/TeQzirt5
         2LTVCbvEnZB7+qMR2HpTIiEZu+Ny/fx6goi0ci0w0YfGSSmyDnkbbcTlJO31CT6I9ZM2
         yC7s5bj/jt4oxoec0UgDKnrwgPQAXBjKkqPBckWdPzb5uMOOGg/ARvM7pYw+Fl0A7ILq
         +YdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=rgixwHhOyrt3Qc6EZVMliXQlti6hVzNVQh1zruMHLp8=;
        b=iIBSH/9w7FXSH2Qno/TZM28fcSYVZdI5rOqLiIk1bfnZeheGnWuaoJ3y2NxqOT66ad
         B+pVC2KfCiQtwOt1j0WLW1ayom5z48xdxg4ORQqfg8rE807oq2+l3wc4s5HjpJo5DPpB
         LHEsdiY76qG+MDBoU5dbgP3fHnG+RFHmZQB+puFVUqC9VAUUaYnb84t1EGbbSGo+8I2x
         gdm4+pm7HGSBf4nNvjLwO2d9DMgiMSBoV2WlTaUdXKZk3768wpv2zwMB1XOTfDzl0FBE
         NPlw9Jw4iqqrHvyySJKtaiMTaEX6zYn8FKIJq3VsTTsgiyGmJwHmtU8y+4p3zQemam4X
         3dhA==
X-Gm-Message-State: AOAM531rTFgRQnBCPUL2joEOWOwaH9GmUwNMc2sh29SlpBDL4sLYnFli
        y+Ql3RrxMDS5TOoucMT/w34=
X-Google-Smtp-Source: ABdhPJzvoXEVCWymxtR8VHOmds2ipVdIYVR9OL6Tspb6MK0uDXQcH2HqXqEf5daJtAVyaMjxtpUMSg==
X-Received: by 2002:a17:90a:9318:: with SMTP id p24mr7504338pjo.138.1629856661794;
        Tue, 24 Aug 2021 18:57:41 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id ev12sm3462227pjb.57.2021.08.24.18.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 18:57:41 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 25 Aug 2021 11:57:36 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v4 3/4] build: doc: VPATH builds work
 again
Message-ID: <YSWjkN/8Bp23ZITM@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
 <20210822041442.8394-3-duncan_roe@optusnet.com.au>
 <20210824102840.GA30322@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824102840.GA30322@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 24, 2021 at 12:28:40PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Aug 22, 2021 at 02:14:41PM +1000, Duncan Roe wrote:
> > Also get make distcleancheck to pass (only applies to VPATH builds).
>
> Not sure I follow. What commit broke this?

No idea. make distcleancheck fails in current master. Never tested it before.
                  ^^^^^
> Why does this need a separated patch?

That's what it took to get make distcleancheck to pass.

Cheers ... Duncan.
