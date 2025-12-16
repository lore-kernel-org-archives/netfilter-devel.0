Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56153390DB1
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765890446; cv=none; b=PC2Jm4qe6PNo2mJ0qL1JCyU8SAottxWrXNPbU4dHXjZAT2373DNM2n9DHc1APPoaKjHIGaISVG5zUwQhoEd+CHDozU2BhT8x2r4fTjsLsVYA0ANirOCwINV4+NT0azcV5xSrrmhLjlWj7+wTNgOZO9nhR8wo5tbY9iqN5e3Xb3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765890446; c=relaxed/simple;
	bh=ArplNCxsoV2kXb/SMCdqsSgak3PK2KH8PBj/ge5nsbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MArWbVrw0NDkopEdqV7oRKcvNfr/7/q+v8JKZyXLIHV2mcTFwBAxqIVcpMvvmWy6dgXSmzPvzdS526PgK2d9qipya0Do5CBMvtRXZCwuTQ4qtrLACaIstxYu+ZbtR7NpuSCuR6dOHwmo+vgSNzuN1daN6E5uAkaJ73aeeiVvw74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=F2J7zS8e; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BIQ6xb9c; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=F2J7zS8e; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BIQ6xb9c; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="F2J7zS8e";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BIQ6xb9c";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="F2J7zS8e";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BIQ6xb9c"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 48C4D5BCCA;
	Tue, 16 Dec 2025 13:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765890441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TGHQgYSIuRzcgafIvTK9gukx6LQl9nTl2eEg7ju2Aak=;
	b=F2J7zS8eaIV5ypLCrF/2wFJs7hC5TmU4RP1tuBVAJu0c+g2SsF/Rnp/H/fBF/KIRAZf1py
	zPPnbugL9q5HNHWcs1hDxyWtwdMb2A/23cdRGa8VQtOR8fTX0JczK6ymlvgCvdqO2B2Kyb
	jfNw0eOeQ7mKn+dxgibwvMHR8QYH66E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765890441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TGHQgYSIuRzcgafIvTK9gukx6LQl9nTl2eEg7ju2Aak=;
	b=BIQ6xb9cHGPU6Y8oTz3rJkvrQ9Tp92vV21esy3CwBnG6vevMhWqHBPqkis/5mJVKwCbkUS
	/XCJ9TcDcJZ8VUBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=F2J7zS8e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BIQ6xb9c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765890441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TGHQgYSIuRzcgafIvTK9gukx6LQl9nTl2eEg7ju2Aak=;
	b=F2J7zS8eaIV5ypLCrF/2wFJs7hC5TmU4RP1tuBVAJu0c+g2SsF/Rnp/H/fBF/KIRAZf1py
	zPPnbugL9q5HNHWcs1hDxyWtwdMb2A/23cdRGa8VQtOR8fTX0JczK6ymlvgCvdqO2B2Kyb
	jfNw0eOeQ7mKn+dxgibwvMHR8QYH66E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765890441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TGHQgYSIuRzcgafIvTK9gukx6LQl9nTl2eEg7ju2Aak=;
	b=BIQ6xb9cHGPU6Y8oTz3rJkvrQ9Tp92vV21esy3CwBnG6vevMhWqHBPqkis/5mJVKwCbkUS
	/XCJ9TcDcJZ8VUBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1301D3EA63;
	Tue, 16 Dec 2025 13:07:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9Oi0AYlZQWk2fwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 16 Dec 2025 13:07:21 +0000
Message-ID: <4683e951-bfff-4351-aad0-57f46fb23b14@suse.de>
Date: Tue, 16 Dec 2025 14:07:09 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nf_conncount: increase connection clean up
 limit to 64
To: Rukomoinikova Aleksandra <ARukomoinikova@k2.cloud>,
 "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Cc: "coreteam@netfilter.org" <coreteam@netfilter.org>
References: <20251216122449.30116-1-fmancera@suse.de>
 <5b08a4a6-4428-4f7b-a448-7cd529801f91@k2.cloud>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <5b08a4a6-4428-4f7b-a448-7cd529801f91@k2.cloud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	URIBL_BLOCKED(0.00)[k2.cloud:email,suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 48C4D5BCCA
X-Spam-Flag: NO
X-Spam-Score: -4.51



On 12/16/25 1:44 PM, Rukomoinikova Aleksandra wrote:
> Hi, thanks so much for fix)
> 

Aleksandra, if you could test it and provide your Tested-by: tag it 
would be quite helpful. I tested this fix with 
nft_connlimit/xt_connlimit and also with OVS zone-limit feature.

> On 16.12.2025 15:24, Fernando Fernandez Mancera wrote:
>> After the optimization to only perform one GC per jiffy, a new problem
>> was introduced. If more than 8 new connections are tracked per jiffy the
>> list won't be cleaned up fast enough possibly reaching the limit
>> wrongly.
>>
>> In order to prevent this issue, increase the clean up limit to 64
>> connections so it is easier for conncount to keep up with the new
>> connections tracked per jiffy rate.
>>
>> Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
>> Reported-by: Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>
>> Closes: https://lore.kernel.org/netfilter/b2064e7b-0776-4e14-adb6-c68080987471@k2.cloud/
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> ---
>>    net/netfilter/nf_conncount.c | 9 +++++----
>>    1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
>> index 3654f1e8976c..ec134729856f 100644
>> --- a/net/netfilter/nf_conncount.c
>> +++ b/net/netfilter/nf_conncount.c
>> @@ -34,8 +34,9 @@
>>    
>>    #define CONNCOUNT_SLOTS		256U
>>    
>> -#define CONNCOUNT_GC_MAX_NODES	8
>> -#define MAX_KEYLEN		5
>> +#define CONNCOUNT_GC_MAX_NODES		8
>> +#define CONNCOUNT_GC_MAX_COLLECT	64
>> +#define MAX_KEYLEN			5
>>    
>>    /* we will save the tuples of all connections we care about */
>>    struct nf_conncount_tuple {
>> @@ -187,7 +188,7 @@ static int __nf_conncount_add(struct net *net,
>>    
>>    	/* check the saved connections */
>>    	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
>> -		if (collect > CONNCOUNT_GC_MAX_NODES)
>> +		if (collect > CONNCOUNT_GC_MAX_COLLECT)
>>    			break;
>>    
>>    		found = find_or_evict(net, list, conn);
>> @@ -316,7 +317,7 @@ static bool __nf_conncount_gc_list(struct net *net,
>>    		}
>>    
>>    		nf_ct_put(found_ct);
>> -		if (collected > CONNCOUNT_GC_MAX_NODES)
>> +		if (collected > CONNCOUNT_GC_MAX_COLLECT)
>>    			break;
>>    	}
>>    
> 
> 

