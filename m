Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E9332E68D;
	Wed, 30 Sep 2026 14:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778671; cv=none; b=utKEhGG6DH2Ob/8a/3XhWPYY1qVWjA/EQHD6f+Kn1yQGuRlpTQk4P+ejU1lDhehI24Z2MEQqkWn0rbp6bg/NnhnfuTE1r0p0KlpA0eiPpg74wffwxQFX0E62i8DI4ErZTJsl/m/zoPkM8LW5kuaCZNjWZ0ek7pixdiPZOslMWl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778671; c=relaxed/simple;
	bh=In1jfoZgA7hKFvPd8grQdVx0ACGLBboIKgPshcrVARE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oSRe9PRe3GqX9FR8qFZ37nGFWrhPi5pk2znB+UWqTCWODp5lCMVPwLxa0zzXFCtkd8UnYH/q5FfWXq8rhH2XFMPU7WIUqprOCx18R9ty0LJQUDFYp0XKtYbgMXjkpsPXSAZ0DL9tQ5ZYyx5muilfPbVk6rHzfLVb/vJE5fyE/oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z49w6/Mj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z49w6/Mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC851F000FF;
	Wed, 30 Sep 2026 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790778655;
	bh=/MBlzshaZKN9ldEh0rW4BKwnU7tTe6JLMiFrUo/22rc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Z49w6/Mj71fB4+Y3//GgSOQT64E2cKM5yvr0Dl1bzueKlg8Rcbezygj8ItgQN/FTW
	 evOher9AIhyHXgJF9crmZOuyhDh+XrIQZFoKNKkMTJbEr3O4axilg1EZSMFVBF++7Q
	 RH8ug6TwsGCK1KsJOGCpeCB4luST23PVehj3Zy9vQ8cq3J+3M3/s+t8nq8cQREOIF1
	 4FHWzvQwJP9xD/rQGD6PzJry5wF/e5zQvkCPBz8CzgjvzPKkFqQgnGUUYk2fj3IXCX
	 WTNy0RuTrtE2C3n61QW59xCPvoxXkK2hcYJhtKAIPSCQUO95ufhj5UltV301A1Tm/9
	 2iRsx0eDQx0IQ==
Subject: Re: [PATCH] netfilter: ebtables: ebt_802_3: drop short frames before
 the match reads LLC
From: netdev-bot+sashiko@kernel.org
To: guozh23@xiaopeng.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, razor@blackwall.org,
 idosch@nvidia.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 30 Sep 2026 14:30:54 +0000
Message-ID: <179077865471.434549.9648522947578914338@kernel.org>
In-Reply-To: <20260928082858.3009191-1-guozh23@xiaopeng.com>
References: <20260928082858.3009191-1-guozh23@xiaopeng.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 3 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new length check in ebt_802_3_mt()
  (net/bridge/netfilter/ebt_802_3.c:32-34) negates the signed MAC offset…
- [High] The new comment in ebt_802_3_mt() (ebt_802_3.c:26-31) says
  skb_header_pointer() 'takes an offset relative to skb->data and cannot…
- [High] ebt_802_3_mt() sets par->hotdrop and also returns false.
- [Medium] ebt_802_3_mt() requires the full sizeof(struct ebt_802_3_hdr)
  (24 bytes from the MAC header) before looking at info->bitmask.
- [Low] The commit fixes a real read of skb data past skb_headlen() in
  ebt_802_3_mt(), but it explicitly leaves out the Fixes: tag because…

--

netfilter: ebtables: ebt_802_3: drop short frames before the match reads LLC

This commit adds a check to ebt_802_3_mt(). Before the LLC fields are read
through skb_mac_header(), it checks that sizeof(struct ebt_802_3_hdr) bytes
starting at the mac header are in the linear area. If they are not, the match
sets par->hotdrop and returns false.

> No Fixes tag. The unchecked skb_mac_header() dereference comes from the
> initial ebtables merge and has not been touched since.

[Severity: Low]
This isn't a bug, but bugs that predate git history are usually tagged in
netdev and netfilter with:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Could that be added so stable tooling and backporters can track this fix?

> diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
> index 68c2519bdc528..533f0d36e1716 100644
> --- a/net/bridge/netfilter/ebt_802_3.c
> +++ b/net/bridge/netfilter/ebt_802_3.c
> @@ -14,27 +14,43 @@

[ ... ]

