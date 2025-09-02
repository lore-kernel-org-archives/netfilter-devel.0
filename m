Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA702F3C0F
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 10:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756810637; cv=none; b=Fb7AejuywRceqMhmbv5v7ONLPc3IDW7XYuDGu6eKOZKxg0xjydtfy+xP1UJL0A65NqjQAqIqKtij4ltQmF6wE6O/wIFYPoOi5VxKO+XPxL/dQwNFIqiaJ4NEwCrzLCrhnyQ0P18JE8oh4lqpD2NzZrtBRBguPYXTpRMTgj/s8vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756810637; c=relaxed/simple;
	bh=FhVniLnzzf1cLAynZrfvchcAz1BNnxTkXlu2IE2Y4rI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X+N5Lin+0VMyeaSsIu+OvCPJVcdoJum3Fn33YCNrR44G+rY58CmFCEBmBWQaQ/fQsaa4UKo0ZK+FmsxN0SSwvpix9DbJY1/mthguDCnzV9Ff3H0YzCQz1rkU0JDD23P+y0Ne3DBXPfoN+enLdCeLzO9nNZn+TYasTKdXzZmag78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZAQSHGeU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AQrJgcNg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZAQSHGeU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AQrJgcNg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZAQSHGeU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AQrJgcNg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZAQSHGeU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AQrJgcNg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5EF201F45E;
	Tue,  2 Sep 2025 10:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756810632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxK9z7MmZNxvWQNR008P3aX/RO1fK4fPBBOtvxYUdvs=;
	b=ZAQSHGeUuq4rebhoSVsGMF1p89vXloG9gvLUVcIPxaascJukZdvFPaqFRe+ko2Wiyge4rm
	6IAVKkPWVRfh/827dhcK9vZbMeAA4qBljcNke3jNgARbfPDkPq+oRJja02QGiWg5VdBIvu
	Rv9y9z2cE/vEW5TMATZ3Buwxv7zuvVM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756810632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxK9z7MmZNxvWQNR008P3aX/RO1fK4fPBBOtvxYUdvs=;
	b=AQrJgcNghZiXMc7YboCl3QPmKTI1iZEi2dpdIVXb8DCp8GJZ8ftVw/WK54MgLMpxq88bvz
	VJa4/5rnokUw7/CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756810632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxK9z7MmZNxvWQNR008P3aX/RO1fK4fPBBOtvxYUdvs=;
	b=ZAQSHGeUuq4rebhoSVsGMF1p89vXloG9gvLUVcIPxaascJukZdvFPaqFRe+ko2Wiyge4rm
	6IAVKkPWVRfh/827dhcK9vZbMeAA4qBljcNke3jNgARbfPDkPq+oRJja02QGiWg5VdBIvu
	Rv9y9z2cE/vEW5TMATZ3Buwxv7zuvVM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756810632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxK9z7MmZNxvWQNR008P3aX/RO1fK4fPBBOtvxYUdvs=;
	b=AQrJgcNghZiXMc7YboCl3QPmKTI1iZEi2dpdIVXb8DCp8GJZ8ftVw/WK54MgLMpxq88bvz
	VJa4/5rnokUw7/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19BFE13888;
	Tue,  2 Sep 2025 10:57:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OFUvA4jNtmjOKQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 02 Sep 2025 10:57:12 +0000
Message-ID: <a29f1e46-5962-451a-ac48-35181fada4c4@suse.de>
Date: Tue, 2 Sep 2025 12:56:58 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft] gitignore: ignore "tools/nftables.service"
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20250902100342.4126-1-fmancera@suse.de>
 <aLbLe9Z0ALPW_pdh@strlen.de> <aLbND44WYV7ju0Gx@orbyte.nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aLbND44WYV7ju0Gx@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30



On 9/2/25 12:55 PM, Phil Sutter wrote:
> On Tue, Sep 02, 2025 at 12:48:35PM +0200, Florian Westphal wrote:
>> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>> The created nftables.service file in tools directory should not be
>>> tracked by Git.
>>
>> ACK, but there is already a patch from Phil in the patchwork backlog.
>>
>> Phil, please apply your patch to ignore this file, thanks!
> 
> Sorry for "hiding" such trivial fixes in series worth reviewing. I'll
> push the first two patches from this series:
> 

Hi, no worries! Thank you for applying it :)

> https://lore.kernel.org/netfilter-devel/20250829142513.4608-1-phil@nwl.cc/
> 
> Cheers, Phil

