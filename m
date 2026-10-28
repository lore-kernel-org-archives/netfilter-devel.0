Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793180553;
	b=IXqM6Hib5pryTHOlLXOPfn8CKHJdL5jHEd4H8/jLmcucOpBAyL2kI1ZDxbGW0vV8qABt
	 YQfmeYrsFm7nFlkbIGGvnBoIBTyOujMEBrIk9S/x6tp7WSYEMmmfh+eFMvsCZjomc/jCm
	 shld03O43LWmTv4lRdSufslnyN/SbJ1y5MPFVOVyC/w5rqv/40lj41UNlPZWQGTHs+B6m
	 sRBGUnt64vOJKP4oSYuk18rwDIcfLmbso9u8YlEKVoMoH43dRL4+sSMCcuMGXUtx9VOUd
	 T66KGN56jsgBKBx95mIcPGUNnzNssP1NmQKxF26YRpJc7mIfuBNlluQHu/eF/s1KThw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793180553;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=vXWRSuBr24FOXUy04I4FEnn1qkhkP7RDetEpiCT0V6c=;
	b=mI6mbK0Csb+jW4pFx2cEkv1QBzxVezISIoTZokKheOgCuAo80cbm1rMQzaBB5N+FK6pq
	 3XyjA0jIuwqohYzVmHr0ni05TTfwIa2SsABquqJfQFeQ9YFMj679Kwp1t285V4OeMc3ut
	 JN6yIva6+Yd2CKty2gd+ixcFbwEE+BfpDkPfT5yJtsISkLSkoEynmIVLdeFaUgM+fxPUA
	 JFXzr98T7l/D8I3CmSXDDuUMpDlLx5ihWCToV3kKFOCvr5aUMjZrnqPw3Sl+bfLv70bZg
	 hKTYNVIx8Gcq2ystru/MTaNRdhZEVbH1FBtdzO5bB+r9Qflj4r+lo4dmSXsxEoNjMZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=QutrsY2M;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gOEmZYEL;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GiIrzTly;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bcnqQN6J;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD68A60A3830;
	Wed, 28 Oct 2026 09:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD68A60A3830
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=QutrsY2M;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gOEmZYEL;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GiIrzTly;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bcnqQN6J
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DC2F11F74A;
	Wed, 28 Oct 2026 09:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793180551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXWRSuBr24FOXUy04I4FEnn1qkhkP7RDetEpiCT0V6c=;
	b=QutrsY2MPYpG2twer2WvH3kQvYQTLGRgsAbe7+q1jL249CpRMAVit3NVbrX4fi0G8XwGGJ
	8w5x367a0dP6xROP6+UbISV2+22Kj1VuogyG4TCUNl4EoTvTxM9ZrbZOzVl9AVSJu1Owr0
	olI9sY9gvOfh5zEsSg0OYf8sPiECLjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793180551;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXWRSuBr24FOXUy04I4FEnn1qkhkP7RDetEpiCT0V6c=;
	b=gOEmZYELGdvQKvW5YKjcKfLj000R8ethwPtKMNz3bXdjy2R4h/Q+Q7JEPhLnY5y7qbSyzX
	r92DNVAT/Spt8bBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GiIrzTly;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bcnqQN6J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793180550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXWRSuBr24FOXUy04I4FEnn1qkhkP7RDetEpiCT0V6c=;
	b=GiIrzTlyklc6bRQKMB/ErKZpMvqfyOtORseVMINEFSerA7kDZZTiQ/1Pv4phTFKSnzudQU
	bZZscN8CH3cvFMmwLKafM2BEkhTtkOBG6uqxtG5XuW3Ul2ny0G4DMrH6B9rOOMAcXBpTYD
	hmI7q2wmBdiKDnK7mn22p1vmc1Bd4NA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793180550;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXWRSuBr24FOXUy04I4FEnn1qkhkP7RDetEpiCT0V6c=;
	b=bcnqQN6Jxa3YiQGiKoYIBjwwS71UkPxdgp4QAy5NiQJu7i8bT3+4QDG0qr7vEN+AAOe0tX
	RRhagO02USdsa3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 390241321C;
	Wed, 28 Oct 2026 09:42:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pEdGA4bD4WrJSgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 28 Oct 2026 09:42:30 +0000
