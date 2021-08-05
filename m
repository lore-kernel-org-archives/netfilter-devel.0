Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42C0C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 10:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C791F610A2
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 10:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhHEKnW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 06:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbhHEKnW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 06:43:22 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4628C061765
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Aug 2021 03:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cIxhroYbqQS/y22VrBeruLghaAoBIZQH+vHZYckdwRA=; b=YESKto5CTb4ncWVbVW1HkY+9oh
        NwnLpXaIK+iyvpu/9MGplf0frw1RfA8/4Vzfh+hbsILZJjRNcSTL5YVO2ZbeeOdh0MXxDOBmbWfY2
        Or6glz6SoyZEX+nqCH96w1EW5yLmT/VEGvoUh4L5MKRLnuuFiE0zc9arYSeKzxFu51b8vKrNrdS1U
        Z2wkLm84t88r47TI1kYtz0tt1L8XXWokF5aScF/ZEyFQ5uIWEwuYhNtlnyl7o9bYZRNKeY61icAaG
        GiUv4mQjGOlib2wHfE0O0/59A66+a77pqAvG+guMdLWuq60+E1ZKPaGgeSHX4/fYYhBo4EU9qyYhV
        i+LQESmw==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1mBaq3-0008Bg-83; Thu, 05 Aug 2021 11:42:59 +0100
Date:   Thu, 5 Aug 2021 11:42:58 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Kyle Bowman <kbowman@cloudflare.com>
Cc:     Phil Sutter <phil@nwl.cc>, Alex Forster <aforster@cloudflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [PATCH] netfilter: xt_NFLOG: allow 128
 character log prefixes
Message-ID: <YQvAsgl/ylNAZVVP@azazel.net>
References: <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
 <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
 <20210728014347.GM3673@orbyte.nwl.cc>
 <YQREpVNFRUKtBliI@C02XR1NRJGH8>
 <YQasUsvJpML6CAsy@azazel.net>
 <YQfU8km0t3clPVhl@azazel.net>
 <YQggBDBruNxkscoi@azazel.net>
 <YQkHIamDpqBzmNrO@azazel.net>
 <YQmMlAheX6Tmg2qJ@C02XR1NRJGH8>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gdI8iqFu+mV8mbir"
Content-Disposition: inline
In-Reply-To: <YQmMlAheX6Tmg2qJ@C02XR1NRJGH8>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--gdI8iqFu+mV8mbir
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-03, at 13:36:04 -0500, Kyle Bowman wrote:
> On Tue, Aug 03, 2021 at 10:06:41AM +0100, Jeremy Sowden wrote:
> >
> > Right, take three.  Firstly, use udata as I previously suggested, and
> > then use a new struct with a layout compatible with struct xt_nflog_info
> > just for printing and saving iptables-nft targets.
> >
> > Seems to work.  Doesn't break iptables-legacy.
> >
> > Patches attached.
>
> Thanks for writing in and helping with this, I appreciate it. I
> actually was trying to make this work last night in a similar way to
> how you've solved it but I gave up after a few hours. I'll go ahead
> and organize this together and send the patches in a separate thread.

One thing before you do.  Some of iptables' unit-tests related to NFLOG
are now failing.  For example:

  $ sudo python3 ./iptables-test.py -n extensions/libxt_NFLOG.t
  Cannot run in own namespace, connectivity might break
  extensions/libxt_NFLOG.t: ERROR: line 2 (cannot find: iptables -I INPUT -j NFLOG --nflog-group 1)
  extensions/libxt_NFLOG.t: ERROR: line 3 (cannot find: iptables -I INPUT -j NFLOG --nflog-group 65535)
  extensions/libxt_NFLOG.t: ERROR: line 6 (cannot find: iptables -I INPUT -j NFLOG --nflog-range 1)
  extensions/libxt_NFLOG.t: ERROR: line 7 (cannot find: iptables -I INPUT -j NFLOG --nflog-range 4294967295)
  extensions/libxt_NFLOG.t: ERROR: line 10 (cannot find: iptables -I INPUT -j NFLOG --nflog-size 0)
  extensions/libxt_NFLOG.t: ERROR: line 11 (cannot find: iptables -I INPUT -j NFLOG --nflog-size 1)
  extensions/libxt_NFLOG.t: ERROR: line 12 (cannot find: iptables -I INPUT -j NFLOG --nflog-size 4294967295)
  extensions/libxt_NFLOG.t: ERROR: line 19 (cannot find: iptables -I INPUT -j NFLOG --nflog-threshold 1)
  extensions/libxt_NFLOG.t: ERROR: line 22 (cannot find: iptables -I INPUT -j NFLOG --nflog-threshold 65535)
  1 test files, 17 unit tests, 8 passed

I'm working my way through them.  I've got fixes for most.  I'll
send patches when I've sorted out the remaining ones.

J.

--gdI8iqFu+mV8mbir
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmELwKsACgkQKYasCr3x
BA131g//WanJQ220cxgSfvg4dYwUBmlzPfZQmZMS50VUUMRhP/J565sbdzpNF9ZL
1l17EAQRVhQFSziKoG+Gwct66NOmaTGJV5mxcnXlhSQd5fYbVBgUwUvYmwAdHQu4
+S6tCBZnvWUqikQNUbbGVp7Ighxmp7JcINAxenbOHyd5s0VLFFDhX85BTQ0c9w8g
b6x/fvkZC3xdfDZHY/r9MtwOvLV/+nNnBstwKyn1dRrFsO+nNTRMFavY+xU1hPtJ
E6Ju9t9TgeLHd2vZYzbDJMiHjuDG5cwn/gvpM47h+WALG7LNxzVIHrKTnc6H/95G
yfLNZBMuwwJQdvzQvqd/yC80GUEhyJtxRj+uoi1Neg0RYXegZqgeLaI/3sPLb3gr
/CidGV/WKHeXmn/lKTsYFB3gjEMtIcWSCEpAeUPdXLQgv91Q2zSDV3BntICp89+G
wcoQNK7n2Jkg9O4yLYPqwNo1kcgk7ceCJd+rdNyTJtWpYqmNK8v+ScatFwKLERi2
/PLwDOYP9zCWJw6ryYA+wGdT2LTirJ7KC6csgW6SP0byCJGBp3BoTv17OZb8WLVu
mjr2VZCQjEZACulR79GJNtoBtIOAMiiviRfQBYrEj8q7S9/gaWlIe0GQNOxrlHCI
vO886b7hINCyhkRZcJ9DIgbJHtVO9DAV+Q1RWvq3T4IGa7QDK9U=
=6IP8
-----END PGP SIGNATURE-----

--gdI8iqFu+mV8mbir--
