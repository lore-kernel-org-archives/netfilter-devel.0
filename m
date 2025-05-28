Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60B06A33B
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 11:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748431924; cv=none; b=EvEDbHB8DgFj2vRDeW/KSRFKCOeodivttm7uGopo85uVGmw19q0eZUvK2jCCw7ki6wwPUCQfcQHdGe1kUSLLkCO+qT9WqVYqNPUMloWWpT7XyMNPUxvcrMy0KIq5yYNMh9WAFCm1EM3olUTNFZsOa3Vs91PFq+G1jIlv6hbdn7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748431924; c=relaxed/simple;
	bh=uyawV61hb1kE1saQVPXk2D6GpWbLz9qnzAyWOWIZRUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mEZ/A7tNVnKzFuHxZz8cK5kCA4QkuT7VHb+4N+i/glB2eCYwf3KJjFSLI2KQYa4Kxs65YzHRNGAqsmRxEJcmSbJaMd7gE9pKRm13bpZsy2bsW8zRTmpWlPxI70Eqe5UGZwILvdqub3wqFbJY3DS0jSi4z6b1ksUg7y4NAhoDTYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QZvyyKWD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=B795IaA3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QZvyyKWD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=B795IaA3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QZvyyKWD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="B795IaA3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QZvyyKWD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="B795IaA3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A3E121F79C;
	Wed, 28 May 2025 11:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748431913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2zq4tdrEIH+OyZxxBJSA7Ofzh6Zh9nba7toqZhnhYFA=;
	b=QZvyyKWDNA/SQ8i0TydZTJN1K08Yc9UJlvW4kVahwFB5bmAUrSc3pMwgKjUoX16JnHGf2R
	dJG8pg6pWmQuItoEH/lAdbNvUSCTRLB3y4I2viujEr99S/8X/B2+ba0rtXK7NfHBA5nbps
	eABttiVigattql2Nt99HjR65WngFW3A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748431913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2zq4tdrEIH+OyZxxBJSA7Ofzh6Zh9nba7toqZhnhYFA=;
	b=B795IaA3gBsP2kz05p59C2K7V8HNMhgl5Wamk1sJ8kGiR8sWDWmFFVKQd04c8tpjT6Kck3
	VKunqcKO8TmLo8DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748431913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2zq4tdrEIH+OyZxxBJSA7Ofzh6Zh9nba7toqZhnhYFA=;
	b=QZvyyKWDNA/SQ8i0TydZTJN1K08Yc9UJlvW4kVahwFB5bmAUrSc3pMwgKjUoX16JnHGf2R
	dJG8pg6pWmQuItoEH/lAdbNvUSCTRLB3y4I2viujEr99S/8X/B2+ba0rtXK7NfHBA5nbps
	eABttiVigattql2Nt99HjR65WngFW3A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748431913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2zq4tdrEIH+OyZxxBJSA7Ofzh6Zh9nba7toqZhnhYFA=;
	b=B795IaA3gBsP2kz05p59C2K7V8HNMhgl5Wamk1sJ8kGiR8sWDWmFFVKQd04c8tpjT6Kck3
	VKunqcKO8TmLo8DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 67B28136E3;
	Wed, 28 May 2025 11:31:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id exE3Fin0NmhlEwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 28 May 2025 11:31:53 +0000
Message-ID: <59084463-eefa-4b75-aaab-8214f13a39a1@suse.de>
Date: Wed, 28 May 2025 13:31:36 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20250527193420.9860-1-fmancera@suse.de>
 <20250527193420.9860-2-fmancera@suse.de> <aDbrpG4vuB6A_n1z@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aDbrpG4vuB6A_n1z@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 5/28/25 12:55 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> +	case NFTNL_OBJ_TUNNEL_GENEVE_OPTS:
>> +		geneve = malloc(sizeof(struct nftnl_obj_tunnel_geneve));
>> +		memcpy(geneve, data, data_len);
>> +
>> +		if (!(e->flags & (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_OPTS)))
>> +			INIT_LIST_HEAD(&tun->u.tun_geneve);
>> +
>> +		list_add_tail(&geneve->list, &tun->u.tun_geneve);
>> +		break;
> 
> I missed this earlier. Do we have precedence for this?
> 
> AFAIK for all existing setters, if you do
> 
> nftnl_foo_set_data(obj, OPT_FOO, &d, len);
> nftnl_foo_set_data(obj, OPT_FOO, &d2, len2);
> 
> Then d2 replaces d, it doesn't silently append/add to the
> object.
> 

Good catch. I thought yes, but no, there is no precedence for this. 
Other similar situations expose a dedicated function to append items to 
a list.

So we should do the same thing on this situation.
