Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3C71B3F15
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 15:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723648170; cv=none; b=HbFisfSiNCDepAej8tqpL9XAE9aZcaRsnWVa2DUMVYksQKvi6Xexxf6bzit0oDFonm4CzTc+XBQaDZMwdeRNVsEJGCHL0Nm3p9DN5+36HFE+4ooz4lqSmIMU8pm7oyPP3phf3cloj2a8e80B1HuVbDjedH8yXqNQQ0rXrngkjLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723648170; c=relaxed/simple;
	bh=XWco0P8uYjFaIurtgw2Y8v0GaH5guqC7dKEmjaSkbGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSjjbF+49c9/d65o7JzcUo21m3zeQOyh++rD5v78vyVHUowY9ihHxurjjTEvmqfLmqRBZ1Cm1B+rJh1np1J/zR285dworlHoGu+XEkh78smb4fG7bf0oWho9UB04pORQK55XcJuYzXV89nNfMdvT5fazhvvs3SRaRKrqUeNP0nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1seFcm-0005wZ-0q; Wed, 14 Aug 2024 17:09:20 +0200
Date: Wed, 14 Aug 2024 17:09:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [netfilter-core] [Q] The usage of xt_recseq.
Message-ID: <20240814150919.GA22825@breakpoint.cc>
References: <20240813140121.QvV8fMbm@linutronix.de>
 <20240813143719.GA5147@breakpoint.cc>
 <20240813152810.iBu4Tg20@linutronix.de>
 <20240813183202.GA13864@breakpoint.cc>
 <20240814071317.YbKDH7yA@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814071317.YbKDH7yA@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> On 2024-08-13 20:32:02 [+0200], Florian Westphal wrote:
> > Or, just tag the x_tables traversers as incompatible with
> > CONFIG_PREEMPT_RT in Kconfig...
> 
> After reading all this I am kind of leaning in for the Kconfig option
> because it is legacy code. Do you have any schedule for removal?

No.  I added a hidden kconfig symbol to allow for disabling it in
a9525c7f6219 ("netfilter: xtables: allow xtables-nft only builds")

I think we should wait a bit more before exposing the symbol
in Kconfig to reduce oldconfig breakage chances.

But I think all pieces are in place to allow for the removal.
