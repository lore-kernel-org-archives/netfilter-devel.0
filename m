From: Nikolay Martynov <mar.kolya@gmail.com>
Subject: Re: [PATCH 1/1] ipset: fix timeout data type size
Date: Fri, 8 Nov 2013 00:31:08 -0500
Message-ID: <CALGY4fvAKT6r-YZjVNMjS=CeKgvQn3KnCPQ-Agyk8-jEjqqZsA@mail.gmail.com>
References: <1383194071-25937-1-git-send-email-mar.kolya@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: kadlec@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:56389 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3KHFbJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:31:09 -0500
Received: by mail-vb0-f53.google.com with SMTP id i11so1063209vbh.40
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2013 21:31:08 -0800 (PST)
In-Reply-To: <1383194071-25937-1-git-send-email-mar.kolya@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

  I've sent this patch for ipset some time ago. It fixes a bug that
surfaces itself on some platforms (notably on mips routers running
openwrt). Unfortunately I have not seen any feedback/response to this
patch. Is something wrong with the proposed fix or with patch itself?
Could you please let me know.

  Thanks!

2013/10/31 Nikolay Martynov <mar.kolya@gmail.com>:
> Currently it is impossible to set timeout on some architectures
> (MIPS ar71xx at least) because timeout is parsed into long long data
> type but used as uint32 without proper conversion. This patch fixes
> this issue. Tested on ar71xx router.
>
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
> ---
>  lib/parse.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/lib/parse.c b/lib/parse.c
> index 8ea8542..440ef8f 100644
> --- a/lib/parse.c
> +++ b/lib/parse.c
> @@ -1292,15 +1292,20 @@ ipset_parse_timeout(struct ipset_session *session,
>                     enum ipset_opt opt, const char *str)
>  {
>         int err;
> -       unsigned long long num = 0;
> +       unsigned long long llnum = 0;
> +       uint32_t num = 0;
>
>         assert(session);
>         assert(opt == IPSET_OPT_TIMEOUT);
>         assert(str);
>
> -       err = string_to_number_ll(session, str, 0, UINT_MAX/1000, &num);
> -       if (err == 0)
> +       err = string_to_number_ll(session, str, 0, UINT_MAX/1000, &llnum);
> +       if (err == 0) {
> +               /* Timeout is expected to be 32bits wide, so we have
> +                  to convert it here */
> +               num = llnum;
>                 return ipset_session_data_set(session, opt, &num);
> +       }
>
>         return err;
>  }
> --
> Thanks.
> Nikolay.
>



-- 
Martynov Nikolay.
Email: mar.kolya@gmail.com
