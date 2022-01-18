Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C97AC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jan 2022 09:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbiARJdT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jan 2022 04:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345792AbiARJdN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jan 2022 04:33:13 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65EFC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jan 2022 01:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/g/UGzVhmSqOQ4DEmMaBFKlpROiB9e2J+HqqFaXyKOM=; b=UZqQ424cwfYpvCmvviw/l0SVMf
        232Sp4acC5TO8QpKXhGVlPYpC0dnuhPTeb6jRVJIyQu8dsOSk4oxO6qLESftrgbSRzaIua6I7S6RI
        Ta1LbmpbfvlJHrhz37ZnqsINo4LF7B+J0Vh1APwy06WKOHEaCMSak2Wz6FtfN00T3wRhKXKTIic1+
        v+oj4OsaxLqhGJV1pem90lYAIqDgO3ZdL9QqycLrsQ7A1Y3uAi38MUmmXVINI8u+5YQImd7w+E0cD
        y7sKld8afYluQ7waCusQQAiMrO6wS1ufQuQGgem+lMVtcxwsTADakg8s0TlxbBxE4ZbVhWTARqAPU
        bjkxllbQ==;
Received: from ec2-18-200-185-153.eu-west-1.compute.amazonaws.com ([18.200.185.153] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n9krR-00BDxN-VY; Tue, 18 Jan 2022 09:33:06 +0000
Date:   Tue, 18 Jan 2022 09:33:02 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables v2 0/8] extensions: libxt_NFLOG: use nft
 back-end for iptables-nft
Message-ID: <YeaJTl8zMCXzOdAf@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
 <YeQ0JeUznhEopHxI@azazel.net>
 <20220116190815.GB28638@breakpoint.cc>
 <YeVHs4oOQki9FIgj@orbyte.nwl.cc>
 <YeXlrL3v0CQJbxwD@azazel.net>
 <YeYWorAwXOzoKVgn@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KR7GvXLZLnc6HgXJ"
Content-Disposition: inline
In-Reply-To: <YeYWorAwXOzoKVgn@salvia>
X-SA-Exim-Connect-IP: 18.200.185.153
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--KR7GvXLZLnc6HgXJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-18, at 02:23:46 +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 17, 2022 at 09:54:52PM +0000, Jeremy Sowden wrote:
> > On 2022-01-17, at 11:40:51 +0100, Phil Sutter wrote:
> > > On Sun, Jan 16, 2022 at 08:08:15PM +0100, Florian Westphal wrote:
> [...]
> > > > Pablo, Phil, others -- what is your take?
> > >
> > > I think the change is OK if existing rulesets will continue to
> > > work just as before and remain compatible with legacy. IMHO, new
> > > rulesets created using iptables-nft may become incompatible if
> > > users explicitly ask for it (e.g. by specifying an exceedingly
> > > long log prefix.
> > >
> > > What about --nflog-range? This series seems to drop support for
> > > it, at least in the sense that ruleset dumps won't contain the
> > > option. In theory, users could depend on identifying a specific
> > > rule via nflog range value.
> >
> > Fair enough.  I'll add a check so that nft is not used for targets
> > that specify `--nflog-range`.
>
> --nflog-range does work?

No.

> --nflog-size is used and can be mapped to 'snaplen' in nft_log.

Correct.

> Manpage also discourages the usage of --nflog-range for long time.
>
> Not sure it is worth to add a different path for this case.

Yes, there have been warnings about `--nflog-range` since `--nflog-size`
was added in 2016.  I wasn't entirely happy dropping `--nflog-range`
support and introducing the divergence between -legacy and -nft as an
incidental side-effect, so when Phil brought it up, I had a look and it
turns out that the code to preserve support for it is quite small:

  --- a/iptables/nft.c
  +++ b/iptables/nft.c
  @@ -1366,6 +1366,12 @@ int add_log(struct nftnl_rule *r, struct iptables_command_state *cs)
          struct nftnl_expr *expr;
          struct xt_nflog_info *info = (struct xt_nflog_info *)cs->target->t->data;

  +       if (info->len && !(info->flags & XT_NFLOG_F_COPY_LEN))
  +               /*
  +                * nft doesn't support --nflog-range
  +                */
  +               return add_target(r, cs->target->t);
  +
          expr = nftnl_expr_alloc("log");
          if (!expr)
                  return -ENOMEM;

Perhaps, we could put this in now, add something to the release notes
for the next release formally deprecating `--nflog-range` and then
remove it altogether in the following release.

Or we could just apply the current patches if you're not that bothered.
:)

J.

--KR7GvXLZLnc6HgXJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHmiTIACgkQKYasCr3x
BA1/RA/+OE16UE2ZbwGyJA7FLGNY6e3KDaP3mMV98rAWokmPpV1HYVjijvYNqkw3
7KktZzSdxFGt70Fu6zibt2/Kp/DIX5zcN4f6Q+n2DLFbXBwfGneCPUnvjLuO7msM
HKTTiIhv3KG36JVGhfPyOUyP9sijCN/RR3Mvp+NBhO0Iq8YM22dPAqV+SoYJmJ10
J1DhOHwNQty5vPIC9HetkDa7pGPVsuQRxLQVl0o0AvOydm+xiptUx2CX6gcf2CQH
/1uFflD1uvJNfZdJJisqQE/HMT/j668wr1acjtrPvEOBX0YrSsSrsfCYx8Bpup7f
Oo30TmgUvHOox+9aRU8tou8bVPYuKtAeXFNi0Ow6siy+HcGWG9I/W7fYRyP0eHU3
1jJxOOVU8gf4hclYCJCRxocrk/FEpGJ9L7o2+mH+D3ru8i+6VScSXnHQkCCWwq5w
AzYcQgbN+ffVkd6fQTQZ0vsHRfYB6BZOhfUbJep8DzSH2LPI5Ibkxg1I1xj7b5IF
CL2YR0AdlbO7+ynTsE1FVhaCGoQsvSp3RcQUP7lGDfh72wPJLErEDIVhBBD0En1T
1RL5h/apFw2aGID8aS4+r7ZrCecIg6/yxEDvyFQSgyTavuehL3mtRjdYcrJ887kk
cwLxMzTOLCm9FqodBM6xOId7KH5hoT0umMSnBTjZT3BtLszFupQ=
=T7HR
-----END PGP SIGNATURE-----

--KR7GvXLZLnc6HgXJ--
