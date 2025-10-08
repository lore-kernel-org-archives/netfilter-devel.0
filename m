Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A9F1D95A3
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 11:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759922245; cv=none; b=JABrX8+ZQBffXEGX8F/6XaOrEBchOnweQtc/cqMqSOhCn0I1t7OpFDhabiUwGT8DGyS7PVJR6QOOftYgaMIeMN+p3JzG9vJfhMcMmfVFngOBONTKAVXABcBR6E6MJeLzsQkUQt0kRb1driOwJZJQ3LxcRas7qcy8l1Y0OcT3RNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759922245; c=relaxed/simple;
	bh=yz893bIQkRA0fNUfsvp98jRBgSGFHCphc9SEUCjEgy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sl98gO6w3/z5ytViLhrSPNsyd5QhqDzGTg+h3zvZ9BnpuZeZGQVqfMdaULcNfhEcgWubT0BUzb4AuHWTFjmIuKbOTmKQgc01CUHr8Jr1vDSq8A54wUUAjPrx/kCzVT38/su+w2E/NIIzKrH98bw4QuIZlU64J9hc0lcj3celRPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nlVHGirh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=91hoJwDx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nlVHGirh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=91hoJwDx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nlVHGirh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="91hoJwDx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nlVHGirh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="91hoJwDx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 50A7222709;
	Wed,  8 Oct 2025 11:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759922241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=naOq/hPpc6lRmVOvGQVD8Uc7/rBi/fBfB+pPOP+p7cE=;
	b=nlVHGirhR3Sp1ugPQxjJMIB0V1mVkLWjACm23lm01IEh9x7dHU2BYASZsofICxB6RRszC7
	QP2izQuYETBr5VGuDiwxH7wrJquJO4a22uPwrKt41Z2oSTY2yLL8J939hQw1SHQ7CX1Ovx
	ZwvkYb27lB4XjOe5X9inmON/+q/YFXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759922241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=naOq/hPpc6lRmVOvGQVD8Uc7/rBi/fBfB+pPOP+p7cE=;
	b=91hoJwDx3zGm+heyr1F2K2ihewyQGYygj3eWOwit1mjGn7JiWOXiy8c3I+fazAqYBxNEPi
	57Cx3fc/MG/maRBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nlVHGirh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=91hoJwDx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759922241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=naOq/hPpc6lRmVOvGQVD8Uc7/rBi/fBfB+pPOP+p7cE=;
	b=nlVHGirhR3Sp1ugPQxjJMIB0V1mVkLWjACm23lm01IEh9x7dHU2BYASZsofICxB6RRszC7
	QP2izQuYETBr5VGuDiwxH7wrJquJO4a22uPwrKt41Z2oSTY2yLL8J939hQw1SHQ7CX1Ovx
	ZwvkYb27lB4XjOe5X9inmON/+q/YFXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759922241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=naOq/hPpc6lRmVOvGQVD8Uc7/rBi/fBfB+pPOP+p7cE=;
	b=91hoJwDx3zGm+heyr1F2K2ihewyQGYygj3eWOwit1mjGn7JiWOXiy8c3I+fazAqYBxNEPi
	57Cx3fc/MG/maRBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0100013693;
	Wed,  8 Oct 2025 11:17:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e/7NOEBI5mi1JAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 08 Oct 2025 11:17:20 +0000
Message-ID: <4d26f257-a101-4245-a260-03b228252290@suse.de>
Date: Wed, 8 Oct 2025 13:17:12 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2] netfilter: nft_objref: validate objref and
 objrefmap expressions
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
 Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
References: <20251008100816.8526-1-fmancera@suse.de>
 <aOZG4TEch18WK7mQ@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aOZG4TEch18WK7mQ@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,suse.com:email,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 50A7222709
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51



On 10/8/25 1:11 PM, Pablo Neira Ayuso wrote:
> On Wed, Oct 08, 2025 at 12:08:16PM +0200, Fernando Fernandez Mancera wrote:
>> Referencing a synproxy stateful object from OUTPUT hook causes kernel
>> crash due to infinite recursive calls:
>>
>> BUG: TASK stack guard page was hit at 000000008bda5b8c (stack is 000000003ab1c4a5..00000000494d8b12)
>> [...]
>> Call Trace:
>>   __find_rr_leaf+0x99/0x230
>>   fib6_table_lookup+0x13b/0x2d0
>>   ip6_pol_route+0xa4/0x400
>>   fib6_rule_lookup+0x156/0x240
>>   ip6_route_output_flags+0xc6/0x150
>>   __nf_ip6_route+0x23/0x50
>>   synproxy_send_tcp_ipv6+0x106/0x200
>>   synproxy_send_client_synack_ipv6+0x1aa/0x1f0
>>   nft_synproxy_do_eval+0x263/0x310
>>   nft_do_chain+0x5a8/0x5f0 [nf_tables
>>   nft_do_chain_inet+0x98/0x110
>>   nf_hook_slow+0x43/0xc0
>>   __ip6_local_out+0xf0/0x170
>>   ip6_local_out+0x17/0x70
>>   synproxy_send_tcp_ipv6+0x1a2/0x200
>>   synproxy_send_client_synack_ipv6+0x1aa/0x1f0
>> [...]
>>
>> Implement objref and objrefmap expression validate functions.
>>
>> Currently, only NFT_OBJECT_SYNPROXY object type requires validation.
>> This will also handle a jump to a chain using a synproxy object from the
>> OUTPUT hook.
>>
>> Now when trying to reference a synproxy object in the OUTPUT hook, nft
>> will produce the following error:
>>
>> synproxy_crash.nft: Error: Could not process rule: Operation not supported
>>    synproxy name mysynproxy
>>    ^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
>> Reported-by: Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
>> Closes: https://bugzilla.suse.com/1250237
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> Thanks Fernando, this looks simpler.
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> One day, if there are more objects that need validation, it should be
> possible to add a .validate interface to objects, but I prefer this
> approach because it will be easier to backport.
> 

Yes, the first patch I sent was adding a .validate operation to objects 
but Florian suggested to drop it as it was unnecessary. I also prefer a 
simpler patch, thank you for the suggestion.
