Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794427464;
	b=qSZqjUuSy8zo3UBq7Q3Trl4t4hN6EY9Tco5xCzRgIU8fZVzh22SlbdDdcpbdHZbA1cB6
	 SL7Qn4P6CuqCePqzrofx79a/3EvgeBuuhj2WdazKG3gLmcIdb41x6Oo5mJ4Fcp5gCqNuh
	 3xEC2vyXC6lzy25vk6ymrKPgD8iCkJCwoUuQ81P8o0o9SeUOY3MLkaigsOwbMQXdoxbR+
	 OUtH86JuZhJ7Dbq2MWLqHmrH+fznNS+7La7bKjuqcdhtnfFr3/UORjJ+/iNqceU7miysR
	 3Jriuw8ChFZWyhDj7C7TPaXYkvObD5bBkXIMa5VUraZHo89ty0N1/VHqkG/dpPXYoMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794427464;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=L4iODkX/6ayF6giLVTd1A8QVe5vtKXteJHmXGcGjk7Q=;
	b=fxs6fZaDB6YXIFz2qSeCydWzeLDXwDysQzBS+AcsEHh7uNlzb9hpoa2YF0Z+VVNbCWGz
	 ZrX4maiClT8h5cmBNbff8Jr6yUzR/XKS3OrVbPNZG2oJOGQsSTQc+QT7+yluVDL3R1uKW
	 34hQCEq+9wN7ii6zXo7+I9kIh2HZUpLYT+Uq60jCJscaVjLwU5GP7YNvWg8Ls+y/BIuQS
	 V7CabsRuHGSl7DgdviLdNPgNfCHz8/oYfLBv0Q2xp0zTmWjE1yjOaOlnmg4op7OjERfPS
	 iJS8JJ8SuJ8PRD3ugBNQm2EJWAdaV4r6xYlOtLrbrvHait+iJV45NRkuKpelLbquyTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B5F606A31C
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 20:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26B5F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 75E2C60420; Wed, 11 Nov 2026 21:04:20 +0100 (CET)
Date: Wed, 11 Nov 2026 21:04:11 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/3] Fix two leaks in error path, one extra
Message-ID: <avTKOyPy0mnDSXEZ@strlen.de>
References: <20261111170147.47501-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111170147.47501-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> The first two patches fix for a recent Coverity tool scan. The last one
> is unrelated and not worth sending on its own, but matches the other
> two's severity.

Thanks Phil.

Reviewed-by: Florian Westphal <fw@strlen.de>
