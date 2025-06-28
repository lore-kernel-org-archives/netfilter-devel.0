Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BD617A306;
	Sat, 28 Jun 2025 13:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751117271; cv=none; b=QhW7Zkh2GqoxyKDEhDXSmX0Q1PFqXETpU146NQgbnZXhheoOwCfIzrGYvlMZ/yeCxzUmDBTTmfwS3+fKWVnc9OJ5GbWWWH5oeTftQdvvxqLAEF9Qrm3a2/dnpjmfyI3CzKUqrancLzbfWGclf16/7HU+H9xTa3FI4J8yXewFPMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751117271; c=relaxed/simple;
	bh=K4MWBqbm/TicUDinu2SyQ9On70xTMy0qYpyexyZz/oU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jSvyVzy4NY/LmqkNhq6jBuNSLr0L1HrBslpRR1vY0XLsjbngLgXolnjhzn5vgW9A3n5E4Y0faoLgmE3v41C24J7wdmAIgYKexWYZsDTHPPCyDIVoFFb45jJT1b/TCM4uTu6Q824lQ0HJ277LbB3F79rJdlIgylSGkJFgUrprGow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f+M8+Lko; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+M8+Lko"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae0de1c378fso102024666b.3;
        Sat, 28 Jun 2025 06:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751117268; x=1751722068; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Nxx+0vLELnf/0KSgY5z4X7sbz5Zwk938cw/Cn3aAS0=;
        b=f+M8+Lko/zAEUOxvJhxPTcLXAVgrH1eQ5moJYkWsuJSlI1bu+9BYrkHrpLr2b25IQW
         IUnpFvC6gaX/MfjEnKfNJQnpIgApWv24LXxR9TO/6MGuU7Gn6+3JOXhleGopTU9GSxS0
         WEIHHvab/sCa4XWgXlB2QJDgIItnMAZav7UiAf8SwUJ6GVw534F6m33AHSyk/7HCHg+I
         wnStvXvOcNyoEyssC1+c0Am+WeOTT+m43o4iJi5RjOVrLPAzsxHB1WfJwOOTkPPTMb+9
         2aqyyKVg9RTuXASfkBUEeTnN3L+juG0BazZj/uViZz81u6TgbggK7zTMg3To0jX/n9Lw
         nukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751117268; x=1751722068;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Nxx+0vLELnf/0KSgY5z4X7sbz5Zwk938cw/Cn3aAS0=;
        b=qBY1Z2zThGUK1SxbL8U4Z/twoOVUV2zhhNqMCvWNA5l1S+fCxIXIK1Ku9H+ofjASv+
         mX9RZkdrfWssc1K6uiJYm2RO2GqS1v87o5kqfkAT36KDiN5rInPUxcCki36u+IjHFZCi
         U7pnyrZNOHgTAQn1GQofTYfU6gYAl1BsAWjRe8ug3GMWYW/dbgnYsg5oQQy8usWomaV8
         V0Cqme83ZhkJ74Ps0kprlYE+USiO9rjGBz+4jGe/fDiy8TSv9A2IB5hFf1pggIw74J3x
         EmR5B1iJtHr4Wsi8pVmlQNCbdubhJ15De4ZWk329sOqFVdnvNI45Y5DWApKDq9PhTcJv
         7keg==
X-Forwarded-Encrypted: i=1; AJvYcCVeaU4P/0HjlrtDEtzvRd4JfHF40Wvm05FrnpY24nmDgNK3lH82JlHzfXEk0dv7HrD21ymoRtY=@vger.kernel.org, AJvYcCWMB2B/NGEAbUpW2vNj4XEGrWRJEobjHn2Z1+v0gbM5WV/Bsik3DIkLqjAIkyJDt/AKWBhcxN3eDcxNG2xMxF7s@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbv41hjhPre6yOSsygheyqO9UZ+eFIFAxLRIP+ScIcwMCw+eUW
	/D1YA02fS69gstcWUegx1fiCx0mSBISB6ahIY61JPLC4gE8ht9crbjP6
X-Gm-Gg: ASbGncv0mrzCL74WlBUsLPE9+XFCxFBXauR5ijxjlRMYC6fPGCOf4a1G2RtrrRdoSgN
	nQiPNbIu7eX35nSI7ANBa+iK3sF8edG25Sbz+GX3VeC+GYGkj7QejeB7wvTYm1E/ftSH9QjbbIk
	6w+2hjppuquJiuZUvx9JtfCaflIhBq7ickrO0pfqDHolO8AaSUGqQVT0qFD+zkInvh3uRyAsUhT
	SvmVxQcVYLUi/nghfFj20BQY3uU2faJeeGU59Jhk8jVw6sE+KlcxvAlTRsMdF0TwKaxn6rR3G4M
	KiXiLG610wJy1xqWBnxSVXT2JqwRbZkNpbK1KGaq6cSNwK7L9KlpeN3YgGuVxUURfW/eNTAXNDZ
	6nXJ2WNI1n5F9SJKcGsbQcvwdpKxq6uAe1rBehhDR0oZbpf041x2Lk+1A+fbh5okIE0lIP4OZCV
	SnD8ukCJ0YxJqT8pVLFJWDRbLQVENCirkZG/vn
