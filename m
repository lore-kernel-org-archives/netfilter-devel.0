Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805641;
	b=oG2vE9VXmJAnTxEDsigi7tMeGQTTxlsUjFzWoKcnPqS9yCpE7igUU5Jvn2PPbx7hi4QL
	 3rE8Mg9QmNUcXqYuuXuldPBEHst+iUNdnbCR6Vu4/0MlJJ7v/M3f+GGjD9RdB59RTV7zi
	 RqhJhXlYMDUaneZaD9QjRcTcSXK1oGKroz9tKgiC+CIS5l7hRyu8CVpuSppSmHH411dPv
	 LyP+Te2snpyKQWgvZ/Uqh4+3ZYIfc2ANM6FNeT3qF2gyUpabYHibmW6inmZmHi4/e6t8m
	 0ETfIlpv/+wASbV4cR0STOiQTBKG4IQTv50Lpa+4o/umRC70DPrwNzAou8XB7UHui2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805641;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=neXNWTbSG81UApMv/kpWAJLvllzd9gyIHGq90vHNXRo=;
	b=FeNV9e9ePcmy0GzsHkT70NdeQkUo5HTDEN9HRJX7WZ8S+6bKurNyHPaI4iKL3z/JHg3/
	 0d9UWKZrRaK1Sw8ncVceicV2OkiIM9lrlCxI+j0SqlSTSJW00yLXZoZStuHPRINirdcRh
	 Euc5NSdpDxDfOSjnAqPUipKgWtHURMGi+XFJrC1hZnbNZF+2vydCtDwkc8o7o0CV2ErmR
	 Lr5HDR2GbZziu8mKFxRTc8JHeiGzidfApEw9vAH6yl1oQjP2FYR5T2DsMEfyq++vP6Vsz
	 rrun/UmB20h9jI73jfvrN+n/oZxkz9hGN6nIiOasiZx/kMDCj/JG8Jy0FzRXgmIoIrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=m4gwRWlI;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lvc3Tjzl;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=m4gwRWlI;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lvc3Tjzl;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33854606EE98
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 15:20:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33854606EE98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=m4gwRWlI;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lvc3Tjzl;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=m4gwRWlI;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lvc3Tjzl
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 51CF321F84;
	Wed,  4 Nov 2026 15:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793805639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=neXNWTbSG81UApMv/kpWAJLvllzd9gyIHGq90vHNXRo=;
	b=m4gwRWlIIPLzyzIxYHpj/3VNRilr5M4KSTq7SlaAdPIzNZ4uc5CYl7PGLJKglekcJ/+Nsl
	QJv8NaCADTOM7ALwDKUnGUejUEOHBCMXvjojFKyWhKxd7b4MdG/S/hiMYGG6iWhEFphzKZ
	UF7tU1HOUCugW/JP7O466Q2qHE+YMh4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793805639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=neXNWTbSG81UApMv/kpWAJLvllzd9gyIHGq90vHNXRo=;
	b=lvc3Tjzlmdqu01ovXD90fPl4nqDa4+4rBW0K7NVjJ9Tt8tN/4iTw2R7z2PQP5ddsFePYJP
	hVOSHbMO9W7lYrCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793805639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=neXNWTbSG81UApMv/kpWAJLvllzd9gyIHGq90vHNXRo=;
	b=m4gwRWlIIPLzyzIxYHpj/3VNRilr5M4KSTq7SlaAdPIzNZ4uc5CYl7PGLJKglekcJ/+Nsl
	QJv8NaCADTOM7ALwDKUnGUejUEOHBCMXvjojFKyWhKxd7b4MdG/S/hiMYGG6iWhEFphzKZ
	UF7tU1HOUCugW/JP7O466Q2qHE+YMh4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793805639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=neXNWTbSG81UApMv/kpWAJLvllzd9gyIHGq90vHNXRo=;
	b=lvc3Tjzlmdqu01ovXD90fPl4nqDa4+4rBW0K7NVjJ9Tt8tN/4iTw2R7z2PQP5ddsFePYJP
	hVOSHbMO9W7lYrCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0949D134A5;
	Wed,  4 Nov 2026 15:20:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nEAAM0ZN62qCJQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 04 Nov 2026 15:20:38 +0000
Message-ID: <5110f450-264c-46e2-8a25-3c3876506bd9@suse.de>
Date: Wed, 4 Nov 2026 16:19:25 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf 0/4] netfilter: logging cleanups
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20261030154433.13601-1-fw@strlen.de> <auY0wSMHLn3ZDKLg@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <auY0wSMHLn3ZDKLg@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.28 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-0.99)[-0.985];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[strlen.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.28
X-Spam-Level: 
X-Spam-Flag: NO

On 10/31/26 7:34 PM, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> 3) Extract dev_parse_header usage into a shared helper for nfnetlink_log and
>> nfnetlink_queue, clamping hw addresses to 8 bytes and validating the skb
>> mac header. Add BUILD_BUG_ON checks to assert identical container struct
>> layouts.
> 
> LLM comments convince me that this needs to be re-targeted to nf-next.
> 
> I will submit a v2 next week.

Oh sorry, I actually missed this.

In any case, first two commits LGTM and the third one could be fixed 
with the suggestion I made (if I am not wrong of course).

Thanks Florian!
