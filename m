Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795382247;
	b=p7B4jHPhgh3jd1dmlggVi6Pdk0Aim4MrxbDoZ/BQSBK0fEpXhNMMFGGqzI7XzZefoH+Q
	 6Jl2pdPLb/r8hhYnL4re5WoRFfHODL/imOI5bmlNPmLu9+f5Sb7ZE6gb0LqXD/u9R518B
	 94d08Se4VXumCuglo8GTf6NKQMi4GmQryeadLA++JomXpdLOuKEZgyRCz/QlJ8ypSXa//
	 C2L3lehKmsnCHk2bW3Z2uLBeAxBGhomWU5dmxCFQLLy1mYv9WqgsWDxJrkqPxFUqEa9NN
	 Ue7pH+TMXxDoHW6NrfryRHNCwjClEYVATWHGrSDr0o726M/OdKthv0EiP9oGAa07T3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795382247;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=VEH5Z1+w3LaZYxRFfj703Jy4TbGcg5XJ26mZdw8z3OI=;
	b=Gv4ZqWMxlht2p7FjmgHJo/1daidgr3iwTaR4abZOoJ1h/DKkk279EYqMY0ibdwbb1PJo
	 sjPfIefeW+ChDBZBsW9SgNFQUVduxBKyH5nB83sudpNE0p9cz/gNQNyf2YT/i3nenOfBB
	 Xut23Ij0p6vDSmP32ZSVhWwUrlB0uPXmPM4GwEpXCql1BsSs1GVUUYQS14YPrwuEQcCtu
	 Mexzd4SsRZPhzBSqgT5apDO9mJGPrydUo1N/zM2XkdDnHREgM3RQkPcIylmKdouIGiXMa
	 gCciaqy8eIGXAnYCgwC1zC+jei+L2VrRz/3EUlN9zAoA2A4GeDU2nB+ZrRe3+CghAbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wlz1CzPd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF08606A33C;
	Sun, 22 Nov 2026 21:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wlz1CzPd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457031F000D3;
	Sun, 22 Nov 2026 21:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795382247;
	bh=VEH5Z1+w3LaZYxRFfj703Jy4TbGcg5XJ26mZdw8z3OI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Wlz1CzPdrOU749KaM+PJC+HqR0Y+mhjW99jS9BMg6ZQBdQ14QnKMjHKyt3BGkHkau
	 A9tlIMBfE50CoIwE1eCsq+96XiUn3BSCrcqZv8ZYgZfkfyJFX4fjY99fhFBGOktnGR
	 ZijA1+e/3uAjHquZWN+zf9QT9SfKTXlYLU0LY2ke+iAtq+nzaQbTgWB8z/584jC6qc
	 tFbKOlsvVTXRXLutSIWK579VysHrvZ4y1w86T1/JdIY881YmoR32kE6Lq+K5h6Expg
	 lXwtNPI/BQHbV9yKixycfyKm3IayW3KrjS8ZaT6NrOZvJ0FYFznQFY+zxoG42OWuVg
	 f/kyNTkUqEm5Q==
Subject: Re: [PATCH net 2/4] netfilter: flowtable: restore the GRE conntrack
 timeout on teardown
From: netdev-bot+sashiko@kernel.org
To: florian.fainelli@broadcom.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, shuah@kernel.org, toshiaki.makita1@gmail.com,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org
Date: Sun, 22 Nov 2026 21:17:25 +0000
Message-ID: <179538224582.3135.4873472373234094009@kernel.org>
In-Reply-To: <20261118201250.2075007-3-florian.fainelli@broadcom.com>
References: <20261118201250.2075007-3-florian.fainelli@broadcom.com>
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

- [Medium] The patch adds a GRE branch to flow_offload_fixup_ct()
  (net/netfilter/nf_flow_table_core.c).

--

netfilter: flowtable: restore the GRE conntrack timeout on teardown

This commit adds a GRE branch to flow_offload_fixup_ct(). When a GRE flow
is torn down, its conntrack timeout is restored to the GRE replied or
unreplied timeout. Without this, the entry keeps the NF_CT_DAY timeout it
got at offload time. GRE has no offload timeout of its own, so
NF_FLOW_TIMEOUT is subtracted when the flow has expired.

> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 2aa2647ed9df0..051b15aecd893 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -237,6 +237,18 @@ static void flow_offload_fixup_ct(struct flow_offload *flow)
>  		timeout = READ_ONCE(tn->timeouts[state]);
>  		expired = nf_flow_has_expired(flow);
>  		offload_timeout = READ_ONCE(tn->offload_timeout);
> +#ifdef CONFIG_NF_CT_PROTO_GRE
> +	} else if (l4num == IPPROTO_GRE) {
> +		const struct nf_gre_net *tn = nf_gre_pernet(net);
> +		enum gre_conntrack state =
> +			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
> +			GRE_CT_REPLIED : GRE_CT_UNREPLIED;
> +
> +		timeout = READ_ONCE(tn->timeouts[state]);

[Severity: Medium]
Should this read the per-conntrack GRE timeouts instead of the per-netns
defaults?

The GRE tracker does not refresh entries with the pernet values directly.
In nf_conntrack_gre_packet(), the per-ct fields are set from an attached
timeout policy when one exists. The pernet defaults are only the fallback:

net/netfilter/nf_conntrack_proto_gre.c:nf_conntrack_gre_packet() {
    ...
	if (!nf_ct_is_confirmed(ct)) {
		unsigned int *timeouts = nf_ct_timeout_lookup(ct);

		if (!timeouts)
			timeouts = gre_get_timeouts(nf_ct_net(ct));
		...
		ct->proto.gre.stream_timeout = timeouts[GRE_CT_REPLIED];
		ct->proto.gre.timeout = timeouts[GRE_CT_UNREPLIED];
	}
    ...
}

Every later refresh then uses ct->proto.gre.stream_timeout or
ct->proto.gre.timeout.

GRE registers .ctnl_timeout, so an nft ct timeout object or an
nfnetlink_cttimeout policy can be attached. nft_flow_offload_eval()
rejects GRE flows that are NATed, keyed, or have a helper. It does not
reject flows that have a timeout policy.

As an example, take a policy that sets the GRE replied timeout to 2h. An
offloaded GRE v0 flow goes idle, and the GC tears it down with expired
set to true. This branch then computes the default 180s minus
NF_FLOW_TIMEOUT, which is 150s. Since nf_flow_timeout_delta(ct->timeout)
is larger than that, nf_ct_refresh() makes the entry expire in about 2.5
minutes instead of 2h.

The reverse also happens: with a policy shorter than the sysctl value, the
longer default replaces it.

Would reading ct->proto.gre.stream_timeout and ct->proto.gre.timeout here
match what the GRE tracker actually uses? The UDP branch above has the
same pattern, but that code predates this patch.

> +		expired = nf_flow_has_expired(flow);
> +		/* GRE has no offload timeout: see flow_offload_get_timeout(). */
> +		offload_timeout = NF_FLOW_TIMEOUT;
> +#endif
>  	} else {
>  		return;
>  	}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118201250.2075007-1-florian.fainelli%40broadcom.com
