Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10292652A2
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Nov 2025 17:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762190663; cv=none; b=rq+QXzpjOTglb/8Rfx6DqR/eSGl6becJblbdTzCvdLfl7n5vRudq9BgRIvQlKItR7HfX8pQXkCC08uACZX8Y0oiEO2sZlleil8xVqlxuSWGdP2xeS422qBlexaeasro+3GyHWPtWjQj+Rm54eyeq/Eo/KA80qr6WAIKSRyFWu2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762190663; c=relaxed/simple;
	bh=4+aNPqew11rzpplQViOC9pAYJHInKLP1995e4x1F5W4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K2crYKycu+neWjpp+0ztMokupv7yb+jl1V6R5Z/JUPwB1tALKR+YjRDTA4PW0o7WCDlZsQsNZtCPNXvsdJN+j0jMhOvtEy84DTQabfj0NBCO+tjrY63VA9CF0QbJZpQNUO2TuxgMvAwtP1Ku/Xn1vONVkQOGFEShHP+GGkQX8fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OMyiHMnD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9coOIu/a; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SMH69YpK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oSf/sI7S; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OMyiHMnD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9coOIu/a";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SMH69YpK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oSf/sI7S"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 149BE1F454;
	Mon,  3 Nov 2025 17:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762190659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kGlI4Ct7ny0X2TP5LDbb15UeERlnB2QK/2RmK9alGlU=;
	b=OMyiHMnDSCGM6sPLoBaQY8fgzvq6aGmmkOTE1OGzgIHebcm9C+lbgLTWCyZh4gdf+34tXD
	AtWZcAj9wS55s18QLtJsriMBFQQJ5zypTaHnwf6cQHOt+W5CENLxsX3/ZxtOVcwHSO3oaf
	0QuIU9YX9F2xeEGhb0tTBM2TimNb1eg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762190659;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kGlI4Ct7ny0X2TP5LDbb15UeERlnB2QK/2RmK9alGlU=;
	b=9coOIu/a/BfSqH3arQqV+l4ktUzyaM4hTxZHJ2NT+/S4oPfyelkGzaesgPX3VgUSWCy2cu
	UxFOBQ6fJ1I3gjAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SMH69YpK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="oSf/sI7S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762190658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kGlI4Ct7ny0X2TP5LDbb15UeERlnB2QK/2RmK9alGlU=;
	b=SMH69YpK3VbdLs6zyCBMRKZS2hUww/zRIdLI1ba5i77dz92t+KUedOohaCW4ZIxeYfRSRJ
	hu1QsgyhwK25pB9o8ujvX19tRg1QtV1yfAHdYWVNWFd6ja7bYoIIDF+bDBfK9PI7t6YYmB
	YYVlT5f0NZzNbuIhY2s0Am7IHGD+mXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762190658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kGlI4Ct7ny0X2TP5LDbb15UeERlnB2QK/2RmK9alGlU=;
	b=oSf/sI7SXQ+gO046+LScG8ZncTsOIv49ZdoRweiLaMELaTu8NJKbWzhH+Gv5IDbsYuJtZa
	0e6IkhzsHILC0YCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E546139A9;
	Mon,  3 Nov 2025 17:24:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wBBMIkHlCGnsDAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 03 Nov 2025 17:24:17 +0000
Message-ID: <7554ab3d-9eeb-48fd-a5b4-9f9db6743c1e@suse.de>
Date: Mon, 3 Nov 2025 18:24:10 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next v2] netfilter: nf_tables: add math expression
 support
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org, fw@strlen.de, pablo@netfilter.org
References: <20251103143134.23300-1-fmancera@suse.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251103143134.23300-1-fmancera@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 149BE1F454
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:mid,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 11/3/25 3:31 PM, Fernando Fernandez Mancera wrote:
> Historically, users have requested support for increasing and decreasing
> TTL value in nftables in order to migrate from iptables.
> 
> Following the nftables spirit of flexible and multipurpose expressions,
> this patch introduces "nft_math" expression. This expression allows to
> increase and decrease u32, u16 and u8 values stored in the nftables
> registers.
> 
> The math expression intends to be flexible enough in case it needs to be
> extended in the future, e.g implement bitfields operations. For this
> reason, the length of the data is indicated in bits instead of bytes.
> 
> When loading a u8 or u16 payload into a register we don't know if the
> value is stored at least significant byte or most significant byte. In
> order to handle such cases, introduce a bitmask indicating what is the
> target bit and also use it to handle limits to prevent overflow.
> 
> This implementation comes with a libnftnl patch that allows the user to
> generate the following example bytecodes:
> 
> - Bytecode to increase the TTL of a packet
> 
> table filter inet flags 0 use 1 handle 3
> inet filter input use 1 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
> inet filter input 4
>    [ payload load 2b @ network header + 8 => reg 1 ]
>    [ math 8 bits mask 0x000000ff reg 1 + 1 => 1]
>    [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
> 
> - Bytecode to decrease the TTL of a packet
> 
> table filter inet flags 0 use 1 handle 3
> inet filter input use 1 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
> inet filter input 4
>    [ payload load 2b @ network header + 8 => reg 1 ]
>    [ math 8 bits mask 0x000000ff reg 1 - 1 => 1]
>    [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
> 
> - Bytecode to increase the meta mark of a packet
> 
> table mangle inet flags 0 use 1 handle 6
> inet mangle output use 1 type filter hook output prio 0 policy accept packets 0 bytes 0 flags 1
> inet mangle output 2
>    [ meta load mark => reg 1 ]
>    [ math 32 bits reg 1 + 1 => 1]
>    [ meta set mark with reg 1 ]
> 
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
> v2: dropped the byteorder netlink attribute, added bitmask to handle
> LSB/MSB when dealing with u8 and u16, simplified eval logic. I've kept
> nft_math as module, IMHO it would be too much to make it built-in.
> ---

Ugh, I forgot to run ./scripts/checkpatch.pl against this patch, there 
are several warnings. No need to go over them during review, I fixed 
them already and will be included in a v3 :-)

Thanks,
Fernando.
