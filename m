From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nft 0/6] flow statement
Date: Tue, 10 Nov 2015 18:23:45 +0000
Message-ID: <20151110182344.GD25929@macbook.localdomain>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
 <20151110165156.GA3227@salvia>
 <CAJO99TnH43njpQ-5wO7Ar6jytmqzF4Y2wCr+DNhTWr7_MgtR8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:61962 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752774AbbKJSXt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Nov 2015 13:23:49 -0500
Content-Disposition: inline
In-Reply-To: <CAJO99TnH43njpQ-5wO7Ar6jytmqzF4Y2wCr+DNhTWr7_MgtR8g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.11, Bj=F8rnar Ness wrote:
> System hangs here if I do the following:
>=20
> add a flow table
>=20
> list flowtable, cant make nft list flow table work, so do nft list se=
t
> filter test
>=20
> flush rules and change flowtable concat, for example adding . ip sadd=
r
>=20
> everything seemingly fine this far, but if I now list set filter test=
,
> system becomes
> unresponsive, and a boot seems needed.

Please provide the exact commands you used.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
