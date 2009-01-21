From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: 2.6.28(.1) and netlink: scheduling while atomic
Date: Wed, 21 Jan 2009 11:59:31 +0100
Message-ID: <49770013.4020807@netfilter.org>
References: <200901211029.01619.kgy@teledigit.hu> <4976F0EB.8050806@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42349 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754022AbZAUK7l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:59:41 -0500
In-Reply-To: <4976F0EB.8050806@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> K=F6vesdi Gy=F6rgy wrote:
>> The new netlink interface allows to add NAT directly to a conntrack
>> entry.
>> If it is used when the moudule nf-nat-ipv4 is not loaded in, it
>> results in crash:
>> BUG: scheduling while atomic
>> It is in the kernels 2.6.28 and 2.6.28.1 in the function
>> ctnetlink_parse_nat_setup(): it calls request_module() which causes
>> the problem. If the module is already loaded, then there is no probl=
em.
>=20
> Thanks for the report. Does this patch fix it?

Hm, this was introduced when we fixed the problem with race condition i=
n
the conntrack creation :( It would be worth to pass it to 2.6.29-rc.

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
