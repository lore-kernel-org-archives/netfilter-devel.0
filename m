Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EFF402B89;
	Wed, 25 Mar 2026 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774460941; cv=none; b=B4CjL0YvN7T/s1lcOJpwsDiiWOZjsM7d4cvm6PjpFHRwXSnDLFvbX/XJ18o90T7/ps+4bIW1jn3OyeiVC1ZYPQ8Xj0BVA8P33zB/979fInR1EuL9w6Tk+igbjRrYuwj5P8Rd5p5fULwy0Dhe8CoMSsbgh08ZY/6Gi7hpypLhmFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774460941; c=relaxed/simple;
	bh=hNlZT99ZtZwiTYpq5bBjvL5AKd1qeEcHL4Ekvpii4Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=omO1xQZzPpy3OxXEwNFa5688PD95w61dKz2sWZhFSpeZfnW/Xm5r8Fhjh/RQq8UKajp22D6y+TasDt7j28RK9q1UzDCzPoceNnT/VsgazpMlHPAFbqqHRmyiMRYbLlHOlVm1QtsiUNVTnZ30eNEnywW6+t8ySMHuQqFl0qQkQ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dLrB24iW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dLrB24iW"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3F33B600B5;
	Wed, 25 Mar 2026 18:48:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774460936;
	bh=3a98aCNzUG7RIJEQkjk8/YAJhffjtA16hOkwN0kGb0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dLrB24iWJZu0JkCYy2cHOU5jmR2DVGeVd1q2WnLVRTslU/OVKXX8nz0l8qUqxWecL
	 C9fmo6wzkobE9Y2squ9jmnMJyUBR+0DH0Ky4hY9YSh0iNgUY32YAaohD6kR0tRCr6s
	 JMvj8teK0sxVzHJKcJYZ/FnnZNqAp9PnmyAYaIEbTqUCYUMq27V/eVrR6/iCeJzavl
	 lOpGdFJQ67J/y92nXmhdB7i5qSEl+tMLjrMpLPLf17fCaQByQ+4xlJdr5M+9D4mXEY
	 DDcu1K2g/lPSenzHLSoweFSDamHG+urgBSi6maoirck4fuHHPdl7LgzI7eVkHDzRBQ
	 z/EeOigtboaEg==
Date: Wed, 25 Mar 2026 18:48:53 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 00/14] netfilter: updates for net
Message-ID: <acQgBRbJHRqbu--0@chamomile>
References: <20260325131108.23045-1-fw@strlen.de>
 <acQemtlq03AZvjL7@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acQemtlq03AZvjL7@strlen.de>

On Wed, Mar 25, 2026 at 06:42:50PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Hi,
> > 
> > The following patchset contains Netfilter fixes for *net*.
> > Note that most bugs fixed here stem from 2.6 days, the large PR
> > is not due to an increase in regressions.
> 
> please toss this.  I'm not sending a new PR.

Will you please collapse this incremental fix to 8/14 in the new PR?

Thanks.
