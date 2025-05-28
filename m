Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95F41EB193
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 09:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748424487; cv=none; b=gDnwBHyZGH8o2v5gsNYMZClPp3iteDe4AJgFE7dsLxsH9LfZ9lUJJW/SqYO+4DVDPmPVx4Y3zyni5iHUlmqq/VtlfG7W1MeLXmGwZ0XHRce0NO92zkHE5v3wXGQCPVhd1ydytFdw2jucnp3L7OnFsw63N+IYOhUP3mxnlSFM7dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748424487; c=relaxed/simple;
	bh=b8cmgYftkFS+FoNMbdXejdc19kaKrD55BVfONgoSf18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OOyByN2fEj1Brqwe2SFgUosY/CJIwG8oIXs4KljcfD/kB5d0b4+BzBigGfbQ+0mCWZck/JzoOhHBRZuayhmpLb8ORuPxiQQjjlj4WVPgZO3lJC93xRCTO/id/cSVXP8y+P90BHL8N6629h2CHgcJRL4kJWgEAEfLUieSSd971P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pTNa2j8G; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hwxFPqPc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iTvAydl/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=j7ZniaHm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pTNa2j8G";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hwxFPqPc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iTvAydl/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="j7ZniaHm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E784121CE0;
	Wed, 28 May 2025 09:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748424484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yb43bY+0RCNYrNRXm5Kn7VFLey5maJLVCIwXAb0Q63k=;
	b=pTNa2j8GCfURdQ5SNnR6ZcM6YmHWjULgdR7d1J2Xl6rpSS/JMnuK0PKvaGYNQYHS9hLCD4
	yr1dfWtMR7eMR2NuHSony80pDBiQg8RjpNiW16Js/hTl4JVu5KpvTZYHIDM6uxsSTyVdUb
	LZEKT18G/FOkMMkE3SOC5UmV6RxuiDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748424484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yb43bY+0RCNYrNRXm5Kn7VFLey5maJLVCIwXAb0Q63k=;
	b=hwxFPqPcrW3sIW/juvCchhl35s3x4gmXiNcOqspL2k+hzoL8wMM7n3nNFBJ71CA5sEdSEL
	s9E/zg2THZ0LVWAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="iTvAydl/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=j7ZniaHm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748424483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yb43bY+0RCNYrNRXm5Kn7VFLey5maJLVCIwXAb0Q63k=;
	b=iTvAydl/PfewwBTlK2IbiHLRofCWFQot1BsINyeOdu5o1bUJjdK7se5OlFmI+5Ccylp+c3
	tduc1NsSC9e2hb4z2WEoysE1d+kKpX04uPtkzOf0TBBKlRB9Gb/WQUwPTGLrhp+KV3yxUk
	dhM2algGFOqUDf8qvzP/jigBL/dNuhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748424483;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yb43bY+0RCNYrNRXm5Kn7VFLey5maJLVCIwXAb0Q63k=;
	b=j7ZniaHmWVuscc0xNTT4XZrFThUhkSQiidB6raYvxaJBvoGgKgXOm/fGOyRkL7tUT2zZGb
	gzZON4XhWx7kZxBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B27B2136E3;
	Wed, 28 May 2025 09:28:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jq2KKCPXNmhDawAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 28 May 2025 09:28:03 +0000
Message-ID: <7f8d6fea-d4da-4cda-87cc-c5194e36d25e@suse.de>
Date: Wed, 28 May 2025 11:27:40 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20250527193420.9860-1-fmancera@suse.de>
 <20250527193420.9860-2-fmancera@suse.de> <aDZaAl1r0iWkAePn@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aDZaAl1r0iWkAePn@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E784121CE0
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51
X-Spam-Level: 



