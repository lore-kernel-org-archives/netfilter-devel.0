Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616302376FF
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Mar 2025 13:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742217601; cv=none; b=F7ZNE4YSn6sHxCn1qkl3zmLFkTRimEPeJAsB/SiYMctJ5FUbp/2xe7bAdPJyB8E4nd2oOXaQ39Qv3fxXlussdP5x4YnS5xKTa+kModPhrWfH2TMry+dAqchLox1Ss4o5gArfnyKHuvA2QcAI21r3oOioA3GWG5PVd6H1YLa6oJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742217601; c=relaxed/simple;
	bh=TOq3llmFRcQ0MRru9B7A8vqaZMVvNseDo2kOKZriPz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1RhjymZTViOn1COZ5fJhN5dpIZ1yLNoUlz9D94eQWoq5oEEFyOdePreU4uFtkl3on0PgibDOYVkDrHtIgarxHE56rVoeh6RBd/QCdr3YYuEthlyotluUb8DnnD1AwnZMBPSKDHt2iBVtpI10MPS1BuTbP47u/qw/OmNZyXEzwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tuANn-0001eP-FQ; Mon, 17 Mar 2025 14:19:55 +0100
Date: Mon, 17 Mar 2025 14:19:55 +0100
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] selftests: netfilter: conntrack respect reject rules
Message-ID: <20250317131955.GA5110@breakpoint.cc>
References: <20250313231341.3040002-1-aojea@google.com>
 <20250314092837.3381916-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314092837.3381916-1-aojea@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Antonio Ojea <aojea@google.com> wrote:
> +	# request from ns1 to vip (DNAT to ns2) on an existing connection
> +	# if we don't read from the pipe the traffic loops forever
> +	echo PING2 >> "$TMPFILEIN"
> +	sleep 0.5

This doesn't really work, 0.5 is too low for my machine
and the tests fail most of the time.

Can you rework this to use the busywait helper
instead of sleep?

The checks are also very repetitive, so there is potential
for code reuse.

Thanks.
