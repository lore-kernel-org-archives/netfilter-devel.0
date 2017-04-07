From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH iptables] extensions: libxt_hashlimit: fix 64-bit printf formats
Date: Fri, 7 Apr 2017 14:17:10 +0200
Message-ID: <CAOkSjBiCCrrGBvQPV+==c1HhBA+4=J5jbomWgP8CFQoFObT7rQ@mail.gmail.com>
References: <1491565649-16679-1-git-send-email-James.Cowgill@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: James Cowgill <James.Cowgill@imgtec.com>
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33486 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933429AbdDGMRd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 08:17:33 -0400
Received: by mail-yw0-f195.google.com with SMTP id p77so4780805ywg.0
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Apr 2017 05:17:32 -0700 (PDT)
Received: from mail-yw0-f178.google.com (mail-yw0-f178.google.com. [209.85.161.178])
        by smtp.gmail.com with ESMTPSA id d80sm1882521ywh.75.2017.04.07.05.17.31
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Apr 2017 05:17:31 -0700 (PDT)
Received: by mail-yw0-f178.google.com with SMTP id v76so33567120ywg.0
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Apr 2017 05:17:31 -0700 (PDT)
In-Reply-To: <1491565649-16679-1-git-send-email-James.Cowgill@imgtec.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 7 April 2017 at 13:47, James Cowgill <James.Cowgill@imgtec.com> wrote:
> hashlimit was using "%lu" in a lot of printf format specifiers to print
> 64-bit integers. This is incorrect on 32-bit architectures because
> "long int" is 32-bits there. On MIPS, it was causing iptables to
> segfault when printing these integers.
>
> Fix by using the correct format specifier.
>
> Signed-off-by: James Cowgill <James.Cowgill@imgtec.com>
> ---
>  extensions/libxt_hashlimit.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>

For reference, this is related to debian bug #859775 [0]

[0] https://bugs.debian.org/859775
