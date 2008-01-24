From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [PATCH] Set default policy of chains in filter tables to DROP/ACCEPT
Date: Thu, 24 Jan 2008 15:51:48 +0100
Message-ID: <4798A604.8020308@balabit.hu>
References: <1201183885868-git-send-email-panther@balabit.hu> <4798A23C.5030904@trash.net>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:48222 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYAXOvu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:51:50 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 0F8A4C14E1
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jan 2008 15:51:49 +0100 (CET)
In-Reply-To: <4798A23C.5030904@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy =EDrta:
> Laszlo Attila Toth wrote:
>> Set the default policy of INPUT/FORWARD/OUTPUT chains of IPv4/IPv6 f=
ilter
>> tables to DROP or ACCEPT in kernel configuration. It can be override=
 by
>> a module parameter (defaultdrop for IPv4 and defaultdropv6 for IPv6)=
=2E
>=20
>=20
> Whats the point of this? You can simply execute the corresponding
> iptables commands early during boot ...

Yes, that's right. But in case of a security audit unfortunatelly it is=
=20
not enough, the only acceptable way is to set the policy to DROP. In ou=
r=20
kernel the default policy is DROP because of it.

--=20
Attila
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
