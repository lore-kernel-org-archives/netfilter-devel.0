Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64777C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jul 2022 06:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiGZGzd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 02:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiGZGzb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 02:55:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EACBB1116E
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jul 2022 23:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658818528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DxMnO8HPvIoD0RCMMAKdeIqoI+W+svLUawAv8Ra/Q9Y=;
        b=L8eIJ0TQX9fPiPrsNyl5GjFbPqYu90puNpjEZgiNyiZ4iL9cspGQI/1j1Ua6gud0VYeOMb
        9Sqss2SqtXfLZTc46QX8/KciYPue9seusN/c0/+Bpo+it/KMcAzQGMQPx89xEsEwInNUxC
        tVJmfVRh99u/XglmjgPuvMFMb3p50RQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-NncvSnWtNiqWsFmsMuaWxA-1; Tue, 26 Jul 2022 02:55:27 -0400
X-MC-Unique: NncvSnWtNiqWsFmsMuaWxA-1
Received: by mail-ej1-f71.google.com with SMTP id ji2-20020a170907980200b0072b5b6d60c2so3923784ejc.22
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jul 2022 23:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DxMnO8HPvIoD0RCMMAKdeIqoI+W+svLUawAv8Ra/Q9Y=;
        b=YdKuuNzwO+l5KAqZ2dcbyk8cczQtRFA25wG2Hxc6KbO/AgxJuASL4lQfc0RvblEGsE
         fECU+7HjL6GuoBvoV0SqPgGA4OPKS/LdmuVqrlwhXQPtCizItTCa/48uxOLMjsfo611G
         7ip3tIitovym35OW27gsmmkt9adR8mmPKCAhyKVtETeev3gaFH975RLu9IeB5QHDur3w
         mkW7CNN48eVG7ZCmszrBcrcb/c79lvq8g/SO7woYkP+AKcXK7XWn/CfwyJkKHVJUwZJ9
         saH17U5YjhMHtQbcAM5+8/cFUzx+Mun/4L5qie/CHUQZXXICzhGtdxhCaxRlWxcLtkVD
         Yb1g==
X-Gm-Message-State: AJIora/MibcFUQGYdOkSqPw/4BcGBZx1/P1c19rf4MN8SvFLJ/harc7S
        wsjDvaSK6+VBVGJfEvFd7nNhuE7w2F8zFAVVhcOTflUk6iDv0VQmAGAUlE5kPmeaTHatYUUtCsV
        j2Jhq/CAsXBI+fblZB5KYIvUO/Bwa
X-Received: by 2002:a05:6402:40c3:b0:43b:d65a:cbf7 with SMTP id z3-20020a05640240c300b0043bd65acbf7mr17068728edb.380.1658818525979;
        Mon, 25 Jul 2022 23:55:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tR9edohf6x8yPVHVkqajDAf5gyJV2/4R69dSbB0bufe7hc35lVv6om1nXPelEiLqV+uNBm8A==
X-Received: by 2002:a05:6402:40c3:b0:43b:d65a:cbf7 with SMTP id z3-20020a05640240c300b0043bd65acbf7mr17068709edb.380.1658818525681;
        Mon, 25 Jul 2022 23:55:25 -0700 (PDT)
Received: from nautilus.home.lan (cst2-15-35.cust.vodafone.cz. [31.30.15.35])
        by smtp.gmail.com with ESMTPSA id a17-20020a50ff11000000b00435a62d35b5sm8091268edu.45.2022.07.25.23.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:55:25 -0700 (PDT)
Date:   Tue, 26 Jul 2022 08:55:23 +0200
From:   Erik Skultety <eskultet@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables: xshared: Ouptut '--' in the opt field
 in ipv6's fake mode
Message-ID: <Yt+P25lN4AmDuCie@nautilus.home.lan>
References: <bb391c763171f0c5511f73e383e1b2e6a53e2014.1658322396.git.eskultet@redhat.com>
 <20220725213914.GC20457@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220725213914.GC20457@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 25, 2022 at 11:39:14PM +0200, Florian Westphal wrote:
> Erik Skultety <eskultet@redhat.com> wrote:
> > The fact that the 'opt' table field reports spaces instead of '--' for
> > IPv6 as it would have been the case with IPv4 has a bit of an
> > unfortunate side effect that it completely confuses the 'jc' JSON
> > formatter tool (which has an iptables formatter module).
> > Consider:
> >     # ip6tables -L test
> >     Chain test (0 references)
> >     target     prot opt source   destination
> >     ACCEPT     all      a:b:c::  anywhere    MAC01:02:03:04:05:06
> > 
> > Then:
> >     # ip6tables -L test | jc --iptables
> >     [{"chain":"test",
> >       "rules":[
> >           {"target":"ACCEPT",
> >            "prot":"all",
> >            "opt":"a:b:c::",
> >            "source":"anywhere",
> >            "destination":"MAC01:02:03:04:05:06"
> >           }]
> >     }]
> > 
> > which as you can see is wrong simply because whitespaces are considered
> > as a column delimiter.
> 
> Applied.  I amended the commit message to include a Link to this thread
> on lore.kernel.org so in case something else breaks because of this
> change.
> 

Thanks!
However, given Phil's findings in his reply to the patch I think my patch is an
incomplete fix without his suggested/proposed follow-ups, so hopefully those
could land upstream as well.

Regards,
Erik

