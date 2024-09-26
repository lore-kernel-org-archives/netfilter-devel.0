Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031D6347B4;
	Thu, 26 Sep 2024 10:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727347298; cv=none; b=M0KTP7vBn/HmkNqWAnCteGn+REQTowOmu/05QnWOlHprN4lQMknsJVO8sqxKpbmrhDJzyGG1KMfd/G0Nd4auo5Ozyc7uirwrAYRntl63ft5OtiOSMWTKLh6/uNN+RPxi9BH/4V14fqyp8xo33n68s7a4uE1ays1zSwqWE/XgY0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727347298; c=relaxed/simple;
	bh=OP+So5IkCz5ta/8Z3M83o7bMEhX+Lp3v4CzzumrQcN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Df2ufo3t5Gl5Xfaiy5Bcn483SUYftbhSokzZy/LqAGuAD8Oe1VtBxSfNEkauxCmDe+aCPQDsgGpBGxWEjFntPmelhWr5O3D94XJyFSQ0J6B9FLGRJSCbanTiTZPZ/OXCatb6IIf2Iz4MEr57Y8y9RRTtAQ0FjfIZ2jSl7SB+APc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1stlwD-0004JZ-97; Thu, 26 Sep 2024 12:41:33 +0200
Date: Thu, 26 Sep 2024 12:41:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com
Subject: Re: [PATCH net 00/14] Netfilter fixes for net
Message-ID: <20240926104133.GB15517@breakpoint.cc>
References: <20240924201401.2712-1-pablo@netfilter.org>
 <c51519c0-c493-4408-9938-5fb650b4ed8b@redhat.com>
 <20240926103737.GA15517@breakpoint.cc>
 <ZvU5rhGYpmGV_FVx@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvU5rhGYpmGV_FVx@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Paolo, Pablo, what should I do now?
> 
> I am going to fix it and resubmit PR.

Thanks, and sorry about this.  I was not aware of how to format this
"properly".
