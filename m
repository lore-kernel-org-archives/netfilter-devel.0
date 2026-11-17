Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794879633;
	b=4MrJ83ei8XsL6LzqA1c/BsRlGLXr9j9Qhxwz35sud9Ta3Eum+yuV4346Al2cYgMkR77n
	 olgVkfF55uhNJyRxzoBp0L3P6M+Alc5su33dqXK2LqQ+QvHAdpw+cP2ZcdrFb9iEe7up6
	 luBl/5ERvBkLwbpJ/NcYM7xAnHZxRUupGau2dJqB5aUToTgJDhcbp8sCdaOwOljQrZxb3
	 dnbdYY1NaHTeTiCvozT3A05i5V+ILRLNwGpjGoWbiQJdEvOfPttgnAYCk46eAzQgeRlhn
	 ZiRJoKYhJfEVS+0S9eVc1b4BASX39z0HI3fBVnrEDpRQp8HZoQn/4qtqCex7TL26LAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794879633;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=0b04//QWyt2VIwTKM8pdgdwuC0Lh4JvVkTwIuOgaP5M=;
	b=ziPsmggze8xMfuEcz6VF1ZLsg0hd9tqUpjsvsfMYShSrgwoUjWCp+kauhpusP2/HBdQz
	 6vREPE0mr34hr/yhSNKGUCCN1+kQsjfNoOmhA6DOi4DP3Pyp2UoSzVmGMMeDhEd1hb009
	 z58BtQm6fbWWZPB7Y+SBHz8FtJnQkbbxBUpa5S2atCxgDO897CnAMOWzLESTOeKpEVCkb
	 Z7oVXtCOKrskoK1giA24uaklIRfL8qTna8NKmusoELqpRz/qEp3yUocROBWklj/p6ptWb
	 ftQATlmK4+YfGwCw6uhd3sc83DaJV4+2a0gH7ouH8Q+wVOkPArO1Bo3sODnmRnAWncw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UloUm8N9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51120606A32C;
	Tue, 17 Nov 2026 01:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UloUm8N9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7CD1F000C6;
	Tue, 17 Nov 2026 01:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794879633;
	bh=0b04//QWyt2VIwTKM8pdgdwuC0Lh4JvVkTwIuOgaP5M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UloUm8N9ZkP5MZqCmdqX4Ob/nSjKmne8a9RijkI2WPYViWOJFC9yzfZj7H2ISXrgg
	 jQCl3Qbatc2hgQ5HQ7Wwb2yAgqHJqJgtwTuoEuy6P3XGA9ictsT1N/hXg9j+PpOtdb
	 xKvKHSpHrfpxRoU6trQQ99eMDu/VIA4cinZwWFBwjCpBmCHWwVdfWXOj3wUZnlO08E
	 ld4VoHAieI/+mIYgiMdr+f13vhGDA2Mjqm1J5MPviMeJlRAPQrnHYt8w0CzYzigjlv
	 uWyvYHG8cCU0Dp4gGv3ybQlDX1aajmVo0MlbgvfAjykImbILa9307bNqiZp6Jb3eeB
	 uObngLJWqC4Ww==
Subject:
 Re: [PATCH net 09/11] ipvs: skip cport 0 connections in ip_vs_conn_out_get()
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 01:40:32 +0000
Message-ID: <179487963213.3136.15958589947509607287@kernel.org>
In-Reply-To: <20261116004404.2821183-10-pablo@netfilter.org>
References: <20261116004404.2821183-10-pablo@netfilter.org>
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

- [Medium] The new term `(!p->vport ^ !(cp->flags &
  IP_VS_CONN_F_NO_CPORT))` in ip_vs_conn_out_get()…

--

ipvs: skip cport 0 connections in ip_vs_conn_out_get()

This commit adds a check to ip_vs_conn_out_get(). A lookup for client
port 0 now matches only connections flagged IP_VS_CONN_F_NO_CPORT, and a
lookup for a nonzero client port matches only connections without that
flag. The aim is to stop packets sent to client port 0 from matching
templates and ordinary cport 0 connections.

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
>  				    p->protocol == cp->protocol) {
>  					if (__ip_vs_conn_get(cp))
>  						goto out;

[Severity: Medium]
Can the nonzero port half of this check make reply lookups miss while
ip_vs_conn_fill_cport() is still running?

Some NO_CPORT connections are MASQ and double-hashed. One example is the
FTP passive data connection that ip_vs_ftp_out() creates with
IP_VS_CONN_F_NO_CPORT | IP_VS_CONN_F_NFCT. For these,
ip_vs_conn_fill_cport() works in two locked passes. The dir=1 pass sets
cport and rehashes hn1, but only the dir=0 pass clears the flag:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_fill_cport() {
    ...
	if (cp->flags & IP_VS_CONN_F_NO_CPORT && (!cp->cport || by_me)) {
		if (!cp->cport) {
			cp->cport = cport;
			by_me = true;
		}
		if (!dir) {
			atomic_dec(&ipvs->no_cport_conns[af_id]);
			cp->flags &= ~IP_VS_CONN_F_NO_CPORT;
		}
		...
		WRITE_ONCE(hn->hash_key, hash_key_r);
		...
	}
    ...
	spin_unlock_bh(&cp->lock);
	if (dir-- && by_me)
		goto next_dir;
}

All locks, including cp->lock, are dropped between the two passes.

Take an RCU reader in ip_vs_conn_out_get() that looks up a real server
reply to client:X inside that window. It finds hn1 with a matching
hash_key and passes the p->vport != cp->cport check, because cp->cport is
already X. NO_CPORT is still set, so the new term evaluates to 0 ^ 0 and
the lookup misses. Before this patch the same lookup matched.

One way to reach the window:

CPU A: ip_vs_nat_xmit()->ip_vs_conn_fill_cport() completes the dir=1
       pass (cport = X, hn1 rehashed) and stalls before the dir=0 pass.

CPU B: already holds cp from the cport 0 fallback lookup and sees
       NO_CPORT in ip_vs_nat_xmit(). Its ip_vs_conn_fill_cport() call
       does nothing because cp->cport != 0 and by_me is false. It then
       forwards the packet to the real server.

Reply: reaches ip_vs_out_hook(). ip_vs_conn_out_get() misses because
       NO_CPORT is still set.

On a miss, ip_vs_out_hook() takes the no-connection path. The reply then
goes out without SNAT, which exposes the real server address. If
nat_icmp_send is enabled, the reply is instead answered with ICMP port
unreachable and dropped. TCP retransmissions recover once the dir=0 pass
clears the flag.

The cases in the commit message (templates and ordinary cport 0
connections) seem to need only the zero port half of the rule. For a
nonzero p->vport, the existing p->vport == cp->cport test already
excludes those entries.

The earlier patch "ipvs: validate cport in received sync records" also
already rejects sync records that have a nonzero cport with NO_CPORT
set. No later patch in the series changes ip_vs_conn_out_get() or
ip_vs_conn_fill_cport().

Would a narrower check like this close the template and cport 0 case
without opening this window?

	(p->vport || (cp->flags & IP_VS_CONN_F_NO_CPORT))

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116004404.2821183-2-pablo%40netfilter.org
