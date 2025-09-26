Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0702EF673
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 10:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758882443; cv=none; b=H9BNliOCiOUbqB7CjMWzM2iRrFdwNttq+LspPN7/eDYU28sXgZnSz4Qt/oI2LdqFrfupl/M0R50CmDwAyJpmJlfi/UPQojZcR7GpLA+AlWeTUUacIGLGGYX1/7s66coUS5oQRC1j8UQTwWM/7CmXxanLJgQ0/oqJ+fXZdQsdTUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758882443; c=relaxed/simple;
	bh=sK0qPmf5GVSYjnPz+iq1tckidYnZ2B6E2Djx9JEbB6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BjQsRr37+pck0TTzqChKwgvAmacemqlk7CiODzVojstX492D0tCA4cOUTE5pQnRj0RtjLscsN2EcIo5infad8CmiMEXAkhq+E2UpghNAp38QDYoJI3MWGINw3Uu/gS8Lav9MMg1T8YpKMma7EGFnxYHrUnXb04I4Z2L08NWuHj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JTv3juLe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iIrQ9Co2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JTv3juLe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iIrQ9Co2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JTv3juLe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iIrQ9Co2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JTv3juLe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iIrQ9Co2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C384C240A4;
	Fri, 26 Sep 2025 10:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758882438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulHV9pM7nHJ9FjCDp02DBwVDyH6TR8zv5clWBYZgER8=;
	b=JTv3juLebDsSNgtp6YZ6hH/t7Dvgx/kwN8cPMCXfQIHxdap5ZeMDuvejXS8Aj9H1IE2jfV
	CZhwRGxE1it+DcmOCs7mHtXZcRZJ5u75bpJVETnPJVKjeY49rKN58rr1qdHb1oQElg9Yft
	CpeB4tDzCd7a6W5rz/GiOnukGrYJDwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758882438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulHV9pM7nHJ9FjCDp02DBwVDyH6TR8zv5clWBYZgER8=;
	b=iIrQ9Co22Lxj5et3kqwEsJAnSTOwIoICXaa6PcPPj+1zMakxGggHXWFlrfPP4oiRpUYMXk
	kuInVZBo6637PMAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JTv3juLe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iIrQ9Co2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758882438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulHV9pM7nHJ9FjCDp02DBwVDyH6TR8zv5clWBYZgER8=;
	b=JTv3juLebDsSNgtp6YZ6hH/t7Dvgx/kwN8cPMCXfQIHxdap5ZeMDuvejXS8Aj9H1IE2jfV
	CZhwRGxE1it+DcmOCs7mHtXZcRZJ5u75bpJVETnPJVKjeY49rKN58rr1qdHb1oQElg9Yft
	CpeB4tDzCd7a6W5rz/GiOnukGrYJDwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758882438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulHV9pM7nHJ9FjCDp02DBwVDyH6TR8zv5clWBYZgER8=;
	b=iIrQ9Co22Lxj5et3kqwEsJAnSTOwIoICXaa6PcPPj+1zMakxGggHXWFlrfPP4oiRpUYMXk
	kuInVZBo6637PMAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 912601373E;
	Fri, 26 Sep 2025 10:27:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CQXcIIZq1mh9HQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 26 Sep 2025 10:27:18 +0000
Message-ID: <6dae9b49-e2e3-4e62-abe7-e46cc2176435@suse.de>
Date: Fri, 26 Sep 2025 12:27:13 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bug: nft -n still shows "resolved" values for iif and oif
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Christoph Anton Mitterer <calestyo@scientia.org>,
 netfilter-devel@vger.kernel.org
References: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>
 <e19bafc0-61c9-47af-afb6-15f886cc4d37@suse.de> <aNVMqSlTNkGFRoPR@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aNVMqSlTNkGFRoPR@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: C384C240A4
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51



On 9/25/25 4:07 PM, Pablo Neira Ayuso wrote:
> On Thu, Sep 25, 2025 at 02:36:15PM +0200, Fernando Fernandez Mancera wrote:
>>
>>
>> On 9/24/25 11:48 PM, Christoph Anton Mitterer wrote:
>>> Hey.
>>>
>>> E.g.:
>>> # nft list ruleset
>>> table inet filter {
>>> 	chain input {
>>> 		type filter hook input priority filter; policy drop;
>>> 		ct state { established, related } accept
>>> 		iif "eth0" accept
>>> 	}
>>> }
>>> #  nft -n list ruleset
>>> table inet filter {
>>> 	chain input {
>>> 		type filter hook input priority 0; policy drop;
>>> 		ct state { 0x2, 0x4 } accept
>>> 		iif "eth0" accept
>>> 	}
>>> }
>>>
>>>
>>> IMO especially for iif/oif, which hardcode the iface ID rather than
>>> name, it would IMO be rather important to show the real value (that is
>>> the ID) and not the resolved one... so that users aren't tricked into
>>> some false sense (when they should actually use [io]ifname.
>>>
>>
>> Hi,
>>
>> AFAICS, the current -n is just a combination of '--numeric-priority
>> --numeric-protocol --numeric-time'. Although, the message displayed when
>> using --help is misleading.
>>
>> -n, --numeric                   Print fully numerical output.
>>
>> I propose two changes:
>>
>> 1. Adjust the description when doing --help
>> 2. Introduce a new "--numeric-interface" which prevents resolving iif or
>> oif.
> 
> I wonder if there is a use-case for this.
> 
>> Another possible solution could be to use --numeric to do not resolve
>> iif/oif but then it would mean we should not resolve ANYTHING as "Print
>> fully numerical output." mentions.
>>
>> What do you think? I can send a patch and test it.
> 
> It would good to check if there are more datatypes that are hiding a
> number value behind to decide what to do with -n/--numeric.
> 

After inspecting the different datatypes:

- verdict (I do not think it makes sense to not resolve this one)
- tchandle (it resolves TC_H_ROOT and TC_H_UNSPEC)
- iif/oif
- ct_label (I think this isn't useful in numeric value)

I do not think there is an use-case for --numeric-interface other than 
just showing the id configured. Maybe we can honor the description of 
--numeric and handle iif/oif and tchandle when using it?
