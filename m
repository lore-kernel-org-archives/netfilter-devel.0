Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBADC7618F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 15:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2FDD20873
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 15:07:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Q4kLvuZg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfGRPHR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 11:07:17 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53948 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRPHR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 11:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0GA4kigskzck0wqwaf8yVzxobNVLua3mq7YQBzEoSHU=; b=Q4kLvuZg5OGpUyUXuVpWdAixKY
        mApzM1cCncsi9epGygWiAD5iOhIHB9RIhcVDM8GyiMJkpMU3fE3IkN0+epoBtma08AxHpH3tG4Hr6
        Cgc9KMIAQMN+hjSZT4g6Q+hCgHMbYUC/QDHWYI9OdVIqBkVjLwOLERlnu0pPUS/nfzdkED8+AtG62
        J/6NoDHckVInxCiTKRiuwZ44cPrSyzgjAi0joaBsE11NBVMI5PezCyX+5aqJv1lQ9LtD3fmAa3wky
        YltWTwrSqkDBy/AtNZx4AVXYNMx+qpXSl6TLvOK4un8sYaRCFRy8YX2URup/j4CV3SGBzwGmqRrD4
        YCkV2HcQ==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ho803-0000qU-VM; Thu, 18 Jul 2019 16:07:16 +0100
Date:   Thu, 18 Jul 2019 16:07:14 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: json_cmd_assoc and cmd
Message-ID: <20190718150714.GA5028@azazel.net>
References: <20190716183101.pev5gcmk3agqwpsm@salvia>
 <20190716190224.GB31548@orbyte.nwl.cc>
 <20190716193903.44zquiylov2p452g@salvia>
 <20190718123704.GA31345@azazel.net>
 <20190718145722.k5nnznt753cunnca@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20190718145722.k5nnznt753cunnca@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-07-18, at 16:57:22 +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 18, 2019 at 01:37:04PM +0100, Jeremy Sowden wrote:
> > On 2019-07-16, at 21:39:03 +0200, Pablo Neira Ayuso wrote:
> > > BTW, not directly related to this, but isn't this strange?
> > >
> > >         list_for_each_entry(cmd, cmds, list) {
> > >                 memset(&ctx, 0, sizeof(ctx));
> > >                 ctx.msgs = msgs;
> > >                 ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
> > >                 ctx.batch = batch;
> > >                 ctx.nft = nft;
> > >                 init_list_head(&ctx.list);
> > >                 ret = do_command(&ctx, cmd);
> > >                 ...
> > >
> > > ctx is reset over and over again. Then, recycled here:
> > >
> > >                 ret = mnl_batch_talk(&ctx, &err_list, num_cmds);
> > >
> > > I wonder if we can get this better.
> >
> > Something like this?
>
> Yes, something like that would get things in better shape I think,
> more comments below.
>
> > 	struct netlink_ctx ctx = { .msgs = msgs, .nft = nft };
> >         ...
> >
> > 	ctx.batch = batch = mnl_batch_init();
> > 	batch_seqnum = mnl_batch_begin(batch, mnl_seqnum_alloc(&seqnum));
> > 	list_for_each_entry(cmd, cmds, list) {
> > 		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
> > 		init_list_head(&ctx.list);
>
> I think we don't need to re-initialize this list over and over again
> (from what I see when doing: git grep "ctx->list").
>
> This always does list_splice_tail_init() to attach the object list
> where they belong.

Right.  Got it.

> You can probably add something like:
>
>         if (!list_empty(&ctx->list))
>                 BUG("command list is not empty\n");
>
> I would make a patch and run tests/shell and tests/py to check if what
> I'm suggesting this fine :-)

I've compiled the changes I outlined above and run `make check`.  Will
add the list changes and submit a patch once I've tested them.

> > 		ret = do_command(&ctx, cmd);
> > 		...

J.

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl0wixUACgkQ0Z7UzfnX
9sNLXg/9GOwT45WotvEZEWnWLM3k5ompnqDU+lChKpNdiM717sx04vgyRbKdfQSm
V0wXk48XWDZNocKmSghfwiSTy3icakLLqvV/bgFdly0SNkMrvzdeH1XwBoIMdfJi
xhrVd9c2ghRjMGnoW9r6gWps1Jz4Ap/9mECrf1ZE1koUySD8igGDwmb8yhMGs0Ht
qdW+n7NNuibKMbzF49jc/tzofAYV8neW7T29CbBsA9R6+yvneRfOqo274N5tQRua
DkYUFaOOQGqUftE+JLW8wN+q16FII96trW5frIhGXYTdfLR7WasPYKm9RzQYRkWW
sSxtzd9kEi0+au0SP8YleXIEgwGIkgEXK0mZDtPqmBTLT2jlXDBuJ8KukA8ePcET
jXSzk0x6KwtxFktKssstb7KSiDwuipT6RXEvC35ksOG2U/N6URrMk63uuEuut/I6
jvltKiAr4n3pdmgy5oa9qNRxCcfXGRjbEa+sm81GAOQ+iij1D0mUOiq6H5bF7t9N
CRAj7hXnGxw4yOVhmaWjPWQD++9cirN8OMqTJRQrkhTkWh+igu8fhEcT3bfkJ/kR
FTUivYMnOaCt40PNDRkJZzV/JYtI+bfuvRn6G+Pb8eoQB9r2+1rvrVFUGxK3+VLR
j2UANjLFf77UuCMmvWHSxANor42oXDYOu5Uyl7TftGLZaVjd7Aw=
=TLvS
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
