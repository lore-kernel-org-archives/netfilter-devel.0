Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D453D610C
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749733318; cv=none; b=QdrFpgfXuwe+Q70QeWbKoZxoC6pnuhworC/l3dc9h27tBjTsJ0XXYBUYP8RrcDN0N/b1HpjeDN0HEpsVbRUmhP5izI/4acZRxLLH/vrmCa0WksModbmkFITY2slcJ2cyv51UP8uGR57GLXKStiTtiBk+8sr2Qx07ohChC4gl568=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749733318; c=relaxed/simple;
	bh=KFDy3yiN0jjZgQHBGNYoHZ3Gp/J4xkSTqeVbXVVIF8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D4byd737PYhrnDypxlPrLOxr1Mfz5oCTxt1ohv/eW4GVLb7A7F4vw0ebfvsWtUC6SO7EmIxItJc7SMKlWswI3emLP78RPgprcNagQ50eCeaAPZKhSQkxGJfTI0a2/RZXbPmhJ3DCyXUV+twi3DxYSjlbYlU/xMgucGFM0tcU0UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=h9sNIS+A; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z1sYDU1Z; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=h9sNIS+A; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z1sYDU1Z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="h9sNIS+A";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z1sYDU1Z";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="h9sNIS+A";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z1sYDU1Z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F41491F8D9;
	Thu, 12 Jun 2025 13:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749733315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UT1dnRVjU73sQR16O3OZoFTkHZEZQ6spuyl8HEpKQhE=;
	b=h9sNIS+AQdlriBmrOD25gWyZAOTAwpBtZnRi/Rj3jDgHRB60BWS+iftgK679zJ2gHMhXCh
	ccNrPqopJUO1tHTTP2p8yl0X3Xly5/3kdYVNi7dv7cmgeIdKCn9Dp8PkqCo77EAFIITHng
	KcC0bXL5U8leNTZfiqXBNMTVSjYxtxY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749733315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UT1dnRVjU73sQR16O3OZoFTkHZEZQ6spuyl8HEpKQhE=;
	b=Z1sYDU1ZwWWTac17q05u0rzYfbpZleZJvuG/RLLm0XkspiNZRkag8ELAHpBkMVZHS1qkoR
	fReb5USzZQPsmADg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749733315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UT1dnRVjU73sQR16O3OZoFTkHZEZQ6spuyl8HEpKQhE=;
	b=h9sNIS+AQdlriBmrOD25gWyZAOTAwpBtZnRi/Rj3jDgHRB60BWS+iftgK679zJ2gHMhXCh
	ccNrPqopJUO1tHTTP2p8yl0X3Xly5/3kdYVNi7dv7cmgeIdKCn9Dp8PkqCo77EAFIITHng
	KcC0bXL5U8leNTZfiqXBNMTVSjYxtxY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749733315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UT1dnRVjU73sQR16O3OZoFTkHZEZQ6spuyl8HEpKQhE=;
	b=Z1sYDU1ZwWWTac17q05u0rzYfbpZleZJvuG/RLLm0XkspiNZRkag8ELAHpBkMVZHS1qkoR
	fReb5USzZQPsmADg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D199C139E2;
	Thu, 12 Jun 2025 13:01:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7YVQMsLPSmgPAwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 12 Jun 2025 13:01:54 +0000
Message-ID: <952e3323-8dcb-4275-888a-15909b5c72f4@suse.de>
Date: Thu, 12 Jun 2025 15:01:44 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20250527193420.9860-1-fmancera@suse.de>
 <20250527193420.9860-2-fmancera@suse.de> <aDZaAl1r0iWkAePn@strlen.de>
 <aEd8Nfv5Zce1p0FD@calendula> <aEfKRbJehyaq1p8S@strlen.de>
 <aEf_LPJT1cFjYknu@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aEf_LPJT1cFjYknu@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 



On 6/10/25 11:47 AM, Pablo Neira Ayuso wrote:
> On Tue, Jun 10, 2025 at 08:01:41AM +0200, Florian Westphal wrote:
>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>>> Hmm, this looks like the API leaks internal data layout from nftables to
>>>> libnftnl and vice versa?  IMO thats a non-starter, sorry.
>>>>
>>>> I see that options are essentially unlimited values, so perhaps nftables
>>>> should build the netlink blob(s) directly, similar to nftnl_udata()?
>>>>
>>>> Pablo, any better idea?
>>>
>>> Maybe this API for tunnel options are proposed in this patch?
>>
>> Looks good, thanks Pablo!
>>
>>> Consider this a sketch/proposal, this is compiled tested only.
>>>
>>> struct obj_ops also needs a .free interface to release the tunnel
>>> options object.
>>
>> nftnl_tunnel_opts_set() seems to be useable for erspan and vxlan.
>>
>> Do you have a suggestion for the geneve case where 'infinite' options
>> get added?
>>
>> Maybe add nftnl_tunnel_opts_append() ? Or nftnl_tunnel_opts_add(), so
>> api user can push multiple option objects to a tunnel, similar to how
>> rules get added to chains?
> 
> nftnl_tunnel_opts_add() sounds good.
> 
> It should be possible to replace nftnl_tunnel_opts_set() by
> nftnl_tunnel_opts_add(), then a single function for this purpose is
> provided. As for vxlan and erpan, allow only one single call to
> nftnl_tunnel_opts_add().
> 
> See attachment, compile tested only.
> 

This looks good to me. Let me include it on my series and extend the 
free interface.

Thanks Pablo!

>> Would probably require a few more api calls including iterators.
>>
>> Fernando, do you spot anything else thats missing for your use cases?

