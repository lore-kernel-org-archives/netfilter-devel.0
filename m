From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: conntracd init.d reload is broken on Centos6
Date: Sat, 18 Nov 2017 13:47:19 +0100
Message-ID: <CAOkSjBjXv=ORw+WxMLU3xUs-XunNPFtsOB-dFpw29oRh6FjDKQ@mail.gmail.com>
References: <CAPyb0YcPtkruBLSVfxBnU1jrkL_5PgCxLvN56pMgexPHx=RZrQ@mail.gmail.com>
 <20171116132528.GA2159@salvia> <CAPyb0YcE2FXgvL0HFBVj9gHK7T4jqtvqEpquQNf2y9+QEdwSvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Jason Hendry <jhendry@mintel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:45373 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966495AbdKRMrm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Nov 2017 07:47:42 -0500
Received: by mail-wm0-f68.google.com with SMTP id 9so11001949wme.4
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Nov 2017 04:47:41 -0800 (PST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com. [74.125.82.43])
        by smtp.gmail.com with ESMTPSA id s6sm4501844edc.2.2017.11.18.04.47.40
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Nov 2017 04:47:40 -0800 (PST)
Received: by mail-wm0-f43.google.com with SMTP id 5so9867463wmk.1
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Nov 2017 04:47:40 -0800 (PST)
In-Reply-To: <CAPyb0YcE2FXgvL0HFBVj9gHK7T4jqtvqEpquQNf2y9+QEdwSvQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please avoid top-posting.

On 17 November 2017 at 23:55, Jason Hendry <jhendry@mintel.com> wrote:
> Turns out sending conntrackd a -HUP signal causes it to die. I can not
> find any documentation/reference on what signals conntrackd accepts,
> is there one to tell it to reload its config?  We are running
> conntrackd 0.9.14
>

That's a very old version of conntrackd (8+ years ago?). Please use a
newer version.

ATM conntrackd is unable to reload config. This is something I would
like to improve in the future.

> Can you also clarify the effect of restarting conntrackd, is it a safe
> operation to do? Will it cause any interruption to connections? Will
> it re-sync with the kernel state table? Will it re-sync with its peer?
>

Connections are in the kernel and those are not affected by conntrackd restart.
Depending on your conntrackd config you may lose state updates which
are in the conntrackd cache but not in the kernel yet.
In newer versions of conntrackd there is a StartupResync option to
request resync with other node at startup.
