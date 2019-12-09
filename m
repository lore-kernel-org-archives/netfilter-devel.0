Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B225C43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 23:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CA95206E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 23:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ERL8J6Bt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfLIXXm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 18:23:42 -0500
Received: from kadath.azazel.net ([81.187.231.250]:42240 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLIXXl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 18:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2nkwrhAzkkQtHBHBhKBPEjVIlUlZVpkkNiyfogDg6pw=; b=ERL8J6BttEGcH5FsecmPPgZj21
        z1xOYMMhFvVEb2MUnIZC+tToULr6aUMj6hQZV2Qb/D6rqnUJ2h1Luq1lQlSE8v7/216uQH0UAIG4J
        k9U3p0qGGYRmFz/LqTSTXyhX/QQKb2OwNhH01Gp4wAdILrdJDPcG+hAwjcpKESS7sEqkbuI6+y3tx
        PwTQKn59pxizDxAo2sRdN+VFiSecpymdseikobRaaqAEb9hmwXPkcR0wLcefYEGE9UY3lPSSZywBK
        /ggt4GKWvO0Sss9BMtvsovLKwBHk5FMCrUu6bHlAlNI8Dbr44e8agvVElwxu/9VyxQLG1ClbtdoZ9
        LrBRzS9A==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ieSNP-000555-Fx; Mon, 09 Dec 2019 23:23:39 +0000
Date:   Mon, 9 Dec 2019 23:23:39 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [RFC PATCH nf-next] netfilter: conntrack: add support for
 storing DiffServ code-point as CT mark.
Message-ID: <20191209232339.GA655861@azazel.net>
References: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
 <20191209214208.852229-1-jeremy@azazel.net>
 <20191209224710.GI795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20191209224710.GI795@breakpoint.cc>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-12-09, at 23:47:10 +0100, Florian Westphal wrote:
> Jeremy Sowden wrote:
> > "ct dscpmark" is a method of storing the DSCP of an ip packet into
> > the conntrack mark.  In combination with a suitable tc filter action
> > (act_ctinfo) DSCP values are able to be stored in the mark on egress
> > and restored on ingress across links that otherwise alter or bleach
> > DSCP.
> >
> > This is useful for qdiscs such as CAKE which are able to shape
> > according to policies based on DSCP.
> >
> > Ingress classification is traditionally a challenging task since
> > iptables rules haven't yet run and tc filter/eBPF programs are
> > pre-NAT lookups, hence are unable to see internal IPv4 addresses as
> > used on the typical home masquerading gateway.
> >
> > The "ct dscpmark" conntrack statement solves the problem of storing
> > the DSCP to the conntrack mark in a way suitable for the new
> > act_ctinfo tc action to restore.
>
> Yes, but if someone else wants to store ip saddr or udp port or
> ifindex or whatever we need to extend this again.
>
> nft should be able to support:
>
> nft add rule inet filter forward ct mark set ip dscp
>
> (nft will reject this because types are different).
>
> Same for
>
> nft add rule inet filter forward ct mark set ip dscp << 16
>
> (nft will claim the shift is unsupported for a 8 bit type).
>
> We need a cast operator for this.  Something like
>
> nft add rule inet filter forward ct mark set typeof(ct mark) ip dscp
>
> or anything else that tells the parser that we really want the
> diffserv value to be assigned to a mark type.
>
> As far as I can see, no kernel changes would be reqired for this.
>
> A cheap starting point would be to try to get rid of the sanity test
> and make nft just accept the right-hand-side of 'ct mark set', then
> see how to best add an 'do this anyway' override in the grammar.
>
> I have older patches that adds a 'typeof' keyword for set definitions,
> maybe it could be used for this casting too.

These?

  https://lore.kernel.org/netfilter-devel/20190816144241.11469-1-fw@strlen.de/

J.

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl3u13IACgkQ0Z7UzfnX
9sPlvQ//ZJ96lQA31RIjURIN8XvUCJuyycq9VksF4F2hpPEiH/TzbplY7iIZww17
ykJy0yrjzmJUmkjbVmwcY+uZSrOGGClu3Z3J7oN+REiNRP3cRnA+Drx/+JK4RrSD
NWjdU74qDhPL9FiHhxDHbIIs2KlW09oRfxBjfGOpX5Ow+xWONvRsJ96+8NRIFlYp
5yUoYhQhWPg9NI5/SnGT1u3t5Cs2S6v7H8/IyWIvP8u5AjVKfuY0XmBuu8U3XmGj
u9WzDqm3UUc7Xz4p8agMTBJn4AK8GqVlXleqpvRIMtDslfwm1GZEQ9VQMEX4y6dG
LzQPFCFtZ7zA6OgihEXsF2kO9I/LzzTZixYXQwgZBXbNFAPGG9ZY7Czw/oNo3XRB
aQ+jxMrPPDb7PL0dLchFc9xY1jC1z7G7xYFtUtnqfr/byNzl2DNgFPUzZYqnRs0t
j0lkjEEr3/3aoQHFUPSTf47hbJqaj4gasSh9RN6q+wL8rhq78DTPxtEclt42xUxY
/kjjZW+X75rxrGJC0cIehzkwApeQoOISQIvnXRSuA8vcINwl5TtUoXr8fnCXpWsv
MZdlZ5KHXwgSN95OO2txiDY9YKEqKTvi+eUOvPBT6BBlGTyjKopmp7L6Md5Kdwn5
Cqm+zlU9PD4AjrHjNcH1Lm/UBcMHwR2mcWedU8PFuFqQ8rdJQt0=
=RlmW
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
