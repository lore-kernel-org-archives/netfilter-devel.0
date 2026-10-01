Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891BF3B1029;
	Thu,  1 Oct 2026 15:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870302; cv=none; b=bQ15HggMVIZ9XZSCcyG4Btx+4N/N0LQCpcvdQ4PMSCg9y91222ICieZLbcTdKGVYC4oYbOMWzO4mYv2LLcmzdwlHFXkdubJeoGoR/VuewHrOEmK/RDCex+vlzP72+8BcrMrFCxvh62Skx38UtkhyDCazTU5sN8JILbWHSfa4HxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870302; c=relaxed/simple;
	bh=FKhGpV2bWENnNOUmhEJ9JcLPZuDW5ZMYnk1KWEP7lFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZXUrm/U8u9c4Qar49C3nq3xEAdofY/mtLoQZrJZQ1D8LCOjJHBCb/Rq+pPEg85uzFmonAIM8g9nnv/2OTr0qVmP/GWuxP7yur3mUZCKbbg72vcX6l4lDPx3/DmZ2+vz/KGxvB3C/GukLuTbiSLDvhQFiPjg9UQJ4opvGsTAzKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IxWz5SCY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IxWz5SCY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790870297;
	bh=Ybh8wufItYw2gWynukBmN3LXd/9ZUiecKPSzIBKlKgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IxWz5SCYLJap8IohDgHXMliZhF16bJBqVFCYjaTVvGp+su5Z+6QlHyHxhaZY5SiB3
	 8JQ0Ck7n0kpdthSaQJzWw+WDu2/k7XQ2JrH/AJ3nc5i3fTe29kEK95VzJfBkZ25gmj
	 bqIAsJ6eau3wuXc5wTt5Z7XjjrHEucy3vFTAZbpcE6eShaelPan8NGGWeAGtoMNSOK
	 iNjk8xiWCU7zmsIKUBnHXuhGsBcqYBqTvR9G9nFWvifRPZ7ifEYp3+SZrpooSTzFHn
	 x+OBbwQFh3fTxlLNcAbFkrt74r1lS8VCX3pDLONp2MXCI/RuM7vhMzmyeZJ1TLeujm
	 +EfAG5XUMeVmA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2EDC4602BD;
	Thu,  1 Oct 2026 17:58:17 +0200 (CEST)
Date: Thu, 1 Oct 2026 17:58:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Subham Pal <subhampal789@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, kaber@trash.net, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net 0/2] netfilter: nf_conntrack_h323: fixes for NAT
 bypass and ASN.1 decode
Message-ID: <ar6DFv-zudWg6i1z@chamomile>
References: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>
 <arORyXjxvZUoEAIw@chamomile>
 <CAHeizqF--yGMCLGBEv9f7Gs=dmbZO6+DwSh7KZjpDgbNonCotA@mail.gmail.com>
 <ar4db-oTyeSGTpCy@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ar4db-oTyeSGTpCy@chamomile>

On Thu, Oct 01, 2026 at 10:44:35AM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Wed, Sep 23, 2026 at 04:16:48PM +0530, Subham Pal wrote:
> > On Wed, Sep 23, 2026 at 2:16 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I understand these are correctness fixes.
> > > Do you have a reproducer/PoC? Do you tests for this?
> > 
> > Hi Pablo,
> > 
> > Both issues were found while testing a netfilter based linux
> > firewall with communicating devices from multiple vendors
> > (Panasonic, PeopleLink, YeaLink and Plycom).
> 
> We will need a reproducer here without requiring such hardware.

This requirement is too strict, apologies, let's remove it.
