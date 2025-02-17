Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B3C21B8E7;
	Mon, 17 Feb 2025 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739808940; cv=none; b=WCldfbeaHoVKmt4hrN3UvVePX7wO7Rh1D0Uhk6+qreJTngHJp2Bb594ZVWDgVGtRyQHCW7fhUfFxNGNu/11dTTPdBZd54wz+vk90Q9xCuZQt28okOIRziUO6PpNsAiGN88IY1E7IiIkEQ2crXomZjoesIUis5vHeoX9fEgwVoXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739808940; c=relaxed/simple;
	bh=SaCiYRwcDexWRBigNOv6fWIaykyRpPKPoGiWIfAoMjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s04MZnrMLIuW2yNkfe6DpCZdmWhzbcL9pP0SJYNhqA/mcCJf9fjs1cUI8lRsA+W/I0VFlqs4p2Man5XG2ImPfoF6xCEcnmsy1Yyz6gHRdwf+o1sRbEfCSj6+tGW+8o6VH/YhMvTkvROnRaJ6LCSci/lMquyVbFVaQBFrfLCfjjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tk3mR-0005gy-Fs; Mon, 17 Feb 2025 17:15:35 +0100
Date: Mon, 17 Feb 2025 17:15:35 +0100
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] netfilter: nft_ct: Use __refcount_inc() for per-CPU
 nft_ct_pcpu_template.
Message-ID: <20250217161535.GA14330@breakpoint.cc>
References: <20250217160242.kpk1dR3-@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217160242.kpk1dR3-@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> nft_ct_pcpu_template is a per-CPU variable and relies on disabled BH for its
> locking. The refcounter is read and if its value is set to one then the
> refcounter is incremented and variable is used - otherwise it is already
> in use and left untouched.
> 
> Without per-CPU locking in local_bh_disable() on PREEMPT_RT the
> read-then-increment operation is not atomic and therefore racy.
> 
> This can be avoided by using unconditionally __refcount_inc() which will
> increment counter and return the old value as an atomic operation.
> In case the returned counter is not one, the variable is in use and we
> need to decrement counter. Otherwise we can use it.
> 
> Use __refcount_inc() instead of read and a conditional increment.

Reviewed-by: Florian Westphal <fw@strlen.de>
Fixes: edee4f1e9245 ("netfilter: nft_ct: add zone id set support")
