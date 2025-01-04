Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B69182CD;
	Sat,  4 Jan 2025 02:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735956111; cv=none; b=n6JIxZf6LE8IK/NLjsI+Qvw17rzaY+NalFu7ZjqSxq1Y1RcjF+MbO1kt1KCHpbsO9M+cQ7ByCvUPTDi8BQ0dAEdSyUiN/AFSmPjxA4P+DQ6BUdHxMYpEkcknAqj6BBo8hRHPgwuY4XRuukE2sDSQM1HgycozIyluZ7mbyNU9cX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735956111; c=relaxed/simple;
	bh=cp3y3UHEtG8IL5FlhkaF54hNlSs0zW2uWc58HvmwFt4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=iVuf5hVHHYyciRirH7lUO4ULkuVvhoFl9l+443FPlYt2M//KGAcHMa0Rn56Xxk6luCbtBrD7cs3l5Yhy6342Pp5ZH4aZv3TH953pCNurXmgBdYUIzg8oO4czqtxaqGsmjGOXgB4Ie+keI2BQnS2I75GaIkixhK1LYHGC8ISmHU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eVm4qr3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eVm4qr3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15479C4CED6;
	Sat,  4 Jan 2025 02:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735956111;
	bh=cp3y3UHEtG8IL5FlhkaF54hNlSs0zW2uWc58HvmwFt4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eVm4qr3KDu2/KTN7kevzV2ArIu65yp6ZWJLcgbvbPry2y2nvWnu4lTgu/Kii/QzzE
	 OU+pmtfzk2BXEsrZUtTCj/SfCCmah1DU38NhObVizBTMmnFjxtg7neBR82tg7gjOOS
	 1qGH7+Oh3e7m9Z4ziKcVDTZFtYUPXrM5av5HK/sg=
Date: Fri, 3 Jan 2025 18:01:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: cheung wall <zzqq0103.hey@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org
Subject: Re: "WARNING in nf_ct_alloc_hashtable" in Linux kernel version
 6.13.0-rc2
Message-Id: <20250103180150.4c4d1f30220720ba7f1a133b@linux-foundation.org>
In-Reply-To: <CAKHoSAtDrR9kkrVZufEYqPoKZpT7WyLC9DH8gCx9cox3oSNPaQ@mail.gmail.com>
References: <CAKHoSAtDrR9kkrVZufEYqPoKZpT7WyLC9DH8gCx9cox3oSNPaQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 3 Jan 2025 17:12:53 +0800 cheung wall <zzqq0103.hey@gmail.com> wrote:

> Hello,
> 
> I am writing to report a potential vulnerability identified in the
> Linux Kernel version 6.13.0-rc2. This issue was discovered using our
> custom vulnerability discovery tool.
> 
> HEAD commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4 (tag: v6.13-rc2)
> 
> Affected File: mm/util.c
> 
> File: mm/util.c
> 
> Function: __kvmalloc_node_noprof

(cc netfilter-devel)

This is

	/* Don't even allow crazy sizes */
	if (unlikely(size > INT_MAX)) {
		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
		return NULL;
	}

in __kvmalloc_node_noprof().

> Detailed Call Stack:
> 
> ------------[ cut here begin]------------
> 
> RIP: 0010:__kvmalloc_node_noprof+0x18d/0x1b0 mm/util.c:662
> Code: a1 48 c7 c7 28 df 86 a8 e8 90 86 14 00 e9 70 ff ff ff e8 b6 d3
> e3 ff 41 81 e4 00 20 00 00 0f 85 16 ff ff ff e8 a4 d3 e3 ff 90 <0f> 0b
> 90 31 db e9 c4 fe ff ff 48 c7 c7 f8 91 e3 a7 e8 5d 86 14 00
> RSP: 0018:ffff88800f397b38 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffa46327ec
> RDX: ffff88800fc4d500 RSI: ffffffffa471a1b1 RDI: 0000000000000000
> RBP: 00000000cbad2000 R08: 0000000000000000 R09: 0a33303939333137
> loop4: detected capacity change from 0 to 32768
> R10: ffff88800f397b38 R11: 0000000000032001 R12: 0000000000000000
> R13: 00000000ffffffff R14: 000000001975a400 R15: ffff88800f397e08
> SELinux: security_context_str_to_sid (root) failed with errno=-22
> FS: 00007fc9b1d23580(0000) GS:ffff88811b380000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055c7e2f2b6b8 CR3: 000000000b970000 CR4: 0000000000350ef0
> Call Trace:
> <TASK>
> kvmalloc_array_node_noprof include/linux/slab.h:1063 [inline]
> nf_ct_alloc_hashtable+0x83/0x110 net/netfilter/nf_conntrack_core.c:2526
> nf_conntrack_hash_resize+0x91/0x4d0 net/netfilter/nf_conntrack_core.c:2547
> nf_conntrack_hash_sysctl net/netfilter/nf_conntrack_standalone.c:540 [inline]
> nf_conntrack_hash_sysctl+0xa9/0x100 net/netfilter/nf_conntrack_standalone.c:527
> proc_sys_call_handler+0x492/0x5d0 fs/proc/proc_sysctl.c:601
> new_sync_write fs/read_write.c:586 [inline]
> vfs_write+0x51e/0xc80 fs/read_write.c:679
> ksys_write+0x110/0x200 fs/read_write.c:731
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xa6/0x1a0 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> 
> ------------[ cut here end]------------
> 
> Root Cause:
> 
> The kernel panic originated within the __kvmalloc_node_noprof function
> in mm/util.c, triggered during the execution of the Netfilter
> connection tracking subsystem. Specifically, the
> nf_conntrack_hash_resize function attempted to allocate memory for
> resizing the connection tracking hash table from a capacity of 0 to
> 32,768 entries using kvmalloc_array_node_noprof. This memory
> allocation likely failed or was mishandled, resulting in an invalid
> memory access or dereference within __kvmalloc_node_noprof.
> Additionally, the log indicates a failure in the SELinux security
> context function security_context_str_to_sid, which returned an EINVAL
> error (errno=-22). The combination of these factors suggests that the
> crash was caused by improper handling of memory allocation during a
> significant capacity change in the connection tracking hash table,
> possibly due to unhandled allocation failures or logic errors in the
> resize process.
> 
> Thank you for your time and attention.
> 
> Best regards
> 
> Wall
