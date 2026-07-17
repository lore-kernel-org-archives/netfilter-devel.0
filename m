Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58243AEB5D
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2026 09:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784279842; cv=none; b=rXjYFqwCPc0ud2oylypQ7djqJN55RdeB9yp8ukDaZd8JQw1JlCXmt+GiZrxDIFf87YwjpFUHc0U5k4zhk1YDIwuXbwr+UXIhJAfjxsXnThCemLV6H4IcfI5DofdyuEYk1xHlZahcv/ujufa2NpTrgMlGxqlvnFzoSrdk+2kg+oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784279842; c=relaxed/simple;
	bh=Qo8yqQWy2e29+GEZLOVJ9je90QWz4nxsG0+IqRQBQ9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gpq6bHF+4hcnz07v4k9IfCZ8MZuKsJAAJZsAG9ebQVQ3t6nxiQGSkcscxCSxtIa6d+1rq7X1DnkfRvlq50F6U6i+c70dBp21pqOk9AGRPLjzJa1/gv159f16wR8DkPDXJprvBee69SN1nWqcNFkpiOFXIeoelrBEjdBC7hyt7GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IoTDrmYV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SA/P+Sln; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IoTDrmYV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SA/P+Sln"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784279839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqpKK8ft0IXPhFJO75+elLXire9Ux6GYiWNcrL81fcw=;
	b=IoTDrmYVMhTtZd3pm+TCVMtZkMtP++7F7xRVEiwqhuAmFHuj27yAIIMMHFV+6DzHgdzmNK
	fRTbFPubPwnkm7gpwZfzOG4VlggHCqD4ooWUg6o0fEvkbRbdC7LVTa/vl78XbofI4aAEHb
	EFj7jIIBzCtUELnV+x8S4IKoicMmFRs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-p6Yv14DNOpa6YrSPHyiEug-1; Fri, 17 Jul 2026 05:17:18 -0400
X-MC-Unique: p6Yv14DNOpa6YrSPHyiEug-1
X-Mimecast-MFC-AGG-ID: p6Yv14DNOpa6YrSPHyiEug_1784279837
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493d742c668so58605135e9.2
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2026 02:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784279837; x=1784884637; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iqpKK8ft0IXPhFJO75+elLXire9Ux6GYiWNcrL81fcw=;
        b=SA/P+SlnDfoQoeOKH8Tcsz9f1kaL+YIY7IAY2aCaH06zTK/XKyklaYsqyNv5BULZID
         dtzAS8xgoOMDTMUsnZ09HQkW0/q9142tpFDfOfvbkD+9OJDYk8/8erYEemGG/6fTBHyr
         SQk30euuEL79kKF/xrq0QZczfj8JFVaq5hsTYFZiIX4ZX3gq90lz36FoOvnyggSWCLv8
         pMObK/4nx6vgllCcweY0k4+DJqLAYcMnplb+YifdrDVEJXOwK5264hSvPNu5L50rXTRo
         63ouyzFN7uQ6qeNcX/6etICejRppnKFz7q3l6O3btqsYf/oFf6L//Z1Qvs75BBoWNNyy
         vWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784279837; x=1784884637;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iqpKK8ft0IXPhFJO75+elLXire9Ux6GYiWNcrL81fcw=;
        b=Da4P5gOEwIXOHX3RGj1p8THBosX+e/sc2fF3tOTNS2ugKcV1kHFLt+dgsMZtk4fT4Y
         uDW8XhMbibWLpveWGpaomivxbmwwQSH1U3Di13rzA0jkGWHnbDrctCW0AC0wYbTML5D8
         TMf9vOulUU37JHjzM4BLnh+SQJMNdYsmi/UHaRw2/kqf9XorB4ZWOmSG1USGWiS6fiPW
         JrEr10Ad7eP0bvwnSK1r2i35IZU18cjNpvddT0mVMlKztBBE+oVRlhJmCW6ZID22A0M/
         XvBWnAbED1bCzjLG/NgIBFqO5nk351Ha2Qd8hlhIoOOvblidvKeDTGqt1xGPEzM9FfQI
         G+DA==
X-Forwarded-Encrypted: i=1; AHgh+Rp20uJAUcETDhB/l4LvH9N4zOT0wcUAFZaBz3yw4Lkm2xXLtTo4X3ZqUcky121M5GuACZZiaYC1+IN06Ibp1Wk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHs2379jAjvbXC76tSkIlO4uQI6dwKEXAWaOX4mjMujUp2RfmE
	JrtHkjM5aobO+qrHNjSdxtBoygJpZ7HHE3KGVHbfrJIQOieofpuQDjcIFNfbQydCHIoUfcflCxm
	6txLXatd6t/GcMg77JIEHudJbppUNKVpi9oVHeFJtXipXk1IQGC1JdXZcyUIZdP5jxr8qRw==
