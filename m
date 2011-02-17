From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix a flaw in printing the MAC
Date: Thu, 17 Feb 2011 16:24:13 +0100
Message-ID: <4D5D3D9D.2010503@trash.net>
References: <4D5D36B2.2090608@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"Schloegel, Robin" <robin.schloegel@secunet.com>
To: Joerg Marx <joerg.marx@secunet.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57397 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab1BQPYP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:24:15 -0500
In-Reply-To: <4D5D36B2.2090608@secunet.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17.02.2011 15:54, Joerg Marx wrote:
> The flaw was in skipping the second byte in MAC header due to increas=
ing
> the pointer AND indexed access starting at '1'.
>=20

Applied, thanks J=F6rg.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
