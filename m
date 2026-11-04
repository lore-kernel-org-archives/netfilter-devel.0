Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793795484;
	b=F5nDodP6wsj0XXv+5sYP619gdvrfmeaNLZwzBZUNuC4HlQAJ0QhSvfVqthOsLE4ISbL5
	 DHzOct9bGgaBmdVynsJirPjnVwquALO6Way8/XarRzxiK/LJGbEGJTu4ggJjqgTesIkqa
	 ir1UyD1490B5PToYK4wbNwNAKE0mF3sp6YsxipvDkkTMfFvA41sX6O3aRoYnLHUkRkz0k
	 yZj+SskGiu88QRuTXSWotLWAiJcipxEBzCXOPcn0/bvbb80kGKwDJ8Nwz8Kef/gChFJk/
	 vN2dmPk7YbSAbQCmRNBm7w9KBo8pX+a7rBOF9+ecxgyY99SmLxF/4iFf9h1yN1doThQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793795484;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=/kvxBM+Lv9we6pmJ6d2ZWfsGgMd0Gn4BF0aFVCz7eLc=;
	b=rHLEJn+dHNzHboyD2lCJUdnwZnTqnnIuaDIVOhqG1CISWt3toTipFSLqnDJXvybbe0l1
	 W5fJz/J/tQmBEw0jl+Ya20JjHD9IGbEIQNAT77DVfQvieQaO41CWOLpvH125N7U2ETvKF
	 EwQfM3xl40yiVetjfKCnfDkj9bks1rh/ZbzGjGPWcynfRWGCvadAMk3A/FKhYSCAtA3nb
	 ZM7PHT2/o/z/TqDUC/5PQHHxy07Yf9qThRgjDtj3zRO+TVqRw2C265NCn/XsV0en61xaL
	 DbWvIEU0LM6K+i7nZHhQy8tCrfO1+isJnKl1NWccaKWUsJ/6DyWzyaGlGCz0FJTDA3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=D9KrmJaq;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cso50yqN;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=D9KrmJaq;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cso50yqN;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E754606A31B
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 12:31:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E754606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=D9KrmJaq;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cso50yqN;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=D9KrmJaq;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cso50yqN
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AB99A1F787;
	Wed,  4 Nov 2026 12:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793795481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/kvxBM+Lv9we6pmJ6d2ZWfsGgMd0Gn4BF0aFVCz7eLc=;
	b=D9KrmJaqP9+NzWo9XjEPh5FnKw+7m/uNwrnPTkLJLrXzk84Sre0Vb2l44hs/g7+XYrnWEC
	xn2/ZUGSOyT2mFbKtBlupIwfY0ubwyrKrakvGu6iwUPnv1JCxA0luLrbhhAfX2L7Ug6fJw
	Hzub3o15T7SaJpXQbpxueoD5p+dNV4g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793795481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/kvxBM+Lv9we6pmJ6d2ZWfsGgMd0Gn4BF0aFVCz7eLc=;
	b=cso50yqN4u+pt0xZmijYmHgU3F1236d7fTra0y+ldyhGnUDuPolCzfcZnpXUUvvloE6ViV
	6sRRDIgsHoXyWJCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793795481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/kvxBM+Lv9we6pmJ6d2ZWfsGgMd0Gn4BF0aFVCz7eLc=;
	b=D9KrmJaqP9+NzWo9XjEPh5FnKw+7m/uNwrnPTkLJLrXzk84Sre0Vb2l44hs/g7+XYrnWEC
	xn2/ZUGSOyT2mFbKtBlupIwfY0ubwyrKrakvGu6iwUPnv1JCxA0luLrbhhAfX2L7Ug6fJw
	Hzub3o15T7SaJpXQbpxueoD5p+dNV4g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793795481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/kvxBM+Lv9we6pmJ6d2ZWfsGgMd0Gn4BF0aFVCz7eLc=;
	b=cso50yqN4u+pt0xZmijYmHgU3F1236d7fTra0y+ldyhGnUDuPolCzfcZnpXUUvvloE6ViV
	6sRRDIgsHoXyWJCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 667B8134F0;
	Wed,  4 Nov 2026 12:31:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kXxLDpkl62owcgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 04 Nov 2026 12:31:21 +0000
