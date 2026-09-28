Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CC34FC8E4
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 21:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790630652; cv=none; b=d77bY0NbyeXglNN/ZP9VxyrDHxDPuPA2I5WgvxXWGqTrGmjHu8oPvS9Szl2ffyy85OAoVtG6QqBubIjFG0BXs3BC84cQtmwSnXjQaFoS5bice/mC1A6tCDX0Kb2mdcLoMmk+GPlKEL94FdhgtRHxMu/zaavpYb+eQrYJn96/dks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790630652; c=relaxed/simple;
	bh=IIdGjmBFN3zPR/DCN6/L5BmZ+eV7EQ54kYowxVVG0mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gcJO+tx8l3HUqIRkc3eO3TCANThO7KFLwUPptM5+aor/OQI3LEPdpZgsxU7hLmUfSQiRG2CwmOgdTKF2TF5QFnPe4xEf3lCFgmfAERw5Ek84DK/YZ3i+TIsLss3p50Fi/4p5WAYLMvVprMj9uDe+4mR84aJV1rxprM6kHbLjpg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uBPgNDSB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bnzDE4LS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J+Mep9ku; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=U8o4TCvT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uBPgNDSB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bnzDE4LS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J+Mep9ku";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="U8o4TCvT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3DB3621A84;
	Mon, 28 Sep 2026 21:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790630637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kq1S6mU8rYo5FkbQszNzya/R6ly/thQR34ZYzSLQNLY=;
	b=uBPgNDSBKqtHlhInjxP3KxK1fboYtVsgiCU2Bce1D3AKOtvxRvT+jcrlxxV0mU48QuH8or
	IfWKB/cIeXCrKlJHvA1ClXfYzirFo3veN7qwuzUlicYLr4GeGQ2Mi1GRf0Bh9VAi3c+bFi
	aJszWLuuR2BCQF/mi5kh33N2ddTmh6E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790630637;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kq1S6mU8rYo5FkbQszNzya/R6ly/thQR34ZYzSLQNLY=;
	b=bnzDE4LSAbt7pXrAamSqNKIjrtyrPbxqaEuO1asXoYeGCHSrx7ZKx+WyuIwE2KFDKWY833
	4nzmhnSsbJw0NRAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790630633; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kq1S6mU8rYo5FkbQszNzya/R6ly/thQR34ZYzSLQNLY=;
	b=J+Mep9kuvaLb6BBMeaWx7tUZqmiQE3VjoHYqX21zt4P4usRV+9IAyNchfz+geNFupMPdrW
	bSKx8r8hMxdxpVp/XYaERpHk3+bwSaNoAXW7F1DDTk1bKP1+MrJaTDECMNT1osy/Xk4dEG
	mkOYzPyl3Jdq7Hj4rGbzPCVkGfwQ9Mw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790630633;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kq1S6mU8rYo5FkbQszNzya/R6ly/thQR34ZYzSLQNLY=;
	b=U8o4TCvT5N/vwj7sJ+GEQQr6HDgnvWfYKpUZhcdfins+EH4GEJ/HRxEqx6NITzn33tZ5FK
	kT7NWsyPE9tN5EDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D04C7133F1;
	Mon, 28 Sep 2026 21:23:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FtsiJ+jaumrCKgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 28 Sep 2026 21:23:52 +0000
Message-ID: <d5fe7a16-34ec-49f9-99b8-f9824f4780d2@suse.de>
Date: Mon, 28 Sep 2026 23:23:05 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Netfilter: match "tcp option" with the same type present multiple
 times
To: Florian Westphal <fw@strlen.de>
Cc: Matthieu Baerts <matttbe@kernel.org>,
 Netfilter Devel <netfilter-devel@vger.kernel.org>,
 Netfilter Coreteam <coreteam@netfilter.org>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arpn7_v8156iSc85@strlen.de> <f62b8394-9ead-45fe-bf26-998c0c822dcd@suse.de>
 <arrao0GEl3eCV0OS@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <arrao0GEl3eCV0OS@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On 9/28/26 11:22 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 9/28/26 3:13 PM, Florian Westphal wrote:
>>>> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
>>>> (type 30) options in the TCP options. It looks like Netfilter doesn't
>>>> handle that, because it stops processing other TCP options when the
>>>> expected type is found:
>>>
>>> Yes, this won't work. 'tcp option X' extracts the
>>> option X.
>>>
>>> I don't see how this could be fixed within the limitations of the
>>> architecture.  Just use bpf.
>>>
>>>> It looks like it shouldn't stop if the wrong subtype is found, but the
>>>> subtype is not compared there if I'm not mistaken. Should there be a fix
>>>> to support this case?
>>>
>>> I don't know how, unless one would extend the kernel to make it aware of
>>> mptcp, which also requires userspace to pass the suboption type to look
>>> for in addition to 'mptcp option'.
>>>
>>
>> This won't be easy neither fast but I added this to my TODO list. It sounds
>> fun. Unless someone else does it first, I will take it.
> 
> Thanks Fernando.  I haven't looked at this at all.
> 
> I think the only sensible solution is to come up with a new syntax to clarify
> that we want a specific mptcp subtype and not the first mptcp option.
> 
> The problem is that "tcp option mptcp subtype" really just tells kernel
> "find the first mptcp option, if any, then place the subtype into dreg".
> 
> And kernel doesn't even know what a subtype is, it just extracts data
> at given offset :-/

Yes, this will likely require both userspace and kernelspace code but I 
guess it is worth doing it :)
