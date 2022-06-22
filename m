Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC6DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jun 2022 10:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiFVK1U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jun 2022 06:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiFVK1T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jun 2022 06:27:19 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247263A716
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2022 03:27:18 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id g4so14609420lfv.9
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2022 03:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R0rafC9mv89RkhtOoTSzRelYBkQ0j2FenOE0mXqmnVs=;
        b=SxER0YyuZNFq8ZDBQ3FlYJSweH2Ks9wJ+nrBqwZming71wFldTsji8N/4A/YFX1zaJ
         RlXU8igKgKLpNj6Mft2QbQJfoPg9WiGQi0XE/wEP/ofdEsAJUh3HK8QjT35+qA54pSp2
         ibeUczQy4YaPDdJR8BC8DYDc8CjeRntMWlE/wDwMMx1gmgr6m8HB6uJ+V8yzjZ4pJqSo
         hNZnoCF8Y5Aw5bBVIL7uHfXp7yeCLBY3jR5i4pIorb7f6iXbtabkshSOoV6T+VQ2UQ1W
         ai9QsRNhESawW3wLEskpf5BbZZj85Gle4r8VkBvsavBgT/VXrbX523VSO7i7c8iv2Vdt
         l24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R0rafC9mv89RkhtOoTSzRelYBkQ0j2FenOE0mXqmnVs=;
        b=rIyGBw1W35w7Ajz8ZS67iy/clr71VUesf0InfdAYrhfxFT0uRrtm9jXwEmBBBEv/fT
         MshiBs8UVucmUA76cqk5xrOwv3xMFMjGo7nl5SotTS8aa4ukkDUB/SBsw5pyADq3tKFY
         rWuEPztwkcLNQjdlcfEgmmk1Uu+SM3Mk2pfAsBBOcvgeh1APEdjTllrNlcPGB9SCdc1X
         SwpGx5VjFLRFJclrCA97Ych9kSMcCMxazVBgEghc5405se7wrwI0iaytpIleQ5OQalTT
         5H4RR7xCaCmzelnncle/rnq8D+0RMrkh3QWAXTjkurgCBZKIRRBWwoiqwoR5PDSb5xhL
         6FtQ==
X-Gm-Message-State: AJIora//yV5fcAm+G1gY4cYdGnCwwTCxdqT+SBNMxk3VKFBVA363dP89
        kDJkoAlzFZzptufGwniO1j9E42+Fjl262mE6VF87+w==
X-Google-Smtp-Source: AGRyM1uV4P7Za3VOpKJeS+rP63uF4A3Kp2QUxeyqcGAxBgU6gUy8SMNIo2eP/Dj+qxMaxfWZ9KlYLWOpf22A/POotjM=
X-Received: by 2002:a05:6512:23a7:b0:47f:7030:5f2b with SMTP id
 c39-20020a05651223a700b0047f70305f2bmr1676277lfv.684.1655893636341; Wed, 22
 Jun 2022 03:27:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220621225547.69349-1-mikhail.sennikovskii@ionos.com>
 <20220621225547.69349-2-mikhail.sennikovskii@ionos.com> <YrK/LuvlSQVtED0a@salvia>
In-Reply-To: <YrK/LuvlSQVtED0a@salvia>
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Date:   Wed, 22 Jun 2022 12:27:05 +0200
Message-ID: <CALHVEJa-ugo2FrF2huaJptA_Vh3XWNHm2=sbndieiEZb1HVc8A@mail.gmail.com>
Subject: Re: [PATCH 1/3] conntrack: introduce new -A command
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

I initially decided against it because Introducing a separate CT_ADD
command would
result in lots of actually unnecessary changes in lots of places, e.g.
the optset arrays definitions (passed to generic_opt_check) in
conntrac.c and all extensions would need a new (actually duplicate)
entry for the CT_ADD, e.g. here
https://git.netfilter.org/conntrack-tools/tree/extensions/libct_proto_dccp.c#n67
But if you prefer this approach, I can surely do that. Let me adjust &
submit an updated patch then.

Thanks,
Mikhail

On Wed, 22 Jun 2022 at 09:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Jun 22, 2022 at 12:55:45AM +0200, Mikhail Sennikovsky wrote:
> > The -A command works exactly the same way as -I except that it
> > does not fail if the ct entry already exists.
> > This command is useful for the batched ct loads to not abort if
> > some entries being applied exist.
> >
> > The ct entry dump in the "save" format is now switched to use the
> > -A command as well for the generated output.
>
> For those reading this patch: Mikhail would like to have a way to
> restore a batch of conntrack entries skipping failures in insertions
> (currently, -I sets on NLM_F_CREATE), hence this new -A command.
> The conntrack tool does not have create and add like nftables, it used
> to have -I only. The mapping here is: -I means NLM_F_CREATE and -A
> means no NLM_F_CREATE (report no error on EEXIST).
>
> > Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
> > ---
> >  src/conntrack.c | 34 +++++++++++++++++++++++++++-------
> >  1 file changed, 27 insertions(+), 7 deletions(-)
> >
> > diff --git a/src/conntrack.c b/src/conntrack.c
> > index 500e736..465a4f9 100644
> > --- a/src/conntrack.c
> > +++ b/src/conntrack.c
> > @@ -115,6 +115,7 @@ struct ct_cmd {
> >       unsigned int    cmd;
> >       unsigned int    type;
> >       unsigned int    event_mask;
> > +     unsigned int    cmd_options;
> >       int             options;
> >       int             family;
> >       int             protonum;
> > @@ -215,6 +216,11 @@ enum ct_command {
> >  };
> >  /* If you add a new command, you have to update NUMBER_OF_CMD in conntrack.h */
> >
> > +enum ct_command_options {
> > +     CT_CMD_OPT_IGNORE_ALREADY_DONE_BIT = 0,
> > +     CT_CMD_OPT_IGNORE_ALREADY_DONE     = (1 << CT_CMD_OPT_IGNORE_ALREADY_DONE_BIT),
>
> Could you add CT_ADD command type so we can save this flag?
>
> You will have to update a few more spots in the code but this should
> be fine.
>
> Thanks.
