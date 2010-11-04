From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 04 Nov 2010 12:55:16 +0100
Message-ID: <4CD29F24.70804@plouf.fr.eu.org>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:64266 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0KDLzU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 07:55:20 -0400
In-Reply-To: <4CD21679.2070508@zytor.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

H. Peter Anvin a =E9crit :
> On 11/03/2010 06:52 PM, Jan Engelhardt wrote:
>> I take it you mean a setup where addresses are automatically assigne=
d
>> (DHCPv6, PPP).

6to4 with the prefix based on a variable IPv4 address, fail-over setup
using links with different prefixes...

> DHCPv6, PPP, RA, anything.

AFAIK PPP only assigns the IPv6 link local addresses so it is not an
issue, and the global prefix must be configured by other means such as
DHCPv6.

> Keep in mind that "expect prefix changes" is=20
> a deliberate part of the IPv6 systems design.

I have been using IPv6 for a few years now, and was not aware this was =
a
design feature. I know two ISPs here that provide IPv6, both assign a
fixed prefix. Also AFAIK IPv6 tunnel brokers assign fixed prefixes. In
my mind, "dynamic" does not necessarily mean "variable".

> Consider for example the case where I get from my ISP the netblock=20
> 2001:0db8:ac10::/48.  I subnet this internally with subnet numbers=20
> prefixed by /52 security domains, i.e 2001:0db8:ac10:0000::/52,=20
> 2001:0db8:ac10:1000::/52 and so forth.

/52 is quite unusual. AFAIK stateless autoconfiguration requires a
prefix length of /64.

> Accordingly, my ip6tables would=20
> contain rules as to what kind of traffic can flow between these prefi=
xes.
>
> Now, the upstream (ISP-assigned) prefix changes to 2001:6b2f:1705::/4=
8.=20
> RA will handle reassigning addresses to actual downstream hosts, but=20
> things that explicitly encode IPv6 addresses need to be changed, and=20
> that includes ip6tables, in this case these rules now need to refer t=
o=20
> 2001:6b2f:1705:0000::/52, 2001:62bf:1705:1000::/52 and so on.

Are you talking about rules on the router which subnets the block, or o=
n
downstream hosts ?
Also, is each subnet prefix on a separate link ?
Could you provide an example of such rules ?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
