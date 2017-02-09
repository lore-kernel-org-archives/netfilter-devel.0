From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH] src: consolidate XML/JSON exportation for rule
Date: Thu, 9 Feb 2017 12:57:22 +0100
Message-ID: <CAOkSjBjpxwQTpczNcA0zhFXRbcjckhkrTBqhPDW5z8ecMm5NSw@mail.gmail.com>
References: <20170208154252.GA32430@Novo>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shivani Bhardwaj <shivanib134@gmail.com>
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34534 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdBIL6M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2017 06:58:12 -0500
Received: by mail-io0-f173.google.com with SMTP id l66so14795867ioi.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Feb 2017 03:57:43 -0800 (PST)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com. [209.85.214.45])
        by smtp.gmail.com with ESMTPSA id 62sm369900itl.1.2017.02.09.03.57.42
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Feb 2017 03:57:42 -0800 (PST)
Received: by mail-it0-f45.google.com with SMTP id r185so14197820ita.0
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Feb 2017 03:57:42 -0800 (PST)
In-Reply-To: <20170208154252.GA32430@Novo>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 8 February 2017 at 16:42, Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> This completes the XML/JSON exportation using the new buffer class for
> rule.
>
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  include/buffer.h |  5 +++
>  src/buffer.c     | 11 +++++++
>  src/rule.c       | 96 ++++++++++++++++----------------------------------------
>  3 files changed, 43 insertions(+), 69 deletions(-)
>

Acked-by: Arturo Borrero Gonzalez <arturo@debian.org>
