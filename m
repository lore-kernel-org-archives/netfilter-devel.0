From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft compat layer
Date: Sat, 16 Jan 2016 20:11:14 +0000
Message-ID: <20160116201113.GA13076@macbook.localdomain>
References: <CAOkSjBhpqYQ01xOehhG7zFAzStOcTttQTk1JcLaP_UnAWSzmPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Shivani Bhardwaj <shivanib134@gmail.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62498 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbcAPULS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jan 2016 15:11:18 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBhpqYQ01xOehhG7zFAzStOcTttQTk1JcLaP_UnAWSzmPw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.01, Arturo Borrero Gonzalez wrote:
> Hi,
>=20
> I'm giving a spin to the nft compat layer, since it can be of certain
> importance for distributions.
>=20
> I just want to be clear on what I recommends to end users about
> migrating from iptables (and friends) to nftables.
>=20
> Could you please remind me in which state was the discussion about
> that patch to show x_tables extensions in nftables rulesets [0]?
> I remember Patrick mentioned several concerns back then about this ap=
proach.

My concerns were mainly about unconditionally giving access to ipt exte=
nsions
from *nft*. It was not about the compat layer in the kernel, but about =
whether
we actually do want to support everything or just conditionally enable =
those
that we are sure of.

> Currently, with a basic ruleset errors are shown [1]. Also, if you tr=
y
> to see what's happening, segfaults [2].
>=20
> I'm aware of the translations efforts being made by Shivani.
>=20
> [0] http://patchwork.ozlabs.org/patch/459398/
> [1] http://paste.debian.net/366059
> [2] http://paste.debian.net/366060/
>=20
> best regards.
>=20
> --=20
> Arturo Borrero Gonz=E1lez
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
