From: =?iso-8859-15?Q?G=E9rald?= Colangelo <binarym@psycho-hazard.net>
Subject: Re: About libnetfilter_queue
Date: Fri, 19 Jun 2009 16:10:25 +0200
Message-ID: <20090619141025.GU14944@finnois.psycho-hazard.net>
References: <20090618144650.GL14944@finnois.psycho-hazard.net> <alpine.LSU.2.00.0906191458570.18418@fbirervta.pbzchgretzou.qr> <4A3B9836.9010607@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from finnois.psycho-hazard.net ([91.121.135.173]:2228 "EHLO
	finnois.psycho-hazard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZFSObe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:31:34 -0400
Content-Disposition: inline
In-Reply-To: <4A3B9836.9010607@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 19, 2009 at 03:52:54PM +0200, Pablo Neira Ayuso wrote:
> Jan Engelhardt wrote:
>=20
> You still have to keep CAP_NET_ADMIN to make it. And you should get
> EPERM when sending packets.

Ok, i didn't know for the CAP_NET_ADMIN.
But i didn't get EPERM, nfq_set_verdict just returned me a value more t=
han
0... perhaps EPERM is stored in errno, but at least nfq_set_verdict() r=
eports
success.

Regards,

--=20
G=E9rald Colangelo=20
binarym@psycho-hazard.net - http://www.yanluo.net

Being a sysadmin means hours of hard labor every day.
Being an abusive sysadmin means hours of fun.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
