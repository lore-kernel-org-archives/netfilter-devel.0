Return-Path: <SRS0=F+rW=57=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9DEC2BA19
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Apr 2020 21:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56870206E9
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Apr 2020 21:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rr1BU6dU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgDOVlR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Apr 2020 17:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727857AbgDOVlO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Apr 2020 17:41:14 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209F7C061A0C
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2020 14:41:14 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w1so18843368iot.7
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2020 14:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WYxY5M6hFFkgxuFFZzPlT5KRD+mE+eLGiI4BVDeYD4o=;
        b=rr1BU6dUMJzHsfj0RqzSHs3izS6psbuWpYGoUmy75R4vtq1pDyWyRcvz6sIZvTNS1e
         zTiTqvgkkV21L+4uVY9L3YPlxyug+pKHlzakyOUQE+oAj8Em4anjetjHKsZtwYN2+UcP
         nggcwjT1q1asKco81xDPFePggGEHxfVjD7s/LXAngvHINyfSVg0WM5nGV9fv/99yy4+S
         4xGvo7UekSscN9+sga0280Pymegp/ouM7T9zToxqvXMXOWp+5vLyBbtRRG43srWgkogw
         ZzDEtVQJ09G7qd1bTGWE9xs1MPWF0yFDpFNbrMmfRK1uuHgmvnFIkMoCfahSq6cPWIxO
         evGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WYxY5M6hFFkgxuFFZzPlT5KRD+mE+eLGiI4BVDeYD4o=;
        b=VFHyK36OzLGmtrrrCsfGC62IvbIS2Ot4anaI8+CekXvy/XeMFxqk6nZDqHteMo4zxX
         JGDGwpEomj+fCFoncLl5zW/GArncgFZrsID3VhV7SysPO3TmaNtT4Fo2tlBh143vNoV1
         RPoggmn0k3IYux2+7AgoWES5awDRZ8hFaDB1kjbN8Mwaph60mydmbxkOPJkhcWOaKuc5
         fSiCO3yNSdcUVBgjC08mXIYaVAOmlRfNKVDC9Gieqy9R5e5SkZeJwy4ktrcMG9Ak9cxk
         qw9kYGMA8vKd2iaRpZRkgWQrofuavMtfEQIhacAbiAHyJM2tVSpu8i/4nYI7hxubuZJq
         erMQ==
X-Gm-Message-State: AGi0PuZyAtYW7KEkWcVjNmCTspZPgX+mt/dcvuvVF76GJGG/r95xlQcT
        NY98vcn6TshexeFYjFfVkVlYx0Q+Qt59XUj2B/buq7Uf
X-Google-Smtp-Source: APiQypIyAR+3+TUYJ8YmJkAlBF/reS8JB19by4bEy2TPpnOZqNf9qdswwZLxt2S6hJCGHB+6baVA0oVyrhybA8SexRM=
X-Received: by 2002:a02:6349:: with SMTP id j70mr28300156jac.137.1586986873307;
 Wed, 15 Apr 2020 14:41:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200407180124.19169-1-ydahhrk@gmail.com> <CAF90-Wg=uGXVOPu-OXupkFYYL0xDYTfV8vTNRvUQgspFMamL=w@mail.gmail.com>
In-Reply-To: <CAF90-Wg=uGXVOPu-OXupkFYYL0xDYTfV8vTNRvUQgspFMamL=w@mail.gmail.com>
From:   Alberto Leiva <ydahhrk@gmail.com>
Date:   Wed, 15 Apr 2020 16:41:02 -0500
Message-ID: <CAA0dE=XPuEv=Gye9MXz+aC9s8=izd066+=yJfYTe9vtZgQtLnA@mail.gmail.com>
Subject: Re: [nft PATCH 2/2] expr: add jool expressions
To:     Laura Garcia <nevola@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> Looking at the code, the pool4db is pretty much an adaptation of what
> conntrack already does. So, why not to put the efforts in extending
> conntrack to support NAT64/NAT46 ?

Ok, please don't take this as an aggressively defensive gesture, but I
feel like this is an unfair question.

If I provide a ready and simple but effective means to bridge our
projects I feel like it befalls on you to justify why you wish to
commit to the far more troublesome course of action.

Merging the projects seems to me like several (if not many) months
worth of development and testing, little of which would be made in
benefit of our users. (No real functionality would be added, and some
functionality might be dropped--eg. atomic configuration, session
synchronization.)

I mean I get that you want to avoid some duplicate functionality, but
is this really a more important use of my time than, say, adding MAP-T
support? ([0])

> This way, the support of this natting is likely to be included in the
> kernel vanilla and just configure it with just one rule:
>
> sudo nft add rule inet table1 chain1 dnat 64 64:ff9b::/96

Ok, but I don't think an IP translator is *meant* to be configured in
a single line. Particularly in the case of NAT46. How do you populate
a large EAM table ([1]) on a line? If your translator instance is
defined entirely in a rule matched by IPv6 packets, how do you tell
the corresponding IPv4 rule to refer to the same instance?

It is my humble opinion that some level of separation between nftables
rules and translator instances is clean design.

> One more thing, it seems that jool only supports PREROUTING, is that right?

Yes, although this might presently only be because nobody has asked elsewhat.

I tried adding LOCAL_OUT support some years ago and forgot to write
down the problems that prevented me from succeeding. I can give it
another shot if this is important for you.

Cheers,
Alberto

[0] https://tools.ietf.org/html/rfc7599
[1] https://jool.mx/en/eamt.html

On Wed, Apr 8, 2020 at 2:22 PM Laura Garcia <nevola@gmail.com> wrote:
>
> On Tue, Apr 7, 2020 at 8:03 PM Alberto Leiva Popper <ydahhrk@gmail.com> wrote:
> >
> > Jool statements are used to send packets to the Jool kernel module,
> > which is an IP/ICMP translator: www.jool.mx
> >
> > Sample usage:
> >
> >         modprobe jool
> >         jool instance add "name" --iptables -6 64:ff9b::/96
> >         sudo nft add rule inet table1 chain1 jool nat64 "name"
> >
>
> Hi Alberto,
>
> Looking at the code, the pool4db is pretty much an adaptation of what
> conntrack already does. So, why not to put the efforts in extending
> conntrack to support NAT64/NAT46 ?
>
> This way, the support of this natting is likely to be included in the
> kernel vanilla and just configure it with just one rule:
>
> sudo nft add rule inet table1 chain1 dnat 64 64:ff9b::/96
>
> One more thing, it seems that jool only supports PREROUTING, is that right?
>
> Cheers.
