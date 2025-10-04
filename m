Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C19C23E25B
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Oct 2025 10:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759574835; cv=none; b=lCBo3GXz9yhnFk9mKyG7jQfxMCoYpoOmy3CyJFF4JaVVutTGgfgx31RRqoJDyjkCS9SsXgojHW5XIxVv9qtnYpSaZftvz/5VMuPX/7640zx27m529bbcepVaqItUn1vCUutdECBQwisZHcXvn873XOBoNu+RGvt7XaqEAgkrrfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759574835; c=relaxed/simple;
	bh=xwPcWabqODl0E3lxIG7ITDFreL+63v3uosxsRxvXrec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7F8OWuUQeGcAGbKJO/qVclvWTzrhM1r6fWir32oH8rao5T9PzhudBISXk5N4gd+BoJGrLP4eoc28zP+7daoZlrrV5dSmBzlxcp/e2aeZ1y1FLPxmMjn3cRRGCZcN4Qq6kT/UfNm6Ugrii7auGKbTr1pCb6YT0XFQuYtYZIlib8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C44C760326; Sat,  4 Oct 2025 12:47:01 +0200 (CEST)
Date: Sat, 4 Oct 2025 12:46:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fmancera@suse.de
Subject: Re: [PATCH v2 2/2] selftests: netfilter: add nfnetlink ACK handling
 tests
Message-ID: <aOD7IaLqduE9k0om@strlen.de>
References: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de>
 <20251004092655.237888-1-nickgarlis@gmail.com>
 <20251004092655.237888-3-nickgarlis@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251004092655.237888-3-nickgarlis@gmail.com>

Nikolaos Gkarlis <nickgarlis@gmail.com> wrote:
> Add nfnetlink selftests to validate the ACKs sent after a batch
> message. These tests verify that:
> 
>   - ACKs are always received in order.
>   - Module loading does not affect the responses.
>   - The number of ACKs matches the number of requests, unless a
>     fatal error occurs.

Thanks for the tests!

This looks good to me, justs one minor nit.

Can you drop the shell wrapper and just call unshare(CLONE_NEWNET) from the
fixture setup function?

> +++ b/tools/testing/selftests/net/netfilter/Makefile
> @@ -37,6 +37,7 @@ TEST_PROGS += nft_zones_many.sh
>  TEST_PROGS += rpath.sh
>  TEST_PROGS += vxlan_mtu_frag.sh
>  TEST_PROGS += xt_string.sh
> +TEST_PROGS += nfnetlink.sh

>  TEST_PROGS_EXTENDED = nft_concat_range_perf.sh
>  
> @@ -46,6 +47,7 @@ TEST_GEN_FILES += conntrack_dump_flush
>  TEST_GEN_FILES += conntrack_reverse_clash
>  TEST_GEN_FILES += sctp_collision
>  TEST_GEN_FILES += udpclash
> +TEST_GEN_FILES += nfnetlink

replacing this with
TEST_GEN_PROGS = nfnetlink

... should make kselftests run this prog just like it does
for TEST_PROGS shell scripts.
