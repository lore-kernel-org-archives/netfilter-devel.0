Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F683054E8
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 15:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756827255; cv=none; b=aTEIKUWtcRRCueRk4bhm8t2zZhCYjpQSr+kb/HTh/iVOoUXV+JP5oXVIzrY01Sfj5ZFblMo751qeKxDx/iVqxmfq/8utaDClC4XNJnbCwpmd6+P8JBAWq6dpav5LrkusKbK37fKX7H9dRFA/Sdaav3kepdGnYgoNZ0xXez8XgdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756827255; c=relaxed/simple;
	bh=aQCRujsTlC0frNz5+qr6CWgLOyu2hK0EcsgehXroe9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lNoivveZKr3NG16cL6w2CL9mkC8TpbBY7/DiVVumy597vNmD6mOq8RptbymOKen7dvgCrQmIZDLD0O+gLmt8ce7r/evHG32LlRgAe4r5xpblzpwOHgzFZ4YLh/JzkXDU0RsX4fdaB05a36peoHD2nsXskseRLQOrx/kvvotJg1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=n329G/MG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KsYY9+uy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=n329G/MG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KsYY9+uy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="n329G/MG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KsYY9+uy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="n329G/MG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KsYY9+uy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 433551F453;
	Tue,  2 Sep 2025 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756827251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwLCbH32l72FYfYvmhtAejSv5RjDbY/KJ3iGUIOfqIM=;
	b=n329G/MGuOxOaRkPBTxAXWAjhn4fYIrnkW5ecnNFRn5LBmE7xoI9/Zq5sxPrHU2nyEUTMP
	e6bSUJwrk2HXUJaX7Zgj9O+kCGcii5AY1jw+uKSjBAgMT2/br3RSofcaXhVh8gehZzkhZY
	BIvToyliVH+QZR2UqizuBifusd4TIrE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756827251;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwLCbH32l72FYfYvmhtAejSv5RjDbY/KJ3iGUIOfqIM=;
	b=KsYY9+uy48y50BW6dstmPCN4XNJV4fkhIIlhnZwR3Jdvg8k2yFiAcn3YNo1nXIqGnAbjSP
	wXlIRSD5zZ4BLzDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="n329G/MG";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KsYY9+uy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756827251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwLCbH32l72FYfYvmhtAejSv5RjDbY/KJ3iGUIOfqIM=;
	b=n329G/MGuOxOaRkPBTxAXWAjhn4fYIrnkW5ecnNFRn5LBmE7xoI9/Zq5sxPrHU2nyEUTMP
	e6bSUJwrk2HXUJaX7Zgj9O+kCGcii5AY1jw+uKSjBAgMT2/br3RSofcaXhVh8gehZzkhZY
	BIvToyliVH+QZR2UqizuBifusd4TIrE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756827251;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwLCbH32l72FYfYvmhtAejSv5RjDbY/KJ3iGUIOfqIM=;
	b=KsYY9+uy48y50BW6dstmPCN4XNJV4fkhIIlhnZwR3Jdvg8k2yFiAcn3YNo1nXIqGnAbjSP
	wXlIRSD5zZ4BLzDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F015C13A54;
	Tue,  2 Sep 2025 15:34:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tg+bN3IOt2j7DAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 02 Sep 2025 15:34:10 +0000
Message-ID: <e2c78075-e3b7-4124-a530-54652910a2d5@suse.de>
Date: Tue, 2 Sep 2025 17:34:02 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: nft_meta_bridge: introduce
 NFT_META_BRI_IIFHWADDR support
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20250902112808.5139-1-fmancera@suse.de>
 <aLbeVpmjrPCPUiYH@strlen.de> <aLcBOhmSNhXrCLIh@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aLcBOhmSNhXrCLIh@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 433551F453
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51



On 9/2/25 4:37 PM, Pablo Neira Ayuso wrote:
> On Tue, Sep 02, 2025 at 02:08:54PM +0200, Florian Westphal wrote:
>> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>> Expose the input bridge interface ethernet address so it can be used to
>>> redirect the packet to the receiving physical device for processing.
>>>
>>> Tested with nft command line tool.
>>>
>>> table bridge nat {
>>> 	chain PREROUTING {
>>> 		type filter hook prerouting priority 0; policy accept;
>>> 		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr accept
>>> 	}
>>> }
>>>
>>> Joint work with Pablo Neira.
>>
>> Sorry for crashing the party.
>>
>> Can you check if its enough to use the mac address of the port (rather
>> than the bridge address)?
>>
>> i.e. add veth0,1 to br0 like this:
>>
>>          br0
>> a -> [ veth0|veth1 ] -> b
>>
>> Then check br0 address.
>> If br0 has address of veth1, then try to redirect
>> redirect by setting a rule like 'ether daddr set <*veth0 address*>
>>
>> AFAICS the bridge FDB should treat this as local, just as if one would
>> have used the bridges mac address.
> 

You are right Florian, I have tested this on the following setup.

1. ping from veth0_a on netns_a to veth1_b on netns_b

                      +----br0----+
                      |           |
veth0_a------------veth0      veth1--------veth1_b
(192.168.10.10/24)                     (192.168.10.20/24)

Using the MAC of the port, the packet is consumed by the bridge too and 
not forwarded. So, no need for it to be the MAC address of the bridge 
itself..

> That sounds more generic if it works, yes.
> 
> This patch was just mocking the existing behaviour in
> net/bridge/netfilter/ebt_redirect.c for this case.
> 
>> If it works i think it would be better to place a 'fetch device mac
>> address' in nft_meta rather than this ibrhwdr in bridge meta, because
>> the former is more generic, even though I don't have a use case other
>> than bridge-to-local redirects.
>>

I am going to send a new patch implementing a "fetch device mac address" 
in nft_meta directly.

Thank you!

>> That said, if it doesn't work or the ibrhwdr has another advantage
>> I'm missing then I'm fine with this patch.
> 
> Unknown to me, but I am fine with reviewing the existing approach and
> understand why this bridge redirect was done like this back in 1999.

