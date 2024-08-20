Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FAD18C938
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 09:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724145950; cv=none; b=unXQOD8DoQ0AfRPIBR7WkYzMrJTs82MZGfJYiR9vEQVpdQgX7RVjEvLJUM8ciwT/BuBWzEDNjhtxuFaxXGQ5uCrxV0L6nKHbZ7PvwXqw+jb4Qip80p5grOUrygu1tFRlZyp0H/qnsBXQ8SDblablx4PCVkr61YBP9DHFSgtBjtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724145950; c=relaxed/simple;
	bh=UONA03LlrjlzOnPRzACq9pWgJadQQSrRxvdCKiqtVag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HkUvuBKZS7X1Y4czeXmsAPLT4kmdbFRfFB9CKLJ8wC1T+MNBuL1H8f9DIuFoVqiWJZKbMOuvOqF2o4fbsNctl5szoxe0wgfGFFHxFDUEnrp7HDlybTOMxBt6+pBNgGCUcH/ZaHXxsSuP1+qn7MDJOYM8NYI8onDtgC4GovF8snM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sgL7Z-0003xK-4c; Tue, 20 Aug 2024 11:25:45 +0200
Date: Tue, 20 Aug 2024 11:25:45 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net 0/3] netfilter: nft_counter: Statistics fixes/
 optimisation.
Message-ID: <20240820092545.GA12657@breakpoint.cc>
References: <20240820080644.2642759-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820080644.2642759-1-bigeasy@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> I've been looking at nft_counter and identified two bugs and then added
> an optimisation on top.

Looks good to me, thanks!

Series: Reviewed-by: Florian Westphal <fw@strlen.de>

