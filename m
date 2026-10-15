Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6FB4AA402;
	Thu, 15 Oct 2026 09:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792057789; cv=none; b=ZxyHwRA78XX3JnkCdA5PB6DsEF6MhBET3zhr0lgu5O6TErxNN/Ua5hlWjrBZdSeY+mKVwRJHdhj27XnzWjAj/BcDUIQptIr1OHsgAt5Mie/amx4rNYj1LYesdqigYCtgTeEmn5NOG85jgw5V9vsadgpuFQ3PGBScRybuETDiUt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792057789; c=relaxed/simple;
	bh=Br4FRlUtRyfe+kj6bTSinbtHL0IsoYrOTCJEBphzawQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DPIzxYZdP47fJZojPnwV9Xr8gBEGP/UxuPeA75WVWoUs2/JBa6UCFqHQMAS8soTbaHHq6XOfSy/xVqXp8nIAzgaZuYGF8GrzDmiT4sHhNftP4hWsig84EP5eakN2bQJq8BkHM1yKUMVNPAuPiTD7dDbMMbHezol32cohnpbzu5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XwZO+qqY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8uN6qWef; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XwZO+qqY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8uN6qWef; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XwZO+qqY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8uN6qWef";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XwZO+qqY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8uN6qWef"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 954EA1FCC1;
	Thu, 15 Oct 2026 09:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792057785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZCmXZp4JSzOKNOK88WHvVMM+gz+JXpVc9fVvp5DGk4=;
	b=XwZO+qqY9oWJkk/Vkyl2+4jlkCx6jowkRZtPLXNGtw27KnrqAyMKHMATJbwAppr7hb3sFk
	ZmSpYAJxAaHmLPCVj7fwD7EWf2d8N8bU2JyjXLqYsaUouuv77xrckaGGtSvYvW2RoM5PTK
	QraHhKv2D4ETmoX5v9y1zuEIlsyh1ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792057785;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZCmXZp4JSzOKNOK88WHvVMM+gz+JXpVc9fVvp5DGk4=;
	b=8uN6qWeflqS1Ho12/nYldV3BRXR9jtpj+lLeQjFgQhNWmDE/eKKvJiT2KZ+oNycd9ny+1a
	Eo+fGNaq07Nr6KCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XwZO+qqY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8uN6qWef
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792057785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZCmXZp4JSzOKNOK88WHvVMM+gz+JXpVc9fVvp5DGk4=;
	b=XwZO+qqY9oWJkk/Vkyl2+4jlkCx6jowkRZtPLXNGtw27KnrqAyMKHMATJbwAppr7hb3sFk
	ZmSpYAJxAaHmLPCVj7fwD7EWf2d8N8bU2JyjXLqYsaUouuv77xrckaGGtSvYvW2RoM5PTK
	QraHhKv2D4ETmoX5v9y1zuEIlsyh1ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792057785;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZCmXZp4JSzOKNOK88WHvVMM+gz+JXpVc9fVvp5DGk4=;
	b=8uN6qWeflqS1Ho12/nYldV3BRXR9jtpj+lLeQjFgQhNWmDE/eKKvJiT2KZ+oNycd9ny+1a
	Eo+fGNaq07Nr6KCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D053F132C9;
	Thu, 15 Oct 2026 09:49:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3IbcJrih0Gq3YwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 15 Oct 2026 09:49:44 +0000
Message-ID: <21b46e85-49db-4c7f-9fd7-f32528f2dc4d@suse.de>
Date: Thu, 15 Oct 2026 11:48:39 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 00/15] Netfilter/IPVS updates for net-next
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, horms@kernel.org, fw@strlen.de,
 ja@ssi.bg, lorenzo@kernel.org
