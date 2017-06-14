From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: using nft & iptables nat in parallel
Date: Wed, 14 Jun 2017 15:22:46 +0200
Message-ID: <CAOkSjBgpg8cfovK9_mQLF1+WQfAjEsAe=-jsaY4=G_LTtgENcA@mail.gmail.com>
References: <20170614092448.GB10130@breakpoint.cc> <CAOkSjBiSrj_V0nJoV8zXmfN-0mDcbfYEuf_knAnp+cHgOa=ePA@mail.gmail.com>
 <20170614095803.GC10130@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35008 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752496AbdFNNXN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 09:23:13 -0400
Received: by mail-io0-f175.google.com with SMTP id k93so277091ioi.2
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 06:23:13 -0700 (PDT)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id l19sm21250ioe.3.2017.06.14.06.23.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jun 2017 06:23:07 -0700 (PDT)
Received: by mail-io0-f174.google.com with SMTP id t87so331231ioe.0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 06:23:07 -0700 (PDT)
In-Reply-To: <20170614095803.GC10130@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14 June 2017 at 11:58, Florian Westphal <fw@strlen.de> wrote:
> Arturo Borrero Gonzalez <arturo@debian.org> wrote:
>> I'm curious, What is the use case of using both nftables and iptables
>> at the same time?
>> Some missing functionality in nft?
>> Perhaps some ipt->nft partial migration procedure?
>
> Yes, partial migration.
>
> Right now there are an awful lot of tools out there (docker, libvirt,
> kubernetes, ..) that call iptables(-restore) directly (or inject them via
> firewalld).
>

Well, just quickly checked firewalld code [0].
It relies so massively in ipXtables/ipset that I bet a migration to
nftables would require a major rewrite.

Not sure if iptables-compat address this case, or even a high level libnftables.

[0] https://github.com/t-woerner/firewalld/blob/master/src/firewall/core/ipXtables.py
