Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A17C33CAC
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 10:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93CC920658
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 10:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rm/mEwUN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgBCKvg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 05:51:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:47045 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgBCKvg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 05:51:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so17286302wrl.13
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Feb 2020 02:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kPNuAsKYVnibbEFXcVdl2Ju0LzpNbD3qE4NuDnszPu8=;
        b=rm/mEwUNee+cRjJHyqGj5ymRWIEXbiYsprNSh2jF6CAYz2zkk79SgBFZ3eePU9afdX
         hNMU53M4DUlv627RFyGLS0aJHIaYTZYNkUPeuTE9ky5fmXlDJS+YUXvRg5TVsgZFwGwd
         Fm7ZvF2MRd39j3DUbZJoWqx88Z0QiByVs3I/5ZU7CfzOVGWEBYcdj80+YwknOfZM5DO7
         6a6ErswVHVhfhrowcZAtr/8gY+QRst0/oCpkBXU+WvpH5Fh23mGmNsudtovhbc19M3AG
         HnWjfC8LG/vJ4n1i6S89vFu0ZNcV/WwJLGqDFajXfvtbKRXgveQoJ8Uhv6CfEuf5AhI9
         coPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kPNuAsKYVnibbEFXcVdl2Ju0LzpNbD3qE4NuDnszPu8=;
        b=WT1elXz0rCSWH/6Guv6FSJa4hfc4Rd9hexL6sn6VZMMn7aMW0vTO2CO2wh6lLZj808
         6YM+GR1MDjae5A9dX+YXwJTKAzGd5daaxcDvFI9Xc5tOAUwhSeelMvtuCdekxkdvrtEQ
         mIlhbECNKCjJA4hUn8Ju5GVnHBVfH/FrJQ+7adHbfaXA+MKC/+1oYJP3pXH3Sfthyjt9
         KZZGAvj+B0dZALodppUddN4H3OWVCuG38nuRjf/GEhhw6TmpTzbnMtWFJVEZNtOyI/jS
         0JY3DFeSOjSCjWoKxWgrvKqOQ2epl6UPkisegLIO3/NIzlaiFinR0t8oPcNMg0bTSw/X
         6E+w==
X-Gm-Message-State: APjAAAUwzNaPqCdx2ODIL5z9Q9tstrgPoqIQ26Y+bv5XFVYyHzAsiXca
        TpQcnJOEKWVlrZuBiElnnCkGYKDYNsnRGgWvv28=
X-Google-Smtp-Source: APXvYqwAdqES5Qxv7KdApzR5nNby5Jgq0YWONeKE3XVtoTPmMoQVBEth8GMjkwXHMaRU+5oMk1WsRDAlzua4EGJY5TA=
X-Received: by 2002:a5d:6388:: with SMTP id p8mr14534557wru.299.1580727094249;
 Mon, 03 Feb 2020 02:51:34 -0800 (PST)
MIME-Version: 1.0
References: <1579740455-17249-1-git-send-email-stranche@codeaurora.org> <20200123102921.GU795@breakpoint.cc>
In-Reply-To: <20200123102921.GU795@breakpoint.cc>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 3 Feb 2020 18:51:37 +0800
Message-ID: <CADvbK_cxE=G9+X5o=rnATjgKnqp-8rzW_vUr-=kKoD3S=Fa2bg@mail.gmail.com>
Subject: Re: [PATCH nf] Revert "netfilter: unlock xt_table earlier in __do_replace"
To:     Florian Westphal <fw@strlen.de>
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 23, 2020 at 6:29 PM Florian Westphal <fw@strlen.de> wrote:
>
> Sean Tranchetti <stranche@codeaurora.org> wrote:
>
> [ CC Xin Long ]
>
> > A recently reported crash in the x_tables framework seems to stem from
> > a potential race condition between adding rules to a table and having a
> > packet traversing the table at the same time.
> >
> > In the crash, the jumpstack being used by the table traversal was freed
> > by the table replace code. After performing some bisection, it seems that
> > commit f31e5f1a891f ("netfilter: unlock xt_table earlier in __do_replace")
> > exposed this race condition by unlocking the table before the
> > get_old_counters() routine was called to perform the synchronization.
>
> But the packet path doesn't grab the table mutex.
>
> > Call Stack:
> >       Unable to handle kernel paging request at virtual address
> >       006b6b6b6b6b6bc5
> >
> >       pc : ipt_do_table+0x3b8/0x660
> >       lr : ipt_do_table+0x31c/0x660
> >       Call trace:
> >       ipt_do_table+0x3b8/0x660
> >       iptable_mangle_hook+0x58/0xf8
> >       nf_hook_slow+0x48/0xd8
> >       __ip_local_out+0xf4/0x138
> >       __ip_queue_xmit+0x348/0x3a0
> >       ip_queue_xmit+0x10/0x18
I don't see how this happens either.

Hi Sean,
do you have a script to reproduce this issue?

Thanks.
> >
> > Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> > ---
> > @@ -921,8 +921,6 @@ static int __do_replace(struct net *net, const char *name,
> >           (newinfo->number <= oldinfo->initial_entries))
> >               module_put(t->me);
> >
> > -     xt_table_unlock(t);
> > -
> >       get_old_counters(oldinfo, counters);
> >
> >       /* Decrease module usage counts and free resource */
> > @@ -937,6 +935,7 @@ static int __do_replace(struct net *net, const char *name,
> >               net_warn_ratelimited("arptables: counters copy to user failed while replacing table\n");
> >       }
> >       vfree(counters);
> > +     xt_table_unlock(t);
>
> I don't see how this changes anything wrt. packet path.
> This disallows another instance of iptables(-restore) to come in
> before the counters have been copied/freed and the destructors have run.
>
> But as those have nothing to do with the jumpstack I don't see how this
> helps.
