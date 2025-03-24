Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403A62641FC;
	Mon, 24 Mar 2025 17:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742838425; cv=none; b=RqBTnxTNmfOEgNImFyCYSqELKgQdu6FgQE8rkyZEi/lsDOXBf9U7vSllYOA7Q+Sq5L7q+dimNbJlRV03vGOTC55yXLXMIrKto9HiZRye7XkOvSmmF2nu6+eWVl85TZ+Sau/h3MCnPWZ3IoNgWoaI1mGDRiJJx2Q7YZs0qPYbg1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742838425; c=relaxed/simple;
	bh=x6Sm7G1YAutU8ro3JvfCSLxFb4v/gi/BRM9kMH2p83c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWzXTeGuTz9sPeYwcd+huaYH6UBGJPsC64eqhdU9gdN65K7ZaXbB2GdH5LNjO6yopjK9BgItDiHHyWUnWHLDCt2mRsWxiP+TXxrtErUN7nYVbByAgUbTOsEAPl697cPNTcmOtE5mwXt26pV5/SUhDB/gM/U4X1abrd5l4O2znkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1twlt6-0005ES-34; Mon, 24 Mar 2025 18:47:00 +0100
Date: Mon, 24 Mar 2025 18:47:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 0/3] Replace xt_recseq with u64_stats.
Message-ID: <20250324174700.GA3480@breakpoint.cc>
References: <20250221133143.5058-1-bigeasy@linutronix.de>
 <Z9IVs3LD3A1HPSS0@calendula>
 <20250313083440.yn5kdvv5@linutronix.de>
 <Z9wM9mqJIkHwyU1J@calendula>
 <Z90-Q3zyEHDWPBNr@calendula>
 <20250324162923.O308UeBw@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324162923.O308UeBw@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > 2. make iptables-legacy user-selectable.
> > 
> > these two are relatively simple.
> 
> Okay. Let me try that.

See https://lore.kernel.org/netfilter-devel/20250321103647.409501-1-pablo@netfilter.org/

(its not yet ready but most tests pass).
