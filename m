Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167A03E928B
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2026 10:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784282471; cv=none; b=kYcdJ0A6rgBuzFmPL8zhxlbMCaEDzR9YNuLVniCZqWPYo30UV/Ek2Oj/ugCJ4PMEzH9RGvmtppDhO6tEip+GG/yJff6/TlUcOnJSeveomBEOPyCQbavJc+Sph1gpsMmAGuwxfQeU2NAXWFBNs9EGmUVHzVNweGBh4AJChnDHOak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784282471; c=relaxed/simple;
	bh=u/7JkjWbGmK91torPKmGmy+lTCT/0XOFu4wZcNaFS/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRyIHT2ahF7GhfLnNS3coh1WqrAvWzQjhUD1gRkky0m0DPBAHKRFFcMVTbqRolSvgyt1yLkXZ9PDKwwVphVWQpRK/Eu1mCbeX9ZiHFqK4DgxGCa6EyDtrTksoQtmXB3FHO4oOqIDP+wLCveHGDwI05tGMRRsX4GJN8jkrCJ9Hg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=X4V+zrZM; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="X4V+zrZM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=o1bvigD0dMvRbgjlnE+zZL1gdS6XKB5u27Z/kEY2br4=; b=X4V+zrZMUK7AQsEL0wBiHW3N2w
	kXGhF7iKsi/HL93dCZWbwiX0K9I1R+FB0VkIpCz86F3ylPA6m/0+Iwc/L3dPpyEJKpZGHi29h6oIL
	GNsOezfsD66rWd8oVE0cf0yGMB16b9xbS73UEbfwFDX/MQZhPLun3kzzQSExaSVbLWi8XZ0AGPfCO
	Dmfj07Jdvh3XFooMUoSecp2FRMpQgKY+TDoT/2WNUnaBAS35X9SjKWYk0bU1weOY8M4LuMjlcgd0t
	iqux3+flreKwJZsSqzQZ19JwiqH37Ih2jaYP3XLtrPUrq6GxA7lH9t15f+30p9QIaCmH7dQ4MqX00
	amNp0vkw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wkfNL-000000002aw-3raG;
	Fri, 17 Jul 2026 12:00:59 +0200
Date: Fri, 17 Jul 2026 12:00:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools] conntrack.8: Document --stats counters
Message-ID: <aln9W7xoIhKM7P4P@orbyte.nwl.cc>
References: <20260527173858.2546091-1-phil@nwl.cc>
 <ahfyv50suL44m7FX@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahfyv50suL44m7FX@strlen.de>

Hi Florian,

Finally trying to return to this open end.

On Thu, May 28, 2026 at 09:46:07AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Provide at least a brief description of each counter's meaning based on
> > code-analysis in kernel's nf_conntrack_core.c.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > While most values are pretty obvious, I am not entirely sure I got the
> > insert_failed and drop reasons right.
> 
> Thanks for working on this.   I think the hardest part is to explain
> how to interpret this, i.e. which counters may indicate issues and which
> ones do not.

Thanks for your feedback so far. What I don't like is how we all seem to
reverse engineer meaning into the counter values. Maybe this is an
opportunity to clarify what these counters *should* represent and with
that in mind treat any deviation in the code as a bug which needs
fixing.

> > ---
> >  conntrack.8 | 37 ++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 36 insertions(+), 1 deletion(-)
> > 
> > diff --git a/conntrack.8 b/conntrack.8
> > index 2bfd80e5d6aa4..b562e16839a32 100644
> > --- a/conntrack.8
> > +++ b/conntrack.8
> > @@ -108,7 +108,42 @@ Flush the whole given table
> >  Show the table counter.
> >  .TP
> >  .BI "-S, --stats "
> > -Show the in-kernel connection tracking system statistics.
> > +Show the in-kernel connection tracking system statistics. The returned values
> > +for each CPU are:
> > +.RS
> > +.TP
> > +.B found
> > +Number of successful conntrack table lookups
> 
> We don't count those anymore, its too expensive.
> This is only incremented when a new connection cannot reuse
> the tuple and has to create a new nat mapping.
> 
> See nf_conntrack_tuple_taken().

Ah, I was obviously confused. Will put as "Number of collisions seen
while inserting a new conntrack entry." Hope that covers all cases.

> > +.B insert
> > +Number of entries inserted into conntrack table
> 
> IIRC its only incremented for insertions from netlink path.

