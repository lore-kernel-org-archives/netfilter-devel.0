Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874965;
	b=ARGzofHTQMWCmEHzbjdXE7OgIcvqbht4k+T6qUfaGrMsi4aXlkP3kFTg3/QkJqlNhcsn
	 UQDCRQ0qznaTv3ziSn7npYWirypHMNP8yW4JjLhEsdHHLcXqAFVd3Hi704Y4rhHdZ3fu8
	 MbgFa0AT3Q/AbOvR3f+8CHM7NyHWVN1xJfCGu7QbHtYNheGtCgBF2N5EnMLX9bCo4hdoK
	 S7nuNorDsozCp78TWBnxBb3gPfj8nxQX7Sw6FbxBqWeDdUpP4dHoWc9VhBpKVxcKdmzBg
	 d42Ha847yYXHmjBMUPp5PPvBiln3/qtqxSeM6TjXZYBg/CRaZUYmGEZpx8UXdOzmpGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874965;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TA8pVBNu8nx+baK0cXowkwFgcToksZ44AVyEJH19w9I=;
	b=g/x4CXYcCCODvbwgT2Dnw/EpU5N9bLAjzqDMP6WhLO6suRto3mdTjdx2WVtn9c5pLFfS
	 HkerONQf4HzKhbZoojdFCaPFQ6IV7x593Owie3W2xR3MdtX+jTKOi1+gsrAUBuU79ggm+
	 v6PgFza23wzEVGKZVaaMG9D9H5pFGj0YfOPKWnm1r9I4gu/1BKyaCBG1w9QAzBw48U8dA
	 CXYAThq0wkFQRy/K3l5o3v7s+qvkB6woQ7QyKV4IK0WyAdCRdOiYCBz9p+nep63CiVIlO
	 8X+Gzu51Res5F6YM/JrL1qzNZ79pkkpoG7DRbvt2NDbea5/4VgFewvnIALUGxt4hpjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=irloyEoC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55964606A323;
	Tue, 17 Nov 2026 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=irloyEoC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65051F000C4;
	Tue, 17 Nov 2026 00:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794874965;
	bh=TA8pVBNu8nx+baK0cXowkwFgcToksZ44AVyEJH19w9I=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=irloyEoCW/Gb35zEeK2u45KqK7neb5aO4nb4FSS447jhm1WB82KXYBMpo9/v0MZrA
	 Jfj0KQ67c/zKD4b3fxFHeCGbD7My0lzh1Itd5/gJAZwdIQ5sAcLnsl8YqAUdiuarYA
	 fCP237nh0Zu16Ctx1hXH0PcH2ptpiNC5jFC6MJBw+wL5raRDhP/yfMl68guzKG5g9G
	 kxs1qIfUB75adHBLtK5iJaH26k8O08ICUNhRK5Ji3Cga22LF6gI5B7Nf/Mw3xc1C73
	 dn4jxIzm7RaBWAEBuReKc0JQGQj980aB0QxKSU+9Tky1SrxQ4VgpsESsifN6HibbHX
	 4tXMgdyhsqQaA==
Subject: Re: [PATCH net-next 01/13] netfilter: flowtable: do not hw offload
 flows in teardown state
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 00:22:44 +0000
Message-ID: <179487496421.3136.13242797618262399074@kernel.org>
In-Reply-To: <20261116001612.2806263-2-pablo@netfilter.org>
References: <20261116001612.2806263-2-pablo@netfilter.org>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.
- [Low] The commit message for "netfilter: flowtable: do not hw offload
  flows in teardown state" fixes a real race in…

--

netfilter: flowtable: do not hw offload flows in teardown state

This commit changes nf_flow_offload_refresh() to check NF_FLOW_TEARDOWN
again after NF_FLOW_PENDING has been taken. If the flow is already being
torn down, the FLOW_CLS_REPLACE work is dropped instead of queued. The
fix depends on GC skipping flows that have NF_FLOW_PENDING set.

