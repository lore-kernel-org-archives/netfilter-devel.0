Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93662E88B6
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 11:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762255562; cv=none; b=Rdp3KR4wCSFuoD906iI609O90K5eGKqi2eq6IQMeRv4XIrZf5DlSkJ/USFabZWIeWRvq8FLpcUHaOpXlxz+SK8obCGdmeAF7bGxvdA+q68iHT7BKDXQOXSEjrSb7Fr6h9w5oJdgB73UxJBfYjNLY8RYzGDvLYeLI2O++Eqcz4JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762255562; c=relaxed/simple;
	bh=C+dwOfsuu31yyQbNcF/MprANJl2/S2Qka1QJsyNd9t8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=atoWD+eMMhi/hlDZNERRWjcAADIqe+DorNiyDnDVm87e15hGNbxR4t/N1daPy34eoDbPUq+9Jq//p8+keuX5Dbg+eRG+9PT3+SxYLoJQjxfkaxPYnwepNCw0E54g/fvGRbklPsqJnkTirMLO3Q6qrb6WvC4oz1K+Fu+4HJtu27Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zJUJx+Xm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kMSOG7O3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zJUJx+Xm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kMSOG7O3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zJUJx+Xm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kMSOG7O3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zJUJx+Xm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kMSOG7O3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 08CFE1F385;
	Tue,  4 Nov 2025 11:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762255558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WCjc84LnifBt6m3MhbT96HZJs5R/zKC0nWdO+OKQGvA=;
	b=zJUJx+XmQhPy+SgZdcnJA7tWFoaBasA9V40OwGPZibyRmWIs1NQ4+/dYWIacDQZJUDv1Ik
	qeABNTVOb+sy56BrUHNy1vareOgStJgsAFtcG2X3B43uJFOMSwLhS2FMFD6JNIvlzhsz8S
	VoRkMxy7ftbxz//5pgl4PInTE6qHJMk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762255558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WCjc84LnifBt6m3MhbT96HZJs5R/zKC0nWdO+OKQGvA=;
	b=kMSOG7O3J45oR1Bf0yYCZ/IMgdGexhCJ2/W0u6WZMFJtjn1ZaUqSBv0FsWxOR2mbDjTm9z
	nHiimxobEVtZETBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zJUJx+Xm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kMSOG7O3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762255558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WCjc84LnifBt6m3MhbT96HZJs5R/zKC0nWdO+OKQGvA=;
	b=zJUJx+XmQhPy+SgZdcnJA7tWFoaBasA9V40OwGPZibyRmWIs1NQ4+/dYWIacDQZJUDv1Ik
	qeABNTVOb+sy56BrUHNy1vareOgStJgsAFtcG2X3B43uJFOMSwLhS2FMFD6JNIvlzhsz8S
	VoRkMxy7ftbxz//5pgl4PInTE6qHJMk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762255558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WCjc84LnifBt6m3MhbT96HZJs5R/zKC0nWdO+OKQGvA=;
	b=kMSOG7O3J45oR1Bf0yYCZ/IMgdGexhCJ2/W0u6WZMFJtjn1ZaUqSBv0FsWxOR2mbDjTm9z
	nHiimxobEVtZETBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2F6E139A9;
	Tue,  4 Nov 2025 11:25:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /y1lKMXiCWnvEgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 04 Nov 2025 11:25:57 +0000
Message-ID: <08bd5858-9a07-4da8-9d31-d685cbf0eea4@suse.de>
Date: Tue, 4 Nov 2025 12:25:51 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v3] netfilter: nft_connlimit: fix duplicated tracking
 of a connection
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org
References: <20251031130837.8806-1-fmancera@suse.de>
 <aQng8WtxoVMaABLs@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aQng8WtxoVMaABLs@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 08CFE1F385
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51



On 11/4/25 12:18 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> Connlimit expression can be used for all kind of packets and not only
>> for packets with connection state new. See this ruleset as example:
>>
>> table ip filter {
>>          chain input {
>>                  type filter hook input priority filter; policy accept;
>>                  tcp dport 22 ct count over 4 counter
>>          }
>> }
>>
>> Currently, if the connection count goes over the limit the counter will
>> count the packets. When a connection is closed, the connection count
>> won't decrement as it should because it is only updated for new
>> connections due to an optimization on __nf_conncount_add() that prevents
>> updating the list if the connection is duplicated.
>>
>> In addition, since commit d265929930e2 ("netfilter: nf_conncount: reduce
>> unnecessary GC") there can be situations where a duplicated connection
>> is added to the list. This is caused by two packets from the same
>> connection being processed during the same jiffy.
>> +	if (!ct || !nf_ct_is_confirmed(ct)) {
>> +		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
>> +			regs->verdict.code = NF_DROP;
>> +			return;
>> +		}
> 
> This means the bug fix won't work when this is hooked before
> conntrack.
> 
>> diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
>> index 0189f8b6b0bd..5c90e1929d86 100644
>> --- a/net/netfilter/xt_connlimit.c
>> +++ b/net/netfilter/xt_connlimit.c
>> @@ -69,8 +69,18 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>   		key[1] = zone->id;
>>   	}
>>   
>> -	connections = nf_conncount_count(net, info->data, key, tuple_ptr,
>> -					 zone);
>> +	if (!ct || !nf_ct_is_confirmed(ct)) {
>> +		connections = nf_conncount_count(net, info->data, key, tuple_ptr,
>> +						 zone);
> 
> Same here, but usage in -t raw is legal/allowed.
> 
> I would suggest to rework this api so that this always passes in
> struct nf_conn *ct, either derived from sk_buff or obtained via
> nf_conntrack_find_get().
> 
> The net, tuple_ptr, and zone argument would be obsoleted and
> replaced with nf_conn *ct arg.
> 
> This allows the nf_conncount internals to always skip the
> insertion for !confirmed case, and the existing suppression
> for same-jiffy collect could remain in place as well.
> 
> Its more work but since this has been broken forever I don't
> think we need a urgent/small fix for this.

Fair enough, I will handle this in a bigger patch aimed for nf-next 
then. I do not think we should touch the API on 6.18 given we are at rc4 
already.
