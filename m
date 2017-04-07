From: Gargi Sharma <gs051095@gmail.com>
Subject: Re: [RFC v2] extensions: libxt_TOS: Add translation to nft
Date: Sat, 8 Apr 2017 00:30:10 +0530
Message-ID: <CAOCi2DE2spwYibzDYMFPCDm3T+mzye+aOUq7pJ+y2sRX5HzguQ@mail.gmail.com>
References: <1490727018-25703-1-git-send-email-gs051095@gmail.com> <20170406224926.GA2623@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: gsoc2013@lists.netfilter.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:35561 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933633AbdDGTAm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 15:00:42 -0400
Received: by mail-it0-f44.google.com with SMTP id y18so124832131itc.0
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Apr 2017 12:00:41 -0700 (PDT)
In-Reply-To: <20170406224926.GA2623@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 7, 2017 at 4:19 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Mar 29, 2017 at 12:20:18AM +0530, Gargi Sharma wrote:
> > diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
> > index cef5876..f284d83 100644
> > --- a/extensions/libxt_TOS.c
> > +++ b/extensions/libxt_TOS.c
> > @@ -183,6 +183,30 @@ static void tos_tg_save(const void *ip, const struct xt_entry_target *target)
> [...]
> > +     xt_xlate_add(xl, "ip dscp set 0x%02x", dscp);
> [...]
> > +     xt_xlate_add(xl, " ip6 dscp set 0x%02x", dscp);
>                           ^
> And there's a space here. You have to be more careful.
>
> Thanks!

Point noted. Will be more careful in future. :)

Thanks,
Gargi
