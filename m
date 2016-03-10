From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libipt_LOG: Avoid to print the default log
 level in the translation
Date: Fri, 11 Mar 2016 00:02:25 +0530
Message-ID: <CAKHNQQGPvSmQP9R3omAuo1hbnOHPrsWhxkmsB7npxKM97v++Fw@mail.gmail.com>
References: <20160310181537.GA16699@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34951 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbcCJSdG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 13:33:06 -0500
Received: by mail-ob0-f179.google.com with SMTP id fp4so89614099obb.2
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 10:33:05 -0800 (PST)
In-Reply-To: <20160310181537.GA16699@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 11:45 PM, Laura Garcia Liebana <nevola@gmail.com> wrote:
> Avoid to print the log level in the translation when the level is the
> default value.
>
> Example:
>
> $ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 10 -j LOG
> nft add rule ip filter INPUT icmp type != router-solicitation counter log
>

Looks good. Don't forget to send a patch for libip6t_LOG too.

Same is the case with reject as well. When I did the translations, I
left its default nature intact.
$ sudo ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT
nft add rule ip6 filter FORWARD tcp dport 22 counter reject with
icmpv6 type port-unreachable

Pablo, should this be corrected too?

Laura, may be you can send more patches depending on his response.

Thanks.

> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  extensions/libipt_LOG.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
> index f3875b6..216b1ca 100644
> --- a/extensions/libipt_LOG.c
> +++ b/extensions/libipt_LOG.c
> @@ -194,7 +194,8 @@ static int LOG_xlate(const struct xt_entry_target *target,
>                 xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
>
>         for (i = 0; i < ARRAY_SIZE(ipt_log_xlate_names); ++i)
> -               if (loginfo->level == ipt_log_xlate_names[i].level) {
> +               if (loginfo->level != LOG_DEFAULT_LEVEL &&
> +                   loginfo->level == ipt_log_xlate_names[i].level) {
>                         xt_xlate_add(xl, "level %s ",
>                                    ipt_log_xlate_names[i].name);
>                         break;
> --
> 2.7.0
>
