Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593B62931EF;
	Fri, 18 Sep 2026 02:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789697062; cv=none; b=NLMz+1xPlrPX7tiOhHQZJW/CSDkFZJFLYmJ4HaiZmd3l68gld12h63WSWo8EnD8XggFsm+mZpwaLrM6LXDMDSZQ7RHrU/AkzNCf9AItq4vb7m+17BLdi6G5P2U6g6ZwjcliP4Z96G53wX1dUe2Tn4PLZ3hTg1abF04GQzvhKZN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789697062; c=relaxed/simple;
	bh=G21A8Qyzai/Mk6FwTo6oxBcHDApmDc3HP/vFX5s0PRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/ZbjaeL36KLJ0sm+KBorTqdgOs61C20l3kALVzpSCr/le8reQ3PzJi6Md0SnlbTMwabSMlZEUcq9j5ylvPkUmRutySv0uQeJWyvq/H2vtzHaY9PDUWdWXiYMSh/Sz6S73h49WITcQmLSwnJzdbEzPsfam3g77Rf8vBno3ZUW6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6iuLxNs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6iuLxNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E021F00899;
	Fri, 18 Sep 2026 02:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789697052;
	bh=qsbu5YRwyymhBZJDeN8qNvDtaokVu/uDHMOaXOb1RmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6iuLxNsLy/XZhuDpFA+kk5/OE9MpgSZX4s1T+RvLbm4Gey2PY6Demu1ceZzOoGlN
	 LeVJoJYqUjNWxSvi9v4ygJDVm1XDnwmSV64v2z+ARemysrS62DVyryE0NL53PSAlO1
	 RFUWNh3LOgxNyXCYHnpN31tBRBOpf7E4ceN4yEdaUVhw6i8GS39nuTKZQjAsO3UIbM
	 X9m1xpt8WbUv1Y2TRoG8SjmPlPsFZ/JaTRInHe6LwtXiGn4MpQaLq+68PX6HoHGZXW
	 o21DgKNYQ2cnE6nVmP8mPLMf6exf9YLOyLT0FNOQyuBk7/9ZoSy0L3c0jK5rx/gWcB
	 i6tZJwPZLd8FQ==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 07/10] ipvs: filter some flags received in the backup server
Date: Thu, 17 Sep 2026 19:04:11 -0700
Message-ID: <20260918020411.3513416-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231652.127456-8-pablo@netfilter.org>
References: <20260916231652.127456-8-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
ipvs: filter some flags received in the backup server

This adds ip_vs_sync_validate_flags() to the backup receive path so that
sync records carrying the NO_CPORT+TEMPLATE combination or ONE_PACKET are
dropped, and it also applies IP_VS_CONN_F_BACKUP_MASK to the flags taken
from version 0 messages for consistency with version 1.

A few questions about the new validation below.

> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index 5383aeafb0aed..69dc28153ec12 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -949,6 +949,21 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
>  	ip_vs_conn_put(cp);
>  }
>  
> +/* Check for incompatible flags */
> +static bool ip_vs_sync_validate_flags(u32 flags)
> +{
> +	/* We do not expect NO_CPORT, especially to allow lookups
> +	 * to hit templates
> +	 */

[Severity: Low]
This isn't a bug, but does the comment describe what the code does?  The
text reads as an unconditional statement that NO_CPORT is not expected,
while the code below only rejects it when TEMPLATE is set, and both call
sites then keep the bit:

	flags &= IP_VS_CONN_F_BACKUP_MASK;

IP_VS_CONN_F_BACKUP_MASK in include/uapi/linux/ip_vs.h is documented as
"Initial bits allowed in backup server" and it lists
IP_VS_CONN_F_NO_CPORT, so bare NO_CPORT is expected here.  It is also
needed: ip_vs_conn_new() accounts NO_CPORT entries in
ipvs->no_cport_conns[] and ip_vs_conn_in_get() relies on that counter for
the cport-zero retry used by the FTP/persistence connections referenced by
the Fixes: tag.

Could the comment be reworded to say that it is the NO_CPORT+TEMPLATE
combination that is not expected?

> +	if (flags & IP_VS_CONN_F_NO_CPORT) {
> +		if (flags & IP_VS_CONN_F_TEMPLATE)
> +			return false;
> +	}

[Severity: High]
Does this close the case described in the changelog as "the NO_CPORT+TEMPLATE
combination allows lookups for normal connections to hit template"?

A record with IP_VS_CONN_F_TEMPLATE set, NO_CPORT clear and a non-zero
cport passes this test, survives flags &= IP_VS_CONN_F_BACKUP_MASK (TEMPLATE
is part of that mask) and reaches ip_vs_proc_conn() -> ip_vs_conn_new() with
the cport taken from the wire (ip_vs_conn_fill_param_sync() copies
s->v4.cport, ip_vs_process_message_v0() copies s->cport).

ip_vs_conn_hash() hashes templates into the same dir-0 key space as normal
connections, and __ip_vs_conn_in_get() has no TEMPLATE test:

net/netfilter/ipvs/ip_vs_conn.c:__ip_vs_conn_in_get() {
	...
			if (p->cport == cp->cport &&
			    p->vport == cp->vport && cp->af == p->af &&
			    ip_vs_addr_equal(p->af, p->caddr, &cp->caddr) &&
			    ip_vs_addr_equal(p->af, p->vaddr, &cp->vaddr) &&
			    (!p->cport ^
			     (!(cp->flags & IP_VS_CONN_F_NO_CPORT))) &&
			    p->protocol == cp->protocol) {
	...
}

For a packet whose client port matches the injected cport, the XOR term is
(0 ^ 1), so the template is returned as if it were a normal connection.
Legitimate templates never hit this only because ip_vs_sched_persist()
always creates them with cport == 0 and without NO_CPORT, which is the
invariant this helper does not enforce.

Once that happens, ip_vs_in() has no template guard, so live traffic is
forwarded through the template's packet_xmit and daddr/dport, and
set_tcp_state() then adjusts dest->activeconns:

net/netfilter/ipvs/ip_vs_proto_tcp.c:set_tcp_state() {
	...
		if (dest) {
			if (!(cp->flags & IP_VS_CONN_F_INACTIVE) &&
			    !tcp_state_active(new_state)) {
				atomic_dec(&dest->activeconns);
	...
}

while ip_vs_bind_dest() counted that entry under persistconns and
ip_vs_unbind_dest() only decrements persistconns for templates, so
dest->activeconns stays skewed and affects lc/wlc scheduling for the real
service.  The timeout is taken from the message (bounded only by
MAX_SCHEDULE_TIMEOUT / HZ in ip_vs_proc_conn()), so the bogus template can
be long lived.

Would rejecting TEMPLATE records with a non-zero cport, or excluding
templates in __ip_vs_conn_in_get(), be needed for the stated goal to hold?

[Severity: Low]
This is a pre-existing issue and not introduced by this patch, but since
the helper is the new place where flag combinations are screened: a record
with NO_CPORT set and a non-zero cport is still accepted, because only the
flags word is inspected and never cross-checked against the record's cport.

ip_vs_conn_new() hashes such an entry under the non-zero cport and bumps
ipvs->no_cport_conns[af]:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_new() {
	...
	if (unlikely(flags & IP_VS_CONN_F_NO_CPORT)) {
		int af_id = ip_vs_af_index(cp->af);

		atomic_inc(&ipvs->no_cport_conns[af_id]);
	}
	...
}

The entry can then never be matched: the direct lookup fails the
(!p->cport ^ !(cp->flags & IP_VS_CONN_F_NO_CPORT)) test, and the cport-zero
retry in ip_vs_conn_in_get() hashes a different bucket than the one the
entry sits in, so ip_vs_conn_fill_cport() never runs and the counter stays
elevated until the entry expires.  While one such entry exists, every
conn-table miss in that address family does a second full hash lookup.

Is it worth also requiring cport == 0 when NO_CPORT is set?

> +	if (flags & IP_VS_CONN_F_ONE_PACKET)
> +		return false;
> +	return true;
> +}

[Severity: Low]
The changelog says:

  "2. ONE_PACKET: it is not sent by master, so we do not expect it in
  backup."

Is that accurate for controller connections?  ip_vs_sync_conn() tests
ONE_PACKET only for the connection it is entered with, and the test sits
above the sloop label:

net/netfilter/ipvs/ip_vs_sync.c:ip_vs_sync_conn() {
	...
	/* Do not sync ONE PACKET */
	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
		goto control;
sloop:
	...
	s->v4.flags = htonl(cp->flags & ~IP_VS_CONN_F_HASHED);
	...
control:
	/* synchronize its controller if it has */
	cp = cp->control;
	if (!cp)
		return;
	...
	goto sloop;
}

The controller path re-enters below the ONE_PACKET test and the serializer
clears only IP_VS_CONN_F_HASHED, so a controller carrying ONE_PACKET is
sent on the wire with that bit.  A persistence template can carry it:
ip_vs_bind_dest() strips the dest ONE_PACKET only for non-UDP and for
SYNC-created entries, and IP_VS_CONN_F_DEST_MASK includes
IP_VS_CONN_F_ONE_PACKET, which the legacy setsockopt path copies verbatim.

For a UDP persistent service configured that way, the master emits a
TEMPLATE|ONE_PACKET record which the backup now drops with retc = 25
instead of masking ONE_PACKET off and creating or refreshing the template,
so that template is no longer replicated.  The practical effect looks small
since ip_vs_conn_hash() returns early for ONE_PACKET on the master too, and
only the single record is skipped, but could the changelog wording be
adjusted, or the controller be masked in ip_vs_sync_conn()?

> @@ -972,8 +987,7 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
>  			return;
>  		}
>  		s = (struct ip_vs_sync_conn_v0 *) p;
> -		flags = ntohs(s->flags) | IP_VS_CONN_F_SYNC;
> -		flags &= ~IP_VS_CONN_F_HASHED;
> +		flags = ntohs(s->flags);
>  		if (flags & IP_VS_CONN_F_SEQ_MASK) {
>  			opt = (struct ip_vs_sync_conn_options *)&s[1];
>  			p += FULL_CONN_SIZE;
> @@ -986,6 +1000,13 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
>  			p += SIMPLE_CONN_SIZE;
>  		}
>  
> +		if (!ip_vs_sync_validate_flags(flags)) {
> +			IP_VS_DBG(2, "BACKUP v0, Invalid flags 0x%X\n", flags);
> +			continue;
> +		}
> +		flags &= IP_VS_CONN_F_BACKUP_MASK;
> +		flags |= IP_VS_CONN_F_SYNC;
> +

[ ... ]

> @@ -1141,7 +1162,13 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
>  	}
>  
>  	/* Get flags and Mask off unsupported */
> -	flags  = ntohl(s->v4.flags) & IP_VS_CONN_F_BACKUP_MASK;
> +	flags = ntohl(s->v4.flags);
> +	if (!ip_vs_sync_validate_flags(flags)) {
> +		IP_VS_DBG(3, "BACKUP, Invalid flags 0x%X\n", flags);
> +		retc = 25;
> +		goto out;
> +	}
> +	flags &= IP_VS_CONN_F_BACKUP_MASK;
>  	flags |= IP_VS_CONN_F_SYNC;
>  	state = ntohs(s->v4.state);
