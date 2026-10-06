Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F323CE0A2
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 20:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319244; cv=none; b=FTvcRS+qDyf+hNW8PilyCbOpkhLJLHS8bfogDIkJiaDVfY4tDTzvh7aa0IiaO8tCZXJ5YkG6/zmsiaD/hvMsdc5JDijcw2YBThuZjP2SA5ruuIbFKVT66a9NoSLToqDm9k2baYGruSTgP+45S9HIkH6wASLpopNKfvdyOTy+Gsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319244; c=relaxed/simple;
	bh=c9d3eoXqkNh+Qxx8TDqe0jLC1z9NL7+aSTEf2oQx7L4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mJQ8/oPDtJdHKcSDGhp4DhTFXBcDlCXotlr5ORIJJi34WKeMl03fvW9PkpMHbFNNqRILuICTrfo/agV+itHSIMBgsK0BzWq9fem5lgqficXxvBGOIEg9hbpc0g2yTz4MTEFK7SlOuhLjduSfKdU61eTrdxOPaGkFEXZ8R9SSifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rQs4/ttI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u4d/2KsF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lFD9/Joz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=edQgG3Wu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rQs4/ttI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u4d/2KsF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lFD9/Joz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="edQgG3Wu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 431591F7BC;
	Tue,  6 Oct 2026 20:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rJVJkRMZr+s1GbwK4HPPJ+GWcrG3r7n4+1FMIScyci4=;
	b=rQs4/ttICu6cLqCKNrh4Xeme7CjY+5J1f0zYbBE0EbBmcJ7BLYnJTICm9RogQqTab4M0br
	kBGUgR9xWoTELDFibiS2Tv7+T1QL/xFkTQp6wV7TKHUl2nggQZz1TH1y+EG2+Ei/zUH9fL
	oQ8VuHfVyp2e0Z802UxI1rjdrlHrkTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319236;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rJVJkRMZr+s1GbwK4HPPJ+GWcrG3r7n4+1FMIScyci4=;
	b=u4d/2KsF0r+Cg7POC05RM9XyLZv3gaMhusApZEsKJrf1F8jmvnlntneCaemP+vO7BkA5BI
	SwndU7SDe5PqkxAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="lFD9/Joz";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=edQgG3Wu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rJVJkRMZr+s1GbwK4HPPJ+GWcrG3r7n4+1FMIScyci4=;
	b=lFD9/JozbQNp5HCm/sMjcs7CSy+9iXhgXfWYw7tQInQBMrb11K/UWW04Dxw2cHTuXMpWHP
	ktqn951QrqJCuJmoSiNZV/3RdcxkdcjP0565ETmn2FH5V0h98Un96PRPzJlArEC9CUmKO7
	N2QKDBlY9EhBalauC2zxcISQZeSzZgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rJVJkRMZr+s1GbwK4HPPJ+GWcrG3r7n4+1FMIScyci4=;
	b=edQgG3Wux+IpeH0qRIcPnp/i/B5jRLpoweYyfUOoIYGyiAkFWJQ6SV/Dq9kdRnGxy6/17d
	+Xc+OQwXgWZ0lrBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9A86137AC;
	Tue,  6 Oct 2026 20:40:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Kz+GI79cxWpSNwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 06 Oct 2026 20:40:31 +0000
Message-ID: <f4459a06-4de5-47e1-b74f-26093883a012@suse.de>
Date: Tue, 6 Oct 2026 22:40:31 +0200
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
 <c9ea9b66-ddf8-44c2-bfc5-9dfacf837b8c@suse.de>
 <c50a369c-b126-4369-830f-cb675f920ef4@kernel.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <c50a369c-b126-4369-830f-cb675f920ef4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 431591F7BC
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 10/6/26 7:06 PM, Matthieu Baerts wrote:
> Hi Fernando,
> 
> On 01/10/2026 10:58, Fernando Fernandez Mancera wrote:
>> On 9/30/26 8:38 PM, Matthieu Baerts wrote:
>>> On 29/09/2026 16:14, Fernando Fernandez Mancera wrote:
>>>> diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
>>>> index ceccfdaa..f1de0956 100644
>>>> --- a/doc/payload-expression.txt
>>>> +++ b/doc/payload-expression.txt
>>>
>>> (...)
>>>
>>>> @@ -833,6 +859,18 @@ filter input tcp option sack-perm exists counter
>>>>    filter input tcp option maxseg size lt 536
>>>>    --------------------
>>>>    +.matching MPTCP suboptions
>>>> +--------------------
>>>> +filter input tcp option mptcp subtype mp-join drop
>>>> +--------------------
>>>> +
>>>> +[NOTE]
>>>> +====================
>>>> +Netfilter currently evaluates only the first MPTCP option found in
>>>> the TCP
>>>> +header. If a packet contains multiple MPTCP options, a rule
>>>> attempting to match
>>>> +the second option will never match.
>>>
>>> Would it be interesting to give an example? e.g. a rule attempting to
>>> match 'remove-addr', 'mp-prio' and 'mp-fail' (and 'mp-tcprst' in some
>>> cases) are not going to catch anything when the traffic is emitted by
>>> the current Linux kernel stack.
>>
>> could you provide a good one? Ideally the documentation should be as
>> simple as possible. I thought about adding the rule you asked about
>> initially.. but I realized that simply describing the issue was better
>> IMHO.
> What about something like this?
> 
>    Netfilter currently evaluates only the first MPTCP option found in the
>    TCP header. If a packet contains multiple MPTCP options, a rule
>    attempting to match the second option will never match. Having
>    multiple MPTCP options in the same packet is valid, e.g. the Linux
>    MPTCP stack inserts 'remove-addr', 'mp-prio' and 'mp-fail' after an
>    MPTCP 'dss' option ; 'mp-tcprst' can also be inserted after an 'mp-
>    fastclose'.
> 

Yep, that works! Will include in the v2, thanks!

> Cheers,
> Matt

