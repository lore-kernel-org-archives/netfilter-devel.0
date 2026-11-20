Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795172468;
	b=Su+WLwJKEvd0RfniwehDXs5XJfGqfvHiRwOEYDvDd/uq9r0DYzALJTrMTrXBzBXc7yly
	 3q9GT8YjMqqK8DP/7aB40awMHdKCrqUzQ9Ygqygcqo8NZs9+omPn1r4igfnHnL6Eysade
	 aQNU9a4bqXb6x09SV4qKrrJTUlbPj5nW9tHsDE4NoY4PhaygEJf87zlPrxlMIgioTQ0lA
	 t2WZ7XdkW7/E2ymRpI8qRgCStwUI0eMqnIw0FRrTV7n2GiJIwWU9VxK8+NlsjS6KTKs5a
	 LYPdcm8eVJd+L2wlBujPpMoTS1CGY428AsDfoxIHTx16Rg/TgxvGZmAqQV/KSwLoC4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172468;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=Uf+/EdEL7JPB/0l1SJZyw/OKDRO9feHxkTVo/cD1+t4=;
	b=n1eRBD15/G3PZc5zFEsDscEQbaihAEG6KP4uK7atI+w5GoMOaPVGuZ+FBT1j/tw4YVzZ
	 p+FBxQz1YmXST2mNxyl9KxUuxy6lguG1x0WRyA5eXp3XvkW7N6LFD99vC7OA14hLx1yuk
	 cr/SH+pK3Eq28W07qCHrgzVBwWYkpL76sTYL+7OftvrTpSTgHyCcHjAEYBF0NL0sfOt7P
	 G/OeHgMkFVRL33Sv6OdR9gdcQf4hMOu3EtWOMbpR/Obu5npxlNSc2iLhP+IEgVHEIyH8l
	 sqaQTolIL+hWP3KnYxj5dpmGB605tZxEKcQf6kVS+HHA2SbnImUhF/xSKY0WFdHRB2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vudTzhJP;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fSDrjOne;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1mSu2OUI;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qvYcOky0;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E497606A320;
	Fri, 20 Nov 2026 11:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E497606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vudTzhJP;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fSDrjOne;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1mSu2OUI;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qvYcOky0
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0F3822258D;
	Fri, 20 Nov 2026 11:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795172466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uf+/EdEL7JPB/0l1SJZyw/OKDRO9feHxkTVo/cD1+t4=;
	b=vudTzhJPUj2RIlkrgT6d1STBxe6jUpqQdk4hHolBEhm56LMH7zD8gfqQSi7CtyUB6NarKS
	PFibV7YWaOHfWf6iIGnN6x94DSj280TwdKNX1n7iNijGv/+nEYzoE791djl/V7FuxSxlvS
	iNK7k45+jbDTEn9l6zj3Q6ynEaEpqY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795172466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uf+/EdEL7JPB/0l1SJZyw/OKDRO9feHxkTVo/cD1+t4=;
	b=fSDrjOnepEtaZMUHGwfXzhtGRliEbvPtyIvNC9LNvN9I/BSyUZCyH0oYbR4xU58F46+heN
	KAH8Oxco3bs2IwCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1mSu2OUI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qvYcOky0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795172465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uf+/EdEL7JPB/0l1SJZyw/OKDRO9feHxkTVo/cD1+t4=;
	b=1mSu2OUICDfDL/lQOrikeDEjkPCqZBX3otAbIOF22DOKdcP7LfnaPePBoSZsJTqriat0ZB
	bRMdgjyjCMYb4wNv+UwsEUh0F15dfzrUtPLXDmXRP/hcA6qlDOHCugN80C+Ll4jTVufks1
	EQY8HAtnshE68L32+X+UHU50hZH6H1w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795172465;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uf+/EdEL7JPB/0l1SJZyw/OKDRO9feHxkTVo/cD1+t4=;
	b=qvYcOky0XG7nMWFQI7HsyFg06k/Ty38jHdMNYrzhZ4hmErlo6bfiImwKI8SviEmpvppLTZ
	pt7n+KpX3FFzuTCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DCAF1342D;
	Fri, 20 Nov 2026 11:01:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NpUWDHAoAGsiVwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 20 Nov 2026 11:01:04 +0000
