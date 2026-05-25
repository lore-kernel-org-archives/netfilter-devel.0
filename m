Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72B0388366
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 22:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779746900; cv=none; b=eb19KcklBmn7FoOwPdIcUMCQbr0rLBovdPZIfJqL9wqAHar8HtiYjhxTGoe57YRTmNEYmV577kfqcd09ml7Fnd/9PccQNaNk4GzlMqBLHZAKQyR+QysZKluqOtiPlUpKn9Nfd+ccpDnVL3eLiXLjILSaYGdAT0GwS0bz8mzEQzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779746900; c=relaxed/simple;
	bh=+xQyQwKvvKkmX3ojG/s/nHGH9vt1NVTcHsKqXyK0vmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+TVrowbFtvKCB9NAobgTcXsJLguq8UGADqyqsB6/Z9it5YxyINiF1khTHKazfQlndgp3sV1XnHCV1m/p4YePobCG09ENm27jzN++N0N66Hs0yfAkAGtiWf+Mb1Y1SXdKBcgfCqCHVZVWW8sHICPmL2WxFwShQB7Gn8cgTTNTTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x4kfJ+FW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=P7is7xTy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x4kfJ+FW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=P7is7xTy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x4kfJ+FW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="P7is7xTy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x4kfJ+FW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="P7is7xTy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EA60475B9A;
	Mon, 25 May 2026 22:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779746897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Acyf3NsNv+vLdjpPES4jOlFsVmtOEP4uuksuAlaXvVs=;
	b=x4kfJ+FWrrtGLSH5oEeAgFK9WkjFKcvd2a5XzJlWDPDs2DGkbxp8WfCo0Qsp2bwZXgBhr7
	hbpmjLMPFqkRkYNbjdyQBLQTJQOn1MbS6EP230EeS4QhMUJqK4JIopy2c0cvb2Ms8gGVqH
	oBtJVl+EsK0h05MCZ00CpmuujZgBFiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779746897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Acyf3NsNv+vLdjpPES4jOlFsVmtOEP4uuksuAlaXvVs=;
	b=P7is7xTyIqf/IKOwY46WBeZ2j/JPCWaNDSotgSHRSzZ8cmRISoWAqdD20Wj/LVw+LKDXb8
	Ku+alsfZgCWB8ADA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x4kfJ+FW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P7is7xTy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779746897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Acyf3NsNv+vLdjpPES4jOlFsVmtOEP4uuksuAlaXvVs=;
	b=x4kfJ+FWrrtGLSH5oEeAgFK9WkjFKcvd2a5XzJlWDPDs2DGkbxp8WfCo0Qsp2bwZXgBhr7
	hbpmjLMPFqkRkYNbjdyQBLQTJQOn1MbS6EP230EeS4QhMUJqK4JIopy2c0cvb2Ms8gGVqH
	oBtJVl+EsK0h05MCZ00CpmuujZgBFiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779746897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Acyf3NsNv+vLdjpPES4jOlFsVmtOEP4uuksuAlaXvVs=;
	b=P7is7xTyIqf/IKOwY46WBeZ2j/JPCWaNDSotgSHRSzZ8cmRISoWAqdD20Wj/LVw+LKDXb8
	Ku+alsfZgCWB8ADA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2402459E83;
	Mon, 25 May 2026 22:08:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AmlBBVDIFGpQbgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 25 May 2026 22:08:16 +0000
Message-ID: <b82e4092-1f4e-40ca-b117-31c062ea54c2@suse.de>
Date: Tue, 26 May 2026 00:08:15 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: TCPMSS: fix dropped packets when MSS option is
 unaligned
To: Florian Westphal <fw@strlen.de>, Kacper Kokot <kacper.kokot.44@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260525201116.407338-2-kacper.kokot.44@gmail.com>
 <ahS--cPlhv6NHAcO@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ahS--cPlhv6NHAcO@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: EA60475B9A
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[strlen.de,gmail.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On 5/25/26 11:28 PM, Florian Westphal wrote:
> Kacper Kokot <kacper.kokot.44@gmail.com> wrote:
>> Padding TCP options with NOPs is optional, so it is legal to send an
>> MSS option that is not aligned to a word boundary and therefore not
>> aligned for checksum calculation. The current TCPMSS target is not
>> robust to this: when the MSS option is unaligned it produces an
>> invalid checksum, and the packet is dropped.
> 
> Is this an actual, real world bug?  This code is 20+ years old, all that
> this hints at is that they are always aligned in reality?
> 

AFAICS, these issues are not present in real environments as MSS option 
is placed at the beginning of the options block making it aligned by 
default usually.

I would say this is more for correctness. I wonder, if we are touching 
this code, we could use the opportunity to make it use 
get_unaligned_be16() instead.