On 5/28/25 2:34 AM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> 
> Hi Fernando
> 
> Thanks for working on this, I got inquiries as to nft_tunnel.c
> and how to make use of this stuff...
> 
>> diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
>> index 9930355..14a42cd 100644
>> --- a/include/libnftnl/object.h
>> +++ b/include/libnftnl/object.h
>> @@ -117,15 +117,19 @@ enum {
>>   	NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX,
>>   	NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID,
>>   	NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR,
>> +	NFTNL_OBJ_TUNNEL_GENEVE_OPTS,
> 
> If every flavour gets its own flag in the tunnel namespace we'll run
> out of u64 in no time.
> 
> AFAICS these are mutually exclusive, e.g.
> NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX and NFTNL_OBJ_TUNNEL_VXLAN_GBP cannot
> be active at the same time.
> 
> Is there a way to re-use the internal flag namespace depending on the tunnel
> subtype?
> 
> Or to have distinct tunnel object types?
> 
> object -> tunnel -> {vxlan, erspan, ...} ?
> 

IMHO, this could be done by providing libnftnl its own object tunnel 
API. Although that would require to expose more functions, but tunnel 
object could have its own flags field.

In addition, I am afraid that ERSPAN and VXLAN enum fields have been 
exposed in a released version so removing them would be a breaking 
change. I am not sure whether that is acceptable or not.

> As-is, how is this API supposed to be used?  The internal union seems to
> be asking for trouble later, when e.g. 'getting' NFTNL_OBJ_TUNNEL_GENEVE_OPTS
> on something that was instantiated as vxlan tunnel and fields aliasing to
> unexpected values.
> 
> Perhaps the first use of any of the NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX
> etc values in a setter should interally "lock" the object to the given
> subtype?
> 
> That might allow to NOT use ->flags for those enum values and instead
> keep track of them via overlapping bits.
> 
> We'd need some internal 'enum nft_obj_tunnel_type' that marks which
> part of the union is useable/instantiated so we can reject requests
> to set bits that are not available for the specific tunnel type.
> 

Yes, that would help but isn't that the reason why the flags field is 
there? I mean, currently the same problem would exist with the different 
object variants e.g the union of "struct nftnl_obj_*". When trying to 
get the attribute we always check that the flag is set.

>>   	switch (type) {
>>   	case NFTNL_OBJ_TUNNEL_ID:
>> @@ -72,6 +73,15 @@ nftnl_obj_tunnel_set(struct nftnl_obj *e, uint16_t type,
>>   	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
>>   		memcpy(&tun->u.tun_erspan.u.v2.dir, data, data_len);
>>   		break;
>> +	case NFTNL_OBJ_TUNNEL_GENEVE_OPTS:
>> +		geneve = malloc(sizeof(struct nftnl_obj_tunnel_geneve));
> 
> No null check.  Applies to a few other spots too.
> 

Ah right. Yes, will fix that. Thanks.

>> +		memcpy(geneve, data, data_len);
> 
> Hmm, this looks like the API leaks internal data layout from nftables to
> libnftnl and vice versa?  IMO thats a non-starter, sorry.
> 

I agree that exposing the list abstraction to the user is problematic 
and shouldn't be done. As you mentioned below, I couldn't come up with a 
better API on libnftnl. Thinking about it, we could expose only the 
relevant fields by putting them in a isolated struct.

> I see that options are essentially unlimited values, so perhaps nftables
> should build the netlink blob(s) directly, similar to nftnl_udata()?
> 
> Pablo, any better idea?
> 
> I don't like exposing the struct and also the list abstraction getting
> exposed to libnftnl users.
> 
> As-is, there is:
> 
> json/bison -> struct tunnel_geneve -> nftnl_obj_set_data(&obj, NFTNL_OBJ_TUNNEL_GENEVE_OPTS, &blob);
>   -> nftnl_obj_tunnel_build -> mnl_attr_put_u16( ...
> 
> I think it will be better if we make this internal to nftables and have
> pass-through for the entire geneve blob,i.e.
> 
> json/bison -> struct tunnel_geneve ->
>   (re)alloc buffer: mnl_nlmsg_put_header(), mnl_attr_put_u16 -> etc.
>   nftnl_obj_set_data(obj, NFTNL_OBJ_TUNNEL_GENEVE_OPTS, blob) ->
>   nftnl_obj_tunnel_build -> memcpy into NFTA_TUNNEL_KEY_OPTS nest
>   container.
> 

I am fine with this, although just as a note I chose the linked list 
path mainly to make it more flexible for users. AFAICS, libnftnl users 
usually do not need to build the netlink blob themselves.

So, the problem in essence is the shared binary structure. If I do not 
expose the list abstraction, copying the allocated struct would still be 
problematic, right?

Thank you for all the comments, Florian.
