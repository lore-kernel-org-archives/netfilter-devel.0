From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] add systemd service file
Date: Sat, 21 Mar 2015 17:45:33 +0000
Message-ID: <20150321174532.GA16593@acer.localdomain>
References: <20150320105320.58266b67@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rg?= Thalheim <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47213 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbbCURph (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2015 13:45:37 -0400
Content-Disposition: inline
In-Reply-To: <20150320105320.58266b67@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20.03, J=F6rg Thalheim wrote:
> The last PATCH was rejected, because it has added an integration scri=
pt.
> This PATCH however only adds a service file, with no other dependency=
 but the
> userpace nft program.
>=20
> my motivation was the following:
>=20
> - Providing a service file upstream hopefully lead to consistent beha=
viour across distributions
> - The people, who know how to deal with nft, are usually the upstream=
 developer itself
> - The provided service should be reusable without any modification in=
 any distribution=20
>   and should preserve maintainers from reinventing the wheel all the =
time=20
>   (debian currently does not provide atomic reloading in sid for exam=
ple;=20
>   archlinux does, but it doesn't set ProtectSystem and ProtectHome)
>=20
> I hope you can agree with this. Thanks

I'm think this is a good idea. However I don't know much about systemd
myself so please take care of Jan's suggestions first.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
