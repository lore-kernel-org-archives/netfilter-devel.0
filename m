Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [194.59.206.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C564368943;
	Fri, 27 Feb 2026 08:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.59.206.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772179238; cv=none; b=ey9tPKI6Da6l7smpCNHVJdECihLC14p6GPE+4S8eMfyWqbxvBna7el3VxRCoBXI0tR+WLodvN+waeR6kogr+8I6o+Mmcs3U5xHGApRY6Swe38iLpatmSF+RG1YPnGaAr6SPSSHIVbJIBbiv0Z/rhlMfFGZuMj/T1vi3B5ghkjMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772179238; c=relaxed/simple;
	bh=BVKiEYenTNAfVqdXZA5Z+9Ej3DYtvXKf2PuLw0IFcKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LwaSgrdOhqsZr1891o2jkILZd0fLa2eIDSukRjSlmHW4ZefRn4zXq7TfWqFLsoKT0Fp57FP0pAtmYpZFHuqiW3+OpY5eKiXTSuSk6+0QJu+caDV32MyVOqjCVeoOCUI6oQ8y7kTZw+fstO6poRhDoEY0YzKnqOmZiBRzY9upIOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=lB0/vlcq; arc=none smtp.client-ip=194.59.206.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="lB0/vlcq"
Received: from relay02-mors.netcup.net (localhost [127.0.0.1])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4fMgjr1gFRz4GGp;
	Fri, 27 Feb 2026 09:00:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1772179232;
	bh=BVKiEYenTNAfVqdXZA5Z+9Ej3DYtvXKf2PuLw0IFcKs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lB0/vlcqkQ3zZhS3yQecBcSxOO8vYkXHkdXG/V1fXyIKtP+ioxBAUAOC/65zv1OWj
	 Gp/GiC6QM0Qw8fuBMQk4uXdli2jebKqK/yJ92yu7vrDdzM7p4GarCa9lq994/Z2RY8
	 HPITnvi1dctRgH0oRWbxPv0lfy57G8xTNno6j5CD51b9fIcSn6I7VEOvDRJbw1HQQ/
	 LocfwdATf5SRQniz9Gl4p7FLnu1Vr1FrNdf3ku5++awpqrLEE5S8W1lnSQQ9A9S6oa
	 Vgcgrq74ydKh/4XJ8ryZF4kyTe0MgXhsjm5PM6WtoKAl3DfymJHTIkhe0umKipTmpp
	 Uw/xEJFei8Cdg==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4fMgjr0yH7z7wKd;
	Fri, 27 Feb 2026 09:00:32 +0100 (CET)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4fMgjp5VZZz8svF;
	Fri, 27 Feb 2026 09:00:30 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 0A93D617A3;
	Fri, 27 Feb 2026 09:00:30 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
Date: Fri, 27 Feb 2026 09:00:24 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables
To: Genes Lists <lists@sapience.com>, linux-kernel@vger.kernel.org,
 coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
 "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <177217923038.2795475.7544626820703456111@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 0A93D617A3
X-NC-CID: mZm3A7D0Ck0QLEVJ+321kERjmQLc4W8zf4AMoua5Opu39kuC7wA=

Lo!

On 2/27/26 04:46, Genes Lists wrote:
> I have a problem with nftables not working on 6.19.4 

Thx for the report. A problem that from a brief look seems to be similar
ist already discussed and was bisected in this thread:

https://lore.kernel.org/all/bb9ab61c-3bed-4c3d-baf0-0bce4e142292@moonlit-rail.com/

I assume Greg will handle this soon through a revert or by applying
another patch.

Ciao, Thorsten

> I apologize for not having done a bisect, but this is on a production
> firewall, so a bisect is not practical. If I can reproduce this on non-
> prod box, I can do a bisect. Hopefully this is is helpful nonetheless.
> 
> 
> Check different kernels with same nftables rules:
> 
>  - 6.19.4 (freshly compiled)
>    nft fails, and kernel logs trace. 
>    boot does not complete if nftables service is enabled.
> 
>  - 6.19.3
>    nft works fine and nothing bad in logs
> 
>  - mainline commit 3f4a08e64442340f4807de63e30aef22cc308830
>    nft fails with same error, but no trace in the kernel log.
>    boots but without working nftables.
> 
> The error nft displays, references somewhere in the middle
> of a large set of cidr elements:
> 
>   nft: In file included from /etc/nftables.conf:134:2-44:
>   nft: ./etc/nftables.d/set_filter.conf:1746:7-21: Error:
>         Could not proces rule: File exists
>   nft:                     23.157.184.0/23,
>   nft:                     ^^^^^^^^^^^^^^^
> 
>  Removing all but one element from set and rerunning nft, 
>  moves the line number but the error remains.
> 
> Userspace Archlinux:
>  - nftables 1.1.6
>  - libmnl 1.0.5
>  - libnftnl 1.3.1
>  - gcc 15.2.1+r604+g0b99615a8aef-1
>  - binutils 2.46-1
> 
> The first sign of trouble in 6.19.4 kernel log is:
> 
> [   39.731654] kernel: RIP: 0010:free_large_kmalloc+0xa8/0xd0
> [   39.731676] kernel: Code: 8d 78 ff a8 01 48 0f 44 fb eb bb 3d f8 00
> 00 00 75 18 0f 0b 80 3d 50 ff fd 01 00 0f 84 48 c1 b9 ff ba 00 f0 ff ff
> 31 ed eb 8d <0f> 0b 48 c7 c6 86 3c 83 96 48 89 df 5b 5d e9 95 9c fa ff
> 48 83 ef
> [   39.731698] kernel: RSP: 0018:ffffd0bcc146b610 EFLAGS: 00010202
> [   39.731720] kernel: RAX: 00000000000000ff RBX: fffffa5a04ad8680 RCX:
> ffff89c66b61ad40
> [   39.731747] kernel: RDX: 0000000000000000 RSI: ffff89c66b61a880 RDI:
> fffffa5a04ad8680
> [   39.731767] kernel: RBP: ffff89c66b61a880 R08: ffff89c6496ab6f0 R09:
> ffff89c66b6229c1
> [   39.731787] kernel: R10: ffff89c66b61a880 R11: fffffa5a04ad8680 R12:
> ffffd0bcc146b6a0
> [   39.731814] kernel: R13: ffff89c6496ab6f0 R14: ffff89c6496ab720 R15:
> ffffd0bcc146b6b0
> [   39.731836] kernel: FS:  00007bd6c7717c40(0000)
> GS:ffff89ca073c7000(0000) knlGS:0000000000000000
> [   39.731854] kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> [   39.731877] kernel: CR2: 0000746430061058 CR3: 0000000105ce4004 CR4:
> 00000000003726f0
> [   39.731903] kernel: Call Trace:
> [   39.731926] kernel:  <TASK>
> [   39.731993] kernel:  nf_tables_abort_release+0x22f/0x260 [nf_tables
> 78d597f27a85e5d69246ce15656dd0568c927257]
> [   39.732026] kernel:  nf_tables_abort+0x2cd/0xe80 [nf_tables
> 78d597f27a85e5d69246ce15656dd0568c927257]
> [   39.732051] kernel:  nfnetlink_rcv_batch+0x8c3/0xb80 [nfnetlink
> 938a1b64e36f407a05edbdcd1906670ecd99bb43]
> [   39.732076] kernel:  nfnetlink_rcv+0x195/0x1c0 [nfnetlink
> 938a1b64e36f407a05edbdcd1906670ecd99bb43]
> [   39.732101] kernel:  netlink_unicast+0x288/0x3c0
> [   39.732126] kernel:  netlink_sendmsg+0x20d/0x430
> [   39.732138] kernel:  ____sys_sendmsg+0x388/0x3c0
> [   39.732149] kernel:  ? import_iovec+0x1b/0x30
> [   39.732160] kernel:  ___sys_sendmsg+0x99/0xe0
> [   39.732172] kernel:  __sys_sendmsg+0x8a/0xf0
> [   39.732184] kernel:  do_syscall_64+0x81/0x610
> [   39.732202] kernel:  ? __handle_mm_fault+0xb46/0xf60
> [   39.732228] kernel:  ? perf_event_task_tick+0x4f/0xb0
> [   39.732256] kernel:  ? count_memcg_events+0xc2/0x170
> [   39.732279] kernel:  ? handle_mm_fault+0x1d7/0x2d0
> [   39.732306] kernel:  ? do_user_addr_fault+0x21a/0x690
> [   39.732333] kernel:  ? exc_page_fault+0x7e/0x1a0
> [   39.732358] kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> 
> (gdb) list *(nf_tables_abort_release+0x22f/0x260)
> 0x10c20 is in nf_tables_abort_release
> (net/netfilter/nf_tables_api.c:11119).
> 11114		mutex_lock(&nft_net->commit_mutex);
> 11115		list_splice(&module_list, &nft_net->module_list);
> 11116	}
> 11117	
> 11118	static void nf_tables_abort_release(struct nft_trans *trans)
> 11119	{
> 11120		struct nft_ctx ctx = { };
> 11121	
> 11122		nft_ctx_update(&ctx, trans);
> 
> 
> After this there are a lot of repeated lines like
> [   39.732596] kernel: page: refcount:0 mapcount:0
> mapping:0000000000000000 index:0xffff89c66b61a140 pfn:0x12b61a
> [   39.733541] kernel: raw: ffff89c66b620180 0000000000400000
> 00000000ffffffff 0000000000000000
> [   39.733738] kernel: raw: ffff89c66b61fc80 0000000000400000
> 00000000ffffffff 0000000000000000
> [   39.733874] kernel: raw: ffff89c66b61fc80 0000000000400000
> 00000000ffffffff 0000000000000000
> [   39.734032] kernel: raw: ffff89c66b61ea40 0000000000400000
> 00000000ffffffff 0000000000000000
> [   39.749164] kernel: flags:
> 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
> [   39.749221] kernel: raw: 0017ffffc0000000 fffffa5a04ad8d88
> fffffa5a04ad8d48 0000000000000000
> [   39.749243] kernel: raw: ffff89c66b634880 0000000000400000
> 00000000ffffffff 0000000000000000
> [   39.749266] kernel: page dumped because: Not a kmalloc allocation
> [   39.749283] kernel: page: refcount:0 mapcount:0
> mapping:0000000000000000 index:0xffff89c66b634880 pfn:0x12b634
> [   39.749306] kernel: flags:
> 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
> [   39.749329] kernel: raw: 0017ffffc0000000 fffffa5a04ad8d88
> fffffa5a04ad8d48 0000000000000000
> [   39.749351] kernel: raw: ffff89c66b634880 0000000000400000
> 00000000ffffffff 0000000000000000
> [   39.749372] kernel: page dumped because: Not a kmalloc allocation
> ...
> 

