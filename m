From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: using nft & iptables nat in parallel
Date: Wed, 14 Jun 2017 11:37:55 +0200
Message-ID: <CAOkSjBiSrj_V0nJoV8zXmfN-0mDcbfYEuf_knAnp+cHgOa=ePA@mail.gmail.com>
References: <20170614092448.GB10130@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:34827 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751707AbdFNJiR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 05:38:17 -0400
Received: by mail-it0-f54.google.com with SMTP id m62so55897762itc.0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 02:38:17 -0700 (PDT)
Received: from mail-it0-f54.google.com (mail-it0-f54.google.com. [209.85.214.54])
        by smtp.gmail.com with ESMTPSA id 131sm142957ioo.5.2017.06.14.02.38.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jun 2017 02:38:16 -0700 (PDT)
Received: by mail-it0-f54.google.com with SMTP id m47so55874229iti.1
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 02:38:16 -0700 (PDT)
In-Reply-To: <20170614092448.GB10130@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14 June 2017 at 11:24, Florian Westphal <fw@strlen.de> wrote:
>
> Another side effect is that this avoids the need to add (in nft case)
> the 'empty' nat base chains to take care of reply translation.
>

good!

> Thoughts?
>

I'm curious, What is the use case of using both nftables and iptables
at the same time?
Some missing functionality in nft?
Perhaps some ipt->nft partial migration procedure?

>
> This would also possibly allow us to add nat hooks in the INET family.

good!
