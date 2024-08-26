Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FA981741;
	Mon, 26 Aug 2024 07:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724656031; cv=none; b=a2d1AwSn2XgOnbSNsBdgi12QTBq7OX9SoKIwk46IPhZM/UP+o5YOu1KGfXk4S54Z1MzRzxMCXsmdhXzkTxd6ldoZ98xhxr0hNqBJo6pQfp+0j4YOJEJLUHqUktILXyx/oVqWIqqecGoYvf5k4NaBXoBFz5+lgvpxEmHmvF2ho5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724656031; c=relaxed/simple;
	bh=42zul1fG6Rl489afvdj1ec8Ys9cNKabK0VGknlfDbBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYnhh8mvv9TJqkPrS7zEn1VSh5U7Jin9sYSTAjGOX3O6cKHa4n4hPWkhUJtmXx40MkX+FF0364ws6KCN/jvfbaM1feXZRZa9Tzt4HDK5mB+y2Qf9t7ZfRiz0q9DMOcxpTMXhGcGIhIG1YLeDYmpSFZmtWrMMg38lJP7k7eQRR/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1siToM-00033J-Jh; Mon, 26 Aug 2024 09:06:46 +0200
Date: Mon, 26 Aug 2024 09:06:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Yan Zhen <yanzhen@vivo.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, roopa@nvidia.com,
	razor@blackwall.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, dsahern@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH net-next v1] netfilter: Use kmemdup_array instead of
 kmemdup for multiple allocation
Message-ID: <20240826070646.GA10527@breakpoint.cc>
References: <20240826034136.1791485-1-yanzhen@vivo.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826034136.1791485-1-yanzhen@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Yan Zhen <yanzhen@vivo.com> wrote:
> When we are allocating an array, using kmemdup_array() to take care about
> multiplication and possible overflows.
> 
> Also it makes auditing the code easier.

Reviewed-by: Florian Westphal <fw@strlen.de>
