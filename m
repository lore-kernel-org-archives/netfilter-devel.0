Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8686C2F22
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2024 20:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721593565; cv=none; b=gPdqQM4cr8FrDIuqeDGHJq/D3UIqF6nerv07XYxLe8p1kUojVOTum3T09PprZdDCJrif0B7260ycdmiB43DgEyV/y8223D6fOfWikzoFuy+v9b0H3aIeC3ZzMwR48a9w2o7zP2To1y6efpebVKRQbHez1qRQqhMyUXV/JLmcJMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721593565; c=relaxed/simple;
	bh=6ij2PSK4VFySvn5pYvouAdctZJwfiXP+IJFzyqOl3Gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxG8zZ5U+Kc6twgJg3MN5NC8W1sI5IQu+EeXVfwGxTBwCkWqTHUOPSrKkiFhN3tAFk9AgQK9t3cejMuE4mpr0x7dgb2Yb5USINeAiyTAX9n9yJu6ianuPaUaF5iir1RCpy3s+arZ4vPQXnS9ATT9mLXsw9TTxFKsQwWVBL11D+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sVd7w-00070J-V5; Sun, 21 Jul 2024 22:25:52 +0200
Date: Sun, 21 Jul 2024 22:25:52 +0200
From: Florian Westphal <fw@strlen.de>
To: caskd <caskd@redxen.eu>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nf_tables/set: Is dynamic + interval possible?
Message-ID: <20240721202552.GA26873@breakpoint.cc>
References: <21LESCW6FS1QS.25Y6ZY142CF7D@unix.is.love.unix.is.life>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21LESCW6FS1QS.25Y6ZY142CF7D@unix.is.love.unix.is.life>
User-Agent: Mutt/1.10.1 (2018-07-13)

caskd <caskd@redxen.eu> wrote:
> i've been trying to set up a more dynamic table which can also merge stuff and additionally accept administrator entries to the filtering sets.
> However, i've been unable to mix dynamic with interval as the kernel returns a 'Not supported'. Is there a configuration option that needs to be enabled in the kernel for this to work or is the code just not capable of handling this mix? Thanks.

Not supported.  Only the rhashtable backend supports insertions from the
datapath and a hashtable cannot handle ranges.
