Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA43E42DA30
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 13:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785416446; cv=none; b=t106IxG0FZUb+hUzmG9sRn/qiJONaYcCjJfwPc84V0T9algi+1MlyIKj3P81H2A4QOM2i/mE0qgFyO7aSWc6gHwa0hT9vUzhGqwN5+Eme2jP42/qXgVAJGRzXouSYibvomoBahVHRxgvmQippwH1cVasQojVDhHuo/B/HpTU0lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785416446; c=relaxed/simple;
	bh=x/8BNxvKWG0DiF/TCRcPU2UaHSiJmna7oCYq/hVLCss=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=K8gHxOGSwCCbd0AvwX1vQql0u7puc3S8Gf1akj9IS1L6zR9FnpplxHsCYEHVDo84q3lLrfDGB31alRnLztgUh9H+nLK7MANc3CVRJ1Sy8H7XaMj6NRZNLzfbNCGWyueiTgNxFrUo4GHZwAg+Z1UlYZWFnoZ+VxfA/rsHEBZqZew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CK+/4a1D; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=m9kfhfX0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=drUaurMM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pEsR32/Z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CK+/4a1D";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="m9kfhfX0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="drUaurMM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pEsR32/Z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E591A7DA10;
	Thu, 30 Jul 2026 13:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785416438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qMtETZ9MVq0nU7nPSKG7vKZ0nLS0vThFnec/Efik0kM=;
	b=CK+/4a1D1hWgo8VUd/pkFIsoGA/X+9NQP1i7iPxHGeWxuEcKPxoCBxHCHTN1lmbPHJWr5c
	8SkSwxjWPZpbY1BzoHMOG6ITi8igqLeRAvs1r772h5tDdmmVf8O5pIC6K5K+XIZq+JUU1G
	BPqTovXzlt5f0C3uuFkUUbSKteg5Fus=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785416438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qMtETZ9MVq0nU7nPSKG7vKZ0nLS0vThFnec/Efik0kM=;
	b=m9kfhfX0CAND9BLP7FOAAY8Pf3NWz/MKVy3LvqQP0q+Ibd/VidneGOsxHGPySLnSMveCDp
	0QqwSAUfmeuGO7Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785416433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qMtETZ9MVq0nU7nPSKG7vKZ0nLS0vThFnec/Efik0kM=;
	b=drUaurMMEb0sn+eoFWYue7E+5lrQgbvQxnn5VJ+GxLQ9bUVojLwMGko1t+viKJmm5ReuE6
	+L1Sh1Im96zph6MZ+4IZBSbrJF8Q4tfSZ0/IwksgrYiHdknHRPYPNO2zP7JQBR0PtGlKUQ
	KTui03ysDqhCP6ZcatC3K/FssA0VZP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785416433;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qMtETZ9MVq0nU7nPSKG7vKZ0nLS0vThFnec/Efik0kM=;
	b=pEsR32/Z4PVaqDJbPvvnHXCGYSYpIt6mJvr+IBKCTLC5+baVg8xa4NphxjhW7Rjce40gTe
	tI/bBBeYMaLxisDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BEE06779CC;
	Thu, 30 Jul 2026 13:00:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sAHPK/FKa2qySAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 30 Jul 2026 13:00:33 +0000
Message-ID: <6e2641c0-5e8e-44b4-8978-55691fb9acf2@suse.de>
Date: Thu, 30 Jul 2026 15:00:21 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next,v2] netfilter: nf_tables: call skb_valid_dst()
 before skb_dst()
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20260730114733.515450-1-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260730114733.515450-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,netfilter.org:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 7/30/26 1:47 PM, Pablo Neira Ayuso wrote:
> When fetching the dst_entry from the skb, check if it valid, ie. this is
> not a template dst, for extensions that can be used from the netdev
> ingress and egress chains.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

LGTM!

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
