Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A04C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Apr 2022 18:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiDBSwZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Apr 2022 14:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiDBSwY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Apr 2022 14:52:24 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A2510FD5
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Apr 2022 11:50:31 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id o5so10669129ybe.2
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Apr 2022 11:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QotQkMwWfdEQeRInixh8iQQ2atN713qv0W3CcYZ6Nu0=;
        b=RmhNWzU9OnUoVHz9k5dobEa2umBYUeg4Npk3HccE8NPMBCXRqo929C5y2Nm8mIpM8t
         G62ByfAbWPEUP4i9uExEhheLnLKXQ/hg/nCEMdHmIG4ZuskQNsLsLlFzggKbRfKcdDt4
         ylxmx4mr5nG+tjzFn+hCI8BkCuVMo178CT+jlrw/1GMJY/7R4YgxBup1cOg/yfFwKk34
         k4ovGEn+UQjqmUK5djUXXInQe2HE78pbsqAWM2wBOeIneYPSkr4GuteNtg3c3MjxYJL5
         zRP98XkwTbgQsebTjfXXqflg922xe1bCFeRboB9NuWfpbQpjPEX1pApj17Kkx/UAovro
         8x9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QotQkMwWfdEQeRInixh8iQQ2atN713qv0W3CcYZ6Nu0=;
        b=zKUPSLRExWAsI5zUthrWSRhZ9lzXz1UaHWGbarnTaoYZP4qv8bbNKDa3PcYZoCFWQ4
         +GtX3fiKjUn72oQHW5oE40PP26Qgd9582XY5FJKzlXkUbqldSR6fOUIZgOv7lsPtdfHl
         AN9pKscA9R0p6JK25v9cjuYQ0hPYef4un5xylvx8rrDKLnOBWXZk1wRp567BcP9Pcmpr
         wMINQO4PT/u2ilfgZb6qSu5jQ2fgUYtjoc1ezPl4bWV/zi+ECCYwl0wEf0ymfT80Cqi1
         ld/zAAfm7DElE8OkVKHzzmsr/vMTYE8T4vEVJdAMugq6cCV6DrVv/HyoR1wn8xhFrBhR
         aPFw==
X-Gm-Message-State: AOAM531R/9whOzSbQyhxwpgkbfqPvvKiiaoF1o57I5/H/bgoZ2VR7QnB
        vpyD5mx2wgcTJfrOgTrbUIVWMtI5OKIncqpUfLL59g==
X-Google-Smtp-Source: ABdhPJwSKsE4ev59F1LU4R7VA3CPiGMEQycZOnf7FjBpjikHh0wqIsJaPDo/trdRveI6frRF2lsL/b28h6zyLJ6LbFQ=
X-Received: by 2002:a25:f441:0:b0:611:4f60:aab1 with SMTP id
 p1-20020a25f441000000b006114f60aab1mr14263408ybe.598.1648925430131; Sat, 02
 Apr 2022 11:50:30 -0700 (PDT)
MIME-Version: 1.0
References: <de70cc55-6c11-d772-8b08-e8994fd934a0@openvz.org>
 <80f0f13f-d671-20fb-ffe6-5903f653c9ed@gmail.com> <f0d8b097-a5bf-0093-650d-56f05ae7e65e@linux.dev>
In-Reply-To: <f0d8b097-a5bf-0093-650d-56f05ae7e65e@linux.dev>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 2 Apr 2022 11:50:19 -0700
Message-ID: <CANn89iKy_2bQJw7_iyTTVA0yMvzkHkUp4DtriieNC3AV1D-SUw@mail.gmail.com>
Subject: Re: troubles caused by conntrack overlimit in init_netns
To:     Vasily Averin <vasily.averin@linux.dev>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, kernel@openvz.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 2, 2022 at 11:32 AM Vasily Averin <vasily.averin@linux.dev> wrote:
>
> On 4/2/22 20:12, Eric Dumazet wrote:
> >
> > On 4/2/22 03:33, Vasily Averin wrote:
> >> Pablo, Florian,
> >>
> >> There is an old issue with conntrack limit on multi-netns (read container) nodes.
> >>
> >> Any connection to containers hosted on the node creates a conntrack in init_netns.
> >> If the number of conntrack in init_netns reaches the limit, the whole node becomes
> >> unavailable.
> >
> > Can you describe network topology ?
>
>               += veth1 <=> veth container1
> ethX <=> brX =+= veth2 <=> veth container2
>               += vethX <=> veth containerX
>

Could you simply add an iptables rule in init_net to bypass conntrack
for idev=veth* ?

iptables -t raw -I PREROUTING -i veth+ -j NOTRACK

(I have not worked with conntrack in recent years, this might be foolish...)

> > Are you using macvlan, ipvlan, or something else ?
>
> No, we dod not used it earlier, because it was not available in RHEL7,
> but now it looks like good solution for me.
>
> Thank you for the hint,
>         Vasily Averin
