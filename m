Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAC1185949;
	Wed,  9 Oct 2024 22:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728513258; cv=none; b=ckT9sSAeXDgdVMjv4kEOuB4oqsQAVp6+tGPwyuf1UW8OX+BEfjGncT4JWKZ4LMiygXE/ApXFkuaiZhlwxe5oy2ic5qXJloho9+BGJOXdsptBXqdKrnWGovtgEXlBhNpGIx9wjQu6cpXtv9GUfIWU4qJh7tKEEsh6LHHzmBznF1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728513258; c=relaxed/simple;
	bh=yFqd026lGIBH4U1L5dmmxB1xoS90MCAzCPpG9GqZXRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IR8xz35WVNmeOCuJZYKlsw2sobOUYg/VhEsoEPqB38yIPi6VK4Dliz4yp/TGjxLLlJ/x+RqTTjJiH+m0hu9cxmZCccyMDwf+3/F3+f1YekL+8WC0+WZOeqfO0NSz6xHWh+CyR9D+MOAmKTWKyzOIM3rj6Jb6SV+7C8igtUOSUsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1syfFx-0001nT-TE; Thu, 10 Oct 2024 00:34:09 +0200
Date: Thu, 10 Oct 2024 00:34:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Paul Moore <paul@paul-moore.com>
Cc: Florian Westphal <fw@strlen.de>, Richard Weinberger <richard@nod.at>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
	davem@davemloft.net, kadlec@netfilter.org, pablo@netfilter.org,
	rgb@redhat.com, upstream+net@sigma-star.at
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
Message-ID: <20241009223409.GE3714@breakpoint.cc>
References: <20241009203218.26329-1-richard@nod.at>
 <20241009213345.GC3714@breakpoint.cc>
 <CAHC9VhSFHQtg357WLoLrkN8wpPxDRmD_qA55NHOUEwFpE_pbrg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhSFHQtg357WLoLrkN8wpPxDRmD_qA55NHOUEwFpE_pbrg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Paul Moore <paul@paul-moore.com> wrote:
> On Wed, Oct 9, 2024 at 5:34 PM Florian Westphal <fw@strlen.de> wrote:
> > Richard Weinberger <richard@nod.at> wrote:
> > > When recording audit events for new outgoing connections,
> > > it is helpful to log the user info of the associated socket,
> > > if available.
> > > Therefore, check if the skb has a socket, and if it does,
> > > log the owning fsuid/fsgid.
> >
> > AFAIK audit isn't namespace aware at all (neither netns nor userns), so I
> > wonder how to handle this.
> >
> > We can't reject adding a -j AUDIT rule for non-init-net (we could, but I'm sure
> > it'll break some setups...).
> >
> > But I wonder if we should at least skip the uid if the user namespace is
> > 'something else'.
> 
> This isn't unique to netfilter and the approach we take in the rest of
> audit is to always display UIDs/GIDs in the context of the
> init_user_ns; grep for from_kuid() in kernel/audit*.c.

Hmm, audit_netlink_ok() bails with -ECONNREFUSED for current_user_ns()
!= &init_user_ns, so audit_log_common_recv_msg() won't be called from
tasks that reside in a different userns.

If you say its fine and audit can figure out that the retuned
uid is not related to the initial user namespace, then ok.

I was worried audit records could blame wrong/bogus user id.