References: <20261011215953.1334630-1-pablo@netfilter.org>
 <as66prsWCk1qlQpm@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <as66prsWCk1qlQpm@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 954EA1FCC1
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,sashiko.dev:url,suse.de:dkim,nft_queue.sh:url];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 10/14/26 1:11 AM, Pablo Neira Ayuso wrote:
> Hi,
> 
> +Cc: lorenzo@kernel.org
> 
> This is a report on sashiko's findings:
> 
> https://sashiko.dev/#/patchset/20261011215953.1334630-1-pablo%40netfilter.org
> 
> On Sun, Oct 11, 2026 at 11:59:38PM +0200, Pablo Neira Ayuso wrote:
>> Hi,
>>
>> The following patchset contains Netfilter/IPVS updates for net-next:
>>
>> 1) Disable br_netfilter in userns and schedule it for removal in 2027,
>>     from Florian Westphal.
>>
>> 2) Prepare the flowtable to support for IPv4 over IPv6 tunneling and
>>     vice-versa, this includes 5 patches from Lorenzo Bianconi.
> 
> I am afraid this preparation series is enabling more than it should,
> sashiko reports type confusion is possible, for example:
> 
>    1/5 netfilter: flowtable: recognize IPv4/IPv6 in tunnel proto matching
> 
> this adds the initial pre-processing of IPv6-over-IPv4.
> 
> But then, nf_flow_offload_lookup() expects to handle IPv4, not an IPv6
> packet.
> 
> I will repost this PR keeping them back.
> 
>> 3) Update selftest nft_queue.sh to make it more stable on debug
>>     kernels, from Jakub Kicinski.
>>
>> 4) Fix a overflow in IPVS sync messages which can only happen in very
>>     old 2.6 kernels, from Julian Anastasov.
>>
>> 5) Flush conntrack gc worker when existing netns to address a unlikely
>>     UaF, from Florian Westphal.
>>
>> 6) Switch nf_tables chain types to use rcu, otherwise module removal
>>     can trigger UaF, also from Florian.
>>
>> 7) Add two new helper functions to validate that socket is of inet type,
>>     coming in 2 patches from Florian Westphal.
> 
> sashiko reports:
> 
> "If an IPv4 packet from an AF_INET socket is encapsulated by an IPv6 tunnel,
> the tunnel preserves the AF_INET socket in skb->sk while transmitting the
> outer IPv6 packet on the LOCAL_OUT path."
> 
> This sounds like an unrelated issue, I don't know yet how that can
> happen TBH.
> 
>> 8) Remove redundant parsing in nft_exthdr for the tcp options case,
>>     from Fernando F. Mancera.
>>
>> 9) Remove redundant skb_header_pointer() calls in nft_exthdr for tcp
>>     options, from Fernando F. Mancera.
> 
> Sashiko here reports this now drops malformed packets instead of
> NFT_BREAK, which is fine, maybe just extend it to tell about this in
> the patch description.

Hi Pablo,

Should I re-post a v2 of this patch or will you ammend the commit 
message to add this bit?

Thanks,
Fernando.

> 
> I plan to drop the flowtable preparation patches and resubmit.
> 
>> Please, pull these changes from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-10-11
>>
>> Thanks.
>>
>> ----------------------------------------------------------------
>>
>> The following changes since commit a5e7d8e446af9803e37a3b6a4d416fb41178348f:
>>
>>    Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2026-10-05 17:51:32 -0700)
>>
>> are available in the Git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-10-11
>>
>> for you to fetch changes up to b4074bbf5c23b05bd34022ade979f3d5f4e86516:
>>
>>    netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling (2026-10-11 23:29:26 +0200)
>>
>> ----------------------------------------------------------------
>> netfilter pull request 26-10-11
>>
>> ----------------------------------------------------------------
>> Fernando Fernandez Mancera (2):
>>        netfilter: nft_exthdr: remove redundant op parsing in tcp_set_init
>>        netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling
>>
>> Florian Westphal (5):
>>        netfilter: disable br_netfilter in user namespaces
>>        netfilter: conntrack: fix unlikely UaF in gc worker
>>        netfilter: nf_tables: switch chain_types array to rcu
>>        netfilter: add nf_skb_sk helper and use it
>>        netfilter: add nf_sk_to_full_sk helper and use it
>>
>> Jakub Kicinski (1):
>>        selftests: netfilter: nft_queue.sh: only queue icmp echo request/reply
>>
>> Julian Anastasov (1):
>>        ipvs: fix buffer overflow when sending sync messages
>>
>> Lorenzo Bianconi (6):
>>        netfilter: flowtable: recognize IPv4/IPv6 in tunnel proto matching
>>        netfilter: flowtable: set inner protocol when popping tunnel header
>>        netfilter: flowtable: populate tunnel tuple regardless of inner protocol
>>        netfilter: flowtable: add encap_proto to flow_offload_tunnel
>>        netfilter: flowtable: refactor MTU check for tunnel offload
>>        netfilter: flowtable: unify tunnel push for IPv4 and IPv6
>>
>>   Documentation/networking/bridge.rst                |   5 +-
>>   include/linux/netdevice.h                          |   1 +
>>   include/net/netfilter/nf_flow_table.h              |   1 +
>>   include/net/netfilter/nf_socket.h                  |  35 ++++
>>   net/bridge/br_netfilter_hooks.c                    |  33 +++-
>>   net/ipv4/ipip.c                                    |   1 +
>>   net/ipv4/netfilter.c                               |   3 +-
>>   net/ipv6/ip6_tunnel.c                              |   1 +
>>   net/ipv6/netfilter.c                               |   3 +-
>>   net/netfilter/ipvs/ip_vs_sync.c                    |  23 ++-
>>   net/netfilter/nf_conntrack_core.c                  |   5 +
>>   net/netfilter/nf_flow_table_ip.c                   | 215 +++++++++++++--------
>>   net/netfilter/nf_flow_table_path.c                 |   2 +
>>   net/netfilter/nf_tables_api.c                      |  94 ++++++---
>>   net/netfilter/nft_chain_nat.c                      |   1 +
>>   net/netfilter/nft_exthdr.c                         |  34 ++--
>>   net/netfilter/nft_socket.c                         |  16 +-
>>   net/netfilter/xt_socket.c                          |  26 +--
>>   tools/testing/selftests/net/netfilter/nft_queue.sh |   2 +-
>>   19 files changed, 336 insertions(+), 165 deletions(-)
>>
> 

