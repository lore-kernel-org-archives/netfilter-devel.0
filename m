Received: from mta1.migadu.com (out-250.mta1.migadu.com [95.215.58.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210F55632A6
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2026 14:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963510; cv=none; b=dfAZyjLYVxfLFFIUSUbML9bNMztlZXC0gNxqC13KZJW7vmGcm96pA0kPWd0lNyJ2YWxor/whnhdHr6XRcHImD5IkJaWqXuNkQprImRDACmN7EEw9UeV61r5poWJlurktnDBCKLdUY58FvI+KmBCF38DNRB3WJZniCq1uCFFZUCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963510; c=relaxed/simple;
	bh=3IScLMqR1j4WOInzczvg5L6GZZlSpePkJw/WpMCPcyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sr7UCiK+P1HziVfHBdO2TJRBNTCWhAlN+eFLjv+QGma2b268IBAVORHQMRGBGJvAP2i5kYA/nPy1jdZqWHAXlNtwAh4OhXIs8PTE2oRgESEDbQg/Fe5kj2nrMuKCUjJJzirDuIL0j0E+n/Q4WUvUL6e738c264hceyA1AKL3uYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ufEOUQRT; arc=none smtp.client-ip=95.215.58.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ufEOUQRT"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3IScLMqR1j4WOInzczvg5L6GZZlSpePkJw/WpMCPcyc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788963505; v=1; x=1789568305;
 b=ufEOUQRTG7/mBrkey+CZYxeOlZyr3lX12dp8AwyeHb5ZXuEgwKJpJ3LL60LCSDJBfazOBtRg
 Fb0XfiP2hDLmR+pTfct/9AXZb73X2y8ZMT6Y0ePV2bsVzpKGff0JYrRjrVbvGpffqciQEgNW86f
 LP2HAcp5hOv1H2X75NCjBGfE=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a8c734c53a6dca85;
	Wed, 09 Sep 2026 14:18:24 +0000
X-Mizu-Trace-ID: a8c734c53a6dca85
X-Migadu-Flow: FLOW_OUT
Message-ID: <c7102128-e2bd-4b06-a402-409cd2960931@linux.dev>
Date: Wed, 9 Sep 2026 22:18:17 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: flowtable: check namespace before
 iterating flows
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260909081705.1512600-1-qingfang.deng@linux.dev>
 <aqFAALdUODUjUMo0@orbyte.nwl.cc>
Content-Language: en-US
From: Qingfang Deng <qingfang.deng@linux.dev>
In-Reply-To: <aqFAALdUODUjUMo0@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 9/9/2026 7:16 PM, Phil Sutter wrote:
> A second caller of nf_flow_table_gc_cleanup is
> nf_flow_table_indr_cleanup in net/netfilter/nf_flow_table_offload.c. Is
> the net_eq-check needed there as well? If not, could you please update
> the patch description with a statement explaining why?

No. Its callback uses the device bound to the flowtable, which belongs 
to the same namespace.

Kind regards,
Qingfang
