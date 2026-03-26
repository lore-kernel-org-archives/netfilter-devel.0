Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B553430AAA9
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 22:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774562780; cv=none; b=DoBaYEpcT/JZtS8zGbmxmi3QHUo3diXO8AiVAZG4fnRgu0S8QgWK4d2IMj95Rh05LXBdjMel1fpGz0JL3lzUj0HSBpwjtVAb6WZoVaEj1NYMP89b2/3IlYrzu+v49ZBGZqVnYw3Uj3qLXYcJi5VBmCTZnQ8HETOdPvOENYCOZyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774562780; c=relaxed/simple;
	bh=v3mmPSrHXgS0vh27+AGvxS9zxdFJCFjK3tKOGOPGH94=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=BM8uoY66k4wHJdtZE/SkAzwd+Mr5n88nbj3JXZ4Ok2nqPZvVjhvhdy8PpemcX+q0yxqryoCdpdM/U4kU8n7B9Qc6QkODhiS/r4yr/1FmClnICjNOuqwPvBKaENbBCVEfvaz1AS6g0B9+dDUtHX2Pta53lMGzEHxDxJ6ywIiC0wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rAqU2Bc4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QNIlKBcd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hg9M6s+y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2YmdJcqC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rAqU2Bc4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QNIlKBcd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hg9M6s+y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2YmdJcqC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D9A745BD3C;
	Thu, 26 Mar 2026 22:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774562778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5uBDqvC+rEQtu2SfGzpVJGr1mpxIyT7TuD9aAnZaTPM=;
	b=rAqU2Bc42+VZ58UXsWsu6rjx8Aw5lWzA8KDL8wnZcLDf4d4+uAr9yPwx0a4PRiIbneEPJY
	Dh8o0NVMi54ZOz5QQrNoHVWkWc/y3TNJHnpquxnzTQ84KZ7k49kdeVDTTx6DoqHNnxEAWr
	LwFKj4RhKReqWOjlUXQaz0BMu6aFJi0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774562778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5uBDqvC+rEQtu2SfGzpVJGr1mpxIyT7TuD9aAnZaTPM=;
	b=QNIlKBcdHv4Ib+znHyn858hsSVj/cgraHZeFrsCNOLyOAG+Q4W6r+HmNwxik2v6NdeeSM6
	8fY79Ykj+8xpMeCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hg9M6s+y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2YmdJcqC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774562777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5uBDqvC+rEQtu2SfGzpVJGr1mpxIyT7TuD9aAnZaTPM=;
	b=hg9M6s+yjwkVD4vtF+LB9S303JniJEA+xIkACeYYZ+8Cawwe499XocTQoze+khqdclg64E
	RA6nX0rBg94a26QSRo3vLP9cazn9lojsLOw0yb114MsFK9jmXRENidr/FMxMM881ZpJIPC
	8o9gE1ZF719lDN7Ndl1QCPKEc5aaHW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774562777;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5uBDqvC+rEQtu2SfGzpVJGr1mpxIyT7TuD9aAnZaTPM=;
	b=2YmdJcqC7PAx22Bbs4Wa9VmRNnofuvPzW+E6CKYy0k276YnwnErx6xoVmAVkjAeYvXYO2M
	XxZHev9L2iuyLpDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B8184A0A3;
	Thu, 26 Mar 2026 22:06:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lakyItmtxWnteQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 26 Mar 2026 22:06:17 +0000
Message-ID: <367c26f5-4eb9-4313-bf1a-cb7650ca9858@suse.de>
Date: Thu, 26 Mar 2026 23:06:09 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: flowtable: strictly check for maximum
 number of actions
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
References: <20260326200935.729750-1-pablo@netfilter.org>
 <f164d975-7134-4638-a8fc-b3348a599797@suse.de>
Content-Language: en-US
In-Reply-To: <f164d975-7134-4638-a8fc-b3348a599797@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,netfilter.org:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -5.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D9A745BD3C



On 3/26/26 11:02 PM, Fernando Fernandez Mancera wrote:
> On 3/26/26 9:09 PM, Pablo Neira Ayuso wrote:
>> The maximum number of flowtable hardware offload actions in IPv6 is:
>>
>> * ethernet mangling (4 payload actions, 2 for each ethernet address)
>> * SNAT (4 payload actions)
>> * DNAT (4 payload actions)
>> * Double VLAN (4 vlan actions, 2 for popping vlan, and 2 for pushing)
>>    for QinQ.
>> * Redirect (1 action)
>>
>> Which makes 17, while the maximum is 16. But act_ct supports for tunnels
>> actions too. Note that payload action operates at 32-bit word level, so
>> mangling an IPv6 address take 4 payload actions.
>>
>> Update flow_action_entry_next() calls to check for the maximum number of
>> supported actions.
>>
>> While at it, rise the maximum number of actions per flow from 16 to 24
>> so this works fine with IPv6 setups.
>>
>> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload 
>> support")
>> Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> ---
>> This is the large version of this fix, it should be possible to make a
>> much smaller workaround patch. This codebase did not change much since
>> 2019, backports should be not too complicated.
>>
> 
> Hi Pablo,
> 
> I assume this the larger version of https://patchwork.ozlabs.org/ 
> project/netfilter-devel/patch/20260325164130.29060-1-fw@strlen.de/ right?
> 

Never mind this comment, I just read your email on that patch. Sorry.
