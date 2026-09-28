Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09A7503BF7;
	Mon, 28 Sep 2026 23:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790639705; cv=none; b=nod7RKTfgUfyqUE/ShqZDS1l+ksFikMmOAxGcc9IA7BW04KzFPug2AoeqG21684+FTsVhRT38Zkl8Yp8ppFGJh3gP3tYJneYuIlGTM5C8gDfuWeYz4Wy7OhROIEq6byhqDs4+tPQTS8XI7ablpadoGVBNBNs4/qAcRcjiuGX03I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790639705; c=relaxed/simple;
	bh=st10Qg+NzenyBit8Eklcb30qBj2wKvNPU9QEaljV6u0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lCKTiO/eAomnVBrHhDFtp1OiQgQ7NVxsIEuy1AnDo8w/Gobdu9cpV/p228IPhVl6qxYtEUIFoLwCd7dfbB/DcLySJ3OSlkVc+5ERcnYzIH3Bx66buV3b1kZNex8qulzwFoCIyDapDbRegiN+9RiBAAJfMj9u/PvXS0oS3YX/IP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWBZ4+nl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWBZ4+nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC88F1F000FF;
	Mon, 28 Sep 2026 23:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790639703;
	bh=pKh4dwwCFsRnF3In47IlltnbJ+Rkap2vq4i7uDC8xFE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HWBZ4+nlIfjACTQJQ/urrw4XFu+T/x3qJi1LBksFoFw3XTdKZpx1mJnXS3JwCR2Pd
	 GmoIZA0fiWEZy6xmywalF3v8M5G+oYdJXUkDNvaFzMwARGCfiNV4820J6hod69sSXZ
	 w6Ghu+d2rfBvkTF3HB2HDboj4oprlRIfWM9S2wSv8uxF2JgO3XqTzt6WgrPrlU3BXX
	 RIg9H8Z+oXsDDQltkLl3HH98fEsjC05hxKKsgSFslC04lOgVufsRifFWCXLnnexXDD
	 hDr7tqKfyk3nhOnZuSiETKrwJ0OUnfV1JTVkWzzBHqCAKI1Xb/rMzXK8zZxGOdbXvo
	 tRjGv7fwM86hA==
Subject:
 Re: [PATCH net 07/11] ipvs: filter some flags received in the backup server
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 28 Sep 2026 23:55:02 +0000
Message-ID: <179063970245.3145.10108068112601989477@kernel.org>
In-Reply-To: <20260927220816.268206-8-pablo@netfilter.org>
References: <20260927220816.268206-8-pablo@netfilter.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch does not stop forged sync messages from creating
  templates that normal-connection lookups can hit.

Pre-existing issues:
- [Low] This problem wasn't introduced by this patch, but
  ip_vs_sync_validate_flags() still accepts NO_CPORT on non-template…

--

ipvs: filter some flags received in the backup server

This commit adds ip_vs_sync_validate_flags() so the backup drops sync
entries that have both NO_CPORT and TEMPLATE set, or that have ONE_PACKET
set. It also applies IP_VS_CONN_F_BACKUP_MASK to v0 message flags, to
match the existing v1 handling.

> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index dfa8487ec0c20..1a30817fbbafe 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -954,6 +954,21 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
>  	ip_vs_conn_put(cp);
>  }
>  
> +/* Check for incompatible flags */
> +static bool ip_vs_sync_validate_flags(u32 flags)
> +{
> +	/* We do not expect NO_CPORT, especially to allow lookups
> +	 * to hit templates
> +	 */
> +	if (flags & IP_VS_CONN_F_NO_CPORT) {
> +		if (flags & IP_VS_CONN_F_TEMPLATE)
> +			return false;
> +	}

[Severity: High]
Does this fully stop sync messages from creating templates that
normal-connection lookups can hit?

Take a v0 or v1 entry with TEMPLATE set, NO_CPORT clear and a non-zero
cport. It passes this check and survives IP_VS_CONN_F_BACKUP_MASK. Then
ip_vs_proc_conn()->ip_vs_conn_new() creates it with the cport from the
message: ip_vs_conn_fill_param_sync() for v1, s->cport for v0.

With no PE data, the template is hashed on the same (proto, caddr, cport,
vaddr, vport) key a normal connection uses. __ip_vs_conn_in_get() does
not check IP_VS_CONN_F_TEMPLATE:

net/netfilter/ipvs/ip_vs_conn.c:__ip_vs_conn_in_get() {
    ...
				if (p->cport == cp->cport &&
				    p->vport == cp->vport && cp->af == p->af &&
				    ...
				    (!p->cport ^
				     (!(cp->flags & IP_VS_CONN_F_NO_CPORT))) &&
				    p->protocol == cp->protocol) {
    ...
}

When p->cport == cp->cport != 0 and NO_CPORT is clear, the XOR term is 1,
so the lookup returns the template.

A later non-template sync for that tuple then gets the template back from
ip_vs_conn_in_get() in ip_vs_proc_conn(). It either expires the template,
or it toggles dest->activeconns on the template's dest and overwrites
cp->flags, state, timeout and seq:

net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
    ...
		if ((cp->flags ^ flags) & IP_VS_CONN_F_INACTIVE &&
		    !(flags & IP_VS_CONN_F_TEMPLATE) && dest) {
			if (flags & IP_VS_CONN_F_INACTIVE)
				atomic_dec(&dest->activeconns);
			else
				atomic_inc(&dest->activeconns);
		}
    ...
}

For templates, ip_vs_unbind_dest() only decrements persistconns, so the
activeconns change is never undone. After failover, real client packets
for that tuple would also be handled by the template in the ip_vs_in()
path.

The master always builds templates with cport 0. Both
ip_vs_conn_fill_param_persist() callers in ip_vs_core.c pass a literal 0.

Should the backup also reject TEMPLATE entries with a non-zero cport when
there is no PE data?

[Severity: Low]
This is a pre-existing issue, not one introduced by this patch. NO_CPORT
without TEMPLATE is still accepted here, and nothing checks that the
synced cport is 0. Is that intended?

Other code assumes NO_CPORT means cport == 0. ip_vs_ftp creates NO_CPORT
connections with cport 0, and ip_vs_conn_fill_cport() uses !cp->cport to
mean the cport has not been filled in yet:

	if (cp->flags & IP_VS_CONN_F_NO_CPORT && (!cp->cport || by_me)) {

ip_vs_conn_new() creates a NO_CPORT entry with cport X != 0 and
increments ipvs->no_cport_conns[af]. ip_vs_conn_in_get() can never find
that entry. The exact lookup fails the XOR term in __ip_vs_conn_in_get(),
and the cport_zero_p retry fails the cport comparison.

So each refresh in ip_vs_proc_conn() would create another duplicate entry,
and each one lasts until its timeout. no_cport_conns also stays non-zero,
which forces the second lookup on every in-direction miss. The entry can
still be matched in the reply direction, because ip_vs_conn_out_get()
does not check NO_CPORT.

Would it make sense to also require cport == 0 when NO_CPORT is accepted
on a non-template entry?

> +	if (flags & IP_VS_CONN_F_ONE_PACKET)
> +		return false;
> +	return true;
> +}
> +

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-2-pablo%40netfilter.org
