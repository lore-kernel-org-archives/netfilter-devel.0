From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf-next/nf_tables8] Unable to compile kernel
Date: Mon, 18 Feb 2013 22:00:58 +0100
Message-ID: <CAOkSjBiXdiaDTUdOH2HnHWmyqRpX_-+hXWh8Q_-13oe20c2ZaA@mail.gmail.com>
References: <CAOkSjBh78knOWQLmFnz+XyW4umVVnVVkWs9VeYPJdzhxg3T_fg@mail.gmail.com>
 <20130218165952.GA19904@localhost> <CAOkSjBjHQhgM0SB7cnXKpZ03nNvdK8NCVyUf+Po-jopOViAQvw@mail.gmail.com>
 <CAOkSjBhL6hgA8fHxE+W3yTLnXMfJja24JjLJSvbbfg2wC0rt8w@mail.gmail.com>
 <20130218172843.GA29465@localhost> <CAOkSjBiKh399=YO4U=mAOz9ACuBidDWWa3CHhEQO4QtZ15AQ7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:64246 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3BRVBX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 16:01:23 -0500
Received: by mail-la0-f54.google.com with SMTP id gw10so5919516lab.27
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Feb 2013 13:01:21 -0800 (PST)
In-Reply-To: <CAOkSjBiKh399=YO4U=mAOz9ACuBidDWWa3CHhEQO4QtZ15AQ7A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/2/18 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>:
> 2013/2/18 Pablo Neira Ayuso <pablo@netfilter.org>:
>>
>> $ git clone git://1984.lsi.us.es/nftables.git
>> Cloning into 'nftables'...
>> Remote: Counting objects: 75738
>>
>> Should be working now.

Same problem again on brach "nftables" of sources
http://1984.lsi.us.es/git/nftables/

  CC      init/version.o
  LD      init/built-in.o
net/built-in.o: In function `nft_exthdr_eval':
/home/aborrero/git/nftables/net/netfilter/nft_exthdr.c:37: undefined
reference to `ipv6_find_hdr'
net/built-in.o: In function `nft_set_pktinfo_ipv6':
/home/aborrero/git/nftables/include/net/netfilter/nf_tables_ipv6.h:18:
undefined reference to `ipv6_find_hdr'
/home/aborrero/git/nftables/include/net/netfilter/nf_tables_ipv6.h:18:
undefined reference to `ipv6_find_hdr'
/home/aborrero/git/nftables/include/net/netfilter/nf_tables_ipv6.h:18:
undefined reference to `ipv6_find_hdr'
make[2]: *** [vmlinux] Error 1
make[1]: *** [deb-pkg] Error 2

With .config:

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=3Dm
CONFIG_NF_CONNTRACK_IPV6=3Dm
CONFIG_NF_TABLES_IPV6=3Dy
CONFIG_NFT_CHAIN_ROUTE_IPV6=3Dy
CONFIG_NFT_CHAIN_NAT_IPV6=3Dm
CONFIG_IP6_NF_IPTABLES=3Dm
CONFIG_IP6_NF_MATCH_AH=3Dm
CONFIG_IP6_NF_MATCH_EUI64=3Dm
CONFIG_IP6_NF_MATCH_FRAG=3Dm
CONFIG_IP6_NF_MATCH_OPTS=3Dm
CONFIG_IP6_NF_MATCH_HL=3Dm
CONFIG_IP6_NF_MATCH_IPV6HEADER=3Dm
CONFIG_IP6_NF_MATCH_MH=3Dm
CONFIG_IP6_NF_MATCH_RPFILTER=3Dm
CONFIG_IP6_NF_MATCH_RT=3Dm
CONFIG_IP6_NF_TARGET_HL=3Dm
CONFIG_IP6_NF_FILTER=3Dm
CONFIG_IP6_NF_TARGET_REJECT=3Dm
CONFIG_IP6_NF_MANGLE=3Dm
CONFIG_IP6_NF_RAW=3Dm
CONFIG_IP6_NF_SECURITY=3Dm
CONFIG_NF_NAT_IPV6=3Dm
CONFIG_IP6_NF_TARGET_MASQUERADE=3Dm
CONFIG_IP6_NF_TARGET_NPT=3Dm

any idea?

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
