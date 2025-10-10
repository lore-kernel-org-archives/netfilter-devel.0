Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774DC26658A
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 08:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760086791; cv=none; b=kCuWLDasTE1FJ6tqXB7kcKMWF3sQccceaKBos/D8XcRF4hMGafM27WBNMIFQpLJz+YyOv186EiRTFPQAJqw/WGNu1cFELu6EiDzU9NMwh06SZPBI2jUg5fOn/jIq1S+xD9XLEWb6ZqYGSwvtH1w5lUGWOs+0JWECb2XL9Ueb63Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760086791; c=relaxed/simple;
	bh=Lu5e34vSpb5XKotrgCZEKMzwPyHptuYEslpGGFnxIrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a+6vSnCpAnnnO2PRxr36lUdNhTBxD34287a61s0+My32yrqMEFrvVEWpj8czx6FmvuiEA1OQKmaB6HnkIanALx0ypqwWUhqV5QDPUXQ1qX0ofComLHfS2FVUOYXv8q/VmQ8TMv+MM1HhEiMNsrhnpma29Cbrcz4a4j5fhM2cH9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0B66+BIe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aZQF7ucA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0B66+BIe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aZQF7ucA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0B66+BIe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aZQF7ucA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0B66+BIe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aZQF7ucA"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A8E631F393;
	Fri, 10 Oct 2025 08:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760086786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j+ynKor5BGcRHYFm8YRktqulMVTEFgyJk2yEJsJnafE=;
	b=0B66+BIeh8mhWAX1pR9dDLJuSGZCpbiX29lUMHjyat7ezy1t0cAkNirogyPw2ZI1sOAflN
	ezlfXxl5rJQSzx+yDJJmjojAMdTcOUnHNaYxLH/tZx6dOwu4/9Sg4uaum/SkNV3bis0Es8
	mWR8JnKyW/Gxy6KDeFwteJ24FmFSVz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760086786;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j+ynKor5BGcRHYFm8YRktqulMVTEFgyJk2yEJsJnafE=;
	b=aZQF7ucAWqZJVfXnhiXPsZ/NsHCCiS7xwQzLNukxLxoKmbifmoSh8eq8SxJKPh7+bAK6Qh
	w2pgoqKOvROBFgAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760086786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j+ynKor5BGcRHYFm8YRktqulMVTEFgyJk2yEJsJnafE=;
	b=0B66+BIeh8mhWAX1pR9dDLJuSGZCpbiX29lUMHjyat7ezy1t0cAkNirogyPw2ZI1sOAflN
	ezlfXxl5rJQSzx+yDJJmjojAMdTcOUnHNaYxLH/tZx6dOwu4/9Sg4uaum/SkNV3bis0Es8
	mWR8JnKyW/Gxy6KDeFwteJ24FmFSVz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760086786;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j+ynKor5BGcRHYFm8YRktqulMVTEFgyJk2yEJsJnafE=;
	b=aZQF7ucAWqZJVfXnhiXPsZ/NsHCCiS7xwQzLNukxLxoKmbifmoSh8eq8SxJKPh7+bAK6Qh
	w2pgoqKOvROBFgAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71D6D13A40;
	Fri, 10 Oct 2025 08:59:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aO/MGALL6GgwVgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 10 Oct 2025 08:59:46 +0000
Message-ID: <768c63ea-0769-440e-a032-e969a893074f@suse.de>
Date: Fri, 10 Oct 2025 10:59:29 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft] tests: shell: add packetpath test for meta ibrhwdr
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20251009162439.4232-1-fmancera@suse.de>
 <315ffc1a-86ee-4173-adeb-69a4611cd892@suse.de> <aOhHKOiWd9E18Jc0@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aOhHKOiWd9E18Jc0@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
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
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 10/10/25 1:37 AM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>> +# cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
>>> +# v6.16-rc2-16052-gcbd2257dc96e
>>
>> I just noticed this version is wrong. Probably I need to wait until
>> 6.18-rc1 and resend this. Anyway, feedback on the test is more than
>> welcome :-)
> 
> No worries, this looks good!
> 
> Do you think it makes sense to also add a counter-hook in ipv4 input?

I don't think so as in $ns2 the counter would be always zero, with or 
without the meta ibrhwdr rule.

Thanks!
