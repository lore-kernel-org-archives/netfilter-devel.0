From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables and sets
Date: Wed, 22 Jan 2014 14:44:23 +0000
Message-ID: <20140122144423.GA14025@macbook.localnet>
References: <CAJO99T=OERsyTy91n=DJSceSdfxUeQVSO5JJtpMwuPyKh6MicQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50307 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbaAVOoa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:44:30 -0500
Content-Disposition: inline
In-Reply-To: <CAJO99T=OERsyTy91n=DJSceSdfxUeQVSO5JJtpMwuPyKh6MicQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 22, 2014 at 03:09:30PM +0100, Bj=F8rnar Ness wrote:
> Is it planned (or already implemented) support for multiple value vma=
ps?
> for example {type uid, type ipv4 : verdict}

We support so called concatenations, basically multiple types glued
together. You can use those for exact matches. However the kernel side
is missing a few bits so far.

Basically:

nft add map uidmap { type uid . ipv4_address : verdict; }
nft filter input uid . ip saddr @uidmap
nft add element uidmap { root . localhost : drop }

The combination doesn't make too much sense of course.

> Also, using iptables I am doing something like this
>=20
> -A INPUT -j BLOCK
> -A BLOCK -m set --match-set ignorelist src -j RETURN
> -A BLOCK -m set --match-set blocklist src -j DROP
>=20
> ..to make sure ips listed in ignorelist does not get blocked..
>=20
> How would I do the same using nft?

nft add set ignorelist { type ipv4_address; }
nft add set blocklist { type ipv4_address; }

nft filter input jump block
nft filter block ip saddr @ignorelist return
nft filter block ip saddr @blocklist drop
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
