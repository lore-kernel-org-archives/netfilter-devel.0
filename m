Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531173;
	b=LPMtVl1zovNzohFlOmLuEhj2MA2FAgEa/pmQMOn3AwjusvC+FAR6DpIZlQoLMezarFnf
	 ozqAwyTvGxrSX5IG3cIOKQnY50mivvVpxU0TZ7Vco4UqrpXOwzD65WkS2vvLGQPGGQvRH
	 rvoqvSfj5X2cR5GJ/NRJMNixl3evmNYT7ODU+jx+HsV7eSseTZHLa2oVFhzf+vHZH2kMA
	 vKh/3c+g+sd6eAQN8bRY3ou+dPMUzOZlbzrwFUhxsqiJUC07P+xKqra5m92DqZto8ELKj
	 r0GT++9sYjqCEs/+6SnMbk0Xo1hB40xeycDl1UztH83Qn3Gqr/SqhKh1oPVLpmkyxNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531173;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=z8v4NCeWFM6qc5ofwBJn2Izk3HxJydkFDGFRVXGG0p8=;
	b=Wb7BTQJQoIpvd471MGNfsULoDixlkddiA94/4ChGBlZbXePqt7gL0LhST6kgRuYT2MSF
	 PTaPGmnaZbP9O2rqRzFHeNEe22uY2bTOCEpzJ+mHh0ZJNxbgmPsoqW+u4FFBey5yVtZ0D
	 sEr6KGK6ujKUzXaSdeP65ry1SPHce2dw1lpZY0hqKWxoCGhHQTrwRc4Qrnhugy9RzAIic
	 me1OPYckEABD8+RLzUH9u092kRUBKPd7vM8ka/izouskMxSNPi58Atw2I0IaGIqyVoSMJ
	 gSHp25xmDkWWT9F3EUO+NEP85hxjkpIjbNsJOMlOvtDlZyGseuTCI0mC3PYTaHkQkiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bt94r4dJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F992606A329;
	Tue, 24 Nov 2026 14:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bt94r4dJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3061F000D2;
	Tue, 24 Nov 2026 14:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531172;
	bh=z8v4NCeWFM6qc5ofwBJn2Izk3HxJydkFDGFRVXGG0p8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bt94r4dJe9Wuy1mJTKUxz+6anRZR0AS/CjF3d4YhvOc47Y3nuq0PV1kMOUUROb+hp
	 jaoweIZP/6T6ewQzBMehUU2Iy6VwzPoKoHVMmL6++H8f19vHR3ZVRzdMCX9f+/2sjz
	 jM03k2XcIYXAYd8KHdcxmUoJbDxbOeXK9PCFvleP28yHSaV1IcrayvtiXziXGAusXf
	 4lJAuxV1BLwDLI2HjFZOIMhWOiLgjqFXwLhhmiYnfhapb4ySntFWmMQ5YlLeswhX9e
	 MMM5h8Y17T0EIBaElyxJBU6lnip64o/Z0mJ7Z15kvlFP5nshGFsngD/HqXH2/LkM8k
	 UV+oQCre94Rfw==
Subject: Re: [PATCH net-next 04/15] netfilter: conntrack: verify L4 protocol
 before calling helper
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:32 +0000
Message-ID: <179553117201.3135.14194838592566427007@kernel.org>
In-Reply-To: <20261123135726.3940688-5-pablo@netfilter.org>
References: <20261123135726.3940688-5-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] This patch breaks the H.245 helper on the normal netfilter path,
  which breaks H.323 media tracking and NAT.
- [High] nft_ct_expect_helper_alloc() now sets the internal helper's
  l4proto to `priv->l4proto` (NFTA_CT_EXPECT_L4PROTO).
- [Low] The commit message does not fully describe the behaviour change.

--

netfilter: conntrack: verify L4 protocol before calling helper

This commit makes nf_ct_call_helper() skip the assigned conntrack helper
when the packet's L4 protocol does not match helper->l4proto. It also
skips IPv4 fragments and packets with no L4 payload. It sets l4proto on
the internal helper that nft_ct expectation objects allocate.

> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index 32f900c155de8..18125aa29e0d0 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -134,21 +134,23 @@ static bool in_vrf_postrouting(const struct nf_hook_state *state)

[ ... ]

>  	case NFPROTO_IPV6:
> -		pnum = ipv6_hdr(skb)->nexthdr;
> -		start = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum, &frag_off);
> -		if (start < 0 || (frag_off & htons(~0x7)) != 0)
> +		*pnum = ipv6_hdr(skb)->nexthdr;
> +		start = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), pnum, &frag_off);
> +		if (start < 0 || frag_off)
>  			return false;

[Severity: Low]
This isn't a bug, but the commit message only mentions IPv4:

  Also change ipv4 to explicitly skip frasgments, this shouldn't happen
  for normal netfilter-only code path, ...

The IPv6 check in nf_confirm_get_protoff() changes too. ipv6_skip_exthdr()
returns the raw frag_off field, including the M bit and the reserved
bits. So the new check also rejects first fragments (offset 0, M=1) and
atomic fragments with reserved bits set. Before, both of those still
went through the helper and seqadj.

