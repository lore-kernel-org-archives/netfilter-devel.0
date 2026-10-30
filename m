Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793371288;
	b=G8pgdygaqczlg1CvOK7+U9B65tI1mMPPkcNxzz+7grSSgIC0qjbFCwHvOIuYRulDUv0D
	 KmJi2tUpUKJhFuiZ/ktfzTlcqyMC9OTGo+XsHpMqNvpazf+aOPzVq/Bbfkw4eLdLaXUMt
	 DYKXcGBVOygCr8zoMI+nXjYJj3boWHkB1UQgcRGQSXRQgZF+TgNt2nWaEBOxgDxCYR+Tq
	 LXxurZSKN71XIMRElLxrlKzp9DrdfEZPstpUzYhtXKkDLkCYZiRfh0gmygUnmNMR9ZtYR
	 ntdYkNkFRZp/PCuTlXYONj0qAuFIQ3M9smMAlpFaV2HWN8+trCn1++G/N3tsLdO9rdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793371288;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=1XpMQrUpLgoAmhwi+UI3s1fFFcnNHOgaIoeUGUk/sl0=;
	b=kWrry+SKUFfCwhBCg9rNGxHYr+7BwGooq2/WoyQQbyIkD15kx5P/ebrbo0GEE7roI5e4
	 axRX+TTFQyu1LbTBlFnG0iCCgXAaHPOAuPKz4+sbqekbmk5wMxY2C+diEJ38mPaRttKf1
	 VZuOTGBdGetpdEDLnF5q6E38C809pc2rPujp2ZDn38QmHVG4/t4sBW9RgMR76fRVSRCY6
	 82O6m4Zr9mN65IPXx9RVx9+ecd/cPamXJxzEOkxd3xh1Lil+XIFJmeEldHG6/5YS2z6EI
	 X55YGUG0ngTICv/UncVOmqCZ/q/vPM5IyqJKFME+1OKQylxQMGSU8ZTkluoDAUtmfXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=awzNl6jC;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="YTj/ftEG";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=w5rZ2Tkh;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=rQY57IWv;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1478E606A31D
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 14:41:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1478E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=awzNl6jC;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YTj/ftEG;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=w5rZ2Tkh;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=rQY57IWv
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 38BD9222A6;
	Fri, 30 Oct 2026 14:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793371286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1XpMQrUpLgoAmhwi+UI3s1fFFcnNHOgaIoeUGUk/sl0=;
	b=awzNl6jChemwqCkH+anrIozt6WY+Q8W9TV61iVgA2wH7ESX17atkYBseyFaCqc7X1AiUMZ
	AW9pD1PmTRtvcLuWs/mYVD/AuZayEU5jiC51d5Q4osPH4t8mbHa68bRh+pXDbcYhf0M35U
	FFguxRB2W66c9HCJyhAjWNh7ysCNtik=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793371286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1XpMQrUpLgoAmhwi+UI3s1fFFcnNHOgaIoeUGUk/sl0=;
	b=YTj/ftEGfrIBjJdUzzsYpE9rajziuxorR0r9aHllPuOYPL9zl+ZlbYK9iyF97+8QzRh2yk
	uTdAWFAeKiTU1xBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793371285; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1XpMQrUpLgoAmhwi+UI3s1fFFcnNHOgaIoeUGUk/sl0=;
	b=w5rZ2TkhNOCHckzXK/IJ5NtDth9LdzIAsiM3FsdWICF/DtsxGYvKU6YkgcoZsE7p+rHIEi
	xRGlzbqiidWjpO6xgA4rkJTgYAqp3uNYiAfUvMmQkJVFlXzbC3nuEe3YYnx7L15GZ2jZlv
	JFpKTKzBUG/A9Rk4bo3Ap1qiFTl8drY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793371285;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1XpMQrUpLgoAmhwi+UI3s1fFFcnNHOgaIoeUGUk/sl0=;
	b=rQY57IWvWm5NHqHvtxr+ZsOfD5ECVPDMH5p8DE5jfSjUmGxa/yywRpeeAyd+FxVB5ewwlc
	lvYlzOptK4KtLaCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B685F13419;
	Fri, 30 Oct 2026 14:41:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0hMJIZSs5GqHJgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 30 Oct 2026 14:41:24 +0000
Message-ID: <17f1cf11-ae17-46f6-a8a0-a23644411ab0@suse.de>
Date: Fri, 30 Oct 2026 15:40:00 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: keep socket ownership when
 expanding skb
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc, VEGA <vega@nebusec.ai>
References: <20261030135750.4452-1-fmancera@suse.de>
 <auSrTEnc8tibSGs2@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <auSrTEnc8tibSGs2@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.997];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 10/30/26 3:35 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> nfqnl_mangle() replaces the skb with skb_copy_expand() when a verdict
>> grows a packet beyond its tailroom. skb_copy_expand() does not copy
>> skb->sk, so the replacement is unowned and freeing the original drops
>> its socket memory charge.
>>
>> The expanded packet is no longer associated with the process that sent
>> it. Therefore xt_owner or xt_cgroup and other socket based matches in
>> later rules no longer matches and a later NFQUEUE reports no uid/gid. In
>> addition, the expanded packet's memory is not counted towards the
>> sender's SO_SNDBUF limit, so the sender can keep producing them while
>> they sit in a queue.
> 
> A proper fix requires wmem/truesize fixups and will have to deal with
> wmem-accounted vs. non-wmem accounted.
> 
> I dont think its worth fixing this, there are many other ways to
> get OOM when you have CAP_NET_ADMIN.

That is fair but the keeping ownership of the skb seems worth it for 
other uses too? Anyway, I don't think the OOM aspect is too relevant.

This is just fixing a combination of queue + other matches. I can also 
drop the memory aspect of it from the commit and keep the combination thing.

But yeah, we can just ignore it. There are many combinations that are 
problematic anyway (?)

What do you think?

Thanks,
Fernando.
