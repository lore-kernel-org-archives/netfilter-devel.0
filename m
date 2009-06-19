From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: About libnetfilter_queue
Date: Fri, 19 Jun 2009 15:52:54 +0200
Message-ID: <4A3B9836.9010607@netfilter.org>
References: <20090618144650.GL14944@finnois.psycho-hazard.net> <alpine.LSU.2.00.0906191458570.18418@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?B?R8OpcmFsZCBDb2xhbmdlbG8=?= <binarym@psycho-hazard.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39775 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbZFSNxF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:53:05 -0400
In-Reply-To: <alpine.LSU.2.00.0906191458570.18418@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> bounce nf-dev
>=20
> On Thursday 2009-06-18 16:46, G=C3=A9rald Colangelo wrote:
>=20
>> Hi guy,
>>
>> I wrote you today since i noticed you're contributing regulary to th=
e
>> netfilter-devel list ...
>> Since the trafic is quiet huge, i unsubscribe, but i want to pass an
>> information i discovered while coding ...
>> If you init all the libnetfilter_queue stuff and then, setuid(!0), t=
hen you
>> won't be able to send packet, the kernel drops it silently ...

You still have to keep CAP_NET_ADMIN to make it. And you should get
EPERM when sending packets.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
