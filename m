Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A61469843;
	Wed, 29 Jul 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785345327; cv=none; b=Tk8Oiv8WTBr2VP/72fPCnBmIycZYhcSj9c2GgxlkwwfgTeKTPjb/iV38Kss2b5X53+z8R0FG2qpgWUlnmE6JynHb2u8QXApP7y4q/Uic/02zXG2IJz/KmVVA2nzeoSqdqnwme1C7R0RgWsMee5P3VJ+MsxqrF9yL3ctvSi3tFNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785345327; c=relaxed/simple;
	bh=t5ooRcfHUdLi9G21R8PdCvsGLvVS0QD7EEIshBBPEQw=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=RKUPDk0XJiuKgu21E+zb/LHEMrfCb2J54+Nrz+suL4av3EMtV0HOFB6WW9bb+AxD0UT/qfbbsTTlV1TSjEq4UY7SMLGpjx2xDKm9OjIqKlqEjtuHzEe4WwiOc4AFhXxWmk/2PZhcEch907ykmKJ6QfhhdVjD9ZnJ//LSGiUGP3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ckQSmcH1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ckQSmcH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471F01F000E9;
	Wed, 29 Jul 2026 17:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785345321;
	bh=+QDv5/wVzojUhGQYTJE+yfEj5KWus6alEp8smYHQei0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ckQSmcH1R8asLxbXEOkMsyqMIxwjt8uYvJ8/zfWc1MZ9kL4ZCl4qkgHyLxOn6i/+r
	 bdTUb2Iilqo3lydop5xb0tJLXM+W4Gw4GfvDcWZWlDn2I8Y9+R49HaAUu/wRLoL3BL
	 q5R5BZPBCizn/HOFFB5v3F4vrpYDq0gk7o41BuN/u8pGgXmpCoBbUiatTRsUTrMHp5
	 nsUlXQIcvsq+AKYfp7LRC+xgCBe3CFFFg9kArQ8Tn5tFdS1VUO+e43fvXEFjhPAFFG
	 hPvwnoF6Ykas7mVAv0D5ao0IpzQbrteRhhUCD80d5xzboO2i2cBtgV98FsbymzzAby
	 EW9GfygOEZ66w==
Content-Type: multipart/mixed; boundary="===============7042278233661880358=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <7aa8b7f7d16fe678e8a66ad5c9888ccee70dd07bd6c40e6a4f456592d33b01ce@mail.kernel.org>
In-Reply-To: <20260729163141.213611-1-nicoyip.dev@gmail.com>
References: <20260729163141.213611-1-nicoyip.dev@gmail.com>
Subject: Re: [PATCH bpf] bpf: Fix netns reference imbalance in conntrack kfuncs
From: bot+bpf-ci@kernel.org
To: nicoyip.dev@gmail.com,pablo@netfilter.org,fw@strlen.de,phil@nwl.cc,davem@davemloft.net,edumazet@google.com,kuba@kernel.org,pabeni@redhat.com,horms@kernel.org,ast@kernel.org,daniel@iogearbox.net,hawk@kernel.org,john.fastabend@gmail.com,sdf@fomichev.me,memxor@gmail.com,lorenzo@kernel.org
Cc: netfilter-devel@vger.kernel.org,coreteam@netfilter.org,netdev@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,nicoyip.dev@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 29 Jul 2026 17:15:20 +0000 (UTC)

--===============7042278233661880358==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> The kernel reported:
>
>   Oops: general protection fault, probably for non-canonical address
>   KASAN: null-ptr-deref in range [0x00000000000000e8-0x00000000000000ef]
>   RIP: 0010:bpf_prog_test_run_xdp+0x52c/0x1700
>   Call Trace:
>    __sys_bpf+0x1662/0x50c0
>    __x64_sys_bpf+0x73/0xb0
>    do_syscall_64+0xf9/0x540
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   Kernel panic - not syncing: Fatal exception

This isn't a bug, but could the crash trace be clearer about its
connection to the fix? The trace shows only BPF test-run frames
with no netfilter or conntrack function names visible.

The chain is reconstructible - the extra put_net() frees the
caller's netns, loopback_dev becomes NULL, and bpf_prog_test_run_xdp()
then dereferences it - but a reader has to derive this themselves.

Would it help to add a sentence connecting the trace to the fix, or
include a Reported-by: or Closes: tag for the original report?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/30472145413
--===============7042278233661880358==--
