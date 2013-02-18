From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf-next/nf_tables8] Unable to compile kernel
Date: Mon, 18 Feb 2013 18:04:43 +0100
Message-ID: <CAOkSjBjHQhgM0SB7cnXKpZ03nNvdK8NCVyUf+Po-jopOViAQvw@mail.gmail.com>
References: <CAOkSjBh78knOWQLmFnz+XyW4umVVnVVkWs9VeYPJdzhxg3T_fg@mail.gmail.com>
 <20130218165952.GA19904@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f42.google.com ([209.85.212.42]:64709 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3BRRFF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:05:05 -0500
Received: by mail-vb0-f42.google.com with SMTP id ff1so567847vbb.15
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Feb 2013 09:05:03 -0800 (PST)
In-Reply-To: <20130218165952.GA19904@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/2/18 Pablo Neira Ayuso <pablo@netfilter.org>:
> Did you enable IP6_NF_IPTABLES in .config? That function is defined
> there. That dependency will be removed since that function now belong=
s
> to the ipv6 core since recently.
>

This is an excerpt of my .config

Shall I change something?

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



> BTW, please use this tree:
>
> http://1984.lsi.us.es/git/nftables/

I'm to use 'nftables' branch. Is this correct?

Regards.


--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
