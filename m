Return-Path: <SRS0=yud9=WI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71424C31E40
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 14:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4189420679
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 14:54:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="UPx7Xq6H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfHLOy3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:54:29 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44748 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfHLOy2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Aug 2019 10:54:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UxVu34cC6QPht+gsU4sDDp0h5MvRTEPal3hDgP9YvNA=; b=UPx7Xq6Hq3cHKSoe3ix1Ndm9PT
        ruWId3LhH2jWsoQ77SZCJ2uBFdI+EsvjuLN+5o2pyeq2TVDp05J5gf/Bz1lTKE0F0QxwIXSZsaNRK
        WsbG0cJcfw7JoWs9yMdoEAbavCYn9qhvQN0dsIXBhYPxdwk1pq6oWjt8XUPw9B+aMCOxY/F/KlvQo
        qe7BEJiOksA6WOHlMjC/9u9wpt0juUlvm+kB5O0cX8rwm3l2VOPJmWGgKAzcEs2Nu2udAR78y9NwY
        lnYVOVleaGyuZpY/z/+L8qayk2YDNBb7/Hd/FhQd5W+XWo3tVDbWrA+b36eGm5qCshohoGXfPGwBu
        0Ny/xl2g==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hxBiN-0006Y0-NO; Mon, 12 Aug 2019 15:54:27 +0100
Date:   Mon, 12 Aug 2019 15:54:26 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Franta =?utf-8?Q?Hanzl=C3=ADk?= <franta@hanzlici.cz>
Subject: Re: [PATCH xtables-addons v2 0/2] Kernel API updates
Message-ID: <20190812145426.GB5190@azazel.net>
References: <20190811113826.5e594d8f@franta.hanzlici.cz>
 <20190812115742.21770-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <20190812115742.21770-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-08-12, at 12:57:40 +0100, Jeremy Sowden wrote:
> v3.3 of xtables-addons does not compile against v5.2 of the kernel
> owing to a couple of kernel API changes.  These two patches update the
> broken extensions to work with the new API's.
>
> Jeremy Sowden (2):
>   xt_pknock, xt_SYSRQ: don't set shash_desc::flags.
>   xt_DHCPMAC: replaced skb_make_writable with skb_ensure_writable.

Turns out that there is already a merge-request open against the
xtables-addons git repo for the shash_desc::flags fix.  I've created
another one for the skb_ensure_writable fix.

J.

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1RfaIACgkQ0Z7UzfnX
9sPcug/+LSoaJxWbySPWI3SgNBAqUeLkJeV5uExw8+cQm15uhB/4D2WWOFGcKNvj
WEAuDYQOYQsOJ28PcbSyerpHV4gt6EY+1ejPgGNnRol9GbhxtPObUJ8q5I+xb1IK
tKDJ3iJak6jHr5mADUUkvMK8dZ0OQs0YDDz5Il2CE/aehrS9tcqZpr93hkVoQ/uM
O5Uy7+MgSkvvD3CPZPYxd2MDY8hyRfEyOdVvZGG54E/XgLVrQkkginDQLGzZ6kqg
qctvpHiyci6LCEnqtVHFgy1ooGgpI47D6Dbq0dFemhP/Oola0691JNwg3v429swz
odWxB8c5Wsy9lBKNJD193mqHqDlKzYNcv/ADGwxB5a+jOXCHuTO8WpPgbQ0RriTw
xSJfVqm6aItf4Ts4hOYBGkD7n1HLJNxKPdjLbWmCHT4JLXKGMf+PJijPa8VKfoCp
VLW93Rp2Cu39vyIGYp70oLXmP489UqiQtE+tNlR4NmsVwCZcE8mWNEsh/tOIoJkB
CaaUm6AgApc5motLNNPhrK2CtuPf1/Lg9udJ2GJJiRKteCeEgr0H3CglAP8kh153
6cAgGQt/LEte0MIUZm/0u6atH2e/ixBd5c4UBo8ramDUhgXRyi0RMDHgEb4QUpyX
7oBcjfRnsOwjRbN0Q9nHLK9T3Ms4rjOvGvttPZh7ybgFKAm0IVE=
=bP3R
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
