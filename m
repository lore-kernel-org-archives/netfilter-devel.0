Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058E729CB52
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2026 08:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845185; cv=none; b=ZUc+JIEiAhbqcA/l6PwzcmQCa+p58RIrRnNxEDeGNrmUAnC4dhVmx9BrG7MKgcTODhMLxXAoSzUedQIerC44DGZk1+jrFwBcHChccTASWWqWqaB9NVqtbwzJJSQ5rnTaa+7jiKYGAiNbRejHVnCLAvPxa8mMW6YIWulUCK43njk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845185; c=relaxed/simple;
	bh=dVMACW1uab6ytVLjT7v1L28wN/MgJxzxJW9ybKVCzBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PzjeDg6Fh4vBXUVtZzWSXjK0UUapkDqZKF/KmlXGTIkI6W47gGlREsldaIcpOCvKsyrQBemOWsXRzCuPl8jpm5BUAKbw0POYgx5t8K7nUxSenw2tU3SmInDwiMxiQYIaVDFQDecxwXoqZc16IID7k59iN1rsZyBz1c9yAselGng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BtURR0R2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=td7q0C7m; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ptl0lvDa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OdxtZp31; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BtURR0R2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="td7q0C7m";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ptl0lvDa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OdxtZp31"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DBEA91FBAE;
	Thu,  1 Oct 2026 08:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790845178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hTMHIHZlQDLeH0xxi6JusfySLvtyspKvL9t2gjw8UU8=;
	b=BtURR0R2ZB7yeZ6f7aNWwTGjAh/BnbIz1zzeF+clpDuoLJqblDSvgKZcBgcXElgB7SaHh4
	Y+/xSquPj7U0icd9jzYI/+815Zd/pvXrgDgSXcrxRNlqxniF88EmdF3MDgKe+lRWIkAbRS
	CaRLkXlzJ8ndgjRfI7NPkuuyILmzzqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790845178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hTMHIHZlQDLeH0xxi6JusfySLvtyspKvL9t2gjw8UU8=;
	b=td7q0C7ms8mLbaVZT/618L0tRkOGc6giKaU4lb0PC4V3QhWj+KEAIEJTLaFjNJU3UFQsLk
	tX3SQaQGp2Ev6ACg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790845173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hTMHIHZlQDLeH0xxi6JusfySLvtyspKvL9t2gjw8UU8=;
	b=Ptl0lvDaxDLdcy61N4KQ8R3WVEXB0rWiIx/4+rtUer5TV0KGrHQmbBBLb1lPH/sfsz5OJ0
	eB0MIJrBNBCmnnzAaT7wzstHuwtzT5ZAP4RZTTQ70RuCOa0bLS+bibyOrhHG/K8NxByaz/
	RENTuIX7uMcOVlZEHlnX0rHlgr4Nj/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790845173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hTMHIHZlQDLeH0xxi6JusfySLvtyspKvL9t2gjw8UU8=;
	b=OdxtZp31V0QUmL7H5V/cZ37vO9iN/fnt1UrnwyoEo0L1vT9RLR/tEi3A/lTNz2y7RE9+jr
	NWE9GvgMME1siMDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6023A134B3;
	Thu,  1 Oct 2026 08:59:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id raMKC/UgvmoVBgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 01 Oct 2026 08:59:33 +0000
Message-ID: <c9ea9b66-ddf8-44c2-bfc5-9dfacf837b8c@suse.de>
Date: Thu, 1 Oct 2026 10:58:31 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft] doc: add MPTCP subtypes documentation to man page
To: Matthieu Baerts <matttbe@kernel.org>, netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
References: <20260929141425.4852-1-fmancera@suse.de>
 <ef8c754d-616f-489f-b556-073efa491cd2@kernel.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ef8c754d-616f-489f-b556-073efa491cd2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 9/30/26 8:38 PM, Matthieu Baerts wrote:
> Hi Fernando,
> 
> On 29/09/2026 16:14, Fernando Fernandez Mancera wrote:
>> In addition, document the limitation when there are multiple MPTCP
>> options.
> 
> Thank you for this patch!
> 
>> diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
>> index ceccfdaa..f1de0956 100644
>> --- a/doc/payload-expression.txt
>> +++ b/doc/payload-expression.txt
> 
> (...)
> 
>> @@ -833,6 +859,18 @@ filter input tcp option sack-perm exists counter
>>   filter input tcp option maxseg size lt 536
>>   --------------------
>>   
>> +.matching MPTCP suboptions
>> +--------------------
>> +filter input tcp option mptcp subtype mp-join drop
>> +--------------------
>> +
>> +[NOTE]
>> +====================
>> +Netfilter currently evaluates only the first MPTCP option found in the TCP
>> +header. If a packet contains multiple MPTCP options, a rule attempting to match
>> +the second option will never match.
> 
> Would it be interesting to give an example? e.g. a rule attempting to
> match 'remove-addr', 'mp-prio' and 'mp-fail' (and 'mp-tcprst' in some
> cases) are not going to catch anything when the traffic is emitted by
> the current Linux kernel stack.
> 

Hi Matthieu,

could you provide a good one? Ideally the documentation should be as 
simple as possible. I thought about adding the rule you asked about 
initially.. but I realized that simply describing the issue was better IMHO.

Thanks,
Fernando.

> Cheers,
> Matt

