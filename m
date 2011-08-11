From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Subject: Re: [PATCH] netfilter: nf_queue: fix NF_STOLEN skb leak redux
Date: Fri, 12 Aug 2011 00:12:07 +0200
Message-ID: <CAHXqBFJ=Z=uhgyxUYJ=j1xp6NvhkY6wUYxjNCx6YTTnr_gDsbg@mail.gmail.com>
References: <1313095621-2015-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54917 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1HKWM2 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2011 18:12:28 -0400
Received: by qwk3 with SMTP id 3so1293013qwk.19
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2011 15:12:27 -0700 (PDT)
In-Reply-To: <1313095621-2015-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2011/8/11 Florian Westphal <fw@strlen.de>:
> A userspace listener may send (bogus) NF_STOLEN verdict, which causes
> skb leak.
>
> This problem was previously fixed via
> 64507fdbc29c3a622180378210ecea8659b14e40 (netfilter:
> nf_queue: fix NF_STOLEN skb leak) but this had to be reverted
> because NF_STOLEN can also be returned by a netfilter hook when
> iterating the rules in nf_reinject.
>
> This is complementary to commit fad54440438a7c231a6ae347738423cbabc93=
6d9
> (netfilter: avoid double free in nf_reinject).
>
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> =C2=A0One alternative would be to change ip(6)queue and nfqueue
> =C2=A0to fail with -EINVAL if userspace gives NF_STOLEN verdict.
> =C2=A0Thoughts?

Since userspace is not supposed to pass NF_STOLEN, this would be the
correct fix.

Just a hint, no guarantees attached. ;)

Best Regards,
Micha=C5=82 Miros=C5=82aw
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
