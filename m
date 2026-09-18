Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD444BA1D6;
	Fri, 18 Sep 2026 10:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789726997; cv=none; b=ULkuB23ALrnnzq/UKVD53k+nrFHWvn0Cgkunddml3fYOYbnweqORS8L7nRLLu+Fro9XpURRhwC7vMLNiGiWGK8+wNdOZhvl3OFlMTFoCoEuF5LKpNAAZFFRJaVUzlLlxVAa35AEme2LXZhPPAR1KkPVuwdvR3Mwl4kwrLgucutc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789726997; c=relaxed/simple;
	bh=C+8SSJ5aqX/922hSjxdyNjybXQl8gOdQl6SYYoWWU+I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EoyYQXf085aHTRTraF10KwwZfuW9c1rMf8Gqe7qewHzEsyCcTNaqdvObwYs1l6PxvrZ6w8CTG8eqMmzieShlbPBYAkQBUWE4w9l02xntDDVuVZpWKEV3FF+IeeBUEyDZNL/EHcWn3QWMgimEkhinl/Uf051r5o6Rl2ZeBOqcQDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=1TSNnXUc; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="1TSNnXUc"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 706C3217C1;
	Fri, 18 Sep 2026 13:23:06 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=1k1ovmlJLtcH4ClE6SSwD5Brkz6u+PNb3FnANbOQITg=; b=1TSNnXUc48B+
	ygEVETQ0V11WcSc7DgDCj+hqShZIyg8cusGRmObGTCTPXwrCjMsdSedl2AWyzgl+
	p19ZRXKA7hqu/ofC4GT+eFwYdVVqUhGCM/XgiNPqL9p1lCVFO2lc2sAQCsgZ8Nja
	J1zBQF64YGLG73uXugNCE4BWb7upg8Qf+AIc4KSLrmnmBw6l0Bv4dyMfu9lrDg0h
	2RFbWOUQBy/Qn1cqP8rHyskj5uC52MJPUGZYL3vHiLrVsIvmCpl6Pkf5D/IMQAAL
	hWsBYAhC4Z69gbzvCEf9P49PHiKnKidsFdHgqMbndyRII08uZMxchuJPXpAxIzeZ
	2+gTwJUnpuNx3F4g3TumPUbEcm/EVufBKdILX4C/cx/dHO/UsRrqKKG4InWxMuQv
	mmw9tSnP3z6TJHy24/sPqe0PLRrQx3aucmXRYuRRBMi7Pi5LgXIqOnXfabCngjfv
	5zbwmTmIi6LzsO48w1N8p1j5AZBVFpIvwofx/0oty47Aw+BG3XhqR6UVTvFxKcZN
	eimZVP/Z/OZ+iv5GDZIt4r976hQyKOn5yL19aILq/uUz6QwroyGOpEelV3nvmEoB
	v+ytl0dPn17pcA3GcDBzWQj626JGM79DjTzcLLluxhPYuAJiGfMLTI8zVODMTss1
	+sJ+G8+LDcgDJZGYXVAHnrEUklGLp0o=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Fri, 18 Sep 2026 13:23:06 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 772A060087;
	Fri, 18 Sep 2026 13:23:08 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 68IAN2L8032556;
	Fri, 18 Sep 2026 13:23:02 +0300
Date: Fri, 18 Sep 2026 13:23:02 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Jakub Kicinski <kuba@kernel.org>
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        pabeni@redhat.com, edumazet@google.com, horms@kernel.org, fw@strlen.de,
        Axel Mierczuk <axel.mierczuk@1password.com>
Subject: Re: [PATCH net 07/10] ipvs: filter some flags received in the backup
 server
In-Reply-To: <20260918020411.3513416-1-kuba@kernel.org>
Message-ID: <7f71f3cc-7261-f603-835b-f6f9fab0b8c0@ssi.bg>
References: <20260916231652.127456-8-pablo@netfilter.org> <20260918020411.3513416-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Thu, 17 Sep 2026, Jakub Kicinski wrote:

> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> ipvs: filter some flags received in the backup server
> 
> This adds ip_vs_sync_validate_flags() to the backup receive path so that
> sync records carrying the NO_CPORT+TEMPLATE combination or ONE_PACKET are
> dropped, and it also applies IP_VS_CONN_F_BACKUP_MASK to the flags taken
> from version 0 messages for consistency with version 1.
> 
> A few questions about the new validation below.

	I'll explain them before sending v2...

