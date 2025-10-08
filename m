Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5F6241663
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 07:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759910334; cv=none; b=XY8uDBMf1jEavwiQRUXzNX9nlJx1mHn0LgXb7cKrhTBxHdTuZBMbtd8aSBMP2tefJcK8A6V1eII9B/endz7XyiSLkuZvo2j+E9xiWMrFY/mlBpPvqAjqhZBugASfjVEQqTxjY1ZknJwEilIwkaD1EsoT/vP3+yZneiVdSOCYkYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759910334; c=relaxed/simple;
	bh=3B50EkNh3caIetFB3X8iuQeFh7a7ddeDwYQY8f5wIyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0PwZRSDjiC5q8q5zMqj+jZCTIAc26p2lNy3kZwI7xMFZln5NGEdkA4/joVpZNPyc1bYRHe9bKxmCRtBqolR55W/rQV0L8HQvun8NVSyAHgv+uB+RkrVryCF4joxYhdGPJHAt1p5/IOlekOtbAt47Mo+v8eQX0sK1/feO0qz3uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vczMakeg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=55t6ErDF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vczMakeg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=55t6ErDF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vczMakeg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="55t6ErDF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vczMakeg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="55t6ErDF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A0A72336A9;
	Wed,  8 Oct 2025 07:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759910330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bOHe95iUbSs/Mg0ie0mlCXowpwL9ZtLRq7riaTI8GqE=;
	b=vczMakeg3LgkeZhSlVpsdAgOORYU3lIXL1YW9l94sgStKTji7JRSGjubc2hEQNrJKsw7bU
	btUSUjwYvlzoDw0vnmX1RbuRQMoG8qcab4OVr0tl6ChoB+VbEdIhLnZLZU9drFrS+AhPIr
	E7F8UyvHsvM0vCO3UrbJeXaiVorFBZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759910330;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bOHe95iUbSs/Mg0ie0mlCXowpwL9ZtLRq7riaTI8GqE=;
	b=55t6ErDFRSdR6uMbjUjmbUAVQdKfb69SEJI/VjSdOUD//6VTvFsiBDH/VEkWtv7JL9e4vo
	D64CbXMAUvNNeuBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759910330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bOHe95iUbSs/Mg0ie0mlCXowpwL9ZtLRq7riaTI8GqE=;
	b=vczMakeg3LgkeZhSlVpsdAgOORYU3lIXL1YW9l94sgStKTji7JRSGjubc2hEQNrJKsw7bU
	btUSUjwYvlzoDw0vnmX1RbuRQMoG8qcab4OVr0tl6ChoB+VbEdIhLnZLZU9drFrS+AhPIr
	E7F8UyvHsvM0vCO3UrbJeXaiVorFBZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759910330;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bOHe95iUbSs/Mg0ie0mlCXowpwL9ZtLRq7riaTI8GqE=;
	b=55t6ErDFRSdR6uMbjUjmbUAVQdKfb69SEJI/VjSdOUD//6VTvFsiBDH/VEkWtv7JL9e4vo
	D64CbXMAUvNNeuBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52BA813A3D;
	Wed,  8 Oct 2025 07:58:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MvE+EboZ5miEYAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 08 Oct 2025 07:58:50 +0000
Message-ID: <bb299732-dafb-48f8-a353-b783cc132fa6@suse.de>
Date: Wed, 8 Oct 2025 09:58:49 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nf_tables: validate objref and objrefmap
 expressions
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
 Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
References: <20251004230424.3611-1-fmancera@suse.de>
 <aOV97sV5DA1z1pv9@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aOV97sV5DA1z1pv9@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30



On 10/7/25 10:54 PM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Sun, Oct 05, 2025 at 01:04:24AM +0200, Fernando Fernandez Mancera wrote:
> [...]
>> To avoid such situations, implement objref and objrefmap expression
>> validate function. Currently, only NFT_OBJECT_SYNPROXY object type
>> requires validation. This will also handle a jump to a chain using a
>> synproxy object from the OUTPUT hook.
>>
>> Now when trying to reference a synproxy object in the OUTPUT hook, nft
>> will produce the following error:
>>
>> synproxy_crash.nft:11:3-26: Error: Could not process rule: Operation not supported
>> 		synproxy name mysynproxy
>> 		^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Object maps only store one type of object, ie. all objects are of the
> same type.
> 
>          if (nla[NFTA_SET_OBJ_TYPE] != NULL) {
>                  if (!(flags & NFT_SET_OBJECT))
>                          return -EINVAL;
> 
>                  desc.objtype = ntohl(nla_get_be32(nla[NFTA_SET_OBJ_TYPE]));
>                  if (desc.objtype == NFT_OBJECT_UNSPEC ||
>                      desc.objtype > NFT_OBJECT_MAX)
>                          return -EOPNOTSUPP;
>          } else if (flags & NFT_SET_OBJECT)
>                  return -EINVAL;
>          else
>                  desc.objtype = NFT_OBJECT_UNSPEC;
> 
> I think it should be possible to simplify this patch: From objref, you
> could check if map is of NFT_OBJECT_SYNPROXY type, then check if the
> right hook type is used.
> 

Ah right, it makes sense. Thank you, let me send a V2.

> Thanks.
> 

