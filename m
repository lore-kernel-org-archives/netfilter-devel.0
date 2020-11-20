Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EADFC5519F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 13:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99EB622264
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 13:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mo3RuKvE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgKTNTK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 08:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgKTNTK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 08:19:10 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16072C0613CF;
        Fri, 20 Nov 2020 05:19:08 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id y24so3101012otk.3;
        Fri, 20 Nov 2020 05:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TxPJXOKPX6TEaOhaf1CzmpADx+XCWdAGqJGhJLYHnrE=;
        b=Mo3RuKvEWvcHEXrY3Hv5Q4ughhU2edtK1+78rHSQpGhpdGjuSZNiMvmm0CO3OLZ08C
         DTe78IO0oUw9Nb4DW8MUSontVYRzraq5KTJtFVoJ71pz+ZABmHGiTaHJxUH+H9o+OQJ/
         jXm58g6/3YmfV0chn4d3GfGItcbm4xzvU81HiKkp3ngy4LZIgh6+77Cwy72GWLZNkfO3
         s1W3SwGDJn9fH9MWcZVGECPKlcsxrO4K/C2azxQfFYGWReikWt6eAI6O36djqdOTQEl0
         Ei0c5ryJ+Xi56GOyJHQqvDqAxkt9EF8TsdE99k6RX/BKvBhbpNSe9oZxfrLLmrYEb2+y
         LZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TxPJXOKPX6TEaOhaf1CzmpADx+XCWdAGqJGhJLYHnrE=;
        b=CwBNlXy3H0eRYRR7PCMdiwjF2FRND0tmSlyzNLWk0HP06SoVWOa4GxQwc2L6oikU9R
         douIdj5kNfJq6jrUfxNUDOGhFjxjQeqJpOXqn8mviE28jWCuNMsPo8tBUQ3dl/kWKzi6
         kEWhVr2SPf1B8+/iHlIUePvROMlISa1tAMDoUP4BepDclUOfBxTp5tVvQ2JS0hfxsL5N
         uQLiFLQdPZCPCnyG88Mvx0HAeqGdEOFNKBHUzjVcY7VUhf3f9F9u+caqTSVpw75gSaB/
         OCNBlhJz83HCbaELQcfTLjX5yF1N9sMN8EdRqenutCfV5WBAMenPZKdMn8sjRH9oDNXq
         TZvg==
X-Gm-Message-State: AOAM53289LDw7Yx3hrQlH5v7u6QezVij71G9r53otBIViX4vXBDTIkLG
        Dm3Os9F8pY0Zedv18Fqkb59yGlFcWnFTLdK7jnq9qEHa
X-Google-Smtp-Source: ABdhPJx1vkhxH66Wuj/mDqSDSG9qlKxTKhxLBTN+Si/Lm5SP2Ocv7K4+GCJzQ/P9wPxQHXRTWx4MwXNnFS6DSw/vEEE=
X-Received: by 2002:a9d:30c3:: with SMTP id r3mr927532otg.115.1605878347383;
 Fri, 20 Nov 2020 05:19:07 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.23.453.2011192141150.19567@blackhole.kfki.hu>
 <45rqn0n5-5385-o997-rn9q-os784nqrn9p@vanv.qr> <alpine.DEB.2.23.453.2011192237290.19567@blackhole.kfki.hu>
 <83oq5412-o0sq-5q31-s7o5-s0q28s12844@vanv.qr> <CAMQP0skDvG-vOAGmcx2kn21KYS9UgMfxND7NTi_X75GOnx_izw@mail.gmail.com>
 <alpine.DEB.2.23.453.2011200904550.19567@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.23.453.2011200904550.19567@blackhole.kfki.hu>
From:   Neutron Soutmun <neo.neutron@gmail.com>
Date:   Fri, 20 Nov 2020 20:18:55 +0700
Message-ID: <CAMQP0sn9NuE=Kg-Qf3FWkoSM-7hTtcj9whDbxn29NcrmnT7F4w@mail.gmail.com>
Subject: Re: [ANNOUNCE] ipset 7.8 released
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Nov 20, 2020 at 3:07 PM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>
> Hi,
>
> On Fri, 20 Nov 2020, Neutron Soutmun wrote:
>
> > For the ipset 7.9, I found the released download url is
> > http://ipset.netfilter.org/ipset-7.9.tar.bz2, however, it's previous
> > releases are in http://ftp.netfilter.org/pub/ipset/
> >
> > The Debian has the tool to detect the new release with package watch [1]
> > file. Could you please consider uploading the new release to the
> > fpt.netfiler.org/pub/ipset also.
>
> It has been fixed. Please note, I switched from md5 to sha512 at
> generating the checksum file, so the filename is changed accordingly to
> <packagename>.sha512sum.txt.

Noted and thanks a lot.

Best regards,
Neutron Soutmun
