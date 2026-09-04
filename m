Received: from mail-wm2-f0.google.com (mail-wm2-f0.google.com [74.125.225.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C43551A746
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 18:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788545170; cv=none; b=ie5O+BcsO9hD8tMApf5LXQ9AQHZ4tNBX831ghNUexE0Mts32YApVjcV3BohU/Lnm1M6lLpzzzjdiIFKi+GIG4EdRAs01YGzdiMuJ6cwaAJCcBTxnffYn1odtwMEjBKMvvWpSDsl4u+7KPWIpnPDJjAELzu6qF8xRCZzBFDZ5fv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788545170; c=relaxed/simple;
	bh=nvD192iZe8GfQ/+1qju1QKsfcMLglWwZM/JeLmYUs7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FzPBdTQDOiUWJXUqqnS7Kve8tSUCFyoi890MeMevH1xoKOESuC4Lkb/QSP6GSPRvdNh3n5n3rhWkucuMpyyO1cnXaMnc7dTJJhFq4AsBh+Dz4TFOqJ9yARGT3psovqtiEGo8tKcTx0wQpm5pGzbbFKwUCKcBF8QmjVPPDUsfvq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm2-f0.google.com with SMTP id 5b1f17b1804b1-49ced856e8dso5834475e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Sep 2026 11:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788545166; x=1789149966;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cVV3G2WGefOofImhtecQzvUhLxVMoksQrLF0cjvq644=;
        b=jLluOT3h4dzhTNGKE8qMwg1JMzFDzqCRsNIdtPUqVUryWdMIGIr3K5ZhHR46sN3hxJ
         TQPMD/O+okkpDiPXXogcDQgpNyCh4CgaxV5x7AeYD0hRHfgcSrYGn6TMcMSoDVJEnkYp
         Zfjp/wUc91+ZWjeOubIGoX1iqy3SksH9sbEEOAY2g9Bu7topZwG9paxP56kC8PrLsgBe
         pVV+tyBoNrC/Zx2PysoVk3fBbx1V7H04qTSRNwAYDkiUM3Jp3GATs+M5ZIcz1tBpyCaK
         Rc7tr8owhU8BYXcNeQs+Ai3ey1ZT4H1nv7zg0zuXEBCfzoddMVT5sPIDHtIIK+LzjTum
         rVBA==
X-Forwarded-Encrypted: i=1; AKwUvBzTdt81ImtKfQN/CjtW2jEa988zLBSXrQNpVpLK1F6VvHaYQxHkc5643GfSEDtmqcNtO438TfRa7oF/Ck9Qs/s=@vger.kernel.org
X-Gm-Message-State: AFuF++ll6+bDLge9dzh5n/6pjHVcfVbxpIUUwUZ/Sbmaz8v1lwJfndYo
	noTkeh/UTZKNscP6+YTPzyUIsXM11SScPALUM4O24qEZpVE1LzVbmTu2
X-Gm-Gg: AYBFou2c27KlX2uS8ZCG0RUFwcKie0LiRkCMbwm+HKkfwf0bwPlA2knw3ypV/oKq6gK
	IIfVNNel4ExHkeZj3NhK18B6TR8hk+4w32KeRDZ7uKc3adaKV6pUHLdNwIgB33JJlVizrRfS5IQ
	QZDdYic0r/h32aqeMDgTBJJS9vv+wuwq5N6LEdYGu5PLSXXwer6dyWiysUcGdZ0ZdPURyhghjn8
	jXVYqaCQXZBUoZ47ninwceLqhRd+s4jytz6I6jfVDx2WZjiUOnSTnmtUacm/zwNCPdm7cE5sEmM
	4EPJKIS9NprEhQXT/kLNHb+AaowFoFfQobrSBP4yhxMlmJFICqX+jo7++TNACTK59P569H1vSvT
	JidRXDazPfx5hUyOSEzwNOApSc4QN2jCAhgYP0LgkHHx5zjUDQWTn8gYy08Yl5rV24ON117XYC+
	ZENyVFY4AOPMcWxY43q1iSCiUG8NKXwo3wEf3VpkGB39DWAk1xUNBIvyq2KwNjzD0EJZBfrgQNC
	/0xiOVWuck0EWUEcE4plaWU
X-Received: by 2002:a05:600c:1990:b0:49c:f512:2361 with SMTP id 5b1f17b1804b1-49cf82524a2mr103087225e9.14.1788545166064;
        Fri, 04 Sep 2026 11:06:06 -0700 (PDT)
Received: from [192.168.88.241] (37-48-53-4.nat.epc.tmcz.cz. [37.48.53.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf770fcf5sm84756205e9.6.2026.09.04.11.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 11:06:04 -0700 (PDT)
Message-ID: <35704da5-5a12-4b23-b684-dcadc432a380@ovn.org>
Date: Fri, 4 Sep 2026 20:06:03 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: conntrack: make filtering by zone
 discoverable
To: Ilya Maximets <i.maximets@ovn.org>, netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 Shuah Khan <shuah@kernel.org>, =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?=
 <ast@fiberby.net>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
 "Remy D. Farley" <one-d-wide@protonmail.com>, linux-kernel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org
References: <20260904174452.1913072-1-i.maximets@ovn.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <20260904174452.1913072-1-i.maximets@ovn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/26 7:44 PM, Ilya Maximets wrote:
> Conntrack flush supports filtering by zone using CTA_ZONE, but this
> attribute is really hard to use from user space applications.  The
> reason is that it is not possible to tell if it's supported or not.
> 
> Older kernels silently ignore CTA_ZONE.  And in that case they just
> happily flush all the entries from all zones breaking all the existing
> connections.  So, applications have to infer support from the kernel
> version.  While it works in most cases, it's not a particularly
> reliable or desired way to check kernel capabilities from applications
> that aim to be portable.  There should be a better way to probe or
> discover features in the kernel.
> 
> The CTA_FILTER interface on the other hand is simple enough to probe.
> We can check for NLM_F_DUMP_FILTERED in the dump to see if filtering
> is supported.  And unknown sub-attributes in CTA_FILTER are rejected
> explicitly since strict validation is in use there.
> 
> Let's add new CTA_FILTER_ZONE that signals that CTA_ZONE should be
> filtered on.  It is a flag, since everything in the CTA_FILTER is a
> bit mask, i.e., a form of a flag.  If set, it means that CTA_ZONE must
> be present and be used for filtering.  If the flag is not set however,
> the filtering on CTA_ZONE will still take place to ensure backwards
> compatibility.  So, the flag doesn't really change the filtering
> behavior, but it allows user space applications to properly discover
> support for CTA_ZONE filtering without need to rely on kernel version
> parsing or risk accidental flushes of the entire conntrack table,
> and also without modifying the kernel state.
> 
> A new test variant is added to test with and without the new flag.
> Since the setup code is moved into a shared function, expectations
> replaced with assertions to bail early if the base setup fails to
> avoid the cascade of secondary failures that can be misleading.
> Error return is only for the SKIP cases.
> 
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
CI reported a build failure for the selftest.  It is caused by this issue:
  https://lore.kernel.org/r/20260904-net-sft-nf-khdr_includes-v1-1-92455af428e9@kernel.org

Not related to the patch itself.

Best regards, Ilya Maximets.