Message-ID: <e2349ba1-454a-4f1c-b7af-d71ff984a693@suse.de>
Date: Fri, 20 Nov 2026 12:00:55 +0100
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
Subject: Re: [PATCH] netfilter: bpf: reject a repeated bpf_ct_set_nat_info()
To: Andrey Misiurov <amisiurov@cloudlinux.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org
References: <20261119163328.878804-1-amisiurov@cloudlinux.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261119163328.878804-1-amisiurov@cloudlinux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0F3822258D
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,cloudlinux.com:email,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 11/19/26 5:33 PM, Andrey Misiurov wrote:
> bpf_ct_set_nat_info() checks the l3 protocol and the manip type but not
> whether NAT for that manip was already set up. A BPF program holding an
> unconfirmed nf_conn___init can call it twice with the same manip. The first
> call sets IPS_SRC_NAT_DONE (or IPS_DST_NAT_DONE); the ct is still
> unconfirmed, so the second call passes the confirmed check and reaches

What confirmed check passes? I think there is no such check at all.

> WARN_ON(nf_nat_initialized()) in nf_nat_setup_info():
> 
>    WARNING: CPU: 1 PID: 21673 at net/netfilter/nf_nat_core.c:674 nf_nat_setup_info+0x251/0x2b0 [nf_nat]
>    CPU: 1 PID: 21673 Comm: loader
>    RIP: 0010:nf_nat_setup_info+0x251/0x2b0 [nf_nat]
>    Call Trace:
>     bpf_ct_set_nat_info+0x81/0xb0 [nf_nat]
>     bpf_prog_e4b00ba35d2f7a6b_nf_skb_ct_nat_twice+0x110/0x13f
>     bpf_test_run+0x172/0x2e0
>     bpf_prog_test_run_skb+0x2e5/0x4f0
>     __sys_bpf+0x7f8/0xe90
>     __x64_sys_bpf+0x1a/0x30
>     do_syscall_64+0x5f/0xe0
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> With panic_on_warn this is a DoS. It is the same BPF-reachable WARN class
> that 16d464013ec2 closed for an invalid manip value; the repeated-setup
> case was left open.

Yes, although this is a completely different issue.

> 
> Reject the call with -EEXIST when NAT for that manip is already initialised,
> before nf_nat_setup_info() is reached.
> 
> Fixes: 16d464013ec2 ("netfilter: bpf: reject invalid NAT manipulation types")

I think this fixes tag is incorrect. That fix was checking a completely 
different problem. In any case it would be:

Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")

> Signed-off-by: Andrey Misiurov <amisiurov@cloudlinux.com>
> ---
> Found during a backport review.
> 
> Reproduced on almalinux9 5.14.0-687.61.1 with a BPF_PROG_TEST_RUN SCHED_CLS
> prog that calls bpf_ct_set_nat_info() with NF_NAT_MANIP_SRC twice: without
> the fix the second call returns -ENOMEM and WARNs as above; with the fix it
> returns -EEXIST and there is no WARN.
> 
>   net/netfilter/nf_nat_bpf.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/nf_nat_bpf.c b/net/netfilter/nf_nat_bpf.c
> --- a/net/netfilter/nf_nat_bpf.c
> +++ b/net/netfilter/nf_nat_bpf.c
> @@ -42,6 +42,10 @@
>   	if (manip != NF_NAT_MANIP_SRC && manip != NF_NAT_MANIP_DST)
>   		return -EINVAL;
>   
> +	/* a repeated manip on an unconfirmed ct would WARN */

This comment is a bit too verbose. Can we just drop it? The check is 
simple enough to be self-documented.

In addition, please use [PATCH nf] for the next revision of this patch 
so we know we tree should we use for the fix.

Thanks,
Fernando.

> +	if (nf_nat_initialized(ct, manip))
> +		return -EEXIST;
> +
>   	memset(&range, 0, sizeof(struct nf_nat_range2));
>   	range.flags = NF_NAT_RANGE_MAP_IPS;
>   	range.min_addr = *addr;

