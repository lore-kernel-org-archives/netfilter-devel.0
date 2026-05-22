Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA883CAA3F
	for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 10:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779445243; cv=none; b=ClgNy4zGZakmJV+NQ5ug7lFjHFKo2aLxB57Vodei4n/DkfBws/X0Tg9s+LhBfO17OX6uTG7R/QTMozyckcYnafc+CAWJPOihgq6Vp1T6Ui4svSmiC2Yqj3TRVsrKUVOrBjKMA4FVznMq5gJOCLOgEMp9EoUyjw+aIhVxTvnm93k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779445243; c=relaxed/simple;
	bh=zYKecUBZ5gKrpfDczolvcCPXeYi0YZYvvlvQwN1P29s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gugBbRN2/P/c4KmHi198x5YaYvdWccmTlfRg/habTa5Xq1WrbAfsRBMuIOpHQ8ix+y/jaOE6QCBFjreefRes5iXXkmp3PUC9IzNmnT2sOksQDdE/2zbibhfaUDkVZmaWKq1sZpWPRWJCeA+St0FCfVGCdcyU0IR8SgcKoizYb+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=01bRPo++; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oTzKHPFO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1gxO77sX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Lfw3S1kQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="01bRPo++";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oTzKHPFO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1gxO77sX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Lfw3S1kQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CACD76B009;
	Fri, 22 May 2026 10:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779445238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LOuZERUGeOgv8YkH+ay5dFqjab1RqReT8WMHvQI91MY=;
	b=01bRPo++2Y9aYYNljc3HjwaXEeUm93QZMcnE5JXu1AIGBUi6bj+JiuUxkIBXScMbpJM68K
	y3EyoaSDOryaEyM4jP1rQc7zYm0TNzBuoeCQOwLeg8Sk/fLwwKyVAmgJVnZjpFazSbcY1B
	q2RYyDfzJ3XGBMZ1XR/c2JDUoslBfu4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779445238;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LOuZERUGeOgv8YkH+ay5dFqjab1RqReT8WMHvQI91MY=;
	b=oTzKHPFOxm22zEpYLy6qKX6A//y5DZeiVsWBHYDWBs2uxim5+RLz9bDCzUPk95xhPHx0Vk
	EiuiUsZwuZ9IFNAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1gxO77sX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Lfw3S1kQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779445237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LOuZERUGeOgv8YkH+ay5dFqjab1RqReT8WMHvQI91MY=;
	b=1gxO77sXvrPaJCZ1fD3ST7xbYe1W4S1egHD0l95UYFTieap85LQzlSV37huJnsARQas92d
	YDtvKNL4OBYRhCFDzGb0AwPFe62C5xS6PreiVFcfknpqqI7m3h3ihRxXD1cBRNwMJrjKyO
	kcFdwfIvjpue/ge3NKdMpxErnOO0LTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779445237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LOuZERUGeOgv8YkH+ay5dFqjab1RqReT8WMHvQI91MY=;
	b=Lfw3S1kQ8UoUlFNHgikW+V+FsEYna7+lWAajFSsWu728uhv0jnpiiZj8r2M4d9A/iKMmLe
	DBNYzRfNcwQMMhDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33575593A8;
	Fri, 22 May 2026 10:20:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8XSBAvUtEGoYeQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 22 May 2026 10:20:37 +0000
Message-ID: <35756825-5349-468c-881f-e88b80f0729b@suse.de>
Date: Fri, 22 May 2026 12:20:35 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: xt_cpu: prefer raw_smp_processor_id
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: syzbot+690d3e3ffa7335ac10eb@syzkaller.appspotmail.com
References: <20260519183430.20726-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260519183430.20726-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: CACD76B009
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TAGGED_RCPT(0.00)[690d3e3ffa7335ac10eb];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim];
	internal_greylist_whitelist(0.00)[2a07:de40:b281:104:10:150:64:97];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 5/19/26 8:34 PM, Florian Westphal wrote:
> With PREEMPT_RCU we get splat:
> 
> BUG: using smp_processor_id() in preemptible [..]
> caller is cpu_mt+0x53/0xd0 net/netfilter/xt_cpu.c:37
> CPU: 1 .. Comm: syz.3.1377 #0 PREEMPT(full)
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>   check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
>   cpu_mt+0x53/0xd0 net/netfilter/xt_cpu.c:37
>   [..]
> 
> Similar to 14d14a5d2957 ("netfilter: nft_meta: use raw_smp_processor_id()").
> 
> Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
> Reported-by: syzbot+690d3e3ffa7335ac10eb@syzkaller.appspotmail.com
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   net/netfilter/xt_cpu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_cpu.c b/net/netfilter/xt_cpu.c
> index 3bdc302a0f91..9cb259902a58 100644
> --- a/net/netfilter/xt_cpu.c
> +++ b/net/netfilter/xt_cpu.c
> @@ -34,7 +34,7 @@ static bool cpu_mt(const struct sk_buff *skb, struct xt_action_param *par)
>   {
>   	const struct xt_cpu_info *info = par->matchinfo;
>   
> -	return (info->cpu == smp_processor_id()) ^ info->invert;
> +	return (info->cpu == raw_smp_processor_id()) ^ info->invert;
>   }
>   
>   static struct xt_match cpu_mt_reg __read_mostly = {


Hi Florian,

I agree with the fix but the same should be needed for xt_NFQUEUE no?

I see I can use the compat layer to configure NFQUEUE target see:

# Warning: table ip filter is managed by iptables-nft, do not touch!
table ip filter {
	chain FORWARD {
		type filter hook forward priority filter; policy accept;
		tcp dport 80 counter packets 0 bytes 0 xt target "NFQUEUE"
	}
}

I would suggest this too:

diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 466da23e36ff..b32d153e3a18 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -91,7 +91,7 @@ nfqueue_tg_v3(struct sk_buff *skb, const struct 
xt_action_param *par)

  	if (info->queues_total > 1) {
  		if (info->flags & NFQ_FLAG_CPU_FANOUT) {
-			int cpu = smp_processor_id();
+			int cpu = raw_smp_processor_id();

  			queue = info->queuenum + cpu % info->queues_total;
  		} else {


Thanks,
Fernando.

