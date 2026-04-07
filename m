Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D2233A9DE
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2026 19:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775590471; cv=none; b=khxmdgktcMZc2KvV0eRj9KBmbqkJyHems53b89hyiOh/msZ1ZDulHp2G3SID2MklSmM/QMsRPYuMOwewtFtJNopbPF5Z7B0LpvkZEDfbrxWMedEyGN8vrYK6gVMqFQMP/R56pXHzp80pj1gKAyEZP2YNpW4dZ3zAWAuMmZZEHSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775590471; c=relaxed/simple;
	bh=V7Gh+845xYvIW26UARQxpPHsgFaPVEP4TUiyr1n5ezA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BX5IByFK3fzDkP7YlnqBTofg48FF5gsaqbyPq/6rOVSAATBmQIRVwzAQiW/9W0flOg4rH2fmk4QAXWuosUhxLJL5YUk3buSlLzHDLQO8Qpxse/5ZbDVbC2HrgxvFqgWVwVoxMKs3cOZPyFAsSD9K+b/ZFi8gl+CEQ3d7C5O69GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RwZJOrgX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4jb4KF+A; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RwZJOrgX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4jb4KF+A; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RwZJOrgX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4jb4KF+A";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RwZJOrgX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4jb4KF+A"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C0D774E5D3;
	Tue,  7 Apr 2026 19:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775590468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=62uM43zB43uvccMyvsDAM55ssBOUwtlrlov1fgW9N9o=;
	b=RwZJOrgXvGBK8mY4W0NDrc+DFymu8Rn/xcitlrJ5JH9TK7HQofskYGSs9itzTd7L9yOlG1
	DvzHwDFCdsui2I2CljaV2IoXR94CeIUG0dtD19AYVjS5ksUBRssFRKl7Gg5H+s2oXHI33N
	wvlspd0o61gajcuPtjVoqJU0r2/xp5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775590468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=62uM43zB43uvccMyvsDAM55ssBOUwtlrlov1fgW9N9o=;
	b=4jb4KF+AVbwMVpvgUUMs4Anui+TKTphnTdRxgapp6UL25EoVGPPs1OPUiAKXS44ueEzF0h
	4xplj1zK9lAztHAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775590468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=62uM43zB43uvccMyvsDAM55ssBOUwtlrlov1fgW9N9o=;
	b=RwZJOrgXvGBK8mY4W0NDrc+DFymu8Rn/xcitlrJ5JH9TK7HQofskYGSs9itzTd7L9yOlG1
	DvzHwDFCdsui2I2CljaV2IoXR94CeIUG0dtD19AYVjS5ksUBRssFRKl7Gg5H+s2oXHI33N
	wvlspd0o61gajcuPtjVoqJU0r2/xp5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775590468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=62uM43zB43uvccMyvsDAM55ssBOUwtlrlov1fgW9N9o=;
	b=4jb4KF+AVbwMVpvgUUMs4Anui+TKTphnTdRxgapp6UL25EoVGPPs1OPUiAKXS44ueEzF0h
	4xplj1zK9lAztHAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A3814A0B0;
	Tue,  7 Apr 2026 19:34:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pU14O0Nc1WmrQgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 07 Apr 2026 19:34:27 +0000
Message-ID: <44245235-03b0-4dc5-88a1-6b05d8119b7a@suse.de>
Date: Tue, 7 Apr 2026 21:34:17 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] selftests: nft_queue.sh: add a parallel stress test
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
 pablo@netfilter.org
References: <20260406211831.3758-1-fmancera@suse.de>
 <adVILlipGGN76rcw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <adVILlipGGN76rcw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 4/7/26 8:08 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
>> index ea766bdc5d04..1e1949c6a918 100755
>> --- a/tools/testing/selftests/net/netfilter/nft_queue.sh
>> +++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
>> @@ -11,6 +11,7 @@ ret=0
>>   timeout=5
>>   
>>   SCTP_TEST_TIMEOUT=60
>> +STRESS_TEST_TIMEOUT=300
> 
> I changed this to 30s, I think the full 5m dance is a bit
> too long for the selftest.
> 
> I know 30s is likely not enough to trigger the bug reliably but given this
> test will run may times per day on netdev infra I think 30s is ok.

It makes sense. Indeed, it is enough time. At least as tested on my system.
