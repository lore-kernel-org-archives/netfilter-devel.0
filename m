From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: extensions: libxt_multiport: Multiport translations
Date: Sat, 5 Mar 2016 13:42:11 +0100
Message-ID: <20160305124211.GA2676@salvia>
References: <CAKrM2X=PyBuF=ZrNkBFoTB4m+7pr15WUC_AahYn+x9wwf5Eibg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: ppang@linux.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48612 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbcCEMmV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2016 07:42:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A46C87400
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Mar 2016 13:42:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 94FACDA388
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Mar 2016 13:42:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9A1D8DA8F9
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Mar 2016 13:42:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKrM2X=PyBuF=ZrNkBFoTB4m+7pr15WUC_AahYn+x9wwf5Eibg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 03, 2016 at 06:02:41PM +0000, Piyush Pangtey wrote:
> Added multiport translations for ipv4 only .
> It's for review pupose only , it definitely needs changes .
> 
> example :
> iptables-translate -A INPUT -p tcp -m multiport --dports 22,http,ssh -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp dport  { 22,80,22 } counter accept
> 
> diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
> index 03af5a9..6b46f93 100644
> --- a/extensions/libxt_multiport.c
> +++ b/extensions/libxt_multiport.c
> @@ -468,6 +468,67 @@ static void multiport_save6_v1(const void *ip_void,
>      __multiport_save_v1(match, ip->proto);
>  }
> 
> +static int multiport_xlate(const struct xt_entry_match *match, struct
> xt_xlate *xl,
> +             int numeric)
> +{
> +    const struct xt_multiport_v1 *multiinfo
> +        = (const struct xt_multiport_v1 *)match->data;

The = should be on the first line, ie.

        const struct xt_multiport_v1 *multiinfo =
                (const struct xt_multiport_v1 *)match->data;

> +    unsigned int i;
   ^^^^
I see spaces here, there should be an 8-chars tab indentation there.

Please, make sure coding style is correct.

> +    switch (multiinfo->flags) {
> +    case XT_MULTIPORT_SOURCE:
> +        xt_xlate_add(xl,"sport ");
                           ^
                          add space after comma

> +        break;
> +

No need for this extra line break;

> +    case XT_MULTIPORT_DESTINATION:
> +        xt_xlate_add(xl,"dport ");
> +        break;
> +
> +    default:
> +        return 1;
> +    }
> +    xt_xlate_add(xl," { ");
> +    for (i=0; i < multiinfo->count; i++) {
             ^
add space betwen variable and value, ie.

        i = 0

this is preferred.

> +        xt_xlate_add(xl,"%u%s", multiinfo->ports[i],
> +                (i+1) != multiinfo->count ? "," : "");

Align this line with the parens:

        xt_xlate_add(xl,"%u%s", multiinfo->ports[i],
                    i + 1 != multiinfo->count ? "," : "");

