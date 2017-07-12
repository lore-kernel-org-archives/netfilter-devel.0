From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [nft PATCH 3/4] expression: Introduce compound_expr_last
Date: Wed, 12 Jul 2017 17:42:21 +0200
Message-ID: <CAOkSjBgtDJyOjZ9Hs-5u3bVQoo=CrhJ6rcZZnyw_aJedeNpArA@mail.gmail.com>
References: <20170712123658.25363-1-phil@nwl.cc> <20170712123658.25363-4-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35247 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752977AbdGLPmn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 11:42:43 -0400
Received: by mail-io0-f169.google.com with SMTP id h134so14822271iof.2
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 08:42:42 -0700 (PDT)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com. [209.85.223.180])
        by smtp.gmail.com with ESMTPSA id 76sm1615192iou.59.2017.07.12.08.42.42
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2017 08:42:42 -0700 (PDT)
Received: by mail-io0-f180.google.com with SMTP id h64so14751276iod.0
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 08:42:42 -0700 (PDT)
In-Reply-To: <20170712123658.25363-4-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 July 2017 at 14:36, Phil Sutter <phil@nwl.cc> wrote:
> This function retrieves the last element in a compound expression.
>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/expression.h | 1 +
>  src/expression.c     | 7 +++++++
>  2 files changed, 8 insertions(+)

Same here, I would suggest merging patch to 1/4.
