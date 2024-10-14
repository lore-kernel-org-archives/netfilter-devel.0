Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67145231C88;
	Mon, 14 Oct 2024 22:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728944469; cv=none; b=uC3Zqyj4WMuigr4qEcJuOkBxFWf/O+nyYgS8Ntdfmuf1oyQfJkjAZCsjPnTU0Aft2gXoInL2KFqJfF2YB3iQK1/x1fmO80GcWT9ZGGsacDggA2LlK7PlD14oZaSzVTgm+7maluM6YsJRqpKwvYt+omv/kUyjMh0zatbGqmsW9Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728944469; c=relaxed/simple;
	bh=PR9JxOfRGnxqHdpbuBp+/8NQj1ETrB0TTmvDY/mvnC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rrWJSrtFeY0S4Ahf40HrQ91M/Mr1Hc3YdNAeny2oMXFUWnMHG5/5FIMwluExLlu/zHd+sIiPypnRq4KCWW+xrokqan6nmlPyMn2t8cEn5FD96+BOyEau4/R9MCQ0SrHaFcR5iY8DqaewLpnGy0iEeF6Ryc9rNAK5/TZr7+IVGIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t0TQx-0002jW-E0; Tue, 15 Oct 2024 00:20:59 +0200
Date: Tue, 15 Oct 2024 00:20:59 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 0/9] Netfilter updates for net-net
Message-ID: <20241014222059.GA9739@breakpoint.cc>
References: <20241014111420.29127-1-pablo@netfilter.org>
 <20241014131026.18abcc6b@kernel.org>
 <20241014210925.GA7558@breakpoint.cc>
 <Zw2UgAlqi_Zxaphu@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw2UgAlqi_Zxaphu@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> At quick glance, I can see the audit logic is based in transaction
> objects, so now it counts one single entry for the two elements in one
> single transaction. I can look into this to fix this.
> 
> Florian, are you seing any other issues apart for this miscount?

Yes, crash when bisecting (its "fixed" by later patch,
hunk must be moved to earlier patch), nft_trans_elems_activate
must emit notify also for update case.

Maybe more.  Just remove these patches.
