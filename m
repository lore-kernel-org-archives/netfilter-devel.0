Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050BA491589;
	Sat, 10 Oct 2026 13:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639005; cv=none; b=McKZzPGHAodcMT549b2Tc9IfvT2ef0pQCeFeePhi5RkpL0O2QPLe2zJ4UgIDfGhjXGFAuffJuMYPexv31mwWRFuoxK1hHTxfPri9VtYBESwFjCACn4RlUg2Y8Mtss0LF9j0Dzf+QdOPN38O7/OWbcHc5ZkUVfVsjO+IhV2GEaHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639005; c=relaxed/simple;
	bh=JOeA7/Juj3GWj37EAgYk4cNWxQojpqCiVvPNTmn+bKg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rxnuAUx3lBY9r7HRuwcMwlxU36tCo/gwHwcs2aWDAYyxtXbIw6f8ihak2vYfxrocFlbWuvhyPCfCZtJAiPIJFj9o3E0f1LFGa7pQJ9i9Qq5UxMD78J5tKg39FlciJbIjJd5wB8x1HzEQNXtVvZeROY7sz0lBMDtpcbJ5Hj0xm7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jg0/s4ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jg0/s4ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928401F00899;
	Sat, 10 Oct 2026 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791639003;
	bh=SBp86mc+EtnQ2CbOzJDZ2KvI0MDHcbGBhqu1BEBEx80=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Jg0/s4ckdQnf73hhIcxDscUUgS37DeDrvLjKjxgMwOC9YkWxLO78eCAPTTn3M5/dq
	 UA04vfwIiNTQyOtj19VrcQudRzYg5VxZRsBjWSyJEfx7MusbCtuDQ9vx3SjN1lIo+P
	 STQTqrunvsOgcBCPix+gCa9xLABh247z2+cPTB+JG3AhNsRI2xNW2ATPueBNJ9WRNn
	 5SOnmJUZm9QFXEVLjudz/bo3v15RPDK2B5UzM2vFjGNb/gQQslYKeDOFB6p4AHUEb1
	 shpGKCkCJIbAk9fmgn76DfmKxO5DF/XAXwKk9B7eRR8mm3UlyzUdtahjv8Uw0xCVCy
	 hhAw+5qaDyaWw==
Subject: Re: [PATCH] netfilter: nf_conntrack_h323: fix NULL pointer deref in
 decode_seqof()
From: netdev-bot+sashiko@kernel.org
To: bsdhenrymartin@gmail.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sat, 10 Oct 2026 13:30:01 +0000
Message-ID: <179163900178.434549.6423959143642919606@kernel.org>
In-Reply-To: <20261009124116.3950469-1-bsdhenrymartin@gmail.com>
References: <20261009124116.3950469-1-bsdhenrymartin@gmail.com>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message says decode_seqof() can be made to
  dereference NULL through the eight *_Caps.supportedPrefixes rows (and…
- [Low] The new comment in decode_seqof() is wrong in three ways.

--

netfilter: nf_conntrack_h323: fix NULL pointer deref in decode_seqof()

This patch adds a NULL check on f->fields in decode_seqof(). When the
pointer is NULL it returns H323_ERROR_BOUND. The commit message says an
attacker can use the eight *_Caps.supportedPrefixes rows to trigger a NULL
pointer dereference there.

> The eight supportedPrefixes table entries (_H310Caps, _H320Caps,
> _H321Caps, _H322Caps, _H323Caps, _H324Caps, _VoiceCaps and
> _T120OnlyCaps, all reached through the _SupportedProtocols CHOICE)
> are declared SEQOF,SEMI with fields=NULL.  decode_seqof()
> dereferences f->fields on the first loop iteration whenever the
> attacker-controlled SEMI count is non-zero, causing a NULL pointer
> dereference.

[ ... ]

> Cc: stable@vger.kernel.org
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

[Severity: Medium]
Can decode_seqof() actually be reached for these rows?

The parent entries in _SupportedProtocols in nf_conntrack_h323_types.c
are:

	{FNAME("h310") SEQ, 1, 1, 3, SKIP | EXT, 0, _H310Caps},
	...
	{FNAME("t120-only") SEQ, 1, 1, 3, SKIP | EXT, 0, _T120OnlyCaps},

With lb=1, nonStandardData is the only root component of _H310Caps.
dataRatesSupported and supportedPrefixes are both extension additions.

The parent is SKIP without DECODE, so decode_seq() sets base to NULL when
it starts:

	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;

In the extension loop of decode_seq(), each present extension reads its
open type length. It then reaches this check before Decoders[son->type]
is called:

	if (!base || !(son->attr & DECODE)) {
		...
		bs->cur += len;
		continue;
	}

The supportedPrefixes row is also plain SKIP:

	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},

So it looks like Decoders[SEQOF] is never called for any of the eight
rows.

The other SEQOF rows in nf_conntrack_h323_types.c that have NULL fields
seem to fall into two groups:

  - STOP rows. decode_seq() returns H323_ERROR_STOP for these before any
    decoder runs.
  - SKIP rows in an extension position. These are skipped by length.

Some examples are Setup_UUIE, Connect_UUIE,
EndpointType.supportedTunnelledProtocols, RRQ.alternateEndpoints and
RCF.alternateGatekeeper.

If none of these rows can reach decode_seqof(), the new check is dead
code. Could this be resent as hardening, without the Cc: stable tag, the
Fixes: tag and the claim of an attacker-reachable NULL dereference?

> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 6830c9da3507c..4d66db5bf5f70 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -692,6 +692,13 @@ static int decode_seqof(struct bitstr *bs, const struct field_t *f,
>  
>  	/* Decode nested field */
>  	son = f->fields;
> +	/*
> +	 * Malformed table entries may carry a NULL fields pointer (e.g.
> +	 * the *_Caps.supportedPrefixes SEQOF,SEMI rows); treat them as
> +	 * undecodable instead of dereferencing NULL when count > 0.
> +	 */
> +	if (!son)
> +		return H323_ERROR_BOUND;

[Severity: Low]
Is this comment accurate? A few parts of it don't seem to match the code.

The comment calls the *_Caps.supportedPrefixes rows malformed and uses
them as an example of rows that reach decode_seqof(). As noted above,
decode_seq() skips them by length. A NULL fields pointer on SKIP and STOP
rows also looks like the normal convention in nf_conntrack_h323_types.c.
Many rows use it.

The comment says the problem only occurs "when count > 0". The check
runs after count has been decoded, though, and it returns an error for
every count, including 0. Before this patch, count == 0 with a NULL base
succeeded.

Elsewhere in this file, H323_ERROR_BOUND means the bitstream would run
past the end of the buffer. Would a different error code fit a missing
table descriptor better?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261009124116.3950469-1-bsdhenrymartin%40gmail.com
