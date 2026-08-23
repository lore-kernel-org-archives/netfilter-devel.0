Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE732F693B;
	Sun, 23 Aug 2026 17:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787506655; cv=none; b=t04BCz2dvPeHWAd7EcnBiHHuldj1oWd8GZ1QJQUBLzsybJvyWkPilk/vUF3Yk5rFY/WaZauGtnOc+brkJJidV+25aPQp7DlA8OZTW3DU2IKvfP+kP8bxIpFNHBNzQVAa15uZbqLFXZZ7NjsYpzPs8GfOs52mvEHkYEiTJ96fDdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787506655; c=relaxed/simple;
	bh=jG22L5f2P1rIBR7jfV20CBvuPd9BU82NjHCemViNrwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CPERq5+IgMRD8K/NXObQe0J/clHogGAXeu00N0UvMVe0clsRrFD1M95nwggvYFri2zWCEG8Zbv6j83OqljjEjuwKoR033FKqyuPzVPvSmq/WmjXzbSuH8QTbYsqBo+agqLqy0A7GvL2MwDJ9CP1ijIdRkAKR38dgXjyCRktPrIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oqQ4cIgS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WCxgppjr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wKhzLl9P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fn/hEGc0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oqQ4cIgS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WCxgppjr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wKhzLl9P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fn/hEGc0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7A5D386466;
	Sun, 23 Aug 2026 17:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787506647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJ9rwPgU84Y78qa/zDD9kIClhwNRKRJnBFUV1+JnGVw=;
	b=oqQ4cIgSBQ5OEayjijalPlXj/1V8butCH0ymsXEklKjZoMMK5nNkT/7g4yICALDsx21fwT
	yaK+ETfNUJtFjmSkDx1NOqP2KV+5nedCHbhPjUcnFFK3Riqt7p4sxN8rI4felV2GPxVon6
	uckfa6EIVV2/LruiFEpfAh5wmsEGBmo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787506647;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJ9rwPgU84Y78qa/zDD9kIClhwNRKRJnBFUV1+JnGVw=;
	b=WCxgppjrHK2mRp6Br/IJjk+6GWdrj74axsZl6/d2AlWR+lPHFFEUNBuyKgGLgsNazQ8xul
	agREMWOp4f/juwCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wKhzLl9P;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="fn/hEGc0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787506643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJ9rwPgU84Y78qa/zDD9kIClhwNRKRJnBFUV1+JnGVw=;
	b=wKhzLl9P4LhGkVagfRn9DLBkgaznwaDEufQYJWyOWcHvLuHGCj1dg/99+gG7edhmN55f2c
	io7DwbtOC5LyLvIGG4tJwNpQH/ebwGHDQje3Bqfo5xuBFE0bi+ll2qcNcPrrH0Xlpp+d1I
	3EUrilNxu319CJ/tPjmpRNiVIZE9KRo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787506643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJ9rwPgU84Y78qa/zDD9kIClhwNRKRJnBFUV1+JnGVw=;
	b=fn/hEGc0ShGG1W/qqK1ScGA4aZ/uL1R7EBTYigtZ+m7lvF61+T/NZX5MOkjUthk3RXqlBN
	fxkg0y954fXhm7DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E982513325;
	Sun, 23 Aug 2026 17:37:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bPwxNtIvi2p8ZwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 23 Aug 2026 17:37:22 +0000
Message-ID: <456872c2-d5ee-4951-aac6-2573cfb6b585@suse.de>
Date: Sun, 23 Aug 2026 19:36:48 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 08/10] netfilter: nf_tables: fix device name and
 prefix match in hook lookup
