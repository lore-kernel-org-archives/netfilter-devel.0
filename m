From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: About libnetfilter_queue
Date: Fri, 19 Jun 2009 14:59:22 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906191458570.18418@fbirervta.pbzchgretzou.qr>
References: <20090618144650.GL14944@finnois.psycho-hazard.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?G=C3=A9rald_Colangelo?= <binarym@psycho-hazard.net>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35959 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbZFSM7V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2009 08:59:21 -0400
In-Reply-To: <20090618144650.GL14944@finnois.psycho-hazard.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


bounce nf-dev

On Thursday 2009-06-18 16:46, G=C3=A9rald Colangelo wrote:

>Hi guy,
>
>I wrote you today since i noticed you're contributing regulary to the
>netfilter-devel list ...
>Since the trafic is quiet huge, i unsubscribe, but i want to pass an
>information i discovered while coding ...
>If you init all the libnetfilter_queue stuff and then, setuid(!0), the=
n you
>won't be able to send packet, the kernel drops it silently ...
>I've been looking for the solution for 5 days ! That's why i prefered =
telling
>you, and if you find this information useful, relay it to the list :)
>
>Regards,
>
>--=20
>G=C3=A9rald Colangelo=20
>binarym@psycho-hazard.net - http://www.yanluo.net
>
>Being a sysadmin means hours of hard labor every day.
>Being an abusive sysadmin means hours of fun.
>
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
