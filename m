Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE63192595
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727343706; cv=none; b=m76RB/pWS5EdpXLH73oYSihqwjEOn7gM6vQ4/Kdyfd36iR65iiqzWIPIZsgGTXfyhHX5JizF4Vmtz5V2DYwlZC2T43ujMShK7YPE3QHFqiOcMu3JDc2MyhKVNuLEYFO2Erk5YHHsO/cgnJqRh1fdE/U2NyUQUvMFJnSNs82KK+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727343706; c=relaxed/simple;
	bh=7KjcE0B1b3Lo+UG6zGvriAp6T9t+938/9Ug99PMsz3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mLiPhFMVjWX0m8OxYUdLzGN5wYXJQmr9nKX+l2gmy+janhFehFRI8WftsNOaqFXHQFZi63HO1gFTjFH7A3egn23lHL0VKdg1vExaaV3JqErDQz+Hiqzx/vWIZt/HSBymDqdwFz40WjOllhBgOI17NtEcsV43nmE1ycEAulhdR3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dplgDuQ6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dplgDuQ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727343704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=duedYL0F/SZtcaJ/2ctYIidXMcsINgd6fgzdoKb7MGU=;
	b=dplgDuQ6i4d2DP6H7Ji6Z55GxBowjR8Ln/5BN0Yzq63YwnrqkTuPZbuHsSOCZgtGjMuczY
	Y9L7B5ftdZEpepzrONR2++1YDOTSDEHrtvm99vZ69rZGWvt4ySdqTMFLG5aLbFeLq6mLxP
	vRG8WkASPm2BhLz2RehhR48WjdXRFjo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-LfdwIK2oMiqBmCZD7k_gxQ-1; Thu, 26 Sep 2024 05:41:42 -0400
X-MC-Unique: LfdwIK2oMiqBmCZD7k_gxQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-374beb23f35so313266f8f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 02:41:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727343701; x=1727948501;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=duedYL0F/SZtcaJ/2ctYIidXMcsINgd6fgzdoKb7MGU=;
        b=YB53U/96JLnPFnrqeOe4hlfnqnoMkzqxztU46zNrNG/FglaFOhNmjQs+z7KvI/J2G4
         UdzYV51dZN/wQI986OI9OjIcGeN/2razc+kiU/NyPFUrcu9evo0sgX492dulZUw6y+qH
         FWuXEoOfV8smY8329Uri/H4OuJ7n14zG9JEthNbUNrxZo/lQ+VsBu7UjyGjfigGK6+WA
         hnYA2TfFVNisbQkAqNFiY8bZpzCaFv4kv5giEQtsNv81vj3vjzOKaa8gYY8ehKkAObgb
         P/8Wi6/Qv6VOH5j0DB7KMAXomOJXdtKS8+uZQLZq4L4EbOvBaymeIfQSMWzVxqN2ZYYh
         jkLw==
X-Forwarded-Encrypted: i=1; AJvYcCVTpJRr9OzbwLOq83PFL3SJpRIS7iMhQCFy8P8Ld2iI9XrYBkOIJ7fx4Vze278VH7RrD9TgaNCT77TZIvzxtBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHalJ3cS/edFWIjbHNtFFAi+vTB5ZBLp8qnpfeBAmfnlWylYTv
	tazJRu/Fw2k34hhOhAu+wqla2zr2043amEialhnKwyVJ1sNlHgGw9cjK6WH6gZJlQ0ZiICCTpaF
	sdCe6gDWSEql/MLjtK0CYeGieCQAKblIVqe8Vtq5KufvIj1ZQNSIlPgl9PyRxhnerAw==
X-Received: by 2002:adf:f5cc:0:b0:374:c31e:971a with SMTP id ffacd0b85a97d-37cc22c292amr3012478f8f.0.1727343701344;
        Thu, 26 Sep 2024 02:41:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbNFmaQ62WOIINYfB3CeWV9VfSJOSRt842DmCJ3cUVE5vR4WBvRiBLHJBBmQvDyTZzZ/7Axw==
X-Received: by 2002:adf:f5cc:0:b0:374:c31e:971a with SMTP id ffacd0b85a97d-37cc22c292amr3012459f8f.0.1727343700913;
        Thu, 26 Sep 2024 02:41:40 -0700 (PDT)
Received: from ?IPV6:2a0d:3341:b089:3810:f39e:a72d:6cbc:c72b? ([2a0d:3341:b089:3810:f39e:a72d:6cbc:c72b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc2a8b55sm5994446f8f.17.2024.09.26.02.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 02:41:40 -0700 (PDT)
Message-ID: <c51519c0-c493-4408-9938-5fb650b4ed8b@redhat.com>
Date: Thu, 26 Sep 2024 11:41:38 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 00/14] Netfilter fixes for net
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 fw@strlen.de
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de
References: <20240924201401.2712-1-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20240924201401.2712-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/24 22:13, Pablo Neira Ayuso wrote:
> The following patchset contains Netfilter fixes for net:
> 
> Patch #1 and #2 handle an esoteric scenario: Given two tasks sending UDP
> packets to one another, two packets of the same flow in each direction
> handled by different CPUs that result in two conntrack objects in NEW
> state, where reply packet loses race. Then, patch #3 adds a testcase for
> this scenario. Series from Florian Westphal.

Kdoc complains against the lack of documentation for the return value in 
the first 2 patches: 'Returns' should be '@Return'.

If you could repost a new revision soon, I could possibly still include 
it in today PR (delaying the latter a bit).

Thanks!

Paolo

