Return-Path: <SRS0=LRg4=7B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB09C433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 19:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C2D320872
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 19:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="nmcZhgVF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgEST75 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 May 2020 15:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgEST7T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 May 2020 15:59:19 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C08CC08C5C1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2020 12:59:19 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i16so594095edv.1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2020 12:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMIDPgMbHVu3g+tSpT5bxTKgYe2ruTghD+dp0Ce+ezo=;
        b=nmcZhgVFvrUq5JC4qwIm8okfkbdw8iu9il46IC3Uss+sgO/7sPyUdIXQq0O6RdQwbf
         +WFR18HzTXkFZc3QGFtOFX6HIzFwjCuBKJI/87fymJWXtPspMiErj+JeVTHEn7xa6YgL
         9TYytifZ01xCLzif+9nLDKfFsDXKuT6ACCqCwliqKPfwV7aJ0mbeetUVkU82jhgr/C5B
         DCId9cp2tszqdN1laadHjUG7Na7SZdxwVzW0/ByeC53UigedJ99ch+cwSb39KnXTyJ+o
         3uo/9GDYTmqnZqY1c0M+X60t1tywbXPoN+CbPGmvXBSRBkKeQSkI0pWJOF/OWRt+evlQ
         iRSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMIDPgMbHVu3g+tSpT5bxTKgYe2ruTghD+dp0Ce+ezo=;
        b=J6n77yhUs4SU4CMCks1+KzQ+Hgr90mam5qUJEWDJe9lXX4r25OtNtelsmVJA52OwsU
         YlmJ1eDTEWvD3i3GeGI/IDA6usRYyxsRWJjIrNZpQ6cSQZMnOQq7T+E+IXYycgG7Dsy0
         oDzmWwOVhMQReIVImMlZLfyT9zJDBh8PgGS8gk8NuNi/TjRx8XJqFHrFZwGNif4H+G9F
         YCO1jHO8lUdp7XBIXe01AiLI1RnrYCiDBCZh+9wCtPvjqZjFYyxhpxIAGaxVoiEjH3GE
         2ShhsVk8WBp7uRAFkxfW2STR3SDevp2EAcIFpDuF7X3fshueFKnQqgQKoLszw9gcmrG9
         imXQ==
X-Gm-Message-State: AOAM531kyGoXyPQjFDfvcBSLTnAb2wKZ1zmd45VnfQX3ho6z8FstE+g5
        DW1uDEIO/L+YhViua4sz4uGYYlXI7/1w5u5yhkMI
X-Google-Smtp-Source: ABdhPJz65RXV/YZirbNciXMjDODPfXWd7iH/a+VM6sKDALr2hlZkHrs+ze8+PoO2Ue4Kga0UI8IYhfgPg7XEruoS49s=
X-Received: by 2002:a05:6402:14d3:: with SMTP id f19mr444826edx.135.1589918358022;
 Tue, 19 May 2020 12:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <2794b22c0b88637a4270b346e52aeb8db7f59457.1589853445.git.rgb@redhat.com>
 <CAHC9VhQYUooJbZ9tcOOwb=48LTjtnfo0g11vQuyLzoxdetaxnw@mail.gmail.com> <20200519194457.nouzteqv2vpcqnta@madcap2.tricolour.ca>
In-Reply-To: <20200519194457.nouzteqv2vpcqnta@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 19 May 2020 15:59:05 -0400
Message-ID: <CAHC9VhQRSwTURYZ2dL_YWqi-xnPfFGN_Aef73mip=eYNVfObRw@mail.gmail.com>
Subject: Re: [PATCH ghak25 v5] audit: add subj creds to NETFILTER_CFG record
 to cover async unregister
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 19, 2020 at 3:45 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-05-19 15:18, Paul Moore wrote:
> > On Tue, May 19, 2020 at 11:31 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Some table unregister actions seem to be initiated by the kernel to
> > > garbage collect unused tables that are not initiated by any userspace
> > > actions.  It was found to be necessary to add the subject credentials to
> > > cover this case to reveal the source of these actions.  A sample record:
> > >
> > > The tty, ses and exe fields have not been included since they are in the
> > > SYSCALL record and contain nothing useful in the non-user context.
> > >
> > >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 uid=root auid=unset subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2
> >
> > Based on where things were left in the discussion on the previous
> > draft, I think it would be good if you could explain a bit why the uid
> > and auid fields are useful here.
>
> They aren't really useful here.  I was hoping to remove them given your
> reasoning, but I was having trouble guessing what you wanted even after
> asking for clarity.  Can you clarify what you would prefer to see in
> this patch?

/me heavily rolls eyes

In my last email to you I said:

"I think it is pointless to record the subject info in this record as we
either have that info from other records in the event or there is no
valid subject info to record."

... I also said:

"As I've mentioned in the thread above, including the auid was done as
a concession to Steve, I don't think it serves any useful purpose."

If phrases like "pointless to record the subject info" and "I don't
think it serves any useful purpose" leave you unsure about what to do,
I'm at a bit of a loss.

Drop the "uid" field.  Drop the "auid" field.  Hopefully those last
two statements should remove any ambiguity from your mind.

-- 
paul moore
www.paul-moore.com
