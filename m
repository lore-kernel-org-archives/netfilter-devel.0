From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH 2/3] src: add xt compat support
Date: Fri, 27 Mar 2015 13:59:31 +0100
Message-ID: <CAOkSjBivXDdt7S4=iPVJT0cubNFML2UeBgRQjecSr_XucDYDAg@mail.gmail.com>
References: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
 <20150325191602.13491.63370.stgit@nfdev2.cica.es> <20150325194441.GA26737@salvia>
 <CAOkSjBivwzs8X+y1PRqG8-hg4b-0QQ_NXfJ38YoT9V05vt7Bag@mail.gmail.com> <20150327123139.GA10614@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:33328 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbbC0M7x convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 08:59:53 -0400
Received: by labto5 with SMTP id to5so69885696lab.0
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2015 05:59:52 -0700 (PDT)
In-Reply-To: <20150327123139.GA10614@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27 March 2015 at 13:31, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> On Fri, Mar 27, 2015 at 01:00:37PM +0100, Arturo Borrero Gonzalez wro=
te:
>> On 25 March 2015 at 20:44, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
>> > On Wed, Mar 25, 2015 at 08:16:02PM +0100, Arturo Borrero Gonzalez =
wrote:
>> >> diff --git a/include/xt.h b/include/xt.h
>> >> new file mode 100644
>> >> index 0000000..414f3d1
>> >> --- /dev/null
>> >> +++ b/include/xt.h
>> >> @@ -0,0 +1,100 @@
>> >> +#ifndef _NFT_XT_H_
>> >> +#define _NFT_XT_H_
>> >> +
>> >> +#include <arpa/inet.h>
>> >> +#include <netinet/in.h>
>> >> +#include <limits.h>
>> >> +#include <net/if.h>
>> >> +#include <net/ethernet.h>
>> >> +
>> >> +struct netlink_linearize_ctx;
>> >> +struct netlink_parse_ctx;
>> >> +struct nft_rule_expr;
>> >> +struct rule_pp_ctx;
>> >> +struct rule;
>> >> +
>> >> +#ifdef HAVE_LIBXTABLES
>> >> +
>> >> +#include <linux/netfilter_ipv4/ip_tables.h>
>> >> +#include <linux/netfilter_ipv6/ip6_tables.h>
>> >> +#include <linux/netfilter_arp/arp_tables.h>
>> >> +
>> >> +/* Fake ebt_entry */
>> >> +struct ebt_entry {
>> >
>> > I think you can avoid this if you:
>> >
>> > #include <linux/netfilter_bridge/ebtables.h>
>> >
>>
>> Can't include <linux/netfilter_bridge/ebtables.h> because it include=
s
>> <linux/if.h> and clash with <net/if.h>
>
> There must be a clean way to fix this without embedding the ebt_entry
> structure.
>

We seem to have the same problem in ebtables-compat:

http://git.netfilter.org/iptables/tree/iptables/nft-bridge.h#n32
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
