Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4246A34D
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 18:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710958078; cv=none; b=NdiHEQc3Jaz/KNPdKClwd1umFSiEaO/KnQfrVhk8msGhw7EHGM8HDgYyKBiwwZNCF07vnHESop6U5YNFA9tUXaAwcBUXEs33JFZSNyz/rNXvQQpQQY4zTN9y09Br4q849vLIBNMkSf0zNqkZQ981nm8HEUSoAEU8VhVFqH+BlrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710958078; c=relaxed/simple;
	bh=WUqUW5wnmYocVuRMnJ/WT+2jnHh1SDxXGaFxQ1wGIuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahNz0A9Pk0sfmQZLHTJqVzSMqgzjf8Z6YkdKNG9h3bRtcQ3HUKf5i63CguN2Kn3njaXRGemZQx56e+NAlhvXEouw2E6tWEevr34zMMZezv6h8x2TRB3N5FX+/WY3Tj1oywY44498R+zmBW2X2mhw/1bdaI4e2KUZBdk1s9YZhJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 20 Mar 2024 19:07:52 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft] netlink_delinearize: restore binop syntax when
 listing ruleset for flags
Message-ID: <Zfsl-JagV67u9tNG@calendula>
References: <20240319110337.42486-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240319110337.42486-1-pablo@netfilter.org>

On Tue, Mar 19, 2024 at 12:03:37PM +0100, Pablo Neira Ayuso wrote:
> c3d57114f119 ("parser_bison: add shortcut syntax for matching flags
> without binary operations") provides a similar syntax to iptables using
> a prefix representation for flag matching.
> 
> Restore original representation using binop when listing the ruleset.
> The parser still accepts the prefix notation for backward compatibility.

Amended tests, which were not correctly updated and I pushed it out.

@Phil: Sorry, this clashes with your recent updates to make more
compact representation of flags in json, you have to rebase.
