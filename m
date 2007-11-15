From: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: [2.6.24][BUG] Compact code broken?
Date: Thu, 15 Nov 2007 21:14:24 +0100
Message-ID: <68676e00711151214idff4d38mf65c6a1f28aeb299@mail.gmail.com>
References: <20071114212855.GA580@dreamland.darkstar.lan>
	 <20071114.150029.144310383.davem@davemloft.net>
	 <68676e00711141539k18fa900bj9016ee5dd72a71c4@mail.gmail.com>
	 <20071114.154247.130153717.davem@davemloft.net>
	 <473C4E1C.2040301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "David Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:30183 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbXKOUOZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:14:25 -0500
Received: by wa-out-1112.google.com with SMTP id v27so765707wah
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Nov 2007 12:14:24 -0800 (PST)
In-Reply-To: <473C4E1C.2040301@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Nov 15, 2007 2:48 PM, Patrick McHardy <kaber@trash.net> wrote:
> David Miller wrote:
> > From: "Luca Tettamanti" <kronos.it@gmail.com>
> > Date: Thu, 15 Nov 2007 00:39:11 +0100
> >
> >> On Nov 15, 2007 12:00 AM, David Miller <davem@davemloft.net> wrote:
> >>> From: Luca Tettamanti <kronos.it@gmail.com>
> >>> Date: Wed, 14 Nov 2007 22:28:55 +0100
> >>>
> >>>> Hello,
> >>>> I'm testing a 64bit kernel on my machine and I've found an issue with
> >>>> iptables (32 bit). Kernel is git current (9418d5dc).
> >>> What platform?  x86?  powerpc?  sparc64?
> >> x86
> >
> > Ok, the userland pointer you provided seemed to be sign extended
> > to 64-bit, so there might be a pointer arithmetic bug in the
> > netfilter compat code somewhere.
>
>
> It took me a few passes over the code, but it turns out to be
> a simple typo :)
>
> Luca, does this fix it for you?

Yes, it's working fine, thank you!

> [NETFILTER]: fix compat_nf_sockopt typo
>
> It should pass opt to the ->get/->set functions, not ops.
>
> Fixes compat fault reported by Luca Tettamanti <kronos.it@gmail.com>
>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Tested-by: Luca Tettamanti <kronos.it@gmail.com>

>
> ---
> commit ac55193be35872211189096ec600f94614a0179b
> tree a6633e33307b5ec1e11fedc2d0e125ed6e2bd081
> parent 99fee6d7e5748d96884667a4628118f7fc130ea0
> author Patrick McHardy <kaber@trash.net> Thu, 15 Nov 2007 14:46:43 +0100
> committer Patrick McHardy <kaber@trash.net> Thu, 15 Nov 2007 14:46:43 +0100
>
>  net/netfilter/nf_sockopt.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
> index 87bc144..3dd4b3c 100644
> --- a/net/netfilter/nf_sockopt.c
> +++ b/net/netfilter/nf_sockopt.c
> @@ -143,12 +143,12 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
>                 if (ops->compat_get)
>                         ret = ops->compat_get(sk, val, opt, len);
>                 else
> -                       ret = ops->get(sk, val, ops, len);
> +                       ret = ops->get(sk, val, opt, len);
>         } else {
>                 if (ops->compat_set)
> -                       ret = ops->compat_set(sk, val, ops, *len);
> +                       ret = ops->compat_set(sk, val, opt, *len);
>                 else
> -                       ret = ops->set(sk, val, ops, *len);
> +                       ret = ops->set(sk, val, opt, *len);
>         }
>
>         module_put(ops->owner);
>
>
