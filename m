From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [nft PATCH] nft.8: Enhance NAT documentation
Date: Thu, 4 May 2017 09:04:59 +0200
Message-ID: <CAOkSjBi7fqb3kqJc+z2Dq6BvZOiQimMKOWFobqvFYv7g0jhj7Q@mail.gmail.com>
References: <20170502175127.30805-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33048 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751362AbdEDHFV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 03:05:21 -0400
Received: by mail-it0-f66.google.com with SMTP id v135so690080itv.0
        for <netfilter-devel@vger.kernel.org>; Thu, 04 May 2017 00:05:21 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com. [209.85.223.181])
        by smtp.gmail.com with ESMTPSA id 141sm183503itz.4.2017.05.04.00.05.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 May 2017 00:05:20 -0700 (PDT)
Received: by mail-io0-f181.google.com with SMTP id f102so10745698ioi.2
        for <netfilter-devel@vger.kernel.org>; Thu, 04 May 2017 00:05:20 -0700 (PDT)
In-Reply-To: <20170502175127.30805-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2 May 2017 at 19:51, Phil Sutter <phil@nwl.cc> wrote:
> This adds documentation about masquerade and redirect statements, points
> out that for any NAT statement both prerouting and postrouting chains
> are required and adds a bunch of examples to the section's end.
>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  doc/nft.xml | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 57 insertions(+), 1 deletion(-)
>

Thanks Phil, more docs are always good.

Acked-by: Arturo Borrero Gonzalez <arturo@debian.org>
