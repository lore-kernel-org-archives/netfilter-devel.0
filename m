From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Wed, 10 May 2017 14:52:49 +0200
Message-ID: <CAOkSjBhBTB8uDspnqx7F9vHt0GcCeAyt_3e+Lzm5nMG9pQKnOA@mail.gmail.com>
References: <20170510105510.891-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33031 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbdEJMxM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2017 08:53:12 -0400
Received: by mail-it0-f67.google.com with SMTP id v135so9024itv.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2017 05:53:11 -0700 (PDT)
Received: from mail-it0-f51.google.com (mail-it0-f51.google.com. [209.85.214.51])
        by smtp.gmail.com with ESMTPSA id 141sm1628784itz.4.2017.05.10.05.53.10
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 May 2017 05:53:10 -0700 (PDT)
Received: by mail-it0-f51.google.com with SMTP id g126so513854ith.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2017 05:53:10 -0700 (PDT)
In-Reply-To: <20170510105510.891-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10 May 2017 at 12:55, Phil Sutter <phil@nwl.cc> wrote:
> This adds support for printing the process ID and name for changes which
> 'nft monitor' reports:
>
> | nft -a -p monitor
> | add chain ip t2 bla3 # pid 11616 (nft)
>
> If '-n' was given in addition to '-p', parsing the process name from
> /proc/<pid>/cmdline is suppressed.
>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Cc: Florian Westphal <fw@strlen.de>
> ---
>  include/nftables.h |  1 +
>  src/main.c         | 12 ++++++++++-
>  src/netlink.c      | 60 +++++++++++++++++++++++++++++++++++++++++++++++++-----
>  src/rule.c         |  2 --
>  4 files changed, 67 insertions(+), 8 deletions(-)
>

If you are about to parse the textual nft output anyway, (which
doesn't seems like a good idea BTW),
why you don't simply add a rule comment?:

% nft add rule inet filter input counter comment "added by my app"
