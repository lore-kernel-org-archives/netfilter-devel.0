Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFE24C6C
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Jan 2026 15:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768751464; cv=none; b=JL9KKs2UgefXMctaaMPwb3x+Ou+t5yBAL4PPnVhRxMJE3l42wT5jX4y+uynK04OmkJsyNHjAls9W7wwHJzrTNdZyXwMu42UFXA9akmM1Ru3toz92BpswtzJwSAmAiFUQFIg+lFAlLYS5EutZPfrNleWh61jCJWoq/dJbZ/ln7z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768751464; c=relaxed/simple;
	bh=FNerokf4gmCi2fDYTMTyzCpltZFwfMAWJpJS/M+EUiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fXC6GFo+XHGOsfDkTZwygMyErWdT7K8xOHAm1aQMDGNCAee+QqmLbN26szS3LBZApHtGrB7ZMNwZLbfpPJZilaC2rHbt5Wu3kcjmRxo3Q5iJ9/14y1XURC6kabeipsYZ39fxLnsgOvl4dI96pM+T8X/E2L08oPoiV5WE9ZP0Hwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ukPOtP4n; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YaCSnSBg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ukPOtP4n; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YaCSnSBg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ukPOtP4n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YaCSnSBg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ukPOtP4n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YaCSnSBg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CAB743368B;
	Sun, 18 Jan 2026 15:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768751460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ackrLSbk2OllKeISgaWeHdKm8Un/ejtxtSbAgNUyf+U=;
	b=ukPOtP4n3tGE3H/GNHzPT19WBYGl42a4r0bSmvW5rJtlcAZL8hktX2QyHpUmdUF6hL18C4
	adwOesdY8AS9isebxyWwmdvc/xMjTjs8R0LpehKPexECnZ5vDmlD1FQr0ayXk6vqx1ghFn
	KZDI8rkX/C9MSWOEsTh9MhMUsRYeB6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768751460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ackrLSbk2OllKeISgaWeHdKm8Un/ejtxtSbAgNUyf+U=;
	b=YaCSnSBgzOqMIwcKvQGHF/duuLiXViDUIj50FSpuJvc2jQ2rlN7GFxr+Rmec/pYGGi6XPE
	oas/vwxeOPOAwWCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768751460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ackrLSbk2OllKeISgaWeHdKm8Un/ejtxtSbAgNUyf+U=;
	b=ukPOtP4n3tGE3H/GNHzPT19WBYGl42a4r0bSmvW5rJtlcAZL8hktX2QyHpUmdUF6hL18C4
	adwOesdY8AS9isebxyWwmdvc/xMjTjs8R0LpehKPexECnZ5vDmlD1FQr0ayXk6vqx1ghFn
	KZDI8rkX/C9MSWOEsTh9MhMUsRYeB6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768751460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ackrLSbk2OllKeISgaWeHdKm8Un/ejtxtSbAgNUyf+U=;
	b=YaCSnSBgzOqMIwcKvQGHF/duuLiXViDUIj50FSpuJvc2jQ2rlN7GFxr+Rmec/pYGGi6XPE
	oas/vwxeOPOAwWCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6238E3EA63;
	Sun, 18 Jan 2026 15:51:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HFWvFGQBbWmdKwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 18 Jan 2026 15:51:00 +0000
Message-ID: <db94e3de-d949-449f-aabb-75de17ee6d21@suse.de>
Date: Sun, 18 Jan 2026 16:50:55 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: fix tracking of
 connections from localhost
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc,
 Michal Slabihoudek <michal.slabihoudek@gooddata.com>
References: <20260118111316.4643-1-fmancera@suse.de>
 <aWzQoFTl6Cf4Vt3T@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aWzQoFTl6Cf4Vt3T@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Level: 
X-Spam-Flag: NO

On 1/18/26 1:22 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> Since commit be102eb6a0e7 ("netfilter: nf_conncount: rework API to use
>> sk_buff directly"), we skip the adding and trigger a GC when the ct is
>> confirmed. For connections originated from local to local it doesn't
>> work because the connection is confirmed from a early stage, therefore
>> tracking is always skipped.
> 
> Alternative:
> 
> @@ -415,7 +415,7 @@ insert_tree(struct net *net,
>                          if (ret && ret != -EEXIST)
>                                  count = 0; /* hotdrop */
>                          else
> -                               count = rbconn->list.count;
> +                               count = rbconn->list.count ? rbconn->list.count : 1;
> 
> ?
> 

I also thought about this but to me it feels a bit misleading. In 
essence, packets will go through but connections won't be tracked.

See the comment below, if you believe we should not cover this use case 
I am fine with this proposed alternative.

> connlimit for localhost connections only works correctly in output or
> postrouting, even before any of your changes.
> 
> As you say; for local connections, confirmation happens in postrouting,
> i.e., before prerouting rules are evaluated.
> 
> Hence, even before any of your changes, the conntrack limit is never
> effective because the connections are confirmed before.
> In the reported example, its no problem to create 1000k connections,
> 500 will go through, rest will eventually time out.  But they are
> created.
> 
> AFAICS the problem is erroneous trigger of "hotdrop" mode.  First
> connection attempt allocates new node, with count == 1.
> 
> Subsequent attempt encounter -EEXIST check instead of add, then
> return list length with is 0, not 1  so packet gets dropped.
> 
> Without your patches, connections won't complete once reaching
> the limit, but the conntrack entries can be allocated and are confirmed
> regardless of "-m connlimit".
> 
> Thus I'm not sold on this use case, it doesn't limit connections,
> it only limits established ones.
> 

Yes, this is completely right. I think the main issue here is that the 
usage and definition of connlimit has been too open. E.g people started 
using it for soft-limiting connections while it wasn't designed for that.

Here, this is a similar situation. I have seen people using connlimit to 
limit the number of connections established against a specific backend.

> If its legit case, then we should have a test case for this in
> iptables.git .
> 
> That said, the patch looks correct to me.

To me it is a legit case, corner case for sure but legit. Anyway, I am 
fine adding both solutions and won't push hard on this because as I said 
is quite corner case. I am just afraid of breaking existing use cases.

Thank you for the feedback Florian!
