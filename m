From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack tuple
Date: Sat, 15 Sep 2012 23:14:50 +0200
Message-ID: <20120915211450.GA11216@1984>
References: <CA+Z0r8Mg3X8LQF0Y-kODT+SGgYuOm7FwwWWZoz5R+XP=vFLRLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Miguel Alejandro =?iso-8859-1?Q?Gonz=E1lez?= <maggonzz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51337 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab2IOVOz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Sep 2012 17:14:55 -0400
Content-Disposition: inline
In-Reply-To: <CA+Z0r8Mg3X8LQF0Y-kODT+SGgYuOm7FwwWWZoz5R+XP=vFLRLQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Sep 14, 2012 at 09:57:36AM -0500, Miguel Alejandro Gonz=E1lez w=
rote:
> Hello
>=20
> I have some questions about how conntrack tuple handles ICMP error me=
ssages...
>=20
> When a ICMP error packet arrives containing an embedded UDP or TCP
> packet, assuming there was already a UDP or TCP connection being
> tracked by conntrack, what are the IP addresses of the tuple, the one=
s
> from the ICMP error message or the ones from the embedded packet?

It uses inner headers of the ICMP error message, ie. "the ones from
the embedded packet".

See net/ipv4/netfilter/nf_conntrack_proto_icmp.c

> Also does the tuple saves port information in this case as well as ic=
mp
> type and code?

Conntrack does not save any ICMP error information.

> How does conntrack know that ICMP error message is related to an
> existing connection?

The conntrack code looks up for some existing entry by using the
information in the inner headers of the ICMP error message.

If no entry is found, the packet is considered invalid, and you can
drop it with iptables ... -m state --state INVALID
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