X-Gm-Gg: AfdE7cmRdFbK4/xD0IHgTTUsyfQb6GDIzXCDE7zajs9eD6+So5QlcakvjAjaYdhpb5a
	Yd5MqnDpA5oGcJ7Ps4pf5WLyX8huho40WmP++zzDrdgVhS6sa2TPmjPp4Gst75z+vtwmXd0dgiL
	41LFsZJ0e4Ru0N9kxQpTGhVqhV4xctpySHtrx+AaD9SK/M0/2DHfNoNFNzBl0khjOt6yiDJWFdO
	Ndy81kRdttWhjRUTfJBjsZCfSzaT8DPczIKZJJLdiI5rZp6WjKOKQBG+b+a+e6G5M7TerhmYd2r
	o1sy45cIYzIVszczS1ikwOYx9j8xNAN7whPEXgoYD39sYd7F++6Nb5ewFqcIvYkzPR4GIR+WZl8
	B3mW91eJCtDS5INc1w5MA1gmQicKtvyeyGTo5xX+f4D1+IDCjPM8JhdEZCvaVtpsQ16i5AgOytf
	DCIw==
X-Received: by 2002:a05:600c:48aa:b0:492:6efc:7c60 with SMTP id 5b1f17b1804b1-4954a516183mr13375245e9.28.1784279837363;
        Fri, 17 Jul 2026 02:17:17 -0700 (PDT)
X-Received: by 2002:a05:600c:48aa:b0:492:6efc:7c60 with SMTP id 5b1f17b1804b1-4954a516183mr13374915e9.28.1784279836791;
        Fri, 17 Jul 2026 02:17:16 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49548e02043sm41826725e9.1.2026.07.17.02.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 02:17:16 -0700 (PDT)
Message-ID: <e7ed31d3-a3aa-427a-8e82-aa65b4388368@redhat.com>
Date: Fri, 17 Jul 2026 11:17:15 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 8/9] ipvs: fix more places with wrong ipv6 transport
 offsets
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
References: <20260710143733.29741-1-fw@strlen.de>
 <20260710143733.29741-9-fw@strlen.de>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260710143733.29741-9-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/10/26 4:37 PM, Florian Westphal wrote:
> From: Julian Anastasov <ja@ssi.bg>
> 
> Sashiko reports for more incorrect IPv6 transport offsets.
> 
> The app code for TCP was assuming IPv4 network header
> even after the ipvsh argument was provided. This can
> cause problems with apps over IPv6. As for the only
> official app in the kernel tree (FTP) this problem is
> harmless because we use Netfilter to mangle the FTP
> ports and we do not adjust the TCP seq numbers.
> 
> Also, provide correct offset of the ICMPV6 header in
> ip_vs_out_icmp_v6() for correct checksum checks when
> the IPv6 packet has extension headers.
> 
> Fixes: d12e12299a69 ("ipvs: add ipv6 support to ftp")
> Fixes: 2a3b791e6e11 ("IPVS: Add/adjust Netfilter hook functions and helpers for v6")
> Cc: stable@vger.kernel.org
> Link: https://sashiko.dev/#/patchset/20260706101624.69471-1-zhaoyz24%40mails.tsinghua.edu.cn
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/ipvs/ip_vs_app.c  | 10 ++++------
>  net/netfilter/ipvs/ip_vs_core.c |  3 +--
>  2 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
> index d54d7da58334..b0e00be85cb1 100644
> --- a/net/netfilter/ipvs/ip_vs_app.c
> +++ b/net/netfilter/ipvs/ip_vs_app.c
> @@ -361,14 +361,13 @@ static inline int app_tcp_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb,
>  				  struct ip_vs_iphdr *ipvsh)
>  {
>  	int diff;
> -	const unsigned int tcp_offset = ip_hdrlen(skb);
>  	struct tcphdr *th;
>  	__u32 seq;
>  
> -	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
> +	if (skb_ensure_writable(skb, ipvsh->len + sizeof(*th)))
>  		return 0;
>  
> -	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
> +	th = (struct tcphdr *)(skb_network_header(skb) + ipvsh->len);

Beyond the usual set of pre-existing issues, sashiko-gemini noted this
patch may need a follow-up:

https://sashiko.dev/#/patchset/20260710143733.29741-2-fw%40strlen.de

/P

