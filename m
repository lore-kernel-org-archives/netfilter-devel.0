From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] Introduce nf_inet_address
Date: Mon, 17 Dec 2007 13:28:02 +0100
Message-ID: <47666B52.1050802@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070336010.1262@fbirervta.pbzchgretzou.qr> <475E639A.9040501@trash.net> <Pine.LNX.4.64.0712151300360.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56342 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbXLQM2r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:28:47 -0500
In-Reply-To: <Pine.LNX.4.64.0712151300360.22877@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 11 2007 11:16, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> A few netfilter modules provide their own union of IPv4 and IPv6
>>> address storage. Will unify that in this patch series.
>>>
>>> (1/4): Rename union nf_conntrack_address to union nf_inet_addr and
>>> move it to x_tables.h.
>> netfilter.h seems more appropriate for this than x_tables.h,
>> so I'll move it unless there are good reasons not to.
>>
>=20
> Userspace iptables does not seem to properly cope with it, though:
>=20
> In file included from /ws/linux-2.6/include/linux/netfilter_ipv4.h:8,
>                  from=20
> /ws/linux-2.6/include/linux/netfilter_ipv4/ip_tables.h:26,
>                  from include/libiptc/libiptc.h:6,
>                  from libiptc/libip4tc.c:29:
> /ws/linux-2.6/include/linux/netfilter.h:53: error: expected=20
> specifier-qualifier-list before =E2=80=98__be32=E2=80=99
> make: *** [libiptc/libip4tc.o] Error 1


Userspace has to deal with these types, they're already used
in many other structures. I've already added the necessary
defines or typedefs to the iptables headers some time ago.
We should probably just include <linux/types.h> to fix it
though. Could you give that a try?
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
