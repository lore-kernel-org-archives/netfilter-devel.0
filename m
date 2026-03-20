Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9086D3803DC
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 11:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005104; cv=none; b=R26Alu11kIeUTDim4XY8DqYhImtGXXzuw1uTxnmRvsTFNURA2687yeHDy91l4qbw+fuF58pwmw/TVwuNNI7q8I/tasBsRMQuzmVg9iKVqIQ5Ujv065E9X7hy2yOIa4ZOJuQ+5+D1U6aK4KRpMyjwsjvtzWJMatAsZFPoAc74JqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005104; c=relaxed/simple;
	bh=1bfx3YP0wGIl+U7CIUPG4i5J4a1CPltHbtNuLwbzku8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEt7rNeKdQr36lEAG70XL/kLll0iVL+h82ELp2Hnh9GQgxPwI/TiYVrdTtEAGrSo5fkBYPaRMrR9BXVgDsyo1RPN9EzqnnmlETJRseuZTx2v6+bYlK4OrThyGNodKAECEYxnqTB3G94EPpLtORWNQcAF35EHltjDF09T43Yvrvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KzoX5obv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KzoX5obv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1bfx3YP0wGIl+U7CIUPG4i5J4a1CPltHbtNuLwbzku8=; b=KzoX5obvkAsLoc0A0nrAB14cok
	iAUy2BfByb2F10xHJZn5Njwcj8xZgIxl3+LrSjiEQUy6Oan22NZbU07xf1bNEAngsDE4KWr495/U1
	r0Yg+wXN7HbI8OcsJG0CO8cgR2yd5c8sp5ytzLNjAjiIjoSADfxy0+TOrdIlrWQZvbtcJhUSX4x0X
	9TGciwBuwASD988aSStbKLKV74UzVK1qiIA9SA3KMP1/JE/bfkCveNXQa8JEhKbHaKbTXEDLiTBS7
	QibsOYjgJOSl19EJvtcBpnEK7G6Bhy9+I92QacrRJ1Rza9oWw241jm8ZxgAuXRFNXIAljbhJoaHQd
	0wCez0dg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3XlV-000000006hu-05iC;
	Fri, 20 Mar 2026 12:11:41 +0100
Date: Fri, 20 Mar 2026 12:11:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <ab0rbTfE7LWIk7f-@orbyte.nwl.cc>
References: <20260313153220.19662-1-phil@nwl.cc>
 <abwegj2TijkaQVLz@strlen.de>
 <abwraHUuxizN4krg@orbyte.nwl.cc>
 <abwtAkSF8-SmH684@strlen.de>
 <abxlzn7lymOxWUFa@orbyte.nwl.cc>
 <abyTyJBv47f3v9gd@chamomile>
 <ab0enMtOAFiG0mSN@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab0enMtOAFiG0mSN@orbyte.nwl.cc>

On Fri, Mar 20, 2026 at 11:17:00AM +0100, Phil Sutter wrote:
[...]
> A remark from a practical perspective: Florian's suggestion to dump the
> nat-type chains in their order with the dispatcher's priority value is
> super-easy to implement (just have to pass the priority value to
> nfnl_hook_dump_one() via parameter) and does not require adjustments in
> user space.

Famous last words. :(

In fact, user space calls basehook_list_add_tail() for each received
hook message which (contrary to its name) inserts sorted by ascending
priority value. It does this by skipping as long as the cursor's
priority is lower than the new element's, i.e. hooks with same priority
value are inserted in reverse order than received. This is a no-go since
ordering matters, right?

Cheers, Phil
