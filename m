From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH iptables] xtables: use exponential delay when waiting for
 xtables lock
Date: Thu, 28 Apr 2016 09:37:32 +0800
Message-ID: <CAML_gOfhesCGBk5WWpmAsi3GQNHu5ZZpe9Wg36HCjGgQuRNeOg@mail.gmail.com>
References: <1460084845-28057-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:33606 "EHLO
	mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbcD1Bhe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 21:37:34 -0400
Received: by mail-vk0-f68.google.com with SMTP id v68so2057988vka.0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 18:37:33 -0700 (PDT)
In-Reply-To: <1460084845-28057-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-04-08 11:07 GMT+08:00 Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org>:
> ip[6]tables currently waits for 1 second for the xtables lock to
> be freed if the -w option is used. We have seen that the lock is
> held much less than that resulting in unnecessary delay when
> trying to acquire the lock. This problem is even severe in case
> of latency sensitive applications.
>
> Introduce an exponential delay starting from 10ms (experimentally
> determined) up to a second.
>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  iptables/xshared.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/iptables/xshared.c b/iptables/xshared.c
> index 81c2581..d90ac13 100644
> --- a/iptables/xshared.c
> +++ b/iptables/xshared.c
> @@ -247,6 +247,7 @@ void xs_init_match(struct xtables_match *match)
>  bool xtables_lock(int wait)
>  {
>         int fd, waited = 0, i = 0;
> +       useconds_t base_delay = 10000;
>
>         fd = open(XT_LOCK_NAME, O_CREAT, 0600);
>         if (fd < 0)
> @@ -257,10 +258,15 @@ bool xtables_lock(int wait)
>                         return true;
>                 else if (wait >= 0 && waited >= wait)
>                         return false;
> -               if (++i % 2 == 0)
> +               if ((++i % 2 == 0) && (base_delay >= 200000))
>                         fprintf(stderr, "Another app is currently holding the xtables lock; "
>                                 "waiting (%ds) for it to exit...\n", waited);
>                 waited++;
> -               sleep(1);

This break the "-w" option's semantic, i.e. if the user input
"iptables -w 1", and concurrency happen,
we will just only wait 10ms and return an error.

> +               if (base_delay > 1000000) {
> +                       sleep(1);
> +               } else {
> +                       usleep(base_delay);
> +                       base_delay *= 2;
> +               }
>         }
>  }
> --
> 1.8.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
