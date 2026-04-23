Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A58366561
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 12:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776947688; cv=none; b=B5uhpU/Aoz80GbWJgUjem4fLr5tmNr8CrTEJPxFvf2Rzb3g4Tm1FcRu1cPIh3l4O6PnGylpadn7ZFXpF6tKntgqGdC/E5TVBHi9XICf/AU5CmCEjqFhoN/n8Z5JCkRDweSyyLDyzQb0xlmSO7EO80S4b1nljhdeTHiMkpSd5eXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776947688; c=relaxed/simple;
	bh=GT5vSIsAQVC3BMKfBOVC8R/qbzqYB2Gkn8ib4/0bZzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RjA1VWd9mEH0gjmCfmNiqcUG3q62pf+prjXaTkdIBePdPfMm8vAQSoa2ZUFMLK6YwC9z9vf4sjZmyV/j1p4waOF0CYJuU94eOj2+RpDf0ta9BX6FVzNfGBVm1j+REs8l9Lt+rINYwuuVtDnvmdOv8p91/QKc+DRaY8bdA8tAUFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PSG/jtlQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0oG0RJs0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PSG/jtlQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0oG0RJs0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PSG/jtlQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0oG0RJs0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PSG/jtlQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0oG0RJs0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 873C66A870;
	Thu, 23 Apr 2026 12:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776947685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8HT744d2GbT1WUv2VKPFnXg+R66UTT1i8gM/dwyewpE=;
	b=PSG/jtlQNRrV/cmL6Oew5Eht8VP5MgyrA3FVXzforDklbEK+QDSLvgqcgxTFZgtc08dvlY
	4ISOilLgyHbwDxkmAw0JyQaYo6Va9L8ZbiH3TrLwhBEcTK4YEaha8+7Uek0DuaDb6p7ylG
	c2cir/Vczy0KIe2qyQ4k0VFc7PMpDOs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776947685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8HT744d2GbT1WUv2VKPFnXg+R66UTT1i8gM/dwyewpE=;
	b=0oG0RJs0gk7gbzmwkLEJnpJaczg+jp6SjzE07tNoAbW2MG4RPxifsx46ZmpLGcCw1SvZPt
	01aYZx3JZq9e9uAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776947685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8HT744d2GbT1WUv2VKPFnXg+R66UTT1i8gM/dwyewpE=;
	b=PSG/jtlQNRrV/cmL6Oew5Eht8VP5MgyrA3FVXzforDklbEK+QDSLvgqcgxTFZgtc08dvlY
	4ISOilLgyHbwDxkmAw0JyQaYo6Va9L8ZbiH3TrLwhBEcTK4YEaha8+7Uek0DuaDb6p7ylG
	c2cir/Vczy0KIe2qyQ4k0VFc7PMpDOs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776947685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8HT744d2GbT1WUv2VKPFnXg+R66UTT1i8gM/dwyewpE=;
	b=0oG0RJs0gk7gbzmwkLEJnpJaczg+jp6SjzE07tNoAbW2MG4RPxifsx46ZmpLGcCw1SvZPt
	01aYZx3JZq9e9uAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 345A4593A3;
	Thu, 23 Apr 2026 12:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AV8RCuUR6mnCcQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 23 Apr 2026 12:34:45 +0000
Message-ID: <684ec011-3785-4df4-a9ee-457025dcd447@suse.de>
Date: Thu, 23 Apr 2026 14:34:40 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 jeremy@azazel.net, phil@nwl.cc, pablo@netfilter.org
References: <20260423120538.3704-1-fmancera@suse.de>
 <aeoQMCJ7x0tGoUFC@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aeoQMCJ7x0tGoUFC@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

On 4/23/26 2:27 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> In nft_bitwise_eval_lshift() and nft_bitwise_eval_rshift(), shift
>> operations are performed in a loop over 32-bit words. The loop
>> calculates the shifted value, writes it to dst, and calculates the carry
>> from src for the next iteration.
>>
>> If the source and destination registers overlap either exactly (sreg ==
>> dreg) or partially (e.g., dreg is offset from sreg by 4 bytes) the loop
>> overwrites src data before it can be read by subsequent iterations. This
>> causes the carry or the shifted data itself to be incorrectly calculated
>> using the newly modified dst value instead of the original src payload.
> 
> We should support overlaps (src == dst).  But partial overlaps?
> Does nft generate such byte code?
> 

No, not at all.

> I think we should reject it.  Either userspace has no more use
> for src (and can clobber it with the shifted result), or it has
> to keep it for later reuse.  But in what case is a partially clobbered
> register useful?
> 

Fine for me. I could not find any situation where this could be useful 
but I was afraid of breaking some weird setups. If we have agreement 
that this isn't useful I am fine rejecting it from control plane with 
something like (not tested):

unsigned int n = DIV_ROUND_UP(priv->len, sizeof(u32));

if (priv->sreg != priv->dreg &&
     priv->dreg < priv->sreg + n &&
     priv->sreg < priv->dreg + n)
	return -EINVAL;

Thanks,
Fernando.
