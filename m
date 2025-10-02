Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493EA305040
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Oct 2025 09:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759398525; cv=none; b=iGTZiV5B/gp5dWIv8YV4xTIjoVUqeDFNzPdZwb/y0wQhrDWHNt1aWjz7ItuOGipj/fb0I2oTFIYbC8JqrDMbDcMIf5JgO1KmC/cgnCux79vimzeIZUuAdbpApeYhByJDIh7Zo2Rj7Bv44aHI9ogcTyYRO3ZLpAVQUL93XwTrrdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759398525; c=relaxed/simple;
	bh=sSYKpB+7a81RR6aDfwM0TPX3/9WK7Y5oLUDgvmOw8gE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FuaQM8gNoFmqXsP3kAWj4LCSjS1nqapNxi758O9RIvWKmp3FTGnkO00IsQJxgHztRQHO68FgOmlH6LhWbclnKxbHaig8wtL5Or39I6eKP69LIF7mD/yZ1Y0K33CYc2hZ5BiRD7E0BOV4P/nE/qCUxvUd0i/xhrWsSHsZYi0zqw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=my7tjq6i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kgC7JdtT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=my7tjq6i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kgC7JdtT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="my7tjq6i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kgC7JdtT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="my7tjq6i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kgC7JdtT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6DCC21FB41;
	Thu,  2 Oct 2025 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759398520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PYj0YLHZPh5dNkSxVeGcG3DC+5MmzAfFxOnJpqz3uQw=;
	b=my7tjq6ihLlo1U+MCJr0ddsBn7BPdvjIhUd5UpPID6tL5JiKIrxzUWKnBXPnD06WkXnaXf
	h6d8gUOqi1Gnq7v0dz+2L5QKG0rWnsyDNgPwkYZ3JNztEhJ9RRtCBZCLOmSzxZjBw7YCE3
	OQY9nNhUc/kO1ooy4Rt2x5msps3GemM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759398520;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PYj0YLHZPh5dNkSxVeGcG3DC+5MmzAfFxOnJpqz3uQw=;
	b=kgC7JdtTcXwUTKvl34JdkgXIQTDFKOiwbLbqG5qs3ZdyItZWyCesP3BRQclZhVDBe/xYA0
	OUV2Jn6G9S+r1TCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=my7tjq6i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kgC7JdtT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759398520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PYj0YLHZPh5dNkSxVeGcG3DC+5MmzAfFxOnJpqz3uQw=;
	b=my7tjq6ihLlo1U+MCJr0ddsBn7BPdvjIhUd5UpPID6tL5JiKIrxzUWKnBXPnD06WkXnaXf
	h6d8gUOqi1Gnq7v0dz+2L5QKG0rWnsyDNgPwkYZ3JNztEhJ9RRtCBZCLOmSzxZjBw7YCE3
	OQY9nNhUc/kO1ooy4Rt2x5msps3GemM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759398520;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PYj0YLHZPh5dNkSxVeGcG3DC+5MmzAfFxOnJpqz3uQw=;
	b=kgC7JdtTcXwUTKvl34JdkgXIQTDFKOiwbLbqG5qs3ZdyItZWyCesP3BRQclZhVDBe/xYA0
	OUV2Jn6G9S+r1TCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1B28B1395B;
	Thu,  2 Oct 2025 09:48:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yL5aA3hK3mgvcgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 02 Oct 2025 09:48:40 +0000
Message-ID: <4814384f-5fe2-491d-9424-7a0aebbbda1d@suse.de>
Date: Thu, 2 Oct 2025 11:48:34 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
To: Nikolaos Gkarlis <nickgarlis@gmail.com>, netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de
References: <20251001211503.2120993-1-nickgarlis@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251001211503.2120993-1-nickgarlis@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 6DCC21FB41
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51



On 10/1/25 11:15 PM, Nikolaos Gkarlis wrote:
> Before ACKs were introduced for batch begin and batch end messages,
> userspace expected to receive the same number of ACKs as it sent,
> unless a fatal error occurred.
> 
> To preserve this deterministic behavior, send an ACK for batch end
> messages even when an error happens in the middle of the batch,
> similar to how ACKs are handled for command messages.
> 
> Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>
> ---
> Hi,
> 
> I recently came across the issue introduced by bf2ac490d28c and
> while trying to find a way to handle it by adding an ACK on batch
> begin, end messages, I spotted what looks like an inconsistency?
> 
> I have tested this change with my userspace application and it
> seems to resolve the "problem". However, I am not sure if there
> is a suitable place to add a regression test, since AFAIK nft
> userspace does not currently use this feature. I would be happy
> to contribute a test if you could point me to the right place.
> 
> I may be missing some context, so feedback on whether this is the
> right approach would be very welcome.
> 
>   net/netfilter/nfnetlink.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 811d02b4c4f7..0342087ead06 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -600,6 +600,11 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>   			status |= NFNL_BATCH_FAILURE;
>   			goto replay_abort;
>   		}
> +
> +		if (nlh->nlmsg_flags & NLM_F_ACK) {
> +			memset(&extack, 0, sizeof(extack));
> +			nfnl_err_add(&err_list, nlh, 0, &extack);
> +		}
>   	}

Right, if BATCH_END message is reached and has the NLM_F_ACK, nfnetlink 
should send the corresponding ACK. Currently if BATCH_END message is 
missing, this would send an extra wrong ACK if the previous message was 
using NLM_F_ACK.

e.g for a batch formatted like (BATCH_BEGIN|NFT_MSG_NEWRULE + NLM_F_ACK) 
- nfnetlink would send two ACKs while it should be only one. Granted it 
won't configure anything but it would be still misleading.

What about this?

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index b8d0fad1ed10..ecf85346d883 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -601,7 +601,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, 
struct nlmsghdr *nlh,
                         goto replay_abort;
                 }

-               if (nlh->nlmsg_flags & NLM_F_ACK) {
+               if (nlh->nlmsg_flags & NLM_F_ACK && status & 
NFNL_BATCH_DONE) {
                         memset(&extack, 0, sizeof(extack));
                         nfnl_err_add(&err_list, nlh, 0, &extack);
                 }

>   
>   	nfnl_err_deliver(&err_list, oskb);

