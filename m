Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6368C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jul 2022 16:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiGTQ4H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiGTQ4H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 12:56:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88E3EB7EA
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 09:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658336165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hla5IpBEMidnOWxCMbH7FRcVFiqGGKKfVxRFHiGVwzA=;
        b=HTxrqiCEmmylvRxNZe2bi72SUYW8XTRX0HSbANJdjwgFTRiv8DNorrGroa7p8Z1JI2vEyM
        XtgqmsLVypWmUoKcQ+iXTbhHXzJ+Tl6To0dU1OXe6S5rqsI/RpJSTZmUYuV2hpXHF2yfJU
        UKiiOmkNtH0+0sfIPeNOES62/HkYetY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-38WEuXGSOWm6sBXHixBCfg-1; Wed, 20 Jul 2022 12:56:04 -0400
X-MC-Unique: 38WEuXGSOWm6sBXHixBCfg-1
Received: by mail-ed1-f72.google.com with SMTP id f13-20020a0564021e8d00b00437a2acb543so12352344edf.7
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 09:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hla5IpBEMidnOWxCMbH7FRcVFiqGGKKfVxRFHiGVwzA=;
        b=R63KZPU16EqkeIJiIV+Ash8o5D2m/dbOUlURJiotui8CHNhhrKJ9m1WxCFLWclURRa
         QoxsSXZV732pBxEtciQRwIRE6xtOLmbiMXqvZTE/gL14Yzd7elEQSYboL0+o+AY9ZQKU
         JdxQ+BUe5Yc/6QUTsXwUuMKNExBsvuCj27bQKbXQzJmvlBd4q0sHYecrl82hVl71qYDG
         HpQWu1TpGml3ALYSLJCQxKKUtXqh/HW45xoAYCSAAkaxotGpkV2+hRn/1IrDkD2fjPuU
         POReEzVdxN2MDeylvmeYuDjx0OUe+KpKQFHbIqpaiu3J6BZR3tofHmarp5oV1TpX60jf
         ZYVw==
X-Gm-Message-State: AJIora8m89QLjhqolHHlOwfYaYjmlBOR/0hpdZTnBY1/6cHo+5Jl2CQ7
        OuQtW7IsRS1jI37Y1G2Rav/CRNj4BlKwkGmGXtcvVyctFnnPEcUi3PEba3dizdNET22UeEZCEdr
        0Re9ton0tYB+yDUyFBkTkfI2XlIKX
X-Received: by 2002:a17:907:a049:b0:72b:1432:5c4 with SMTP id gz9-20020a170907a04900b0072b143205c4mr36467816ejc.263.1658336162912;
        Wed, 20 Jul 2022 09:56:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uQ1bcETmY+cyO2lOnOyOnedkZHl7eS7vZm/Jvw4+OqM7/ncWbNx3V+YeHfUCR8IZ34MPREEg==
X-Received: by 2002:a17:907:a049:b0:72b:1432:5c4 with SMTP id gz9-20020a170907a04900b0072b143205c4mr36467799ejc.263.1658336162696;
        Wed, 20 Jul 2022 09:56:02 -0700 (PDT)
Received: from nautilus.home.lan (cst2-15-35.cust.vodafone.cz. [31.30.15.35])
        by smtp.gmail.com with ESMTPSA id q9-20020aa7d449000000b0043ba45cec41sm2399679edr.36.2022.07.20.09.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 09:56:02 -0700 (PDT)
Date:   Wed, 20 Jul 2022 18:56:00 +0200
From:   Erik Skultety <eskultet@redhat.com>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables: xshared: Ouptut '--' in the opt field
 in ipv6's fake mode
Message-ID: <YtgzoIJngb5edrmu@nautilus.home.lan>
References: <bb391c763171f0c5511f73e383e1b2e6a53e2014.1658322396.git.eskultet@redhat.com>
 <784718-9pp7-o170-or1q-rnns2802nqs@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <784718-9pp7-o170-or1q-rnns2802nqs@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 20, 2022 at 06:07:34PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2022-07-20 15:06, Erik Skultety wrote:
> 
> >The fact that the 'opt' table field reports spaces instead of '--' for
> >IPv6 as it would have been the case with IPv4 has a bit of an
> >unfortunate side effect that it completely confuses the 'jc' JSON
> >formatter tool (which has an iptables formatter module).
> >Consider:
> >    # ip6tables -L test
> >    Chain test (0 references)
> >    target     prot opt source   destination
> >    ACCEPT     all      a:b:c::  anywhere    MAC01:02:03:04:05:06
> >
> >Then:
> >    # ip6tables -L test | jc --iptables
> >    [{"chain":"test",
> >      "rules":[
> >          {"target":"ACCEPT",
> >           "prot":"all",
> >           "opt":"a:b:c::",
> >           "source":"anywhere",
> >           "destination":"MAC01:02:03:04:05:06"
> >          }]
> >    }]
> >
> >which as you can see is wrong simply because whitespaces are considered
> >as a column delimiter.
> 
> Even if you beautify the opt column with a dash, you still have
> problems elsewhere. "MAC01" for example is not the destination
> at all.

That's incorrect - this is what it would look like after this patch:

[{"chain":"test",
  "rules":[
      {"target":"ACCEPT",
       "prot":"all",
       "opt":   ,
       "source": "a:b:c::",
       "destination":"anywhere",
       "options":"MAC01:02:03:04:05:06"
      }]
}]

which actually makes more sense.

I may have not been completely clear about it. With the column "beautifying" we
could keep the current shape of tests, i.e. not trying to use 'jc' to get a JSON
output and instead it would give me time to try address the nature of the checks
in the test suite with nft's native JSON formatter instead which is IMO a more
future-proof design of these old tests.

> 
> If you or jc is to parse anything, it must only be done with the
> iptables -S output form.
> 

Well, that would be a problem because 'jc' iptables plugin doesn't understand
the -S output (isn't -S considered deprecated or I'm just halucinating?).

Erik