> 
> > diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> > index 5383aeafb0aed..69dc28153ec12 100644
> > --- a/net/netfilter/ipvs/ip_vs_sync.c
> > +++ b/net/netfilter/ipvs/ip_vs_sync.c
> > @@ -949,6 +949,21 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
> >  	ip_vs_conn_put(cp);
> >  }
> >  
> > +/* Check for incompatible flags */
> > +static bool ip_vs_sync_validate_flags(u32 flags)
> > +{
> > +	/* We do not expect NO_CPORT, especially to allow lookups
> > +	 * to hit templates
> > +	 */
> 
> [Severity: Low]
> This isn't a bug, but does the comment describe what the code does?  The
> text reads as an unconditional statement that NO_CPORT is not expected,
> while the code below only rejects it when TEMPLATE is set, and both call
> sites then keep the bit:
> 
> 	flags &= IP_VS_CONN_F_BACKUP_MASK;
> 
> IP_VS_CONN_F_BACKUP_MASK in include/uapi/linux/ip_vs.h is documented as
> "Initial bits allowed in backup server" and it lists
> IP_VS_CONN_F_NO_CPORT, so bare NO_CPORT is expected here.  It is also
> needed: ip_vs_conn_new() accounts NO_CPORT entries in
> ipvs->no_cport_conns[] and ip_vs_conn_in_get() relies on that counter for
> the cport-zero retry used by the FTP/persistence connections referenced by
> the Fixes: tag.
> 
> Could the comment be reworded to say that it is the NO_CPORT+TEMPLATE
> combination that is not expected?

	This is one of the things I want to explain. It is
ip_vs_sync_conn_needed() in the master that does not send
sync messages for TCP conn before it is established, so we do
not expect to see NO_CPORT on the wire. But we prefer not to
disable receiving NO_CPORT with cport=0 for normal connections.
It is nothing special to wait for initial SYN from unknown cport.

> 
> > +	if (flags & IP_VS_CONN_F_NO_CPORT) {
> > +		if (flags & IP_VS_CONN_F_TEMPLATE)
> > +			return false;
> > +	}
> 
> [Severity: High]
> Does this close the case described in the changelog as "the NO_CPORT+TEMPLATE
> combination allows lookups for normal connections to hit template"?
> 
> A record with IP_VS_CONN_F_TEMPLATE set, NO_CPORT clear and a non-zero
> cport passes this test, survives flags &= IP_VS_CONN_F_BACKUP_MASK (TEMPLATE
> is part of that mask) and reaches ip_vs_proc_conn() -> ip_vs_conn_new() with
> the cport taken from the wire (ip_vs_conn_fill_param_sync() copies
> s->v4.cport, ip_vs_process_message_v0() copies s->cport).

	This will be solved in separate patchset from
Axel Mierczuk.

> ip_vs_conn_hash() hashes templates into the same dir-0 key space as normal
> connections, and __ip_vs_conn_in_get() has no TEMPLATE test:
> 
> net/netfilter/ipvs/ip_vs_conn.c:__ip_vs_conn_in_get() {
> 	...
> 			if (p->cport == cp->cport &&
> 			    p->vport == cp->vport && cp->af == p->af &&
> 			    ip_vs_addr_equal(p->af, p->caddr, &cp->caddr) &&
> 			    ip_vs_addr_equal(p->af, p->vaddr, &cp->vaddr) &&
> 			    (!p->cport ^
> 			     (!(cp->flags & IP_VS_CONN_F_NO_CPORT))) &&
> 			    p->protocol == cp->protocol) {
> 	...
> }
> 
> For a packet whose client port matches the injected cport, the XOR term is
> (0 ^ 1), so the template is returned as if it were a normal connection.
> Legitimate templates never hit this only because ip_vs_sched_persist()
> always creates them with cport == 0 and without NO_CPORT, which is the
> invariant this helper does not enforce.
> 
> Once that happens, ip_vs_in() has no template guard, so live traffic is
> forwarded through the template's packet_xmit and daddr/dport, and
> set_tcp_state() then adjusts dest->activeconns:
> 
> net/netfilter/ipvs/ip_vs_proto_tcp.c:set_tcp_state() {
> 	...
> 		if (dest) {
> 			if (!(cp->flags & IP_VS_CONN_F_INACTIVE) &&
> 			    !tcp_state_active(new_state)) {
> 				atomic_dec(&dest->activeconns);
> 	...
> }
> 
> while ip_vs_bind_dest() counted that entry under persistconns and
> ip_vs_unbind_dest() only decrements persistconns for templates, so
> dest->activeconns stays skewed and affects lc/wlc scheduling for the real
> service.  The timeout is taken from the message (bounded only by
> MAX_SCHEDULE_TIMEOUT / HZ in ip_vs_proc_conn()), so the bogus template can
> be long lived.
> 
> Would rejecting TEMPLATE records with a non-zero cport, or excluding
> templates in __ip_vs_conn_in_get(), be needed for the stated goal to hold?

	Yep, the above problems will be solved...

> [Severity: Low]
> This is a pre-existing issue and not introduced by this patch, but since
> the helper is the new place where flag combinations are screened: a record
> with NO_CPORT set and a non-zero cport is still accepted, because only the
> flags word is inspected and never cross-checked against the record's cport.
> 
> ip_vs_conn_new() hashes such an entry under the non-zero cport and bumps
> ipvs->no_cport_conns[af]:
> 
> net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_new() {
> 	...
> 	if (unlikely(flags & IP_VS_CONN_F_NO_CPORT)) {
> 		int af_id = ip_vs_af_index(cp->af);
> 
> 		atomic_inc(&ipvs->no_cport_conns[af_id]);
> 	}
> 	...
> }
> 
> The entry can then never be matched: the direct lookup fails the
> (!p->cport ^ !(cp->flags & IP_VS_CONN_F_NO_CPORT)) test, and the cport-zero
> retry in ip_vs_conn_in_get() hashes a different bucket than the one the
> entry sits in, so ip_vs_conn_fill_cport() never runs and the counter stays
> elevated until the entry expires.  While one such entry exists, every
> conn-table miss in that address family does a second full hash lookup.
> 
> Is it worth also requiring cport == 0 when NO_CPORT is set?

	It is harmsless but better to check it.

> 
> > +	if (flags & IP_VS_CONN_F_ONE_PACKET)
> > +		return false;
> > +	return true;
> > +}
> 
> [Severity: Low]
> The changelog says:
> 
>   "2. ONE_PACKET: it is not sent by master, so we do not expect it in
>   backup."
> 
> Is that accurate for controller connections?  ip_vs_sync_conn() tests
> ONE_PACKET only for the connection it is entered with, and the test sits
> above the sloop label:
> 
> net/netfilter/ipvs/ip_vs_sync.c:ip_vs_sync_conn() {
> 	...
> 	/* Do not sync ONE PACKET */
> 	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
> 		goto control;
> sloop:
> 	...
> 	s->v4.flags = htonl(cp->flags & ~IP_VS_CONN_F_HASHED);
> 	...
> control:
> 	/* synchronize its controller if it has */
> 	cp = cp->control;
> 	if (!cp)
> 		return;
> 	...
> 	goto sloop;
> }
> 
> The controller path re-enters below the ONE_PACKET test and the serializer
> clears only IP_VS_CONN_F_HASHED, so a controller carrying ONE_PACKET is
> sent on the wire with that bit.  A persistence template can carry it:
> ip_vs_bind_dest() strips the dest ONE_PACKET only for non-UDP and for
> SYNC-created entries, and IP_VS_CONN_F_DEST_MASK includes
> IP_VS_CONN_F_ONE_PACKET, which the legacy setsockopt path copies verbatim.
> 
> For a UDP persistent service configured that way, the master emits a
> TEMPLATE|ONE_PACKET record which the backup now drops with retc = 25
> instead of masking ONE_PACKET off and creating or refreshing the template,
> so that template is no longer replicated.  The practical effect looks small
> since ip_vs_conn_hash() returns early for ONE_PACKET on the master too, and
> only the single record is skipped, but could the changelog wording be
> adjusted, or the controller be masked in ip_vs_sync_conn()?

	Templates with ONE_PACKET will not be hashed. But before that
we can attach such template as controlling connection to some
data connection. Such template will be invisible (not hashed)
and will expire when its data connection expires. But it is better
to disallow ONE_PACKET for templates. Will post a patch for this.

Regards

--
Julian Anastasov <ja@ssi.bg>