>  static bool
>  ebt_802_3_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  {
>  	const struct ebt_802_3_info *info = par->matchinfo;
> -	const struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
> -	__be16 type = hdr->llc.ui.ctrl & IS_UI ? hdr->llc.ui.type : hdr->llc.ni.type;
> +	struct ebt_802_3_hdr _frame;
> +	const struct ebt_802_3_hdr *frame;
> +	int mac_offset = skb_mac_offset(skb);
> +	__be16 type;
> +
> +	/* skb->data sits past the Ethernet header when the match runs, so the
> +	 * frame starts before skb->data. skb_header_pointer() takes an offset
> +	 * relative to skb->data and cannot express that, so check the linear
> +	 * area against the mac header ourselves and use skb_mac_header()
> +	 * directly once the check has passed.
> +	 */

[Severity: High]
Is this comment accurate? skb_header_pointer() takes a signed int offset, and
__skb_header_pointer() handles a negative value:

include/linux/skbuff.h:__skb_header_pointer() {
	if (likely(hlen - offset >= len))
		return (void *)data + offset;

	if (!skb || unlikely(skb_copy_bits(skb, offset, buffer, len) < 0))
	...
}

With offset = skb_mac_offset(skb) = -14, the fast path returns the mac header
when skb_headlen() >= 10. Otherwise, skb_copy_bits() copies the linear bytes
that start before skb->data and then walks the frags.

nft_payload_eval() already relies on this:

	offset = skb_mac_header(skb) - skb->data;

The commit message says only ETH_HLEN bytes are guaranteed linear. A complete
frame whose LLC header sits in page frags would now be hotdropped instead of
matched.

Could this use the following, and return false on NULL the way ebt_stp_mt()
does?

	skb_header_pointer(skb, skb_mac_offset(skb), sizeof(_frame), &_frame)

That would also give _frame a real use. Right now it only appears in sizeof().

> +	if (mac_offset < 0)
> +		mac_offset = -mac_offset;
> +	if (mac_offset + sizeof(_frame) > skb_headlen(skb)) {

[Severity: High]
Does negating mac_offset make this check stricter than intended?
skb_mac_offset() and skb_headlen() are both measured from skb->data. On
NF_BR_PRE_ROUTING, NF_BR_FORWARD and bridge-device NF_BR_LOCAL_OUT, skb->data
is ETH_HLEN past the mac header, so mac_offset is -14.

The 24-byte header ends at mac_header + 24, so skb_headlen() >= 10 is enough
(-14 + 24). After the sign flip, the test becomes 14 + 24 > skb_headlen(skb),
which requires 38 linear bytes past skb->data.

Wouldn't that hotdrop every 802.3 frame with 10 to 37 bytes of linear
payload, even though the whole LLC header is present? Unpadded frames from
veth, tap or virtio guests would hit this.

The threshold also depends on the hook. br_send_bpdu() does:

	skb_reset_mac_header(skb);

	NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT,

On that path mac_offset is 0 and the frame threshold is 24 bytes. On ingress
and forward it works out to 52 bytes of frame. Doesn't this path also
contradict the comment's claim that skb->data always sits past the Ethernet
header?

[Severity: Medium]
Should the length required here depend on info->bitmask? A SAP-only rule
reads only llc.ui.dsap and llc.ui.ssap, at mac offsets 14 and 15. The ctrl
and type bytes are needed only for EBT_802_3_TYPE.

For example, br_send_tcn_bpdu() calls br_send_bpdu(p, buf, 4). That adds the
3-byte LLC UI header and the 14-byte Ethernet header, resets the mac header,
and enters NF_HOOK(NF_BR_LOCAL_OUT) with a 21-byte linear skb and mac_offset
0. The test 0 + 24 > 21 then sets par->hotdrop.

With an OUTPUT rule such as "-p Length --802_3-sap 0x42 -j ACCEPT", will the
bridge's own STP topology change notification BPDUs now be dropped? Before
this patch, dsap and ssap were read from valid bytes in that frame.

> +		/* The frame is too short to hold an LLC header. */
> +		par->hotdrop = true;
> +		return false;
> +	}

[Severity: High]
Is the packet actually dropped here under legacy ebtables? ebt_do_match()
returns !match(), so a false return stops EBT_MATCH_ITERATE. ebt_do_table()
then skips the hotdrop check:

net/bridge/netfilter/ebtables.c:ebt_do_table() {
	...
		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
			goto letscontinue;
		if (acpar.hotdrop) {
	...
}

acpar.hotdrop is set once per table walk and never cleared. If no later rule
fully matches, the chain policy decides:

	if (chaininfo->policy == EBT_ACCEPT) {
		read_unlock_bh(&table->lock);
		return NF_ACCEPT;

Take the default ACCEPT policy and a rule like "-p Length --802_3-sap 0x42
-j DROP". Before this patch, a short frame with SAP 0x42 was dropped, because
dsap and ssap were in linear data. Now it looks like it would be forwarded.
Can an untrusted guest on a veth or tap port use this to get past such a rule?

If a later, unrelated rule does fully match, it returns NF_DROP instead of
running its own target, and its counters and watchers are skipped.

ebtables-nft behaves differently, because __nft_match_eval() checks
xt.hotdrop before the match result:

	if (xt.hotdrop) {
		regs->verdict.code = NF_DROP;
		return;
	}

So the two front-ends now give different results. In the broute table,
ebt_broute() treats NF_DROP as "route instead of bridge", so the frame is not
discarded there either.

Would simply returning false, as ebt_stp_mt() does when skb_header_pointer()
fails, match what the commit message describes?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260928082858.3009191-1-guozh23%40xiaopeng.com
