Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5419A1E3DF9
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2024 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507975; cv=none; b=Ezut7R1/Emhep4XK9IFRrTQttwmD8bExbwLcfwcpgJXqPVuOEeSqg4SxQjVYIMhIkSVXUp1mKQVmaFu5+S5OAqYztNzIIsIwsSP485vfv+GGYKide6PTD+xvCFzShzdW0DSqdngIiq4QfZy/zBj64kBzVGQs7Xvtg59dqWb37ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507975; c=relaxed/simple;
	bh=XV1S6Zw+g3mH55uWg3ccT7dNJYp0UXWhsGtCGN4+4GQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oLdpQmJqun+hkCvQipxC7bQMfB0s1t58h8/Ilc+CRGw8RFQrmGfAYcsVpaEjAyoM1bx6HgJuOVWtK265eGb26nYLjctMbczUQK443084d/nGqMqbuFAK+0CTkPdXsmqDxXUgAGTkZNsueaETPUS/DJE89AKNspmwpUDh6Vp05yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MGw7hhok; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MGw7hhok"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729507972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Io9Wjovsf8+IWCVdGDtutv8zva9MNZWk0eG1/vRQng0=;
	b=MGw7hhokpVWCEy/rSNOJtu2xQcSXRDNbpMbLi9S797hXiSeXWyxJRrBzOFpb1QUtkAWGvJ
	hVJUWF7G7ZEEDxUHFNXVYzwPkghIX11oVbI0uSmhCoU0b9f8hvagsA3J4i2923/Ffe4BXR
	7q8+9rEcYe8oclvZt2zCHQCKZgDwyt0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-5QmVrs8zO96tJV1Vm-MfAQ-1; Mon, 21 Oct 2024 06:52:51 -0400
X-MC-Unique: 5QmVrs8zO96tJV1Vm-MfAQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d49887a2cso2365508f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2024 03:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729507970; x=1730112770;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Io9Wjovsf8+IWCVdGDtutv8zva9MNZWk0eG1/vRQng0=;
        b=Qi3+6FBn2shFJd6mSHTwpESQ8haNp3B/D1KgiqU3j95QGjkqCBFxIaIIAcmghrZGIH
         NNV21l3E8VeOWl00do6MEoS1IGKW0iGylo4WUDh4Ejb4F/4/opbK60xiRZNzQsLhjC/9
         MlWHUJ46yBe3iVicaqeT41hw4i5hppMz7aBf8gOfbh4UM29uRc6Mj8ho/BQnFOmcbYCF
         rtvyADWt4CchC0p8VIa7XKPu2m4V/kzLnrdi8H0RixbItxtsmWqz4o43zkp+mCOwA2kK
         FEYinIisdj0C/7Vteuj3MjTl+dTRuAHjJWQd1DdpvwnzPING9lYkznswLYI5CeszG3m/
         BOaA==
X-Forwarded-Encrypted: i=1; AJvYcCXA5UdcnC5pqVA+780R6AJtRvYZF8diQsQ4QZ1tIdg0HLdeNEGmZhy9lhr5v6DM8qlUvXcTBOOSCjFTqiaPpH4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWS39+8lu6FRGL7zyUtNI6xKbfuvSFGa6yqkFb9KqKWD4ZQuG3
	5mc/8Sp855xj5Ec2Gm64WbOo6dFxi2Z3hgXwsRR3zpix7en50VlaNMNxRLWhDAzRGi5JN1ahdOF
	qTIHjUUn21OLDWheGLj04ea0K1oDnZSNUQY4AGmBTLFirMBlCYJ1CvXaNgzm55zuDMQ==
X-Received: by 2002:a05:6000:183:b0:376:dbb5:10c2 with SMTP id ffacd0b85a97d-37ecf08650fmr7003033f8f.29.1729507969840;
        Mon, 21 Oct 2024 03:52:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdA0NxQjeMM/mp9d3cx0ocUBlXzwmAevgDKmJdOzzdQKq8l1oOAE/WjVMpBUAWAdDgbNEdlQ==
X-Received: by 2002:a05:6000:183:b0:376:dbb5:10c2 with SMTP id ffacd0b85a97d-37ecf08650fmr7003008f8f.29.1729507969505;
        Mon, 21 Oct 2024 03:52:49 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:1b73:a910::f71? ([2a0d:3344:1b73:a910::f71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a37b07sm4065797f8f.1.2024.10.21.03.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 03:52:49 -0700 (PDT)
Message-ID: <20d9ed5f-abde-43ee-854f-48a9f69e9c04@redhat.com>
Date: Mon, 21 Oct 2024 12:52:47 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 05/10] net: ip: make ip_route_input_slow()
 return drop reasons
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 dsahern@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
 roopa@nvidia.com, razor@blackwall.org, gnault@redhat.com,
 bigeasy@linutronix.de, idosch@nvidia.com, ast@kernel.org,
 dongml2@chinatelecom.cn, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev, bpf@vger.kernel.org
References: <20241015140800.159466-1-dongml2@chinatelecom.cn>
 <20241015140800.159466-6-dongml2@chinatelecom.cn>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241015140800.159466-6-dongml2@chinatelecom.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/15/24 16:07, Menglong Dong wrote:
> @@ -2316,19 +2327,25 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
>  		err = -EHOSTUNREACH;
>  		goto no_route;
>  	}
> -	if (res->type != RTN_UNICAST)
> +	if (res->type != RTN_UNICAST) {
> +		reason = SKB_DROP_REASON_IP_INVALID_DEST;
>  		goto martian_destination;
> +	}
>  
>  make_route:
>  	err = ip_mkroute_input(skb, res, in_dev, daddr, saddr, dscp, flkeys);
> -out:	return err;
> +	if (!err)
> +		reason = SKB_NOT_DROPPED_YET;
> +
> +out:	return reason;

Since you are touching this line, please rewrite the code with a more
natural indentation:

out:
	return reason;

Thanks,

Paolo

