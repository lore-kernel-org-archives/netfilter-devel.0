Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224C036EA9E
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Apr 2026 12:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775480065; cv=none; b=t87moC8b12kamDZN0BYApgMRvbphpIB+ehpnY0fQlee7ykyliKIP/6cYe7c38Jlx8rRz/F5bY/ewrWrJfAfIYB1TVLUXCwGDdiTFPkJlQewR5XQtRb66XOocFPtXYt0ICXhvv7NKsWjBZ/IY09hAB9xz3i/68qAwhrBLXaOcu4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775480065; c=relaxed/simple;
	bh=LsR7hE/w6MI1iPPkBH+0iYGlNJ6gyUh7K+zylqYbJU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KPA86ZHo0OUItL3uoVSVm5OmTNCav4us+emFXHGNa5jimgG9s9Z8vXKyuk9dbXoI7vsP54PNeDgPmIPqIgWGtMb1ahUCRt/6ffpHc/V2HYZJRMiyiXT+KlW0MMaBxp9gXn8bDZwgqku5yymjUjKaaf1Bsd8ujzdEgRTGgDHd7Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fpsZII7J; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BDsUeq3V; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fpsZII7J; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BDsUeq3V; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fpsZII7J";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BDsUeq3V";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fpsZII7J";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BDsUeq3V"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 463A24DED6;
	Mon,  6 Apr 2026 12:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775480061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5kKmKhDLPLb2pLFAyHy2AFNE9rCkroMqUtvCGSBJRc=;
	b=fpsZII7JipBG5uMLXumF2TulKQbNWvmpi9Gp+cLOVR2VOrM8Ry+i0gjwtQBs2spslPhSoX
	VITXMLZ+97x7cO7AiYeftIzzZI/Uj4ZU6bU0/poXnxJIE6K7Cdi7T005hgbkXQvovReDRr
	Ue+FRxjvhPMNh0Zq4U6J3bBFqb2LD8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775480061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5kKmKhDLPLb2pLFAyHy2AFNE9rCkroMqUtvCGSBJRc=;
	b=BDsUeq3VPtP+X6utTdIddwCrp7MJ/Wm1sDoP5PkStf5KPVunn3iJKoBSsFKvZwPSxzpk4v
	/y5mf/WFGUCzhBDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fpsZII7J;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BDsUeq3V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775480061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5kKmKhDLPLb2pLFAyHy2AFNE9rCkroMqUtvCGSBJRc=;
	b=fpsZII7JipBG5uMLXumF2TulKQbNWvmpi9Gp+cLOVR2VOrM8Ry+i0gjwtQBs2spslPhSoX
	VITXMLZ+97x7cO7AiYeftIzzZI/Uj4ZU6bU0/poXnxJIE6K7Cdi7T005hgbkXQvovReDRr
	Ue+FRxjvhPMNh0Zq4U6J3bBFqb2LD8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775480061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5kKmKhDLPLb2pLFAyHy2AFNE9rCkroMqUtvCGSBJRc=;
	b=BDsUeq3VPtP+X6utTdIddwCrp7MJ/Wm1sDoP5PkStf5KPVunn3iJKoBSsFKvZwPSxzpk4v
	/y5mf/WFGUCzhBDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D2414A0B0;
	Mon,  6 Apr 2026 12:54:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5y4JAP2s02l9GQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 06 Apr 2026 12:54:20 +0000
Message-ID: <867c1ae1-66b4-4584-985a-38a4f7d55925@suse.de>
Date: Mon, 6 Apr 2026 14:54:06 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: nfnetlink_queue crashes kernel
To: Florian Westphal <fw@strlen.de>
Cc: Scott Mitchell <scott.k.mitch1@gmail.com>, netfilter-devel@vger.kernel.org
References: <ac-w6e33txkgTRJj@strlen.de> <ac_EY9ciqt5yQ6wr@strlen.de>
 <b0c495e4-2137-443b-986e-ed0c10251d0c@suse.de> <adDccAnxkl4to_ta@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <adDccAnxkl4to_ta@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 463A24DED6

On 4/4/26 11:40 AM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 4/3/26 3:45 PM, Florian Westphal wrote:
>>> Florian Westphal <fw@strlen.de> wrote:
>>>> A probably better fix is to make the rhashtable perqueue, which is
>>>> much more intrusive at this late stage.
>>>
>>> Tentative patch to do this, still misses selftest extensions:
>>>
>>
>> I could help with selftests. I have written a couple already. Let me prepare
>> some this week and I will send them as proposals on the list.
> 
> Thanks Fernando, much appreciated.
> This will be hard to trigger, the autoresize means that we'll typically
> not have two entries per bucket.
> 
> What might help is to add a mode to nf_queue.c to:
> 1. send out-of-order-verdicts
> 2. send *bogus* verdicts that are expected to
>     fail w. -ENOENT.
> 
> I had a go at adding a stress test but its not
> triggering for me even if i run it for 10m.

Bingo! I modified the test you attached a bit to include your 
suggestions and I got the splat on virtme-ng when running the test. See 
the whole splat attached below.

I am going to test your proposed patch and check out the results. In 
addition I will do some cleanup and send this as a formal nf-next patch.

[  283.183815] 
==================================================================
[  283.184508] BUG: KASAN: slab-use-after-free in 
nfqnl_recv_verdict+0x149a/0x1a60 [nfnetlink_queue]
[  283.184508] Read of size 8 at addr ffff88800f151b10 by task nf_queue/685
[  283.184508]
[  283.184508] CPU: 10 UID: 0 PID: 685 Comm: nf_queue Not tainted 
7.0.0-rc6-virtme #2 PREEMPT(lazy)
[  283.184508] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  283.184508] Call Trace:
[  283.184508]  <TASK>
[  283.184508]  dump_stack_lvl+0x4d/0x70
[  283.184508]  print_report+0x170/0x4f3
[  283.184508]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[  283.184508]  ? __sys_sendto+0x342/0x390
[  283.184508]  kasan_report+0xda/0x110
[  283.184508]  ? nfqnl_recv_verdict+0x149a/0x1a60 [nfnetlink_queue]
[  283.184508]  ? nfqnl_recv_verdict+0x149a/0x1a60 [nfnetlink_queue]
[  283.184508]  nfqnl_recv_verdict+0x149a/0x1a60 [nfnetlink_queue]
[  283.184508]  ? __pfx_nfqnl_recv_verdict+0x10/0x10 [nfnetlink_queue]
[  283.184508]  ? unwind_next_frame+0x3c4/0x1f70
[  283.184508]  ? __is_insn_slot_addr+0x8c/0x100
[  283.184508]  ? is_module_text_address+0x111/0x180
[  283.184508]  ? __pfx_nfqnl_recv_verdict+0x10/0x10 [nfnetlink_queue]
[  283.184508]  nfnetlink_rcv_msg+0x455/0x840 [nfnetlink]
[  283.184508]  ? __pfx_nfnetlink_rcv_msg+0x10/0x10 [nfnetlink]
[  283.184508]  ? __kasan_slab_alloc+0x63/0x80
[  283.184508]  ? kmem_cache_alloc_node_noprof+0x119/0x3c0
[  283.184508]  ? kmalloc_reserve+0x101/0x2b0
[  283.184508]  ? __alloc_skb+0x11e/0x820
[  283.184508]  ? netlink_sendmsg+0x503/0xbb0
[  283.184508]  ? __sys_sendto+0x342/0x390
[  283.184508]  ? __x64_sys_sendto+0xe4/0x1f0
[  283.184508]  ? do_syscall_64+0xe2/0xf80
[  283.184508]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  283.184508]  netlink_rcv_skb+0x126/0x380
[  283.184508]  ? __pfx_nfnetlink_rcv_msg+0x10/0x10 [nfnetlink]
[  283.184508]  ? __pfx_netlink_rcv_skb+0x10/0x10
[  283.184508]  ? __asan_memset+0x27/0x50
[  283.184508]  nfnetlink_rcv+0x166/0x4a0 [nfnetlink]
[  283.184508]  ? __pfx___netlink_lookup+0x10/0x10
[  283.184508]  ? __pfx_nfnetlink_rcv+0x10/0x10 [nfnetlink]
[  283.184508]  netlink_unicast+0x614/0x830
[  283.184508]  ? __pfx_netlink_unicast+0x10/0x10
[  283.184508]  ? __pfx___alloc_skb+0x10/0x10
[  283.184508]  netlink_sendmsg+0x6d0/0xbb0
[  283.184508]  ? __pfx_netlink_sendmsg+0x10/0x10
[  283.184508]  ? _copy_from_user+0x2d/0x80
[  283.184508]  __sys_sendto+0x342/0x390
[  283.184508]  ? __pfx___sys_sendto+0x10/0x10
[  283.184508]  __x64_sys_sendto+0xe4/0x1f0
[  283.184508]  ? fpregs_assert_state_consistent+0x5b/0xf0
[  283.184508]  do_syscall_64+0xe2/0xf80
[  283.184508]  ? __sysvec_call_function+0x20/0x280
[  283.184508]  ? exc_page_fault+0x6f/0xc0
[  283.184508]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  283.184508] RIP: 0033:0x7f49aacf0c5e
[  283.184508] Code: 4d 89 d8 e8 34 bd 00 00 4c 8b 5d f8 41 8b 93 08 03 
00 00 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 
05 <c9> c3 83 e2 39 83 fa 08 75 e7 e8 13 ff ff ff 0f 1f 00 f3 0f 1e fa
[  283.184508] RSP: 002b:00007fffdfd753c0 EFLAGS: 00000202 ORIG_RAX: 
000000000000002c
[  283.184508] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
00007f49aacf0c5e
[  283.184508] RDX: 0000000000000020 RSI: 000000000c085010 RDI: 
0000000000000005
[  283.184508] RBP: 00007fffdfd753d0 R08: 00007f49aae78980 R09: 
000000000000000c
[  283.184508] R10: 0000000000000000 R11: 0000000000000202 R12: 
00007fffdfd755f8
[  283.184508] R13: 0000000000000007 R14: 00007f49aaedc000 R15: 
0000000000403df0
[  283.184508]  </TASK>
[  283.184508]
[  283.184508] Allocated by task 709:
[  283.184508]  kasan_save_stack+0x30/0x50
[  283.184508]  kasan_save_track+0x14/0x30
[  283.184508]  __kasan_kmalloc+0x7f/0x90
[  283.184508]  __kmalloc_noprof+0x180/0x4b0
[  283.184508]  nf_queue+0x10d/0x1700
[  283.184508]  nf_hook_slow+0x13f/0x1e0
[  283.184508]  ip_forward+0x1637/0x2010
[  283.184508]  ip_rcv+0x2e8/0x360
[  283.184508]  __netif_receive_skb_one_core+0x14f/0x1b0
[  283.184508]  process_backlog+0x1ea/0x5e0
[  283.184508]  __napi_poll+0x9d/0x4a0
[  283.184508]  net_rx_action+0x980/0xfb0
[  283.184508]  handle_softirqs+0x18e/0x520
[  283.184508]  do_softirq+0x42/0x60
[  283.184508]  __local_bh_enable_ip+0x62/0x70
[  283.184508]  __dev_queue_xmit+0x903/0x3390
[  283.184508]  ip_finish_output2+0x55d/0x1cb0
[  283.184508]  ip_do_fragment+0x13fb/0x1f80
[  283.184508]  __ip_finish_output+0x536/0xb10
[  283.184508]  ip_output+0x17a/0x2f0
[  283.184508]  ip_send_skb+0x113/0x150
[  283.184508]  udp_send_skb+0x7c9/0xff0
[  283.184508]  udp_sendmsg+0x1394/0x1fa0
[  283.184508]  __sys_sendto+0x32b/0x390
[  283.184508]  __x64_sys_sendto+0xe4/0x1f0
[  283.184508]  do_syscall_64+0xe2/0xf80
[  283.184508]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  283.184508]
[  283.184508] Freed by task 709:
[  283.184508]  kasan_save_stack+0x30/0x50
[  283.184508]  kasan_save_track+0x14/0x30
[  283.184508]  kasan_save_free_info+0x3b/0x70
[  283.184508]  __kasan_slab_free+0x47/0x70
[  283.184508]  kfree+0x147/0x3b0
[  283.184508]  nf_queue+0x865/0x1700
[  283.184508]  nf_hook_slow+0x13f/0x1e0
[  283.184508]  ip_forward+0x1637/0x2010
[  283.184508]  ip_rcv+0x2e8/0x360
[  283.184508]  __netif_receive_skb_one_core+0x14f/0x1b0
[  283.184508]  process_backlog+0x1ea/0x5e0
[  283.184508]  __napi_poll+0x9d/0x4a0
[  283.184508]  net_rx_action+0x980/0xfb0
[  283.184508]  handle_softirqs+0x18e/0x520
[  283.184508]  do_softirq+0x42/0x60
[  283.184508]  __local_bh_enable_ip+0x62/0x70
[  283.184508]  __dev_queue_xmit+0x903/0x3390
[  283.184508]  ip_finish_output2+0x55d/0x1cb0
[  283.184508]  ip_do_fragment+0x13fb/0x1f80
[  283.184508]  __ip_finish_output+0x536/0xb10
[  283.184508]  ip_output+0x17a/0x2f0
[  283.184508]  ip_send_skb+0x113/0x150
[  283.184508]  udp_send_skb+0x7c9/0xff0
[  283.184508]  udp_sendmsg+0x1394/0x1fa0
[  283.184508]  __sys_sendto+0x32b/0x390
[  283.184508]  __x64_sys_sendto+0xe4/0x1f0
[  283.184508]  do_syscall_64+0xe2/0xf80
[  283.184508]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  283.184508]
[  283.184508] The buggy address belongs to the object at ffff88800f151b00
[  283.184508]  which belongs to the cache kmalloc-128 of size 128
[  283.184508] The buggy address is located 16 bytes inside of
[  283.184508]  freed 128-byte region [ffff88800f151b00, ffff88800f151b80)
[  283.184508]
[  283.184508] The buggy address belongs to the physical page:
[  283.184508] page: refcount:0 mapcount:0 mapping:0000000000000000 
index:0xffff88800f151300 pfn:0xf150
[  283.184508] head: order:1 mapcount:0 entire_mapcount:0 
nr_pages_mapped:0 pincount:0
[  283.184508] flags: 0x80000000000240(workingset|head|node=0|zone=1)
[  283.184508] page_type: f5(slab)
[  283.184508] raw: 0080000000000240 ffff888001048a00 ffffea00001b3d10 
ffffea00000e7190
[  283.184508] raw: ffff88800f151300 0000000000200005 00000000f5000000 
0000000000000000
[  283.184508] head: 0080000000000240 ffff888001048a00 ffffea00001b3d10 
ffffea00000e7190
[  283.184508] head: ffff88800f151300 0000000000200005 00000000f5000000 
0000000000000000
[  283.184508] head: 0080000000000001 ffffea00003c5401 00000000ffffffff 
00000000ffffffff
[  283.184508] head: 0000000000000000 0000000000000000 00000000ffffffff 
0000000000000000
[  283.184508] page dumped because: kasan: bad access detected
[  283.184508]
[  283.184508] Memory state around the buggy address:
[  283.184508]  ffff88800f151a00: fa fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[  283.184508]  ffff88800f151a80: fc fc fc fc fc fc fc fc fc fc fc fc fc 
fc fc fc
[  283.184508] >ffff88800f151b00: fa fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[  283.184508]                          ^
[  283.184508]  ffff88800f151b80: fc fc fc fc fc fc fc fc fc fc fc fc fc 
fc fc fc
[  283.184508]  ffff88800f151c00: fa fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[  283.184508] 
==================================================================

