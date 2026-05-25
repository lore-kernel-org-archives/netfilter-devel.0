Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8150388E4F
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 14:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779717618; cv=none; b=cdSWEuMN5k25xZUG0KmYJJuNMmVRrhZq2yDKqL+onwelcFjH3l7gnQA43vdvFQncADGD7y/xmFSdgjieeyO9kYejtwhsarRbDuDAmYuQ+g/uyxJFEhtcAUkSANZJ7ai59BAGvgbCRX/CUtYiBF72yw/xPjPEdNkeuLx4LusmNA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779717618; c=relaxed/simple;
	bh=3Eog/Mkqp7+61sKxBuO5VC0vY1/FIEZRY9rmKVpOWHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qc/+PCW69xedi4owdco/K1p1HNLuDnUOBn+F3RJ0wPwV8MNOLvftYY/U7ljNkRVK6DsfsQgLwv0VuKYyjdOy2XBqQVuTS3a6j8SbvYR2pD0YVvXbnr7+RDjDKnRvJYbaLHjWEHeRjtZ2Wkrv+xLxMyT0cL/gvPcj8hdb+zWiHqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZSuosMwo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CS3kxrDJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZSuosMwo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CS3kxrDJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZSuosMwo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CS3kxrDJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZSuosMwo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CS3kxrDJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2BE276AB14;
	Mon, 25 May 2026 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779717615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FkX6HDwXCHhLHxcUFUgeaLQmIcVLET5BF3CQpStbCe8=;
	b=ZSuosMwo2x0sqk+Gy9OvieG9G3KvwpZSUSW6da3ppeLS90lAzuMlVoKp7FZrY1eyuPUcPv
	A6dK49V0dIkbvZiw3khWFMnrk44u2B0cd1kirGq2jBeTJ9qYMdNZOTwsnzK+v7DyFzBAXV
	YuaewcFSiADl3xch0Aw/VtNxXFh2Cww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779717615;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FkX6HDwXCHhLHxcUFUgeaLQmIcVLET5BF3CQpStbCe8=;
	b=CS3kxrDJ7gVjqW5HcTbyZFNkRuylAlbRVq9XNjOQEP3KlFhnNFvkAj03K3oug3Oi3ljCAb
	CDmZ9/4PAGXGiOCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779717615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FkX6HDwXCHhLHxcUFUgeaLQmIcVLET5BF3CQpStbCe8=;
	b=ZSuosMwo2x0sqk+Gy9OvieG9G3KvwpZSUSW6da3ppeLS90lAzuMlVoKp7FZrY1eyuPUcPv
	A6dK49V0dIkbvZiw3khWFMnrk44u2B0cd1kirGq2jBeTJ9qYMdNZOTwsnzK+v7DyFzBAXV
	YuaewcFSiADl3xch0Aw/VtNxXFh2Cww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779717615;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FkX6HDwXCHhLHxcUFUgeaLQmIcVLET5BF3CQpStbCe8=;
	b=CS3kxrDJ7gVjqW5HcTbyZFNkRuylAlbRVq9XNjOQEP3KlFhnNFvkAj03K3oug3Oi3ljCAb
	CDmZ9/4PAGXGiOCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF4BC59C9B;
	Mon, 25 May 2026 14:00:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VSbeJ+5VFGoUFQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 25 May 2026 14:00:14 +0000
Message-ID: <d23ab420-f7ae-46d8-9589-f36af441b4fb@suse.de>
Date: Mon, 25 May 2026 16:00:14 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: flowtable: avoid num_encaps underflow on
 bridge VLAN untag
To: David Carlier <devnexen@gmail.com>, pablo@netfilter.org, fw@strlen.de,
 kadlec@netfilter.org
Cc: phil@nwl.cc, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org
References: <20260523152621.58576-1-devnexen@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260523152621.58576-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,netfilter.org,strlen.de];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO

On 5/23/26 5:26 PM, David Carlier wrote:
> The DEV_PATH_BR_VLAN_UNTAG case post-decrements info->num_encaps
> inside WARN_ON_ONCE(). num_encaps is u8, so if it's already 0 the
> decrement still happens and wraps it to 255. The break only leaves
> the inner switch -- a later path entry can set info->indev back to
> a real device, and we end up returning with num_encaps == 255.
> 
> nft_dev_forward_path() then walks info.encap[] (size 2) up to
> num_encaps, which means an OOB stack read and a bogus count copied
> into the route descriptor.
> 
> Should only happen on a malformed bridge path stack, hence the WARN,
> but worth handling sanely. Move the decrement out of the WARN.
> 
> Fixes: e990cef6516d ("netfilter: flowtable: add bridge vlan filtering support")
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
