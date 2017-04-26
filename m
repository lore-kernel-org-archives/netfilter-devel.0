From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [nft RFC PATCH] expression: print sets and maps in pretty format
Date: Wed, 26 Apr 2017 10:59:35 +0200
Message-ID: <CAOkSjBj8QP8rWHBLGvudbETjU3eDk_KVnRiPsaoY16BEw0Hc_g@mail.gmail.com>
References: <149312374138.17592.11887464748028997707.stgit@nfdev2.cica.es> <CAAaDf4sLCNeR6re98yNOcrvi=6RkPKb-O9ROU+8F3ZyGhWjPUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34421 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1434662AbdDZI75 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Apr 2017 04:59:57 -0400
Received: by mail-oi0-f43.google.com with SMTP id x184so202257636oia.1
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Apr 2017 01:59:57 -0700 (PDT)
Received: from mail-oi0-f42.google.com (mail-oi0-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id d30sm5207428otb.18.2017.04.26.01.59.56
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Apr 2017 01:59:56 -0700 (PDT)
Received: by mail-oi0-f42.google.com with SMTP id j201so201212952oih.2
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Apr 2017 01:59:56 -0700 (PDT)
In-Reply-To: <CAAaDf4sLCNeR6re98yNOcrvi=6RkPKb-O9ROU+8F3ZyGhWjPUA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 April 2017 at 00:00, Pablo M. Bermudo Garay <pablombg@gmail.com> wrote:
> 2017-04-25 14:35 GMT+02:00 Arturo Borrero Gonzalez <arturo@debian.org>:
>> Print elements per line instead of all in a single line.
>> The elements which can be 'short' are printed 5 per line,
>> and others, like IPv4 addresses are printed 2 per line.
>
> The default terminfo tab size is 8. Why not align the first column of
> elements for this case? It is only needed to replace the last tab of
> "newline" with five spaces.
>
> -       const char *newline = ",\n\t\t\t\t";
> +       const char *newline = ",\n\t\t\t     ";

yeah far better, sending v2 now