Message-ID: <0993c772-c6a4-4634-952a-012dd3c4f0be@suse.de>
Date: Wed, 4 Nov 2026 13:30:03 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf 1/4] netfilter: nf_log: remove dead ARPHRD_SIT handling
 from MAC/HW header logging
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20261030154433.13601-1-fw@strlen.de>
 <20261030154433.13601-2-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261030154433.13601-2-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.28 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-0.99)[-0.990];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,strlen.de:email]
X-Spam-Score: -13.28

On 10/30/26 4:44 PM, Florian Westphal wrote:
> dump_mac_header() in nf_log_syslog.c and the HWHEADER dump in
> nfnetlink_log.c special-case ARPHRD_SIT devices by backing the header
> pointer up by ETH_HLEN before dumping dev->hard_header_len bytes, on
> the assumption that a SIT tunnel's "hard header" covers the
> underlying device's real Ethernet header plus the tunnel's IPv4
> header.
> 
> That is no longer the case: ever sice commit 8ef9ba4d6666 ("IPv6: Set

s/sice/since

> SIT tunnel hard_header_len to zero"), dev->hard_header_len is 0 and
> these branches are dead code.
> 
> No bug report in 6 years, so lets remove those branches.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!

> ---
>   net/netfilter/nf_log_syslog.c | 23 +++--------------------
>   net/netfilter/nfnetlink_log.c |  6 +-----
>   2 files changed, 4 insertions(+), 25 deletions(-)
> 
> diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
> index c3fd398ffcd7..3ff5a49a1c8d 100644
> --- a/net/netfilter/nf_log_syslog.c
> +++ b/net/netfilter/nf_log_syslog.c
> @@ -820,26 +820,9 @@ static void dump_mac_header(struct nf_log_buf *m,
>   		const unsigned char *p = skb_mac_header(skb);
>   		unsigned int i;
>   
> -		if (dev->type == ARPHRD_SIT) {
> -			p -= ETH_HLEN;
> -
> -			if (p < skb->head)
> -				p = NULL;
> -		}
> -
> -		if (p) {
> -			nf_log_buf_add(m, "%02x", *p++);
> -			for (i = 1; i < dev->hard_header_len; i++)
> -				nf_log_buf_add(m, ":%02x", *p++);
> -		}
> -
> -		if (dev->type == ARPHRD_SIT) {
> -			const struct iphdr *iph =
> -				(struct iphdr *)skb_mac_header(skb);
> -
> -			nf_log_buf_add(m, " TUNNEL=%pI4->%pI4", &iph->saddr,
> -				       &iph->daddr);
> -		}
> +		nf_log_buf_add(m, "%02x", *p++);
> +		for (i = 1; i < dev->hard_header_len; i++)
> +			nf_log_buf_add(m, ":%02x", *p++);
>   	}
>   	nf_log_buf_add(m, " ");
>   }
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index d923f2cb1398..0b590c117f4c 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -610,11 +610,7 @@ __build_packet_message(struct nfnl_log_net *log,
>   
>   		hwhdrp = skb_mac_header(skb);
>   
> -		if (skb->dev->type == ARPHRD_SIT)
> -			hwhdrp -= ETH_HLEN;
> -
> -		if (hwhdrp >= skb->head &&
> -		    nla_put(inst->skb, NFULA_HWHEADER,
> +		if (nla_put(inst->skb, NFULA_HWHEADER,
>   			    skb->dev->hard_header_len, hwhdrp))
>   			goto nla_put_failure;
>   	}

