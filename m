Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975EB28AB0B
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Apr 2026 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775484113; cv=none; b=GhgkICV4+x6XkMYKvIhZ5KiPjHmjtnxAyqZtE1AKMPsffiCrGasg0r1z6eIsBBw7ZdIv8UG+NlYRQnQR6ThlUtv9lyJiuYNZJHviHy784gxpjMLHyrGhu6DvE+N+H4fTpS+DuhxM8W4GJoY6To7S/20IsTwrBYeTB7AyBkiTqPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775484113; c=relaxed/simple;
	bh=fHPNgrf2bXsmSFjgZvL0fIGt23iufmSgATaKRFa5HNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=crFoRQaJBJh4cxiNC2CfynTaQB+HFPC6VdSPjf8U3/u6e8pSXaJpXntxILC8wjtC3WVLFoO4AX/C/bn8Eijq1QWBh5EXJEMOJVWuquxVXvyl2CYX3RdQICY5gGIZjPbZli52ELKBOhDbfs4tIUb8PE4sfCiLQfSCcMEddf7p8do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Xmd0dq0P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O887R+1m; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Xmd0dq0P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O887R+1m; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Xmd0dq0P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O887R+1m";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Xmd0dq0P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O887R+1m"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B56794DF19;
	Mon,  6 Apr 2026 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775484104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qkoWXwj2HMEOhTOnl8p7cxmTvWsgCVhzncQIOn8LEhs=;
	b=Xmd0dq0PYO8LrU1wzHUqcn6VL+G1jMY0P3u1uPJtpT3cxA0ZDvdIo1CLJlc6ca0bvLvFVz
	KuW8aY3BCFzlWbe3ePJAMNcqnkhiWUHNLzXAvSrkoS8OpHt0cO6uBnYcmQSZL6EvK8jn8B
	1K8Yu+EjMfZ4q452pKLMHlgcC3Y+f7E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775484104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qkoWXwj2HMEOhTOnl8p7cxmTvWsgCVhzncQIOn8LEhs=;
	b=O887R+1mNEAJTsFFZTNqZ/aU7pKJAWhaBt47CR61Wt6dFkFj5dyKajuXgm6zMCV6NOCRg8
	Cw2alw61RLqOSRCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775484104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qkoWXwj2HMEOhTOnl8p7cxmTvWsgCVhzncQIOn8LEhs=;
	b=Xmd0dq0PYO8LrU1wzHUqcn6VL+G1jMY0P3u1uPJtpT3cxA0ZDvdIo1CLJlc6ca0bvLvFVz
	KuW8aY3BCFzlWbe3ePJAMNcqnkhiWUHNLzXAvSrkoS8OpHt0cO6uBnYcmQSZL6EvK8jn8B
	1K8Yu+EjMfZ4q452pKLMHlgcC3Y+f7E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775484104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qkoWXwj2HMEOhTOnl8p7cxmTvWsgCVhzncQIOn8LEhs=;
	b=O887R+1mNEAJTsFFZTNqZ/aU7pKJAWhaBt47CR61Wt6dFkFj5dyKajuXgm6zMCV6NOCRg8
	Cw2alw61RLqOSRCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A6274A0B0;
	Mon,  6 Apr 2026 14:01:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jOCaGsi802nYWgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 06 Apr 2026 14:01:44 +0000
Message-ID: <536764c9-8200-43ff-9347-3a8761239524@suse.de>
Date: Mon, 6 Apr 2026 16:01:35 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: nfnetlink_queue crashes kernel
To: Florian Westphal <fw@strlen.de>, Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: netfilter-devel@vger.kernel.org
References: <ac-w6e33txkgTRJj@strlen.de> <ac_EY9ciqt5yQ6wr@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ac_EY9ciqt5yQ6wr@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[strlen.de,gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 4/3/26 3:45 PM, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> A probably better fix is to make the rhashtable perqueue, which is
>> much more intrusive at this late stage.
> 
> Tentative patch to do this, still misses selftest extensions:
> 

This looks good from my side. I cannot reproduce the splat when this 
patch is applied.

