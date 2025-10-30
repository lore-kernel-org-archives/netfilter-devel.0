Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C9A24169D
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 23:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761867606; cv=none; b=tzksF+a+e5m4dBzcliASbq5tUWnZPH4JiZtSP2L1RM3jsFx9xuu6S4ON9i7z84sGquP9PvqNaSIeBwwFLk3fVbfWo5yqb9xZZATE+4k1kT9lT1V5mu6X6eqcc/O3sSuIv7Di5HbxnCpW+MuYa78uLUzRb7NX0DggXDQsizfJP00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761867606; c=relaxed/simple;
	bh=u6ECycmalbXbdYRV/Rb23347otgjWQdbg3aKZ7t+8Hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JItTKUUyJ1HLRLICYCR/FZRPpB2nyiS7naZ42RRigXCHR/djJznJIn3Q6QyazqzSGunGubbl5eBviiHwSdqAkztA+Dm66dehCH+5vAAZY2+c8VgCwf71Cjp4VD5w2wYHKAa9/iC0sPXf6TSqAvoDLyYujOw4/sALmi1gKKQYHjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4E08F60203; Fri, 31 Oct 2025 00:40:01 +0100 (CET)
Date: Fri, 31 Oct 2025 00:40:01 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf v2] netfilter: nft_connlimit: fix duplicated tracking
 of a connection
Message-ID: <aQP3UcydB5Rk6ZVR@strlen.de>
References: <20251029132318.5628-1-fmancera@suse.de>
 <aQJ6AysjCMTHLzsP@calendula>
 <c58ae9ad-46f3-4853-bc61-ac725c860160@suse.de>
 <aQPvFHEYZYacJQcC@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQPvFHEYZYacJQcC@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > TBH, I added this expression mainly focusing on being used with
> > > dynset, I allowed it too in rules for parity. In the dynset case,
> > > there is a front-end datastructure (set) and this conncount list
> > > is per element. Maybe there high ct count is also possible.
> > > 
> > > With this patch, gc is called more frequently, not only for each new
> > > packet.
> > > 
> > 
> > How is it called more frequently? Before, it was calling nf_conncount_add()
> > for every packet which is indeed performing a GC inside, both
> > nf_conncount_add() and nf_conncount_gc_list() return immediately if a GC was
> > performed during the same jiffy.
> 
> Before this patch, without 'ct state new' in front, this was just
> adding duplicates, then count is wrong, ie. this is broken.

Yep, this was broken.  It did never occur to me to use this
for anything other than 'stop accepting new connections from
address/network when over x'.

> Assuming 'ct state new' in place, then gc is only called when new
> entries for the initial packet of a connection (still broken because
> duplicates due to retransmissions are possible).
> 
> My proposal:
> 
> - Follow a more conservative approach: Perform this gc cycle for
>   confirmed ct only when 'ct count over' evaluates true or 'ct count'
>   evaluates false.
> - For the confirmed ct case, stop gc inmediately when one slot is
>   released to short-circuit the walk.

Its currently ending gc early after 8 reaped entries.

> ... but still long walk could possible.

Yes.

> - More difficult: For the confirmed ct case, add a limit on the
>   maximum entries that are walked over in the gc iteration for each
>   packet. If no connections are found to be released, annotate the
>   entry at which this stops and a jiffy timestamp, to resume from where
>   the gc walk has stopped in the previous gc. The timestamp could be
>   used to decide whether to make a full gc walk or not. I mean, explore
>   a bit more advance gc logic now that this will be alled for every
>   packet.

There is this:
        if ((u32)jiffies == READ_ONCE(list->last_gc))
                return false;

i.e. we never collect more than once per jiffy and list.

(actually we could, if one cpu has sailed past the test
 and another cpu completed the list walk right after,
 but I don't think its a frequent thing to happen).

I don't think its worth playing with further logic here
because even if entry x was checked one jiffy ago there
is always a chance that this connection has been torn
down right now.

If you think its needed to avoid long list walks
(i.e. resume on next packet), then I think we need
a dedicated gc function that does this, e.g. by
relinking scanned-and-valid entries at the tail.

But for insert case we have to scan until we reach
end-of-list or evict at least one entry, else we report
incorrect ct count.
