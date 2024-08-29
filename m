Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5222F5E
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 08:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724920516; cv=none; b=Yt5/z4LpAJG6XbUi+bkHzzczmq8BaRGsCb0C7/Eviy6OIDb3mFWcV2Ek3QYZMQPDdDwQOnsa6TJyyPhypaM/2hSWqnFkxq3AV8lOoLjeq7JNZdntjnt3SvxPMp7HFtmFhMfADnvFBzsXTAG8MqW/x30ktRT6yW14OqY6HrmKPKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724920516; c=relaxed/simple;
	bh=niNKKgEBYnfmhH+WcSZ2c8MjqN1b0H5B++lOzpK3/nc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nf26lP6JsSsO/uPY4vRqO1ttyQ7K6PlSWjCrirSyapysPb2E8OucVrMnhU6HY0o7/6JpESj/TDVfuE7rhISwN/XrDPKEJtjGtNCV5/HRcKgXrqUAmEOKyKuCD26DCK9a3vAncqaADIyNu85A/fpE1ghWJVRjGCWT6X6Sv0RoxJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VR3qM5Vu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VR3qM5Vu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724920513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jLUymKuWt+NKQEaSszi9iMsr44QlqAxs4bJEIt+NlX4=;
	b=VR3qM5VunflTBYuISJMg1M1cM/E0oR2g+nQMO+iVqKczmb3VbYIRQHswSmfOLzMpn2ZDuG
	GpBtU0Z4wdFWrUgfSHPXsbjsLAVwMFWy/DR1IZjhiZoJR+fhpQ0t7IWIbAKx93zwFds7FH
	X5h/JU650iI3IqlHP+pqr7cSnOxgI8M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-QOExQttcMZ61fDrSxIFKOQ-1; Thu, 29 Aug 2024 04:35:12 -0400
X-MC-Unique: QOExQttcMZ61fDrSxIFKOQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42b929d654bso4093815e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 01:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724920511; x=1725525311;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jLUymKuWt+NKQEaSszi9iMsr44QlqAxs4bJEIt+NlX4=;
        b=JQr5ABi0ccvQxLOhmhFpgP5b0HCwSQk6qSXBCgc+fRVC7WHLeQSVwhGvqteE6hVSho
         9U6ozoQ5OhWGL7FI8DD+TiD63wg8pjU7RsV64XYqBv/Bnc0J3vhvkHTYuMPIDse5wCaj
         YLliid0C4bj4ADKEx4JlTHgY8MEJKE7C0yjOE0gFpAgcCG3XVXJKjY1nYHXsjUgin7EA
         6AEytdHNRrN+xQzllm+bcSlzuJveuYaPHMcI2NdCn3dQljRXeLad/cJMGl+YeKQ/Ivtn
         v/xoSsk393HL4ncVKHcQmIrNBoGqqZ6Np8iV7vyDivhwq0d62QI8gFS1Aq+4WPdMRHKi
         i3eQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2++iTjscurLV3WS57tIVEfQ73Swz0usXFcYHViW3qoGkKNI/E+5Kk8nyBk6uyQpED8wrNlKjFSb5M1VOFxX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD+K2+CwqO9RQ/b/zm36fwgrify3cMf7L99c31eQAnQqAzpSn3
	RhqbQkCjeZIR4RR4qFfRaY6UXdMGBPDD8boYLCCh9Iy5Sx7JNR+VwVlQqohE0GmL7YVaynRwZlr
	bXqMFABrMtba5a8j7QinoWMNZXDR0vfDzYgRkTOKwFG5JWHfKgocI9j2l2E9/fQjSIQ==
X-Received: by 2002:a05:600c:1914:b0:428:52a:3580 with SMTP id 5b1f17b1804b1-42bb02c071cmr13817485e9.3.1724920510999;
        Thu, 29 Aug 2024 01:35:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEInkswj2i86rE05dq/qQudbVYtuioUD9hZw1RN+aFdYAm3WNKMqJjr1DkacydPx99iOnthYw==
X-Received: by 2002:a05:600c:1914:b0:428:52a:3580 with SMTP id 5b1f17b1804b1-42bb02c071cmr13817235e9.3.1724920510473;
        Thu, 29 Aug 2024 01:35:10 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:1b50:3f10:2f04:34dd:5974:1d13? ([2a0d:3344:1b50:3f10:2f04:34dd:5974:1d13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb85ffbadsm3711905e9.12.2024.08.29.01.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2024 01:35:10 -0700 (PDT)
Message-ID: <399397e3-467a-41aa-8bad-90c80954764a@redhat.com>
Date: Thu, 29 Aug 2024 10:35:08 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] selftests: netfilter: nft_queue.sh: reduce test
 file size for debug build
To: Florian Westphal <fw@strlen.de>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>
References: <20240826192500.32efa22c@kernel.org>
 <20240827090023.8917-1-fw@strlen.de> <20240828154940.447ddc7d@kernel.org>
 <20240829080109.GB30766@breakpoint.cc>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20240829080109.GB30766@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/29/24 10:01, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
>> On Tue, 27 Aug 2024 11:00:12 +0200 Florian Westphal wrote:
>>> The sctp selftest is very slow on debug kernels.
>>
>> I think there may be something more going on here? :(
>>
>> For reference net-next-2024-08-27--12-00 is when this fix got queued:
>>
>> https://netdev.bots.linux.dev/contest.html?executor=vmksft-nf-dbg&test=nft-queue-sh
>>
>> Since then we still see occasional flakes. But take a look at
>> the runtime. If it's happy the test case takes under a minute.
>> When it's unhappy it times out (after 5 minutes). I'll increase
>> the timeout to 10 minutes, but 1min vs 5min feels like it may
>> be getting stuck rather than being slow..
> 
> Yes, its stuck.  Only reason I could imagine is that there is a 2s
> delay between starting the nf_queue test prog and the first packet
> getting sent.  That would make the listener exit early and then
> socat sender would hang.

As the root cause for this latter hang-up looks unrelated, and this 
patch is improving the current CI status, I'll apply it as-is.

The other issue will be fixed by a separated patch.

Thanks,

Paolo


