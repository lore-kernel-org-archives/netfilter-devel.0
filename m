From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: concurrency problems in a netfilter target extension?
Date: Thu, 31 Jul 2008 10:39:56 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0807311039180.6855@fbirervta.pbzchgretzou.qr>
References: <4891C96A.20004@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Tobias Koeck <tobias.koeck@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54763 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbYGaOj7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:39:59 -0400
In-Reply-To: <4891C96A.20004@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-07-31 10:17, Tobias Koeck wrote:

> I=C2=B4m writing on a netfilter target extension.
>
> Are there some possible concurrency problems (means is it possible th=
at my
> target extension modules is loaded several times or could it be used =
with
> several cpu cores simultaniously)?

Yes, see "Writing your own Netfilter modules" at=20
http://jengelh.medozas.de/ , chapter "tricks and traps"
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
