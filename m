Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB7A69D2B;
	Wed, 31 Jan 2024 08:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706690881; cv=none; b=QmJby5b5OGcPsZsknED/K9N9cWHqZrXYZY205cHAAO23SJhZW9uX5ss18cRf0aszrx23LLEZSRe7xbelhios1IuYfa3QJVQAwoiK/NQ57YQLjpnECRZHnFwvsGqZxiwV1hY5dGG64lcZ2c/U6p6nd9UPFdEeI8WRZ+w7gcnhuCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706690881; c=relaxed/simple;
	bh=ij5Yf+5MnL3JjxIUsCyzKk4g2PBHdsqM7jo5MnZIDtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DsX7vM1qkX3vz5P8GrxUEQVfZpO7O4883L/m6XmjZwuHS4H8zeAF/93Bc0TCk4UBazSKoTpZQc/21V8Ny08ZmSewOH8dwDbjcNpgtyQvcmhfuxpBemdX5ZaJcd6jtTHYp+5noHhzy44EkOb0Bur7BvnqJ4aDo5Fy7Z/9TaofFRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=45094 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rV6G1-00GU9B-UQ; Wed, 31 Jan 2024 09:47:47 +0100
Date: Wed, 31 Jan 2024 09:47:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/9] netfilter updates for -next
Message-ID: <ZboJMGQ73Yo1fHf+@calendula>
References: <20240129145807.8773-1-fw@strlen.de>
 <20240130183729.5925c86d@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240130183729.5925c86d@kernel.org>
X-Spam-Score: -1.9 (-)

On Tue, Jan 30, 2024 at 06:37:29PM -0800, Jakub Kicinski wrote:
> On Mon, 29 Jan 2024 15:57:50 +0100 Florian Westphal wrote:
> > Hello,
> > 
> > This batch contains updates for your *next* tree.
> 
> The nf-next in the subject is a typo, right? It's for net-next?
> Looks like it but better safe than sorry :)

Yes, I confirm this is net-next material.
