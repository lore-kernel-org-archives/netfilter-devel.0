Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D08628686
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781795933; cv=none; b=JyvKDjC++YO6kKsN8lH++TvO/3xyL8cOkxyWEGTqVzAb5P1MVBPUg1apGcnGLiYyaPziOFoyk222RhOL5Wrcx/8ltnmWOa35gXEhjIjedIkRNciae7+AmKqesau+wdQkjk5I0AHZ3nHkWH/9mOl42IDKCBxk46OZfS/XZd9Af0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781795933; c=relaxed/simple;
	bh=wiVDLHtOIMhv5UsKa3NE0LAL4cHlYH2wA2YuTIen7wU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GvQSD2m3tM9NA8AYeQNbqfHWeJ9tInqdXr6ZhbsFmLwD0XqauUnn4Jk/1FOUgccc5Dmcwuw6prj26Y/FyVcDrmb29enqYNszuxaUaynvJ7Rl/hHXBAjqAqCeKmq7a/swhBzl7G9yidQukNm00/LmMYc/yurIbC8z/88v+36xG5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JAALCZX+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VIv/1ieK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JAALCZX+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VIv/1ieK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JAALCZX+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VIv/1ieK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JAALCZX+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VIv/1ieK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5AAFF75EE4;
	Thu, 18 Jun 2026 15:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781795930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YNvhRm7LyV/dJ0G0eDNecietzon7Hrx2+e+Iyvw1csg=;
	b=JAALCZX+QGPlGnJe/EHELQRsmFYFlZGwpXBvEfFNthhavrqxmYMqYrG7TCxADO4nB8hu0+
	fqkiyMvrattyG1naCP8Vdjg1E2Dw6eyW5pqG6Ed2xblS7VFtp8g31Du1DRoVntr2CPLHOE
	HUKz3gDPiTlQZ82/w96mjx6jZQAe+uI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781795930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YNvhRm7LyV/dJ0G0eDNecietzon7Hrx2+e+Iyvw1csg=;
	b=VIv/1ieKNwGO39Ypi6BJiFVyNh7TtCTBLfmwTZWjs8uX3pqdwzqYrbF6ivpXRm1uMoui7K
	smeK3TXIxP/tT+Bg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781795930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YNvhRm7LyV/dJ0G0eDNecietzon7Hrx2+e+Iyvw1csg=;
	b=JAALCZX+QGPlGnJe/EHELQRsmFYFlZGwpXBvEfFNthhavrqxmYMqYrG7TCxADO4nB8hu0+
	fqkiyMvrattyG1naCP8Vdjg1E2Dw6eyW5pqG6Ed2xblS7VFtp8g31Du1DRoVntr2CPLHOE
	HUKz3gDPiTlQZ82/w96mjx6jZQAe+uI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781795930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YNvhRm7LyV/dJ0G0eDNecietzon7Hrx2+e+Iyvw1csg=;
	b=VIv/1ieKNwGO39Ypi6BJiFVyNh7TtCTBLfmwTZWjs8uX3pqdwzqYrbF6ivpXRm1uMoui7K
	smeK3TXIxP/tT+Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3397B779A8;
	Thu, 18 Jun 2026 15:18:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YmzaCVoMNGphTgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 18 Jun 2026 15:18:50 +0000
Message-ID: <0596e86b-7d7e-447b-8dfd-23fb29cfa6fb@suse.de>
Date: Thu, 18 Jun 2026 17:18:49 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nft_payload: reject offsets exceeding 65535
 bytes
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260618045826.2449-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260618045826.2449-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

On 6/18/26 6:58 AM, Florian Westphal wrote:
> Large offsets were rejected based on netlink policy, but blamed commit
> removed the policy without updating nft_payload_inner_init() to use the
> truncation-check helper.
> 
> Silent truncation is not a problem, but not wanted either, so add a
> check.
> 
> Fixes: 077dc4a27579 ("netfilter: nft_payload: extend offset to 65535 bytes")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Uh, it seems I missed two other usages of NFTA_PAYLOAD_OFFSET, thanks 
for catching this.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
