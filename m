Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865681552FD
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 22:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758754674; cv=none; b=WiQaM4GXsJPH4Y61a/drRoAmLWeVJy0wmm1Pd1DzMw+1p9h8dH8pXdtiA5vfjF2M4nbdGTV8QRTTLilVcBGk7fbXyZZtFQrGZpcIDzrR3RyrDE+NAtJIJvGsc8tQYwU/Ah4YGP4c9+k+Nr8tBw5Qdf9fFabcY1okIW1uaoFepy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758754674; c=relaxed/simple;
	bh=0Tro1s+a26/sKy2o1715pp2LM3OYQV3tcVMG/CLReNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g1/BHiaNzkmzpVKGwvXOX2bwuK2X+OfKEqwMtISTcgYu9bvMGZytYX/XpcXKZQSVF6POrzsj74UqRxUmmRWX4SoUmCtQse4dTnBG9famZ4u8av3HKVj8Cnf2dZsFH5dyjJnFZiR8YYYWotj9RjmSyAxrK2SkQLDtx86QC03xub4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A4of2wyo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y8BwQFgn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A4of2wyo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y8BwQFgn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A4of2wyo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y8BwQFgn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A4of2wyo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y8BwQFgn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CC093F32B;
	Wed, 24 Sep 2025 22:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758754670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ExO6Av5GCOnGHT6HrUI05Cz90BMebJot8wQ1XFtOdZU=;
	b=A4of2wyoNAkEZpY54N/DTJh+87O4SVxGqvfAKDJe5R7yQ6rIiOX1jHUrl0nOfyoZGYvqc1
	J3Z0hRXPJxtCjN6LC65AhtqysmkmirP2NLq+O8ywHVZynZzg3dkWwkYsvyvDa6RQYoyrru
	iYSUWGJ+/KqQG/x1zX0jWEOIRyWbxlw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758754670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ExO6Av5GCOnGHT6HrUI05Cz90BMebJot8wQ1XFtOdZU=;
	b=y8BwQFgnm+A4ODzJdx455W3VT1BGhcndNo5dgdniJVVZHRmFht2QThe8ITD1BPVT5UaQfL
	SS/OE2QcQJjBPfAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758754670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ExO6Av5GCOnGHT6HrUI05Cz90BMebJot8wQ1XFtOdZU=;
	b=A4of2wyoNAkEZpY54N/DTJh+87O4SVxGqvfAKDJe5R7yQ6rIiOX1jHUrl0nOfyoZGYvqc1
	J3Z0hRXPJxtCjN6LC65AhtqysmkmirP2NLq+O8ywHVZynZzg3dkWwkYsvyvDa6RQYoyrru
	iYSUWGJ+/KqQG/x1zX0jWEOIRyWbxlw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758754670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ExO6Av5GCOnGHT6HrUI05Cz90BMebJot8wQ1XFtOdZU=;
	b=y8BwQFgnm+A4ODzJdx455W3VT1BGhcndNo5dgdniJVVZHRmFht2QThe8ITD1BPVT5UaQfL
	SS/OE2QcQJjBPfAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6BFB213A61;
	Wed, 24 Sep 2025 22:57:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tTC4F2531Gh8IQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 24 Sep 2025 22:57:50 +0000
Message-ID: <9a19b12e-d838-485d-8c12-73a3b39f1af2@suse.de>
Date: Thu, 25 Sep 2025 00:57:37 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 0/6] netfilter: fixes for net-next
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <20250924140654.10210-1-fw@strlen.de> <aNRwvW4KV1Wmly0y@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aNRwvW4KV1Wmly0y@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30



On 9/25/25 12:29 AM, Pablo Neira Ayuso wrote:
> Trimming Cc:
> 
> On Wed, Sep 24, 2025 at 04:06:48PM +0200, Florian Westphal wrote:
>> Hi,
>>
>> The following patchset contains Netfilter fixes for *net-next*:
>>
>> These fixes target next because the bug is either not severe or has
>> existed for so long that there is no reason to cram them in at the last
>> minute.
>>
>> 1) Fix IPVS ftp unregistering during netns cleanup, broken since netns
>>     support was introduced in 2011 in the 2.6.39 kernel.
>>     From Slavin Liu.
>> 2) nfnetlink must reset the 'nlh' pointer back to the original
>>     address when a batch is replayed, else we emit bogus ACK messages
>>     and conceal real errno from userspace.  From Fernando Fernandez Mancera.
>>     This was broken since 6.10.
> 
> Side note: nftables userspace does not use this feature. This is used
> by a tool that is not in the netfilter.org repositories, to my
> knowledged.
> 

Yes, that is right. It was found in an external tool using libnftnl 
directly. FWIW, the libnftnl examples also uses the NLM_F_ACK for the 
messages containing data as new rule, chain, table..