To: Jakub Kicinski <kuba@kernel.org>, pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
References: <20260821153833.245589-9-pablo@netfilter.org>
 <20260822195230.2202763-1-kuba@kernel.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260822195230.2202763-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 7A5D386466
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On 8/22/26 9:52 PM, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: nf_tables: fix device name and prefix match in hook lookup
> 
> This changes nft_hook_list_find() so a hook spec only matches another
> spec of the same kind (prefix vs exact name) and the same length,
> replacing the previous strncmp() over min(hook->ifnamelen,
> this->ifnamelen).  hook_is_prefix() also gains a const argument.
> 
> Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
> 
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index 20c562174b278..d160f6ea0dc29 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
> 
> [ ... ]
> 
>> @@ -2445,8 +2445,11 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
>>   	struct nft_hook *hook;
>>   
>>   	list_for_each_entry(hook, hook_list, list) {
>> -		if (!strncmp(hook->ifname, this->ifname,
>> -			     min(hook->ifnamelen, this->ifnamelen))) {
>> +		if (hook_is_prefix(hook) != hook_is_prefix(this))
>> +			continue;
>> +		if (hook->ifnamelen != this->ifnamelen)
>> +			continue;
>> +		if (!strncmp(hook->ifname, this->ifname, hook->ifnamelen)) {
>>   			if (hook->flags & NFT_HOOK_REMOVE)
>>   				continue;
>>   
> 
> [Severity: Critical]
> nft_hook_list_find() has two callers with different expectations, and this
> turns it into a pure identity comparator for both.  The delete/get paths
> (nf_tables_delchain_hook(), nft_flowtable_del_hook()) want identity, but
> the add paths use it as an overlap rejector:
> 
> nf_tables_parse_netdev_hooks()
> 	if (nft_hook_list_find(hook_list, hook)) {
> 		NL_SET_BAD_ATTR(extack, tmp);
> 		nft_netdev_hook_free(hook);
> 		err = -EEXIST;
> 		goto err_hook;
> 	}
> 
> and the same in nf_tables_updchain(), nft_register_flowtable_net_hooks()
> and nft_flowtable_update().
> 
> The Fixes-referenced commit 6d07a289504a states the min() compare was
> deliberate: "When checking for duplicate hooks, compare the shortest
> prefix so a device may never match more than a single hook spec."  Does
> this change intentionally drop that invariant?
> 
> Concretely, is this still rejected after the patch?
> 
>    nft add chain netdev t c \
>      '{ type filter hook ingress devices = { "eth*", "eth0" } ; }'
> 
> Before, prefix "eth" (ifnamelen 3) and exact "eth0" (ifnamelen 5) matched
> via strncmp(..., min(3, 5)) and gave -EEXIST.  Now
> hook_is_prefix(hook) != hook_is_prefix(this) short-circuits, so both hooks
> end up in the same hook_list.  Prefix "eth" versus prefix "eth0" is
> likewise separated by the ifnamelen compare.
> 
> nft_netdev_hook_alloc() then builds one nf_hook_ops per matching netdev
> per hook:
> 
> 	for_each_netdev(net, dev) {
> 		if (strncmp(dev->name, hook->ifname, hook->ifnamelen))
> 			continue;
> 		...
> 		ops->dev = dev;
> 		list_add_tail(&ops->list, &hook->ops_list);
> 	}
> 
> so two distinct nft_hook objects each own an ops with ops->dev == eth0,
> and nft_netdev_register_hooks() registers both.  nf_hook_entries_grow()
> only rejects duplicates for NF_HOOK_OP_BPF, so both land in
> eth0->nf_hooks_ingress and the base chain is evaluated twice per packet.
> For flowtables the cross-flowtable -EEXIST guard in
> nft_register_flowtable_net_hooks() is bypassed the same way, so the same
> device gets two FLOW_BLOCK_BIND calls.
> 
> Can this also leave a dangling struct net_device pointer?  Both notifier
> loops service only the first hook that owns an ops for the device, because
> of the unconditional break after the switch:
> 
> net/netfilter/nft_chain_filter.c:nft_netdev_event() {
> 	list_for_each_entry(hook, &basechain->hook_list, list) {
> 		ops = nft_hook_find_ops(hook, dev);
> 		...
> 		switch (event) {
> 		case NETDEV_UNREGISTER:
> 			...
> 			nf_unregister_net_hook(dev_net(dev), ops);
> 			list_del_rcu(&ops->list);
> 			kfree_rcu(ops, rcu);
> 			break;
> 		...
> 		}
> 		break;
> 	}
> 	return 0;
> }
> 
> nft_flowtable_event() in nf_tables_api.c has the same trailing break.  On
> ip link del eth0 only the first hook's ops is unregistered and freed; the
> second hook keeps a registered nf_hook_ops whose ops->dev points at the
> device that is then freed, since nf_hook_ops holds no device reference.
> 
> A later teardown (nft delete chain, nft delete table, dormant toggle,
> netns exit) walks every ops:
> 
> net/netfilter/nf_tables_api.c:nft_netdev_unregister_hooks() {
> 	list_for_each_entry_safe(hook, next, hook_list, list) {
> 		if (!(table->flags & NFT_TABLE_F_DORMANT)) {
> 			list_for_each_entry(ops, &hook->ops_list, list)
> 				nf_unregister_net_hook(net, ops);
> 		}
> 	...
> }
> 
> and __nf_unregister_net_hook() reaches nf_hook_entry_head(net, pf,
> reg->hooknum, reg->dev), which does dev_net(dev) and returns
> &dev->nf_hooks_ingress, i.e. a read and then a write through the stale
> pointer.  For flowtables, nft_unregister_flowtable_ops() additionally
> calls ->setup(..., ops->dev, FLOW_BLOCK_UNBIND) on the freed device.  The
> orphaned nf_hook_entries blob is also leaked.
> 
> On NETDEV_REGISTER the same break means only one of two covering hooks
> gains an ops, so the other stays permanently unhooked.
> 
> Would it work to keep the strict identity match only for the
> delete/update lookups and retain the prefix-overlap semantics for the
> add/-EEXIST paths, e.g. as two separate helpers?  Alternatively, should
> the unconditional break in nft_netdev_event() and nft_flowtable_event()
> be dropped so every matching hook is serviced?
> 
> The commit message describes only the delete/update lookup semantics; the
> fact that configurations previously rejected with -EEXIST are now
> accepted is not mentioned.  Could that be spelled out?
> 

Hi,

About the add path it was intended, what it wasn't is the UAF. The AI 
review managed to catch it. Btw, sashiko.dev didn't catch it, it seems 
the NIPA instance is managing to catch more subtle bugs.

This patch needs a V2 enforcing an exact match on delete/update path 
while using the current approach on the add path. I am sending one 
tomorrow first thing in the morning.

Thanks,
Fernando.
