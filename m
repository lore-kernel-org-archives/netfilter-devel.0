Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E09481AA2;
	Tue, 23 Jan 2024 18:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706032999; cv=none; b=WvAbV+RoOWp1IgL57f8hbG8urR787/fYtCgRg806wSLhdTCkxVpJ5EpzslMxsDVpVXhv1aRmiJPAq9D9xjkUsH61UP+41bDEjCvX7V7YMthb+UXeiIWZfk4lqMihwrlkDWKrR37d2EG+p18aYu5icDDkBnjElbrkX+nAXIUDpzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706032999; c=relaxed/simple;
	bh=EL5p5c0hwl2jJMI3Rm+9efOqsd/1ZSKtNHzHsiSsBcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xqf7zaCXz0lmJ1D4DOShs/hZpH3vIZqgySF0DGiZL9xHBdf+Br1vkpUX4VRXNvaq0FESAoSMRJr5hzhcFk47uEVCO2VFEBBgUEhBAEeUzSbYzeMaXNiMpvme6aosBq2VQsN5Qc6bZBxir94oxipdruikEJbpGyVG6oEcXOlx1C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rSL71-0002f0-JY; Tue, 23 Jan 2024 19:03:03 +0100
Date: Tue, 23 Jan 2024 19:03:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Kees Cook <keescook@chromium.org>
Cc: linux-hardening@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 64/82] netfilter: Refactor intentional wrap-around test
Message-ID: <20240123180303.GB31645@breakpoint.cc>
References: <20240122235208.work.748-kees@kernel.org>
 <20240123002814.1396804-64-keescook@chromium.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123002814.1396804-64-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Kees Cook <keescook@chromium.org> wrote:
> In an effort to separate intentional arithmetic wrap-around from
> unexpected wrap-around, we need to refactor places that depend on this
> kind of math. One of the most common code patterns of this is:
> 
> 	VAR + value < VAR

Acked-by: Florian Westphal <fw@strlen.de>
