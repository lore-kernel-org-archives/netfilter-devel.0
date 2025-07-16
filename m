Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7359672635
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752688997; cv=none; b=YK7pD1z5zgZI+Ck14WWw6FvDl9Q4QW67G5jKpRee2XBaWyK7GMm3oXxUaDwf25KZRSYQW3K0lOKnjJfiDIs9IFCzwZUXuvH08pj5i779cyovKnSQhUYQeD5rY7Uq8mBwNPdzoBZLkok9y5ZOT+SpZFAfJpl1rprnPnp/xPNYbz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752688997; c=relaxed/simple;
	bh=o14CiS5cEFvwOmS2w8uEyjz9daMEnX9xyP2lU866jsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jWqZOYtNNtHKHOzQcmJsIFW31KdmmcBgdBQFr7c4SBXSH1RG5zbAb69lvU76mJCfpUQ7Uwen7aWdsv3wV0Zh/6iI4Ey1SmH40EL4ypT76XIpdoaTXC+pJDURbyUx2DYfuUgoPEt7CreOhGOJ6lF3tcrSj36oEHpD17flaHrv02I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 446D460637; Wed, 16 Jul 2025 20:03:12 +0200 (CEST)
Date: Wed, 16 Jul 2025 20:03:11 +0200
From: Florian Westphal <fw@strlen.de>
To: Razvan Cojocaru <rzvncj@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: __nf_ct_delete_from_lists crash, with bisected guilty commit
 found
Message-ID: <aHfpX9vdb-jMGPQZ@strlen.de>
References: <4239da15-83ff-4ca4-939d-faef283471bb@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4239da15-83ff-4ca4-939d-faef283471bb@gmail.com>

Razvan Cojocaru <rzvncj@gmail.com> wrote:
> It should crash immediately.
> 
> Maybe this is what you're trying to fix in "[PATCH nf 0/4] netfilter: 
> conntrack: fix obscure confirmed race"?

Yes, looks like it.  Reaping the entries hits the clash resolution
logic, i.e. for the iperf tcp stream, it will do mid-stream pickup on
multiple packets (e.g. outgoing data and incoming ack), then hits clash
resolution logic.

Thats not supported for TCP, so one packet gets tossed while the
'losing' conntrack entry isn't added to the hash table but has its
confirmed bit set on anyway, which the module treats as 'I can delete it'
signal.
