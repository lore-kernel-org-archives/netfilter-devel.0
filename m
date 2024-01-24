Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33DC7A70B
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2024 15:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706110941; cv=none; b=VSIHfay/jHgJr3cEZJMbQireiCQ4cQLJkKE1BA8YUpst86EdvlLr2feC7HMXcV6as3D5cgzXSiZBR+LzEBcyCpcSnyBKKr7dd3nRYOQWL6cCD3Hnu/nVEWt2iDUqshahw47WHrB1WE9t3HW9Yr44WHNBFkXqytZeXxFAoSTFSo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706110941; c=relaxed/simple;
	bh=k/nOCSCwSVkfUUoxSMUURCeSewxNgz8NShaZZ/PDlCY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yixuy510UNbEItjCswPho4ZI8uJDCVqBNagKOKqd0WSyS3iqljvyA59VusctgbjqAad98QMLpTIcUUY/PRV6O9SlOVujeY9hCDF6EtGHxs1J96k+UkEmMEke19uiwl7sEgvyTgS7REJopbcpeNPGWEf0Vwf4Z9IC1XbRlWlO3vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rSfOK-0001Qr-KS; Wed, 24 Jan 2024 16:42:16 +0100
Date: Wed, 24 Jan 2024 16:42:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] extensions: libebt_stp: fix range checking
Message-ID: <20240124154216.GD31645@breakpoint.cc>
References: <20240123164936.14403-1-fw@strlen.de>
 <ZbEYDliDhUrO73eu@orbyte.nwl.cc>
 <20240124143757.GC31645@breakpoint.cc>
 <ZbElUwojpsHjxnGO@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbElUwojpsHjxnGO@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> While you correctly hate the game instead of its player, you probably
> hate the wrong game: The code above indeed is confusing. Maybe one
> should move that monotonicity check into libxtables which should
> simplify it quite a bit. I'll have a look. :)

Something IS broken.  Still not working on FC 39 test machine
even after fresh clone.

On a "working" VM:
export XTABLES_LIBDIR=$(pwd)/extensions
iptables/xtables-nft-multi ebtables -A INPUT --stp-root-cost 1
have 1 32765

@@ -150,7 +151,9 @@ static void brstp_parse(struct xt_option_call *cb)
                RANGE_ASSIGN("root-prio", root_prio, cb->val.u16_range);
                break;
        case O_RCOST:
+               fprintf(stderr, "have %u %u\n", cb->val.u32_range[0], cb->val.u32_range[1]);

I can't even figure out where the correct max value is supposed to be set.

Varying the input:

xtables-nft-multi ebtables -A INPUT --stp-root-cost 1
have 1 32764

Looks to me as if the upper value is undefined.

Other users of *RC versions handle it in .parse, e.g. libxt_length.
No idea how this is working.
