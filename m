Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2934B2E0917
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 15:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756827221; cv=none; b=aYW0dwIkuSgNtGoCMQTECR/2jrGkVQtAZycus34PC5SkMzmP18zAJj6+g0s/7m6LxS5aQFqA0MIBeM3AvwD6pgAXv27Fc9WCEJXPSvKUpiT+zu0kOMgkEjnHI2W6+ixq3g1kOb9viEMXeTyd1s0xtdUOcJxMq6Gf7S+UT5fcSBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756827221; c=relaxed/simple;
	bh=lLCbMlza5ROMMbbePQDk/andc/Y60ckqpOqfg4Z+xRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P16elzQiFE6PwZisPtXc79CPB7U7jWB3TMQUqdDoN6+lcnJ3nzC++3jZPv4pCodS/dzeJT9MNsNgwYeotyJf2ptetZhf/TIH5JqAnK3tzdwcuZqYqqOgtZLf/oWQDwUxognl9NGA89AHEPN7H6QJ61IYdvnGDs+ud+GlOpK27VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LuzVSPVy; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LuzVSPVy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LuzVSPVy";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LuzVSPVy"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A0768608C9; Tue,  2 Sep 2025 17:33:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756827217;
	bh=jdzgY4yVOTQ9QBjw4p7/1cYgRNHZSNtGqzvhcRUuMX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LuzVSPVyOkmUGofsFzKUV+Go+p+tgATMYYVyKL4Us0MO70k4CscOVGwZ1MUzX4zqS
	 R2RfXEesd6sn4oRFc2rHBv8++m/KqqkD6l2gXfHiNWfR2scZSo8V9Lwaorxz6WA8ps
	 t6450IWgkhde4RVQkF2/6jEW1gOjHhxRm0274vtAU8KXtxdyY/arY2+34JIQG1COAj
	 J+WvqM9+eC2uy9b9FNe0Rvl0aw3qEDsdbYWivGSJrcpwWfMNAMF9wWmbaXo6cUZ0uY
	 2wDHqLQpViNdeaZfXGlpDk7N5hlZN2MlxTw5oUTyWDeq81lLRqbc1Oo5bKtJ0cESv3
	 iJtUvIxVfJUlw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 12E27608C6;
	Tue,  2 Sep 2025 17:33:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756827217;
	bh=jdzgY4yVOTQ9QBjw4p7/1cYgRNHZSNtGqzvhcRUuMX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LuzVSPVyOkmUGofsFzKUV+Go+p+tgATMYYVyKL4Us0MO70k4CscOVGwZ1MUzX4zqS
	 R2RfXEesd6sn4oRFc2rHBv8++m/KqqkD6l2gXfHiNWfR2scZSo8V9Lwaorxz6WA8ps
	 t6450IWgkhde4RVQkF2/6jEW1gOjHhxRm0274vtAU8KXtxdyY/arY2+34JIQG1COAj
	 J+WvqM9+eC2uy9b9FNe0Rvl0aw3qEDsdbYWivGSJrcpwWfMNAMF9wWmbaXo6cUZ0uY
	 2wDHqLQpViNdeaZfXGlpDk7N5hlZN2MlxTw5oUTyWDeq81lLRqbc1Oo5bKtJ0cESv3
	 iJtUvIxVfJUlw==
Date: Tue, 2 Sep 2025 17:33:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 3/7] tests: py: Set default options based on
 RUN_FULL_TESTSUITE
Message-ID: <aLcOTrTUs5D95pKN@calendula>
References: <20250829155203.29000-1-phil@nwl.cc>
 <20250829155203.29000-4-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250829155203.29000-4-phil@nwl.cc>

On Fri, Aug 29, 2025 at 05:51:59PM +0200, Phil Sutter wrote:
> Automake is supposed to set this for a full testrun.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  tests/py/nft-test.py | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index 78f3fa9b27df7..52be394c1975a 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
> @@ -1517,6 +1517,13 @@ def set_delete_elements(set_element, set_name, table, filename=None,
>      signal.signal(signal.SIGINT, signal_handler)
>      signal.signal(signal.SIGTERM, signal_handler)
>  
> +    try:
> +        if os.environ["RUN_FULL_TESTSUITE"] != 0:
> +            enable_json_option = True
> +            enable_json_schema = True
> +    except KeyError:
> +        pass

I would revisit options for tests to:

1) Run all tests by default, ie. native syntax and json.
2) Add options to run native syntax (-pick-one-here) and json test only (-j).

Option 1) (default) will be fine for make check... and CI in general.
Option 2) will be only useful for development, for troubleshooting
broken tests.

Then, add the env variable to shortcircuit tests with distcheck-hook:
