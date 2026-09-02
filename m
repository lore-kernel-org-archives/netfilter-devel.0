Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C40A1B6D08;
	Wed,  2 Sep 2026 04:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788323749; cv=none; b=VplNYFTOyoVwjUODVfyNenisCQxRoGOlbg5+kuOK7dAgaQbEdUkNzf2bnDsWeybtvmnhKOvx06zNDfEV40h76vSPFqfjiUT43EvvfD4cbz0t9N95iGbxSFU57ztaJe00JRrTUfFHfJf8YQykxoWxbYt18PG9/m8s3kCLdVSlizA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788323749; c=relaxed/simple;
	bh=0Qdzli+qJp3FOabq/THj8Atm7xH7luM+jagflvB2Src=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fLK3E5hV1wInNh5Rbe0fVwLaIDMQd8A0wBDciSf3LaN8VQgc3bRHlo/E9pgxNWtJeObS2GhCYU/KGrA3NSLod4iTyQkpTvWXAYuAc7k8VquCqyR71z1hu4X4VwGOJK2lQAhUBXm4k3FIm04EkjULaeUbUdooAzj43TfnlFNiG+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esLXqLgv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esLXqLgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08221F000E9;
	Wed,  2 Sep 2026 04:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788323747;
	bh=3+aNzt7+vR8uvvRPwWe1grwPlvO+Ou8ltA+L0ejnOWs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=esLXqLgvcPxUITP7luIajV9bgLZ5yzoX2XFHM6+gDi/B7h1L3BB5D7dNqDbaeIJ5C
	 rtmBdRFErxZa78OPVY/dTrbs3ydZ/I/My3uunWpQWBS6Zf/ftpIFivOEu4KLWoCI3m
	 O3+bJnvsm6L1b40xfBQzp8HpF4bM8Z5GL9+9NNzyC8h0ysUSKqXj+nds+hwphEaZrB
	 TwV0BOOFIM0xLZT216bnhgSVBeA9i/GwMDNTQ7T0cvdqDGvfehCJsJCBNMNsilhwLa
	 yI5THRjiwy4FuFqBJ5c9d4kMgHv9+mD98YWr9WXbDck0V/0UX0VkvsTfZ0XrygUrVT
	 pEYOx+rOKJ1iw==
Subject: Re: [RESEND,nf-next] netfilter: nf_conntrack_h323: fix double cursor
 advance in decode_int()
From: netdev-bot+sashiko@kernel.org
To: l1138897701@163.com
Cc: pablo@netfilter.org, fw@strlen.de, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, phil@nwl.cc,
 horms@kernel.org, zhaojignmin@hotmail.com, kaber@trash.net,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Sep 2026 04:35:46 +0000
Message-ID: <178832374645.3394541.7615305682823291426@kernel.org>
In-Reply-To: <20260831013315.95231-1-l1138897701@163.com>
References: <20260831013315.95231-1-l1138897701@163.com>
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
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 1

- [Medium] Commit message mischaracterizes the impact of the fixed double
  cursor advance in decode_int().
- [Low] The patch is a user-visible bug fix to
  net/netfilter/nf_conntrack_h323_asn1.c but carries no `Fixes:` tag, so…

Pre-existing issues:
- [Medium] The RAS timeToLive value decoded by the CONS/DECODE branch is
  fully remote-controlled (nf_conntrack_h323_types.c:1594/1646 define it…

--

netfilter: nf_conntrack_h323: fix double cursor advance in decode_int()

In the CONS case of decode_int(), get_uint() already advances the bitstream
cursor, so the following unconditional bs->cur += len consumed the value
bytes twice.  The patch moves the manual advance into an else branch so the
bytes are consumed exactly once.  The code change itself looks correct.

A few questions about the changelog and about one pre-existing item in this
area.

>     All fields following such an integer are decoded from a wrong bit
>     position.  This affects the timeToLive field in RAS
>     RegistrationRequest/RegistrationConfirm messages: subsequent fields
>     (e.g. transport addresses) end up being parsed from arbitrary offsets
>     inside the message, so the helper may create expectations based on
>     bogus addresses/ports.

[Severity: Medium]
Is this description of the impact accurate?

The only fields that reach the CONS plus DECODE branch are the two
timeToLive entries in _RegistrationRequest and _RegistrationConfirm in
nf_conntrack_h323_types.c.  Every other CONS integer is SKIP or STOP and
takes the (unchanged) manual advance path.

In both tables timeToLive is an extension component, so decode_seq() wraps
it as an open type and resets the cursor after the decoder returns:

net/netfilter/nf_conntrack_h323_asn1.c:decode_seq() {
	...
	beg = bs->cur;
	if ((err = (Decoders[son->type]) (bs, son, base, level + 1)) < H323_ERROR_NONE)
		return err;
	bs->cur = beg + len;
	bs->bit = 0;
	...
}

Doesn't that discard the over-advanced cursor, so parsing resumes at the
correct offset?

Also, the entry immediately following timeToLive in both tables carries
STOP:

net/netfilter/nf_conntrack_h323_types.c:_RegistrationRequest[] = {
	{FNAME("timeToLive") INT, CONS, 1, 0, DECODE | OPT,
	 offsetof(RegistrationRequest, timeToLive), NULL},
	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},

decode_seq() returns H323_ERROR_STOP at the STOP son, so no later field is
decoded at all.  The DECODE'd transport addresses (callSignalAddress,
rasAddress) are root components parsed before timeToLive.  Can a bogus
address or port expectation actually be produced by this bug?

