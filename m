From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH 2/3] src: add xt compat support
Date: Fri, 27 Mar 2015 13:00:37 +0100
Message-ID: <CAOkSjBivwzs8X+y1PRqG8-hg4b-0QQ_NXfJ38YoT9V05vt7Bag@mail.gmail.com>
References: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
 <20150325191602.13491.63370.stgit@nfdev2.cica.es> <20150325194441.GA26737@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33408 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbbC0MA7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 08:00:59 -0400
Received: by lbcmq2 with SMTP id mq2so61853400lbc.0
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2015 05:00:58 -0700 (PDT)
In-Reply-To: <20150325194441.GA26737@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25 March 2015 at 20:44, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> On Wed, Mar 25, 2015 at 08:16:02PM +0100, Arturo Borrero Gonzalez wro=
te:
>> diff --git a/include/xt.h b/include/xt.h
>> new file mode 100644
>> index 0000000..414f3d1
>> --- /dev/null
>> +++ b/include/xt.h
>> @@ -0,0 +1,100 @@
>> +#ifndef _NFT_XT_H_
>> +#define _NFT_XT_H_
>> +
>> +#include <arpa/inet.h>
>> +#include <netinet/in.h>
>> +#include <limits.h>
>> +#include <net/if.h>
>> +#include <net/ethernet.h>
>> +
>> +struct netlink_linearize_ctx;
>> +struct netlink_parse_ctx;
>> +struct nft_rule_expr;
>> +struct rule_pp_ctx;
>> +struct rule;
>> +
>> +#ifdef HAVE_LIBXTABLES
>> +
>> +#include <linux/netfilter_ipv4/ip_tables.h>
>> +#include <linux/netfilter_ipv6/ip6_tables.h>
>> +#include <linux/netfilter_arp/arp_tables.h>
>> +
>> +/* Fake ebt_entry */
>> +struct ebt_entry {
>
> I think you can avoid this if you:
>
> #include <linux/netfilter_bridge/ebtables.h>
>

Can't include <linux/netfilter_bridge/ebtables.h> because it includes
<linux/if.h> and clash with <net/if.h>

I will put a comment in the code.

>
>> +                                    struct stmt *stmt, struct rule =
*rule) {}
>> +
>> +#endif /* HAVE_LIBXTABLES */
>> +
>> +#endif /* _NFT_XT_H_ */
>> +xt_opts                      :       /* empty */     { $$ =3D NULL;=
 }
>> +                     |       XTOPTS          { $$ =3D $1; }
>> +                     ;
>> +
>> +xt_name                      :       STRING          { $$ =3D $1; }
>> +                     |       STATE           { $$ =3D xstrdup("stat=
e"); }
>> +                     |       COMMENT         { $$ =3D xstrdup("comm=
ent"); }
>> +                     |       AH              { $$ =3D xstrdup("ah")=
; }
>> +                     |       ESP             { $$ =3D xstrdup("esp"=
); }
>> +                     |       TCP             { $$ =3D xstrdup("tcp"=
); }
>> +                     |       UDP             { $$ =3D xstrdup("udp"=
); }
>> +                     |       UDPLITE         { $$ =3D xstrdup("udpl=
ite"); }
>> +                     |       SCTP            { $$ =3D xstrdup("sctp=
"); }
>> +                     |       ICMP            { $$ =3D xstrdup("icmp=
"); }
>> +                     |       IP              { $$ =3D xstrdup("ip")=
; }
>> +                     |       VLAN            { $$ =3D xstrdup("vlan=
"); }
>> +                     |       LOG             { $$ =3D xstrdup("log"=
); }
>> +                     |       _802_3          { $$ =3D xstrdup("802_=
3"); }
>
> This _802_3 should not be clashing with anything else, the problem is
> somewhere else.
>

% sudo nft add rule bridge filter FORWARD xt match 802_3 [--802_3-sap 0=
x01  ]
<cmdline>:1:41-43: Error: syntax error, unexpected number
add rule bridge filter FORWARD xt match 802_3 [--802_3-sap 0x01 ]
                                        ^^^

I have to admit I don't know where to look. Do you have any hint?
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