Message-ID: <f2e3828b-c3d6-47dc-b37a-512045b8bb26@suse.de>
Date: Wed, 28 Oct 2026 10:41:08 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG Report] UAF in ipt_do_table() on table replace (v5.10/v6.6)
To: "huangwenqing (A)" <huangwenqing@yinwang.com>,
 "pablo@netfilter.org" <pablo@netfilter.org>,
 "kadlec@netfilter.org" <kadlec@netfilter.org>, "fw@strlen.de" <fw@strlen.de>
Cc: "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
 "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 Phil Sutter <phil@nwl.cc>, "wangli (D)" <wangli2@yinwang.com>,
 guxizhi <guxizhi@yinwang.com>
References: <9fc5fe14207146a4a9d12c12cf17e652@yinwang.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <9fc5fe14207146a4a9d12c12cf17e652@yinwang.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: DC2F11F74A

On 10/28/26 3:35 AM, huangwenqing (A) wrote:
> Hello,
> 
> We hit a field panic in ipt_do_table() on an OEM kernel based on
> v5.10.43 (arm64), several times per fleet per week, sometimes as
> reboot storms on the same device; in most logs netd /
> iptables-restore had run 0.7 to 2.2 seconds before the crash.  It
> looks similar to the ip6t_do_table() use-after-free that motivated
> cc00bcaa5899.  Field logs are customer-confidential; a sanitized
> representative stack is at [2].
> 
> Root cause we suspect is as follows:
> 
> xt_replace_table (setsockopt IPT_SO_SET_REPLACE)
>    table->private = newinfo
>    /* ... wait for even xt_recseq on all cpus ... */
>    for_each_possible_cpu(cpu)
>      raw_read_seqcount(&per_cpu(xt_recseq, cpu))   // scan misses a walker
>    return private
>      xt_free_table_info
>        cleanup_entry -> string_mt_destroy -> textsearch_destroy
>          kfree(pattern)                            // old table + matches freed
> 
> ipt_do_table (reader, packet path, e.g. INPUT softirq)
>    addend = xt_write_recseq_begin()          // seq -> odd
>    private = READ_ONCE(table->private)       // still the old table
>    ... walk the whole table ...              // reads freed memory
>    xt_write_recseq_end(addend)               // seq -> even
> 

Hi,

Have you tried to trigger this on mainline? Or at least 7.3? It would be 
helpful to understand if this is a problem of stable kernel or an 
existing issue in the current codebase.

Thanks,
Fernando.

