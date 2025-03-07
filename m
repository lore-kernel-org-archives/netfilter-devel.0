Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C96219A9B
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 12:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741352255; cv=none; b=XSGIRwU2CRs4MEH1TBtjXQo+HiYUXCJR6C1tZ6GZMZhh+wcRmVKyfVK2MIiBUyNazxrrlWDPKKP3huD7Jzb8WIMWhTHzVsXyis2/nXk9+O5uxoDBjDJZKNlTRXydFHkxM/73Wog5ijkTTPPjqwLcjTHotctWMJbGor+zZnXH8HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741352255; c=relaxed/simple;
	bh=Ey8Z70dzV02S7CmnqKA3n8FGfxnDKRpH9GQGNOqrJGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+Pbqvw30QHlW0mllVfZaUT+K7pzLbfii3e0Nww2Kc7VNUveIqv52eWtPg1DjE/yvG1MA7agxo1U7RN330k6wHo3wfjxfl8l4b2JmBQfLsi2TL0rnpD6BXXWBQ0dzRKL0ZZFmOyna+TCiZxn5SGUiYPSP/8343J8DUIKgaXmAeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nTcVmIFQ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nTcVmIFQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nTcVmIFQ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nTcVmIFQ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8E76D60289; Fri,  7 Mar 2025 13:57:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741352241;
	bh=dEwyv//b1oIBOpnGwkidaxFrvkmVhJiOQz+LFsFerEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nTcVmIFQFtFjjKqrJejcYD1RdvXCmO9RcrsakqIYOfKk4HNDX14IQwVT7LLTpdGq3
	 3+Nen7VxkXFsNOy8Q2Ub01yew9MQJkVk5XdqeEvhUNDqQf7yj6WU/T2ecurqOAI+ey
	 gvnkHyb/MRvMbQZe+Jz1XxjV6pgbBFuOvaHgFWSZ+LMUFohVdyfiNz6AjJx9E4Ausm
	 NxQbc6Okd0ECIe8qMlszxRSQJkLdJDBFEhtx7uuC3+sKIc3wv/09xBi6o4IdiyMGtN
	 KBd0ysu+mKFJ0oSUw9SIL/DzyzTCrdgCfYpKEbk+ramkBhvMDh7QaT3dzp0Sb+FyuQ
	 N09YfvVKE5gRg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E650760289;
	Fri,  7 Mar 2025 13:57:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741352241;
	bh=dEwyv//b1oIBOpnGwkidaxFrvkmVhJiOQz+LFsFerEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nTcVmIFQFtFjjKqrJejcYD1RdvXCmO9RcrsakqIYOfKk4HNDX14IQwVT7LLTpdGq3
	 3+Nen7VxkXFsNOy8Q2Ub01yew9MQJkVk5XdqeEvhUNDqQf7yj6WU/T2ecurqOAI+ey
	 gvnkHyb/MRvMbQZe+Jz1XxjV6pgbBFuOvaHgFWSZ+LMUFohVdyfiNz6AjJx9E4Ausm
	 NxQbc6Okd0ECIe8qMlszxRSQJkLdJDBFEhtx7uuC3+sKIc3wv/09xBi6o4IdiyMGtN
	 KBd0ysu+mKFJ0oSUw9SIL/DzyzTCrdgCfYpKEbk+ramkBhvMDh7QaT3dzp0Sb+FyuQ
	 N09YfvVKE5gRg==
Date: Fri, 7 Mar 2025 13:57:18 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 1/3] src: fix reset element support for interval
 set type
Message-ID: <Z8rtLmq-2Tiuy5dJ@calendula>
References: <20250306182812.330871-1-pablo@netfilter.org>
 <20250307111652.GA27653@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250307111652.GA27653@breakpoint.cc>

On Fri, Mar 07, 2025 at 12:16:52PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > From: Florian Westphal <fw@strlen.de>
> > 
> > Running reset command yields on an interval (rbtree) set yields:
> > nft reset element inet filter rbtreeset {1.2.3.4}
> > BUG: unhandled op 8
> 
> Thanks, please, push it out.

Done.
