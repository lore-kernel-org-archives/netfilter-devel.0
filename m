Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80B31946AD;
	Wed,  5 Jun 2024 08:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717577889; cv=none; b=N4wl0yjixRJfSy6P/xyw8j6k1aYAG8+640H9C5O8dvKbJbSdyznZCv8uuSY87Xyq4ghi4puaJoxGgHqWIpyQ3hhwkMIAUdT9Zpyz/VQHqdvXKRGlK5sCfDHLP5co5z74b14iJV68geI6Wvjg3ucOBCmLQxce+YSpfgKiRrnDfTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717577889; c=relaxed/simple;
	bh=nIP7Mx8vLUWEsu6iq107lRLwxTKjrQc8uhfSIPDS/oU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JmOt/tlHLHqtBhwe5iDSZ6lxpz4X4GBnKHQ9utnwhOw/9NLux2gZH7KLRjjB0Q7mMJr6xpXjf45Bk5EoQNWdSt/pp7rgRMq/vNbwKEXjrvotQH5VIfcgSg2zvuOXqBtbGNeQ3S/zhwscGZxZK+du4Gkk3v3kb3MKhG3JzRUpayI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sEmT6-0000gT-BY; Wed, 05 Jun 2024 10:58:04 +0200
Date: Wed, 5 Jun 2024 10:55:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: restore default behavior for
 nf_conntrack_events
Message-ID: <ZmAn7VcLHsdAI8Xg@strlen.de>
References: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> Since the below commit, there are regressions for legacy setups:
> 1/ conntracks are created while there are no listener
> 2/ a listener starts and dumps all conntracks to get the current state
> 3/ conntracks deleted before the listener has started are not advertised
> 
> This is problematic in containers, where conntracks could be created early.
> This sysctl is part of unsafe sysctl and could not be changed easily in
> some environments.
> 
> Let's switch back to the legacy behavior.

:-(

Would it be possible to resolve this for containers by setting
the container default to 1 if init_net had it changed to 1 at netns
creation time?
