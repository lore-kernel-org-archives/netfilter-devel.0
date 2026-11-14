Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622545;
	b=JBu0UboWi6Nu6XTZf4f244QToBnGyHrNNA+a2CZiqWmFAMPS/O2Ss24ODEuQ6ipKdrNB
	 fSPbW3IrlG4fVN9hkF3lPYPK/Lug3+iY4un90uP6zsIyIgjJKR94p3Nk9XgI8jojTUuRq
	 6GTmzrKsyM3k5HYbekOzU5MDKUZUhnNmzJBQ5rUjRjRN8NZq6ya+0iLoulFfcZNVDJ0HU
	 JaV8Bp5ECtTclY5fZRUvsvw9/QqvZWeN99V3TclD7qDaTiioVBoycD0FjO5RVf1bg9WQ3
	 jFsKTpyr039eZktI8JNITGSaHTcQEvg35hT5yps5Yfgno7QOgF+IrhPyg8sZPtduv8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622545;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=z4i/fmyOqndkSOxwHcN+Hq4btJ3lhkQBCoXbXJdFXD8=;
	b=GqANWuNNvcGsPLU1/5HkuJqlBBbu+z5n0heJWGAcOzunn/tD5bjNQrKt0Z8AiZpo72Gx
	 4uZE22cqBalsvZGVT9mgMgUK5p54XKgerEF4vJn631Jsixz3yT/RasmepPsgKa2V6edfD
	 2bDGy/5YauuP6pV+19RkS/DEYyxkr/8sJsVR1KL9yCpgCNsx9WbWDtVksM32lSK+BuAdf
	 vENd/ui+5/kPMmdXQsrg0nIkV41nujGTVyBv2E/qVshJJH7/x6HNnmpywbXRSDmL1U7DK
	 iBoOuqaF2vJciY5wY/ff6O9hSr7TWo1lxMuf0nQlmTYTuQrxJOO+53DUQWRigQoQjXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFlktzmA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96DC606A8A8;
	Sat, 14 Nov 2026 02:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFlktzmA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2971F000C4;
	Sat, 14 Nov 2026 02:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622545;
	bh=z4i/fmyOqndkSOxwHcN+Hq4btJ3lhkQBCoXbXJdFXD8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GFlktzmARnF8IIMt7e/TjUHjxOiRRPP2gcaNW9lPaSguum10pD7Tb4ZmhQeftrSdY
	 HSG2zzztSDPxJHS4hn42eqmIZnUeu7s1F6K1wsyhjuJfDTiTfDGrfINIST1Tq4p6tM
	 cz/jiy2agNCHpwcMaW1GqGh8bsB3rT9BZ7uAvS5TcoWhsovCAmYwaZv/CyKUPe1BkQ
	 Dj24UsvKq1oAYBiPrJS2NTIZORx05w2zW8cwWMc++4SBb+robReZEeIFprgAdT/GNd
	 /srKGaxPcYWM1E0I9KBXj8FQddptv6C36ofRkl0PDcmWv3Sl8nDyXqQu37RgkYTXjM
	 YWgRE5kDH5qNA==
Subject:
 Re: [PATCH net 08/15] ipvs: update flags and seqs in backup server under lock
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:44 +0000
Message-ID: <179462254476.2199510.10872735133163296509@kernel.org>
In-Reply-To: <20261113011447.2357709-9-pablo@netfilter.org>
References: <20261113011447.2357709-9-pablo@netfilter.org>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message overstates the old bug.

--

ipvs: update flags and seqs in backup server under lock

This patch extends the cp->lock critical section in ip_vs_proc_conn().
On the backup server, cp->flags, in_seq/out_seq, state, old_state and
timeout are now updated together. New connections also take cp->lock,
and ip_vs_try_bind_dest() is called after the lock is dropped.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-1-pablo%40netfilter.org

> Sashiko reports that we modify the conn flags and seq values in
> the backup server without holding cp->lock. The same is true for
> other fields such as state, old_state and timeout which are
> modified by protocols under lock.

[Severity: Low]
Is the first sentence accurate for cp->flags?

Before this patch, the existing-connection path in ip_vs_proc_conn()
already updated cp->flags under cp->lock:

net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
    ...
		spin_lock_bh(&cp->lock);
		...
		flags &= IP_VS_CONN_F_BACKUP_UPD_MASK;
		flags |= cp->flags & ~IP_VS_CONN_F_BACKUP_UPD_MASK;
		cp->flags = flags;
		spin_unlock_bh(&cp->lock);
		if (!dest)
			ip_vs_try_bind_dest(cp);
    ...
}

ip_vs_try_bind_dest() also takes cp->lock before ip_vs_bind_dest()
changes cp->flags.

The fields written without the lock were the seqs, state, old_state
and timeout, after spin_unlock_bh():

	if (opt) {
		cp->in_seq = opt->in_seq;
		cp->out_seq = opt->out_seq;
	}
	atomic_set(&cp->in_pkts, sysctl_sync_threshold(ipvs));
	cp->state = state;
	cp->old_state = cp->state;

So the IP_VS_CONN_F_SEQ_MASK bits were set under the lock, but the
in_seq/out_seq values they describe were written outside it. The
subject line and "update the fields atomically" describe this
correctly.

Could the first sentence say that flags and seqs were not updated
together under the lock, instead of saying the flags were modified
without it? The code change itself looks correct.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