> Sashiko reports that refreshing hw offload from packet path is racy
> since the flow might be already torn down.
>
> Since commit 7c549fb7eecd ("netfilter: flowtable: generalize pending
> status bit"), GC skips flow entries that are still pending to be
> offloaded. Let's just check for the teardown status bit after the
> pending bit is set on to address this race.

[Severity: Low]
Should this have a Fixes: tag? The Sashiko report is credited in the
text, but there is no Reported-by: or Link: tag.

The fix only works because of this early return in
nf_flow_offload_gc_step():

	if (test_bit(NF_FLOW_PENDING, &flow->flags))
		return;

That return was added by 7c549fb7eecd. A stable backport without that
commit would leave the race open. Could the dependency be noted for
backporters?

The message also doesn't say what goes wrong. A hardware rule gets
reinstalled after GC's DESTROY, and the flow is then freed while that
rule is still in hardware.

Other fixes in this series do have Fixes: tags, for example
"netfilter: flowtable: purge entries immediately when destroying the
flowtable" and "netfilter: flowtable: do not scrub as crossing netns".

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 4365859220e6a..3a18fa48cadb0 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1120,6 +1120,12 @@ void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
>  	if (!offload)
>  		return;
>  
> +	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
> +		clear_bit(NF_FLOW_PENDING, &flow->flags);
> +		kfree(offload);
> +		return;
> +	}
> +
>  	flow_offload_queue_work(offload);
>  }

[Severity: High]
Is NF_FLOW_TEARDOWN the only bit that needs checking here?
NF_FLOW_CLOSING also leads to the hardware rule being removed. That bit
is still checked only in the caller, before NF_FLOW_PENDING is taken:

net/netfilter/nf_flow_table_core.c:flow_offload_refresh() {
    ...
	if (likely(!nf_flowtable_hw_offload(flow_table)) ||
	    test_bit(NF_FLOW_CLOSING, &flow->flags))
		return;

	if (test_bit(NF_FLOW_HW, &flow->flags))
		nf_flow_offload_refresh(flow_table, flow);
}

This is the same check-before-lock pattern the patch fixes for
TEARDOWN. Can the following happen?

CPU A (packet path)
flow_offload_refresh()
  sees CLOSING == 0, HW == 1
  stalls before test_and_set_bit(NF_FLOW_PENDING) in
  nf_flow_offload_work_alloc()

CPU B (packet path)
nf_flow_state_check()
  FIN/RST sets NF_FLOW_CLOSING

GC
nf_flow_offload_gc_step()
  PENDING clear, teardown false, CLOSING && HW && !HW_DYING
  nf_flow_offload_del()
    takes PENDING, sets NF_FLOW_HW_DYING, queues FLOW_CLS_DESTROY
flow_offload_work_handler()
  flow_offload_work_del() removes the rule, sets NF_FLOW_HW_DEAD
  clears PENDING

CPU A resumes
nf_flow_offload_work_alloc()
  test_and_set_bit(NF_FLOW_PENDING) succeeds
nf_flow_offload_refresh()
  test_bit(NF_FLOW_TEARDOWN) is 0, queues FLOW_CLS_REPLACE
flow_offload_work_add()
  puts the rule back in hardware, with no HW_DYING or HW_DEAD check

The flow now has CLOSING|HW|HW_DYING|HW_DEAD set and a live hardware
rule. GC never sends another DESTROY, because the CLOSING branch
requires !HW_DYING. When the flow later expires, nf_flow_offload_gc_step()
takes this path:

	if (teardown) {
		if (test_bit(NF_FLOW_HW, &flow->flags)) {
			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
				nf_flow_offload_del(flow_table, flow);
			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
				flow_offload_del(flow_table, flow);

Does this leak the hardware rule? The flow and conntrack get freed, but
the rule stays installed with a cookie that points at freed memory.

Destroying the flowtable doesn't clean it up either.
nf_flow_table_do_purge(), added by the later "purge entries immediately
when destroying the flowtable" commit, skips the hardware purge when
NF_FLOW_HW_DEAD is set. No later patch in the series touches
flow_offload_refresh() or nf_flow_offload_refresh().

A wider interleaving could also give a use-after-free. Suppose a later
GC step reads PENDING == 0 just before CPU A's test_and_set_bit(). In
that same step the flow becomes a teardown (expired, ct dying, dst check
failure, or custom gc).

GC then sees the HW_DYING|HW_DEAD left over from the earlier DESTROY and
calls flow_offload_del(). The flow and ct are freed through call_rcu()
while the REPLACE work is still queued. flow_offload_work_handler() then
dereferences offload->flow, offload->flow->ct and offload->flow->flags
outside any RCU read section.

Would it work to also check NF_FLOW_HW_DYING (or NF_FLOW_CLOSING) here,
next to TEARDOWN? HW_DYING is always set while PENDING is held, before
the DESTROY work clears PENDING, so one check would cover both teardown
paths.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116001612.2806263-2-pablo%40netfilter.org
