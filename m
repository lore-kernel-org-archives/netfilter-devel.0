Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VJNZWZ6N"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD6CAC
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 07:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+nlsC8J77m/9HoJlKBAttD18JKiV2zuojhc3jXrGf4c=; b=VJNZWZ6NvB7gjfcm9950zvkC2m
	HpkwvB/bbk8cpVeSc/CrVTESMys4hP5r/FswnNOrqe/EgCukGDCCuVdjpTlFdEQNji5P700d/XggP
	+Jk8RvLYQswoQ5WuRls7REX/P4kFP7pu/YXfDwsB4dnS+CxT0FCO9+cmIeWpcPUsEEh0oXDU5yFg8
	puhFzPsWwrkbQuskt35WaeCxEW3GffskNqwZ2mKw9b1dwhL1uNoDOYwAZsnx6Hcp1tRoYADYBCJJa
	jrCtEN3/gX6wOg70jGvB00V9GRexsFH5N0FOU8gGo56YwOmD2WljuuCKuH1ViR2V/m7j5Zs/4hO41
	x1BJ58Nw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rDRVm-0003pL-RT; Wed, 13 Dec 2023 16:51:02 +0100
Date: Wed, 13 Dec 2023 16:51:02 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
Message-ID: <ZXnS5k/iOj3g5f22@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
References: <20231208130103.26931-1-phil@nwl.cc>
 <ZXhbYs4vQMWX/q+d@calendula>
 <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
 <ZXji-iRbse7yiGte@egarver-mac>
 <ZXmgAu3u2w+Xjh8+@orbyte.nwl.cc>
 <ZXnKpoMQnsoTK6sA@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXnKpoMQnsoTK6sA@calendula>

On Wed, Dec 13, 2023 at 04:15:50PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Dec 13, 2023 at 01:13:54PM +0100, Phil Sutter wrote:
> > Hi,
> > 
> > On Tue, Dec 12, 2023 at 05:47:22PM -0500, Eric Garver wrote:
> > > I'm not concerned with optimizing for the crash case. We wouldn't be
> > > able to make any assumptions about the state of nftables. The only safe
> > > option is to flush and reload all the rules.
> > 
> > The problem with crashes is tables with owner flag set will vanish,
> > leaving the system without a firewall.
> 
> So it does currently in a normal process exit.
> 
> Reading all this, a few choices:
> 
> - add an 'orphan' flag that gets set on if the owner process goes
>   away, so only ruleset with such flag can be retaken. This is to
>   avoid allowing a process to take any other ruleset in place.

That's an interesting idea, implementing it should be easy indeed. I
wonder though if this "takeover" protection is effective: The table not
having an owner yet may be deleted and recreated (with owner flag) by
any other process, effectively this is the same as the "takeover" you
probably want to prevent by limiting the add owner update to tables with
'orphan' flag.

> - add another flag to keep the ruleset around when the owner process
>   goes away.
> 
> Probably it can be the same flag for both cases.

ACK: A table may become orphan only if there was an owner in the first
place and it survives. So 'orphan' flag may well be a virtual one for
user space only based on '(flags & (owner|persist)) && (nlpid == 0)'.

> I remember we discussed these superficially at the time that the
> 'owner' flag was introduced, but there were not many use-cases in
> place already, and the goal for the 'owner' flag is to prevent an
> accidental zapping of the ruleset via 'nft flush ruleset' by another
> process.

I find it sensible to protect a table only as long as the owning process
remains alive, at least to prevent zombie tables. This raises the
question what shall happen to orphan tables upon 'nft flush ruleset'?
Flush them like a regular one?

> > [...]
> > > > For firewalld on the other hand, I think introducing this "persist" flag
> > > > would be a full replacement to the proposed owner flag update.
> > > 
> > > I don't think we need a persist flag. If we want it to persist then
> > > we'll just avoid setting the owner flag entirely.
> > 
> > The benefit of using it is to avoid interference from other users
> > calling 'nft flush ruleset'. Introducing a "persist" flag would enable
> > this while avoiding the restart/crash downtime.
> 
> I think this 'persist' flag provides semantics the described above,
> that is:
> 
> - keep it in place if process goes away.
> - allow to retake ownership.

I'll give it a try.

Thanks, Phil
