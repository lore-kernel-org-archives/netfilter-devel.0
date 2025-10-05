Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F48434BA56
	for <netfilter-devel@vger.kernel.org>; Sun,  5 Oct 2025 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759676542; cv=none; b=VEyLjyEmOILjRvsHXGbtihHs6uwbdfzoVu3Op7EclfToCXgH70w5bDNnAVUwQOZMuiHbN1odec4uMda/0axadjxoweOIB07dmpUbvjz74/+XdLPmnoMuTZfoFzN1ASWPNUhGMlc2+EN/4smss4ufoyrzDG1agb1TN4PKOXC/w5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759676542; c=relaxed/simple;
	bh=Ts35Kt5eGjEHg9gQqHS+Q3egBjqNv7A5TSQoy6Y8GDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Len3tMtIxVowzMG5gZOknk/Vz/EaXP5VpFxdev6RIXRSINd0/YSaQJoe/mJaG1xOxGyZOJ4bUrHnu/xrAdIOX+LAE61mQeE5D4i3a9HOCu2axOCFk1MXIUqc6Vap3rfLmjN84qltjuTrwcEm2pGu4PO48iJDGV4NFMF5eg1Pp/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JRcDnO+W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UlhsJoOP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JRcDnO+W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UlhsJoOP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JRcDnO+W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UlhsJoOP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JRcDnO+W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UlhsJoOP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 743645BD44;
	Sun,  5 Oct 2025 15:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759676538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nkrMIEHXP0MoJeGD6FoND+uRxc3j1xJ3ZKN78d1Ljg=;
	b=JRcDnO+W9Lxwp8gBXqvR9S3hAwDgkw3X5xmtr5nk/XyaHAzAnq52xSAL+hoVvzDaPMAb5N
	mhVr7L351Ltw+AXiq2NhSFoXVM3UqNiTrD48XslOLrUN6bQWFXpKvRD2sUXwFIDufjVQpy
	p/WTeeMCPwY9PSLYUqyxSA11MfD/NkI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759676538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nkrMIEHXP0MoJeGD6FoND+uRxc3j1xJ3ZKN78d1Ljg=;
	b=UlhsJoOPMm/yAveXZUdW6rRA+UFeZm9v+UrKPW9JrQQv5dRflwpzJ+v2+lc5eGLpfF3Zbe
	98tn3NAwpN/iRiDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759676538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nkrMIEHXP0MoJeGD6FoND+uRxc3j1xJ3ZKN78d1Ljg=;
	b=JRcDnO+W9Lxwp8gBXqvR9S3hAwDgkw3X5xmtr5nk/XyaHAzAnq52xSAL+hoVvzDaPMAb5N
	mhVr7L351Ltw+AXiq2NhSFoXVM3UqNiTrD48XslOLrUN6bQWFXpKvRD2sUXwFIDufjVQpy
	p/WTeeMCPwY9PSLYUqyxSA11MfD/NkI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759676538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nkrMIEHXP0MoJeGD6FoND+uRxc3j1xJ3ZKN78d1Ljg=;
	b=UlhsJoOPMm/yAveXZUdW6rRA+UFeZm9v+UrKPW9JrQQv5dRflwpzJ+v2+lc5eGLpfF3Zbe
	98tn3NAwpN/iRiDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19E8613A39;
	Sun,  5 Oct 2025 15:02:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V7eiAnqI4mhiSAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 05 Oct 2025 15:02:18 +0000
Message-ID: <fd8a8886-2f06-49ba-bede-6bffdd490d8a@suse.de>
Date: Sun, 5 Oct 2025 17:02:11 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nf_tables: validate objref and objrefmap
 expressions
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
References: <20251004230424.3611-1-fmancera@suse.de>
 <aOJZ9dlb5cYGR13c@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aOJZ9dlb5cYGR13c@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
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
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30



On 10/5/25 1:43 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> Referencing a synproxy stateful object can cause a kernel crash due to
>> its usage on the OUTPUT hook. See the following trace:
> 
> I edited this slightly to mention the recursion and applied
> this patch to nf:testing.
> 
> Let me know if I messed anything up.
> 

All looks good, thank you Florian!

