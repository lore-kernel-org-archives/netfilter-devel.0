Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A9BC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 08:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAFA461004
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 08:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhHIIWo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 04:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbhHIIWo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 04:22:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCC7C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 01:22:23 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so2740353pjl.4
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Aug 2021 01:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=DQO1YB406B+AGYqpBjdRcTZg/ndhmPzNU2B0d+SYOOI=;
        b=F15UbcRBYcQ3yzf6jWdKGjr/slK3vAmtur21fMJ8C3/+YPIvlk+SQcgpKBfKehGEKa
         rhdk7fyP5WYkBNZsw7PMARfbm6hWiFCxo5ccbwtstc3so7VJFne3apyq1U0izWNh0Pze
         Bs8WFgzfAmyNIoC5xu1P9JYScGD2/UunR/iN1KY6vSC+hRuBuCtLj0hKKmpXYSevm4Hq
         DTF6j8Mk7L4e2RVOL8F3XMxd8eUnRO8kceqZ1GP8Ab+DW1TxHgq+Pv+kihnLFV9SVnvC
         XMyUwJJZbvZaXcqpFSRD6UZEtG8MzFZv1tsx6zl9tpfntDhMm+rzGmjAjZ21ixdwqry9
         +5hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=DQO1YB406B+AGYqpBjdRcTZg/ndhmPzNU2B0d+SYOOI=;
        b=q/8hHjp5nmalUQ4JOZma51ey8OEIWUxrEjfrqyYM74HK94tMzbhpMhu/eiGp1HURWz
         re2oSlgW8blhUSlkxHnF/EDnHVL7NCwBKQqDKfb/Z3S8r7+OfDr3HEkPeRS0vFfGme1x
         PC0AlMLyfT4Hw111SvON01FTrlba726tVqIivuOgyVzFYk7DM6KhHzm4xNw4tcIc4otY
         MHgLm2HCEaijyp4xCA32abpC9bcSd0IO8CILWNObZaBC5F4DLp5MvAn0UL5JP+IlN4r8
         b+ZmtuNlt4cjID1z0goXeQqr8nnpK1/AuCx4CJHKIgYp0vFwykiJgkxA6qzHLgumkdkL
         f/Lg==
X-Gm-Message-State: AOAM5328T95ASojhxvZ9c8Evy/etgl1ZvnyUg075n2p/jocXcUYqp40R
        UQ/1hK+4JSgt8SDKK3qfllk=
X-Google-Smtp-Source: ABdhPJzxUBdVRJEVj1S4fOQzcZ+m8USTDEpbO5iqCg9+eCiIDn60j7OLk1HgHpXyU5BsUiGlHP50ag==
X-Received: by 2002:aa7:9ac4:0:b029:3c4:3e72:95fa with SMTP id x4-20020aa79ac40000b02903c43e7295famr17229984pfp.59.1628497342971;
        Mon, 09 Aug 2021 01:22:22 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id s36sm23052687pgk.64.2021.08.09.01.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 01:22:21 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 9 Aug 2021 18:22:17 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH RFC libnetfilter_queue 1/1] src: doc: supply missing
 SYNOPSIS in pktbuff man pages
Message-ID: <YRDluYiIuSpBaDVB@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210629093837.GA23185@salvia>
 <20210717025350.24040-2-duncan_roe@optusnet.com.au>
 <20210722171015.GA12639@salvia>
 <YPuN1cuL1ukqzSFl@slk1.local.net>
 <20210724085633.GA21304@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4ab2CEOiM8Lu/Euk"
Content-Disposition: inline
In-Reply-To: <20210724085633.GA21304@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--4ab2CEOiM8Lu/Euk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 24, 2021 at 10:56:33AM +0200, Pablo Neira Ayuso wrote:
> On Sat, Jul 24, 2021 at 01:49:41PM +1000, Duncan Roe wrote:
> > On Thu, Jul 22, 2021 at 07:10:15PM +0200, Pablo Neira Ayuso wrote:
> > > The existing autogenerated manpages are still a bit distant to usual
> > > Linux Programmer's Manual manpages at quick glance.
> >
> > I guess doxygen-generated man pages will always be a little bit "distinctive".
> >
> > Looking carefully, I see a number of doxygen artefacts that can be
> > post-processed away.
>
> I mean: If you can achieve this via standard features available in
> doxygen to keep this maintainable along time, such as \manonly or
> such, then that's good.
>
> Otherwise, extending doxygen should be the way to keep it simple.
> I understand doxygen might generate a little but "distintive" output,
> that's OK. I'd rather not to add more dependencies on this.
>
> Thanks.

Fine with not adding more dependencies.

Using only standard shell tools, I went ahead with post-processing man pages
because there are no standard features available in doxygen to do what I wanted.

I've attached a sample of what I hope you'll see on applying my 2 new patches
"Insert SYNOPSIS sections for man pages" and "Fix NAME entry in man pages".
The sample was made by doxygen-1.9.1, earlier versions e.g. doxygen-1.8.9.1
generate a few extra blank lines.

To view, save attachment and in another window `man ./pktb_alloc.3.gz`.

Cheers ... Duncan.

--4ab2CEOiM8Lu/Euk
Content-Type: application/x-gunzip
Content-Disposition: attachment; filename="pktb_alloc.3.gz"
Content-Transfer-Encoding: base64

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

--4ab2CEOiM8Lu/Euk--
