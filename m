Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97D0DDA0
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 22:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727304455; cv=none; b=h47clq9KQz4w1yHw8rE5q9XHUy6/9L3aPXr/O/B9Uo9K4WlAQLmTA9icjXZGtGRqyXEUVMeSMS/MNMnF16fLP5FPKAUt81O9ISWMvXu6j5IUnsSd6gj/bBYsFWfh5xCgARi/rp54BUe/WwL90hShY2WVAiEQpaT//xA+SSFgcLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727304455; c=relaxed/simple;
	bh=/9ssXvUZcvmHN5OAb5g1AFhz0Ffn9wRQVnq5IHXLLhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdC9+lvR7kOubFE1CSr8d3/MZK+QmiMRXweTUDPIgnvuKpa5ZEUndLB5cF6bof+teeZlYSUw+wHPbKXuY5dl+JKrezR4fwtfIFfnIc1QpyTDQBIhJelhcQUYLmDOAFgCf1m7Imzx4L8dFSNFB5qsOtuyQOQ5F5/fksf8Qgci1CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nNWUBYDa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nNWUBYDa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A6XzgIzfjDqxLTNJObFsSjzNA7xtjsoAKSlFJe1POsA=; b=nNWUBYDaCddUiknX7jUjxsJ60b
	RXzTBR6WxsnsbbIW7lxUFaIPWgVIdbH1u1Q3WSZWAK85xNVgy/qhBxXhWOEPuSbBpld1zs62Y9LH8
	iOvwbkMDfccsSa03SgKYiqR1VCkF8ySU7sCF5QARztVcw6PE7b7gJ5jPvIXfKfIMj/OIPRusOOv39
	unRIoYQHkzu90IEGLE/O4AxzVSKVHnwAohUX8psSidjN8AH9Aafgix/tnqY5KwjWMhjI3AWtStBXO
	loQiAw+Wt6o7dhI/oUtXnvXsUcJKLvnT1iUsxvlO7TTp09NPIxD0aqMQXD2AuViQXk+aS7G/S2TAQ
	tNggsyag==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stanC-000000004Kb-0cVv;
	Thu, 26 Sep 2024 00:47:30 +0200
Date: Thu, 26 Sep 2024 00:47:30 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 5/7] cache: consolidate reset command
Message-ID: <ZvSTAoV3thoJlKRw@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240826085455.163392-1-pablo@netfilter.org>
 <20240826085455.163392-6-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826085455.163392-6-pablo@netfilter.org>

Hi Pablo,

On Mon, Aug 26, 2024 at 10:54:53AM +0200, Pablo Neira Ayuso wrote:
> Reset command does not utilize the cache infrastructure.

This commit changes audit log output for some reason. At least I see
tools/testing/selftests/net/netfilter/nft_audit.sh failing and git
bisect pointed at it. The relevant kselftest output is:

# testing for cmd: nft reset rules ... FAIL
#  table=t1 family=2 entries=3 op=nft_reset_rule
#  table=t2 family=2 entries=3 op=nft_reset_rule
#  table=t2 family=2 entries=3 op=nft_reset_rule
# -table=t2 family=2 entries=180 op=nft_reset_rule
# +table=t2 family=2 entries=186 op=nft_reset_rule
#  table=t2 family=2 entries=188 op=nft_reset_rule
# -table=t2 family=2 entries=135 op=nft_reset_rule
# +table=t2 family=2 entries=129 op=nft_reset_rule

I don't know why entries value changes and whether it is expected or
not. Could you perhaps have a look?

Cheers, Phil
