Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B760C48BC2
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Jun 2021 04:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B870619C5
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Jun 2021 04:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhF0Eoh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Jun 2021 00:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhF0Eoh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Jun 2021 00:44:37 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E514CC061574
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Jun 2021 21:42:12 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id a7so1553376pga.1
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Jun 2021 21:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=bZCQlN/J9g0Y7MICtGcbZC9ZEt2c8mmfTEkXOrsunJs=;
        b=creFmLrQByTM0XEAHti1vVF3sSqePsxjjEaio3GZnQYSCIWcIrdeJWw+ziA6jSbGXq
         I3fwewWvgg/LjR/VaqmCfe1Su4L63VWmneULFcP+SSLCy9K2E1Y3I9r5z+TW4mQIEZRu
         ZSTIIC7kVZI0/1Tq8bNGG2TYWoNwoNPKjapgOWepj/RPwV6VYb04BAYdojA7rbQA9Z5s
         5P6QV6mwqkvLLJU+W4Cvd56yJchHhGpsu62JKyjOcmvvjDR1zoR1fAj/Q4mvSAt+ej80
         Y3DfHCb5TTYyvguCzZm+WVFirkTwlSIdv+RHyJgZNNvrrMiqNPGgJiEv4x5TcgdPAqzj
         tmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=bZCQlN/J9g0Y7MICtGcbZC9ZEt2c8mmfTEkXOrsunJs=;
        b=Bb25H2usnBe0hOJHRbSYHp5vb9yTHk08ArwkC7Eoz+V8rP2mwU4WJucDg9xIhd7htg
         i2lIu5q7b5FSK9Zt1i1mWepy4T7Wshyu+BvflnGHYULAQYigEdaS8HCGfgHIEU8rb4J6
         Nwr1lkN1NGHFl9eimAA4WoQQaaQlyKQpOMVciB1xn1zNj4Ee/jM8/ECVx5K9HfLeYI5Q
         kH55YR0wIVTr4V+wljG00z3s5RCAvl1e3Lx9ymdz7YLS7LBITdiHk70+c05Yk4WXA6j6
         QcjP6I5R4gaoABnHRBZTKYdL78GoJSHNsLaw1Gc9YVUCciwZL8Fi3gR6pzRiRej6W2NX
         Lccg==
X-Gm-Message-State: AOAM533+8DQNYg/30jen+nbA73ZY4f9bKkr6h9sq1cEocWC1H4tGZ3lE
        hOnH7XITLXvFE/W+iwsxrNo/PtPm2AQ=
X-Google-Smtp-Source: ABdhPJzuuyb0vBMrkQuxGddbA9UqRNLNoyo+kQGB508iYR+eZvGz86QzevkmZJJ934OVkOzR/NN4wg==
X-Received: by 2002:a63:5c04:: with SMTP id q4mr17170852pgb.127.1624768932208;
        Sat, 26 Jun 2021 21:42:12 -0700 (PDT)
Received: from slk1.local.net (n49-192-153-80.sun4.vic.optusnet.com.au. [49.192.153.80])
        by smtp.gmail.com with ESMTPSA id j3sm10180795pfe.98.2021.06.26.21.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 21:42:11 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 27 Jun 2021 14:42:07 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl 1/1] build: doc: "make" builds & installs a full
 set of man pages
Message-ID: <YNgBnwZfgh0Okqft@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
 <20210622041933.25654-2-duncan_roe@optusnet.com.au>
 <20210623172621.GA25266@salvia>
 <YNf+/1rOavTjxvQ7@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNf+/1rOavTjxvQ7@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 27, 2021 at 02:30:55PM +1000, Duncan Roe wrote:

[...]
>
> > libmnl configuration:
> >   doxygen:          no
> > man pages:          no
>
[...]
I meant:

> libmnl configuration:
>        html:          no
>   man pages:          no

Cheers ... Duncan.
