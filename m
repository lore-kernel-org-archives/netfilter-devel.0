Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DC4397E86;
	Mon, 12 Oct 2026 03:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791776582; cv=none; b=lGEDgFLRTLctAW/113aLmbaaF7imBsa76HVcoircFh6wsnKK4MI9SYZGtR7SkgNPBjEc59oaphf59ZaiBHrVM1A/R8Kdw9ceLdaikOo9xb/D89CKDCbHbfywbxOoQVU6PgUxVhkFJ9bRXB01kOSMA5E7zTRel7qR096n/YVE2+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791776582; c=relaxed/simple;
	bh=1Yatm2bkBHGatM/f4l3ONLHfivAPAiPYQN+9EPPJA1s=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NKS3iCpTAH3aD7SinKTYEm/hpg9g5UJmfn92ZvAH8DVmQaZXi3JTSnjVs5QyocKC6PU8i9d/DBkIW1KltFQVu2mg+Ctn9VfslZe9k0M1n3cf8pYtmPFGr6MjMwUbIYuMJFeJgFZ3uNPppYjU73wLUtcu4BiXFQIbYtVcmUSEA1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V8b/NILj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V8b/NILj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FFB1F0089B;
	Mon, 12 Oct 2026 03:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791776580;
	bh=ZzxgQD2SMPs5sT/NYSKNh8vCxo0raIQzh0NGC3Qt3UE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=V8b/NILjBiWnmdKnaDCrezkGZzf1hhfCdc198Vj9fb7Ox+wbITMhcUjgEZrDNoYkY
	 pFb9bkU6vQ0byqjXdfeQIJEDCVXUaqp8B/SM2FBybuaiSZToK8AxbQZm0Gq8LrAuP0
	 oSNInbHQ4zvTGgvjjejFasUOXkT/BPRVS2uHUNbdd74rpv/FCi9pJF9cXvLO+JJcw2
	 w9IO8zlMW+Duv2UL/kQ/+ENbvYxvyCsMUvfDkBNRk3KwbgtuCrjTNwq6bXjQNuv7Oy
	 q/EDzBTbjD+S1O0H5iywVsvZuvS0hpIa92spTPg7oGxYB9LLcb2yy02Zu3LacBi5tP
	 ukiTv1SWzzSbA==
Subject: Re: [PATCH net v2] netfilter: ebtables: ebt_802_3: check the LLC
 fields before reading them
From: netdev-bot+sashiko@kernel.org
To: guozh23@xiaopeng.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, razor@blackwall.org,
 idosch@nvidia.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Mon, 12 Oct 2026 03:42:59 +0000
