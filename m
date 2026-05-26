Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612083FC5A8
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 13:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801198; cv=none; b=KZ3MQE+rOOtXSdfeVZswQ/pswGTPsHcD2IBE3EjG2UEokClFbA9FJxJwRkUb/97QaNI878xHquk9hYXJdHvARxApSkz1okzdejNyS1DnmJ5YX4C85DOFsbu6c/rm4pBXGDXjdi1i0Po3WDxDED7S3EOBH7cWtrTI/9j2NYf54EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801198; c=relaxed/simple;
	bh=B0blJg1Ouyh7ilMkBNKumKjjP52qFjKURnNFx+fzHlI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C/6QzILqWitzc67xvfpGAmVC6IDrMjfZIN0lFXxyc3Lpu7yU+Na6qgW/lNK3xj8QSDntPlcUFg5XxiMAv159xOMkh0QANyaj1wrims2NIgUZNh29p2tOu7uIoDvsxWRgHf4cbSHT2k+Hmbl678qAsqit1xU7K9D696Bgn2xPTw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g9up/crd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DU2UWZNB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g9up/crd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DU2UWZNB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g9up/crd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DU2UWZNB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g9up/crd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DU2UWZNB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9A75175E1F;
	Tue, 26 May 2026 13:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779801195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YwIHecXYS+lB6LLphRBK2MbARoCv9+EBdOvk+v2yK6E=;
	b=g9up/crdhYor669lOBspQOvB1UuKOOfLvWfxmavJg8lvPBbwoPJXokt0alXO2/WDy08GdF
	IyTe/p5Bsml7s/IkaPXbx5MWkLeuF5l9oQCm9uROwmbc7s+8uSPqhxK1+zEqzLR1LMx2rI
	lRV9Ep+ogQxyVR4WvBKkSQ2wLwGqlGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779801195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YwIHecXYS+lB6LLphRBK2MbARoCv9+EBdOvk+v2yK6E=;
	b=DU2UWZNBlDwo0WAZ7ax3IiUf+qiBLn9o2zXEGmckqsLnSDo9L99mmk1mKLCnRyq6HcWoue
	MyDv5PUApWHHYEBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779801195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YwIHecXYS+lB6LLphRBK2MbARoCv9+EBdOvk+v2yK6E=;
	b=g9up/crdhYor669lOBspQOvB1UuKOOfLvWfxmavJg8lvPBbwoPJXokt0alXO2/WDy08GdF
	IyTe/p5Bsml7s/IkaPXbx5MWkLeuF5l9oQCm9uROwmbc7s+8uSPqhxK1+zEqzLR1LMx2rI
	lRV9Ep+ogQxyVR4WvBKkSQ2wLwGqlGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779801195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YwIHecXYS+lB6LLphRBK2MbARoCv9+EBdOvk+v2yK6E=;
	b=DU2UWZNBlDwo0WAZ7ax3IiUf+qiBLn9o2zXEGmckqsLnSDo9L99mmk1mKLCnRyq6HcWoue
	MyDv5PUApWHHYEBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 455585A20B;
	Tue, 26 May 2026 13:13:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vsvTDWucFWpvYwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 26 May 2026 13:13:15 +0000
Message-ID: <184fa254-0792-4097-a57e-9fdca70a8f57@suse.de>
Date: Tue, 26 May 2026 15:12:52 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4 nf v2] netfilter: synproxy: fix possible write to
 stale pointer
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc
References: <20260525124450.6043-1-fmancera@suse.de>
 <20260525124450.6043-5-fmancera@suse.de>
 <df64cebb-1279-4e66-afa7-3d8ffca4928f@suse.de> <ahSb-UU8n9o1aHoI@strlen.de>
 <4887bf00-d044-4366-8588-a83e4bce0274@suse.de> <ahWatXyiNiBrE9FX@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ahWatXyiNiBrE9FX@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On 5/26/26 3:05 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>> In particular, seqadj and concurrent registration.  As these bugs aren't
>>> as severe as patch 4, I think nf-next would be fine as well.
>>>
>>>
>>
>> I have been taking a look to this. The seqadj issue isn't real IMHO.
> 
> We could be processing a 2nd packet in parallel, in particular reply
> direction is a concern.
> 

Ugh. I missed that. Yes, then it seems real. Let me wrap it with proper 
locking..

Thanks Florian and sorry for the noise :)
