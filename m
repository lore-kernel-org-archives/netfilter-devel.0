From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 07/07]: Use __u32 in struct nf_inet_addr
Date: Tue, 19 Feb 2008 18:15:08 +0100
Message-ID: <47BB0E9C.6060608@trash.net>
References: <20080219162532.13631.71318.sendpatchset@localhost.localdomain> <20080219162541.13631.48514.sendpatchset@localhost.localdomain> <Pine.LNX.4.64.0802191808540.26109@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:13025 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753783AbYBSRPY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:15:24 -0500
In-Reply-To: <Pine.LNX.4.64.0802191808540.26109@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Feb 19 2008 17:25, Patrick McHardy wrote:
>> [NETFILTER]: Use __u32 in struct nf_inet_addr
>>
>> As reported by David Woodhouse <dwmw2@infradead.org>, using u_int32_=
t in
>> struct nf_inet_addr breaks the busybox build. Fix by using __u32.
>=20
> ... that's why I say we should use uint32_t (with just one underscore=
),
> because that is available in userspace thorugh <stdint.h>,
> while u_int32_t is not (at first glance=B2).


As David explained, kernel headers shouldn't assume that userspace
has pulled in any of these typedefs and therefore should use
the kernel-internally defined types.

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
