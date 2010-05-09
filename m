From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Document --state UNTRACKED
Date: Mon, 10 May 2010 01:03:07 +0200
Message-ID: <4BE73F2B.1080207@netfilter.org>
References: <201005040832.00376.simonl@parknet.dk> <4BDFED86.5000408@plouf.fr.eu.org> <201005041205.47747.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	netfilter-devel@vger.kernel.org
To: Simon Lodal <simonl@parknet.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42324 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab0EIXDO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 May 2010 19:03:14 -0400
In-Reply-To: <201005041205.47747.simonl@parknet.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Simon Lodal wrote:
> Tirsdag 04 maj 2010 11:48:54 skrev Pascal Hambourg:
>> Hello,
>>
>> Simon Lodal a =E9crit :
>>> +.B UNTRACKED
>>> +meaning that the packet is not tracked at all, which happens if yo=
u use
>>> +the NOTRACK target in mangle table.
>> s/mangle/raw/
>=20
> Can't believe i wrote that, thanks.
>=20
> Signed-off-by: Simon Lodal <simonl@parknet.dk>

Applied, thanks everyone.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
