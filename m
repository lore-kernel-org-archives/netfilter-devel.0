Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF983A1D2;
	Sun,  4 Jan 2026 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767539789; cv=none; b=rV7IL5n0+SI5bMoMlDc4FalrgkEe9MrovzBaxSv9BkrwqbxppzlKh5F25hnJSdDo6VBwqqKedswM/IZU+c41Ty9navgLDZKN5aZ5DnzawoSj3RcfOAd7mKOYuY7Oa1SVsfL87uvNFXbouRQXJOr0t8BeD7BUY3SDIDpsUdgTdSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767539789; c=relaxed/simple;
	bh=yHUekBp12VSP+83c1RqvPtEF4QbjhP7Cs3xnjhKMlXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQz6B6XvgNxKpMbB7I2e6uPMenyBNVB8b0bGkAxbEM5zlJh6mjcFTYN4roleWKkXKaboW8SvRKQuDAqpT3x1c/FV76MOsg3WRfkDGQbUFI1CU4KRYaV/+tjNRVyTVUbREX7lvqYJTDgDkzQpZFqT0WLKd8hBNdbXf1dHIHqrB84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8AC13604E3; Sun, 04 Jan 2026 16:16:18 +0100 (CET)
Date: Sun, 4 Jan 2026 16:16:18 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net 0/6] netfilter: updates for net
Message-ID: <aVqEQqdqajSAM7XA@strlen.de>
References: <20260102114128.7007-1-fw@strlen.de>
 <70d635b0-b5ca-44fe-90b1-da2303ff09ec@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70d635b0-b5ca-44fe-90b1-da2303ff09ec@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> FWIW, infinite list growth is still possible when insert rate is high in
> nf_conncount as I noticed that the commit "netfilter: nf_conncount: increase
> the connection clean up limit to 64" was not included in the pull request.

Intentional.  The other change will be handled via -next.
