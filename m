Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2DB34A77F
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 09:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900247; cv=none; b=DrgrHNboEjgVmc+hxOo8PMOComMPPbCSgPjfPlUe1BX5VlNX4yV+ypAQB9pmisJGMGkL80mMQ0fvBYcvE5Q7zqD4HAFpg0AZAADPFqnGNC2N7vJIG9LKKKaLO7GUqaSmDOeoXPoyxqMI4xiQgm45xPDPzX3BoNvb/VrADB/jL3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900247; c=relaxed/simple;
	bh=HqMQt64k+MgEaLPVxNlpMxVsFfXVVTPmj3Zs/014cME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dmf6HivADRxBCs/j8o3Fpdui1TUQQ/p0Ld6Yu1z14hlnZ7y60ZMR2tMye1AwLK9EyqPn4au6YYKGIdJNAbwedMNRaxMCQKd/z/8PFqJf58rn6QNKoDpryBIEi9WnRO2noAyTxLNV1sigRkHeQVIGGFfuaQj4T7uA5fCct0BLwFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0Yt9aLgi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3zixYNV1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0Yt9aLgi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3zixYNV1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0Yt9aLgi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3zixYNV1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0Yt9aLgi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3zixYNV1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 801555BCC3;
	Tue, 20 Jan 2026 09:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768900243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hz9eXACmixyamBW7Z0dxDrN2OAjfyLrD8qlrHXHgzTo=;
	b=0Yt9aLgio1HFG+73rT5d1wGAR63I+TWHXkkwMEpVfnG5ygokBUDHiWCZ62nqLKj9ci4TrX
	VjkxFkKwq0VMHZQRqijVhh6mF4BvtldVh8jDYyiibcx9+/UwhLfyVnYkrJW3MxTKYkS2ur
	+0fIm08KViDcrHc5UJ9pzFcBGKGZC+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768900243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hz9eXACmixyamBW7Z0dxDrN2OAjfyLrD8qlrHXHgzTo=;
	b=3zixYNV1u0iJEOSEidOmaFT4Sj/b7HurAoI8elHMhUzb4EU3xn9DWZIM77eUmDBrCAYk3M
	cm34gWGXJAwJ7XBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0Yt9aLgi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3zixYNV1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768900243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hz9eXACmixyamBW7Z0dxDrN2OAjfyLrD8qlrHXHgzTo=;
	b=0Yt9aLgio1HFG+73rT5d1wGAR63I+TWHXkkwMEpVfnG5ygokBUDHiWCZ62nqLKj9ci4TrX
	VjkxFkKwq0VMHZQRqijVhh6mF4BvtldVh8jDYyiibcx9+/UwhLfyVnYkrJW3MxTKYkS2ur
	+0fIm08KViDcrHc5UJ9pzFcBGKGZC+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768900243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hz9eXACmixyamBW7Z0dxDrN2OAjfyLrD8qlrHXHgzTo=;
	b=3zixYNV1u0iJEOSEidOmaFT4Sj/b7HurAoI8elHMhUzb4EU3xn9DWZIM77eUmDBrCAYk3M
	cm34gWGXJAwJ7XBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 24C7F3EA63;
	Tue, 20 Jan 2026 09:10:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /84ABpNGb2kXIQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 20 Jan 2026 09:10:43 +0000
Message-ID: <0950bd9f-0d8b-4907-8c77-46280660a9d1@suse.de>
Date: Tue, 20 Jan 2026 10:10:24 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next v2] netfilter: nf_conncount: fix tracking of
 connections from localhost
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc,
 Michal Slabihoudek <michal.slabihoudek@gooddata.com>
References: <20260119203546.11207-1-fmancera@suse.de>
 <aW6X1kBQ8clOAL76@strlen.de> <18fa7f7c-22ee-42d9-b698-03df94f24d4c@suse.de>
 <aW6_rWdJHz305jma@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aW6_rWdJHz305jma@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.51
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 801555BCC3
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO



On 1/20/26 12:35 AM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>> LGTM, thanks Fernando.  But shouldn't this go via nf tree?
>>>
>>
>> Yes but it will conflict with 76c79f31706a ("netfilter: nf_conncount:
>> increase the connection clean up limit to 64") when merging both trees. Also
>> it is rc7 cycle now.. so not sure.
> 
> In your opinion, is this bug more severe than what 76c79f31706a fixes?
> 

Not at all. This is a corner case IMHO. While 76c79f31706a is affecting 
the main functionality when the packet rate is high enough. Therefore I 
think via nf-next is fine. Thank you Florian!

> If yes, please resend vs. nf; I can hold 76c79f31706a back until
> after release and then handle it via nf too.
> 
> If no, let me know and I will add handle it via -next.

