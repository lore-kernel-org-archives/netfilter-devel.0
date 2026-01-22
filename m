Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D470331B823;
	Thu, 22 Jan 2026 08:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769069727; cv=none; b=DoxKwYlyi03Cux4OoehRJVU1qXQGydvCSCllpWgDPsKh2A1HSUKaHvpntVLNZAWplHuP89SLs+gc5GbvFkoEyav44Gt6G92rhyvDwzChjC3e9gKQy+5Vj9Lrl7LxWNI0rQQhJnNvhGuNEi1yp7ZA9uH0yfluKePBA78H3k50cqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769069727; c=relaxed/simple;
	bh=kbNnzPFW8j+yNLG4b7rlrzCkl90ALRJY0AIXYUJhs6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2CiWRLzkfudod+agYDb2e9Qy5h+O56D0ia5VDhM7TmLmwtAPA/ac2IZF5ZN+j1Cg2cvf2h3BmuPnPVKiQFWbMzZpsHoeV1clg6Rp8cc1LzR8iyjsadIC5spXj13WxZM5DSpKQQwJz0Xnr23eEppQ9RCPSwMAlgAAGfBvIz2Fgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szpc9HzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szpc9HzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52AFC116C6;
	Thu, 22 Jan 2026 08:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769069727;
	bh=kbNnzPFW8j+yNLG4b7rlrzCkl90ALRJY0AIXYUJhs6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=szpc9HzAp6GB7r+32tn2+6gDV6cqMZOkVnGKIk3i6Yv0Myj8elV8+MVVjAJOR0LWa
	 Dre3CF7eekEMNhmEGuVg7G6ow5Z0CZPrEgfYonAnlXHuBeKfykW7HkjEA2STqLJWSj
	 4U7u84/cdjxSjpSK1W+uQtgT2qbUBd+cc9sFK2912w9EPJG77ku/+PiVoTMsh9bJm5
	 uBSSNGv4EgZWXlHpwet+IZytw1Oyp2AfLESl3VgcGmhFX5lnNIYzN4XhCa91HPykBG
	 +7CUfzz2CSwn3d9K3Mp3ozEqjb0cerKGpE6fcOq3kYH06cRCdWLwyuiVDbbj0Fy/Bn
	 vYc4lgT+hJHHg==
Date: Thu, 22 Jan 2026 08:15:22 +0000
From: Simon Horman <horms@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Kshitiz Bartariya <kshitiz.bartariya@zohomail.in>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: arptables: use xt_entry_foreach() in
 copy_entries_to_user()
Message-ID: <aXHcmikPscC14t3j@horms.kernel.org>
References: <20260119063704.12989-1-kshitiz.bartariya@zohomail.in>
 <aXERRqh79pmVsuzk@horms.kernel.org>
 <aXFNoRjTS71iqDDQ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXFNoRjTS71iqDDQ@strlen.de>

On Wed, Jan 21, 2026 at 11:05:21PM +0100, Florian Westphal wrote:
> Simon Horman <horms@kernel.org> wrote:
> > On Mon, Jan 19, 2026 at 12:07:04PM +0530, Kshitiz Bartariya wrote:
> > > Replace the manual offset-based iteration with xt_entry_foreach(),
> > > thereby removing FIXME. The byte offset semantics and user ABI
> > > are preserved.
> > > 
> > > Signed-off-by: Kshitiz Bartariya <kshitiz.bartariya@zohomail.in>
> > > ---
> > >  net/ipv4/netfilter/arp_tables.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> > > index 1cdd9c28ab2d..9f82ce0fcaa5 100644
> > > --- a/net/ipv4/netfilter/arp_tables.c
> > > +++ b/net/ipv4/netfilter/arp_tables.c
> > > @@ -684,12 +684,11 @@ static int copy_entries_to_user(unsigned int total_size,
> > >  
> > >  	loc_cpu_entry = private->entries;
> > >  
> > > -	/* FIXME: use iterator macros --RR */
> > > -	/* ... then go back and fix counters and names */
> > > -	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
> > > +	num = 0;
> > > +	xt_entry_foreach(e, loc_cpu_entry, total_size) {
> > >  		const struct xt_entry_target *t;
> > >  
> > > -		e = loc_cpu_entry + off;
> > > +		off = (unsigned char *)e - (unsigned char *)loc_cpu_entry;
> > 
> > This offset calculation makes me feel queasy.
> > 
> > Can the code start with off = 0 and increment it by e->next_offset
> > as the loop iterates, as was the case before this patch?
> > It would be similar to how num is handled.
> 
> I think this file should just be left alone resp. should be restricted
> to bug fixes only.  Same for ip/ip6/ebtables.
> 
> Its too early to remove this file from the tree, but I don't see
> value in making cosmetic improvements, sorry.

Thanks Florian,

No objection to that approach from my side.
