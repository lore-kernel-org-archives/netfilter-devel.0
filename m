From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next/nf_tables8] Unable to compile kernel
Date: Mon, 18 Feb 2013 23:08:03 +0100
Message-ID: <20130218220803.GA30353@localhost>
References: <CAOkSjBh78knOWQLmFnz+XyW4umVVnVVkWs9VeYPJdzhxg3T_fg@mail.gmail.com>
 <20130218165952.GA19904@localhost>
 <CAOkSjBjHQhgM0SB7cnXKpZ03nNvdK8NCVyUf+Po-jopOViAQvw@mail.gmail.com>
 <CAOkSjBhL6hgA8fHxE+W3yTLnXMfJja24JjLJSvbbfg2wC0rt8w@mail.gmail.com>
 <20130218172843.GA29465@localhost>
 <CAOkSjBiKh399=YO4U=mAOz9ACuBidDWWa3CHhEQO4QtZ15AQ7A@mail.gmail.com>
 <CAOkSjBiXdiaDTUdOH2HnHWmyqRpX_-+hXWh8Q_-13oe20c2ZaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:20194 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756771Ab3BRWII (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 17:08:08 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBiXdiaDTUdOH2HnHWmyqRpX_-+hXWh8Q_-13oe20c2ZaA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 18, 2013 at 10:00:58PM +0100, Arturo Borrero Gonzalez wrote=
:
> 2013/2/18 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>:
> > 2013/2/18 Pablo Neira Ayuso <pablo@netfilter.org>:
> >>
> >> $ git clone git://1984.lsi.us.es/nftables.git
> >> Cloning into 'nftables'...
> >> Remote: Counting objects: 75738
> >>
> >> Should be working now.
>=20
> Same problem again on brach "nftables" of sources
> http://1984.lsi.us.es/git/nftables/
>=20
>   CC      init/version.o
>   LD      init/built-in.o
> net/built-in.o: In function `nft_exthdr_eval':
> /home/aborrero/git/nftables/net/netfilter/nft_exthdr.c:37: undefined
> reference to `ipv6_find_hdr'
> net/built-in.o: In function `nft_set_pktinfo_ipv6':
> /home/aborrero/git/nftables/include/net/netfilter/nf_tables_ipv6.h:18=
:
> undefined reference to `ipv6_find_hdr'
> /home/aborrero/git/nftables/include/net/netfilter/nf_tables_ipv6.h:18=
:
> undefined reference to `ipv6_find_hdr'
> /home/aborrero/git/nftables/include/net/netfilter/nf_tables_ipv6.h:18=
:
> undefined reference to `ipv6_find_hdr'
> make[2]: *** [vmlinux] Error 1
> make[1]: *** [deb-pkg] Error 2
>=20
> With .config:
>=20
> #
> # IPv6: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV6=3Dm
> CONFIG_NF_CONNTRACK_IPV6=3Dm
> CONFIG_NF_TABLES_IPV6=3Dy
                       ^^
Please, try: CONFIG_NF_TABLES_IPV6=3Dm

I don't see CONFIG_NFT_EXTHDR, make sure it's also =3Dm.

This problem will be fixed once nftables is upon 3.8 (currently is
based upon 3.7) with this patch:

commit f8f626754ebeca613cf1af2e6f890cfde0e74d5b
Author: Jesse Gross <jesse@nicira.com>
Date:   Fri Nov 9 17:05:07 2012 -0800

    ipv6: Move ipv6_find_hdr() out of Netfilter code.

So using =3Dm as workaround by now should be just fine.

Please, pass me your full .config in case you still hit problem so I
can reproduce it here.

Thanks.

> CONFIG_NFT_CHAIN_ROUTE_IPV6=3Dy
> CONFIG_NFT_CHAIN_NAT_IPV6=3Dm
> CONFIG_IP6_NF_IPTABLES=3Dm
> CONFIG_IP6_NF_MATCH_AH=3Dm
> CONFIG_IP6_NF_MATCH_EUI64=3Dm
> CONFIG_IP6_NF_MATCH_FRAG=3Dm
> CONFIG_IP6_NF_MATCH_OPTS=3Dm
> CONFIG_IP6_NF_MATCH_HL=3Dm
> CONFIG_IP6_NF_MATCH_IPV6HEADER=3Dm
> CONFIG_IP6_NF_MATCH_MH=3Dm
> CONFIG_IP6_NF_MATCH_RPFILTER=3Dm
> CONFIG_IP6_NF_MATCH_RT=3Dm
> CONFIG_IP6_NF_TARGET_HL=3Dm
> CONFIG_IP6_NF_FILTER=3Dm
> CONFIG_IP6_NF_TARGET_REJECT=3Dm
> CONFIG_IP6_NF_MANGLE=3Dm
> CONFIG_IP6_NF_RAW=3Dm
> CONFIG_IP6_NF_SECURITY=3Dm
> CONFIG_NF_NAT_IPV6=3Dm
> CONFIG_IP6_NF_TARGET_MASQUERADE=3Dm
> CONFIG_IP6_NF_TARGET_NPT=3Dm
>=20
> any idea?
>=20
> --=20
> Arturo Borrero Gonz=E1lez
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
