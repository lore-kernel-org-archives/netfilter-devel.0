Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622542;
	b=jwlmfa3C+BrT7qFjZlbjnIKiEznxSiRnPigTFIiwTdqtH48X/IhnIttpp0M6UiSgH6zU
	 5cNV9ofKLLtXtifpLfhrMyyywjdYc15vW0K1HfZFjnGlr9Nr2LcG+Y9Gq0jk1vmDKfQQC
	 2V7c5K9VA9lxCgWs7TxGd+v/vgwouYxwAUyvpd5pcahIk8QRMTK2JniMGlt6rp1Ie/3EG
	 v2AzWBxFPBKwh/6E2oC2k/OOqAQOvnOyqYkDl/69JBSe2JQYcnrVWAmUrku3q5jlbTCra
	 2iJhl0oQ3B5pqBQdEXW/YS9ehW1UMTKs2c7rdA6KPULzyguDjhjNGwRwRuZJpJNQGoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622542;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=0QVVJaI//1zE2AiZWpjkhe1vPP+g8HZO/j+NbsfH7u4=;
	b=I5rRoxphxKjF7G53iehvshGvPH9QTIMZda6ONCrgDfB6Eu9Eer3uVFH2hJ9oostv5PJw
	 4ksuoubcThc5H+jfBbgQAxqIBlXPQyzJ3APK9UZKHVgjXfsIxJ2Zr5Xoqp9lA88QFLch0
	 R4xBw8M4L4RGPJsqX9J6FABagLGPvtHE3nVz62U5gaoXRk6vrvUwnZFl1CGbJ59WeRWN8
	 9Wdpv2YYxorIOYXFzlWO84avLn1iw0jbzRv2T4gL1Fod76hE4Zt6yW6Lzag/0fmdNzTaZ
	 sc1zaAk/WsYciqxO+8sjH/f5vyv6FXn+5F5VnaUV7ZLwUqRKAJkE/nfRDGz/idNBfUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="dCJHu4/Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFDF606A883;
	Sat, 14 Nov 2026 02:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dCJHu4/Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CA51F000C4;
	Sat, 14 Nov 2026 02:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622542;
	bh=0QVVJaI//1zE2AiZWpjkhe1vPP+g8HZO/j+NbsfH7u4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dCJHu4/Z5W7DwcPNxjbcywzwIFsWDOE/3ZB5ct8DuCDV3UyZEyjcv/bHl0w3a7QMK
	 cKTFTCkUqmE3VohVo41FNzfCioPr0APZXy39YSyj+il8g/mIBzd+mf/xyc26XBXb4T
	 khk0OB2uiedsMFGMpkuVgCRLtVDHA8QaiucFxS8BhKRvXkrL09pUvICfsgj1rsBWBk
	 tf1OAc367pRKllY4jcocDXKszKjwXHWrXmyTNYt5Zu1YB5lmLKPwqNfQB+X4cVix7w
	 H5FLB4g24a6VE5L2UzkCoTrw1wCHaXlpgcSLZPKV5KrZYCGjKRJrMag3lQvQywQEVC
	 cRaQ2xrY0Jssw==
Subject: Re: [PATCH net 04/15] ipvs: avoid stack overflow from recursive
 connection expiration
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:41 +0000
Message-ID: <179462254139.2199510.10412248743488371357@kernel.org>
In-Reply-To: <20261113011447.2357709-5-pablo@netfilter.org>
References: <20261113011447.2357709-5-pablo@netfilter.org>
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

- [Low] The commit message says the recursive chain walk exhausts the
  kernel stack "during namespace cleanup".

--

ipvs: avoid stack overflow from recursive connection expiration

This commit replaces the recursive controller expiration in
ip_vs_conn_expire() with an iterative walk. It no longer calls
ip_vs_conn_del() on the controller. Instead, the new
ip_vs_conn_del_reference() helper steals the controller's timer
reference, and the function loops back with cp = ct inside a single
rcu_read_lock() section.

> When a controlled IPVS connection expires, its controller may be expired
> synchronously if it has no remaining controlled connections. A chain of
> controlled connections can then recurse through ip_vs_conn_expire() and
> exhaust the kernel stack during namespace cleanup.

[Severity: Low]
This isn't a bug, but is "during namespace cleanup" the only place the
recursion can happen?

ip_vs_conn_del_reference() is the only code that sets cp->timeout = 0,
which arms the drop-controller chain. It is reached from runtime callers
as well as from the netns flush.

ip_vs_random_dropentry() runs from defense_work when drop_entry defense
is active:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_random_dropentry() {
    ...
drop:
			IP_VS_DBG(4, "drop connection\n");
			ip_vs_conn_del(cp);
    ...
}

ip_vs_expire_nodest_conn_flush() runs when a real server becomes
unavailable and expire_nodest_conn is set:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_expire_nodest_conn_flush() {
    ...
			ip_vs_conn_del(cp);
			if (cp_c && !atomic_read(&cp_c->n_control)) {
				IP_VS_DBG(4, "del controlling connection\n");
				ip_vs_conn_del(cp_c);
			}
    ...
}

The chain can also run from the timer softirq. If ip_vs_conn_unlink()
fails because refcnt > 1, the expire_later path keeps timeout == 0 when
n_control == 0:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_expire() {
    ...
  expire_later:
    ...
	if (cp->timeout || atomic_read(&cp->n_control))
		cp->timeout = 60 * HZ;
    ...
	__ip_vs_conn_put_timer(cp);
}

The timer is then re-armed at jiffies + 0. The next callback walks the
controller chain, and before this patch that walk recursed on the
softirq stack.

The loop in ip_vs_conn_expire() covers all of these entry points, so the
code change itself looks fine. Could the commit message also mention the
runtime paths, since stable and CVE triage will rely on the stated
impact?

The commit message also doesn't explain how a deep chain is built. The
ip_vs_conn_expire_now() comment still says chains are at most
DATA->CTL->TPL. Both points are handled by the follow-up patch in the
series, "ipvs: reject FTP control ports as data ports". It rejects
control ports as FTP data ports in ip_vs_ftp_out() and ip_vs_ftp_in(),
which bounds the chain again.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
