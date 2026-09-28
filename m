Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DE647141C
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 21:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790630296; cv=none; b=cvYinAsFzYcUv18352/dWdXqybpqLRhoDcYX3VBoVra4VGmMFtTcq1Jgl2c/xx/V9Mvxd9zMdJADXz/+mZbO9GUZEQNwW6gfxEJIBJ/0CxLH4la1awvgLVZR/oA7EbPraOwGteFXfgGSrGhNSHNty6Eo/0eOLPb+Pae76JN0+J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790630296; c=relaxed/simple;
	bh=5r1IFZ/qBfPSwzVuYRLz5spv47UX1Kypl4JFIo6mj4U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Kykk4e5wixMnxtsXJY5xSAyUvWNqg7yiOB/IhtbpCarXhfZsVBcLpz++Ih8vAjz/MDOV6Z3ukT154tg7iEmPIIL3gvoTCF5JmGnhrDbzV9QxQwWeYnKbV9wztUFkN157pDQhJ0gRFxlPSDp0p69Y9Nj6Jpfv5C1pmmNG0GqMp/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BIA7EqIs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i8YnAz3M; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=t4Tnrutm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xlsQ2mIb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BIA7EqIs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i8YnAz3M";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="t4Tnrutm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xlsQ2mIb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8F52B21B5A;
	Mon, 28 Sep 2026 21:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790630287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOcFhutnWs3sH0lvFRBICQc9XEEqYFSBZHVhmKJjUfE=;
	b=BIA7EqIsU39gEfrQqWQhJFdVp1n5zOqfEk3ZwzGVNbn2DEZyXZsUjwfdJNU/C0+xNkMAU7
	YRGZmMxWst+2I+RhWzgAeZIkKcXYED2hxTLzl1PtOHwu2i6koRsTcX/8snli1DiYVDgJt+
	jv3mlg6VG4CR+Vg7pbPOmKYtxJu4HRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790630287;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOcFhutnWs3sH0lvFRBICQc9XEEqYFSBZHVhmKJjUfE=;
	b=i8YnAz3M2fl1Esi4b9Eq244n/DDjDvqp/lwIP8Bbub9sAwFgSRiFwsfqXbhMJJyH8MRdFA
	za4X7LF39UgaMsDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=t4Tnrutm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xlsQ2mIb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790630283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOcFhutnWs3sH0lvFRBICQc9XEEqYFSBZHVhmKJjUfE=;
	b=t4Tnrutm13yFAsxZmkLwbjyyo5f0v6AqrIG98xUkqhzQtB1WbZCLdPB13ptNjIIUvIas7p
	ZhB2XPs4RM27625wmvs6zBub19T+EyKc7wcmXCbgZqkRrI/3istSieMs3QuIDNOJrid98Y
	Y/iyOMxFyDua5H/pqFeECJGiLvHGD9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790630283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOcFhutnWs3sH0lvFRBICQc9XEEqYFSBZHVhmKJjUfE=;
	b=xlsQ2mIbCo/BVS8DjhNjTcgmcMDF5Y8VcoBNOEqJ41o+i+z9pr8KBBVvSvuMKrheEnpjaS
	YbuYfhdu7LIGcBBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 133DC133F3;
	Mon, 28 Sep 2026 21:18:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ApuVNIrZumrrJAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 28 Sep 2026 21:18:03 +0000
Message-ID: <0c08f9e6-123f-4514-a865-6f9e0f979167@suse.de>
Date: Mon, 28 Sep 2026 23:17:07 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Netfilter: match "tcp option" with the same type present multiple
 times
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: Matthieu Baerts <matttbe@kernel.org>,
 Netfilter Devel <netfilter-devel@vger.kernel.org>,
 Netfilter Coreteam <coreteam@netfilter.org>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <f9690303-d022-4dd4-8050-ca8e00f8f71c@suse.de>
Content-Language: en-US
In-Reply-To: <f9690303-d022-4dd4-8050-ca8e00f8f71c@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 8F52B21B5A
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/28/26 10:54 PM, Fernando Fernandez Mancera wrote:
> On 9/28/26 2:13 PM, Matthieu Baerts wrote:
>> Hello Netfilter devs,
>>
>> First, thank you for maintaining Netfilter in the kernel and the
>> userspace tools.
>>
>> The MPTCP selftests are switching from IPTables to NFTables, and
>> Clashiko reported that this part of a rule wouldn't match anything:
>>
>>    tcp option mptcp subtype remove-addr drop
>>
>> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
>> added to the TCP options, it is added after an MPTCP DSS option (type
>> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
>> (type 30) options in the TCP options. It looks like Netfilter doesn't
>> handle that, because it stops processing other TCP options when the
>> expected type is found:
>>
>> net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
>>      ...
>>     for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
>>         optl = optlen(opt, i);
>>
>>         if (priv->type != opt[i])
>>             continue;
>>         ...
>>         return;  // <== it will look at the first MPTCP option
>>     }
>>      ...
>> }
>>
>> It looks like it shouldn't stop if the wrong subtype is found, but the
>> subtype is not compared there if I'm not mistaken. Should there be a fix
>> to support this case?
>>
>> For more details about the Clashiko report:
>>
>> https://lore.kernel.org/179058242453.3145.1450534124183352369@kernel.org
>>
>>
>> BTW, I'm probably missing something, but adding the following doesn't
>> seem to have any effect on my side:
>>
>>    nft add table ip filter
>>    nft add chain ip filter OUTPUT \
>>      { type filter hook output priority filter; policy accept; }
>>    nft insert rule ip filter OUTPUT tcp option mptcp exists counter drop
>>
>> Same with "mptcp subtype mp-capable", other subtypes or other types like
>> "timestamp". But if I use ...
>>
>>    nft insert rule ip filter OUTPUT meta l4proto tcp counter drop
>>
>> ... then the drop is effective. Any idea what I'm missing here? :)
>>
>>
>> (Also, it looks like the MPTCP suboptions are not documented in the nft
>> man page :) )
>>
> 
> Tomorrow there should be a patch in netfilter-devel adding it, we 
> definitively should put more work into documentation.
> 

While at it, I will also document the existing limitation that was 
discussed above too.

>> Cheers,
>> Matt
> 

