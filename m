Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A52D211491;
	Tue, 14 Oct 2025 12:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760444723; cv=none; b=CHMLpIdJeP+MzpnqHRK6yUEqikOHSX/aMEJEBdYwDa8683yv+a3if2sHXMJ/OWxViYEPDo90qh8k1LDK7FkoBLW8GN7gL9hVmBY4BdwkwhX8/VImKI6myHEhSnthXHr5KZcoKk6sTH07J6OgWR4iv3/0LqlLOLkMOIRC6g1NLMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760444723; c=relaxed/simple;
	bh=RKgvjxketpaNtUXeqwGtA6c/9f9d99/7aXrG9xPdMJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jT/IP7Dd8h0lsY6kovmK/W92Cjy3oPcjTotlSkvVyEcpB4QA3e3BxMHJw8mBlOkHbv3npAHCjFwdg0Erc/C0v8iNZvCmYF6kcNSc/bjhrKPtZT/ZnJ+0Ygo44el6ZE9hlEafvfTqGex5hvFacQjpsxcGWaS7ssImeytyrctAaeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9A4BF603CA; Tue, 14 Oct 2025 14:25:18 +0200 (CEST)
Date: Tue, 14 Oct 2025 14:25:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] netfilter: Added nfct_seqadj_ext_add() for ftp's
 conntrack.
Message-ID: <aO5BKQwvvDHdPnDm@strlen.de>
References: <20251014114334.4167561-1-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014114334.4167561-1-a.melnychenko@vyos.io>

Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> There was an issue with NAT'ed ftp and replaced messages
> for PASV/EPSV mode. "New" IP in the message may have a
> different length that would require sequence adjustment.

This needs a 'Fixes' tag.

And it needs an explanation why this bug is specific to ftp.

Lastly, why is this needed in the first place?

nf_nat_ftp() sets up the expectation callback to 'nf_nat_follow_master'.
That calls nf_nat_setup_info() which is supposed to add the seqadj extension
since connection has helper and is subject to nat.

And if nat isn't active, why do we need to seqadj extension?
No NAT, no command channel address rewrites.

It would be good to have a test case for this too, the nat helpers
have 0 coverage.
