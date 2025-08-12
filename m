Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F87E2DECD8;
	Tue, 12 Aug 2025 09:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754990570; cv=none; b=anN6lQ5l2uFMFgycCsgc1z+sQgrXexMyw/z1hiow5yeeHvTm+3c8GIU800g8EHf381CNW2oDXa2Ktg865KrQfhIF12re1IZiCSeCWPfZ6C03XGoixt8UU6sg8PnjejvuB416Gbxff/P+H1KrvzsQpB/HxqFJJ9L6qFnCw0ol8ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754990570; c=relaxed/simple;
	bh=Bn0nLJ0eSfQmwvtXaMVruZB+z6pgSxe46LyjEl2CuZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1dKK/JKotyRUcokPfBI9gTEAKTjj+gpCd2IcmLjoFaV7HM0ProdP8AJn8UFUsIaWnNs9pc+pIzue2q51lTorKvP0Sbdv21vGpWxaQ+YtwaSkpcaXslgE3BUbosm67Tg0OpHD3z4YM1P1WZnes0k/iV6JPlFCReoZE6/fhV5tTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 067F060172; Tue, 12 Aug 2025 11:22:45 +0200 (CEST)
Date: Tue, 12 Aug 2025 11:22:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: nft_flowtable.sh selftest failures
Message-ID: <aJsH3c2LcMCJoSeB@strlen.de>
References: <766e4508-aaba-4cdc-92b4-e116e52ae13b@redhat.com>
 <78f95723-0c65-4060-b9d6-7e69d24da2da@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78f95723-0c65-4060-b9d6-7e69d24da2da@redhat.com>

Paolo Abeni <pabeni@redhat.com> wrote:
> > I don't see relevant patches landing in the relevant builds, I suspect
> > the relevant kernel config knob (CONFIG_CRYPTO_SHA1 ?) was always
> > missing in the ST config, pulled in by NIPA due to some CI setup tweak
> > possibly changed recently (Jakub could possibly have a better idea/view
> > about the latter). Could you please have a look?

Can't reproduce this here.

Latest net tree:
vng --build  --config tools/testing/selftests/net/netfilter/config
grep SHA1 .config
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
CONFIG_CRYPTO_SHA1=m
make -C tools/testing/selftests/ TARGETS=net/netfilter
vng -v --run . --user root --cpus 4 -- \
   make -C tools/testing/selftests TARGETS=net/netfilter run_tests TEST_PROGS=nft_flowtable.sh
[..]
# PASS: ipsec tunnel mode for ns1/ns2
ok 1 selftests: net/netfilter: nft_flowtable.sh

> > NIPA generates the kernel config and the kernel build itself with
> > something alike:
> > 
> > rm -f .config
> > vng --build  --config tools/testing/selftests/net/forwarding/config
> 
> Addendum: others (not nft-related) tests (vrf-xfrm-tests.sh,
> xfrm_policy.sh) are failing apparently due to the same root cause
> (missing sha1 knob), so I guess it's really a NIPA issue.

Looks like it, I mean, I can't repro it here.

Let me know if I missed anything or if there is something I can
do to help debugging this.
