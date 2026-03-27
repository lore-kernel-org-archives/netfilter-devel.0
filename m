Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399013DCD86
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2026 10:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774607794; cv=none; b=kSn2Q6yGNpu7R+I0mnrqiPCvi1Eo93zUrNM9T/w0D5jKp3rH96ekbHAITLS0FnCwB9crXpw8EXG5CcIN7k2JZLvsXNxkvJbOqC8pPrUaRu+9Wttnw7fgHlTTUubb0upfwwRdOYfVuI8EmUuIRrCnI/MRDO+eHycI/Iytx0IaZpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774607794; c=relaxed/simple;
	bh=j+Eczm2XpwMxshqABtCPbSz8QsAvGwssr/Zt3v/mgvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KFkdZWH6vrzdC7gHJJtxuccc8Xv8gSIR//o5BvQVGgYLswbfAyMP+I+htHqv09N4yv3DN2CWYYffr8C9ym7tQ9UTGUHI1wRfnkGMTGR/YsJ3tYYl+RRds+1y1sdeHKSALh5UOLL4+RNpMCkoUc7yF52oeCLg5JttW6eKG7tLiSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=L2nN4pWS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=11laDLyb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=L2nN4pWS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=11laDLyb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="L2nN4pWS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="11laDLyb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="L2nN4pWS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="11laDLyb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 81B7C4D1C7;
	Fri, 27 Mar 2026 10:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774607791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FSBPjZ0IOkm8PrN2cYxYmKIQTtyVd5d0D8cRgMK1/1k=;
	b=L2nN4pWSCrxonjeWNyIbjxA8l6vEMOyHjhmOWASRzgDTbVJfkIRBxvO1sqKiiijkTeHarn
	PqIKe6RUWijIriI/PeS9Y2yBAyRqSaYGRMONyRwPZ/r06GFBkGfJZlLnsE6KY6HF87bZxd
	CtLBHCEW+1K11Ep2CHsh/1u9KyyhD84=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774607791;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FSBPjZ0IOkm8PrN2cYxYmKIQTtyVd5d0D8cRgMK1/1k=;
	b=11laDLybnPLjE611Cw7AISD0KhbU8dl06TwxZtWSrvqrRsUfYwv8ELPxNFoN8Ph0dABRMV
	kj6tzMx35aijt3DQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774607791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FSBPjZ0IOkm8PrN2cYxYmKIQTtyVd5d0D8cRgMK1/1k=;
	b=L2nN4pWSCrxonjeWNyIbjxA8l6vEMOyHjhmOWASRzgDTbVJfkIRBxvO1sqKiiijkTeHarn
	PqIKe6RUWijIriI/PeS9Y2yBAyRqSaYGRMONyRwPZ/r06GFBkGfJZlLnsE6KY6HF87bZxd
	CtLBHCEW+1K11Ep2CHsh/1u9KyyhD84=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774607791;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FSBPjZ0IOkm8PrN2cYxYmKIQTtyVd5d0D8cRgMK1/1k=;
	b=11laDLybnPLjE611Cw7AISD0KhbU8dl06TwxZtWSrvqrRsUfYwv8ELPxNFoN8Ph0dABRMV
	kj6tzMx35aijt3DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 464A24A0A2;
	Fri, 27 Mar 2026 10:36:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0L7fDa9dxmk9YwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 27 Mar 2026 10:36:31 +0000
Message-ID: <e93c1dea-ec47-4b5d-97fe-a638d997ace4@suse.de>
Date: Fri, 27 Mar 2026 11:36:21 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf,v2] netfilter: flowtable: strictly check for maximum
 number of actions
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
References: <20260326223023.741604-1-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260326223023.741604-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 3/26/26 11:30 PM, Pablo Neira Ayuso wrote:
> The maximum number of flowtable hardware offload actions in IPv6 is:
> 
> * ethernet mangling (4 payload actions, 2 for each ethernet address)
> * SNAT (4 payload actions)
> * DNAT (4 payload actions)
> * Double VLAN (4 vlan actions, 2 for popping vlan, and 2 for pushing)
>    for QinQ.
> * Redirect (1 action)
> 
> Which makes 17, while the maximum is 16. But act_ct supports for tunnels
> actions too. Note that payload action operates at 32-bit word level, so
> mangling an IPv6 address take 4 payload actions.
> 
> Update flow_action_entry_next() calls to check for the maximum number of
> supported actions.
> 
> While at it, rise the maximum number of actions per flow from 16 to 24
> so this works fine with IPv6 setups.
> 
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
