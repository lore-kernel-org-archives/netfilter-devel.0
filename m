From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [net-next] socket: Added 'transparent' option
Date: Thu, 04 Jun 2009 15:33:31 +0200
Message-ID: <4A27CD2B.9060105@balabit.hu>
References: <1244119045-10614-1-git-send-email-panther@balabit.hu> <1244119045-10614-2-git-send-email-panther@balabit.hu> <alpine.LSU.2.00.0906041443050.6111@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:44917 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756255AbZFDNdc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:33:32 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 2A97F13A13C
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2009 15:33:33 +0200 (CEST)
In-Reply-To: <alpine.LSU.2.00.0906041443050.6111@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-06-04 14:37, Laszlo Attila Toth wrote:
>> +
>> +		if (check_transparent);
>> +			info =3D par->matchinfo;
>=20
> That's a definite =E2=80=9Cwhoops in coding=E2=80=9D there with that =
trailing ;.
> Wanna buy a `make C=3D1`? :-)

Thanks. I tried make C=3D1 but this mistake wasn't noticed by sparse...


--=20
Attila
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
