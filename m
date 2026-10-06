Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EECD383987;
	Tue,  6 Oct 2026 21:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791321688; cv=none; b=T78DLEYVdN8Hwh8Q4peNnDuQkV5fGecjtei2BtyPrMHS/7+XzXhjCPAyzsfmDBO3e4P6Unt4/GB4WPq7quyBgGtKbMfwwzxr4lpOKs+xgvJqEHmJZo2xUi0VfhBpMr25646yZ+cUp+Rrv8ipLjZCqTL1aszIXI2yv/vWx8gn1yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791321688; c=relaxed/simple;
	bh=+rN6+W0kpbhT2PMBQ5tO3wwT+3cNzF8JcxG4Fa2hojw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sTF2WbyRSTpwXkaM1hDlx8fGWql3bzx7HKpT9gGe4RdDeu5XPhzJY9mJzkRJh/yqwDYEIurl9k4iZ+P/IykyGQvRl0lp80ZOlL/8/l3YlxcVPir7rAmgmEl2U7LOXfuTcVdo1yJg3GGArI4XzYsWMoM0bkBHNHb5zPweLh7auRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JGEKJcb8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=c4V333GH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jF0Dxb/1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wkOprfuR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JGEKJcb8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="c4V333GH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jF0Dxb/1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wkOprfuR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 195A41F7E1;
	Tue,  6 Oct 2026 21:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791321681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/kFhnU6EL5J6ASc70rjGdPvahMo4Qt7faCK2CaPoOZE=;
	b=JGEKJcb88P49OCe0UJjf3dvwdTWaZRHgTDJwq4T5TJIvgGLmwlRl54/kXQjzcja5P2Ijj2
	/wFtdkWcB2+fanniBU0J4gnl9y06h9U7GPKI3L41/zUkRFcG1pqxLYHoxdzh/f6U5Qu5Nx
	4fDw92qbhVe4Y46Kgp1vQVRUZlnHdIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791321681;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/kFhnU6EL5J6ASc70rjGdPvahMo4Qt7faCK2CaPoOZE=;
	b=c4V333GH9sAbdTHAE+0wGgrOUebKgOOsxjkYBeMhr98GixnGflklUeN2u1mRfyn+MLlpil
	FFBnHtm3lVlWE8BA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791321677; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/kFhnU6EL5J6ASc70rjGdPvahMo4Qt7faCK2CaPoOZE=;
	b=jF0Dxb/1XMHOc2Tpat7fVnyZOhrtcSYB0K4FHbSqTZZ6qL6PRnCZAz76FHTpuKGs+rR0oF
	T6w++f7lu6mBBh3IJ3zqLFQeKB7acXDN1fRqFaaIwaN9wakDsvFUKbTudlOgf0yBpv1mpk
	wpsu2C4J32LPPpoRAlhQvFx8z0hgXZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791321677;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/kFhnU6EL5J6ASc70rjGdPvahMo4Qt7faCK2CaPoOZE=;
	b=wkOprfuRj/cLEiBdDIGyfyyJ0AD0MI4a2tpdTO8XLzt84/tdrMxJ3EogYCnpUhqkAi7ZNc
	AJsxgTehuab5GeBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C266137AC;
	Tue,  6 Oct 2026 21:21:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qeahFkxmxWraYAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 06 Oct 2026 21:21:16 +0000
Message-ID: <b8aac52d-c69c-436f-83eb-572df8c40e7c@suse.de>
Date: Tue, 6 Oct 2026 23:20:13 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft v2] doc: add MPTCP subtypes documentation to man page
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, matttbe@kernel.org
References: <20261006204803.11155-1-fmancera@suse.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261006204803.11155-1-fmancera@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO

On 10/6/26 10:48 PM, Fernando Fernandez Mancera wrote:
> In addition, document the limitation when there are multiple MPTCP
> options.
> 
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
> v2: added valid MPTCP situations suggested by Matthieu
> ---

I have accidentally sent this to netdev mailing list too. Please ignore 
it, it only concerns netfilter-devel.

Sorry for the inconvenience.

>   doc/payload-expression.txt | 41 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 41 insertions(+)
> 
> diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
> index ceccfdaa..53e92905 100644
> --- a/doc/payload-expression.txt
> +++ b/doc/payload-expression.txt
> @@ -805,6 +805,32 @@ TCP option matching also supports raw expression syntax to access arbitrary opti
>   [verse]
>   *tcp option* *@*'number'*,*'offset'*,*'length'
>   
> +.MPTCP subtypes
> +[options="header"]
> +|============================
> +|Keyword| Description
> +|mp-capable|
> +Multipath capable
> +|mp-join|
> +Join connection
> +|dss|
> +Data sequence signal
> +|add-addr|
> +Add address
> +|remove-addr|
> +Remove address
> +|mp-prio|
> +Change subflow priority
> +|mp-fail|
> +Fallback to single-path TCP
> +|mp-fastclose|
> +Fast close
> +|mp-tcprst|
> +Subflow reset
> +|============================
> +
> +Data types can be queried with 'nft describe tcp option mptcp subtype'.
> +
>   .IP Options
>   [options="header"]
>   |==================
> @@ -833,6 +859,21 @@ filter input tcp option sack-perm exists counter
>   filter input tcp option maxseg size lt 536
>   --------------------
>   
> +.matching MPTCP suboptions
> +--------------------
> +filter input tcp option mptcp subtype mp-join drop
> +--------------------
> +
> +[NOTE]
> +====================
> +Netfilter currently evaluates only the first MPTCP option found in the TCP
> +header. If a packet contains multiple MPTCP options, a rule attempting to match
> +the second option will never match. Having multiple MPTCP options in the same
> +packet is valid, e.g the Linux MPTCP stack inserts 'remove-addr', 'mp-prio' and
> +'mp-fail' after an MPTCP 'dss' option; 'mp-tcprst' can also be inserted after
> +an 'mp-fastclose'.
> +====================
> +
>   .matching IPv6 exthdr
>   ---------------------
>   ip6 filter input frag more-fragments 1 counter

