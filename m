Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90320DF76;
	Fri,  9 Oct 2026 00:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791504461; cv=none; b=SZcJatLGkVulmmErl76aWIAmdyxmVdyJjXLx91QekFR5zWsP99jbl3HkmJuxMhNOWdrmSynm3+r57rrT2jZetP084+46XNDukVSwtu1ux3z2crVc1QxZw4uCPYpdcXyZBE3XMyLJO25+L0FtzQ9V9g8INARwALsuyEq9bfLVRpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791504461; c=relaxed/simple;
	bh=rRMl1pE8djftn9sW+5YV9g2vC/AZMg9rSDmuR8ruISs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PI8Df35dbyLdZBvRHt39EHCoNGQsilqptUo7pVvlXSvO6Uzm3U+8HyCjaJNGLVJeT/gq3il3/YEY7r+LoMvyQ0p4ZwLmqKrXh35OdNoLSzPHh2xfAZ1iZ8Dah9TwQ7jittCdGyGSf8FnqGKjulB/o9N5mmp+HRJqOEK4v7of+Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E969A604C4; Fri, 09 Oct 2026 02:07:37 +0200 (CEST)
Date: Fri, 9 Oct 2026 02:07:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Zihan Xi <zihanx@nebusec.ai>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, phil@nwl.cc, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org
Subject: Re: [PATCH nf v3 1/1] netfilter: x_tables: avoid holding mutex over
 faultable user copies
Message-ID: <asgwR9LsGCEMolQX@strlen.de>
References: <cover.1789885804.git.zihanx@nebusec.ai>
 <f88fc502b17b4022105a99eea407525807ee573e.1789885804.git.zihanx@nebusec.ai>
 <asgtQ3E2LVWqfV8D@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asgtQ3E2LVWqfV8D@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The ebtables GET paths use a separate ebt_mutex and are outside this
> > IPv4/IPv6/ARP series.
> 
> I keep spinning on this, and I am not sure this fix is the right thing
> to do. There is no single caller of this pagefault_disable/enable() mm
> subsystem function in the net folder.

See:

https://lore.kernel.org/all/CAL4Wiir+CBGE=hXxHEBkyk0Au9B6G3=AdHFd5botrC-FF5BM5w@mail.gmail.com/raw

Quote:
| We have many places where copy_{from,to}_user() runs while a mutex or
| a socket lock is held, and some of these locks are global.

So I would not spend too much time on this, especially not for the
xtables get/setsockopt APIs.
