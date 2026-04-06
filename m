Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B7B311963
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Apr 2026 20:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775505854; cv=none; b=fyW0UVNXQkFSrK+kNrz/s1Sre5p0CHoQgcgFndBfYvxx4u4gIiqt3XBMlvrK1AVQEO5m1tVkV/6F3zpJy9xOyc1Gyopmdbf95OqQfN6CSDF9jRmrLBxCRMEuTEXqWP8i06Kr3vovtDnWTnEEse+6oGhY4Vb9XEKvbECiQd+MqeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775505854; c=relaxed/simple;
	bh=FiaMu9IBZGIIgmOauoNq95oYE4Oc4P/2K7u4ZuJCslk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owqfGTO9psDlSG2RhvNIdAC4yh1LfB+9Kbmbi3ugl5/SmDbO5jrmGXSKJBA9oJN2vW/0qohYUsi2HeMOOttNmCskiIUGk1THiS5yIaNc7xBrFXLPjTI9PubOQfbycGGe4HvPu/a6yMkjTbJAxfncU3CE2U6sQbUGlKk9Z1kXOdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bGtbaZX9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=I8fSoV/K; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WP+xnYCG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6bAnJvew; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bGtbaZX9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="I8fSoV/K";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WP+xnYCG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6bAnJvew"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9183F5BDD9;
	Mon,  6 Apr 2026 20:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775505851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDTxBS8UdnQYyaP5sVoYqg/OsPJ5o16B635kObHxDUA=;
	b=bGtbaZX9mt25eztfOumOlvBCWAH5wmykkuXdQpHQDUAl0GYjQ0QwPELbV000gdoX/pjjrS
	dQytPelS6N+xqtzSUOEg6fQPu3L4s9kaTIV8jsDy8tvUpNExbkVhsO7Ps1l6C0Xn1ImkGK
	ZHRJt6DzIzuZs65Hf2b1d18WL567ia8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775505851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDTxBS8UdnQYyaP5sVoYqg/OsPJ5o16B635kObHxDUA=;
	b=I8fSoV/K9zaSXTn2OL7Dh5RsOLufMtODWaVTAXFVxN/2AZ+1WcYK9ma1D1p97TkgGI5YSH
	Id86GyYMFBZrrHCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WP+xnYCG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6bAnJvew
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775505850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDTxBS8UdnQYyaP5sVoYqg/OsPJ5o16B635kObHxDUA=;
	b=WP+xnYCGZtaaLb4l4cvWHPN9x1rXWVL0MezoxHnQSvowov0picBtmxtb2j53i34uO0T42s
	I3gN1woluD6Oe+XE+gul7yPRN+apypBqsV9d82UPgv/wvYZvMOu5BRvvD//9Wkp4/4XjW1
	o5u6l2gAMCwmJhlzgTBm3StE8Iv/v8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775505850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDTxBS8UdnQYyaP5sVoYqg/OsPJ5o16B635kObHxDUA=;
	b=6bAnJvew9VI0y7eyYNAbjl6JrR6G4zvivECMisnbcd8iJfC/FG9CMUrxQJAxTxaxWpoey9
	Df07bIISddmygSDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B4324A0B0;
	Mon,  6 Apr 2026 20:04:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3GhlE7oR1GlXOQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 06 Apr 2026 20:04:10 +0000
Message-ID: <6455e07a-20ad-4be8-be96-4b804ed5e118@suse.de>
Date: Mon, 6 Apr 2026 22:04:09 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: nfnetlink_queue crashes kernel
To: Florian Westphal <fw@strlen.de>
Cc: Scott Mitchell <scott.k.mitch1@gmail.com>, netfilter-devel@vger.kernel.org
References: <ac-w6e33txkgTRJj@strlen.de> <ac_EY9ciqt5yQ6wr@strlen.de>
 <b0c495e4-2137-443b-986e-ed0c10251d0c@suse.de> <adDccAnxkl4to_ta@strlen.de>
 <867c1ae1-66b4-4584-985a-38a4f7d55925@suse.de> <adPpAPURumLBRrp8@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <adPpAPURumLBRrp8@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email]
X-Rspamd-Queue-Id: 9183F5BDD9
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 4/6/26 7:10 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 4/4/26 11:40 AM, Florian Westphal wrote:
>>> I had a go at adding a stress test but its not
>>> triggering for me even if i run it for 10m.
>>
>> Bingo! I modified the test you attached a bit to include your
>> suggestions and I got the splat on virtme-ng when running the test. See
>> the whole splat attached below.
>> I am going to test your proposed patch and check out the results. In
>> addition I will do some cleanup and send this as a formal nf-next patch.
> 
> Thanks Fernando, this helps a lot.
> 

No worries!

> Given the revert isn't clean and the per-queue ht fix isn't larger
> than the (modified...) revert I am still considering to apply the fix
> to nf instead of revert + nf-next defer.

Then I will send it to nf tree instead. I don't have a strong opinion.

Thanks!
Fernando.
