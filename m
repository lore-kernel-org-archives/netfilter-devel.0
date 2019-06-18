Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A27DC31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 12:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A4B52085A
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 12:08:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mEw6qy+T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfFRMIC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 08:08:02 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:43087 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFRMIC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 08:08:02 -0400
Received: by mail-io1-f54.google.com with SMTP id k20so29086940ios.10;
        Tue, 18 Jun 2019 05:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W6pciV6t8kYopsiUDCIGRGlSM0ZMGWc5Sh3ngOfZNEY=;
        b=mEw6qy+T4eFb/7G2y24LYyZGhhnuX9TmDFgYu2+lyFLJKyItxrYqAPSY8HDLNyb3Rk
         +CEmb//v/fn0WO1dzRrvWDOH74bwymMpGJQRZniuO5tVF6UZrs3MtLbGbNKmhotP7G7O
         AOvTFVCaXZqvqiqcmPOzWrM6floIuMTeHJpN0X857ytYic7VL7To0bxLBA3R7uoY7q/G
         9TArRICrIo+kvnUFNrfWihmLYkoKdvUeVVqmlKoW3lwhq4k1IvfttV4ryt7mwnqdYJph
         x5wRnCThsPWt23OxD8adIlT1zAmyIZNVkeLpflkVYMBbr/j6W1hJXs5nQc5E6VRmuT9t
         VLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W6pciV6t8kYopsiUDCIGRGlSM0ZMGWc5Sh3ngOfZNEY=;
        b=cyph7yyXFHZJZ/netiKq9eu8BUbYfhMbOvMZk5VaEpJJ5yaNXWM0gpctUL9ytP23Da
         +5oU4N9OD7Xo9MLxDCHmWiGSWmPK7CVP7B+vBwbiOZYQzREh0gErxKn3c3jGuvIX8eN+
         7lG9sq5S1qAVvzK8YcrhLA00l1ahWIg/ta3i2hCkJSDVwL/h8zmODjYKZlrFqTYqnIYi
         C9PSKV9pN9DqEVLz08rwmb7rYLBalLcjOoQMgsmI51XEK7CKeNvFOcw1S4AGIFmtSdsA
         7tFDidtZd9btLnQzzokvuGBvv1Np/QAn/D2ABjgQG/InzXHROfTKvUuhT8lMgJsnWCgy
         Z9Pg==
X-Gm-Message-State: APjAAAUgos19xQAnkc6bKQlq71BJy5rzeIdwkUR/tiIofsuoXi70T7AR
        +n0owt944kIdn9/XJvCYsmpo+VqKLkP1+4dRcdE=
X-Google-Smtp-Source: APXvYqwiLpxsRVqvnb9I5CGxz0zDzUR1ss++xkSxz9AH2R/HOp3QZ159ZhEvx3VAsRqhD2PwO3Uq9v1+WoN9r2xTtAA=
X-Received: by 2002:a5d:8508:: with SMTP id q8mr5912980ion.31.1560859681738;
 Tue, 18 Jun 2019 05:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc> <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
 <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc>
In-Reply-To: <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc>
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Tue, 18 Jun 2019 15:07:50 +0300
Message-ID: <CAK6Qs9mTkAaH9+RqzmtrbNps1=NtW4c8wtJy7Kjay=r7VSJwsQ@mail.gmail.com>
Subject: Re: Is this possible SYN Proxy bug?
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 2:59 PM Florian Westphal <fw@strlen.de> wrote:

> >
> > I am confused. So this statement from manual page is just a illusion?
> > --mss maximum segment size
> >               Maximum segment size announced to clients. This must
> > match the backend.
>
> ?
>
> Your question was about MSS sent to server.
>
> Flow is this:
> Client          Synproxy         Server
> -> Syn, mss X
>     <-Synack,mss M
> -> ACK
>                      -> Syn, mss Y
>
> M is what you need to configure via --mss switch.
>
> Because Synproxy keeps no state, it can only send
> to real server the MSS that was encoded in syncookie (in synack)
> packet.  Therefore, X == Y only if the Value from client matches
> exactly one for the four values of the mss table, in all other
> cases Y is the next lowest available one.  In your case thats 536.
>
> > I don't understand why these restriction exist. Why can't we set mss
> > value same as what client send to us?
>
> We only have 2 bits out of the 32Bit Sequence number for MSS. Increasing
> mss state table reduces security margin of the cookie.

My question about both way actually. If you check out my tests, M is
also not correct. Client sends mss 1260 and syn proxy responds 1260
too although I set mss 1460 in iptables.
