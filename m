Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7A42DCF71
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 23:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768864487; cv=none; b=Bqz+J1XwZjtmwyRijF2LWxSMHEDHYzOLOCAzlMcxdI7vv150udoGfEXqn06qDm2pfMBp4BvAPrfJ4kgW2z8eFARbpZRA1Cnq1brrD3/GVPPriNTJEsH7dF2gfsgIbqCsSfOYf9s7zocKR0hhUSE2/m/hTp0XPKmNaQr0GFIyeR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768864487; c=relaxed/simple;
	bh=tFRwjmazAOaoSoKqdMhMUO+/DQI2/zbsC2dZDzPUy+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gWF4KflTJpjjbv3ILnNclZ5oZuQ1rcitem5sR2voFpbDr08p+cS36YrbiTH8Aq8pCbWGruSJKJkL0qQ67kDGLsdGjPCK0O7k8KebbL3QwZhcIUgTdEX7PuvT/YDdbsTdgFQTx2fQrWJPpGVRGMwU0tVd6u4f1/PXqWLhR1iudQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wDd55Frl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zoUJPaan; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wl/bdpyA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H3Slzs6r; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wDd55Frl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zoUJPaan";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wl/bdpyA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H3Slzs6r"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5DD405BCC3;
	Mon, 19 Jan 2026 23:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768864484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVa7sc8uwBLNhRhdLVJCJNEOPlGUty4ZO3dbv/n7f7c=;
	b=wDd55FrlWZSSdWBs2fR5xIybSu8IkvGQ7ub/9/Ll2LVh3Kf9mJWEoJd9Po8ShGi/Je1YS/
	7neDdkrupDqs2RfWMdpWkC07knbbvgbnfvwu208vaNmwdG/ZOoDzsO+S/yXUKqAG3xjfRM
	kH2Rn+TAZ3Z3SSqWTixA/wRo0U0Y3so=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768864484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVa7sc8uwBLNhRhdLVJCJNEOPlGUty4ZO3dbv/n7f7c=;
	b=zoUJPaannDCAMGCy063C5xkM8cca0mPRj8tEH8iaATcrEvcJYVRVzc7+X2Pe0P6rW1jfi0
	/X85BMFzJTyCLBAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768864483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVa7sc8uwBLNhRhdLVJCJNEOPlGUty4ZO3dbv/n7f7c=;
	b=wl/bdpyA39czzD0xBLtIt9nSInIRqlppqQlsLWpNPBRoFWtMNMmzCpRtpqmR/w0H539BtZ
	XO5hNDeor2EkL5yOqaP5KTjLnJhhroMxDW3YHSqxsXYRq7YeG5Qw7Am/IhThoZozDWKEO8
	U3OPKGd4Qpw0rov8QnWxsNTZyPmPBkM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768864483;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVa7sc8uwBLNhRhdLVJCJNEOPlGUty4ZO3dbv/n7f7c=;
	b=H3Slzs6r5iizTuWZrfO15MBm/95dbOhgB3wwOOOcRm2Sge78jzmjxKmDiWsK7ydUVALNh8
	/8Jva8hDIjHghQBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF0B83EA63;
	Mon, 19 Jan 2026 23:14:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iuXUNuK6bmlncQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 19 Jan 2026 23:14:42 +0000
Message-ID: <18fa7f7c-22ee-42d9-b698-03df94f24d4c@suse.de>
Date: Tue, 20 Jan 2026 00:14:31 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next v2] netfilter: nf_conncount: fix tracking of
 connections from localhost
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc,
 Michal Slabihoudek <michal.slabihoudek@gooddata.com>
References: <20260119203546.11207-1-fmancera@suse.de>
 <aW6X1kBQ8clOAL76@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aW6X1kBQ8clOAL76@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO

On 1/19/26 9:45 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> Since commit be102eb6a0e7 ("netfilter: nf_conncount: rework API to use
>> sk_buff directly"), we skip the adding and trigger a GC when the ct is
>> confirmed. For connections originated from local to local it doesn't
>> work because the connection is confirmed on POSTROUTING, therefore
>> tracking on the INPUT hook is always skipped.
>>
>> In order to fix this, we check whether skb input ifindex is set to
>> loopback ifindex. If it is then we fallback on a GC plus track operation
>> skipping the optimization. This fallback is necessary to avoid
>> duplicated tracking of a packet train e.g 10 UDP datagrams sent on a
>> burst when initiating the connection.
>>
>> Tested with xt_connlimit/nft_connlimit and OVS limit and with a HTTP
>> server and iperf3 on UDP mode.
> 
> LGTM, thanks Fernando.  But shouldn't this go via nf tree?
> 

Yes but it will conflict with 76c79f31706a ("netfilter: nf_conncount: 
increase the connection clean up limit to 64") when merging both trees. 
Also it is rc7 cycle now.. so not sure.

Anyway, if you think nf tree is better let me know if I should send a v3 
rebased in top of it. I am fine with both trees as long as the conflict 
isn't a problem.

Thanks,
Fernando.