Message-ID: <179177657959.434549.13718920312504127960@kernel.org>
In-Reply-To: <20261008024539.4106699-1-guozh23@xiaopeng.com>
References: <20261008024539.4106699-1-guozh23@xiaopeng.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (2) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In ebt_802_3_mt() (net/bridge/netfilter/ebt_802_3.c), the
  patch makes every rule with EBT_802_3_TYPE require sizeof(struct…
- [Low] The new comment in ebt_802_3_mt()
  (net/bridge/netfilter/ebt_802_3.c, lines 27-30), and the matching…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but it is kept
  here because the concern requires validation.
- [Medium] This problem wasn't introduced by this patch, but it is kept
  here because the concern requires validation.

--

netfilter: ebtables: ebt_802_3: check the LLC fields before reading them

This patch changes ebt_802_3_mt() to read the LLC header with
skb_header_pointer() at the mac header offset instead of dereferencing
skb_mac_header() directly. Rules without SAP or TYPE constraints now return
early, and the fetch length depends on which fields the rule examines.
Frames too short for the requested fields now fail to match.

> diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
> index 68c2519bdc528..1a67376d146f8 100644
> --- a/net/bridge/netfilter/ebt_802_3.c
> +++ b/net/bridge/netfilter/ebt_802_3.c

[ ... ]

>  static bool
>  ebt_802_3_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  {
>  	const struct ebt_802_3_info *info = par->matchinfo;
> -	const struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
> -	__be16 type = hdr->llc.ui.ctrl & IS_UI ? hdr->llc.ui.type : hdr->llc.ni.type;
> +	struct ebt_802_3_hdr _frame;
> +	const struct ebt_802_3_hdr *frame;
> +	unsigned int hlen;
> +	__be16 type;
> +
> +	/* Without SAP or TYPE constraints the match only selects 802.3
> +	 * frames, which ebt_basic_match() has already decided from the
> +	 * ethertype/length field. Nothing in the LLC header is read.
> +	 */

[Severity: Low]
Is this comment accurate? The commit message makes the same claim:

  "a rule without any SAP or TYPE constraint selects frames by their
  802.3 length field alone, which ebt_basic_match() has already handled."

ebt_basic_match() only checks the 802.3 length when the entry has
EBT_802_3 set:

net/bridge/netfilter/ebtables.c:ebt_basic_match() {
    ...
	if (e->bitmask & EBT_802_3) {
		if (NF_INVF(e, EBT_IPROTO, eth_proto_is_802_3(ethproto)))
			return 1;
	} else if (!(e->bitmask & EBT_NOPROTO) &&
    ...
}

ebt_802_3_mt_check() only checks info->bitmask and info->invflags
against EBT_802_3_MASK. It never looks at the entry, so the kernel
accepts this match on a rule with any protocol. Only the ebtables
userspace tool enforces -p Length.

On the nft_compat bridge path, nft_match_set_mtchk_param() fills in only
ebt.ethproto and ebt.invflags. __nft_match_eval() then calls
match->match() directly and never runs ebt_basic_match().

The early return behaves the same as the old code. Could the comment be
reworded so it doesn't imply that SAP/TYPE rules only ever see 802.3/LLC
frames? As it stands, they can read Ethernet II payload bytes as
dsap/ssap/type.

> +	if (!(info->bitmask & (EBT_802_3_SAP | EBT_802_3_TYPE)))
> +		return true;
> +
> +	/* Only the dsap/ssap pair is examined for a SAP-only rule; the
> +	 * type field (and the control byte that selects between the ui
> +	 * and ni views of the union) is needed for a TYPE rule alone.
> +	 */
> +	hlen = sizeof(_frame);
> +	if (!(info->bitmask & EBT_802_3_TYPE))
> +		hlen = offsetof(struct ebt_802_3_hdr, llc.ui.ctrl);

[ ... ]

> +	frame = skb_header_pointer(skb, skb_mac_offset(skb), hlen, &_frame);
> +	if (!frame)
> +		return false;

[Severity: Medium]
Can this reject well-formed SNAP UI frames for TYPE rules?

For any rule with EBT_802_3_TYPE, hlen is sizeof(struct ebt_802_3_hdr),
which is 24 bytes. That size comes from the hdr_ni member. Its type field
sits at frame bytes 22..23, after a padding byte, which makes the union
10 bytes.

For a UI frame (ctrl & IS_UI), the TYPE branch only reads dsap, ssap and
ctrl (frame bytes 14..16) and llc.ui.type (frame bytes 20..21). That is
22 bytes in total.

Take a complete SNAP UI frame (dsap = ssap = 0xaa, ctrl = 0x03) that is
22 or 23 bytes long from the mac header. For that frame,
skb_header_pointer() returns NULL here, and the match returns false
whether or not the rule is inverted. Before the patch, every byte read
for such a frame was inside the frame.

Physical NICs pad frames to 60 bytes. Tap, veth and AF_PACKET senders on
a bridge port can still inject frames this short, and the bridge does not
pad them. A rule like "--802_3-type 0x0800 -j ACCEPT" no longer matches
these frames, and "--802_3-type ! X -j DROP" no longer drops them.

This also seems at odds with the commit message, which says the patch
will:

  "require only the bytes each rule actually examines"

Would it work to fetch up to and including ctrl first? The code could
then require offsetof(struct ebt_802_3_hdr, llc.ui.type) + 2 for UI, or
the end of the ni type for NI. A second skb_header_pointer() for just
the selected type field would also work.

>  
>  	if (info->bitmask & EBT_802_3_SAP) {

[ ... ]

>  	if (info->bitmask & EBT_802_3_TYPE) {
> -		if (!(hdr->llc.ui.dsap == CHECK_TYPE && hdr->llc.ui.ssap == CHECK_TYPE))
> +		type = frame->llc.ui.ctrl & IS_UI ? frame->llc.ui.type :
> +						    frame->llc.ni.type;

[Severity: Medium]
This isn't a bug introduced by this patch, but does this choose the
right view of the union for S-format and I-format frames?

frame->llc.ui.ctrl & IS_UI is true when either of the two low bits is
set. The uAPI header says the control field is one byte only when the
first byte is 0x03. That matches LLC_PDU_TYPE_IS_U() in
include/net/llc_pdu.h:

#define LLC_PDU_TYPE_IS_U(pdu) \
	(((pdu->ctrl_1 & LLC_PDU_TYPE_U_MASK) == LLC_PDU_TYPE_U) ? 1 : 0)

Control bytes 0x01 (S-format) and 0x02 (I-format) both have two-byte
control fields, but here they select the ui view. With
dsap = ssap = 0xaa, a TYPE rule then compares frame bytes 20..21 instead
of the ni type location. That can produce false matches or false
non-matches.

Should the test be (frame->llc.ui.ctrl & IS_UI) == IS_UI?

[Severity: Medium]
This is also a pre-existing issue, but does frame->llc.ni.type read the
SNAP type from the right offset?

struct hdr_ni in include/uapi/linux/netfilter_bridge/ebt_802_3.h is not
packed:

struct hdr_ni {
	__u8 dsap;
	__u8 ssap;
	__be16 ctrl;
	__u8  orig[3];
	__be16 type;
};

Natural alignment adds a padding byte after orig[3], so type ends up at
LLC offset 8 (frame bytes 22..23). On the wire, a header with a 2-byte
control field and a 3-byte OUI has the type at LLC offset 7 (frame bytes
21..22).

So whenever the ni view is picked, the comparison uses the second type
byte plus the next payload byte, not the real SNAP type. The same padding
is what makes sizeof(struct ebt_802_3_hdr) 24, which feeds into the hlen
question above.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008024539.4106699-1-guozh23%40xiaopeng.com