Since nf_conntrack_hash_check_insert is called from
net/netfilter/nf_conntrack_bpf.c, too I'll put this as "Number of
entries manually inserted (via netlink or eBPF)."

> > +.B insert_failed
> > +Number of failed inserts (clash resolution failure, conntrack extensions in
> > +inconsistent state, entry in dying state, oversized hash bucket encountered)
> 
> oversized hash buckets should not be mentioned here, they have their own
> counter.  Should probably not increment both counters in kernel when it
> happens.

I see it incremented in three places:

1) nf_ct_resolve_clash
   - Increments 'drop' at the same time
   - This is the "clash resolution failure" case I mentioned
   - Happens either if nf_conntrack_l4proto does not set 'allow_clash' or
     both __nf_ct_resolve_clash and nf_ct_resolve_clash_harder fail

2) First spot in __nf_conntrack_confirm
   - Called "entry in dying state" by me above
   - AIUI, happens when confirming a conntrack entry (SYN-ACK?) for which
     nf_ct_is_dying() returns true

3) Second spot in __nf_conntrack_confirm
   - Increments 'chaintoolong' at the same time
   - Happens if oversized hash bucket is encountered(?)

> Maybe: "Number of NEW connections dropped because of clashes with existing entry."?

So this would be just #1 above. As a remedy, I would:

- Remove the 'drop' increment in #1, make it *the* insert_failed counter
  case
- Remove the 'insert_failed' increment from #3

But what about #2? Introduce a new counter? Increment 'drop' instead?

> > +.B drop
> > +Number of packets dropped (clash resolution failure, removed conntrack helper,
> > +stress, TCP connection aborted)
> 
> Yes, I think we need to fix this in the kernel and not increment two
> counters for the same reason.
> 
> Drop should mostly mean "incomplete packet / out of memory".

Hmm. Assuming we no longer increment it in nf_ct_resolve_clash, the
following incrementers remain:

1) nf_conntrack_in
  - If resolve_normal_ct returns error, which happens only if
    init_conntrack returns -ENOMEM

2) nf_conntrack_in
   - Also increments 'invalid' counter
   - If nf_conntrack_handle_packet returned 0 (= NF_DROP), which seems
     to be a special case with TCP (added in commit 6b69fe0c73c0
     ("netfilter: nf_conntrack_tcp: fix endless loop"))

3) nf_confirm_cthelper
   - If TCP sequence number adjustment fails, which seems to happen only
     on ENOMEM, missing seqadj CT extension or malformed TCP packet
     (having a tcpopt header with invalid optlen)

Maybe one should split #3 to increment 'invalid' upon invalid TCP option
header? What about #2? Should this increment 'invalid' at all? It does
not seem to indicate an invalid packet, but rather some internal
corner-case, right?

> > +.B early_drop
> > +Number of packets dropped up front due to full table
> 
> AFAICS its number of connections dropped because of a full table.

This is incremented by early_drop() only, called by __nf_conntrack_alloc
if a netns's conntrack table exceeds nf_conntrack_max. Am I getting this
right and early_drop() tries to drop existing entries to free up space
for the new one? I don't see any particular preference in
early_drop_list(), is this just "best effort"? (I guess the system is
under pressure and the goal is to resolve the situation as quickly as
possible?)

> > +.B search_restart
> > +Number of times a table lookup had to be restarted due to table reorg
> 
> Not sure about this one.  This is an implementation detail (SLAB_TYPESAFE_BY_RCU).
> This can happen at any time when entry is removed from table and
> other CPU is re-instantiating a new conection using the just-unlinked
> entry.

Ah, I see. Guess the comment in ____nf_conntrack_find misled me into
believing this was about hash table reorgs.

Maybe describe like this (which avoids too many internal details):

"Number of table lookups which had to be restarted. Due to optimized
storage reuse, a table lookup may occasionally find an already deleted
entry. This is detected and remedied by restarting the search."

> > +.TP
> > +.B clash_resolve
> > +Number of entry insert clashes resolved
> 
> Maybe mention that this is not a cause for alarm and mostly
> expected with DNS these days?

Sure!

> 
> > +.TP
> > +.B chaintoolong
> > +Number of oversized hash bucket encounters
> 
> Maybe mention that this happens only on insert and results in conntrack
> to drop the packet.

ACK.

Thanks, Phil
