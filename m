From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [nft PATCH 2/2] masquerade: Complain if no prerouting chain exists
Date: Fri, 28 Apr 2017 09:01:44 +0200
Message-ID: <CAOkSjBjdnywsFENgBLQfQr2aXMTDpU9ztXm_Y4V1==E61hH05g@mail.gmail.com>
References: <20170427132439.9443-1-phil@nwl.cc> <20170427132439.9443-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33215 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdD1HCG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 03:02:06 -0400
Received: by mail-it0-f66.google.com with SMTP id z67so4719753itb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 00:02:06 -0700 (PDT)
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com. [209.85.214.52])
        by smtp.gmail.com with ESMTPSA id o67sm830886ito.14.2017.04.28.00.02.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Apr 2017 00:02:05 -0700 (PDT)
Received: by mail-it0-f52.google.com with SMTP id x188so30036300itb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 00:02:05 -0700 (PDT)
In-Reply-To: <20170427132439.9443-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27 April 2017 at 15:24, Phil Sutter <phil@nwl.cc> wrote:
> As reported in netfilter bz#1105, masquerading won't work if there isn't
> at least an empty base chain hooked into prerouting. In order to raise
> awareness of this problem at the user, complain if a masquerading
> statement is added and the table does not contain an appropriate
> prerouting chain already.
>
> To not break user scripts which add the required chain at a later point,
> accept the command anyway.
>
> A better solution would be to create the required chain as a dependency
> and drop it again on return path or if the user adds his own one later,
> though I doubt the extra effort is feasible here.
>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/evaluate.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>

This warning will be printed even in rulesets loaded with '-f'
which first creates the masq rule an then the other chain.

I think is just a matter of documenting *everywhere* that this is the
expected behaviour, not a bug.