X-Google-Smtp-Source: AGHT+IFuqD/DkDU4axjMaoUl0BcVU2EaqayxrSXSe56IjpDjpDtR/zxE4DmtZVgLNr9j9W7UkFZPNQ==
X-Received: by 2002:a17:906:794e:b0:adb:4342:e898 with SMTP id a640c23a62f3a-ae3500b3f07mr752829766b.28.1751117267891;
        Sat, 28 Jun 2025 06:27:47 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae35363b24fsm313376166b.34.2025.06.28.06.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Jun 2025 06:27:47 -0700 (PDT)
Message-ID: <9866f2d2-eda8-470f-99fb-5a8d6756de56@gmail.com>
Date: Sat, 28 Jun 2025 15:27:46 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 nf-next 1/2] netfilter: bridge: Add conntrack double
 vlan and pppoe
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org
References: <20250617065835.23428-1-ericwouds@gmail.com>
 <20250617065835.23428-2-ericwouds@gmail.com> <aFhksV47fCiriwJ4@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aFhksV47fCiriwJ4@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/22/25 10:16 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> -	if (ret != NF_ACCEPT)
>> -		return ret;
>> +	if (ret == NF_ACCEPT)
>> +		ret = nf_conntrack_in(skb, &bridge_state);
>>  
>> -	return nf_conntrack_in(skb, &bridge_state);
>> +do_not_track:
>> +	if (offset) {
>> +		__skb_push(skb, offset);
> 
> nf_conntrack_in() can free the skb, or steal it.
> 
> But aside from this, I'm not sure this is a good idea to begin with,
> it feels like we start to reimplement br_netfilter.c .
> 
> Perhaps it would be better to not push/pull but instead rename
> 
> unsigned int
> nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
> 
>  to
> 
> unsigned int 
> nf_conntrack_inner(struct sk_buff *skb, const struct nf_hook_state *state,
> 		   unsigned int nhoff)
> 
> and add
> 
> unsigned int 
> nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
> {
> 	return nf_conntrack_inner(skb, state, skb_network_offset(skb));
> }
> 
> Or, alternatively, add
> struct nf_ct_pktoffs {
> 	u16 nhoff;
> 	u16 thoff;
> };
> 
> then populate that from nf_ct_bridge_pre(), then pass that to
> nf_conntrack_inner() (all names are suggestions, if you find something
> better thats fine).
> 
> Its going to be more complicated than this, but my point is that e.g.
> nf_ct_get_tuple() already gets the l4 offset, so why not pass l3
> offset too?

So I've tried nf_conntrack_inner(). The thing is:

>  	switch (skb->protocol) {
>  	case htons(ETH_P_IP):
>  		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>
>  		len = skb_ip_totlen(skb);
> +		if (data_len < len)
> +			len = data_len;
>  		if (pskb_trim_rcsum(skb, len))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>
>  		if (nf_ct_br_ip_check(skb))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>
>  		bridge_state.pf = NFPROTO_IPV4;
>  		ret = nf_ct_br_defrag4(skb, &bridge_state);
>  		break;
>  	case htons(ETH_P_IPV6):
>  		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>
>  		len = sizeof(struct ipv6hdr) + ntohs(ipv6_hdr(skb)->payload_len);
> +		if (data_len < len)
> +			len = data_len;
>  		if (pskb_trim_rcsum(skb, len))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>
>  		if (nf_ct_br_ipv6_check(skb))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>
>  		bridge_state.pf = NFPROTO_IPV6;
>  		ret = nf_ct_br_defrag6(skb, &bridge_state);
>  		break;

This part all use ip_hdr(skb) and ipv6_hdr(skb). I could add offset to
skb->network_header temporarily for this part of the code. Do you think
that is okay?

Adding offset to skb->network_header during the call to
nf_conntrack_in() does not work, but, as you mentioned, adding the
offset through the nf_conntrack_inner() function, that does work. Except
for 1 piece of code, I found so far:

nf_checksum() reports an error when it is called from
nf_conntrack_tcp_packet(). It also uses ip_hdr(skb) and ipv6_hdr(skb).
Strangely, It only gives the error when dealing with a pppoe packet or
pppoe-in-q packet. There is no error when q-in-q (double q) or 802.1ad
are involved.

Do you have any suggestion how you want to handle this failure in
nf_checksum()?

