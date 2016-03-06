From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libipt_icmp: Add translation to nft
Date: Sun, 6 Mar 2016 15:31:15 +0530
Message-ID: <CAKHNQQE7S-x63bez0qdhwujESbwqPHSftc_aMXHkHh=Y5amrZA@mail.gmail.com>
References: <20160305200039.GA14269@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34084 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbcCFKB4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Mar 2016 05:01:56 -0500
Received: by mail-oi0-f47.google.com with SMTP id m82so63436678oif.1
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Mar 2016 02:01:55 -0800 (PST)
In-Reply-To: <20160305200039.GA14269@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 6, 2016 at 1:30 AM, Laura Garcia Liebana <nevola@gmail.com> wrote:
> Add translation for icmp to nftables.
>
> Examples:
>
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type any -j LOG
> nft add rule ip filter INPUT icmp type any counter log level warn
>
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3/1 -j LOG
> nft add rule ip filter INPUT icmp type host-unreachable counter log level warn
>
> $ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j LOG
> nft add rule ip filter INPUT icmp type != destination-unreachable counter log level warn
>

Hi Laura,

There are some icmp types that nftables does not support, have you
tried adding up rules corresponding to all the packet types?

$ sudo nft add table filter
$ sudo nft add chain filter INPUT { type filter hook input priority 0\;}
$ sudo <your generated rule goes here>

Please consider finding out such packet types and mention about them
in commit message.
Same for icmpv6.

> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  extensions/libipt_icmp.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
>
> diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
> index 666e7da..795172f 100644
> --- a/extensions/libipt_icmp.c
> +++ b/extensions/libipt_icmp.c
> @@ -218,7 +218,7 @@ static void print_icmptype(uint8_t type,
>  }
>
>  static void icmp_print(const void *ip, const struct xt_entry_match *match,
> -                       int numeric)
> +                      int numeric)
>  {
>         const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
>
> @@ -249,6 +249,36 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
>         }
>  }
>
> +static void type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
> +                            unsigned int code_min, unsigned int code_max)
> +{
> +       unsigned int i;
> +
> +       for (i = 0; ARRAY_SIZE(icmp_codes); i++)

Also, here you are using the array icmp_codes, this will give out the
same packet names as iptables. But, some packet names are different in
nftables. May be not in case of icmp but in case of icmp6. Please have
a look at this.

Thanks.

> +               if (icmp_codes[i].type == icmptype &&
> +                   icmp_codes[i].code_min == code_min &&
> +                   icmp_codes[i].code_max == code_max)
> +                       break;
> +
> +       xt_xlate_add(xl, icmp_codes[i].name);
> +}
> +
> +static int icmp_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
> +                      int numeric)
> +{
> +       const struct ipt_icmp *info = (struct ipt_icmp *)match->data;
> +
> +       xt_xlate_add(xl, "icmp type%s ",
> +                    (info->invflags & IPT_ICMP_INV) ? " !=" : "");
> +
> +       type_xlate_print(xl, info->type, info->code[0], info->code[1]);
> +
> +       xt_xlate_add(xl, " ");
> +
> +       return 1;
> +}
> +
> +
>  static struct xtables_match icmp_mt_reg = {
>         .name           = "icmp",
>         .version        = XTABLES_VERSION,
> @@ -261,6 +291,7 @@ static struct xtables_match icmp_mt_reg = {
>         .save           = icmp_save,
>         .x6_parse       = icmp_parse,
>         .x6_options     = icmp_opts,
> +       .xlate          = icmp_xlate,
>  };
>
>  void _init(void)
> --
> 2.7.0
>
