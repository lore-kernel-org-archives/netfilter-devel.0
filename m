Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0737D3515DF
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 15:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791559828; cv=none; b=ufTrUNT/q60YGQRNADYl22KiQBYUf319NzXaLr6aPKmCswVkTcQ4fenVsUnHfA9qBiBIVCoOkMiNRU9/NL5AnvvuO2L0jbFbcWFbFG9b5CiFpPvbPdGEDOiKqOaRihgDMqc9WqdD6R+L34NK8oSwnrczkvaOhAHIQEMdFrqonwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791559828; c=relaxed/simple;
	bh=5VVYYN/cShBwlv3ANVA3gfr5EYHCtLEkhWFV9gLM5tI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ICiQU21AgIpJCTqFSiq+DXwFzsxGkex+wtqaqKWtQkMHxqyoN5zl0lSCOrS2yhFOBI0Av+KKWqy7TP3GQflM/IxEcwYEnBiTTItKXBBEEQTPcLi9hkb48Bwk3q0P50u0qeUV5GvXqxTtNXmkRQn8dH2yZpC4Kmo3GGFP9dBYaa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D3201F7D2;
	Fri,  9 Oct 2026 15:30:25 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B04E81326D;
	Fri,  9 Oct 2026 15:30:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sjCQH5AIyWovZQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 09 Oct 2026 15:30:24 +0000
Message-ID: <29da46f0-3cac-4edb-9f0f-01dcd5f00b93@suse.de>
Date: Fri, 9 Oct 2026 17:29:26 +0200
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
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 1D3201F7D2
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
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

I think these two paragraphs do not belong to the commit message. Could 
you drop them?

I think this should go through nf-next tree instead. Could you please 
add nf-next prefix in your v2?

Other than that, the patch looks good to me.

Thanks,
Fernando.

> Fixes: 1d3de414eb20 ("[NETFILTER]: New iptables DCCP protocol header match")
> Assisted-by: LLM
> Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
> ---
>   net/netfilter/xt_dccp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
> index 3db81e041af9b..23a4e3e8df7de 100644
> --- a/net/netfilter/xt_dccp.c
> +++ b/net/netfilter/xt_dccp.c
> @@ -62,7 +62,7 @@ dccp_find_option(u_int8_t option,
>   			return true;
>   		}
>   
> -		if (op[i] < 2 || i == optlen - 1)
> +		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1)
>   			i++;
>   		else
>   			i += op[i + 1] ? : 1;

