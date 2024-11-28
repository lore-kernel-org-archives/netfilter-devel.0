Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CDA1A0BC0;
	Thu, 28 Nov 2024 14:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732804924; cv=none; b=StsNeKOuCJ1NVA51n5xvBz/3W/r3LKKSCvHLyN9LdGWGgan9T7xNdgqOaMmF6eUY7oOggyBUG25LZprqeAgzmQ2462JDA2i0oVAm4ybcosrJYxyDqeQD580dJ3uGxeEpDBfZgxUygt9QrIRiSB3tK/Nj/Ch8U91s8l9nIqJf4po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732804924; c=relaxed/simple;
	bh=U9wCyG5v3Y25+N04HK8RK4eizU9o9MB45JViquFeAbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCI81H9DbZZf9wFDbT6wmbHP3ncV035eUxM++19tJtoVXQwrXjsNq9UICPk1IOxs9qmpOh9417OJBvJwkK2DKH9ZvMa1gLhe3FeQkuGUgo6nYbccVM09YNiAqBXRW8mSTxBEqgiNw0PgH+3r4tTIyErCuoV1FvbGpE9OwPgbG3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=60688 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tGfiO-00GavV-5x; Thu, 28 Nov 2024 15:41:58 +0100
Date: Thu, 28 Nov 2024 15:41:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net,v2 0/4] Netfilter fixes for net
Message-ID: <Z0iBM0P54cO830ez@calendula>
References: <20241128123840.49034-1-pablo@netfilter.org>
 <d74075e2-8e82-4c7d-b876-398f4880d097@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d74075e2-8e82-4c7d-b876-398f4880d097@redhat.com>
X-Spam-Score: -1.9 (-)

On Thu, Nov 28, 2024 at 03:33:59PM +0100, Paolo Abeni wrote:
> On 11/28/24 13:38, Pablo Neira Ayuso wrote:
> > v2: Amended missing Fixes: tag in patch #4.
> > 
> > -o-
> > 
> > Hi,
> > 
> > The following patchset contains Netfilter fixes for net:
> > 
> > 1) Fix esoteric UB due to uninitialized stack access in ip_vs_protocol_init(),
> >    from Jinghao Jia.
> > 
> > 2) Fix iptables xt_LED slab-out-of-bounds, reported by syzbot,
> >    patch from Dmitry Antipov.
> > 
> > 3) Remove WARN_ON_ONCE reachable from userspace to cap maximum cgroup
> >    levels to 255, reported by syzbot.
> > 
> > 4) Fix nft_inner incorrect use of percpu area to store tunnel parser
> >    context with softirqs, reported by syzbot.
> > 
> > Please, pull these changes from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-11-28
> > 
> > Thanks.
> 
> Oops... I completed the net PR a little earlier than this message, I was
> testing it up 2 now, and I just sent it to Linus. Is there anything
> above that can't wait until next week?

This can wait. I will try to post PR late wednesday moving forward.
