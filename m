Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906F03655C7
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 08:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534964; cv=none; b=tP6q1bBZGOKy2m30sZfNZwiEwFRxOsWg2gZGMYQsdwRkvIMMk2V5GfQAr/9/rWnorQIjfleu0DdU98MGZ8xBgtGTNZTFw8Uj6L3wbx6EjdCb8V0vRSCkuX3kB84+MPCQNMVSmcpytKWnn8ECD91JCie6CEv/UkVxa9HAUB8fh9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534964; c=relaxed/simple;
	bh=miKPawhSDtCHBCKXLRdYFq+BJGcurUhblCOCkIJ9OSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DR59o9Eke+aY9xeJK1T+cN1a83HBA3RsCDOVRs5d5kJMH3qzZxgAhb1ZJOMoiipplGKu6Qh3S+wx7r4W486UuCbdJ+Ewa9d1+w7Nmq/vWjwVZP2t3WzU8RLM3eP8Kf0fkysLcpOzZfn5TIWdMLHM//B4g4xiihdSZhXqh9nUUi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC7F121BB1;
	Fri,  9 Oct 2026 08:36:01 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1B3D91326D;
	Fri,  9 Oct 2026 08:36:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QWK9M3CnyGpZIQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 09 Oct 2026 08:36:01 +0000
Message-ID: <06fe96ca-ef3e-4a15-9d11-d188164291a4@suse.de>
Date: Fri, 9 Oct 2026 10:34:55 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: xt_dccp: handle reserved options as
 single-byte
To: tjdqudcks0424@naver.com, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <20261008183814.10521-1-tjdqudcks0424@naver.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261008183814.10521-1-tjdqudcks0424@naver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spamd-Result: default: False [0.00 / 50.00]
X-Spam-Score: 0.00

On 10/8/26 8:38 PM, tjdqudcks0424@naver.com wrote:
> From: Sung Byeongchan <tjdqudcks0424@naver.com>
> 
> The DCCP UAPI defines option numbers 3 through 31 as reserved.  Like
> Padding and Mandatory, these options occupy one byte.  dccp_find_option()
> only treats values below 2 as single-byte and interprets the byte after a
> reserved option as a TLV length.
> 
> This can skip a later option and invert an XT_DCCP_OPTION rule result.  A
> local production-hook fixture installed the same DROP rule for IPv4 and
> IPv6.  In three fresh boots per kernel, a target-only packet was dropped
> 20/20 times, while adding reserved option 3 before the same target let
> 20/20 packets reach the protected receiver.  The fixed kernel dropped all
> trigger packets in three fresh boots and preserved the normal controls.
> 
> Treat every option up to DCCPO_MAX_RESERVED as single-byte, matching the
> protocol definition.  Triggering requires
> CONFIG_NETFILTER_XTABLES_LEGACY, CONFIG_NETFILTER_XT_MATCH_DCCP, an
> option-based rule, and remote protocol-33 reachability.  The touched source
> is unchanged at 0c2669a9f4a1d607e7591ae50ccf3c432a0aff08, where the patch
> applies and builds cleanly.
> 
> The demonstrated impact is a conditional remote filter-verdict bypass.
> No memory-safety violation, information disclosure, RCE, or LPE was
> demonstrated.  The source reproducer and complete logs are available on
> request and are not included in this public report.
> 
> OpenAI Codex assisted source inspection, test design, patch drafting, and
> evidence organization.
> 
> Fixes: 1d3de414eb20 ("[NETFILTER]: New iptables DCCP protocol header match")
> Assisted-by: LLM
> Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>

The commit message is a bit too verbose and I doubt this has been found 
in a real environment. This might be a bit too extreme from my side but 
can we ditch DCCP support?

DCCP socket infrastructure was deprecated in 2023 at commit b144fcaf46d4 
("dccp: Print deprecation notice.") and removed more than a year ago in 
2025 at commit 2a63dd0edf38 ("net: Retire DCCP socket.").

I don't think someone is actively matching DCCP traffic as a middlebox.. 
what do you think?
