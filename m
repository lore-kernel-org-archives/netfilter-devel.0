From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [RFC PATCH nft V4] src: Add import command for json
Date: Thu, 21 Sep 2017 08:52:56 +0200
Message-ID: <CAOkSjBj0SZ18kUPrp4r-4P18ZOwmC+6hS16ZSyOU=JOYK6UZTw@mail.gmail.com>
References: <1505902479-24405-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:50208 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751804AbdIUGxT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 02:53:19 -0400
Received: by mail-wm0-f53.google.com with SMTP id v142so12584157wmv.5
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2017 23:53:18 -0700 (PDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com. [74.125.82.43])
        by smtp.gmail.com with ESMTPSA id d89sm498371edc.15.2017.09.20.23.53.17
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Sep 2017 23:53:17 -0700 (PDT)
Received: by mail-wm0-f43.google.com with SMTP id a137so8149455wma.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2017 23:53:17 -0700 (PDT)
In-Reply-To: <1505902479-24405-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20 September 2017 at 12:14, Shyam Saini <mayhs11saini@gmail.com> wrote:
> This new operation allows to import ruleset in json to make
> incremental changes using the parse functions of libnftnl.
>
> A basic way to test this new functionality is:
>
>  % cat file.json | nft import json
>
> where the file.json is a ruleset exported in json format.
>
> Highly based on work from  Alvaro Neira <alvaroneay@gmail.com>
> and Arturo Borrero <arturo@netfilter.org>
>
> Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> ---
> V4:
>   Fix coding style issues
>   Avoid nested function calls (As Suggested by Arturo )

LGTM

Thanks Shyam!

Just tested this patch, along with the one adding the testcase.
All seems fine.

@Pablo, please, review and apply.
