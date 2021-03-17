Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B59C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 18:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6EF664F4F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 18:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhCQSbl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 14:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbhCQSba (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 14:31:30 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A545C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 11:31:30 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id m17so408482lfg.0
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 11:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KjEcZnjGq3WK9S7AxwSS+2XKdEBQbKSzwoo6UAai7ZQ=;
        b=XWGyapUMyf8xuRoLZdCv7g0Xxno1AFYHQHJMQclT5vFKkpNspgh3pkxKeoSRI0uL83
         xOGAMmnHtJpOZSmoQU0otb5ED5Al0uqVUVnEAKVjPWAj0WnSvY9kc0s8ohs001yq3Fmd
         cLqmasryicVqDrpbNTyNailM8LJOo5zvUiG7k3ZMMIhALMoQwcYGRKzugmGizh3fQhOA
         m++ejE++rHqvuOPRmOcRwh8lQzBLWXGEFiFuFhe9CqCEEzVI9cDO+5uIOFoXKOFcwJEm
         mIMka5Rp2R+574lnzrT2bJdpBxsJm8x3tXyP3Rf9dcjx1dWCd09yAHiDzz+HZiqZkdBD
         dcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KjEcZnjGq3WK9S7AxwSS+2XKdEBQbKSzwoo6UAai7ZQ=;
        b=bKaGedEziEvTiDDzyCl9b/hpv8xDgqPVTVyOV54VZO8nQCr0Hy8LdkI62bUAegrFDE
         yTPARGCksHybEorosKdCCmWkSAOPfiHTmOoJjY9W/+SHjjkHA2Ima2pP/MWcsLcPyYXk
         kGyyvQ48HFda/eXUk/4bnUivgiKGPxLiCgRN0rTSSNt3mjZWPeY3Ecrzp+YFj6/AZOPk
         7JLzSNULuYjS0TFAVjLouHPPMiOcGBLBNOGcu+D9hYu1XRpnOfKNV0RIb34KpbvAEsz4
         yFgLSE8NMixcpUL0fBYDoK7bdddin0Tx4jRVWK5Tv4eRd+3mDgvwQrNG4XipayteJqmi
         mkbQ==
X-Gm-Message-State: AOAM530Muusv92QW8KKP+sTuZ9jg/XXenayaBwBmy2Ab5901R6AR12EN
        GuK+sqMdWDRPL5vc/Y7OIWXuB/nhs73mUjRDmzZeCw==
X-Google-Smtp-Source: ABdhPJzi1IXzxWp/33ZkdgIjnZrVQo7Un0mH4vCHFQfGm39jd2smO1cLZ2OGdEU5UqVARAh1zMSxgGZGEn1Yzp1Iaho=
X-Received: by 2002:ac2:5d52:: with SMTP id w18mr2945701lfd.28.1616005888964;
 Wed, 17 Mar 2021 11:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
 <20210129212452.45352-2-mikhail.sennikovskii@cloud.ionos.com> <20210315171819.GA25083@salvia>
In-Reply-To: <20210315171819.GA25083@salvia>
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Date:   Wed, 17 Mar 2021 19:31:18 +0100
Message-ID: <CALHVEJbqbPLMUJN5H6Q-8sUFxTWtmCN+qWNCBETPEjBhtZc_Jw@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] conntrack: reset optind in do_parse
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Sure, so taking into account your comments to 3/8 and 4/8 I collapse
1-5/8 in a single commit, correct?

Regards,
Mikhail

On Mon, 15 Mar 2021 at 18:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Fri, Jan 29, 2021 at 10:24:45PM +0100, Mikhail Sennikovsky wrote:
> > As a multicommand support preparation reset optind
> > for the case do_parse is called multiple times
>
> Patch looks good, I'd suggest to collapse it to 4/8 and 5/8 in the
> next round.
>
> Thanks.
