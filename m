Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1BB84039
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 22:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715638688; cv=none; b=XcwE2FChvCPP/u6mVVobJOgy3SLsi4uTTLYAyd7fpNYEpIUqJoaNrz8pzvk/jjxVmvJ5VOMElgy+OZXH4UF95KImgDnoKPopbk65rnfcJX1kLagPd1f6Dqe8dlcmkehYcUf6xczS06Bc3G1tBECzCJSVc9Zu1wY0roYhp7IzBs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715638688; c=relaxed/simple;
	bh=6Kr1xb5cfM38UNAt7CUtlAfrHYa7uz9/qWDWMyqFeiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PuzZI5LfLMDAhHiIZpide/djI/FjqfVcXGyMQSRDVXhwslyQ8BQ6+dNrXLPpSojmBmNE8Y0jHE4X0ZQkvCZVy8yXXHy8jJsUF6tpar1KcEFzg5knKy8vAxqrCqljJwdgsujFgQjSM0FydAmdI4OsatOI5EQyrSaBTPMzaov2KYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s6dzf-0004z7-Sa; Tue, 14 May 2024 00:18:03 +0200
Date: Tue, 14 May 2024 00:18:03 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v3 1/2] netfilter: nft_queue: compute SCTP checksum
Message-ID: <20240513221803.GA4517@breakpoint.cc>
References: <20240513220033.2874981-1-aojea@google.com>
 <20240513220033.2874981-2-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240513220033.2874981-2-aojea@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Antonio Ojea <aojea@google.com> wrote:
> when packet is enqueued with nfqueue and GSO is enabled, checksum
> calculation has to take into account the protocol, as SCTP uses a
> 32 bits CRC checksum.

Reviewed-by: Florian Westphal <fw@strlen.de>
