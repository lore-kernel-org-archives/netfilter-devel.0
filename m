From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: ftp: Remove the useless dlen==0
 condition check in find_pattern
Date: Thu, 1 Sep 2016 10:26:08 +0800
Message-ID: <CA+6hz4o5ZqQBEND62wK3QswZd-vi0ark9aJWbjrPL9d_Aq2-ZQ@mail.gmail.com>
References: <1472696057-15819-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@blackhole.kfki.hu,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:33591 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754393AbcIAC0K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2016 22:26:10 -0400
Received: by mail-ua0-f195.google.com with SMTP id a1so801088uaa.0
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2016 19:26:09 -0700 (PDT)
In-Reply-To: <1472696057-15819-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 1, 2016 at 10:14 AM,  <fgao@ikuai8.com> wrote:
> From: Gao Feng <fgao@ikuai8.com>
>
> The caller function "help" has already make sure the datalen could not be zero
> before invoke find_pattern as a parameter by the following codes
>
>         if (dataoff >= skb->len) {
>                 pr_debug("ftp: dataoff(%u) >= skblen(%u)\n", dataoff,
>                          skb->len);
>                 return NF_ACCEPT;
>         }
>         datalen = skb->len - dataoff;
>
> And the latter codes "ends_in_nl = (fb_ptr[datalen - 1] == '\n');" use datalen
> directly without checking if it is zero.
>
> So it is unneccessary to check it in find_pattern too.
>
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_conntrack_ftp.c | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
> index b6934b5..77f05ac 100644
> --- a/net/netfilter/nf_conntrack_ftp.c
> +++ b/net/netfilter/nf_conntrack_ftp.c
> @@ -301,8 +301,6 @@ static int find_pattern(const char *data, size_t dlen,
>         size_t i = plen;
>
>         pr_debug("find_pattern `%s': dlen = %Zu\n", pattern, dlen);
> -       if (dlen == 0)
> -               return 0;
>
>         if (dlen <= plen) {
>                 /* Short packet: try for partial? */
> @@ -312,16 +310,6 @@ static int find_pattern(const char *data, size_t dlen,
>         }
>
>         if (strncasecmp(data, pattern, plen) != 0) {
> -#if 0
> -               size_t i;
> -
> -               pr_debug("ftp: string mismatch\n");
> -               for (i = 0; i < plen; i++) {
> -                       pr_debug("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
> -                                i, data[i], data[i],
> -                                pattern[i], pattern[i]);
> -               }
> -#endif
>                 return 0;
>         }
>
> --
> 1.9.1
>
>

Sorry, I forget one point. I also remove some codes which are
commented out by #if0.

Regards
Feng
