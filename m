Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43C5C43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 19:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F3C72082E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 19:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z42bmcft"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfLRT6Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 14:58:25 -0500
Received: from mail-ua1-f43.google.com ([209.85.222.43]:35809 "EHLO
        mail-ua1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfLRT6Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 14:58:25 -0500
Received: by mail-ua1-f43.google.com with SMTP id y23so1109464ual.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Dec 2019 11:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M0kdrtXc25Vc47I0EqONQVMARvIyTpZdwWFp06CdP9Q=;
        b=Z42bmcftQIArMapvuPrZpTqI9kXi1W5kipvbzh4ppNtu4Nuq9Cs1olxrsnIEp7UR5W
         2+Zt+ng7X7BuIJLAsixFK66nG+khkE8y1TqTvKHF9r5XhJGl3uLzyg9iPtT6M9i1Kh/L
         OBXAq2hzR2N0ESHiN+SEYp1u2CpOG5SqYcrH/yAvxPAG3kJqmnHzgw7YOhM/qUJQOd79
         MABSfxUVE1zI5OhSBrJXpGkSI0nT9DN/IGmjTVpt7iIVhMpZxMB3vdjv0pMpO65P2I4U
         Res62CwVrFnoH4m7722B6wTflTCnLDnxxU7Tkr5BFKCtvBiMqVJATgsA0//ve0ONIk4o
         dVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M0kdrtXc25Vc47I0EqONQVMARvIyTpZdwWFp06CdP9Q=;
        b=jnVvj9VDXHo0OUbfcMJA7/Nxreu3xcDoSsV5xVdYa6EFUkd6XK07xJra/W8967bsWK
         mnXq+JRC2tSyA3iWLMsDBKDyzEttZTaUzAPt9w6ECmR3bPT2+Cdd1f1VXPcqLYJPg0Ch
         vC9vUVbPmFvF0R83pB58boAr0aG3uWNSaFJKDUuiWNjiA8OZ5OpVyLGmsiZd5306G7Ej
         6bPI94kF+nkyytu2nh3mVri6BXBmA+SPK1X+GBAi6bdderfu611Wu9lpc0rs25ME2l2h
         q/xqvDUnXD0/hfro8BwTDfpY1+/UKQBgiqE8TIv52Xyn3KXCyeyuyvOU3+xAiZSiG2E1
         WvDQ==
X-Gm-Message-State: APjAAAUBjRnY0vzEaEn0aGY9QgD7/J0/gMkrYZKWHTSyw6xrqj9KdJq6
        jpV/bM66Vi2uPKmdM7bZeCfsyPtov22yf+DKt/ot80ng
X-Google-Smtp-Source: APXvYqxSAUrEKHA4X/D+dtP//6kvnzDUITtrNZ5EL6habq4wciVQjKxKf2pAopPjqLV/sLVdn6ox/IM0jEqewQI9wDg=
X-Received: by 2002:a9f:36ca:: with SMTP id p68mr1818808uap.112.1576699104370;
 Wed, 18 Dec 2019 11:58:24 -0800 (PST)
MIME-Version: 1.0
References: <20191204151738.GR14469@orbyte.nwl.cc> <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc> <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc> <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc> <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
 <20191217164140.GE8553@orbyte.nwl.cc> <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
 <20191218172436.GA24932@orbyte.nwl.cc> <36EA0652-C146-4ED4-A004-2D729AB69BA7@cisco.com>
In-Reply-To: <36EA0652-C146-4ED4-A004-2D729AB69BA7@cisco.com>
From:   Laura Garcia <nevola@gmail.com>
Date:   Wed, 18 Dec 2019 20:58:12 +0100
Message-ID: <CAF90-Whnsiw=kEGyYroERYwo+_E2vWEv_3RtT89oSbp-9xoc1A@mail.gmail.com>
Subject: Re: Numen with reference to vmap
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 18, 2019 at 8:44 PM Serguei Bezverkhi (sbezverk)
<sbezverk@cisco.com> wrote:
>
> Error: syntax error, unexpected th
>
> add rule ipv4table k8s-filter-services ip protocol . ip daddr . th dport vmap @no-endpoints-services
>                                                                                                           ^^

Try this:

... @th dport vmap ...

or

... @th,16,16 vmap ...
