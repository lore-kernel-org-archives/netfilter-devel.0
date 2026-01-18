Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A7422CBF1
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Jan 2026 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768754055; cv=none; b=Qu+hRPxshO2H7hAf4mkSObRiLVEu7EiWZZTkJy1uqGp5wVRI2uXrtaCUgJXlld6ry6rbR+28QgyuGfSClbdWjCa5GnkWisADr8KbFpiDgYZBC9ibfuJ8z/04imttS6V2UUGAu8JMkwSqVlV1BYIHbLZk2lC1NfY2CfObULogiZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768754055; c=relaxed/simple;
	bh=DSj22WFJyx1UIvxO8TGvh4clftqDewN20SpSb9PH2pM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WqQxwM3eB0m5mIJm1DaCk86iujwYJUvadV0jBIBxvESoesQLHOwas+pZOPf1PT/2lGTYKIPvq/9tybefbTMvsdgPoQ0QrIyvPeT8/XAfsdpQRobVH5vSz/0zO1GShy0yRDGT+Qsg2lA9m7UEqbvLF1G84mIJMrtVowpJ8n5tm8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZU0Ebh9t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5np8IZEJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZU0Ebh9t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5np8IZEJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZU0Ebh9t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5np8IZEJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZU0Ebh9t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5np8IZEJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1164F336EA;
	Sun, 18 Jan 2026 16:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768754052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGfJbo6IGtPNIuYPzBca7qMdl9K9qJVZWrsR3u6K3HE=;
	b=ZU0Ebh9trMb+pJpGEaWZ4nFJHNnHcPKL5sbcfx9gYK0M8UXyJyC7GZ3iW4NlhZBncULhYB
	zMAfGznX5LcvuiW8lZ2q55DM4LX2HkbR8D23lSOJDIP6ERZbvXHl6LZZ8LHbhN8xg1C21Z
	jgxt22pdV4hZuQasEMjW7f1cujchm4M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768754052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGfJbo6IGtPNIuYPzBca7qMdl9K9qJVZWrsR3u6K3HE=;
	b=5np8IZEJx+qXhDFkws72C0LoWblJB932lYMzNTHOdHx87xew3K76qXGWqAIfuYUCoTvqP8
	C6yFy97eGKxFefCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZU0Ebh9t;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5np8IZEJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768754052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGfJbo6IGtPNIuYPzBca7qMdl9K9qJVZWrsR3u6K3HE=;
	b=ZU0Ebh9trMb+pJpGEaWZ4nFJHNnHcPKL5sbcfx9gYK0M8UXyJyC7GZ3iW4NlhZBncULhYB
	zMAfGznX5LcvuiW8lZ2q55DM4LX2HkbR8D23lSOJDIP6ERZbvXHl6LZZ8LHbhN8xg1C21Z
	jgxt22pdV4hZuQasEMjW7f1cujchm4M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768754052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGfJbo6IGtPNIuYPzBca7qMdl9K9qJVZWrsR3u6K3HE=;
	b=5np8IZEJx+qXhDFkws72C0LoWblJB932lYMzNTHOdHx87xew3K76qXGWqAIfuYUCoTvqP8
	C6yFy97eGKxFefCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A15B13EA63;
	Sun, 18 Jan 2026 16:34:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LiW4I4MLbWnaUgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 18 Jan 2026 16:34:11 +0000
Message-ID: <7d24517c-1209-49cc-a9cc-26eaf1a0e49e@suse.de>
Date: Sun, 18 Jan 2026 17:34:06 +0100
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
 <aWzQoFTl6Cf4Vt3T@strlen.de> <db94e3de-d949-449f-aabb-75de17ee6d21@suse.de>
 <aW0EZPoM60XTy6kJ@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aW0EZPoM60XTy6kJ@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.51
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1164F336EA
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 1/18/26 5:03 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> To me it is a legit case, corner case for sure but legit. Anyway, I am fine
>> adding both solutions and won't push hard on this because as I said is quite
>> corner case. I am just afraid of breaking existing use cases.
> 
> Yes :-/
> 
> What about a v2 that checks skb->skb_iif, would that work?
> I dislike the need to unconditionally wait for SEEN_REPLY.
> 

After a quick test, it works for local connections. Although it doesn't 
work for reverse-connlimit on INPUT. Consider the following ruleset:

iptables -I INPUT -p tcp --sport 80 --tcp-flags FIN,SYN,RST,ACK SYN -m 
connlimit --connlimit-above 100 -j LOG --log-prefix "Exceeded limit 
established connections to 443"

But I believe this isn't correct and this should be in OUTPUT instead. 
In the OUTPUT it works well.

To clarify this is the diff:

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 5588cd0fcd9a..339aaf5e3393 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -182,7 +182,7 @@ static int __nf_conncount_add(struct net *net,
                 /* connections from localhost are confirmed almost 
instantly,
                  * check if there has been a reply
                  */
-               if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+               if (skb->skb_iif != 1) {
                         err = -EEXIST;
                         goto out_put;
                 }

I will send a V2 and ask for testing from Michal if possible.

Thanks,
Fernando.

