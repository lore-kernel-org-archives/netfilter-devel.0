Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1DFC4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 07:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 969252075D
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 07:58:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="KYEJinxW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfI0H6D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 03:58:03 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44874 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfI0H6D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 03:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j0GC4Qb16Y0ZBPfImb4HGzCxQeG4EFcQBdgazB2Idog=; b=KYEJinxWQkUYncrol+DqD9pn8g
        2ZAryMyrUhAc2b6IF1izHll3XfaG62Y0w5M3zCQf1goAk5jGOR+naf1M1Cx9TEvKwAfFgdFqb5u61
        ZygcW3pQRmxcRvW+qJ2afTgc9AS2LEcwItOgogOzMR0mPcqGgldPXfl396bdyS22apv0TyiMUQawM
        VhXs6bJqchmZuQA5cx3AtGyCrnCYag3Bp/4AvjnGFTzsqZ9RCDr0jRZ2aKIJ4lnCY6CMrotVdYD2N
        /OUBr1E41h1YpGwQxuPFvuxdM7BV/Md+rUHm6graxYOTXCsrrV9Fr/H6+t+6oLqF0fqT3gKW+ZzDc
        BTDCRzCA==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iDl8b-0005Zd-N4; Fri, 27 Sep 2019 08:58:01 +0100
Date:   Fri, 27 Sep 2019 08:58:01 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2] libnftables: memleak when list of commands is
 empty
Message-ID: <20190927075801.GA15351@azazel.net>
References: <20190927064251.10604-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20190927064251.10604-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-09-27, at 08:42:51 +0200, Pablo Neira Ayuso wrote:
> ==9946== 200,807 (40 direct, 200,767 indirect) bytes in 1 blocks are definitely lost in loss record 4 of 4
> ==9946==    at 0x4837B65: calloc (vg_replace_malloc.c:762)
> ==9946==    by 0x4F28216: nftnl_batch_alloc (batch.c:66)
> ==9946==    by 0x48A33E8: mnl_batch_init (mnl.c:164)
> ==9946==    by 0x48A736F: nft_netlink.isra.0 (libnftables.c:29)
> ==9946==    by 0x48A7D03: nft_run_cmd_from_filename (libnftables.c:508)
> ==9946==    by 0x10A621: main (main.c:328)
>
> Fixes: fc6d0f8b0cb1 ("libnftables: get rid of repeated initialization of netlink_ctx")

Whoops.  Thanks for fixing this.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jeremy Sowden <jeremy@azazel.net>

> ---
> v2: better commit description and title.
>
>  src/libnftables.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/src/libnftables.c b/src/libnftables.c
> index a19636b22683..e20372438db6 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -34,7 +34,7 @@ static int nft_netlink(struct nft_ctx *nft,
>  	int ret = 0;
>
>  	if (list_empty(cmds))
> -		return 0;
> +		goto out;
>
>  	batch_seqnum = mnl_batch_begin(ctx.batch, mnl_seqnum_alloc(&seqnum));
>  	list_for_each_entry(cmd, cmds, list) {
> --
> 2.11.0
>
>

J.

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2NwP4ACgkQ0Z7UzfnX
9sNA3hAAin9y6VNq/ct6sX6uOvNRNLQaN8pi9u53mfpLTKg+FIPgS8mJQyp3mZmU
FSYv7XG/GQlgXkphaSTAfDjDLYjXnFhi7d+NL/9eXXRxdwsIsOncKFHJdRsz91zs
ulmSIBc8nJlI3O4ggBX9BYLMb3dpDbIAbDVf16e+koFTP+nJl7TM1FSUocbVRnow
IT5kU1J/iuItgJYT9x2w8tllSLxDVf5kdG+qYgaOq41CEsEOVZyg74D95azR6ba9
7rctXoHQbpvDws5aMrTjOTl+z+BY+tmJsEsqLIMs3JtBw3jT3b1S4w4RrV9E7NrW
uzM8725jxpHwPotxo6ZQvS6rAmTABUexYXzQlBz5eNbNcJ6yDrvke9i5ybsUXPSm
LARkMfd70R549q99G4xlyMXocAxAvTzp0CbPUa/9KXU99WgoKRFFzGHdd6tVwQTt
Z9yt/nk9h9ZhNHM9Q+ZsIfqw6noYUIs01/brp4MUe3X7rBCFijyl/LqOj1PRm9jO
arq2K0fuFZPTPlujR14qp4e5L0bvqF8CrgtraRR3d7zNFUSPJ5IpOC4zBjnmPQAD
xCyNq7w67AV07BvMn2ljsW/0ZlmELVFHnHeu5QQWwSdo2a02xZEr7O0FHsJY3P8T
GcZMfeSGDeAmGF3t6R9OOo6gljF01FxmTyfSJsFhZOVxEqlRDoE=
=9FEg
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
