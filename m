Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F871E7C12
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776955862; cv=none; b=nffqFXc7otNDL1Vm0VRuxnIbbDZ9kH+BXxMGmzFLVj2coo/jMIKn4LpDluFmUzAGbzyUZvOABHwUr3qXXckcFPdi6pO7H+vTxjJaJum4lDBsWwCvgW8TBUpsfNdjsjLCRgF0sw1yOZlZDR5Ea2l167+ja2YxGkGOTITWkOO1gHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776955862; c=relaxed/simple;
	bh=oOCPjuhKeZNKz1Xn+Yu6+iXzSc9geHN/aQ2odX1Bwvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fxZWzBgj/gCphfiQP6uXlIiiLw6GCRA7Ote+zk/UDZmHu2GodkUFIyj1iGmeV5HU9Nqe6IWx/Pa/zoMNx4rIRcktJt7vR2fmHGFi6gzap5ZfxnSTYKRSiBMOcoCxRNHIJ8mMVAB4EZviLAtziYnIvjdX4ISVt38WAXKTGDrDixc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UGDksFSC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tpR72BSl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=02b2TlmP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wZA2UsMK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UGDksFSC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tpR72BSl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="02b2TlmP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wZA2UsMK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC7466A833;
	Thu, 23 Apr 2026 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776955859; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zwydtiIluiskSBwqwZNT6srBHtQenL8s1T2oZcZH+ic=;
	b=UGDksFSCpMXLjaYA97gQtiivJYMDnrhltavmO111C3LkaQ5OuRLFtEze8tlfJlRdIlkThF
	bMziLiG/2+JNxdE6gXSpRODkiZo0Hkc++STw6+837lUpiKpwu0f1Fz3Bvd6+M9RGgW1QBb
	xk1mMURQ+brang3HgRRMXvncehCmgt8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776955859;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zwydtiIluiskSBwqwZNT6srBHtQenL8s1T2oZcZH+ic=;
	b=tpR72BSlRGa/0qqRCg+m5lF9tpMbD+QQYYcSWNAJ1/NEhuuDTq1DV05gNTELy7Gr7CxTgj
	bV+zuKCMGqwH66CA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=02b2TlmP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wZA2UsMK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776955857; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zwydtiIluiskSBwqwZNT6srBHtQenL8s1T2oZcZH+ic=;
	b=02b2TlmPNgQU5YVyex+EtN9fXxcxdWtLIz2woZQdHv0Bd+1O+YAAgG+mQrYCyRrETBJr4L
	iP9FMB1rCi+aC6tAMd6zzgcVTmvXr6s5xUD5GT0VCZtcYrg9V32bcrlRfII5jnp4z1cMUA
	W21ikiFwyKP+oenfRL45umJdhjz96RE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776955857;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zwydtiIluiskSBwqwZNT6srBHtQenL8s1T2oZcZH+ic=;
	b=wZA2UsMKUnlEKBFqfxuuvdWmoXgqrbR+ivWEesdfHjvUprMeFL2Je+bPWJ9j/Sd2OBOUYj
	YsCpLslFNSQcjaCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7674C593A3;
	Thu, 23 Apr 2026 14:50:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4RweGtEx6mkuAwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 23 Apr 2026 14:50:57 +0000
Message-ID: <7d18a754-fb59-42e3-b44e-73dadbf17418@suse.de>
Date: Thu, 23 Apr 2026 16:50:48 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 jeremy@azazel.net, phil@nwl.cc
References: <20260423120538.3704-1-fmancera@suse.de>
 <aeoQMCJ7x0tGoUFC@strlen.de> <684ec011-3785-4df4-a9ee-457025dcd447@suse.de>
 <aeoStjrp12qNUeDL@strlen.de> <aeoxeHoufCrJrNHn@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aeoxeHoufCrJrNHn@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CC7466A833

On 4/23/26 4:49 PM, Pablo Neira Ayuso wrote:
> On Thu, Apr 23, 2026 at 02:38:14PM +0200, Florian Westphal wrote:
>> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>> On 4/23/26 2:27 PM, Florian Westphal wrote:
>>>> We should support overlaps (src == dst).  But partial overlaps?
>>>> Does nft generate such byte code?
>>>>
>>>
>>> No, not at all.
>>
>> Phew. :-)
>>
>>> Fine for me. I could not find any situation where this could be useful
>>> but I was afraid of breaking some weird setups. If we have agreement
>>> that this isn't useful I am fine rejecting it from control plane with
>>> something like (not tested):
>>
>> Lets wait for Pablos take on this, but I would prefer reject from
>> control plane.
> 
> I'd rather reject this from control plane too, thanks!

Got it, then I will take the v1 and add the control plane check. Thanks!

