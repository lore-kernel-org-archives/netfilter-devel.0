Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AD036D4E7
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 00:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684195; cv=none; b=SnN3mnAh7AnLrPrFn+o08zna4wo3CwxIjvqvWdpwEuA8gEpOxZqzZxD55krIwWV2dsOcuBzfxbf29oQ8dIW8AUpuhHjRoTw6LwhyQ0t6RN9jnS4RQYdNDNiTspaXwEtatRg0TG1aexWtnlvQl6QdhCt2fPOanhkVK0gST5BaVqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684195; c=relaxed/simple;
	bh=1LnVyZTDz1rmPxyEojklHzQ+dEx7IbqmT74DhMx6Bu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CKdK3IaLwavz6sPsu4F90SPNgTDlQDOM93XbtuUE/iz2YIk5EIMstApNe4lFTbEKpDKx5c90fiElJwDDFdQcaG5SkSiD5HwL6jdunKEoF8jpOO0gp16iNkA6qjKmCNYexWZcg5gI+VTFN+F2XDX1v4Lf1g9NF0sItt+dW5pI50I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TvvEqH1y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rFpydp4u; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TvvEqH1y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rFpydp4u; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TvvEqH1y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rFpydp4u";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TvvEqH1y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rFpydp4u"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D54720CF6;
	Fri, 21 Nov 2025 00:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763684191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e6AfKK4hv5UFG2UfKnm87X/FByU++U7443rsAbSuEA8=;
	b=TvvEqH1ySuF30ulWOQHA7ll5t56SoPwPQog5m6gJa/iYr8bLNb4rf8YD2W0JyFqUo4dIj3
	hJxXHFJH1FcRx+5/mhXfRQZ0fZKT6F8tH4KaYBhnDE0SFAHOSjUUSL8CXIBBAEJKEiLMLv
	vmcoxsUEr4SXgRKO+62OygepOyZSl5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763684191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e6AfKK4hv5UFG2UfKnm87X/FByU++U7443rsAbSuEA8=;
	b=rFpydp4u1uuLfVajYS1U3o5sxnaLMBFuToNlKJJFjKsjum5IxPtDn1vouWrq9Xyw5bhJIM
	2HXyohDpVyoj0BCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TvvEqH1y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rFpydp4u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763684191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e6AfKK4hv5UFG2UfKnm87X/FByU++U7443rsAbSuEA8=;
	b=TvvEqH1ySuF30ulWOQHA7ll5t56SoPwPQog5m6gJa/iYr8bLNb4rf8YD2W0JyFqUo4dIj3
	hJxXHFJH1FcRx+5/mhXfRQZ0fZKT6F8tH4KaYBhnDE0SFAHOSjUUSL8CXIBBAEJKEiLMLv
	vmcoxsUEr4SXgRKO+62OygepOyZSl5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763684191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e6AfKK4hv5UFG2UfKnm87X/FByU++U7443rsAbSuEA8=;
	b=rFpydp4u1uuLfVajYS1U3o5sxnaLMBFuToNlKJJFjKsjum5IxPtDn1vouWrq9Xyw5bhJIM
	2HXyohDpVyoj0BCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A0993EA61;
	Fri, 21 Nov 2025 00:16:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S0yFIl6vH2n0dAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 21 Nov 2025 00:16:30 +0000
Message-ID: <bfb59b17-2c95-4790-a442-522cda9846eb@suse.de>
Date: Fri, 21 Nov 2025 01:16:14 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6 nf-next v3] netfilter: rework conncount API to receive
 sk_buff directly
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
 phil@nwl.cc, aconole@redhat.com, echaudro@redhat.com, i.maximets@ovn.org
References: <20251112114351.3273-2-fmancera@suse.de>
 <aR-nlkm8RrHZsCbP@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aR-nlkm8RrHZsCbP@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1D54720CF6
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 



On 11/21/25 12:43 AM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Wed, Nov 12, 2025 at 12:43:46PM +0100, Fernando Fernandez Mancera wrote:
>> This series is fixing two different problems. The first issue is related
>> to duplicated entries when used for non-confirmed connections in
>> nft_connlimit and xt_connlimit. Now, nf_conncount_add() checks whether
>> the connection is confirmed or not. If the connection is confirmed,
>> skip the add.
>>
>> In order to do that, nf_conncount_count_skb() and nf_conncount_add_skb()
>> API has been introduced. They allow the user to pass the sk_buff
>> directly. The old API has been removed.
>>
>> The second issue this series is fixing is related to
>> nft_connlimit/xt_connlimit not updating the list of connection for
>> confirmed connections breaking softlimiting use-cases like limiting the
>> bandwidth when too many connections are open.
>>
>> This has been tested with nftables and iptables both in filter and raw
>> priorities. I have stressed the system up to 2000 connections.
>>
>> CC'ing openvswitch maintainers as this change on the API required me to
>> touch their code. I am not very familiar with the internals of
>> openvswitch but I believe this should be fine. If you could provide some
>> testing from openvswitch side it would be really helpful.
>>
>> Fernando Fernandez Mancera (6):
>>    netfilter: nf_conncount: introduce new nf_conncount_count_skb() API
>>    netfilter: xt_connlimit: use nf_conncount_count_skb() directly
>>    openvswitch: use nf_conncount_count_skb() directly
>>    netfilter: nf_conncount: pass the sk_buff down to __nf_conncount_add()
> 
> I have collapsed this four patches initial patches (1-4) to see how it
> looks:
> 
>   include/net/netfilter/nf_conntrack_count.h |   17 ++++-----
>   net/netfilter/nf_conncount.c               |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
>   net/netfilter/nft_connlimit.c              |   21 +----------
>   net/netfilter/xt_connlimit.c               |   14 +------
>   net/openvswitch/conntrack.c                |   16 ++++----
>   5 files changed, 133 insertions(+), 94 deletions(-)
> 
> It is a bit large, but I find it easier to understand the goal,
> because this patch is pushing down the skb into the conncount core and
> adapting callers at the same time, which is what Florian suggested.
> 
> Then, another patch to add the special -EINVAL case for already
> confirmed conntracks that is in patch 6/6 in this series. This is to
> deal with the new use-case of using ct count really for counting, not
> just for limiting.
> 
> Finally, the gc consolidation.
> 

All looks good to me, except the gc consolidation must be before the 
nft_connlimit one.. otherwise nft_connlimit would be calling it without 
disabling bh. Anyway, I just sent a v4 with the collapsed patches, 
commit description adjusted and the correct ordering for the last two 
patches.

Thanks,
Fernando.

> I pushed it to this branch in nf-next.git,
> 
>          https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git/log/?h=tentative-conncount-series
> 
> NOTE: commit messages would need an adjustment.
> 
> Sidenote: Not related, but connlimit does not work for bridge and
> netdev families because of nft_pf(). This relates to another topic
> that is being discussing about how to handle vlan/pppoe packets.
> **No need to address this series**, just mentioning it.
> 

Yes, I will need to look into this during the next release cycle I 
guess. Thanks for mentioning it.

