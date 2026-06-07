Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372A731715F
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2026 21:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780867639; cv=none; b=qW5VZbTPi0KJAmDUg06vQ4o9XGtxCJx37wvTD//qZ7nYVSoVjZ3rjYsuUoqUP2GqR8byQHk/HVRhrW860YOB/PoRwf68LH34dZ3zTYNQNlAqhCYuOYtue9a+tAjEMz6I+1CS4gYMDNFM85nunowk1onAan54Lv+chsoS1nahJdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780867639; c=relaxed/simple;
	bh=rP3OXPQOmzfdOFiSl6nk7FxuoG034U4hR2rzE0x2Rfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KfR8ynSX7bA4w/jF0V/XJ6e7i31k8WWML1lOjKBNCrJx1XXMo2I0V3fJixvHsg1WYHRl1V69XEPiBlddk6Lt0v5U5CB4N48gg5kUHmBtiMmPQ8q+kmhCEZUPv7a1xe3LyoT1PjNnvVV4h0z3XszOtyfYl2zlASLxD1oTBWKnyAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Dah0oAdc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GgzvyVrj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Dah0oAdc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GgzvyVrj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Dah0oAdc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GgzvyVrj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Dah0oAdc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GgzvyVrj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8608B6A900;
	Sun,  7 Jun 2026 21:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780867636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r7mIFaSxwp1nM31lrLsxAp1j/TNU9+RaPeFN/tv5Bik=;
	b=Dah0oAdcYvrRsqllVds7khL/rmSZnUG3wO/3adJtXocXdBUUa4mWd8agcGVUwsXFB9xW2f
	9n1BdmN+zy1HT7wQBUZOeg8rBA1vL467B92ECjdebNu1iDSoxRS+NytURlDyx5iTTraC1x
	UyP4qqfpSpbfye9uKUN6KVNtg3QMmrs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780867636;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r7mIFaSxwp1nM31lrLsxAp1j/TNU9+RaPeFN/tv5Bik=;
	b=GgzvyVrj8sY8KOTn227D3Jh9HGsSMMyn+5/a8VPtA+KxnQng4Z8i2vf6ybx85K9XUeDy9b
	FOTKOit//l1efDDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780867636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r7mIFaSxwp1nM31lrLsxAp1j/TNU9+RaPeFN/tv5Bik=;
	b=Dah0oAdcYvrRsqllVds7khL/rmSZnUG3wO/3adJtXocXdBUUa4mWd8agcGVUwsXFB9xW2f
	9n1BdmN+zy1HT7wQBUZOeg8rBA1vL467B92ECjdebNu1iDSoxRS+NytURlDyx5iTTraC1x
	UyP4qqfpSpbfye9uKUN6KVNtg3QMmrs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780867636;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r7mIFaSxwp1nM31lrLsxAp1j/TNU9+RaPeFN/tv5Bik=;
	b=GgzvyVrj8sY8KOTn227D3Jh9HGsSMMyn+5/a8VPtA+KxnQng4Z8i2vf6ybx85K9XUeDy9b
	FOTKOit//l1efDDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE8BA779A7;
	Sun,  7 Jun 2026 21:27:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LtfyLjPiJWq7RAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 07 Jun 2026 21:27:15 +0000
Message-ID: <ab136215-157e-491a-b9cb-ba9c1d3c982d@suse.de>
Date: Sun, 7 Jun 2026 23:27:03 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: synproxy: fix unaligned access to TCP
 timestamp option
To: Rosen Penev <rosenp@gmail.com>, netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "open list:NETFILTER" <coreteam@netfilter.org>,
 "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260607164447.39700-1-rosenp@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260607164447.39700-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -4.30

On 6/7/26 6:44 PM, Rosen Penev wrote:
> synproxy_tstamp_adjust() reads and writes the TSval and TSecr fields of
> the TCP Timestamp option via direct __be32 pointer dereferences. These
> fields are at byte offsets 2 and 6 within the option, which are only
> 2-byte aligned — not 4-byte aligned for __be32 access.
> 
> Replace with get_unaligned_be32() / put_unaligned_be32() to safely
> handle the unaligned access on strict-alignment architectures.
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
Hi,

as mentioned on [1] this was already fixed in [2]..

[1] 
https://lore.kernel.org/netdev/a8cfeb06-6ffb-49f2-a14d-c5a50bc4e5be@suse.de/

[2] 
https://lore.kernel.org/netfilter-devel/20260525124450.6043-4-fmancera@suse.de/

Thanks,
Fernando.
