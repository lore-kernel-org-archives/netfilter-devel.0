From: Ana Rey <anarey@gmail.com>
Subject: Re: [PATCH] xtables: fix memory leak in command_jump
Date: Tue, 3 Dec 2013 18:53:21 +0100
Message-ID: <CAD7o0siZ4v30vjyuJ0Y40UcZm8=_4UpFm-pBTB0bE7aRV3GeVw@mail.gmail.com>
References: <1385981059-2923-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:63951 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab3LCRxo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:53:44 -0500
Received: by mail-vc0-f170.google.com with SMTP id ht10so10363489vcb.29
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Dec 2013 09:53:43 -0800 (PST)
In-Reply-To: <1385981059-2923-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/12/2 Ana Rey <anarey@gmail.com>:
> This error is shown with valgrind tool:
>
> valgrind --leak-check=full xtables -A INPUT -i eth0 -p tcp --dport 80
>
> ==7377==
> ==7377== 40 bytes in 1 blocks are still reachable in loss record 4 of 14
> ==7377==    at 0x4C2B514: calloc (vg_replace_malloc.c:593)
> ==7377==    by 0x52448C8: xtables_calloc (xtables.c:272)
> ==7377==    by 0x41487B: do_commandx (xtables.c:618)
> ==7377==    by 0x4134DC: xtables_main (xtables-standalone.c:72)
> ==7377==    by 0x5B87994: (below main) (libc-start.c:260)
> ==7377==

Please, withdraw this patch, I detected a problem in it.



> ---
>  iptables/xtables.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/iptables/xtables.c b/iptables/xtables.c
> index c49b4a2..b5fff8c 100644
> --- a/iptables/xtables.c
> +++ b/iptables/xtables.c
> @@ -638,6 +638,8 @@ static void command_jump(struct iptables_command_state *cs)
>                 opts = xtables_merge_options(xtables_globals.orig_opts, opts,
>                                              cs->target->extra_opts,
>                                              &cs->target->option_offset);
> +       free(cs->target->t);
> +
>         if (opts == NULL)
>                 xtables_error(OTHER_PROBLEM, "can't alloc memory!");
>  }
> --
> 1.8.4.rc3
>



-- 
Ana Rey (@anaRB)
http://www.anarey.info
http://about.me/anarey
