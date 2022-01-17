Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7A7C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jan 2022 21:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243381AbiAQVy6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 16:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243380AbiAQVy6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 16:54:58 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC712C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jan 2022 13:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JfQaLd6VlhClWBPDECaIZ6gPlhMORo0gmhoGS67w1gg=; b=JMYRs1dmEX4G8VtpfJ6fnUHXuv
        Bd374FcnRL7AUHU3U2cyb8NL6MMvxKntBH2MO4FvixTfEbY94Flx9FKBU05q58C7xt4c+b3c1n5Pa
        cNoPAfaWru442EO90UkwznRcK1ZfBLKhuht4Z5gw+wO50hvEhBP+8a1lHspZ+8c0lAqcwfWmzAjQI
        NDl59tvMxXZHhoZgXOtP6WxkbKn8YLSCAHyJKMGwq82Y2KI/8G8ojU2k9ouqIAvZWmvM524vVRd9/
        4AHUn4XjyYoAnVwcVXdnI7LZaiQ+8jDfJaqM/BhUTtnbOvipnpcfv0IESSdCHKl5TrYQBDpx+6L2P
        X/qj6tOg==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n9Zxl-00ARXO-99; Mon, 17 Jan 2022 21:54:53 +0000
Date:   Mon, 17 Jan 2022 21:54:52 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables v2 0/8] extensions: libxt_NFLOG: use nft
 back-end for iptables-nft
Message-ID: <YeXlrL3v0CQJbxwD@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
 <YeQ0JeUznhEopHxI@azazel.net>
 <20220116190815.GB28638@breakpoint.cc>
 <YeVHs4oOQki9FIgj@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DZzBbNWWNrhD+i/F"
Content-Disposition: inline
In-Reply-To: <YeVHs4oOQki9FIgj@orbyte.nwl.cc>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--DZzBbNWWNrhD+i/F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-17, at 11:40:51 +0100, Phil Sutter wrote:
> On Sun, Jan 16, 2022 at 08:08:15PM +0100, Florian Westphal wrote:
> > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > On 2021-10-01, at 18:41:34 +0100, Jeremy Sowden wrote:
> > > > nftables supports 128-character prefixes for nflog whereas
> > > > legacy iptables only supports 64 characters.  This patch series
> > > > converts iptables-nft to use the nft back-end in order to take
> > > > advantage of the longer prefixes.
> > > >
> > > >   * Patches 1-5 implement the conversion and update some related
> > > >     Python unit-tests.
> > > >   * Patch 6 fixes an minor bug in the output of nflog prefixes.
> > > >   * Patch 7 contains a couple of libtool updates.
> > > >   * Patch 8 fixes some typo's.
> > >
> > > I note that Florian merged the first patch in this series
> > > recently.
> >
> > Yes, because it was a cleanup not directly related to the rest.
> > I've now applied the last patch as well for the same reason.

Thanks for that.

> > > Feedback on the rest of it would be much appreciated.
> >
> > THe patches look ok to me BUT there is the political issue that we
> > will now divert, afaict this means that you can now create
> > iptables-nft rulesets that won't ever work in iptables-legacy.
> >
> > IMO its ok and preferrable to extending xt_(NF)LOG with a new
> > revision,

Indeed.  The original proposal from Cloudflare was to extend xt_NFLOG,
but Pablo requested that iptables-nft be modified instead.  Hence this
series.

> > but it does set some precedence, so I'm leaning towards just
> > applying the rest too.
> >
> > Pablo, Phil, others -- what is your take?
>
> I think the change is OK if existing rulesets will continue to work
> just as before and remain compatible with legacy. IMHO, new rulesets
> created using iptables-nft may become incompatible if users explicitly
> ask for it (e.g. by specifying an exceedingly long log prefix.
>
> What about --nflog-range? This series seems to drop support for it, at
> least in the sense that ruleset dumps won't contain the option. In
> theory, users could depend on identifying a specific rule via nflog
> range value.

Fair enough.  I'll add a check so that nft is not used for targets that
specify `--nflog-range`.

J.

--DZzBbNWWNrhD+i/F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHl5aUACgkQKYasCr3x
BA2ECBAAisCCoIi8IoHL/RFcMPqtT+u/PAx09CaZlJ9A8XUsuPYlnS9rQsONjPcq
TrH9u9GiSXa+ebI0e7OONWf0MsRwqstmT0GRV7BdZ5KJ+VginU2pULMwELPLP38Z
Mbp4xAy4G3nRYciVMykW4y9u7T94iNjSmQrI3DvgzWtAosOpn0TkZZ90H2p1BvkK
QgAjWQ8PhVQph+Pnn0dNMOrS4PcSrURIQOjl7f/o/tKJk1BgoCwcP1h+GEwDlH9d
+fBCeZFu3n7ClhZNNue7z3xDbPxQYA556b7K2vQXTMht+G4b52GU49eSkcVVid0r
ZWZs30QskwRxIfbc30UM0KNXnbviqUO2BTWB3/SxzQ0TUKo4T5zxPkKFb9ulBPHX
5zbd1kanCkHFxyDnWhdUcySioCYWqVKAM2DJQSgJPJZGlWv2jJhx4KIt6MROElkJ
zmdYH82ycnJtBtHzpC8e/2Mv6fITj/z+uAga8kU1SeMj7YitJZj4c6Fzs2cfDE+h
qykBHbqYw+U+U87sbaaCaMIO+zIoMc1oUXS/RchbXjmTzl753Tx2ZlJFen7ijKjp
uIzwAW9THZRLGBN85b/41YjpYa67t/gJEFhoEPHOeffLyk+CP7CXDZwprSZuo7kB
O+HSMmdFvmHx6V+uX8K4TQNBREj+b8E/5BQTyBGuHnXKm4lHfKA=
=rh96
-----END PGP SIGNATURE-----

--DZzBbNWWNrhD+i/F--
