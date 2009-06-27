From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: About libnetfilter_queue
Date: Sat, 27 Jun 2009 23:18:10 +0200
Message-ID: <4A468C92.3010605@netfilter.org>
References: <20090618144650.GL14944@finnois.psycho-hazard.net> <alpine.LSU.2.00.0906191458570.18418@fbirervta.pbzchgretzou.qr> <4A3B9836.9010607@netfilter.org> <20090619141025.GU14944@finnois.psycho-hazard.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: =?ISO-8859-15?Q?G=E9rald_Colangelo?= <binarym@psycho-hazard.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47459 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbZF0VSQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Jun 2009 17:18:16 -0400
In-Reply-To: <20090619141025.GU14944@finnois.psycho-hazard.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

G=E9rald Colangelo wrote:
> On Fri, Jun 19, 2009 at 03:52:54PM +0200, Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>
>> You still have to keep CAP_NET_ADMIN to make it. And you should get
>> EPERM when sending packets.
>=20
> Ok, i didn't know for the CAP_NET_ADMIN.
> But i didn't get EPERM, nfq_set_verdict just returned me a value more=
 than
> 0... perhaps EPERM is stored in errno, but at least nfq_set_verdict()=
 reports
> success.

You're right. We're sending the netlink message to kernel-space without
the NLM_F_ACK flag set, that's why we don't get any error reporting
back. I'm going to look into this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
