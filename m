Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793869410;
	b=fh6TSrKs3PO4cMDCknQjyRPj0LKTEYPjNWiCcVa8BvHBO5ButoVo1XIM3je+SnnkEXYK
	 UXjK2b81pwbblIlIHdq54TbLCPxGwoAy+FxIFsS5EFVL7G1vo1g4rvtoQot1p133fxiN5
	 pLiBhVRPbhnc5sXPD+s/0qGfx8FrCh/L2MQQ1d6UWHCP55nPhMaRr89CmvMTAFUGqZM2g
	 QYySw5k4SN5okTMHTciQIn5WvdkqITsbIvn9YsQtKdiVgaIhouZ8dzr9gOuyGdaILncRA
	 6BJSV1UXaJoLhq0BmMnEeDlOS9JvC8iS8EMIRmF3cMpqqKA8YBzVnXOMs814kqIPySg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793869410;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TRXlzlkbH1m9T6kN9Rtt9KXhOZxtIzD4QvUfCH3ejVA=;
	b=ne1aqw8LW1msb9Q1/BNARVPniTsFxVe+JJZiZp+dN7HRXgETp3X60ukmYhIi9fdQaG8b
	 pAy0AdB3HFepqMmez37N8r3LteQllmZgJjkoalC7yFKjAA7f/gizRdk1pYNHkDQRW5iC7
	 EH6fJt5+muVifdQckqK4Fo/9gXmi1J2WyNMIxwKIPD+Lr91jE1Z2lN+9OUPXCYhTu0cJQ
	 q1EtUTfA2501vm2aS5X9R1n0WLZhhXfMf7kP1hE/vxfKacAkB5vIKmYXew6D2WYK+ui0a
	 YbHjuTaLKvKeGrwM2TCUB7Xd4wHeNVLi4CdBXcqJnonjXnIi171prkQpyu2vuy4fLOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CMOBud2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A288606A333;
	Thu,  5 Nov 2026 09:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CMOBud2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BDF1F00919;
	Thu,  5 Nov 2026 09:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793869410;
	bh=TRXlzlkbH1m9T6kN9Rtt9KXhOZxtIzD4QvUfCH3ejVA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CMOBud2DttsLsbSlhfn6aTb2FDrnwsHhLhIKWy9WB3/gwDm3gswnqRPJGYpKf7QNo
	 BaKwWDUsxM9TVsz8fuoCQeehaCAhH8NQRSQ4+Ofk0f9qTdcsNm81Qru9K2CcQOyVuF
	 oKmLUZkftEXKj/nPVFWQJVFeT+uTBKI9MiGGlZl3V9SY0cltZPPh5AtogjrG4GZM0e
	 CkzYQOmDYeiPeBVf/MpEx7Halrggnii3CLdJDkX773jskIhmUOl/ghk9RA/kVmsoz+
	 RIS9tyfjzZ3tztVwEMYsGkx4pVfzS8yu+Te0NVm/D1/cBu7P4EkSzmCevPuqebjO0j
	 0StrcYqZzVsHA==
Subject: Re: [PATCH net 2/2] netfilter: h323: avoid secs-to-jiffies overflow
 in RAS timeout
From: netdev-bot+sashiko@kernel.org
To: l1138897701@163.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 kaber@trash.net, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Nov 2026 09:03:28 +0000
Message-ID: <179386940893.488856.3164971137869500824@kernel.org>
In-Reply-To: <20261104085925.773471-2-l1138897701@163.com>
References: <20261104085925.773471-2-l1138897701@163.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message names a symptom that the overflow cannot
  cause and that the patch does not fix.
- [Low] process_rcf() calls nf_ct_secs_to_jiffies().

--

netfilter: h323: avoid secs-to-jiffies overflow in RAS timeout

This patch replaces the two 32-bit "info->timeout * HZ" conversions in
process_rcf() with one call to nf_ct_secs_to_jiffies(). That helper
multiplies in 64 bits and saturates at INT_MAX. The result is used for
both the RAS conntrack refresh and the Q.931 expectation timeout.

> With the signed expiry test "(__s32)(ct->timeout - nfct_time_stamp)
> <= 0", a timeout of 2147484 seconds (24.9 days) at HZ=1000 is born
> expired, and 4294968 seconds wraps to 704 jiffies.  The RAS connection
> therefore drops mid-call, or the Q.931 expectation stays pinned for
> days after the peer is gone.

[Severity: Medium]
Is the second half of this accurate? Can the 32-bit wrap of
info->timeout * HZ ever make a lifetime longer than the one requested?

For X > INT_MAX / HZ, the old value X * HZ mod 2^32 ends up in one of two
places. If it is >= 2^31, it reads as already expired under
nf_ct_exp_is_expired():

    return (__s32)(READ_ONCE(exp->timeout) - nfct_time_stamp) <= 0;

If it is below 2^31, it is smaller than X * HZ. Either way the lifetime
is shorter than what the peer asked for, never longer.

After this patch, the timeToLive stored by process_rrq() or process_rcf()
still has no upper bound. The only limit is the INT_MAX jiffies
saturation in nf_ct_secs_to_jiffies(). That is about 24.8 days at HZ=1000
and about 248 days at HZ=100.

A peer could already reach that same maximum before this patch by
sending 2147483 seconds. So the longest lifetime a remote peer can force
on the RAS conntrack and the Q.931 expectation is the same before and
after the patch.

For oversized TTLs the change actually goes the other way. Values that
used to wrap to a short lifetime or come out already expired now get the
maximum lifetime. For example, 0xFFFFFFFF used to come out as s32 -1000
at HZ=1000.

Could the commit message drop the "pinned for days" symptom? It could
instead say directly that oversized TTLs now saturate to INT_MAX jiffies.

> diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
> index 4cb1665bba021..5e900037fa6f1 100644
> --- a/net/netfilter/nf_conntrack_h323_main.c
> +++ b/net/netfilter/nf_conntrack_h323_main.c
> @@ -1375,9 +1375,11 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
>  	}
>  
>  	if (info->timeout > 0) {
> +		u32 timeout = nf_ct_secs_to_jiffies(info->timeout);

[Severity: Low]
nf_ct_secs_to_jiffies() only exists because the previous patch in this
series, "netfilter: conntrack: avoid secs-to-jiffies overflow in SIP
helper", adds it to include/net/netfilter/nf_conntrack.h. That patch
carries a different Fixes: tag (0f32a40fc91a, where this one has
f587de0e2feb).

Will this still build if it is backported to stable without the SIP
patch? That could happen if the SIP patch does not apply cleanly to an
older tree.

The SIP patch is also tagged for stable and comes first in the series,
so stable tooling will usually pick up both. Still, would it help to
note the dependency on the Cc: stable line?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261104085925.773471-1-l1138897701%40163.com