The one effect that does escape decode_int() looks like the trailing
boundary check:

	if (nf_h323_error_boundary(bs, 0, 0))
		return H323_ERROR_BOUND;

When fewer than len bytes follow the timeToLive value, the doubled advance
pushes bs->cur past bs->end and DecodeRasMessage() fails, so ras_help()
takes the accept path and skips the whole RRQ/RCF:

net/netfilter/nf_conntrack_h323_main.c:ras_help() {
	ret = DecodeRasMessage(data, datalen, &ras);
	if (ret < 0) {
		pr_debug("nf_ct_ras: decoding error: %s\n", ...);
		goto accept;
	}

That means no TTL based nf_ct_refresh() and no Q.931 expectation timeout
update for that message.  Could the changelog be reworded to describe this
spurious out-of-bound decode failure instead of the bogus address/port
expectation scenario?  As written it reads like a security relevant misparse
and may drive an urgent stable backport on the wrong grounds.

>     Assisted-by: LLM
>     Signed-off-by: Qing Luo <luoqing@kylinos.cn>

[Severity: Low]
Should this carry a Fixes: tag?

git blame at the baseline shows the unconditional bs->cur += len and the
surrounding CONS case in decode_int() came in with 5e35941d9901
("[NETFILTER]: Add H.323 conntrack/NAT helper"), so the defect has been
there since decode_int() was added.  Since decode_int() is reachable
remotely through DecodeRasMessage() from ras_help(), stable tooling would
need the tag to pick the affected trees:

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")

> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 6830c9da3507..a51275cc4d0f 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -336,8 +336,9 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
>  			unsigned int v = get_uint(bs, len) + f->lb;
>  			PRINT(" = %u", v);
>  			*((unsigned int *)(base + f->offset)) = v;

[Severity: Medium]
This isn't a bug introduced by this patch, but while looking at the value
produced here: is the decoded timeToLive bounded anywhere?

nf_conntrack_h323_types.c declares it as {INT, CONS, 1, 0, DECODE | OPT} in
both _RegistrationRequest and _RegistrationConfirm, and get_uint(bs, len)
with len up to 4 covers the whole u32 range, so v is fully remote
controlled.

process_rrq() and process_rcf() then copy it straight into info->timeout
with no upper limit, unlike the default_rrq_ttl module parameter path:

net/netfilter/nf_conntrack_h323_main.c:process_rcf() {
	if (rcf->options & eRegistrationConfirm_timeToLive) {
		pr_debug("nf_ct_ras: RCF TTL = %u seconds\n", rcf->timeToLive);
		info->timeout = rcf->timeToLive;
	}

	if (info->timeout > 0) {
		nf_ct_refresh(ct, info->timeout * HZ);
		...
			WRITE_ONCE(exp->timeout,
				   nfct_time_stamp + (info->timeout * HZ));

Does info->timeout * HZ wrap in u32 arithmetic here, and can a peer keep the
RAS conntrack entry and its Q.931 expectation alive for an arbitrarily long
time, or wrap the product down to a near-zero timeout?

__nf_ct_refresh_acct() in nf_conntrack_core.c applies no upper clamp on
extra_jiffies:

	if (nf_ct_is_confirmed(ct))
		extra_jiffies += nfct_time_stamp;

	if (READ_ONCE(ct->timeout) != extra_jiffies)
		WRITE_ONCE(ct->timeout, extra_jiffies);

so the helper looks like the only place a bound could be applied.  Note this
predates the patch: before the change the correct TTL bytes were still read
and decode_seq() reset the cursor, so the value already reached
process_rrq()/process_rcf() whenever bytes followed the TTL field.

>  		}
> -		bs->cur += len;
>  		break;
>  	case UNCO:
>  		BYTE_ALIGN(bs);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260831013315.95231-1-l1138897701%40163.com
