Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3221EC76191
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 12:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3D8420880
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 12:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="r4ilWVvz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfGRMhO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 08:37:14 -0400
Received: from kadath.azazel.net ([81.187.231.250]:50600 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfGRMhO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 08:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RgCrA214dS1yST/6GBOUEF+yME35qvNOpI+teI3p8vk=; b=r4ilWVvzmiXc5KcmcEgtaZDcMG
        aBl2w0vHPxIxCA/425/z4S7yV6T/LVs7OF+R9W8JNLM7vgwwlnYdga6ojKEAMxhK/8DCVH5OGMmaz
        EqT5+cfy0pQwe3uopOTLHFhhfaZKKgVMF7Lk1brtaiE4cL//SWzMXOcMHWlgq0iEM9CdOVqk8QY4P
        EO04hEBaNmb2LEGN8dEL1YXMPPX6idsFw+rSycYxoD79311cjR+1+aiXoeNO6SUMgJXk7pA4YNSPZ
        /yyrz4Djc9Lg3IVH7pkCNavjOEVQ6+ur9Dy+R7nwppokiFBJq4IVHfM0gKQgLC44JMhfVHm+PEMBk
        iAoigZYQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ho5ek-0005o7-1K; Thu, 18 Jul 2019 13:37:06 +0100
Date:   Thu, 18 Jul 2019 13:37:04 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: json_cmd_assoc and cmd
Message-ID: <20190718123704.GA31345@azazel.net>
References: <20190716183101.pev5gcmk3agqwpsm@salvia>
 <20190716190224.GB31548@orbyte.nwl.cc>
 <20190716193903.44zquiylov2p452g@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20190716193903.44zquiylov2p452g@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-07-16, at 21:39:03 +0200, Pablo Neira Ayuso wrote:
> BTW, not directly related to this, but isn't this strange?
>
>         list_for_each_entry(cmd, cmds, list) {
>                 memset(&ctx, 0, sizeof(ctx));
>                 ctx.msgs = msgs;
>                 ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
>                 ctx.batch = batch;
>                 ctx.nft = nft;
>                 init_list_head(&ctx.list);
>                 ret = do_command(&ctx, cmd);
>                 ...
>
> ctx is reset over and over again. Then, recycled here:
>
>                 ret = mnl_batch_talk(&ctx, &err_list, num_cmds);
>
> I wonder if we can get this better.

Something like this?

        ...
	struct netlink_ctx ctx = { .msgs = msgs, .nft = nft };
        ...

	ctx.batch = batch = mnl_batch_init();
	batch_seqnum = mnl_batch_begin(batch, mnl_seqnum_alloc(&seqnum));
	list_for_each_entry(cmd, cmds, list) {
		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
		init_list_head(&ctx.list);
		ret = do_command(&ctx, cmd);
		...
	}

J.

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl0wZ+kACgkQ0Z7UzfnX
9sOPPxAAkue/XA2X1N90MHDgYxpkUCTnk2FZqvsceE8HxlUo5eqgi/d8gdPnyVsO
TIuD24UTKh5aU4wIKtKpaPjIyPGh8B+GLrqiMSH2/ubCtzkW9+u7Ehl1MA1ljkud
x55SpgBJKLfzg65oEyBUPx6ttu9TehTQpGS1WF8Gzs1+gGYff+0z7N1iH0KriMkX
ke/YlRB/6Ign5qCFvdVKe5f/88yOUgCLolzLYdYOosXMH8CBE1wBGtPjxu3I5k4j
Cgx0j+ecjjaQFOeLtuyAUoRsF+wu95+NpSm4XFmCsttaG10HIw3Tw+tHL9c2IiEp
v62c7NrqJEYo2noEpxxN1JNQbFoJSyU6xV/1zt1Nj8tSw68ybhKvd3ADBoNbOmL4
I/1a12CCYyISMjDMmMLAKiK6NLbPwa7INmJcY9mLb+RRskE2R2+G9hwhNl0a8ZEr
05674KV0/7CbL4uwq3xWEvymGdis2XbE7MxBQjtg8E7wiJRP1PiT+hZN8CdXCAEK
uUT35IZb7Gs6bofrCpAFqdUpYva6FwHPtfRvLJyxnYWi4cxJjEz7XKmPPAT+kp3a
lk779jFrvXnaju2ZPfWd6u4TuT3svJul0OOtViv/HqO185u+5yGZxxK1s6pc25aw
jQ7f/0batvUv9HFHdZ0XEJELaoCmB0GmT+50fgtsSuTtkpTMUME=
=uPHh
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
