Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1757F342523;
	Wed,  7 Oct 2026 19:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791402250; cv=none; b=BirvuUcfnm10QtDxWxsg9KVtSWjYjFG5qfLCM6OAJ60uGtr9g/dAJMr8k6NS66yFUKPQoYQRxwmeePl9czYLWIxG3EtzMeKU41i8GYGDn9ZeDph1DgzgR3hsSDcwXLtzBwcmYnnBx3BEFxEnveoKbwA2TR9ruMPgy0p+del5VVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791402250; c=relaxed/simple;
	bh=o18PTC159uzGzI09RXEF02jVvQB93yCBG7nAUQJcmII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMSBI1+gPHRaXrO9bMGRFEf20or+LupQpnE309K71xHw4gLwrb2sFMB7T4dOSdNEpyia5h8QQ09lh3gwYEdum6qUTyV680A20ePQ0b5qdjE/idcrNkJSl1uS+x4LuOuHWi+mfdCUEtKLdQutYixg7fI4Eep8YGBzRvjiA9ydQQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hQhAJ+q7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hQhAJ+q7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791402245;
	bh=VUuZxfLDhpvNEXQUPMbnDBpD02PVPPUZQtnIVr/uYEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hQhAJ+q75EPvTnnfupVoy8QjHaRkfsdtlqsn8/X8UhQDK3okAMK5eDHlB3+An+Tuq
	 fXp+Q5SG15+GGE80o4tElokVsxVAjSpj4yZK/RkYP3a+pBDIUkygq/I+LO1iMuvy+4
	 xGSY1ad1CUEkxlpsCDNzvRMKbMQkqN8HuveOQiknIN0wKVBsSMFXs3G7I3orydDWqO
	 55khzS+JLc117LkueeEjbdU5j4r7np5ihmj2k28cnLkzYwsIQPJPNybL1ID9aFe7vP
	 0tkXy02tW9soEWVw9XFIoGjbquKQzqHrVD4inzD/Qy1buYR+6iLopmfY5rwuy0hMtv
	 Ga8GkK5jo3ABA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7006D60055;
	Wed,  7 Oct 2026 21:44:05 +0200 (CEST)
Date: Wed, 7 Oct 2026 21:44:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Joas Antonio <joasantonio108@gmail.com>
Cc: netdev-bot+sinfo@kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack_sip: only honour Via: port in
 original direction
Message-ID: <asahA40Bh9chMyqP@chamomile>
References: <179138670045.80227.4002052840715926590@gmail.com>
 <179138703794.2527009.12321622169213831789@kernel.org>
 <CAOCBhwE_JmVTmbuzJc8SEU1ROVyrat=7K-wqTQE=Er0gUy4fLA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOCBhwE_JmVTmbuzJc8SEU1ROVyrat=7K-wqTQE=Er0gUy4fLA@mail.gmail.com>

On Wed, Oct 07, 2026 at 12:52:19PM -0300, Joas Antonio wrote:
> Hi,
> 
> How the issue was discovered: manual code inspection of
> nf_conntrack_sip.c / nf_nat_sip.c, assisted by an LLM (hence the
> Assisted-by: tag), while auditing the conntrack helpers for
> direction-handling issues.
> 
> I then confirmed it at runtime on 602042bf29f6 (QEMU, arm64) with
> client -> router -> server network namespaces, the router running
> nft masquerade and a "sip" ct helper on udp/5060. When the server
> sends a request with "Via: SIP/2.0/UDP <server-ip>:4444", the client
> behind the NAT receives that request and a following plain UDP payload
> on port 4444; with the patch applied both arrive on 5060.

Sorry, this cannot be nf material.

It looks fairly theoretical to me, maybe for correctness patch? Is
this assuming a rogue server and packet spoofing?

> Thanks,
> Joas
> 
> 
> Em qua., 7 de out. de 2026 às 12:30, <netdev-bot+sinfo@kernel.org> escreveu:
> >
> > Hi!
> >
> > This is an automated message. This series looks like a fix, but its
> > commit messages seem to be missing some information:
> >
> >  - How the issue was discovered, e.g. hit in production, hit during
> >    development, syzbot report, manual code inspection, LLM or static
> >    analysis tool scan.
> >
> > Please do not repost the series just to address the above. Instead,
> > reply to this email with the missing information, so that reviewers
> > can take it into account. If the series needs another revision for
> > other reasons, please include the information in the commit messages
> > then.
> >
> > The evaluation is done by an LLM so it may be wrong, if you think
> > that is the case please reply and explain.
> 
> 
> 
> -- 
> Joas Antonio dos Santos
> Cyber Security Specialist and Ethical Hacker
> joasantonio108@gmail.com
> LinkedIn
