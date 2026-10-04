Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BA938F92F;
	Sun,  4 Oct 2026 19:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791142003; cv=none; b=QFlO4c2gpBCC94/6AdDNttJnykix9ig1A1JN1/SMAhP+XTk+V5unyJzE/i/7mFIpqnUXpuvTPEcERd0FGv5+rNux9ErxWhv82+aaZ+ZEDreA4QfWJnoiwXf6jMVJIqdz2T+6km4FrMeE/X/Vg1eisXRDMFJUUJ337lWXD6uiQb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791142003; c=relaxed/simple;
	bh=EZqj9oz9hc/uErnnmjyNBZUXrr48+ZU27QZxpRRKcEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQtdIR2URtmFg4SnIPqo1xQB5U5O+vgE0sqsujKUE1aRFpUER4PdG8QJTpOZDIgo9OAcpV/LLQDWfIs/fgEgyVFFcluFCU4wK5zWuQez0QQw+NSO5MiniPg+o5qQcvXCmnm6+jhb2LXP500D8AzU24bw4ORPfrMn3RYcnYEzec0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oju769jK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oju769jK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791141998;
	bh=DvHBIiApvl4tSWC5DbD9q2NS2XSoHvWiFwW0/l7xdlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oju769jKfWggoOLVGJ5WomnnuABTJPPS3vUlQ569aZ8mRIRcon/cnC45yynUkNWeH
	 sUUUtPLsISfcyI3vk0MLXZonZ5obg6iM4+NSsUvq8SfZgyLuGQMtk1VMy4dxdaMG1P
	 VORvGmAfZVNKbfhcph9DhDxfDNQbvdVtc0IikKT2f95mqnAl7CMx7D8F3Pe8PqLBCa
	 jInw9Cek3fRXTT9BeKCuuTA0/RzRjAyCrgcV7XzH3jBRUGJ+m0qBGqLRkMdpQbmEP5
	 DT9X3EZNcBpQ98sYQ3zhX0Q01IESZ8RWQMOtarCIGuJpMK/s1oQJeEkAwrvLlx2WYc
	 e/5HfMEBKB4cw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 20FEA602C6;
	Sun,  4 Oct 2026 21:26:38 +0200 (CEST)
Date: Sun, 4 Oct 2026 21:26:35 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/11] netfilter: synproxy: fix reset of ct
 seqadj when reopening a connection
Message-ID: <asKoa2wFW5QneXEA@chamomile>
References: <20260927223436.269024-1-pablo@netfilter.org>
 <20260927223436.269024-2-pablo@netfilter.org>
 <179054884482.31693.9985445366421543993@kernel.org>
 <armg511ZWKl5ZqhZ@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <armg511ZWKl5ZqhZ@chamomile>

Hi,

Just a gentle bump to this net-next PR containing Netfilter updates.

Let me know if there is anything that needs to be addressed.

Thanks.

On Mon, Sep 28, 2026 at 01:04:07AM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Sun, Sep 27, 2026 at 10:40:44PM +0000, netdev-bot+sinfo@kernel.org wrote:
> > Hi!
> > 
> > This is an automated message. This series looks like a fix, but its
> > commit messages seem to be missing some information:
> > 
> >  - How the issue was discovered, e.g. hit in production, hit during
> >    development, syzbot report, manual code inspection, LLM or static
> >    analysis tool scan.
> > 
> >  - Whether the issue was actually triggered, or is only theoretical
> >    (e.g. found by code inspection). If it was triggered please include
> >    the symptoms, like the stack trace or error messages.
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
> This are correctness fixes (no crashes to my knowledged, hence I
> decided to target net-next) as the cover letter specifies:
> 
> Patch #1 TCP sequence tracking issue was reported by sashiko as the
>          cover letter says.
> 
> Patch #2 Just documentation update to fix incorrect information
>          about the maximum number of expectations.
> 
> Patch #3 Just a cleanup patch to remove a break;
> 
> Patch #4 Just a cleanup, typos in comments.
> 
> Patch #5 and #6 are the result of a human triggered review of the
>          conntrack error stats by Phil Sutter, I think.
> 
> Patch #7 is a preparation patch for #8.
> 
> Patch #8 removes a unnecessary workqueue flush, submitter does not
>          specify if it is visible in production, I suspect with
>          a very large number of netns it must be. Author does not
>          claim LLM assistance.
> 
> Patch #9 is a fix triggered by sashiko report IIRC, I deemed it too
>          large for net so I am routing this rework-fix to net-next.
> 
> Patch #10 is a feature fix, IPv6 filtering does not work.
>           I suspect it was found when trying to use this (broken)
>           feature by the submitter.
> 
> Patch #11 Ilya Maximets reports the CTA_ZONE filtering feature is
>           not easy to infer from userspace, I don't think LLM
>           triggered this, it looks more like an improvement to help
>           userspace tools discover this feature.
> 
> This is human written reply, my cover letter has been generated by me
> too to provide more context on these patches.
> 
> Thanks!
> 
