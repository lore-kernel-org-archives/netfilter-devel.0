Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBBD59D61B;
	Tue,  8 Sep 2026 18:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788890644; cv=none; b=l89GlkQ5SkDNVHBf4ZlZcOgA6q8uEqfsjnzOxv978q/I1Hbc/Cp3HCxMMmLSVR3J9FBs/QHrbnwnG+zdcyZ5P4dVU9Mg2oy3UC9lDc9+7172N0MHS4iiSiGwxRMU/EvT8eVoQf2NxyUA867yBuk2VbFoY5+DZ1bpaL6FwhRbdU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788890644; c=relaxed/simple;
	bh=ZBk6B19vG9Sra1Av/g7R6wy2+3dvzFq+xH3DUEo5cuU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uxohD5chlBWHFFyQlLvsDUi275S0gFmx2t9+qPR0g04st1UnwpYoyPvkTZX2dFcrXEKocxIKxRgjIyxMtrva2lU0fPYgn6TYD7ayIa0WA38diBjmG9FLp3ytfv/qNBwKyMAuVLGAEwsBBwIEejml0RGpuFH2z9ASGhTKYBe5wL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIsUTFeh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIsUTFeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4101F00A3A;
	Tue,  8 Sep 2026 18:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788890642;
	bh=H7s4JtONqF4Pi0x8N4keB4JODkU+W2Qd9K/O5CFwllI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SIsUTFehconGAovaJq3arO64Ey8DGO0M+qD/r3tMKXYxGSwPA89eUpytlK6EK4uIM
	 KFTRSAq0IoGBshGdMpM1alLx4xT5U+8pSGtWLj+rx9ojrCMLfEuRLI1NdHgWOy62ki
	 v6KsWidS1PstPJYh/sCSgYS3WY8Oh4N4EzBiWCFb0A8mJ04J1S4OBu5yr5to4CIyB8
	 pQInpH79Q8tRfW+jN/UjTwfOKRYU2GnBtA/Ab/9XbiJSqaH7LItJVjyqKiVdhRlixw
	 jDJQOwqfVEN18RN1exxhsrrBdv4pH0EETs6IKY8OOYGoXwF627ACAyyTBOEKBZo90S
	 ASi66/zxqQFrw==
Subject:
 Re: [PATCH net 4/9] netfilter: cttimeout: prevent UAF during module unload
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 08 Sep 2026 18:04:01 +0000
Message-ID: <178889064168.219967.15151233151602486944@kernel.org>
In-Reply-To: <20260907171732.1407739-5-pablo@netfilter.org>
References: <20260907171732.1407739-5-pablo@netfilter.org>
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
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 0 · Low: 0

- [High] cttimeout_exit() only drains RCU readers that reach the per-net
  timeout storage through nf_ct_timeout_hook.

--

netfilter: cttimeout: prevent UAF during module unload

This reorders cttimeout_exit() so that nf_ct_timeout_hook is cleared and
synchronize_net() is called before unregister_pernet_subsys() frees the
per-net timeout storage.  That closes the window where nf_ct_set_timeout()
could still reach the freed nfct_timeout_pernet blob through the hook.

> diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
> index 66c2016f6049d..132c02ac7c4ea 100644
> --- a/net/netfilter/nfnetlink_cttimeout.c
> +++ b/net/netfilter/nfnetlink_cttimeout.c
> @@ -652,9 +652,9 @@ static void __exit cttimeout_exit(void)
>  {
>  	nfnetlink_subsys_unregister(&cttimeout_subsys);
>  
> -	unregister_pernet_subsys(&cttimeout_ops);
>  	RCU_INIT_POINTER(nf_ct_timeout_hook, NULL);
>  	synchronize_net();
> +	unregister_pernet_subsys(&cttimeout_ops);
>  }

[Severity: High]
Does this leave the same per-net object reachable from the netlink dump
path during unload?

cttimeout_get_timeout() starts the dump without a module reference:

net/netfilter/nfnetlink_cttimeout.c:cttimeout_get_timeout() {
	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
		struct netlink_dump_control c = {
			.dump = ctnl_timeout_dump,
		};
		return netlink_dump_start(info->sk, skb, info->nlh, &c);
	}

With no .module set, __netlink_dump_start()'s try_module_get(control->module)
is try_module_get(NULL), which succeeds without taking anything, and
cb->module stays NULL.  nf_tables_api.c and nfnetlink_hook.c pass
.module = THIS_MODULE in their netlink_dump_control for comparison.

ctnl_timeout_dump() reads the per-net blob that unregister_pernet_subsys()
frees, and it is not gated by nf_ct_timeout_hook:

net/netfilter/nfnetlink_cttimeout.c:ctnl_timeout_dump() {
	rcu_read_lock();
	pernet = nfct_timeout_pernet(net);
	list_for_each_entry_rcu(cur, &pernet->nfct_timeout_list, head) {

Is the following sequence possible?

1. IPCTNL_MSG_TIMEOUT_NEW creates one policy; cttimeout_new_timeout() does
   __module_get(THIS_MODULE).
2. A NLM_F_DUMP IPCTNL_MSG_TIMEOUT_GET parks the dump: with one entry
   present ctnl_timeout_dump() returns skb->len > 0, netlink_dump() queues
   the skb and leaves nlk->cb_running set with cb->dump =
   ctnl_timeout_dump.
3. IPCTNL_MSG_TIMEOUT_DELETE removes the policy, and ctnl_timeout_del()
   does module_put(THIS_MODULE), so the module refcount is back to zero
   while the dump is still parked.
4. rmmod runs cttimeout_exit().  The synchronize_rcu() inside
   nfnetlink_subsys_unregister() and the new synchronize_net() only wait
   for RCU read-side sections, and a parked dump is not in one, so
   unregister_pernet_subsys() frees the nfct_timeout_pernet allocation and
   the module text goes away.
5. The next recvmsg() on that netlink socket resumes the dump:

net/netlink/af_netlink.c:netlink_recvmsg() {
	if (READ_ONCE(nlk->cb_running) &&
	    atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf / 2) {
		ret = netlink_dump(sk, false);

which is an indirect call through cb->dump into freed module text, and
then a read of the freed pernet->nfct_timeout_list.

Should the dump control also carry .module = THIS_MODULE so the parked
dump pins the module across the unload, given the commit is aimed at the
same freed nfct_timeout_pernet object during module unload?

Note that a dump over an empty policy list does not park: ctnl_timeout_dump()
returns 0 there and netlink_dump() finishes the dump immediately, so the
create/park/delete order above is what makes it reproducible.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260907171732.1407739-2-pablo%40netfilter.org