> A reader that fetched the old ->private but is missed by this
> single-pass per-CPU scan keeps walking the old table while the
> caller frees it.  Note xt_recseq is a seqcount_t used with
> inverted roles: the entity marking the count (ipt_do_table) is the
> *reader* of the protected data, the data writer (the replacer)
> only polls the count, and nothing anywhere does
> read_seqcount_begin()/retry on it -- it is a hand-rolled per-CPU
> quiescence wait.
> 
> We reproduced this on vanilla v6.6.160 + KASAN: forcing the miss
> once -- a single debugger write making the scan read "even" for
> CPUs whose readers are still walking -- reproduces the
> use-after-free with high probability, and the other in-flight
> walkers then fault concurrently, ending in the same panic form as
> the field (setup and method in [1]).  Without the flip we only see
> long-tail wedges (replacers never returning from setsockopt()).
> The flip does not prove the scan misses readers by itself; the
> field crash is our natural occurrence.
> 
> History we may be misreading: cc00bcaa5899 (Dec 2020) converted
> this scheme to RCU to fix a reported ip6t_do_table() UAF, was
> reverted in March 2021 (d3d40f237480) because synchronize_rcu()
> slowed table replaces by an order of magnitude (200 iptables
> invocations: 1.16 s -> 11.59 s), and 175e476b8cdf then upgraded two
> of the smp_wmb()s to smp_mb().  Our OEM kernel and current mainline
> are both in that post-revert shape, so the field crash happens on
> a kernel that already carries 175e476b8cdf.  One gap it did not
> touch: xt_write_recseq_end() still only issues smp_wmb() before
> the even store, leaving the walk's loads unordered against it.
> 
> Maybe the destruction of the old table could be deferred with
> call_rcu() (as nftables does for replaced rules), which would keep
> the replace latency as it is today while removing this whole class
> of ordering subtleties.
> 
> Does anyone have a good idea to solve this problem?  Also, is the
> single-pass scan believed to be correct on all architectures with
> the 175e476b8cdf barriers, and is the end-side smp_wmb()-only
> ordering known or considered harmless?
> 
> Best Regards,
> Wenqing Huang
> 
> [1] Reproduction on vanilla v6.6.160 + KASAN (QEMU virt-aarch64,
> 16 vCPU):
> 
>      Kernel: kernel.org linux-6.6.160, arm64 defconfig +
>      CONFIG_KASAN=y (generic) + CONFIG_KASAN_VMALLOC=y, booted with
>      nokaslr.
> 
>      Load: per-CPU UDP senders crossing a filter table with ~45
>      xt_string rules, plus processes looping
>      setsockopt(IPT_SO_SET_REPLACE).
> 
>      Trigger: the window is narrow, so we forced exactly one event
>      with a debugger.  On entry to xt_replace_table(), flip the
>      per-CPU xt_recseq of the in-flight walkers odd -> even --
>      i.e. make the scan read "even" for CPUs whose readers are
>      still inside the table, the event the scan exists to rule out.
>      This is the single debugger write (no memory poisoning, no
>      page recycling); everything after it was natural: the scan
>      passed, the old table and its xt_string/textsearch allocations
>      were freed, and the walkers still walking were caught by KASAN.
> 
>      Full report:
> 
>      BUG: KASAN: slab-use-after-free in kmp_find+0x188/0x294
>      Read of size 1 at addr ffff0000c81b8934 by task init/146
>      CPU: 4 PID: 146 Comm: init Not tainted 6.6.160
> 
>      Call Trace (access -- an in-flight walker, softirq INPUT path,
>      entered from sendto -> ip_output -> loopback delivery):
>       kmp_find+0x188/0x294
>       skb_find_text+0x130/0x198
>       string_mt+0x6c/0x94
>       ipt_do_table+0x494/0x7e4
>       nf_hook_slow+0xa4/0x148
>       ip_local_deliver+0x264/0x29c
>       ip_rcv+0xb0/0x188
>       __netif_receive_skb+0xac/0x1cc
>       ... process_backlog -> net_rx_action
> 
>      Allocated by task 151 (the table install):
>       __kmalloc+0xb8/0x10c
>       kmp_init+0x54/0x2bc
>       textsearch_prepare+0x128/0x18c
>       string_mt_check+0xac/0xcc
>       xt_check_match+0x3c8/0x42c
>       translate_table+0x824/0xb40
>       do_ipt_set_ctl (setsockopt IPT_SO_SET_REPLACE)
> 
>      Freed by task 150 (the next replace, tearing down the old
>      table):
>       kfree+0x58/0x78
>       textsearch_destroy+0x5c/0x6c
>       string_mt_destroy+0x30/0x40
>       cleanup_entry+0x124/0x1f0
>       do_ipt_set_ctl+0x800/0x8f4
>       ... __arm64_sys_setsockopt (setsockopt IPT_SO_SET_REPLACE)
> 
>      The buggy address belongs to the object at ffff0000c81b8900, 52
>      bytes inside it: the kmp pattern configuration of the old
>      table's xt_string match -- the same object class whose bytes
>      appear as wild match pointers in the field logs.
> 
> [2] Sanitized representative field stack (OEM v5.10.43):
> 
>      WARNING: CPU: 1 PID: 0 at net/ipv4/netfilter/ip_tables.c:305
>                ipt_do_table+0x48c/0x6c4
>      x8 : 0000000000000000            <- t->u.kernel.target
>      Call trace:
>       ipt_do_table+0x48c/0x6c4
>       iptable_filter_hook+0x30/0x40
>       nf_hook_slow+0xa8/0x1e8
>       ip_local_deliver+0xa8/0x17c
>       ip_rcv+0xfc/0x15c
>       __netif_receive_skb_core+0xe58/0x114c
>      [1.3 ms later]
>      Unable to handle kernel NULL pointer dereference at virtual
>      address 0000000000000030
>      pc : ipt_do_table+0x2d8/0x6c4
>      Kernel panic - not syncing: Oops: Fatal exception in interrupt
> 
>      Eleven captured occurrences all fault inside ipt_do_table(), at
>      neighboring instructions of the same 0x6c4-byte function
>      (+0xfc/+0x2ac/+0x2d8/+0x338/+0x48c), always from packet
>      processing.  In other logs the faulting addresses are wild
>      non-canonical (e.g. 0xffffff9c71769000), and in the clearest
>      ones the in-register match pointer contains bytes of xt_string
>      pattern data while the entry pointer is tens of KB past the end
>      of the table blob.  Six product software versions from 2024 to
>      2026 share the same kernel image (same faulting offsets, only
>      the KASLR base differs), so this is a long-standing defect.

