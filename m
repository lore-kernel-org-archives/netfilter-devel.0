Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147FF30C637
	for <netfilter-devel@vger.kernel.org>; Sun, 24 May 2026 21:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779657865; cv=none; b=hSBGcxeTx04hPD7e9OPMHXLxl+EnAhlwJY7mB4c27aKTlsxsHL8GL1sApCUblbXbZnreLIKfW/lLeUtC0Xs50eu84gN9gDdgklasGC1D8mrnBOV0XQpG/+hHPizWn+d/66w3KJyUnr/Ngn9ADkQXs+/lhGhcvXm9p1x6G06jpeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779657865; c=relaxed/simple;
	bh=1emg1OXIq0d+UUXxxMME+wV0HTGx3wljV+QKbkHCJWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OR8BP2t12MHL4b3oIkEEvUXHHSnVSFq3JTPVkDKGIUKTTxGr64ps7r2cqKtVGLi3PK96fH1Vysh1LJOVVGKKbS/rV0MHvDN9TCwWEkdzT7q5Gzqu6p6QnF0RY1hZdyQ6v2Pq+z8PFHUkVw3YulFcgtv7GXqsm8DOoQmhuE/NQso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vEGnq6Dd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JoC8fEwn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vEGnq6Dd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JoC8fEwn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vEGnq6Dd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JoC8fEwn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vEGnq6Dd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JoC8fEwn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 24A6D68404;
	Sun, 24 May 2026 21:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779657862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AyyWyIwbQzezpIscJzCy3ci/FvCAo1cVKwsPpSF5G4o=;
	b=vEGnq6Dda8M5gHuFnW1mDhIYtQ/CWde9c2vyc6Vv4wfNvhtDsPT5SssYTkSk1Lb3ZL0TeO
	oUNpJ74reIeZ3H5cn6FuxGFx0A+R16FhWbKxXkbUGQW9cDB9aKI5VSefWagRizwmE1EunX
	RBzX3ZeCk5p+KpWWCc3A+z6wh1zS0Bc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779657862;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AyyWyIwbQzezpIscJzCy3ci/FvCAo1cVKwsPpSF5G4o=;
	b=JoC8fEwnVRL4CxmydWbp6M/h5vN9KLEu0NBJP2TkTo/aUtoNvohcAoxzZt6p6A7+xytWOQ
	H3QbtIMysykuVuBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779657862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AyyWyIwbQzezpIscJzCy3ci/FvCAo1cVKwsPpSF5G4o=;
	b=vEGnq6Dda8M5gHuFnW1mDhIYtQ/CWde9c2vyc6Vv4wfNvhtDsPT5SssYTkSk1Lb3ZL0TeO
	oUNpJ74reIeZ3H5cn6FuxGFx0A+R16FhWbKxXkbUGQW9cDB9aKI5VSefWagRizwmE1EunX
	RBzX3ZeCk5p+KpWWCc3A+z6wh1zS0Bc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779657862;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AyyWyIwbQzezpIscJzCy3ci/FvCAo1cVKwsPpSF5G4o=;
	b=JoC8fEwnVRL4CxmydWbp6M/h5vN9KLEu0NBJP2TkTo/aUtoNvohcAoxzZt6p6A7+xytWOQ
	H3QbtIMysykuVuBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C67D5598B8;
	Sun, 24 May 2026 21:24:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id brrWLIVsE2psYwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 24 May 2026 21:24:21 +0000
Message-ID: <9bacc5a6-59b6-48d9-9721-efff1c308fc3@suse.de>
Date: Sun, 24 May 2026 23:24:21 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3 nf-next] netfilter: synproxy: timestamp adjustment
 fixes
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc
References: <20260523194743.5888-2-fmancera@suse.de>
 <7dcb73cb-11ab-4c9d-89bd-7418bdc86fdb@suse.de> <ahMyVJYynOoa32U5@strlen.de>
 <3178bbf8-552a-45cf-819f-bf3ec2de41e0@suse.de> <ahNQbjbK5DBNWnNt@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ahNQbjbK5DBNWnNt@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
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
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 
X-Spam-Flag: NO

On 5/24/26 9:24 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> Hm. That might be an appealing argument for the dup timestamp option, if we
>> want to be more relaxed we can just adjust all timestamp options equally (we
>> need to assume that this is a corner case of course).
>>
>> But when failing skb_ensure_writable() or when encountering completely
>> malformed options I believe we should drop the packet.
> 
> Not so sure. skb_ensure_writable() -> yes.
> But for malformed options?  I think it should be done by policy.
> Not even conntrack drops such packets at the moment.
> 

Hm, okay that makes sense I didn't know that. I agree with you then. 
Thanks for explaining.

> Could you use NF_DROP_REASON() in next version?
> NF_DROP conceals the drop location which makes debugging harder.
> 

I was also not aware of this. It makes a lot of sense.

Thanks,
Fernando.

