Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940C52D0611
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 18:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761675826; cv=none; b=ccmSDlbrG57OXrKdP7ZYIkHRsg9fUr0ZWxEp36k3ahH/6aQ6VI3yYC3G99XCOslJn7e6rqt+jEvQ8M7EeQ3Ho651cmXRR+hdffPu52wqpvLaIAakT3+p1kc+GSGXcAz1G1ucLlYdLoW8KeDvfkmvOz2mlRzQBt8QODg3c7JOK6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761675826; c=relaxed/simple;
	bh=IjRKOnyA+dLKyzgCCHMee6R9wELzHIRZiCCLGx8I0XE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QA2oTWsa38a96/VZ+Swb43xAwWKH287OF/098huV59yyFpxxPwpjUcWnS4/ORsid3zB9PIU8krN9PAnMF0gOtAMxmCffETIPcWppTGrFAoZ/nF5TXM+DzAdIMw0QDDlcqrPZzLlmxA8JWW79pXm4W8RjMzCfsQty5+Zx2W5LY2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k0lp7mam; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vdip8A2l; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k0lp7mam; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vdip8A2l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k0lp7mam";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vdip8A2l";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k0lp7mam";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vdip8A2l"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6316021A52;
	Tue, 28 Oct 2025 18:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761675822; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypQWx9g8YZFbb9A8hcYNMMtpIV5u0ltOwXA4Rwci1Cc=;
	b=k0lp7mam2zq0HRIE92QaGtf6wquzQ+fP1xd9nnrzM9wJRHWQ7+CD71aYnqeHirKjkEOKkL
	5AbYoTSU7w9Bu+e7oZldtmOtV+YNx/R5DDLcJkl1vbJPwXXDMk8hpkIFX/5SbHabH2C/jT
	8f1YCpWnNo8OSDrJX7iLgkuytKilNxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761675822;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypQWx9g8YZFbb9A8hcYNMMtpIV5u0ltOwXA4Rwci1Cc=;
	b=Vdip8A2lI3j1Dta8Z3+2RXuN2gci7cqMID7cqL5X++EiRL6aefnlyoJEL4c6ARVdoPZNhE
	rdeTjEn8Z+w34CBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k0lp7mam;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Vdip8A2l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761675822; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypQWx9g8YZFbb9A8hcYNMMtpIV5u0ltOwXA4Rwci1Cc=;
	b=k0lp7mam2zq0HRIE92QaGtf6wquzQ+fP1xd9nnrzM9wJRHWQ7+CD71aYnqeHirKjkEOKkL
	5AbYoTSU7w9Bu+e7oZldtmOtV+YNx/R5DDLcJkl1vbJPwXXDMk8hpkIFX/5SbHabH2C/jT
	8f1YCpWnNo8OSDrJX7iLgkuytKilNxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761675822;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypQWx9g8YZFbb9A8hcYNMMtpIV5u0ltOwXA4Rwci1Cc=;
	b=Vdip8A2lI3j1Dta8Z3+2RXuN2gci7cqMID7cqL5X++EiRL6aefnlyoJEL4c6ARVdoPZNhE
	rdeTjEn8Z+w34CBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F09813693;
	Tue, 28 Oct 2025 18:23:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BscbAC4KAWnOLAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 28 Oct 2025 18:23:41 +0000
Message-ID: <fdaccdd2-fce5-4224-9636-bf3366de2761@suse.de>
Date: Tue, 28 Oct 2025 19:23:36 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of a
 connection
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 louis.t42@caramail.com
References: <20251027125730.3864-1-fmancera@suse.de>
 <aQD2R1fQSJtMmTJc@calendula> <aQD4J7pI-Fz1V3eC@strlen.de>
 <aQD5PUkG7M_sqUAv@calendula> <aQD810keSBweNG66@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aQD810keSBweNG66@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6316021A52
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim];
	FREEMAIL_ENVRCPT(0.00)[caramail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,caramail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 



On 10/28/25 6:26 PM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Tue, Oct 28, 2025 at 06:06:47PM +0100, Florian Westphal wrote:
>>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>>>> -	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
>>>>> -		regs->verdict.code = NF_DROP;
>>>>> -		return;
>>>>> +	if (ctinfo == IP_CT_NEW) {
>>>>
>>>> Quick question: Is this good enough to deal with retransmitted packets
>>>> while in NEW state?
>>>
>>> Good point, I did not consider retransmit case.
>>> What about if (!nf_ct_is_confirmed(ct)) { ..?
>>>
>>> Would need a small comment that this is there instead of NEW
>>> check due to rexmit.
>>>
>>>>> +		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
>>>>> +			regs->verdict.code = NF_DROP;
>>>>> +			return;
>>>>> +		}
>>>>> +	} else {
>>>>> +		local_bh_disable();
>>>>> +		nf_conncount_gc_list(nft_net(pkt), priv->list);
>>>>> +		local_bh_enable();
>>>>>   	}
>>>
>>> As this needs a respin anyway, what about removing the else
>>> clause altogether?  Resp. what was the rationale for doing a gc call
>>> here?
>>
>> You mean, call gc for both cases, correct?
> 
> No, i meant this:
> 
> /* comment that explains this */
> if (nf_ct_is_confirmed(ct))
> 	return;
> 
> if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> 	regs->verdict.code = NF_DROP;
> 	return;
> }
> 
> As we don't add anything for 'is confirmed' case, I don't see why
> we would need to prune the existing list.
> 

We need this gc call, it is what fixes the use-case reported by the 
user. If the user is using this expression without a ct state new check, 
we must check if some connection closed already and update the 
connection count properly, then evaluate if the connection count greater 
than the limit for all the packets.

Otherwise, this change will introduce a change in behavior.. AFAICT

>>> And, do we want same check in xt_connlimit?
>>
>> Are you referring to the !nf_ct_is_confirmed() check?
> 
> Yes, AFAICS xt_connlimit has same issue as nft_conncount given
> they use same backend.
> 
> Backend doesn't have access to nf_conn/ctinfo so no way to solve it there.

