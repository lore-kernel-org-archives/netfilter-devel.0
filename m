Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794879635;
	b=rRBnkIZ32cK12rv6+v+WfyUh7qidUg/tChxrN0g7c07jY/+pABlo9TmdrPMb8VRGUlSr
	 dHkZI535KLFXYqx+x66grW4Fn05zkaUN0B7zMxAZmlCOFYmQQbwYFyEb80gNbD2tBjNVE
	 YGwxrACiEUijkNu4xWXoPTi1BxHPHo6NHYJ04KcfMmDkYm07IArvu9CHKz5IH52QYMAzk
	 s9MSfzG3xPabp4zpJnqUYyofRJI+BGjW38ExID4KH66G64e7DkLSxfwvYSlg2NCx44jUF
	 X3SWohTcwKeazthVVA92RU+k9xw0H1jVTcr/BCdx74YWMrwxOaYlHH4wJ9PUrjelPEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794879635;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=bfWb5RBiPkAxVa1yJSTv5gJyF52mYlUF7kbQr6pnYLQ=;
	b=u0RkJh4UtFSZEJ2kZGQYQH2SBB8zQKLbX+DpW8D+srfuWCTv7NUloZtwCSbnD2lyPRrW
	 WY/sdDFKmlRxK+wjtV2euaKpJeTtZ5prKmorYJHeVPMI5BhMW08tziUSjjuhpu2gWU/Vx
	 DpGr7JR0SPrGYetGfdigRGls7D6aLBfG/JRXMHJQaTlrit4nr3nAcm67/gpQqgR65ie+i
	 ON/mpICge4qf82tXikmCvpLhdSdZjRsSfF4H3gl2HKSjXYeAKjscVa/V7FiBffKMMktUX
	 jM7oo6/HeWJl8g+7O8VBSFwiFHB5tTLeGAt/+U0wcP7Etkx5qohdA+G6GT9s8OSKBkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nO6kpO21;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD6E606A333;
	Tue, 17 Nov 2026 01:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nO6kpO21
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F2B1F000C4;
	Tue, 17 Nov 2026 01:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794879635;
	bh=bfWb5RBiPkAxVa1yJSTv5gJyF52mYlUF7kbQr6pnYLQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nO6kpO21kZQMHQgs5CBB/3tNhWvahxd0R0sSIjeevIKOOHCaCQA689n3A/RucBZdF
	 dvMWQ2mSNfKzxroZknuwivvKpSKg1TK2hXFN3EohSb0Y2NFUXFu92fVyX1+H7zUztM
	 NTdrOjKLMZBHznNPWMvgFo23Ypps+H7cVitW23p3zEPjPJLfab3OQ8oXHE0s2sCNSK
	 tkmwdTOjDj+MkvGzL88/Jzdj2YlUzhC5ReRHIoxv91gDTqduIbKLIXCMnRFuIZhXVf
	 tJrUHLEQ/ZOpPPW4/qvDX7+X4pv3M8bDg2iY95D/ayvjKfvstEhrxrpFs/etnJ2nfV
	 0K/inXqTVpZrg==
Subject:
 Re: [PATCH net 11/11] ipvs: wait grace period before reusing destinations
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 01:40:34 +0000
Message-ID: <179487963451.3136.12564607186717303065@kernel.org>
In-Reply-To: <20261116004404.2821183-12-pablo@netfilter.org>
References: <20261116004404.2821183-12-pablo@netfilter.org>
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

- [Low] The commit message describes pre-patch code that does not exist.

Pre-existing issues:
- [Low] The header comment on __ip_vs_del_service() in
  net/netfilter/ipvs/ip_vs_ctl.c still says " * - We are called under…

--

ipvs: wait grace period before reusing destinations

This patch saves an RCU grace-period cookie when an IPVS destination is
moved to dest_trash or unhashed for an edit. It then waits with
cond_synchronize_rcu() before the destination's n_list, d_list or
estimator list links are reused. Trash additions are collected in a
temporary list, so one cookie is taken after all unlinks in a delete or
flush.

> When a destination is retrieved from dest_trash, ip_vs_add_dest() currently
> restarts its estimator before waiting for the grace period.

[ ... ]

> ip_vs_start_estimator() rewrites the node on its temporary list on success,
> or initializes it on failure, before the current wait. A reader can then
> follow the changed link or stop traversing the chain early.
>
> Wait immediately after retrieving the destination, before starting its
> estimator.

[Severity: Low]
Does this paragraph match the tree being patched? It reads as if an
existing grace-period wait is being moved earlier. However, the baseline
ip_vs_add_dest() has no wait between ip_vs_trash_get_dest() and
ip_vs_start_estimator():

net/netfilter/ipvs/ip_vs_ctl.c:ip_vs_add_dest() {
    ...
	dest = ip_vs_trash_get_dest(svc, udest->af, &daddr, dport);

	if (dest != NULL) {
		IP_VS_DBG_BUF(3, "Get destination %s:%u from trash, "
		...
		ret = ip_vs_start_estimator(svc->ipvs, &dest->stats);
    ...
}

This patch adds cond_synchronize_rcu(dest->rcu_state) from scratch, along
with the rcu_state and need_gp bookkeeping. The phrases "currently" and
"before the current wait" seem to describe an earlier revision of the
patch, where the wait came after ip_vs_start_estimator().

Since this is Cc: stable, could the paragraph be reworded to describe the
new wait being added, so backporters don't go looking for an existing wait
to move?

> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 5868adda6ed6e..be818bf7d3806 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c

[ ... ]

> @@ -2063,7 +2123,8 @@ ip_vs_edit_service(struct ip_vs_service *svc, struct ip_vs_service_user_kern *u)
>   *	- The service must be unlinked, unlocked and not referenced!
>   *	- We are called under _bh lock
>   */
> -static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
> +static void __ip_vs_del_service(struct ip_vs_service *svc,
> +				struct list_head *dest_trash, bool cleanup)
>  {
>  	struct ip_vs_dest *dest, *nxt;
>  	struct ip_vs_scheduler *old_sched;

[Severity: Low]
This isn't a bug introduced by this patch, but is the "We are called
under _bh lock" line above __ip_vs_del_service() still accurate?

__ip_vs_del_service() calls ip_vs_stop_estimator() for svc->stats. It
also calls it for each dest through __ip_vs_del_dest(). Both of these can
sleep:

net/netfilter/ipvs/ip_vs_est.c:ip_vs_stop_estimator() {
    ...
	if (ktid > 0) {
		mutex_lock(&ipvs->est_mutex);
		ip_vs_est_kthread_destroy(kd);
    ...
}

The callers are ip_vs_del_service() and ip_vs_flush(), both through
ip_vs_unlink_service(). They run in process context under service_mutex,
not under a BH lock.

Since this patch already changes the signature here, could the stale
comment line be dropped or corrected at the same time?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116004404.2821183-2-pablo%40netfilter.org
