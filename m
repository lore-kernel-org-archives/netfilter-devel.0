From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [nft PATCH v2] set_expr: Allow passing the parent set to set_expr_alloc()
Date: Wed, 12 Jul 2017 14:22:05 +0200
Message-ID: <CAOkSjBiLoU3_=a8fApWYoQ0=tn_0Enigd8LXncWCw=ukcp4tZQ@mail.gmail.com>
References: <20170712120315.GR16375@orbyte.nwl.cc> <20170712121416.22871-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35051 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932539AbdGLMW1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 08:22:27 -0400
Received: by mail-io0-f182.google.com with SMTP id h134so11511099iof.2
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 05:22:27 -0700 (PDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com. [209.85.223.175])
        by smtp.gmail.com with ESMTPSA id o8sm1464429ioo.56.2017.07.12.05.22.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2017 05:22:26 -0700 (PDT)
Received: by mail-io0-f175.google.com with SMTP id r36so11466459ioi.1
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 05:22:26 -0700 (PDT)
In-Reply-To: <20170712121416.22871-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 July 2017 at 14:14, Phil Sutter <phil@nwl.cc> wrote:
> Usually one wants to at least initialize set_flags from the parent, so
> make allocation of a set's set expression more convenient.
>
> The idea to do this came when fixing an issue with output formatting of
> larger anonymous sets in nft monitor: Since
> netlink_events_cache_addset() didn't initialize set_flags,
> calculate_delim() didn't detect it's an anonymous set and therefore
> added newlines to the output.
>
> Reported-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> Fixes: a9dc3ceabc10f ("expression: print sets and maps in pretty format")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Changed set_expr_alloc() to return early if struct set pointer is
>   NULL.
> - Removed the unrelated extra chunk.
> ---
>  include/expression.h |  3 ++-
>  src/evaluate.c       |  2 +-
>  src/expression.c     | 12 ++++++++++--
>  src/netlink.c        |  8 +++-----
>  src/parser_bison.y   |  4 ++--
>  src/rule.c           |  2 +-
>  6 files changed, 19 insertions(+), 12 deletions(-)
>

Thanks Phil,

Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
