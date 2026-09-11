Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58212EFDA4;
	Fri, 11 Sep 2026 00:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789087611; cv=none; b=KBVBy4r4T35FL+LGJW87Jh7EhXGhP+qxognlO4NP8xGjZ5qHliqlQ1X787YH6JjFJULQYoX4QSDY39nNGN05xz+jmYTh3kvtNB9XTwTiwMr4Nbd6YceuchnViMv5/YaDxaupknkn/cuYmRub4VSAfrcTS25DB4odr9JVs9cQqAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789087611; c=relaxed/simple;
	bh=cX2eYPDA0QTBWmqMFjtoxFZUfSdQXFXoX8N6MK2p3Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlYnyqaHIXfBRoXgm99sTqpDPMMuV8JXBK208S71ot1X1njHpl1k70/c+WpmJ/uOuQM5uMJmmIZrhaCegBlEBtQMx3VNVt2exoFpPnDRijhM2sO2cYU6f8xcxjQjbnSwbwFWKAvUElbt344Ozzqnc1CCmKXb2j3qI0+HMzx4KXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I94h1uvY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I94h1uvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2941F000FF;
	Fri, 11 Sep 2026 00:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789087610;
	bh=LVLnyusPS9/cmxWC2/sW3G9S2I6Vu+zek9mtK8Hza+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I94h1uvY97U2BJ3SpQ9djvvpqmOH8a/qdG96u4kD8f01BYfHNUxv4x/k3BHhhzxa4
	 Zr04RdoaoLz3kRbm3H7+lCJ7RQ/635MrstXEFKXmQeS2ZBDuQjGNlU75cEKnpnlb0k
	 mnzyEbO/USS8QmkJHZHFzFYf1DcgcAEJl1/+IHAtUPyydgpq+FK3ShXyeN5amPSBUg
	 fyoHDe9TJpI+VttM8GflCToyXEq4/KTgQ0SKaFioGkVyFaG8U3Z3L77eZwsevqP3Tl
	 rBoHB/mc9tP78T4ttAzW+axGcGPxUS34+Enkci5EoNHq5DEeJP4tTo8YzXX+Skzb8y
	 VdwOlWM4qTlnQ==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 6/7] netfilter: xt_IDLETIMER: allocate timer with kzalloc()
Date: Thu, 10 Sep 2026 17:46:49 -0700
Message-ID: <20260911004649.2877933-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909221844.1650275-7-pablo@netfilter.org>
References: <20260909221844.1650275-7-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: xt_IDLETIMER: allocate timer with kzalloc()

This switches the struct idletimer_tg allocation in
idletimer_tg_create_v1() from kmalloc_obj() to kzalloc_obj() so the
embedded struct device_attribute does not carry uninitialized function
pointers.  The v0 path already used kzalloc_obj(), so this aligns the
two.

> diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
> index fe7d8d19629b4..8a1d95d219917 100644
> --- a/net/netfilter/xt_IDLETIMER.c
> +++ b/net/netfilter/xt_IDLETIMER.c
> @@ -196,7 +196,7 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
>  {
>  	int ret;
>  
> -	info->timer = kmalloc_obj(*info->timer);
> +	info->timer = kzalloc_obj(*info->timer);
>  	if (!info->timer) {
>  		ret = -ENOMEM;
>  		goto out;

[Severity: Medium]
The change itself looks right, and zeroing does remove the uninitialized
attr.store / attr.store_const pointers, but does the mechanism described in
the commit message actually work?

The message says:

  "When the sysfs file is created, a process with the DAC_OVERRIDE
  capability can bypass the 0444 mode restriction and write to the file.
  This causes dev_attr_store() to execute the uninitialized store pointer,
  leading to arbitrary kernel code execution."

sysfs creates its kernfs root with the extra open permission check:

fs/sysfs/mount.c:sysfs_init() {
	sysfs_root = kernfs_create_root(NULL, KERNFS_ROOT_EXTRA_OPEN_PERM_CHECK,
					NULL);
	...
}

and kernfs_fop_open() rejects the write open before any ->store dispatch:

fs/kernfs/file.c:kernfs_fop_open() {
	...
	if (root->flags & KERNFS_ROOT_EXTRA_OPEN_PERM_CHECK) {
		if ((file->f_mode & FMODE_WRITE) &&
		    (!(inode->i_mode & S_IWUGO) || !has_write))
			goto err_out;
	...
}

idletimer_tg_create_v1() sets attr.attr.mode = 0444, and
sysfs_add_file_mode_ns() installs that mode verbatim via mode & 0777, so
S_IWUGO is clear on the inode and the write open fails with -EACCES
regardless of CAP_DAC_OVERRIDE.

Reaching the garbage pointer seems to require a privileged chmod of the
sysfs file first (permitted by kernfs_iop_setattr()), which is a different
and much narrower trigger than the capability bypass described.

Could the commit message be reworded to describe the actual trigger, given
that the Fixes: tag and the "arbitrary kernel code execution" wording will
drive stable backports?
