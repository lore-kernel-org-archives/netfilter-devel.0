Received: from mta0.migadu.com (out-242.mta0.migadu.com [91.218.175.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F943AAF6E
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 09:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789031044; cv=none; b=FkUeFfKeIzrhsRrftxtsLO9tTLxf/LRttF0HYOKR5HiWyiqX7bEf6OS6FYjyUsu9hkxzMyjdHwLWmRkA5opLf/Ya/GkuukoYJVLp6xaWCNBHvUVT3mxF0u3c1nmWpay9yeZjS6mefEb/KEcfCqaKfhfm8CG0ifhbXOpYt+pdSVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789031044; c=relaxed/simple;
	bh=wUNVRuuAgmhVudN+fFOa/MZYBPVn9vZgptxW7nwpaC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5NN0XHLDYl/jChnRS0QCjEYSIH6vr1NMN1y2wgYMoBVuktpvmNTuyvA6yHc1uV6ifNuRR7LgDFNvox2d8so0nZPaoR9NmKgQ14+w1Db192dYnyo42HwkBdCuXINW/l7rva+Hq5tbTaSvcojxUwJ4BbpopdswDV3XY6AMFRAQHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gZeYlXnX; arc=none smtp.client-ip=91.218.175.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gZeYlXnX"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wUNVRuuAgmhVudN+fFOa/MZYBPVn9vZgptxW7nwpaC0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789031039; v=1; x=1789635839;
 b=gZeYlXnX0W4MpEwl+gO6lxXPnbm4khr4R752+3eztLhjRJalFf1LhEcKgr9/pGgwsotYGa4x
 KpXAR3o3v9fqCte4aQBXriAK+xYCZErguO7ZBlnYwAixfO61PH4ZLRc7HB8JmxelBqeEnLVXLmp
 E42Gv70dyPwgXLPbkFiotqi8=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bac34b0f2eef1bd3;
	Thu, 10 Sep 2026 09:03:59 +0000
X-Mizu-Trace-ID: bac34b0f2eef1bd3
X-Migadu-Flow: FLOW_OUT
Message-ID: <94103430-c2e8-491d-880c-c4690c5e3f98@linux.dev>
Date: Thu, 10 Sep 2026 17:03:52 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] net/sched: act_ct: set net pointer before publishing
 flowtable
To: Xuanqiang Luo <xuanqiang.luo@linux.dev>
Cc: netfilter-devel@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
 Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260909075606.1508155-1-qingfang.deng@linux.dev>
 <fa0181b9-d715-41c6-8086-af410ee4131b@linux.dev>
From: Qingfang Deng <qingfang.deng@linux.dev>
In-Reply-To: <fa0181b9-d715-41c6-8086-af410ee4131b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2026/9/10 14:09, Xuanqiang Luo wrote:
>> nf_flow_table_init() adds the flowtable to the global flowtables list.
>> However, tcf_ct_flow_table_get() sets the table's network namespace only
>> after that call, leaving a window where the published table has a NULL
>> namespace pointer.
>
> The window does exist, but can any existing code path actually read
> flowtable->net during this window? Could you also describe that path
> in the commit message? 

There's none. The patch is a preparation for:
https://lore.kernel.org/netfilter-devel/20260909081705.1512600-1-qingfang.deng@linux.dev/

Kind regards,
Qingfang
