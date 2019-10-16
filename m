Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC8AFA3728
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 10:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41A992067D
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 10:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="GO5B82C/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388987AbfJPKzH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 06:55:07 -0400
Received: from kadath.azazel.net ([81.187.231.250]:58244 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfJPKzH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 06:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KQ+okMfoyFPUc8ev/Q1oAJRSZUWIGIDUzo3LrQJqVCk=; b=GO5B82C/h84fmqjTLBMSwihEox
        l6ItkeKORyhn7cStOMuqv+cJW4xM9SgnxvjLCoXWOJaCCH4Ko8vildZre3TtxqDyekFZCYb8Lewvl
        kmQNfRSg8d/9NcUTynw4R8dR5EFeI1C7E70EbKHgMhEs31yEYirVGJlOsHL4ABtkdVsmK4SKdif9n
        PqDpfaZeKthhQz2CIRwUyXrRFdqezba4yLXLZC33YXiOsJaWa5ol8E2z+cUK+sbin03cHFdt9eSll
        Y3un9CAzp1wgWVqQnfypUUrL1wc2SovLyV+C7+RJ9S1EFLfSe3psNI3W+0ptyGSLwecj1piLsTkf8
        YomZoqIA==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iKgxK-00011t-Ji; Wed, 16 Oct 2019 11:55:03 +0100
Date:   Wed, 16 Oct 2019 11:55:02 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables v2 1/2] cli: add linenoise CLI implementation.
Message-ID: <20191016105501.GA5825@azazel.net>
References: <20190924074055.4146-1-jeremy@azazel.net>
 <20190924074055.4146-2-jeremy@azazel.net>
 <20191015083252.rm22hgssh4inezq4@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20191015083252.rm22hgssh4inezq4@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-10-15, at 10:32:52 +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 24, 2019 at 08:40:54AM +0100, Jeremy Sowden wrote:
> > By default, continue to use libreadline, but if
> > `--with-cli=linenoise` is passed to configure, build the linenoise
> > implementation instead.
>
> Applied, thanks Jeremy.

Thanks, Pablo.  Don't know whether you change your mind about it, but
there was a second patch with changes to `nft -v` that you suggested:

  https://lore.kernel.org/netfilter-devel/20190924074055.4146-3-jeremy@azazel.net/

Need to find something else to do now. :) Will go and have a poke about
in Bugzilla.

J.

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2m9vIACgkQ0Z7UzfnX
9sNT3w//WBOdwcQHYu4RWFTaoJcME+mA0V3VvigTfYUGewaStd1tBnjWHAqKZhAZ
jkBOnr8saVOob1QD0/vTTV06DOl44q1WYMp0DGWuom6vmbEY5go3pvENEzbE9bfx
YN+YnUX72iAQ5O5mNZldKFMAhafE8rY8Di+J+wzF/TZtwZLZU9bCrR/HiPFYbgR3
ZUY/E64u3QE1PZyGXMOpmaYwieYwPusDq8s5o1L0NZIn9cJKNxg6m28iVMRweQX8
bDnhC59Xas2zcHJZ6LL7JGOSVl2YwVa7uT9f9/iUWknNgXAxW6erCnxr6q67jfaB
Y9dC1mP9cVDfbHZ2xqhT0P871zh2LG5j369JKWJmjmbH57Kqv280Tu+RVy6hsZj0
L7Er3oxj2Xd1A4GUJtLzyCgx3B2Cj33sMNS9Yf9lo1P8Z/HkfAIJfF0o17xTW5ld
bMpU97zzUC9HKWigC63pbJRGY0yiIYBS0nRUGmOxuIwtQjbsl9TcE7sV+pinef6C
toI+5v8LjzWcwpqwGCCB8b+B6F3I5AbS4Ld1sSzCrG0kK2TnLwwIbU1l3P75aXDY
qQiaCw+7qMWw835PRfTdtGMkZisEdtI1bgqTpiTDAFEQQUZbagmWbOxE+3QzvHWG
TuKX9V20OT3vXpk0VGTzei/HtgMCzlxciSsvdNQpQ3SqAV96Ziw=
=rrwx
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
