Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D231714B4;
	Thu, 22 May 2025 06:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747895688; cv=none; b=aDPImO8K2WykeQPW+hljLWnak3XXT+inIihQgXj+02y77LyEwOyhfGNw7eJyk/+Ef+cBDnYtF4U7qkzMg3uZLBZNHo6N/PRyq/mjI437qhacLbQvjsgLz+vGao3B77QsWKZ003qBJaiFGYMeTI2P73S/7lFhyBKey0pw+PvPSqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747895688; c=relaxed/simple;
	bh=JEazXizDWPNo8BblEGRAdajOpB5k5fF+Rd+pkbF/nU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ilZQs7HqCdRNioVOX4hM+NlHoxZKtsayHkvd7M9SkW+Kg2pM7H49Shwg3IqSWNJ3r6AnANVY7wtnjUb+jS5t5uGXMkR89Fkc35oiEDfZvZLmvomM9I5qF2LAxGruvNhVOFFKv8SZ23LegkL/8JHlfP81QM5/+DH/YT9kyBKTzVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 793DC60147; Thu, 22 May 2025 08:34:43 +0200 (CEST)
Date: Thu, 22 May 2025 08:34:43 +0200
From: Florian Westphal <fw@strlen.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Lance Yang <ioworker0@gmail.com>, kadlec@netfilter.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Zi Li <zi.li@linux.dev>
Subject: Re: [RESEND PATCH 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <aC7Fg0KGari3NQ3Z@strlen.de>
References: <20250514053751.2271-1-lance.yang@linux.dev>
 <aC2lyYN72raND8S0@calendula>
 <aC23TW08pieLxpsf@strlen.de>
 <6f35a7af-bae7-472d-8db6-7d33fb3e5a96@linux.dev>
 <aC4aNCpZMoYJ7R02@strlen.de>
 <1c21a452-e1f4-42e0-93c0-0c49e4612dcd@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c21a452-e1f4-42e0-93c0-0c49e4612dcd@linux.dev>

Lance Yang <lance.yang@linux.dev> wrote:
> Nice, thanks for jumping in! I'll hold until the helper lands, then
> rebase and send the v2.

Please just add this new helpre yourself in v2.
