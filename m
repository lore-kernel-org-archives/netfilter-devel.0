From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: named vmaps
Date: Mon, 24 Nov 2014 12:55:22 +0100
Message-ID: <20141124115522.GA27521@salvia>
References: <CAJO99T=5z-AC=YzOVTYH3++6kf74fXqSu=Q15Jqhb3bVYQ-mLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39287 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaKXLxO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:53:14 -0500
Content-Disposition: inline
In-Reply-To: <CAJO99T=5z-AC=YzOVTYH3++6kf74fXqSu=Q15Jqhb3bVYQ-mLw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 21, 2014 at 09:22:00AM +0100, Bj=F8rnar Ness wrote:
> Is support for named vmaps removed from nft? Running kernel 3.18.0-rc=
5
> and nft head.
>=20
> I am able to create the named vmap:
>=20
> nft add map filter my_vmap { type ipv4_addr : verdict\; }
>=20
> ..but when I try to add elements to it:
>=20
> nft add element filter my_vmap { 1.0.0.0 : drop}
> <cmdline>:1:40-43: Error: syntax error, unexpected drop
> add element filter my_vmap { 1.0.0.0 : drop}
>                                        ^^^^
>=20
> also, when trying to use the vmap in a rule:
>=20
> nft add rule filter input ip saddr vmap @my_vmap
> <cmdline>:1:37-37: Error: syntax error, unexpected @, expecting '{'
> add rule filter input ip saddr vmap @my_vmap

Sent you several patches, please confirm this resolves your problems.

> Dont find anything in "documentation" or online that tells me if and =
when this
> functionality changed/broke/got removed.

I have updated the documentation:

http://wiki.nftables.org/wiki-nftables/index.php/Dictionaries

Please, let me know if you find any mistake on it. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
