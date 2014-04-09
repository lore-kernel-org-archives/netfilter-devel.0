From: Ana Rey <anarey@gmail.com>
Subject: Re: [libnftnl PATCH 1/3] ruleset: Add an end of line in the exit of ruleset.
Date: Wed, 9 Apr 2014 16:59:18 +0200
Message-ID: <CAD7o0sjWLOuBDQ+7bpndK7bKTENnc-Qw9kWphThnXL9BqJpG4w@mail.gmail.com>
References: <cover.1397032579.git.anarey@gmail.com> <15bbda6958ec01d0088c386537288dcfe1ad8731.1397032579.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:44972 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbaDIO7j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:59:39 -0400
Received: by mail-vc0-f180.google.com with SMTP id lf12so2228962vcb.11
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 07:59:38 -0700 (PDT)
In-Reply-To: <15bbda6958ec01d0088c386537288dcfe1ad8731.1397032579.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please, Fotget this patch.

2014-04-09 10:53 GMT+02:00 Ana Rey <anarey@gmail.com>:
> Add an end of line in the exit of ruleset.
>
> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
>  src/ruleset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/src/ruleset.c b/src/ruleset.c
> index 3cbec09..181aeae 100644
> --- a/src/ruleset.c
> +++ b/src/ruleset.c
> @@ -818,7 +818,7 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
>                 SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>         }
>
> -       ret = snprintf(buf+offset, size, "%s", nft_ruleset_o_closetag(type));
> +       ret = snprintf(buf+offset, size, "%s\n", nft_ruleset_o_closetag(type));
>         SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>
>         return offset;
> --
> 1.9.0
>



-- 
Ana Rey (@anaRB)
http://about.me/anarey
