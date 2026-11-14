Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622548;
	b=NKduwbgTGgUlsJm3fysXwREkexkGMRx9d41pFznhK5I4/3brpPesyiPeWcWGGtQq7Hpo
	 L2O01ROCQKh7pTgjlm8YoKocLGlrDkVaKgb3J0CfRi2+29qFM9KttULc8GW9DjtEqe3YT
	 hXAnrVpjl5mmZqYgqD1YFkUxLesOnOJS6+COolzNGv/P+QI8WiZmUGHe5ZR8zxMWjyx8X
	 fcZBu00aY16L4AJyPgJ1aXFwkmcWYeA4ltdzZyo3+dqjHApL/lWds95ofgLMBgCeeOd5Q
	 AtNyJR4wvZsj7iyPhgDfeeUQpox3Y0L/oREOFwH9/tmDDJO/FT3ugL85btAuJ0v3Qxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622548;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=K7Ee0RXuFIRL3X/++4BjFlJdZu68uRnMG6uLIwSo8zc=;
	b=4Oq8FOnQbRz2V7m5WjaaFNgq0Ih1AbjseSk+ZSs6CfL3H+R7yzUrKvUxOsGTNMYJqq09
	 c0rS27yuvg0d8uVV4SrPUGeWN8ah+NY+g9kHC96rwrN2NaYTMJMbQV6NKWwGEsFgCMHe/
	 S73xrtb8w7XLiwwFXRFhm1dcuVO/QMbwBtCkTQ3gLsjQDTV4i/oFOmY5KI+0l6ZRXfTtr
	 IyJG9sDsSncqlCXREaCPvgj7l1sK3FG2yroUDv1jmLrRo7oTgHnroNX8Wscjycb3giW1S
	 G6p4q/pT/MJLLgt4DeiljicIqNDsVu9/QmlBAqccjsXpT6UWIprakLkcJ6Slvumdh4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oKITd+h/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC66606A880;
	Sat, 14 Nov 2026 02:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oKITd+h/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9AD1F000C6;
	Sat, 14 Nov 2026 02:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622547;
	bh=K7Ee0RXuFIRL3X/++4BjFlJdZu68uRnMG6uLIwSo8zc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oKITd+h/6nxwngRKE2krQggxFnVE71Ln1IQH3cEKYw6r4JzLaAvlBJQ6pOb518Ese
	 QKQGy4o5OP35T7BNxjH2/cdPqxgCsXGi6z9QIV+QhYHk7YD7J0juZxRqBTLxTiVuLu
	 tWJQ/qGtacTQYLS+RaaGIU3aEwZnXmy9YLtl/qJ0tRyZxtMDobLc7AwTqHyTxVpnu6
	 izPlYVY/j3YLC3y7Bz81hvaQMwPGS1VBzPp9UDMFu1P2SGH7EN5NDwWpI/eN4hGyYF
	 uZvqbtTKWI6dde7qCX++M/w1GrufN67ZWNp9X13T2vmtqSNWlVgE0E8EUWIYYXnRG+
	 3PSqk3YsxyuWg==
Subject: Re: [PATCH net 11/15] ipvs: validate cport in received sync records
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:46 +0000
Message-ID: <179462254691.2199510.2580386044579897716@kernel.org>
In-Reply-To: <20261113011447.2357709-12-pablo@netfilter.org>
References: <20261113011447.2357709-12-pablo@netfilter.org>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] This patch has Cc: stable@vger.kernel.org, but on its own it does
  not stop synced templates from being matched by ip_vs_conn_in_get().
- [Low] The new backup check in ip_vs_proc_conn() drops every non-
  template record with a nonzero cport and IP_VS_CONN_F_NO_CPORT set.

--

ipvs: validate cport in received sync records

This commit adds checks to ip_vs_proc_conn() that drop received sync
records whose cport and IP_VS_CONN_F_NO_CPORT combination is
inconsistent. Three cases are rejected: templates with a nonzero
cport, ordinary connections with cport 0 and NO_CPORT clear, and
ordinary connections with a nonzero cport and NO_CPORT set.

> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index f11c59eca5536..7e562e745ab5d 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -871,6 +871,25 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
>  	struct ip_vs_dest *dest;
>  	struct ip_vs_conn *cp;
>  
> +	/* Templates require cport 0. Ordinary connections require
> +	 * NO_CPORT exactly when cport is 0.
> +	 */
> +	if (flags & IP_VS_CONN_F_TEMPLATE) {
> +		if (param->cport) {
> +			IP_VS_DBG(2, "BACKUP, template with cport dropped\n");
> +			kfree(param->pe_data);
> +			return;
> +		}

[Severity: Low]

This patch carries Cc: stable, but for templates it only rejects a
nonzero cport. A template with cport 0 and IP_VS_CONN_F_NO_CPORT set
still passes this check.

That combination is rejected only by ip_vs_sync_validate_flags(), which
is added by f96e91748f63 ("ipvs: filter some flags received in the
backup server"):

    if (flags & IP_VS_CONN_F_NO_CPORT) {
        if (flags & IP_VS_CONN_F_TEMPLATE)
            return false;
    }

That commit has a Fixes: tag but no Cc: stable.

Suppose a stable tree picks up only this patch. Can an unauthenticated
sync message then still install a template with TEMPLATE | NO_CPORT
and cport 0? ip_vs_conn_new() would raise no_cport_conns. The cport-zero
fallback in ip_vs_conn_in_get() would then match that template for any
client source port:

    if (atomic_read(&ipvs->no_cport_conns[af_id])) {
        struct ip_vs_conn_param cport_zero_p = *p;

        cport_zero_p.cport = 0;
        cp = __ip_vs_conn_in_get(&cport_zero_p);
    }

This happens because !p->cport ^ !(cp->flags & IP_VS_CONN_F_NO_CPORT)
evaluates to true in __ip_vs_conn_in_get().

Mainline is not affected, because f96e91748f63 is already an ancestor.
In stable, the out-of-bounds part is covered by 74cb39735b6c ("ipvs:
reject invalid states in connection template sync records"). The two
commits share the same Fixes: target, so stable tooling may pick up
f96e91748f63 anyway.

The commit message calls f96e91748f63 a "companion commit". Would it
help to state the backport dependency explicitly, for example:

    Cc: stable@vger.kernel.org # depends on f96e91748f63

> +	} else if (!param->cport && !(flags & IP_VS_CONN_F_NO_CPORT)) {
> +		IP_VS_DBG(2, "BACKUP, conn without cport dropped\n");
> +		kfree(param->pe_data);
> +		return;
> +	} else if (param->cport && (flags & IP_VS_CONN_F_NO_CPORT)) {
> +		IP_VS_DBG(2, "BACKUP, conn with cport and NO_CPORT dropped\n");
> +		kfree(param->pe_data);
> +		return;
> +	}

[Severity: Low]

Can a legitimate in-tree master send a nonzero cport with NO_CPORT
still set for an ordinary connection? The new comment says ordinary
connections require NO_CPORT exactly when cport is 0. However,
ip_vs_conn_fill_cport() updates the two fields in separate passes:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_fill_cport() {
    ...
	if (cp->flags & IP_VS_CONN_F_NO_CPORT && (!cp->cport || by_me)) {
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
	spin_unlock_bh(&cp->lock);
	if (dir-- && by_me)
		goto next_dir;
}

The dir=1 pass sets cp->cport and releases cp->lock. Only the dir=0
pass clears NO_CPORT.

On the sending side, ip_vs_sync_conn() reads the flags with
READ_ONCE(cp->flags). It takes cp->lock only when
IP_VS_CONN_F_SEQ_MASK is set. Later it copies s->v4.cport = cp->cport
without the lock. ip_vs_sync_conn_v0() copies s->cport = cp->cport the
same way.

Consider a NO_CPORT FTP data connection under MASQ. One CPU can be in
ip_vs_nat_xmit()->ip_vs_conn_fill_cport() between the two passes while
another CPU syncs the connection. The record would then carry a nonzero
cport with NO_CPORT still set, and this new branch would drop it.

The impact looks small. Before this patch, the backup would have
created a connection that incoming lookups could not match anyway, and
later syncs carry consistent flags.

Should the comment and the debug message be adjusted? This state can
come from an in-tree master, so it does not necessarily mean the peer
misbehaved.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
