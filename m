From: Patrick McHardy <kaber@trash.net>
Subject: Re: pom: remove superseded patchlets
Date: Mon, 18 Jan 2010 08:02:37 +0100
Message-ID: <4B54078D.5000506@trash.net>
References: <alpine.LSU.2.01.1001162247110.4057@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Nicolas Bouliane <acidfu@netfilter.org>, max@nucleus.it,
	ole@ans.pl, frozenspot@gmail.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47469 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab0ARHCm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:02:42 -0500
In-Reply-To: <alpine.LSU.2.01.1001162247110.4057@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> People are still on the old trail. Another attempt at reducing the
> pitfalls with /svn/patch-o-matic-ng.
>=20
>=20
> ---=E2=9C=82---
> Remove patchlets that have been merged into Xtables-addons
>=20
> All deleted modules have either been merged upstream in the kernel,
> or merged into Xtables-addons with the authors' consent, and have
> been improved from there. We should not been offering outdated
> versions. It happens that people still run across this.

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
