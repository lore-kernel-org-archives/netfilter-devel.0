Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA8B1C3306
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Oct 2025 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760027563; cv=none; b=bFWfAccYgA2OkZ5l+Oj5Yn1RRNPKXEj+xI3DPKR3yAx3PO4DOT7GZ4SU8LScWpNVtZhfos+rvih7Z0Sqe508AM1nSnxKLSUGVwpQh3Ly8BnHhYliNTYHtYB4rgFGWn02hXlFlhXf+Ew/3dnSZaMzpllwGYYhdR65hCHlaqe4nHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760027563; c=relaxed/simple;
	bh=Ht1Svut6gxybwWxNbF1qQrFZnE/zwjBlMprqmNprrgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bff06Z6wXswf57YtD0tTY+WZQLsRXpm9m2423OZxHsvgabKAZRDhEX+UB3S2xHoOylAnVO2TWu/q7p/7eNcrQeklM1N//KnO71RNBBLo/PEQPox4CWdoy51ohXCXkzjbhAfs66i+HHxhwv51zMoHX2mhDMnJj6OMOJPaLqE2ASk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AZGpm3gg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ink3GtOK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s36OFrV4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wyQsCMOt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AZGpm3gg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ink3GtOK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s36OFrV4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wyQsCMOt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 154F221CBC;
	Thu,  9 Oct 2025 16:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760027560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=845OPgL5dHHnalAoFkl5tiPc9KnufiVOfSEpetQgxXQ=;
	b=AZGpm3ggkJ2t1l4EzTWZ8Ol3tuawglbqcn/TokYfmMiOUAJkG8kyJ0gpKGktazpUReUKN1
	hXp3hfnoFIZKqzqH5tGnJmskwm0R03b0WEMKenx38+6Yohh0FBu0FKnXyp2DB9gRNCrtuz
	gb2V1W3kunpAN3Y2djqrETjYV47D3aQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760027560;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=845OPgL5dHHnalAoFkl5tiPc9KnufiVOfSEpetQgxXQ=;
	b=ink3GtOKcX7upG6/GkHIwpC68fXHzRygZ7ts+fLvGpX0eK7D1EfNv/OTQIyKBhB+OyPVKy
	yDWWeR8aU/j3DxBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s36OFrV4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wyQsCMOt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760027559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=845OPgL5dHHnalAoFkl5tiPc9KnufiVOfSEpetQgxXQ=;
	b=s36OFrV4X2gj420K7bQJO5HpQ97xkFoXgHegZvg9dHAvR/HBliYoAE71NXqixWF3Esic8M
	F7XF4r0sz0agOGwe0vVdfj85wGQN3FDaGxK2XnTBLM5LE42qiJCg4/wfCLNP1yeLvxRwC/
	WMdDmT214gp/3zuhCuuKrucOcngJmRY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760027559;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=845OPgL5dHHnalAoFkl5tiPc9KnufiVOfSEpetQgxXQ=;
	b=wyQsCMOtfYshyn4uCNiYZm1n1WH4UhXaSXSzvLuCCgPWLrWZQDbq9mloJRUyHzpaFN7hLT
	kBEaJRpfbAoq/oDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF01A13AA6;
	Thu,  9 Oct 2025 16:32:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zTh3M6bj52j2PwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 09 Oct 2025 16:32:38 +0000
Message-ID: <315ffc1a-86ee-4173-adeb-69a4611cd892@suse.de>
Date: Thu, 9 Oct 2025 18:32:25 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft] tests: shell: add packetpath test for meta ibrhwdr
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
References: <20251009162439.4232-1-fmancera@suse.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251009162439.4232-1-fmancera@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 154F221CBC
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 



On 10/9/25 6:24 PM, Fernando Fernandez Mancera wrote:
> The test checks that the packets are processed by the bridge device and
> not forwarded.
> 
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
> Please keep on mind that this requires:
> * https://lore.kernel.org/netfilter-devel/20250902113529.5456-1-fmancera@suse.de/
> * https://lore.kernel.org/netfilter-devel/20250902113216.5275-1-fmancera@suse.de/
> ---
>   tests/shell/features/meta_ibrhwdr.nft         |  8 ++
>   .../shell/testcases/packetpath/bridge_pass_up | 83 +++++++++++++++++++
>   2 files changed, 91 insertions(+)
>   create mode 100644 tests/shell/features/meta_ibrhwdr.nft
>   create mode 100755 tests/shell/testcases/packetpath/bridge_pass_up
> 
> diff --git a/tests/shell/features/meta_ibrhwdr.nft b/tests/shell/features/meta_ibrhwdr.nft
> new file mode 100644
> index 00000000..ba9b3431
> --- /dev/null
> +++ b/tests/shell/features/meta_ibrhwdr.nft
> @@ -0,0 +1,8 @@
> +# cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
> +# v6.16-rc2-16052-gcbd2257dc96e

I just noticed this version is wrong. Probably I need to wait until 
6.18-rc1 and resend this. Anyway, feedback on the test is more than 
welcome :-)

