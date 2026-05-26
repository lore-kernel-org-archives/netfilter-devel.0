Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867013B774A
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 21:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779830330; cv=none; b=Bld0Kt8sHMQjjSVAxQBt9GvZ1YNPAFQcGpBQjzRDX+iPpAalvRdt1ATMkGucRLjlDN9l1Q+NxCIV1tAVoW54q16Qh0NwrfUvyGmyU7gyf0+c7ho9L3h4zTudZzLj+XU/8I209V4l10VHQLJR2ahI6LqZmv0LkPsqtlLEhHAk3bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779830330; c=relaxed/simple;
	bh=6jxMpll5mU6ZiOeypKHPCP3y6tMVW7/wiqAWE1qs/Tg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XCpTxSrUs9aW2T6/9ctx+oZvbc2NqsGUu9KZoho+QrvJ673uk2ySiDBybLG5AmVMfR5CgtCYg1Kow+OXzunBAw3nbKYq8EIOWJzuW5MLQlJHyttHuljNPCLIoqxTDKRNBHLcHYdwo+HH8c8GaovilL0kr8dWwZK6YI9ed/Yr07k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VsuO+OtL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PkbZ4cH5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VsuO+OtL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PkbZ4cH5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VsuO+OtL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PkbZ4cH5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VsuO+OtL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PkbZ4cH5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C47C965AD7;
	Tue, 26 May 2026 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779830320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=09Z963DURIKJC9/kpcza/Rnt2b9EtezyE6kNRU23vUM=;
	b=VsuO+OtL6xG+AHdNyHqcqRPRxGea79vaQjRUo8kQIOAmTPbC3FKQr3wgcDgXf8ptGp1A83
	8pDT4Wpmu6xM4VXZNjMnhY7qD7ApMnyd47YzRWq+XLvznsewG2o2mplxMPRH49znuKhxYn
	LQ65ZBzzHQ7zyRL3TMdc1Gm92PAc6/Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779830320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=09Z963DURIKJC9/kpcza/Rnt2b9EtezyE6kNRU23vUM=;
	b=PkbZ4cH5VkWib3+UTX+hC7btA6ago+yeVRBZel1dKNB+Np6VCoD3P/Q2devwWzf7c+ehFT
	WpQcIKE+3EKRvmAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779830320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=09Z963DURIKJC9/kpcza/Rnt2b9EtezyE6kNRU23vUM=;
	b=VsuO+OtL6xG+AHdNyHqcqRPRxGea79vaQjRUo8kQIOAmTPbC3FKQr3wgcDgXf8ptGp1A83
	8pDT4Wpmu6xM4VXZNjMnhY7qD7ApMnyd47YzRWq+XLvznsewG2o2mplxMPRH49znuKhxYn
	LQ65ZBzzHQ7zyRL3TMdc1Gm92PAc6/Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779830320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=09Z963DURIKJC9/kpcza/Rnt2b9EtezyE6kNRU23vUM=;
	b=PkbZ4cH5VkWib3+UTX+hC7btA6ago+yeVRBZel1dKNB+Np6VCoD3P/Q2devwWzf7c+ehFT
	WpQcIKE+3EKRvmAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A0505A3F0;
	Tue, 26 May 2026 21:18:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lugaGzAOFmo0PwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 26 May 2026 21:18:40 +0000
Message-ID: <e2bcb8bb-a3fa-47be-8251-d1b7a3cc7b71@suse.de>
Date: Tue, 26 May 2026 23:18:35 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5 nf-next v3] netfilter: synproxy: protect
 nf_ct_seqadj_init() with conntrack lock
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
 phil@nwl.cc
References: <20260526141838.4191-1-fmancera@suse.de>
 <20260526141838.4191-5-fmancera@suse.de> <ahW1U9_ESybsuAlv@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ahW1U9_ESybsuAlv@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]

On 5/26/26 4:59 PM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> linux$ git grep nf_ct_seqadj_init
> net/netfilter/nf_conntrack_seqadj.c:int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
> net/netfilter/nf_conntrack_seqadj.c:EXPORT_SYMBOL_GPL(nf_ct_seqadj_init);
> net/netfilter/nf_synproxy_core.c:                       nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
> net/netfilter/nf_synproxy_core.c:               nf_ct_seqadj_init(ct, ctinfo, 0);
> net/netfilter/nf_synproxy_core.c:               nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
> net/netfilter/nf_synproxy_core.c:                       nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
> net/netfilter/nf_synproxy_core.c:               nf_ct_seqadj_init(ct, ctinfo, 0);
> net/netfilter/nf_synproxy_core.c:               nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
> 
> On Tue, May 26, 2026 at 04:18:37PM +0200, Fernando Fernandez Mancera wrote:
>> diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
>> index 5413133a42fa..3e02e252eecc 100644
>> --- a/net/netfilter/nf_synproxy_core.c
>> +++ b/net/netfilter/nf_synproxy_core.c
>> @@ -669,8 +669,10 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
>>   	switch (state->state) {
>>   	case TCP_CONNTRACK_CLOSE:
>>   		if (th->rst && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
>> +			spin_lock_bh(&ct->lock);
>>   			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
>>   						      ntohl(th->seq) + 1);
>> +			spin_unlock_bh(&ct->lock);
>>   			break;
> 
> Maybe add the spin_lock to nf_ct_seqadj_init() given synproxy is the
> only user of this function?
> 

Thanks Pablo, makes a lot of sense.

>>   		}
>>   
> 

