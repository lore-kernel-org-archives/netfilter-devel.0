Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C4D370AE5;
	Thu,  1 Oct 2026 10:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790849998; cv=none; b=jQBPawXAZ5gzIml9cQ+uA6nSowUF94QAWM8S8XTVxt0iZYB0WzrW2AzfB87z8tdwCS2r3/pKkfhs3Jn9mcWPgEYPS6WcpeDk+5wUyOVrJixNbxbolZtdKHz/+VbTrX9mfAkiufYQqwA/8HYAzv3RHPVFusMT9A3stgiHUmS46yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790849998; c=relaxed/simple;
	bh=nVFES05dJdPdNH4MvPtS3SfLoUIzWsT8FsNMooMXZRU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cem4oFlgAqy4mUnFbZTmAM9Rih8zc90QRlQBun34X5/puFTK50YOqHZ/pkBFFDE/BO7lhQSngNpUuFpZRUYRlz49Uo7tcn44ty/BAbfUlwyoCSUcQ0d0NiDbs0Oo/lJuJxtNK25rWbi5EpNNU342mepWl9S5FC1fSKUR7hryA3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EoApCBXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EoApCBXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE781F000FF;
	Thu,  1 Oct 2026 10:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790849996;
	bh=KPrAr2tai6AeurnhqCq4tRsFxzEy/I/Zax5DtbQXaII=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=EoApCBXvxZoi7zVyJMA602KkcF+ZoaM4cJCUSc2VPSN3fQ6ixDJm99WEme7sMnzAg
	 3J+ajeLXLeM2rUDT+acSsvGbhLvrOnlg/JVCiDI5aTCsAn+5MkODw8u+AK6pOZfmNC
	 VA1eOx67thlTwrbwNlwZtY/2DAEHuimfxIJEaGFJmOD9pLd866dHdOEXfO0POV2Tjg
	 kvwJXlzzbzm1MNPFQ08paN8oFZgO270js5dRWHSD1prNaGmfak4nK+gX0QENJ0+Qwz
	 SLQGJvbkg2Zyrd1p0TGWZVmFFmyEq4f5I4Ph1nNKI3sC3mUN4WEBipms9PYcTP8OJU
	 +i5MQSgCbk0hQ==
Subject: Re: [PATCH nf] netfilter: br_netfilter: restore VLAN tag on
 refragmented IPv6 packets
From: netdev-bot+sashiko@kernel.org
To: parri.andrea@gmail.com
Cc: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
 phil@nwl.cc, razor@blackwall.org, idosch@nvidia.com, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, kuba@kernel.org
Date: Thu, 01 Oct 2026 10:19:55 +0000
Message-ID: <179084999520.434549.4764913674478855382@kernel.org>
In-Reply-To: <20260928161830.351199-1-parri.andrea@gmail.com>
References: <20260928161830.351199-1-parri.andrea@gmail.com>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.

--

netfilter: br_netfilter: restore VLAN tag on refragmented IPv6 packets

This commit moves saving the L2 header and VLAN tag into a new helper,
br_nf_save_frag_data(). Both the IPv4 and IPv6 refragmentation branches of
br_nf_dev_queue_xmit() now call it. Before this change, the IPv6 branch
reused whatever VLAN tag the last IPv4 refragmentation on that CPU had left
in per-CPU storage.

> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index 0a394e5f4391..ec69d6254e34 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -832,6 +832,25 @@ static unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
>  	return 0;
>  }
>  
> +/* Fragments may not inherit the MAC header or VLAN tag. */
> +static void br_nf_save_frag_data(struct sk_buff *skb)
> +{
> +	struct brnf_frag_data *data = this_cpu_ptr(&brnf_frag_data_storage);
> +
> +	if (skb_vlan_tag_present(skb)) {
> +		data->vlan_tci = skb->vlan_tci;
> +		data->vlan_proto = skb->vlan_proto;
> +	} else {
> +		data->vlan_proto = 0;
> +	}

[Severity: High]
What happens when the head skb goes out untagged but the fragments still
carry a tag?

For an untagged packet this helper saves vlan_proto = 0. The consumer only
ever sets a tag and never clears one:

net/bridge/br_netfilter_hooks.c:br_nf_push_frag_xmit() {
    ...
	if (data->vlan_proto)
		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci);
    ...
}

For IPv6, nf_ct_frag6_reasm() calls inet_frag_reasm_finish(..., false).
Each original fragment stays as its own skb on the head's frag_list and
keeps its own ingress vlan_all.

On egress to an untagged VLAN (or a BR_VLAN_TUNNEL port), br_handle_vlan()
clears the tag on the head skb only:

	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED &&
	    !br_switchdev_frame_uses_tx_fwd_offload(skb))
		__vlan_hwaccel_clear_tag(skb);

A unicast-forwarded reassembled skb normally takes the skb_has_frag_list()
fast path in ip6_fragment(). On that path,
ip6_fraglist_prepare()->ip6_copy_metadata() does not copy or reset vlan_all.

So would fragments 2..N reach br_nf_push_frag_xmit()->br_dev_queue_push_xmit()
with their ingress 802.1Q/802.1ad tag still set, while the first fragment
goes out untagged?

The conntrack bridge restore path handles this case:

net/bridge/netfilter/nf_conntrack_bridge.c:nf_ct_bridge_frag_restore() {
    ...
	if (data->vlan_present)
		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci);
	else if (skb_vlan_tag_present(skb))
		__vlan_hwaccel_clear_tag(skb);
    ...
}

Without a similar else branch in br_nf_push_frag_xmit(), does the commit
message's claim that IPv6 fragments now "use the current packet's VLAN
information" still hold? The same branch would also cover the IPv4 path,
since ip_copy_metadata() does not touch vlan_all either.

Also, the comment "Fragments may not inherit the MAC header or VLAN tag"
does not seem accurate for reused frag_list skbs, which keep their own tag.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260928161830.351199-1-parri.andrea%40gmail.com
