Return-Path: <SRS0=ut36=Z4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3ADBC2D0C1
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 22:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C91542245C
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 22:58:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="hbilOdCb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfLFW6o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Dec 2019 17:58:44 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52564 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLFW6o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Dec 2019 17:58:44 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so9428667wmc.2
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Dec 2019 14:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fQyTyi81sNSurDVNaGanlJRmf47w9kd4qd/eAEXU8Mg=;
        b=hbilOdCblw8Nr9SIw2Ydv9XSVrj0A0s6nuhmiXHi70770wcJUhqKbJLMugwuEgdrcL
         LdHm8bYtVwkqees3QE/NPkey+hKUC8rAsKKxTS70F1Ssvuc/A5IIOw2GNSkzj7FfMIdh
         bgt2XDFM4QE7f497OpxO/HZ0oLXCXTLqx84fU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fQyTyi81sNSurDVNaGanlJRmf47w9kd4qd/eAEXU8Mg=;
        b=l+ymBbrU3m+JICCCbxr7CojlgGT3PwvRCc+4ekB/sDESTD9GYu0QGReJccIcmhOBCC
         IBI4zKfaaO5PaJ7pwBRPHsJTN4uKKX8TlYyI/0n/61oavKsqOf1s7a79zX250YF8vYMr
         j7jWNVWdCVoImqRGdsUHMy+mCruG6MVRoMUklu0rwgoVxa5YsY7t9KOhASPl3hTsWZqC
         /cBedA6xPAHtU+mm9L8JveEEqlA56sKCSeEbuxi7Sa9tkHl5qDhtVLi3E4dY/U09ucky
         j5FyUY9C7Z/aK8qDtY4YkpxZufi1ysWYVoc7I9av3+dWE3YafbrffAExmdHNJIfi8tdB
         ttiQ==
X-Gm-Message-State: APjAAAXN2s8nn+G2ulEd/eQuy+LRa+tGH9aDP1tVMQN83OnX1Gj3fXYz
        sxixCmrxcS8a0xt9eVbOdCLJ+ZJQwbqYWHIftzKY5ZHSaVM0zw==
X-Google-Smtp-Source: APXvYqxDoDwoU4SeO/Mh/qR20XP3FrNBHYS6CYnTkK0xT0ow24f8fr3bvnM7N97dWNb232sOnDwxgpfdDsA3YFRZdxI=
X-Received: by 2002:a1c:3941:: with SMTP id g62mr12268370wma.165.1575673121680;
 Fri, 06 Dec 2019 14:58:41 -0800 (PST)
MIME-Version: 1.0
References: <20191203160345.24743-1-labbott@redhat.com> <20191203170114.GB377782@localhost.localdomain>
 <9bc4b04b-a3cc-4e58-4c73-1d77b7ed05da@redhat.com>
In-Reply-To: <9bc4b04b-a3cc-4e58-4c73-1d77b7ed05da@redhat.com>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 6 Dec 2019 16:58:30 -0600
Message-ID: <CAFxkdAraVz6mbQ3OFRGF3DmfWMDNzuXd+HJ14ypex6bMm-oCGw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_flow_table_offload: Correct memcpy size for flow_overload_mangle
To:     Laura Abbott <labbott@redhat.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 3, 2019 at 2:50 PM Laura Abbott <labbott@redhat.com> wrote:
>
> On 12/3/19 12:01 PM, Marcelo Ricardo Leitner wrote:
> > On Tue, Dec 03, 2019 at 11:03:45AM -0500, Laura Abbott wrote:
> >> The sizes for memcpy in flow_offload_mangle don't match
> >> the source variables, leading to overflow errors on some
> >> build configurations:
> >>
> >> In function 'memcpy',
> >>      inlined from 'flow_offload_mangle' at net/netfilter/nf_flow_table_offload.c:112:2,
> >>      inlined from 'flow_offload_port_dnat' at net/netfilter/nf_flow_table_offload.c:373:2,
> >>      inlined from 'nf_flow_rule_route_ipv4' at net/netfilter/nf_flow_table_offload.c:424:3:
> >> ./include/linux/string.h:376:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
> >>    376 |    __read_overflow2();
> >>        |    ^~~~~~~~~~~~~~~~~~
> >> make[2]: *** [scripts/Makefile.build:266: net/netfilter/nf_flow_table_offload.o] Error 1
> >>
> >> Fix this by using the corresponding type.
> >>
> >> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> >> Signed-off-by: Laura Abbott <labbott@redhat.com>
> >> ---
> >> Seen on a Fedora powerpc little endian build with -O3 but it looks like
> >> it is correctly catching an error with doing a memcpy outside the source
> >> variable.
> >
> > Hi,
> >
> > It is right but the fix is not. In that call trace:
> >
> > flow_offload_port_dnat() {
> > ...
> >          u32 mask = ~htonl(0xffff);
> >          __be16 port;
> > ...
> >          flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
> >                                   (u8 *)&port, (u8 *)&mask);
> > }
> >
> > port should have a 32b storage as well, and aligned with the mask.
> >
> >> ---
> >>   net/netfilter/nf_flow_table_offload.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> >> index c54c9a6cc981..526f894d0bdb 100644
> >> --- a/net/netfilter/nf_flow_table_offload.c
> >> +++ b/net/netfilter/nf_flow_table_offload.c
> >> @@ -108,8 +108,8 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
> >>      entry->id = FLOW_ACTION_MANGLE;
> >>      entry->mangle.htype = htype;
> >>      entry->mangle.offset = offset;
> >> -    memcpy(&entry->mangle.mask, mask, sizeof(u32));
> >> -    memcpy(&entry->mangle.val, value, sizeof(u32));
> >                                     ^^^^^         ^^^ which is &port in the call above
> >> +    memcpy(&entry->mangle.mask, mask, sizeof(u8));
> >> +    memcpy(&entry->mangle.val, value, sizeof(u8));
> >
> > This fix would cause it to copy only the first byte, which is not the
> > intention.
> >
>
> Thanks for the review. I took another look at fixing this and I
> think it might be better for the maintainer or someone who is more
> familiar with the code to fix this. I ended up down a rabbit
> hole trying to get the types to work and I wasn't confident about
> the casting.
>

Any update on this? It is definitely a problem on PPC LE.

Thanks,
Justin
