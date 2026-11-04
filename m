Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793800999;
	b=GVXxVIQGfvloFW30fCFNkWqm0AjEv/1SdQl9zdP1Or0re9qRjqTiPpBxONoIeJPpLIOj
	 G4e37dFKOaP3GACuU9rYJpewJjoIGr8O7F8HjqsW610XJbuJXQWAZmgu5JqZPsg2efUz1
	 bObIkzNdWNE6UFigA5onO4EMJICK6dcoQE+XTvDYOFDDUqYprClsonD/empFxDOo6Ffyf
	 x5dePDWGYuWlDM3CkkP6oFdJy0k82oLBYlVYRp0oCiOA4AkYn4GaQRrYhFHMKiCdtdFEQ
	 IwULzO98HhiSbymTm/JBN37egBZjok8gyyRp6V1I1yC9jBGntc5yNANGe2HJ1HlTkSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793800999;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=apRl2El7nP7LcmtflFE2Yy+x8BAepN87OjpasQuAWPU=;
	b=kKiLwnTPkDBxzMWkm33sIqtN5tsCMJhK6OVL3zAFSwPqXt53rzq69Z8ihRqQbwW7NkLG
	 TJJKESwjsn1pQWkrRp5C1O8ipspFhoCAA5uKw2srVVi4GgkMgb88HfHpng5MoErAIedcK
	 ggLgmo+iQQcgMJj/vkxs5dYXSzLHNlSgbpLCR/H7oUTHH/RbTrL9lcw7TjAaaleUYoxiN
	 Na68VOGwYQB83Mu2rgRH0euomfCU5lDX39e1BzBjluHUNzayBV65mOsCJRY5AvOwip3mt
	 Y59F1s1sFPj3PWx7gCLrHL7dAuYCwq1Fm5DDrT5nkMFpTBQj2rvTnY85+ogu8HDFU7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="vOPCBo/G";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=uiCXNTsi;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=feAyLddu;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RQ9NB09b;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D979606A31B
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 14:03:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D979606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vOPCBo/G;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=uiCXNTsi;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=feAyLddu;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RQ9NB09b
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1BB421F7DF;
	Wed,  4 Nov 2026 14:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793800996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=apRl2El7nP7LcmtflFE2Yy+x8BAepN87OjpasQuAWPU=;
	b=vOPCBo/G96RwGaBSUQNSJ5zmvTfDMI7umu7u5rbP3wxTiUDwJhZ/MMWOUuOjvB8ehodcmv
	CgVtl+9FJa0SoUPHHSib+xIoc+awhUtBKxwvafYP8sZjpsGUnybwtx0GMSxfDFSsHGrK3A
	CUfGnHsSLk+RDyJOaI2TOkjeLRcS0vo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793800996;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=apRl2El7nP7LcmtflFE2Yy+x8BAepN87OjpasQuAWPU=;
	b=uiCXNTsiNUoB5Qn8Nze5S/Kakk19X6Y2BS7mXuCvMeQQsfyi0NDFz0co0Cz4MLbOu2wf10
	P0STN3ftP6XfBvCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793800995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=apRl2El7nP7LcmtflFE2Yy+x8BAepN87OjpasQuAWPU=;
	b=feAyLdduaqsaWotYNkPClDJRHNGr/BPh9JlOcNO6il714m+Zt5AYAEdqRLzaS0vtmlrmh6
	K/gGVWZaarvDLl4x8lkfZjlcEpdF6e89N6YvM78O9mEsw1bcEYnq4SC8Nm3U3c9QOkbXlg
	+itJsqB47LL4XtjFvZkvTrNCCbDDLS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793800995;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=apRl2El7nP7LcmtflFE2Yy+x8BAepN87OjpasQuAWPU=;
	b=RQ9NB09bSSeikdWJPCC+STWC1G5J5qtIA+NZk3z6YhvgbuH2/a8qzLqJayKG3aZ3yXfDNK
	ad5S8sxhb6Ghx2Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A529F134F0;
	Wed,  4 Nov 2026 14:03:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SqykGyI762r9UgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 04 Nov 2026 14:03:14 +0000
Message-ID: <dedf7348-3dcb-4748-8cde-90b27c36c39a@suse.de>
Date: Wed, 4 Nov 2026 15:02:00 +0100
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
Subject: Re: [PATCH nf 2/4] netfilter: nf_log_syslog: fix MAC header dump to
 use real header length
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20261030154433.13601-1-fw@strlen.de>
 <20261030154433.13601-3-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261030154433.13601-3-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.28 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-0.99)[-0.990];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,strlen.de:email]
X-Spam-Score: -13.28
X-Spam-Level: 
X-Spam-Flag: NO

On 10/30/26 4:44 PM, Florian Westphal wrote:
> old code unconditionally iterated dev->hard_header_len bytes, assuming
> the SKB's MAC header is always exactly that long.
> 
> If the actual mac header in the packet is smaller, the loop reads past
> the MAC and logs ip/ipv6 header as if it was part of the address.
> 
> Use skb_mac_header_len() as the base length, then clamp the result to
> dev->hard_header_len so we never read beyond what the
> device actually uses for its hard header, even if mac header was
> mangled.
> 
> LLM finding, no bug was ever reported about this.
> 
> Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   net/netfilter/nf_log_syslog.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
> index 3ff5a49a1c8d..332fe47fd109 100644
> --- a/net/netfilter/nf_log_syslog.c
> +++ b/net/netfilter/nf_log_syslog.c
> @@ -815,14 +815,19 @@ static void dump_mac_header(struct nf_log_buf *m,
>   
>   fallback:
>   	nf_log_buf_add(m, "MAC=");
> -	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
> -	    skb_mac_header_len(skb) != 0) {
> +	if (dev->hard_header_len && skb_mac_header_was_set(skb)) {
> +		unsigned int mac_len = skb_mac_header_len(skb);
>   		const unsigned char *p = skb_mac_header(skb);
>   		unsigned int i;
>   
> -		nf_log_buf_add(m, "%02x", *p++);
> -		for (i = 1; i < dev->hard_header_len; i++)
> -			nf_log_buf_add(m, ":%02x", *p++);
> +		if (mac_len > dev->hard_header_len)
> +			mac_len = dev->hard_header_len;
> +
> +		if (mac_len) {
> +			nf_log_buf_add(m, "%02x", *p++);
> +			for (i = 1; i < mac_len; i++)
> +				nf_log_buf_add(m, ":%02x", *p++);
> +		}
>   	}
>   	nf_log_buf_add(m, " ");
>   }

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
