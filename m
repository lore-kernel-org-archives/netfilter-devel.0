Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9EEA95C
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 14:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731596104; cv=none; b=jMJXgdUFS3SjwLnlfa2zg2DaVYe6tYiR61kmPIe+ZsF41qqjBhW//8nIaaqGrzWx6hypujxeB5eXlzb/zPVro8WHAiUOe3BXqVuZwgl4blyvUWq0H/YOb18p3BmGk64q7k3+0FN7GD/BO5g4SWfFiy0+rXN+bgVjAbFEXZi14rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731596104; c=relaxed/simple;
	bh=ec2L+7e0vT8yTLsCl2sZgLxSob6hsS5EkocT59W1j/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nbzZ28sQdY/jhmZZmB+eR7PiSw2rBJ5Y7p/ijNS7rLF3abMY5ZcsgqpHO2RzC3vXf6A0n4tTAzAc2YpFG5k12WMu4EYox+zQX/L3/iKDVJpm10rK6Igh+3KwWxSJbIdmlf9FpeZVUvKcCmuxVE0Z+cZqwOYmaCgjjomDe0NekpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DeBAlZ1n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DeBAlZ1n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731596101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wl368KWLJfj6XVSvcwTkcEJAI/thf3EjKjtMwcyr6QE=;
	b=DeBAlZ1nwxeyOdjNI7YcrCgNnCuTo4erWdIKo9yj+/N9HHCOLJ+mHL5tyOQ0I8vnhcqT4I
	CijKZQLxUCrR/ixynMJPF1yExHsxFZ9xgCbYMiu2M4pgqYQFjUcY97uCVFC7MENSC/kYwP
	7w314OJrpWT/fUn59TzwM+T3y8q5pig=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-liCzoRTjOt6xP3mMRfKeyw-1; Thu, 14 Nov 2024 09:55:00 -0500
X-MC-Unique: liCzoRTjOt6xP3mMRfKeyw-1
X-Mimecast-MFC-AGG-ID: liCzoRTjOt6xP3mMRfKeyw
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-539eeb63cc3so548926e87.2
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 06:54:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731596098; x=1732200898;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wl368KWLJfj6XVSvcwTkcEJAI/thf3EjKjtMwcyr6QE=;
        b=gMNMAX8T9VUexVRONVq9hgiWMGAce4mCGpaOiAcrC+i2Ao0DJQIKJ8DGJA2uE2qqkQ
         WlDRjPxWpVAqBLOBKWThmS3hAaFh70909yWcIRsrFWm2ZPTPQ6R0vXnIOgpgvnoXWC1m
         bCvHZvH6fZ3nip8dKrwDDlIj3FJn8SaWWBXvuoOwBEWzVvr7wa19sduwsCYPreEvJM89
         yfjdCx0QOH31laLz33O2yiJ5pAFvc/By9Xz9QzGzhypeosXsOPSrR0YAzZzkvUWDAEUV
         ZYrCQj9b+vmAOAtdFZTJ2X0Phgj76vfHGUEhp35Sm475PwNAG32zn/ZaqNhAnm1D29n1
         /u1w==
X-Forwarded-Encrypted: i=1; AJvYcCVdncjCid86Kdo66r95rzBP95HZQcXwcheTw5WkTuNxhXwgy/mJ9s48hGxCSYYsT4D4ZlN3q+ByDLXU29hIK4s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxexT3QqDV37JlFbIqU6OAQjS8Y6N9QSjVs5cqs6lyBUfJ+siOS
	QO9WVCOjRsFrakwXbU/A4ODoOegSvuRvsBSmZ+Xra6ERH3yW9htCDDKEMa8FjFnYoTwoeoBw5V9
	viGI0eaK82WMsUmkTgwIH719r0U2pf2kirUDK0pkB/yXaFVOr0Xtfvh3gxJ5PtUtajg==
X-Received: by 2002:a05:6512:3e0e:b0:539:eb82:d453 with SMTP id 2adb3069b0e04-53d9a42dfc4mr5958672e87.39.1731596098418;
        Thu, 14 Nov 2024 06:54:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3MgpF5ai6GfQ8bKQvnzeky07N7cZIpolBQK6Vfo6iU8LsHLdNA9A6r1kC1oq+w5DZqMrkPA==
X-Received: by 2002:a05:6512:3e0e:b0:539:eb82:d453 with SMTP id 2adb3069b0e04-53d9a42dfc4mr5958654e87.39.1731596097967;
        Thu, 14 Nov 2024 06:54:57 -0800 (PST)
Received: from [192.168.88.24] (146-241-44-112.dyn.eolo.it. [146.241.44.112])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da265c45sm26332215e9.11.2024.11.14.06.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 06:54:57 -0800 (PST)
Message-ID: <119bdb03-3caf-4a1a-b5f1-c43b0046bf37@redhat.com>
Date: Thu, 14 Nov 2024 15:54:56 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de
References: <20241114125723.82229-1-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241114125723.82229-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/14/24 13:57, Pablo Neira Ayuso wrote:
> The following patchset contains Netfilter fixes for net:
> 
> 1) Update .gitignore in selftest to skip conntrack_reverse_clash,
>    from Li Zhijian.
> 
> 2) Fix conntrack_dump_flush return values, from Guan Jing.
> 
> 3) syzbot found that ipset's bitmap type does not properly checks for
>    bitmap's first ip, from Jeongjun Park.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-11-14

Almost over the air collision, I just sent the net PR for -rc8. Do any
of the above fixes have a strong need to land into 6.12?

/P

