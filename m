Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E484DE702
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 12:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550228; cv=none; b=TnMDceGgNatMluPohwpmTFWe/DwQM56aG9fSnEG9HeXMbEr8qCyP96WPHjZIWX17FqiEKYKuA55zylrt49SUyJn32qjpMzxKdH62Gw3L+AFF5FbDuSVV45+F/i8L3GAhKfM1P44IFm9m8T02t6y1s5i0+MHjIcuTGhWLtdf4STE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550228; c=relaxed/simple;
	bh=Bwt8dP8Jgc7j4lvIQEndJFx7yi1qnty3lkI0Z3ymbxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XDi5EH9cIFu7ha0vY95dq5RTr9sQbhWHttIZD4jNqgW0fd4nBtygRcbz5HO9NHxwSgloX9XVCyh49gO+9vMuhP/qTfwfE4HWkOcn4wRV7oNQn2eLNCuZC/8M6Rrt+PFI8CQG28Xqng58QE89gB33plrcCT6DCHHJc8i7MflnLiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4FD951F7CE;
	Fri,  9 Oct 2026 12:50:16 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C06FF1326D;
	Fri,  9 Oct 2026 12:50:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M7CfIgfjyGphNwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 09 Oct 2026 12:50:15 +0000
Message-ID: <31b57c78-52ad-4ee6-a232-c5daf3a6a906@suse.de>
Date: Fri, 9 Oct 2026 14:49:02 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: xt_dccp: handle reserved options as
 single-byte
To: Florian Westphal <fw@strlen.de>, =?UTF-8?B?7ISx67OR7LCs?=
 <tjdqudcks0424@naver.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20261008183814.10521-1-tjdqudcks0424@naver.com>
 <06fe96ca-ef3e-4a15-9d11-d188164291a4@suse.de>
 <af8485bf933f5620813e12cdfe68a080@cweb014.nm> <asjW0HXAbyCOkcjw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <asjW0HXAbyCOkcjw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spam-Flag: NO
X-Spam-Score: 0.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spamd-Result: default: False [0.00 / 50.00]

On 10/9/26 1:58 PM, Florian Westphal wrote:
> 성병찬 <tjdqudcks0424@naver.com> wrote:
>>
>> -----Original Message-----
>> From: "Fernando Fernandez Mancera"<fmancera@suse.de>
>> To: <tjdqudcks0424@naver.com>; "Pablo Neira Ayuso"<pablo@netfilter.org>; "Florian Westphal"<fw@strlen.de>;
>> Cc: <netfilter-devel@vger.kernel.org>;
>> Sent: 2026-10-09 (금) 17:34:55 (GMT+09:00)
>> Subject: Re: [PATCH] netfilter: xt_dccp: handle reserved options as single-byte
>>
>> On 10/8/26 8:38 PM, tjdqudcks0424@naver.com wrote:
>>> From: Sung Byeongchan <tjdqudcks0424@naver.com>
>>>
>>> The DCCP UAPI defines option numbers 3 through 31 as reserved.  Like
>>> Padding and Mandatory, these options occupy one byte.  dccp_find_option()
>>> only treats values below 2 as single-byte and interprets the byte after a
>>> reserved option as a TLV length.
>>>
>>> This can skip a later option and invert an XT_DCCP_OPTION rule result.  A
>>> local production-hook fixture installed the same DROP rule for IPv4 and
>>> IPv6.  In three fresh boots per kernel, a target-only packet was dropped
>>> 20/20 times, while adding reserved option 3 before the same target let
>>> 20/20 packets reach the protected receiver.  The fixed kernel dropped all
>>> trigger packets in three fresh boots and preserved the normal controls.
>>>
>>> Treat every option up to DCCPO_MAX_RESERVED as single-byte, matching the
>>> protocol definition.  Triggering requires
>>> CONFIG_NETFILTER_XTABLES_LEGACY, CONFIG_NETFILTER_XT_MATCH_DCCP, an
>>> option-based rule, and remote protocol-33 reachability.  The touched source
>>> is unchanged at 0c2669a9f4a1d607e7591ae50ccf3c432a0aff08, where the patch
>>> applies and builds cleanly.
>>>
>>> The demonstrated impact is a conditional remote filter-verdict bypass.
>>> No memory-safety violation, information disclosure, RCE, or LPE was
>>> demonstrated.  The source reproducer and complete logs are available on
>>> request and are not included in this public report.
>>>
>>> OpenAI Codex assisted source inspection, test design, patch drafting, and
>>> evidence organization.
>>>
>>> Fixes: 1d3de414eb20 ("[NETFILTER]: New iptables DCCP protocol header match")
>>> Assisted-by: LLM
>>> Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
>>
>> The commit message is a bit too verbose and I doubt this has been found
>> in a real environment. This might be a bit too extreme from my side but
>> can we ditch DCCP support?
> 
> See: 606bd17ef0de ("netfilter: add deprecation warning for dccp support")
> 

Ah right. Thanks Florian, then I will patiently wait until 2027.

>> Pablo, Florian, what direction would you prefer?
> 
> Well, you already made a fix and it makes more sense from -stable PoV.
> So I'd say: Fix and then zap this thing early in 2027.

Let's go with the fix then.

Thanks,
Fernando.

