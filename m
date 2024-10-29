Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469E0205AC6
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 12:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730204345; cv=none; b=Zm/5OGM9Bw7pwuGatxRYbjaHhjCHkU4ynEplmztEI1kyj0Q65bivwR+iwWT5/XpGTFHdr8kAoOs7n26s2MSCuNqv1yT5Jn0CjcEQfTyuPsyXfq1wKuBE8QqeZmIntAiPs78UGLTYqp7obn4e2fDighcJpMGIvALKnTua6nHpkZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730204345; c=relaxed/simple;
	bh=0I7kvJtFLDqQM0siDKT0j8ymg14gRFLwbFQ5gaEXjw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=U/ZV1iMX/pdVx+m+LC7TDMKFMN2DtjVwgSRAtrqNp2T8l8D6rLnhnr0xnDL1kDX0mYVjPKCn22R58KeZ2yiVpvEN0AvLQeBvJa8orpP7n13/q/gPZUn2VRfl+T77CFZ23a4K6KW9a9hiQ5L2holjQns/d6eyJ4QCPxcAlNjQoO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YuyTlG44; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YuyTlG44"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730204342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vfuf4xyKDvT9u1kPEhld7930e8myJyX3Zvs5SawIvSg=;
	b=YuyTlG44rGdGOTGNMYOmP7O4m4uLkLMn+8UHTndNLpN/lAHsUpJAMWwvuBJM5IsouhxHX/
	x0LwU71GKh9sUK63OKZbfVXUcQgqRMLlnSsLs9CLRyjzrJvPMoSoF2GBUgerm2BTaKLAjW
	+4J9jA1btXqasr+JoAiG+dLbbmcOEBw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-Fnqe0yJtMxizgYLzuPwzEw-1; Tue, 29 Oct 2024 08:19:01 -0400
X-MC-Unique: Fnqe0yJtMxizgYLzuPwzEw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4315e8e9b1cso30784135e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 05:19:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730204340; x=1730809140;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vfuf4xyKDvT9u1kPEhld7930e8myJyX3Zvs5SawIvSg=;
        b=uxAy8nLjjdRxNOaAZ/hKRN69t7CXOlZX0bRZqjpm+S+1ypNXOv+8SyLBQusYkmv7TR
         JkK1KtuXCeo0gH0Vo4AGiXdKjK+Q8P9dsQA9uSPSQ0CsMPjH0Hj/m3SbqqegZyviFR4l
         B2xTbjmPWLacg//yGtTJQmAjtms4cb/Y68NihSh7Z0BoEfKaE8Xp3A/eIkRhPrvwOlcM
         4aATI3fvqmcrgl0AN+T/jxLqAV53in3k+GymXAuQnxQQwuG9AOPBglH3vYawlC7sfU11
         NfElwQCcEK7MS5c6+1BOau5UJ1tFmsS21p0E2Xd1oeTsEk3N1OtPivlCYJkjYm575TGz
         UlAw==
X-Forwarded-Encrypted: i=1; AJvYcCU1sdSImvhxVPH8QWpUoT9p+v28V9+vwpGNVrkuN2Jv1Z1e4wIqAec6OIqMQusHZQj7vAxQam2bE1rU+E4jcEo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw07h4y7v2WOf9fwXNaMt14/wf+BQ3PDkZwKzcz7Z0kAl9Xqfbo
	f/QheUyKkZ84prxCD9Fwji8plcbPI3OVzkX0e9cZ0NxFbXuDTDtALg0Qs0jemfktXqie4l46hK4
	Js5hI9R4f7DiRWGlOdc1BH7378KxqTXtpPJ11L3qF23+ZxSdgw3ohxj1yLkKIUzqqk+dLWltzk/
	IJ
X-Received: by 2002:a05:600c:3555:b0:42c:b166:913 with SMTP id 5b1f17b1804b1-431b5727f7fmr14851825e9.11.1730204339707;
        Tue, 29 Oct 2024 05:18:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmrOsa0Gr67Yj5/cS+/SQl29FfUNpizydNLzGmFEG+bAVc4wyWPLsRt8+pgyP6z3kTKadvOg==
X-Received: by 2002:a05:600c:3555:b0:42c:b166:913 with SMTP id 5b1f17b1804b1-431b5727f7fmr14851665e9.11.1730204339372;
        Tue, 29 Oct 2024 05:18:59 -0700 (PDT)
Received: from [192.168.88.248] (146-241-44-112.dyn.eolo.it. [146.241.44.112])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b5430edsm173654585e9.2.2024.10.29.05.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 05:18:59 -0700 (PDT)
Message-ID: <c0a4d1ad-cb3a-4d61-93b5-471c1033d67d@redhat.com>
Date: Tue, 29 Oct 2024 13:18:56 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 net-next 11/14] tcp: allow ECN bits in TOS/traffic
 class
To: chia-yu.chang@nokia-bell-labs.com, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 dsahern@kernel.org, netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
 coreteam@netfilter.org, pablo@netfilter.org, bpf@vger.kernel.org,
 joel.granados@kernel.org, linux-fsdevel@vger.kernel.org, kees@kernel.org,
 mcgrof@kernel.org, ij@kernel.org, ncardwell@google.com,
 koen.de_schepper@nokia-bell-labs.com, g.white@CableLabs.com,
 ingemar.s.johansson@ericsson.com, mirja.kuehlewind@ericsson.com,
 cheshire@apple.com, rs.ietf@gmx.at, Jason_Livingood@comcast.com,
 vidhi_goel@apple.com
References: <20241021215910.59767-1-chia-yu.chang@nokia-bell-labs.com>
 <20241021215910.59767-12-chia-yu.chang@nokia-bell-labs.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241021215910.59767-12-chia-yu.chang@nokia-bell-labs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/24 23:59, chia-yu.chang@nokia-bell-labs.com wrote:
> @@ -2178,6 +2185,7 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
>  int tcp_v4_rcv(struct sk_buff *skb)
>  {
>  	struct net *net = dev_net(skb->dev);
> +	enum tcp_tw_status tw_status;
>  	enum skb_drop_reason drop_reason;
>  	int sdif = inet_sdif(skb);
>  	int dif = inet_iif(skb);

Minor nit: please respect the reverse x-mas tree order.

More instances below.

Cheers,

Paolo

