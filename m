Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622549;
	b=zpxblen18WVbtuBqx3aRJy/irFwohoHKsIYuLUPZB2T2Z1XQDJ3kn1DJL9OKuSfv1Etd
	 l1W+m7dGQ6C4zdhVyWgTrR45ROfBKR9nwa6TM81FvTUPzC1V3+Icp+vjOdgEwFq2scuOr
	 ZqlsyKnMzwMJ4zSMZgwrEC4IPJAjITex/lqaeXapvesQLkxBQP204jqcenmp3F0SRi0dI
	 2zqt3gO+hN/L1yfsOi3mLPvuttqhgTa1yrrdntiAJxQ6/nDb9jZ4ywTlz+FHnb3gd6eGH
	 84F5hUHyaRrhhrbMcnU9iQWugcu4hyCynNYWAXCLk0ModBE+s6pt3JA/2MtF/psuqiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622549;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=z2PzGhfCZXFT86c6LEhdmvfJrNYyQEznbTeZebR3mhw=;
	b=W2BTxxZGNPMtT3M0b/9QpQqUyMdlCg0th0xwUybpcnW9v7ChV02xSwVVIjTA4lftmhUp
	 JU4/rsu/GTqCktacim2pbLnT8JG+XkGZi+1oG+rW4sSeDjspNGMrO0OF2ZhM9DH2RtGdR
	 7ZRmiqiW4Jmp1jqQ6wjFBvdiQLL4M1cANGPB83V9c8MfhU/L2GI+2Kg0vpMaHrhPwbDre
	 nv6WX47DzkCPi2qgF1M2ivBhjVOE3F8FySyKTDh1JyFl0IIJMrBKBh4FfaKGLhOVeCk6H
	 kzthhUp5VwlwtHgFsA5uZjRdGXBen4c2SOy2MQsEdX0IT5BRrmUYB6C6HozzG+CyI1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mZD2IGJ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEE7606A886;
	Sat, 14 Nov 2026 02:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mZD2IGJ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833A31F000C6;
	Sat, 14 Nov 2026 02:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622549;
	bh=z2PzGhfCZXFT86c6LEhdmvfJrNYyQEznbTeZebR3mhw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mZD2IGJ479tzjJ2LtuLkGnYG3ZPcqBuE+vvhUqSi6Pdvjdo8+qg1n/Oz+tFCYarrS
	 E8OGJ7joDMKhWB11WIEtCVBYqeRVFEt2NR9d/cl3UhQmN/2MsFPXcBhhgHqUQY7XH9
	 H0m71nl28IMaYGQ6d5VdERWkvNwYzhHm4JhdcU3qPLnvHir1KoGYPe2+keTjz05k4K
	 wE5Q9k5su3eOWRbxZaXmMK2kr6iSviW1+CpBcJyPvKdFRhNNRPHJ1KCDs245Sdp/lt
	 D+na0EsEHPTOTdiXyLP5FiaXJTv5jI2puodVWkYPspt5utm6DvFFVRGImajaszed0Y
	 7ce7OzopHpWJg==
Subject:
 Re: [PATCH net 12/15] ipvs: skip cport 0 connections in ip_vs_conn_out_get()
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:48 +0000
Message-ID: <179462254809.2199510.1654079102144951045@kernel.org>
In-Reply-To: <20261113011447.2357709-13-pablo@netfilter.org>
References: <20261113011447.2357709-13-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] ip_vs_conn_out_get() (net/netfilter/ipvs/ip_vs_conn.c:593-594)
  now copies the symmetric rule from __ip_vs_conn_in_get(): `(!p->vport…

--

ipvs: skip cport 0 connections in ip_vs_conn_out_get()

This patch adds the rule from __ip_vs_conn_in_get() to
ip_vs_conn_out_get(). A lookup for client port 0 matches only
connections flagged IP_VS_CONN_F_NO_CPORT, and a lookup for a nonzero
client port matches only connections without that flag. The goal is to
stop templates and ordinary cport 0 connections from being matched on
the out path.

> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 66fcdc00ef375..83d8a9153a342 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -590,6 +590,8 @@ struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
>  				    ip_vs_addr_equal(p->af, p->vaddr,
>  						     &cp->caddr) &&
>  				    ip_vs_addr_equal(p->af, p->caddr, saddr) &&
> +				    (!p->vport ^
> +				     (!(cp->flags & IP_VS_CONN_F_NO_CPORT))) &&

[Severity: Medium]

Can the nonzero p->vport half of this check make the out lookup miss a
MASQ connection while ip_vs_conn_fill_cport() is still filling it?

For double-hashed connections (ip_vs_conn_use_hash2(): MASQ and not a
template), ip_vs_conn_fill_cport() works in two separately locked
passes. The first pass is dir 1:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_fill_cport() {
    ...
	/* No packets from inside, so we can do it in 2 steps. */
	dir = use2 ? 1 : 0;
    ...
		if (!cp->cport) {
			cp->cport = cport;
			by_me = true;
		}
		if (!dir) {
			atomic_dec(&ipvs->no_cport_conns[af_id]);
			cp->flags &= ~IP_VS_CONN_F_NO_CPORT;
		}
    ...
			hlist_bl_del_rcu(&hn->node);
			hlist_bl_add_head_rcu(&hn->node, head_new);
    ...
	spin_unlock_bh(&cp->lock);
	if (dir-- && by_me)
		goto next_dir;
}

After the dir 1 pass, cp->cport is set and hn1 (the node walked by
ip_vs_conn_out_get()) sits in the bucket for the new cport. But
IP_VS_CONN_F_NO_CPORT stays set until the dir 0 pass, and all locks are
dropped between the two passes.

Before this patch, an out lookup in that window matched on cport alone.
With the new check, p->vport is nonzero and the flag is still set, so
the expression is 0 ^ 0 and the entry is skipped. Nothing else in
ip_vs_conn_out_get() would find the connection.

One sequence that seems possible with an FTP PASV/EPSV data connection,
which is created with IP_VS_CONN_F_NO_CPORT:

CPU A and CPU B each handle a client packet for the data connection.
Both find it through the cport 0 fallback in ip_vs_conn_in_get().

CPU A
ip_vs_nat_xmit()
  ip_vs_conn_fill_cport()
    dir 1 pass done: cport set, hn1 rehashed, NO_CPORT still set
    cp->lock released

CPU B
ip_vs_nat_xmit()
  ip_vs_conn_fill_cport()
    sees cp->cport set and by_me false, so it does nothing
  packet forwarded to the real server

The real server's reply then reaches ip_vs_out() before CPU A runs its
dir 0 pass. ip_vs_conn_out_get() misses, so handle_response() and SNAT
are skipped. The reply is NF_ACCEPTed with the real server's address as
its source.

The window is short. It only fits a full round trip if CPU A stalls
between the passes, for example through vCPU preemption or softirq
preemption on PREEMPT_RT. TCP retransmission should recover after dir 0
completes.

The commit message's goal seems to need only the p->vport == 0 half.
For nonzero lookups, the other half only matters in this in-between
fill state. Would a one-sided check avoid opening this window? For
example:

	if (!p->vport && !(cp->flags & IP_VS_CONN_F_NO_CPORT))
		continue;

On the in side, __ip_vs_conn_in_get() uses the same symmetric rule
without this problem. There, hn0 is rehashed and the flag is cleared in
the same locked step, but hn1 has no such guarantee.

>  				    p->protocol == cp->protocol) {
>  					if (__ip_vs_conn_get(cp))
>  						goto out;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
