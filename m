From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCHv2] extensions: libipt_icmp: Add translation to nft
Date: Mon, 7 Mar 2016 23:40:08 +0530
Message-ID: <CAKHNQQFQvt1j_+HW659VsD3TVJkaBV4q29MyrN_HHkz-NYmDGw@mail.gmail.com>
References: <20160306222442.GA20945@sonyv> <20160307171408.GB29573@salvia> <20160307180445.GA22851@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Laura Garcia <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:32897 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbcCGSKs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 13:10:48 -0500
Received: by mail-ob0-f176.google.com with SMTP id fz5so113176407obc.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2016 10:10:48 -0800 (PST)
In-Reply-To: <20160307180445.GA22851@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 7, 2016 at 11:34 PM, Laura Garcia <nevola@gmail.com> wrote:
> On Mon, Mar 07, 2016 at 06:14:08PM +0100, Pablo Neira Ayuso wrote:
>> On Sun, Mar 06, 2016 at 11:24:44PM +0100, Laura Garcia Liebana wrote:
>> > Add translation for icmp to nftables. Not supported types in nftables
>> > are: any, network-unreachable, host-unreachable, protocol-unreachable,
>> > port-unreachable, fragmentation-needed, source-route-failed,
>> > network-unknown, host-unknown, network-prohibited, host-prohibited,
>> > TOS-network-unreachable, TOS-host-unreachable, communication-prohibited,
>> > host-precedence-violation, precedence-cutoff, network-redirect,
>> > host-redirect, TOS-network-redirect, TOS-host-redirect,
>> > router-advertisement, router-solicitation, ttl-zero-during-transit,
>> > ttl-zero-during-reassembly, ip-header-bad and required-option-missing.
>> >
>> > Examples:
>> >
>> > $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type echo-reply -j LOG
>> > nft add rule ip filter INPUT icmp type echo-reply counter log level warn
>> >
>> > $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j LOG
>> > nft add rule ip filter INPUT icmp type destination-unreachable counter log level warn
>> >
>> > $ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j LOG
>> > nft add rule ip filter INPUT icmp type != destination-unreachable counter log level warn
>> >
>> > Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
>> > ---
>> > v2:
>> >     - Detection of not supported types in nftables, as Shivani suggested.
>> >
>> >  extensions/libipt_icmp.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
>> >  1 file changed, 45 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
>> > index 666e7da..89eb36e 100644
>> > --- a/extensions/libipt_icmp.c
>> > +++ b/extensions/libipt_icmp.c
>> > @@ -218,7 +218,7 @@ static void print_icmptype(uint8_t type,
>> >  }
>> >
>> >  static void icmp_print(const void *ip, const struct xt_entry_match *match,
>> > -                       int numeric)
>> > +                  int numeric)
>> >  {
>> >     const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
>> >
>> > @@ -249,6 +249,49 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
>> >     }
>> >  }
>> >
>> > +static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
>> > +                        unsigned int code_min, unsigned int code_max)
>> > +{
>> > +   unsigned int i;
>> > +
>> > +   if (code_min == code_max)
>> > +           return 0;
>> > +
>> > +   switch (icmptype) {
>> > +   case 0xFF:
>> > +   case 9:
>> > +   case 10:
>>
>> Why are we skipping these here?
>>
>
> These are types which doesn't seem to be supported by nftables: any,
> router-advertisement and router-solicitation, so in this case we would
> return a 0 in order to indicate that the translation is not supported.
>
>> > +           return 0;
>> > +   default:
>> > +           for (i = 0; ARRAY_SIZE(icmp_codes); ++i)
>>
>> Missing bracket here.
>>
>> > +                   if (icmp_codes[i].type == icmptype &&
>> > +                       icmp_codes[i].code_min == code_min &&
>> > +                       icmp_codes[i].code_max == code_max)
>> > +                           break;
>> > +
>> > +                   xt_xlate_add(xl, icmp_codes[i].name);
>>
>> Same thing. But as I said in the previous patch, are you sure you need
>> this code snippet above at this stage?
>>
>
> The brackets are not missing here, sorry for the confusion. Inside the for
> statement we only have the condition. Just the xt_late_add function indentation is not correct.
>
> This code it's needed in order to translate from types numbers to type
> names, but we're ensuring after that which types names are similar in
> iptables and nftables. For example, with this code we get:
>
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j LOG
> nft add rule ip filter INPUT icmp type destination-unreachable counter log level warn
>
> Without this code:
>
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j LOG
> nft add rule ip filter INPUT icmp type 3 counter log level warn
>
This looks good too. nftables is anyway going to convert it to its
name type (if available). See how this above rule shows up in the
chain:

table ip filter {
    chain INPUT {
        type filter hook input priority 0; policy accept;
        icmp type destination-unreachable counter packets 0 bytes 0 log
    }
}

But, anyway, wait for Pablo's comments about this.

>
>> > +   }
>> > +
>> > +   return 1;
>> > +}
>> > +
>> > +static int icmp_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
>> > +                  int numeric)
>> > +{
>> > +   const struct ipt_icmp *info = (struct ipt_icmp *)match->data;
>> > +
>> > +   xt_xlate_add(xl, "icmp type%s ",
>> > +                (info->invflags & IPT_ICMP_INV) ? " !=" : "");
>> > +
>> > +   if (!type_xlate_print(xl, info->type, info->code[0], info->code[1]))
>> > +           return 0;
>> > +
>> > +   xt_xlate_add(xl, " ");
>> > +
>> > +   return 1;
>> > +}
>> > +
>> > +
>> >  static struct xtables_match icmp_mt_reg = {
>> >     .name           = "icmp",
>> >     .version        = XTABLES_VERSION,
>> > @@ -261,6 +304,7 @@ static struct xtables_match icmp_mt_reg = {
>> >     .save           = icmp_save,
>> >     .x6_parse       = icmp_parse,
>> >     .x6_options     = icmp_opts,
>> > +   .xlate          = icmp_xlate,
>> >  };
>> >
>> >  void _init(void)
>> > --
>> > 2.7.0
>> >
