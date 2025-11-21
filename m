Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A9434A76F
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732471; cv=none; b=RGyvZuXlOXq56GtU0YjzfJ33uzvfE3SUscXw13KgvrAwOM+5jiz1G9c3NbSZfDh2gw1KcBAd/8KR9SeNvWPTeAv1LyuuuAk83T2OIT3SAAR+S/NPHLJMMVfLhVxvLveft/7CqdR/NjC9B6aKLKd6xZNyjKJxbm0hRphjtSpRJYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732471; c=relaxed/simple;
	bh=zWY9UtZa0fsAaqxO+u4sDoiuN0XNEFhmX4wm2bqgZbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FoRkoTtmR6SLSfJxuOMAtzVyfiWxGPCWdOdyqpy03omJLQ+7ooF1JS1GIxqbCCz66AU/9f6jIz1tv0/KI4EGvvt4c+DW8q5alwc44rAfvtEFW5Flpv5TsD8DmW8/51WO3jZsKEnrpDs3fKQ89a41pyvN8tav9dRyujTD5iDTT1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z7t+NGP7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CPKN6/z3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z7t+NGP7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CPKN6/z3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z7t+NGP7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CPKN6/z3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z7t+NGP7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CPKN6/z3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C3EAA21290;
	Fri, 21 Nov 2025 13:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763732466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKN/OITGZxAz5v4qV0bEV8ALmwGXZ3iuynxkRJm4GOg=;
	b=z7t+NGP7e3F+UOlfJLF4WnT85RR07oG4YM2UOssnq+yJiUgeiqbaXAXytRFHzaEo3Ld1Lh
	hibwyIUQFZKmwYVhzM3PYNIRbJCgIQoYM7G+twUAGOxJo6v9l40OQw4WyACoTGq9MCsg/K
	d5EjizjICQNagOPib2fFDg+yX9VXRsg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763732466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKN/OITGZxAz5v4qV0bEV8ALmwGXZ3iuynxkRJm4GOg=;
	b=CPKN6/z38jqNAnK/YpJIGm7HYV4sgFf/Ai+WSGQ0H6tnIB7u24set60SxIwjGN2y1Uij22
	LH6Km9krRyJ7LVAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763732466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKN/OITGZxAz5v4qV0bEV8ALmwGXZ3iuynxkRJm4GOg=;
	b=z7t+NGP7e3F+UOlfJLF4WnT85RR07oG4YM2UOssnq+yJiUgeiqbaXAXytRFHzaEo3Ld1Lh
	hibwyIUQFZKmwYVhzM3PYNIRbJCgIQoYM7G+twUAGOxJo6v9l40OQw4WyACoTGq9MCsg/K
	d5EjizjICQNagOPib2fFDg+yX9VXRsg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763732466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKN/OITGZxAz5v4qV0bEV8ALmwGXZ3iuynxkRJm4GOg=;
	b=CPKN6/z38jqNAnK/YpJIGm7HYV4sgFf/Ai+WSGQ0H6tnIB7u24set60SxIwjGN2y1Uij22
	LH6Km9krRyJ7LVAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 861A43EA61;
	Fri, 21 Nov 2025 13:41:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kl3FHfJrIGllZgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 21 Nov 2025 13:41:06 +0000
Message-ID: <3a187dec-cd78-43cf-b202-e8c1d64c4f3b@suse.de>
Date: Fri, 21 Nov 2025 14:40:54 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft v2] src: add connlimit stateful object support
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
References: <20251115110446.15101-1-fmancera@suse.de>
 <aR7sIHfbHYERFAjN@orbyte.nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aR7sIHfbHYERFAjN@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 11/20/25 11:23 AM, Phil Sutter wrote:
> Hi,
> 
> On Sat, Nov 15, 2025 at 12:04:46PM +0100, Fernando Fernandez Mancera wrote:
>> Add support for "ct count" stateful object. E.g
>>
>> table ip mytable {
>> 	ct count ssh-connlimit { to 4 }
> 
> Quota objects use "over" and "until". So maybe use the latter instead of
> "to" for ct count objects, too? I know it's a bit of back-n-forth since
> Pablo had suggested the "to" keyword.
> 

To me both are fine. I don't have a strong opinion here.

> Pablo, WDYT?
> 
> [...]
>> diff --git a/src/parser_json.c b/src/parser_json.c
>> index 7b4f3384..987d8781 100644
>> --- a/src/parser_json.c
>> +++ b/src/parser_json.c
>> @@ -2835,17 +2835,26 @@ static struct stmt *json_parse_connlimit_stmt(struct json_ctx *ctx,
>>   					      const char *key, json_t *value)
>>   {
>>   	struct stmt *stmt = connlimit_stmt_alloc(int_loc);
>                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> I think this line causes a memleak. It should probably be a plain
> variable declaration.
> 

Yes, that is right. Thank you Phil!

> Cheers, Phil

