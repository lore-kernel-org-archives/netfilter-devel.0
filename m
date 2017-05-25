From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCH 1/1] extensions: libxt_cluster: Add translation to nft
Date: Thu, 25 May 2017 15:42:23 +0530
Message-ID: <CAOfkYf5Uv6HE=t5Q+2=6r1fmf2cuvEod86wOPFaRm9FBGYwBTw@mail.gmail.com>
References: <1495629111-8206-1-git-send-email-mayhs11saini@gmail.com> <20170524154419.GA24697@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34330 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755275AbdEYKMZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2017 06:12:25 -0400
Received: by mail-oi0-f53.google.com with SMTP id b204so274374045oii.1
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2017 03:12:24 -0700 (PDT)
In-Reply-To: <20170524154419.GA24697@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 24, 2017 at 9:14 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, May 24, 2017 at 06:01:51PM +0530, Shyam Saini wrote:
>> Add translation for cluster to nft
>
> I think this should be:
>
>         -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed 0xdeadbeef
>
> should be translated to:
>
>         jhash ct original saddr mod 2 seed 0xdeadbeef eq 0
>
> if --cluster-local-node is 2, then:
>
>         jhash ct original saddr mod 2 seed 0xdeadbeef eq 1

Thanks for correcting me.

I will send the version 2 of this patch
