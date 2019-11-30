Return-Path: <SRS0=76Lg=ZW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0D2C432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5542F2075C
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:11:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="oprxcQbR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfK3RLH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Nov 2019 12:11:07 -0500
Received: from kadath.azazel.net ([81.187.231.250]:52522 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfK3RLH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Nov 2019 12:11:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vN73VLhrJjp/1HstTdgeoT52WPxVDKj+22zgtJSiSRc=; b=oprxcQbRj+g+aPk2qetkCEYoUr
        tXkk7L82TfH6hJjtOrRSkXLDXfNF0OManB8nncvnv7b3jrpb960IHQfPneSKqUV8CM9PUL1jQfOps
        WKq+RXGmmhGg7g04aQLnr8r32rBGX6Nk05mvvEV4Y/Q4ZBz7LlHyTf/Ck5owefmA8hkMfYNnuhc5I
        synAcsRDh8wLTpovXbeodOu09kayqfBTeL5D5vlzAQUUIOyIvn3tbFX5zlDWuo2f6ogcoi1Y7BzbJ
        RCo6IgTqQbI+e59kttH1GPoySFMN4sI1/Zf/Kn7nQfIOh3+LB41R1L4zNqKtz+SzukQwR5OUeUeyk
        ximINwvQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ib6Gv-00020x-6T; Sat, 30 Nov 2019 17:11:05 +0000
Date:   Sat, 30 Nov 2019 17:11:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        "Thomas B . Clark" <kernel@clark.bz>
Subject: Re: [PATCH xtables-addons 3/3] xt_geoip: fix in6_addr little-endian
 byte-swapping.
Message-ID: <20191130171113.GC133447@azazel.net>
References: <3971b408-51e6-d90e-f291-7a43e46e84c1@ferree-clark.org>
 <20191130170219.368867-1-jeremy@azazel.net>
 <20191130170219.368867-5-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <20191130170219.368867-5-jeremy@azazel.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-11-30, at 17:02:19 +0000, Jeremy Sowden wrote:
> libxt_geoip attempts to byte-swap IPv6 addresses on little-endian
> systems but it doesn't get it quite right.  Rather than doing ntohl on
> each 32-bit segment, it does ntohs on each 16-bit segment.
>
> This means that:
>
>   1234::cdef
>
> becomes:
>
>   2143::dcfe
>
> instead of:
>
>   4321::fedc

I'm an idiot.  This commit message is wrong.  Will fix and resend.

J.

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl3iorAACgkQ0Z7UzfnX
9sOR7g//S6NAxu5G1Cy0LnZX25xLZdro78wmtihhpe/t29LJkMnoqHUcQ8F0371W
6I4xntLdBSE7g40HRASVgZYzTrCZ0azbS/tpRFOjcGgABdZf0GxIJnlPbhVJsVJ/
u0DR9vg+c//WpqENOCRNHMBLdShyCHxjD/hoKNIvKKPLGdYlBw3V0llVTAqFdXcv
YKMEsPOEAhJHAWo5w/37lZVaoZ+Km8eUbBzZUOamfi5wKwEq+bY8/WfS1Wx60yOx
2qUbMSMTu4P6PfpOQIggDpLUC8BH868SQprR9gvb11ZWOpKTQnW4G9KkbTT4S8fR
CwJeDWR/vs5c+xSyxiiRXU+MkHXWTWSxLMxUH6h0FbqK7yQ2pUXYSUywNwPHyUui
BbO+hRS7o/EqnHVipzAASdpN2RGCrrhMvjGSwacdGBMxOSivrXkDX3JgSnFvf1JC
IaVPCr3FbzuZG5+GCb0jV6FVi1elvfGamwmmlAiIBQ2aXMfYXIXcBEho+fDGB0ID
pZs/sul/i689IvC6VSpZF4xoQcXByOrn0MoLQ30uFGzTKWDBos/TudyYemn4AnfN
3DdDJH+vuceFADWHjbczMBtoMGHozk9tZWvCOYGb34PsWFJN9Eo3N7CU0SF7hzjs
OnXoMMSLTxWRq25TUeMgbnYVTcodqLUbBNF2NHANAQUJKZOXRk0=
=9iTc
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
