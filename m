Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D121C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiKUWw0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiKUWwZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:52:25 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD529B9485
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dHN30HFVE8MK5Bui/nBjpUXqpg5y4r+CqLJRx8GFRGk=; b=iGVbLtTlt27nMA2jEvZnuIHMGU
        0bpXv6bsy3tBeFvr/bNGLilj+NOr//UjshYGvqOvS+eoFQauSKkNg/lyYQVwwcVqgu1hh4nxuB/CI
        adkgAp5UaRzy7GiUn5n2dpDQ2TSBWFOJO2BRMefFog+pKW1ncQ5URcgdrAuOR1Oz/pf+xMoUAv4OY
        MQ+tZHu9SnlE0umyWB8b5ak6Y3LPK0NHbRpB11y/CQlWZEv64krZOIZdQk0PS8dI4FzHl5ngAX+Oj
        BNTsEqa1Muo2xcU5ddUgc60FS3n9zVjcwqzhZOK0RQbtbEyvf3hFanw7j5CmdVIvh74Sr0gPUIQn6
        hL06oTZQ==;
Received: from [2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFeG-005Lqj-IF; Mon, 21 Nov 2022 22:52:20 +0000
Date:   Mon, 21 Nov 2022 22:52:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Robert O'Brien <robrien@foxtrot-research.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: PATCH ulogd2 filter BASE ARP packet IP addresses
Message-ID: <Y3wBIqCFTAFob4/4@azazel.net>
References: <004301d8f531$bb2c60c0$31852240$@foxtrot-research.com>
 <005601d8f532$49cd7080$dd685180$@foxtrot-research.com>
 <Y24taNAVtz53JPDB@salvia>
 <001c01d8f851$38ac6050$aa0520f0$@foxtrot-research.com>
 <Y3KFKuhzFWbbAKWL@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4GC8Q8aUwMn/jbUx"
Content-Disposition: inline
In-Reply-To: <Y3KFKuhzFWbbAKWL@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--4GC8Q8aUwMn/jbUx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-11-14, at 19:12:58 +0100, Pablo Neira Ayuso wrote:
> On Mon, Nov 14, 2022 at 12:47:52PM -0500, Robert O'Brien wrote:
> > I will create a bug report and attach an example ulogd configuration
> > file that demonstrates the issue.
>
> OK.
>
> > I will send a patch using git send-email and mention it in my bug
> > report. What is the email address to where I should send the patch?
>
> Please use netfilter-devel@vger.kernel.org so patchwork catches this
> patch.

I think there are at least a couple more places where IP addresses are not
correctly handled:

  https://git.netfilter.org/ulogd2/tree/output/sqlite3/ulogd_output_SQLITE3.c?h=ulogd-2.0.8&id=79aa980f2df9dda0c097e8f883a62f414b9e5138#n176
  https://git.netfilter.org/ulogd2/tree/filter/raw2packet/ulogd_raw2packet_BASE.c?h=ulogd-2.0.8&id=79aa980f2df9dda0c097e8f883a62f414b9e5138#n647

I'll see if I can find any others.

J.

--4GC8Q8aUwMn/jbUx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmN8ARkACgkQKYasCr3x
BA3k/g/9FuAdjSwCrE8OACgsR2yBIvpwsjE3VRaOYWoDKXpDN+UmHMfTuFunjt/X
OOupnfVq25Tq1ZYrQQMIkXF6T7h+69KcgW9DSOlJOGyunQLOjf1AFu5XveU04G+e
llYg4eqMvDT9n90q8hl93lt9oX1dr4GWhZ4CgksUHCHVdSUDyPEXfXevibRD+zk8
+kqJDz1oizMF+fsQ/WjASlRthD1gSRy28lr7R9c1XohQMWFZgj4nRRbZO94gJy39
GPbNnHSn/6hxxq4kzWxUzXrt1wAPm7A5douuwx3oGN02K0mRIixfq3JsVCdyA5EX
79jDoyVEvlOQ29UAmKL5AAPfgZekRHo6Opf6fI/rRrV+L9fcqHkdUiA00w+xE+SE
zO/EFLRajBTFrqT8rldWNGCjnmoD0xCnwWZqOMInudXjA0lXXjWLxegV54EW+m1Q
40juMMlDPqfHD/m7aZVhdR4vuuoVMM7YUIKie8zQnydDWE+yZn3TCLKcT6+RJ6uQ
cTOXF3LBvFiQPugbZOV2xulm/nOiCdiJIa+KzFRSi6hznaNP6OqNtkuMiZSjPFlb
uICLi6Kg+s6ulLax5VGA6+xywx2Fs2C+YZJRJjpdCJNLp/u9N84x/anCtRPzl6tu
IrZG4V2asv8mhN7n1Oa9h08iDgOEzXE+0kNyTsj30yqIQQ9SakM=
=CDsA
-----END PGP SIGNATURE-----

--4GC8Q8aUwMn/jbUx--
