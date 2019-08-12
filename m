Return-Path: <SRS0=yud9=WI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95022C31E40
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 11:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 682742085A
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 11:06:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="k4qsQDYy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbfHLLG7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Aug 2019 07:06:59 -0400
Received: from kadath.azazel.net ([81.187.231.250]:41778 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbfHLLG7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Aug 2019 07:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5fUyQmo4G0XIbbRcuFyf5Pep85tWDif5cmjFkA9URA8=; b=k4qsQDYylmeW31v8LkGM6cHU/v
        2CwbzFZby+wFRXw589qRXKOH16TF8gAwBtXVDMlF771u2Cwux0tKcEFdW5ca16QjSxHJzMOwGzmCu
        AXxho6MlHYZUN6Q8e+mJXQjHG883ys1CWql0TZLkj2Z1J0RdTygsLxwxzxCcGyfi3WNHK/Nn+3Oqh
        6iF1w9NOsUGHu4TccvtsyW+9GgGz7lMQKSSyera+tAULl0brLBQllM53AqwgIfA4q2biOgpMOan/2
        U/yepMLUIryMaN68/DQyzMZQQ6Yy7Jaw9hQ8cVV76FsRqofkbsDCIQZiDm4RCgQBOEPgCnwpkpd6N
        fZyCwywA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hx8AD-0002C1-Iw; Mon, 12 Aug 2019 12:06:57 +0100
Date:   Mon, 12 Aug 2019 12:06:56 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Franta =?utf-8?Q?Hanzl=C3=ADk?= <franta@hanzlici.cz>
Subject: Re: [PATCH xtables-addons 2/2] xt_DHCPMAC: replaced
 skb_make_writable with skb_ensure_writable.
Message-ID: <20190812110656.GA5190@azazel.net>
References: <20190811113826.5e594d8f@franta.hanzlici.cz>
 <20190811131617.10365-1-jeremy@azazel.net>
 <20190811131617.10365-2-jeremy@azazel.net>
 <20190811184217.yse5h3diubi7uvas@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20190811184217.yse5h3diubi7uvas@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-08-11, at 20:42:17 +0200, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > skb_make_writable was removed from the kernel in 5.2 and its callers
> > converted to use skb_ensure_writable.
> >
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  extensions/xt_DHCPMAC.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/extensions/xt_DHCPMAC.c b/extensions/xt_DHCPMAC.c
> > index 47f9534f74c7..412f8984d326 100644
> > --- a/extensions/xt_DHCPMAC.c
> > +++ b/extensions/xt_DHCPMAC.c
> > @@ -96,7 +96,7 @@ dhcpmac_tg(struct sk_buff *skb, const struct
> xt_action_param *par)
> >  	struct udphdr udpbuf, *udph;
> >  	unsigned int i;
> >
> > -	if (!skb_make_writable(skb, 0))
> > +	if (!skb_ensure_writable(skb, 0))
> >  		return NF_DROP;
>
> You need to drop the "!".  The "0" argument is suspicious as well, i
> guess this needs to be "skb->len".

Whoops.  Not paying enough attention.  Will correct and resend.

Thanks,

J.

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1RSEcACgkQ0Z7UzfnX
9sPHsw//SlXP7araLwKNx0eI4knL5NJuatf9kT7Nqhhw3M+D3GOSaqOYl1gKyITf
ZX6z1ajz7fDShSP9zd6a4KsHyS7jLUJvXEKW+SuJCZbXIZb+Xd0tH+aFUtOFznTG
A+cRcJ+2dU9hkrw5Z7qAJgadhaQkqdMv3m7POLR44XKshHWI3MmtqeL+daVm2uFa
rCKufmwnbO/bP4Nhw+2kSiVS+ILLGkf7QH8LhJXPveQhtE5L8WDm2zPxpze7XzPi
l3QdupgMm7SCu94TtW/0yIBGfpAuRr9Ew4arhEY8UyemLWhenForRAmtdTRDApfu
JQ8V+8Rs2ImKKutVVtti+BrHDZ/AFzyagHWf1z1N8XU/qMqdQQe0J8TuCdX19kfP
gmEpFdazdpf7hXoFtw1WfZ1wpqDhAncp5vr/31BCBIVuAgL5KjVuNojWEv1xGXpL
l02LgI82BrZsZ9NcSW7KpEya31jFxqDFQIWx5/RPuGwUZOmjUMie1QdhBSFB/TB2
gkntBJPXycM16N/01Svbyc+UcFdkguQ9t/UohdiSI2YTWIiYSwSP+yUmrPEvS9Og
PBg80wKzBXHo3iSNO2jrrX+baOK8dXuSAxCxHrBItXvvmjkJaI6OCCrAAB/8tq7f
H55sifXrc/uaX8GmwmvGxYOEFg4KbtFPLF4UZcgKqL6yN2x9Va8=
=myjq
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