The new check also no longer matches the unchanged IPv6 check in
nf_ct_helper() in nf_conntrack_ovs.c.

Could the commit message mention the IPv6 change as well?

The commit message also says:

  or when conntrack got attached via TC/act_ct, then was later munged via
  act_pipe to alter the ip protocol.

There doesn't seem to be an act_pipe tc action. Should this say
pedit/bpf, like the new comment above nf_ct_call_helper()? Also, there's
a typo (frasgments).

[ ... ]

> @@ -204,6 +210,9 @@ int nf_ct_call_helper(struct sk_buff *skb, struct nf_conn *ct,
>  		/* rcu_read_lock()ed by nf_hook */
>  		helper = rcu_dereference(help->helper);
>  		if (helper) {
> +			if (helper->l4proto != pnum)
> +				return NF_ACCEPT;
> +

[Severity: High]
Does this guard break the H.245 helper on the normal netfilter path?

h323_helper_init() in nf_conntrack_h323_main.c registers H.245 as a UDP
helper:

	nf_ct_helper_init(&nf_conntrack_helper_h245, AF_UNSPEC, IPPROTO_UDP,
			  "H.245",
			  &h245_exp_policy, 0, h245_help, NULL, THIS_MODULE);

However, expect_h245() creates a TCP expectation and assigns that helper
to the TCP child conntrack:

	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
			  &ct->tuplehash[!dir].tuple.src.u3,
			  &ct->tuplehash[!dir].tuple.dst.u3,
			  IPPROTO_TCP, NULL, &port);
	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_h245_ptr);

h245_help() also parses TCP: get_tpkt_data() reads a struct tcphdr at
protoff.

With this patch, every H.245 packet takes this path:

q931_help()->expect_h245()   (TCP expectation, H.245 helper)
nf_confirm()->nf_ct_call_helper()
    nf_confirm_get_protoff() sets pnum = IPPROTO_TCP
    helper->l4proto (IPPROTO_UDP) != pnum -> return NF_ACCEPT

As a result h245_help() never runs. No RTP/RTCP/T.120 expectations are
created and the H.245 NAT payload rewrite is skipped. Wouldn't H.323
calls through an iptables/nftables conntrack/NAT box lose their media?

Before this patch nf_confirm() didn't check the protocol. Only the
nf_ct_helper() path used by OVS/act_ct had this check. This still seems
to be the case at the end of the series.

Should the H.245 helper be registered with IPPROTO_TCP as part of this
change? This matters more because the Fixes: tag makes the patch a
stable candidate on its own.

>  			helper_cb = rcu_dereference(helper->help);
>  			if (helper_cb) {
>  				ret = helper_cb(skb, protoff,
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 5a8db55920364..58846bc405b7e 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -1307,6 +1307,7 @@ static int nft_ct_expect_helper_alloc(struct nft_ct_expect_obj *priv)
>  		 "nft_ct_expect");
>  	ct_expect_helper->me = THIS_MODULE;
>  	ct_expect_helper->expect_policy[NF_CT_EXPECT_CLASS_DEFAULT].max_expected = priv->size;
> +	ct_expect_helper->l4proto = priv->l4proto;

[Severity: High]
Is priv->l4proto the right value to store here?

In the expectation object, l4proto is the protocol of the expected child
connection. ct_expect_help() passes it as the protocol of the
expectation tuple:

	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
			  &ct->tuplehash[!dir].tuple.src.u3,
			  &ct->tuplehash[!dir].tuple.dst.u3,
			  expect_data->obj.l4proto, NULL, &expect_data->obj.dport);

The new guard in nf_ct_call_helper() compares helper->l4proto with the
L4 protocol of the master connection that the helper is attached to.

nft_ct_expect_obj_eval() attaches the helper to any unconfirmed
conntrack. Unlike nft_ct_helper_obj_eval(), it doesn't check
nf_ct_protonum(ct) against priv->l4proto:

	if (help && refcount_inc_not_zero(&priv->helper->ct_refcnt))
		rcu_assign_pointer(help->helper, priv->helper);

The nft documentation shows a TCP control connection with a UDP
expectation:

  ct state new tcp dport 8888 ct expectation set "expect"

Here the expectation object uses "protocol udp". So pnum is IPPROTO_TCP
and helper->l4proto is IPPROTO_UDP. ct_expect_help() never runs and no
expectation is created. Nothing reports an error, either at rule load
or at runtime.

Before this patch, helper->l4proto was 0 from kzalloc and nf_confirm()
didn't check it, so expectations with a different protocol than the
master worked. The code is still unchanged at the end of the series.

Could the check use the master connection's protocol for this helper
instead? Another option is to reject the mismatch in
nft_ct_expect_obj_eval().

A smaller point: the l4proto field comment in struct
nf_conntrack_helper says IPPROTO_UDP/TCP, but this assignment can now
store DCCP or SCTP.

>  	rcu_assign_pointer(ct_expect_helper->help, ct_expect_help);
>  	refcount_set(&ct_expect_helper->ct_refcnt, 1);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
