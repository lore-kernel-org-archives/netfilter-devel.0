From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: kernel panic in icmp_error
Date: Thu, 4 Oct 2012 10:55:57 +0200
Message-ID: <20121004085557.GA27566@1984>
References: <CA+Z0r8NcZwtwk+GG-fKpwRMnLphpXSqpa0h1A=jJ_At7Remb_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Miguel Alejandro =?iso-8859-1?Q?Gonz=E1lez?= <maggonzz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45701 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965535Ab2JDI4G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:56:06 -0400
Content-Disposition: inline
In-Reply-To: <CA+Z0r8NcZwtwk+GG-fKpwRMnLphpXSqpa0h1A=jJ_At7Remb_g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 03, 2012 at 05:22:53PM -0500, Miguel Alejandro Gonz=E1lez w=
rote:
> Hello
>=20
> I'm making a Netfilter module that depends on conntrack, it has come
> to my attention that a kernel panic occurs when a ICMP error packet
> embedded inside another ICMP error packet in the function icmp_error(=
)
> in /ipv4/netfilter/nf_conntrack_proto_icmp.c

Can it be due to malformed packet? Do you have this patch in your kerne=
l?

commit 07153c6ec074257ade76a461429b567cff2b3a1e
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Tue Apr 3 22:02:01 2012 +0200

    netfilter: nf_ct_ipv4: packets with wrong ihl are invalid

> Is the function not prepared to receive this kind of packets or is
> this a bug? Will a kernel panic also happen in icmpv6_error() in
> ipv6/netfilter/nf_conntrack_proto_icmpv6.c??

I need more information, please post the kernel backtrace.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
