Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3202CC433E6
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Feb 2021 16:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E44B064EC0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Feb 2021 16:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhBKQcs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 11:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhBKQaa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 11:30:30 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27099C061756
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2021 08:29:47 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id i8so10957139ejc.7
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2021 08:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ABj8h6JxoKzCkEFlLOPlFl55Hb6x4ubH36UnScGj9KU=;
        b=BNxr53Eh4Rd+L3Iw+fOTZ3NITnYeHKeJ8+3HLB+AB44V4L2zuKgso8bfqhIZT85PdG
         MadFFUeEB8p8acfVuuXebGL5/coigQDu+Kkx9UYe62gOanXH4mBtMZG4A/EAZ7Dyr/6s
         KVRhrf9gIWH1e+4bBOu/eJkfQExosu4Xf7VL02HVcfadCSvcZGikKnqJhnp8bXf67oT1
         +WkfOdhxc4ETMZs3Vgj+UIOMy8beZbbLvmViZBtOybjqxmPjhgU4hfHpL/ffyD1I9rkL
         yPqFnvkvqgJ4/bA6t+VSk0TaR7Mw6MV3oPTy16RPjBs2EjJaNHHJa+slCef/Ijb9pW98
         qYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ABj8h6JxoKzCkEFlLOPlFl55Hb6x4ubH36UnScGj9KU=;
        b=RIXjpF0XKtrkyfKPfEqyZrELSrEPDwoxLZzxk4++BucVxHXUZPjBlvXHwfUF/myp9L
         pst4wSJcYEeeZJEmpsvZL6fdi+DjoXIoTpXPQWWrW8aL1/wMz+UNimkJOUZYV1fNeHN7
         bOAVwfseWFLEnB/2QapzSzhSO0FLw+Df8MHdxyFT7xI10h2AdIiTw9L7qmYezqF34IJU
         kObaONE5ne1b+0Eix82kYSfMgIUbgXXKyZCnMot+TXpOy50UFER+aq+VzUhn6I2CPbti
         OI45kd6LH9QHAhYlRPuYLK4YTToOHDX63bv46Pk0FQqJbMfsSrY0+asUsQiVerMnaUyO
         KjXw==
X-Gm-Message-State: AOAM5330lQqz4eKTDWlm2IAqN0ekNCHI2A8Uch7gSEdLKUFBedn2XcxP
        8boziqdsRodHxaPXfPj3DrBezuTawK064kprRq9k
X-Google-Smtp-Source: ABdhPJweNZP4TzMhtMYaYgcn1PzXigwCB0MySFfbTC8o7Eq1L6ARWGPA1NXZPn9sU34dwjLDUP8/GMbabKeHGrzw3ck=
X-Received: by 2002:a17:906:35d9:: with SMTP id p25mr9185445ejb.398.1613060985419;
 Thu, 11 Feb 2021 08:29:45 -0800 (PST)
MIME-Version: 1.0
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20210211151606.GX3158@orbyte.nwl.cc>
In-Reply-To: <20210211151606.GX3158@orbyte.nwl.cc>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 11 Feb 2021 11:29:34 -0500
Message-ID: <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change events
To:     Phil Sutter <phil@nwl.cc>, Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, Ondrej Mosnacek <omosnace@redhat.com>,
        fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 11, 2021 at 10:16 AM Phil Sutter <phil@nwl.cc> wrote:
> Hi,
>
> On Thu, Jun 04, 2020 at 09:20:49AM -0400, Richard Guy Briggs wrote:
> > iptables, ip6tables, arptables and ebtables table registration,
> > replacement and unregistration configuration events are logged for the
> > native (legacy) iptables setsockopt api, but not for the
> > nftables netlink api which is used by the nft-variant of iptables in
> > addition to nftables itself.
> >
> > Add calls to log the configuration actions in the nftables netlink api.
>
> As discussed offline already, these audit notifications are pretty hefty
> performance-wise. In an internal report, 300% restore time of a ruleset
> containing 70k set elements is measured.

If you're going to reference offline/off-list discussions in a post to
a public list, perhaps the original discussion shouldn't have been
off-list ;)  If you don't involve us in the discussion, we have to
waste a lot of time getting caught up.

> If I'm not mistaken, iptables emits a single audit log per table, ipset
> doesn't support audit at all. So I wonder how much audit logging is
> required at all (for certification or whatever reason). How much
> granularity is desired?

That's a question for the people who track these certification
requirements, which is thankfully not me at the moment.  Unless
somebody else wants to speak up, Steve Grubb is probably the only
person who tracks that sort of stuff and comments here.

I believe the netfilter auditing was mostly a nice-to-have bit of
functionality to help add to the completeness of the audit logs, but I
could very easily be mistaken.  Richard put together those patches, he
can probably provide the background/motivation for the effort.

> I personally would notify once per transaction. This is easy and quick.
> Once per table or chain should be acceptable, as well. At the very
> least, we should not have to notify once per each element. This is the
> last resort of fast ruleset adjustments. If we lose it, people are
> better off with ipset IMHO.
>
> Unlike nft monitor, auditd is not designed to be disabled "at will". So
> turning it off for performance-critical workloads is no option.

Patches are always welcome, but it might be wise to get to the bottom
of the certification requirements first.

-- 
paul moore
www.paul-moore.com
