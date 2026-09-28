Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB65237F00B
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 20:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790628950; cv=none; b=YmDtRK/521jSI12z1lz8dzdnPuZiNf8WuDjXT0uLiMV7ypgD/fBsJnL+X+NO/Mzf+Bl2XfoGa/FB+VmhFFaxDezI8mlNNRWUjy/dQ6HC375n0vuu5uNTIx8j6HjHqOyglBDHZ20ALu79rQlc7Mn/Raf45bXHnoIvoLWNl5mGhFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790628950; c=relaxed/simple;
	bh=V7tb3aNt5SuShUXsBlZ76yLZmYZ89Vw2dBGOZyb5BV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=If+ekuRrf71151JgmOt/BtwGZPexdj2IfgAULv6Ud4jCxCA09PhdbIK44pkbiw0WBwf8xjUsIYX1lrMkx8xP7JEpNBxS98uUlKOFGTUYSKVxTmZ5b/ELteM+JJ0hWHzjo8ya0DU+Q/JHkFQ2+bwV4BtnBHJos6zBAoXSSfXlm2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LwUHppja; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RL29oWgy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iDJsyBJ6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JH7phM8b; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LwUHppja";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RL29oWgy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iDJsyBJ6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JH7phM8b"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 767BA1F785;
	Mon, 28 Sep 2026 20:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790628942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kXn9g8niZAe7JHP7xKRI6ptYk/Y9JnOmT7kr+bEqi6o=;
	b=LwUHppjao/v+aZUYXLXvL0ETJVpvClghEdhKNhYn/uc6xTM9JIFSut/C8I6BgQj4iTAQa8
	5l5SW8fteCP9DTxCAjDCg7vp91SO3jPKL/qXnQQa8Y5J7c2pJE3gfRmxWmcfeqgmUEsteB
	nxGNFrZD6HmcElIGnG6YUG6QDlcdiko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790628942;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kXn9g8niZAe7JHP7xKRI6ptYk/Y9JnOmT7kr+bEqi6o=;
	b=RL29oWgyBb9fYy+bZMM8WxFv4CbcoTEV9Nxj3IDjwGDy06ebTuGOdjTVshFrIp8oxt2f7c
	e3N73Gn9OJWKvvAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790628938; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kXn9g8niZAe7JHP7xKRI6ptYk/Y9JnOmT7kr+bEqi6o=;
	b=iDJsyBJ6a/gEmN/CD69+kjK3ZiQwmFpec5a2q71I1EV2Eywc8ZvrB/hf/oiJLyzbBcuE6e
	Oi1V2SHQSDCt2foP680dSws5uDa3Ba1qfpbEdmkeoGwyXG/AUIf/QZgPnxiUhvFKZDJI8q
	HlxNne9TlaLf4AhFvVrWMBxTx/19JYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790628938;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kXn9g8niZAe7JHP7xKRI6ptYk/Y9JnOmT7kr+bEqi6o=;
	b=JH7phM8bISUiat5NxnpuF+/FQhZnko2vIYVsFix1BeAKkneb+fIqDEMQeoDhbC6FL12mTy
	u4cxRKB5foPWS3DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 213CA133F3;
	Mon, 28 Sep 2026 20:55:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1B8MOEnUumqQDgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 28 Sep 2026 20:55:38 +0000
Message-ID: <f9690303-d022-4dd4-8050-ca8e00f8f71c@suse.de>
Date: Mon, 28 Sep 2026 22:54:42 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Netfilter: match "tcp option" with the same type present multiple
 times
To: Matthieu Baerts <matttbe@kernel.org>,
 Netfilter Devel <netfilter-devel@vger.kernel.org>,
 Netfilter Coreteam <coreteam@netfilter.org>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]

On 9/28/26 2:13 PM, Matthieu Baerts wrote:
> Hello Netfilter devs,
> 
> First, thank you for maintaining Netfilter in the kernel and the
> userspace tools.
> 
> The MPTCP selftests are switching from IPTables to NFTables, and
> Clashiko reported that this part of a rule wouldn't match anything:
> 
>    tcp option mptcp subtype remove-addr drop
> 
> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
> added to the TCP options, it is added after an MPTCP DSS option (type
> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
> (type 30) options in the TCP options. It looks like Netfilter doesn't
> handle that, because it stops processing other TCP options when the
> expected type is found:
> 
> net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
>      ...
> 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
> 		optl = optlen(opt, i);
> 
> 		if (priv->type != opt[i])
> 			continue;
> 		...
> 		return;  // <== it will look at the first MPTCP option
> 	}
>      ...
> }
> 
> It looks like it shouldn't stop if the wrong subtype is found, but the
> subtype is not compared there if I'm not mistaken. Should there be a fix
> to support this case?
> 
> For more details about the Clashiko report:
> 
> https://lore.kernel.org/179058242453.3145.1450534124183352369@kernel.org
> 
> 
> BTW, I'm probably missing something, but adding the following doesn't
> seem to have any effect on my side:
> 
>    nft add table ip filter
>    nft add chain ip filter OUTPUT \
>      { type filter hook output priority filter; policy accept; }
>    nft insert rule ip filter OUTPUT tcp option mptcp exists counter drop
> 
> Same with "mptcp subtype mp-capable", other subtypes or other types like
> "timestamp". But if I use ...
> 
>    nft insert rule ip filter OUTPUT meta l4proto tcp counter drop
> 
> ... then the drop is effective. Any idea what I'm missing here? :)
> 
> 
> (Also, it looks like the MPTCP suboptions are not documented in the nft
> man page :) )
> 

Tomorrow there should be a patch in netfilter-devel adding it, we 
definitively should put more work into documentation.

> Cheers,
> Matt

