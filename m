From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: nftables: lockout with 0008split_tables_0 test
Date: Tue, 21 Nov 2017 19:39:47 +0100
Message-ID: <CAOkSjBj1iKHwe-X3wNL0O2A2Kt4XNapRE8vN3va7xCN+G8r1Mw@mail.gmail.com>
References: <20171121111556.GX32305@orbyte.nwl.cc> <20171121170946.GB24866@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Phil Sutter <phil@nwl.cc>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:43949 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdKUSkJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2017 13:40:09 -0500
Received: by mail-wm0-f41.google.com with SMTP id x63so5451160wmf.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2017 10:40:09 -0800 (PST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com. [74.125.82.49])
        by smtp.gmail.com with ESMTPSA id j30sm5630506edc.24.2017.11.21.10.40.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Nov 2017 10:40:08 -0800 (PST)
Received: by mail-wm0-f49.google.com with SMTP id y80so5438955wmd.0
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2017 10:40:07 -0800 (PST)
In-Reply-To: <20171121170946.GB24866@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 November 2017 at 18:09, Florian Westphal <fw@strlen.de> wrote:
>
> Yes, thats expected.
> First ssh base chain gets invoked, which accepts any packet
> either by verdict or policy.
>
> Then next base chain gets consulted which drops the packet.
>
> I would suggest to either swap the policies or duplicate the ssh
> rule into the input chain too.

This is something which is actually confusing our users.
I just took the time to extend a bit the documentation:

https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains

Of course, feel free to edit the docs :-)
