Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E854E194A76
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Dec 2025 22:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765665457; cv=none; b=Fd9VJLHzUxWYARnA7vvzk6QJRXbSDDYA/5qKqYCc8LE2/7mJcTcATO/QBnKoUT2X+c7NFgaqCIbo6846Zy5bgyt34XkfPXfKgZXtGTobjc2BWXMTKz9+EuPTHQIXjQVrde4yoZ+sOCIZ3ePGKkj7z5tFek5aM3OaDbSTvUVtQLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765665457; c=relaxed/simple;
	bh=0AKelx5YvD4ih/r164r9R4oF8i6pVFx8tyUStcoSlbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UI+Lq/ARI0yc3INf68O7vQ5wwpElphxiJ+kaadEG/ImmE2a29MHezHfPgyqELRj4nYVRnsPDFsSHc7EuD0/ACjmYetnWqlqbshF/Uanl36L2b4WfWeGaSs9uLQdLCNr1s4LZ3YCd+lRAGRk3IS1NTFf35S+iDhvsdS3gu2Lya48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7491960366; Sat, 13 Dec 2025 23:37:32 +0100 (CET)
Date: Sat, 13 Dec 2025 23:37:28 +0100
From: Florian Westphal <fw@strlen.de>
To: syzbot ci <syzbot+ci135094d4d47126eb@syzkaller.appspotmail.com>
Cc: netfilter-devel@vger.kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: netfilter: nf_tables: avoid chain re-validation
 if possible
Message-ID: <aT3qqBIme8LO6VqB@strlen.de>
References: <20251211123038.1175-1-fw@strlen.de>
 <693b5756.050a0220.1ff09b.0012.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <693b5756.050a0220.1ff09b.0012.GAE@google.com>

syzbot ci <syzbot+ci135094d4d47126eb@syzkaller.appspotmail.com> wrote:
 ------------[ cut here ]------------
> WARNING: net/netfilter/nf_tables_api.c:4112 at nft_chain_vstate_update net/netfilter/nf_tables_api.c:4112 [inline], CPU#1: syz.0.17/5982
> WARNING: net/netfilter/nf_tables_api.c:4112 at nft_chain_validate+0x6b0/0x8c0 net/netfilter/nf_tables_api.c:4176, CPU#1: syz.0.17/5982
> Modules linked in:
> CPU: 1 UID: 0 PID: 5982 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:nft_chain_vstate_update net/netfilter/nf_tables_api.c:4112 [inline]
> RIP: 0010:nft_chain_validate+0x6b0/0x8c0 net/netfilter/nf_tables_api.c:4176
> Code: 31 db 89 d8 48 83 c4 50 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 2d 32 42 f8 bb fc ff ff ff eb de e8 21 32 42 f8 90 <0f> 0b 90 49 83 c5 78 ba 04 00 00 00 4c 89 ef 31 f6 e8 ea 18 a8 f8
> RSP: 0018:ffffc90003df6fe0 EFLAGS: 00010293
> RAX: ffffffff897f183f RBX: 0000000000000000 RCX: ffff888102f93a80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000040 R08: ffff888102f93a80 R09: 0000000000000002
> R10: 0000000000000010 R11: 0000000000000000 R12: ffff88816a79c510
> R13: ffff88816a79c500 R14: ffff88816a79c500 R15: dffffc0000000000
> FS:  000055555e417500(0000) GS:ffff8882a9eb1000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000005000 CR3: 000000017531c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  nft_validate_register_store+0xf6/0x1d0 net/netfilter/nf_tables_api.c:11750
>  nft_parse_register_store+0x225/0x2c0 net/netfilter/nf_tables_api.c:11787
>  nft_immediate_init+0x1cf/0x390 net/netfilter/nft_immediate.c:67
>  nf_tables_newexpr net/netfilter/nf_tables_api.c:3550 [inline]
>  nf_tables_newrule+0x1794/0x28a0 net/netfilter/nf_tables_api.c:4419

Righ, this patch depends on the already pending patch
"netfilter: nf_tables: remove redundant chain validation on register store",
which removes the only case where the function is called with ctx->chain
not set to a base chain.
