Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780AB2BEFE7
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 09:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773221705; cv=none; b=eohMzVFP6tQpXxY2x37OqQD4Z8kGVFtBzJjamzAeXWKmx6JeUatCkWQKzRNubphqCC0/abT6clRFk6RWohvfBuBfDukGIbEmddpoyFIS9NKcaLK8yOgUNQpurZGvk3yHcUole6HkN9oJ0ZD8z2boUSjkerfrymQVGwVqQ84G6qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773221705; c=relaxed/simple;
	bh=Pe2nqGype9qhM0z3mCGo8xexBNrZf0xMktl390BX0D4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZp6uN8TjEQ7kFjoWUjVk30TYqMUrJxg6fUd2929RP6lUZlRYwUJCcM5hlCsVjklo01/C0gqFnhEcAcGLXH/iUGc6jptbrghA3oa+yc2j4bE8I66SCh4tcWkFw0Vh8KLzJnzmcQpS5IGzyr3xCbOxaqp2lw0gFNXGCawPz8OaoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j6ggvZyG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j6ggvZyG"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7076E602B4;
	Wed, 11 Mar 2026 10:35:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773221702;
	bh=rFNsuahz/WA9vb+hRzr93kPXkIzQXv8DT8ZZrBKUcIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j6ggvZyGZmRAxBREIUgNKAUrLxIl6pU/lxyiaY2q7PL15IHSyRCkfTz5ncKVnGkqa
	 n/tfnxKISP0pRRP0aMraZfeQKye7s3wZR8Nxd9JRk8HwNsJj7rdo/4SKUW2/zJz+cq
	 XTqyZuxwb4gvRy7Rbgq4F6BBZvwLrb8/24OQmlACgxygg1itI2joEogvSl/VZa67D0
	 n0AvevjIdgkzdJVH5bo4UplFKWzOZYlCcZNp6z8SQgXWQ9BbjMfk1BkauQTYBUHUnj
	 sV1dmpCTx3aH1dcVVBGTfOmR4ORajx8TIhTDfa0qq7h6yJgd2xEFAhAM98Q0fTHK4T
	 hjPTvcUIOIx6g==
Date: Wed, 11 Mar 2026 10:34:59 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/5] cache: Respect family in all list commands
Message-ID: <abE3Q6E9eZEm4-DZ@chamomile>
References: <20260310231115.25638-1-phil@nwl.cc>
 <20260310231115.25638-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260310231115.25638-3-phil@nwl.cc>

On Wed, Mar 11, 2026 at 12:11:12AM +0100, Phil Sutter wrote:
> Some list commands did not set filter->list.family even if one was given
> on command line, fix this.
> 

Fixes: a1a6b0a5c3c4 ("cache: finer grain cache population for list commands")

> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
