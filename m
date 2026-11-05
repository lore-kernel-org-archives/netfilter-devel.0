Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793869409;
	b=Xvvl8PA90+dFRuL4HRLJg5pFTO0HB8bKv343UM3AXfgEutNxudYNXy/h+oTrFqrGNChI
	 45hpnYzkyGwOkzEbjnMSrZHIhGdL35dqcZfyHNvcGB3M+RwJW/8YS+lwpRk4AHKkejY62
	 dKEhVkpT3mO5K+mNShpwd0YHG6XTO1VlBnlm8Sln51qHKQtEeU582ciQhBukGt82xcMIW
	 p+2uMm3pq1EKDm4F1N/HHMu3kN3x5QVSnHCHKbm/tML/Y0Tbs32dttEZMhySthGh/IAkd
	 hPdoXG8GK9j1rT6d7Vac10eKhNiaz04/BsO1wgmEK9rSYw/l7SSw4z/stbdnbv2yVIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793869409;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=yfdFy6IF2ZSTW4IIgQ/Zl1ryhrMMJ5q0oMnV5GTJ8pg=;
	b=JHUkeH245WDBhtfXAjhp9X+k3LYJivuevMDmJ9fB8+A8Jdu9RzemnPnFpWnNzo+7kQbZ
	 WQ4f4JBFir98jMH751Yo3Yj51GV6tZvQPjGdzLGUc5ppHVWfMjisS0lxm5ypaoKO5H/73
	 rxMVKOanYqbX1uB5bdyyQDlZkjlO/+HM+oN99ALjcaGDyV6MnAPiAR1DpgMbdL+euvV+X
	 Uv7kTQ8FaxTwGizC/NehVSCsDBtKChbLX1MZXxXZT5GtXXcCr2TR61z5GG/NFWMU3ucuU
	 EJVsKtFIkg8r1ugMRs5ejGtZVED/uVYTshRDHsJ5mUEZYQDyIUFCULS+R6eOaoVcGmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h8X8xzSs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA69606A329;
	Thu,  5 Nov 2026 09:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h8X8xzSs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB4F1F000C1;
	Thu,  5 Nov 2026 09:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793869408;
	bh=yfdFy6IF2ZSTW4IIgQ/Zl1ryhrMMJ5q0oMnV5GTJ8pg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=h8X8xzSsec0nZmGFDQmrUejk1RMXcM/uSRaPyyMLZ+PIrzh6njwvifB5mc6mRR0dp
	 vxcHWIhbChOL2t75lKfhbHkZk1ZRnRwyOufztnCBXfiV4Ertlg9livn6sD7C9Q6Lvc
	 ykf0Y6CCKMHJggNapid6VzKHZeGZGvuWClFAnrTFS6eLgGGDn1jVEFsp3h/W4dafHx
	 mYxzKeDPJ/Ew4mYA8K9omHSHg7vcJLj5wlfb52AK/OyM6uWjdmZoooDFWzIipAogfo
	 aj2eaXdxwzAU3baC43QpcjZBvs6uwljskQPaQ0IZnasyGdeCD2sVfYTfsrj5ncDph7
	 ZgoxhwHyBPEFg==
Subject: Re: [PATCH net 1/2] netfilter: conntrack: avoid secs-to-jiffies
 overflow in SIP helper
From: netdev-bot+sashiko@kernel.org
To: l1138897701@163.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 kaber@trash.net, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Nov 2026 09:03:27 +0000
Message-ID: <179386940745.488856.2949210034419775650@kernel.org>
In-Reply-To: <20261104085925.773471-1-l1138897701@163.com>
References: <20261104085925.773471-1-l1138897701@163.com>
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

- [Low] The Fixes: tag gives the wrong origin for the failure the commit
  message mainly describes, which matters for backporting.
- [Low] This is a bug fix under net/, which MAINTAINERS 'NETWORKING
  [GENERAL]' covers with 'P: Documentation/process/maintainer-…

--

netfilter: conntrack: avoid secs-to-jiffies overflow in SIP helper

This adds nf_ct_secs_to_jiffies(), which multiplies in u64 and saturates
at INT_MAX. refresh_signalling_expectation() now uses it, so a large
expiry in a SIP REGISTER 2xx response can no longer wrap the u32
exp->timeout or make the expectation read as already expired.

> Expectations are reaped with "(__s32)(exp->timeout - nfct_time_stamp)
> <= 0".  At HZ=1000 an expiry of 2147484 seconds (24.9 days) crosses
> 2^31 and the expectation is born expired, while 4294968 seconds wraps
> to 704 jiffies.  Registration refreshes break, or a signalling
> expectation stays pinned for days.

[ ... ]

> Fixes: 0f32a40fc91a ("[NETFILTER]: nf_conntrack_sip: create signalling expectations")
> Cc: stable@vger.kernel.org

[Severity: Low]
Should this also have a Fixes: tag for b8b09dc2bf35 ("netfilter:
nf_conntrack_expect: use conntrack GC to reap expectations")?

The commit message quotes a signed expiry test. That test is in
nf_ct_exp_is_expired():

    return (__s32)(READ_ONCE(exp->timeout) - nfct_time_stamp) <= 0;

b8b09dc2bf35 added that test. It also made exp->timeout a u32 and added
the line this patch changes in refresh_signalling_expectation():

    WRITE_ONCE(exp->timeout, nfct_time_stamp + (expires * HZ));

0f32a40fc91a used a timer instead:

    exp->timeout.expires = jiffies + expires * HZ;
    add_timer(&exp->timeout);

Later trees changed this to mod_timer_pending(), but still added
jiffies + expires * HZ.

Trees from before b8b09dc2bf35 only have the 2^32 wrap (4294968 seconds
turning into 704 jiffies). On 64-bit, a product between 2^31 and 2^32 is a
positive unsigned long delta, and the timer wheel clamps it. So the
24.9 day "born expired" case does not seem to exist in those trees.

Those older trees also do not have the WRITE_ONCE(exp->timeout, ...)
context, so the stable backport will not apply cleanly there.

Could the tags or the message say which failure mode applies to which
trees?

The h323 patch in this series ("netfilter: h323: avoid secs-to-jiffies
overflow in RAS timeout") has the same pattern. It cites only
f587de0e2feb, but it relies on the same signed expiry test.

> Sweeping all 2^32-1 inputs at HZ=1000, the helper never wraps, never
> yields a value that reads as expired, and matches the old expression
> up to INT_MAX / HZ.

[Severity: Low]
Could the commit message say how this issue was found, and how the fix
was tested beyond the arithmetic sweep of nf_ct_secs_to_jiffies()?

net/netfilter/ is covered by the NETWORKING [GENERAL] entry, which points
to Documentation/process/maintainer-netdev.rst. Its bug fixes section
says:

    All bug fixes must state how the issue was discovered and validated,
    and how the fix was tested.

It also asks whether the fix was tested against the reproducer and the
kernel selftests.

The message says "Registration refreshes break, or a signalling
expectation stays pinned for days". It does not say whether this was
seen with real REGISTER 2xx traffic through the SIP helper, or found by
reading the code. There is also no Reported-by: tag.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261104085925.773471-1-l1138897701%40163.com
