Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED10329CEB
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Nov 2025 23:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762902746; cv=none; b=BkGRtrqOiu7sCpXpr0eX70ACdrk798LVa7Hk6IrllyvXZsIeUaEB9d5cerEAT+LLDRV9CNNosq8OLQXHtBzJmdjA8sk4Xovsd8WGfNjF3fI+Y6Nr1qyXFXhwIGKLeQoezF1BS+gvbMOEK2XEs/sGbcJChhr5Wx4ruAb2cNyIhqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762902746; c=relaxed/simple;
	bh=nzuzwr74RMh5hAPBAqaqC7bBe6CB5LBB5j6xboJg61I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k7OdeYevVv+TW7iLo2zjYfBNjYTn3fgNUi5Kox9iGWmKKeINXzlbtNO/a6QE+lXEv44kM1Bd8nrlQGi2Jqzr9yjquLcCaU3mu+t3ZJfG3jlaol3cW74w2ediQPrliJpkFnGeEflsMz0tK0K92d4uzBnpH2ebeIEL7k7jDthu6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RQvM9LBS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gbgtY+6z; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RQvM9LBS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gbgtY+6z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RQvM9LBS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gbgtY+6z";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RQvM9LBS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gbgtY+6z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 948A021C13;
	Tue, 11 Nov 2025 23:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762902737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGno5R4faafdqL97zVRGwEToZj0wrZH9eqxY40nvHI8=;
	b=RQvM9LBS0dG5oL5fw7j5YXbLaNGVGMriKykVotx8nzmAy29+QQX2/ZQfCPOFj503OXMNdP
	3p6zIxmnu999y0CvMqmTPAsFdJs4m3kRZwkMBtgY8hdRVot6kQVTvmusyfnrl8f5pw85nL
	fwVxhqcL0NAaFUsA1o6r+mUbMzoiyHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762902737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGno5R4faafdqL97zVRGwEToZj0wrZH9eqxY40nvHI8=;
	b=gbgtY+6zsjiR1OAQKbneswrsFmxeUE9OIm/4esfCQWes/SUK2HLr1p9Dgndca9Rl9Znyij
	jTz6KhZ6bEy4wSAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RQvM9LBS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gbgtY+6z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762902737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGno5R4faafdqL97zVRGwEToZj0wrZH9eqxY40nvHI8=;
	b=RQvM9LBS0dG5oL5fw7j5YXbLaNGVGMriKykVotx8nzmAy29+QQX2/ZQfCPOFj503OXMNdP
	3p6zIxmnu999y0CvMqmTPAsFdJs4m3kRZwkMBtgY8hdRVot6kQVTvmusyfnrl8f5pw85nL
	fwVxhqcL0NAaFUsA1o6r+mUbMzoiyHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762902737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGno5R4faafdqL97zVRGwEToZj0wrZH9eqxY40nvHI8=;
	b=gbgtY+6zsjiR1OAQKbneswrsFmxeUE9OIm/4esfCQWes/SUK2HLr1p9Dgndca9Rl9Znyij
	jTz6KhZ6bEy4wSAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 60E8D14BE6;
	Tue, 11 Nov 2025 23:12:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pdjMFNHCE2m5OAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 11 Nov 2025 23:12:17 +0000
Message-ID: <c8a3fdb3-7b44-43a2-80a7-90bc66e88bd5@suse.de>
Date: Wed, 12 Nov 2025 00:12:15 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft] src: add connlimit stateful object support
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20251104171321.29393-1-fmancera@suse.de>
 <aRN5iuGxV6aHn6zA@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aRN5iuGxV6aHn6zA@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 948A021C13
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 11/11/25 6:59 PM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Tue, Nov 04, 2025 at 06:13:21PM +0100, Fernando Fernandez Mancera wrote:
>> Add support for "ct count" stateful object. E.g
>>
>> table ip mytable {
>> 	ct count ssh-connlimit { over 4 }
>> 	ct count http-connlimit { over 1000 }
> 
> For the opposite case, maybe could you use?
> 
> 	ct count http-connlimit { to 1000 }
> 
> because this representation limits a bit its extensibility in the
> future:
> 
> 	ct count http-connlimit { 1000 }
> 
> parser can do better with a bit of tokens as context.
> 

Sure, I am adding the "to" token in a v2. Thanks!

> I am not expecting any extension 'ct count' on this in 2025, but you
> never know what future brings.
> 
>>          chain mychain {
>>                  type filter hook input priority filter; policy accept;
>>                  ct count name tcp dport map { 22 : "ssh-connlimit", 80 : "http-connlimit" } meta mark set 0x1
>>          }
>> }
> 
> For the record, there is one more scenario which is not supported and
> that needs a kernel + userspace extension, which is:
> 
>          ... ct count map { 0-10 : jump a, 11-20 : jump b, * : jump c }
> 
> This is because I _deliberately_ implemented the 'ct count VALUE' as a
> statement, not as a expression, because at that time I want to add
> support for ct count for dynsets, and only statements are supported
> there.
> 
> This requires to extend connlimit to have a function to return the
> count and stores the value in a DREG.
> 
> In userspace, there will be an issue to support this because there is
> a shift-reduce conflict in the parser which needs a careful look.
> 
> That would complete native 'ct count' support for nftables.
> 

Thanks for letting me know, I didn't think about it. This has been added 
to my TO-DO list although, is not at the top right now.

Thanks,
Fernando.
