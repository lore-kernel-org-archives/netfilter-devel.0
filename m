Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA0F5B1E1;
	Tue, 12 Mar 2024 12:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710246274; cv=none; b=dblpjvVuRtLNIvSH3pP9AzzEzx2uFfxc2xDduabFJaaRu1d82y/JoWlkXldX32vqiUJl07Xzw5TQkc3XK7+j1DdFYlqKy11YZPa9tjLApJffkbpdrDQYV4v6S/NL53pwY2jwhwOu0HP2Ywfd6NtmUEvKLYYNKT2tpocYUvUpWQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710246274; c=relaxed/simple;
	bh=zs86aPSvkU/VAl2s2fTJ/BbtTz0LkfC5BDWzy3W42sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZLkOkFhAV2VNEwUaV/0nghwCkawH6dkWQHVWHRDFeG1/9Q66HBWjCKOYxgYyEq9PdW4Sux5AqH8qsr8t9g8dkkmSMpaLqmTOOnYf85+x66BB5+VA6rxGcXn6zczLYWCMWfzSW3IH3ef/mzAlp3OqvzycklAi7uLrJeIzH/WHZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rk1B3-0000mU-Vu; Tue, 12 Mar 2024 13:24:17 +0100
Date: Tue, 12 Mar 2024 13:24:17 +0100
From: Florian Westphal <fw@strlen.de>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
Message-ID: <20240312122417.GA2899@breakpoint.cc>
References: <20240311070550.7438-1-kerneljasonxing@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240311070550.7438-1-kerneljasonxing@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jason Xing <kerneljasonxing@gmail.com> wrote:
> I think, even we have set DNAT policy, it would be better if the
> whole process/behaviour adheres to the original TCP behaviour as
> default.

LGTM.
Acked-by: Florian Westphal <fw@strlen.de>
