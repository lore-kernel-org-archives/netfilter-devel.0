Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC933E8C70
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 09:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033419; cv=none; b=b3GR9iqI8HTvP6QWNADpqquUyFeUlst+Tw26iZMJThhUTMmbG/kqLwFHk/+3cm3gKnLq8ig+3RISYrTdQW2TjCV8+VtbeFKgSFVXCaTTWSlKjx5iSM0bPwD/TsBk2gyY1AHzwLMSz0oiSd1VQ+cEH1xtLgWACvxv3USfmZB3waM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033419; c=relaxed/simple;
	bh=KnS4FREeAKzpHL8fFTZa5rjNeAMn6U9PigOahw3tm9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eL4mMIo+vwVgfwkLBCEtMe3OAuL3HUMkKiYKzZ387mdTpPbOFvGHhqLoi38X6GZ457qdc6E+f2NEzVrmNWNoGaXU7lTpojrRcAwjyKMOQy2TRM/1cJBorYscnPTLA/rl6Hu7BuH+GgB2DbuiAXZ7czK+ujTkRFf2ls4lrHVMuMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SI6PwCXk; arc=none smtp.client-ip=95.215.58.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SI6PwCXk"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KnS4FREeAKzpHL8fFTZa5rjNeAMn6U9PigOahw3tm9s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789033407; v=1; x=1789638207;
 b=SI6PwCXkC1akEW66K7nj/nSDItlzqc/zNXEBhaycSP6a5qG1RSmqteUxDI4BzptTdAj310Zl
 gLU7iseREFdm69afWBD432Qv1s4FxbZWMzIN+OwYUw7pGiYXAoWyl1W5rTRx47K7kwGoTNLcM6b
 eS28VOij3fD9lBCqdHtM8Wmc=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f283204ef0f696d7;
	Thu, 10 Sep 2026 09:43:27 +0000
X-Mizu-Trace-ID: f283204ef0f696d7
X-Migadu-Flow: FLOW_OUT
Message-ID: <95330c25-d5ed-4e5d-8f62-528df543f8f3@linux.dev>
Date: Thu, 10 Sep 2026 17:43:19 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] net/sched: act_ct: set net pointer before publishing
 flowtable
To: Qingfang Deng <qingfang.deng@linux.dev>
Cc: netfilter-devel@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
 Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260909075606.1508155-1-qingfang.deng@linux.dev>
 <fa0181b9-d715-41c6-8086-af410ee4131b@linux.dev>
 <94103430-c2e8-491d-880c-c4690c5e3f98@linux.dev>
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
In-Reply-To: <94103430-c2e8-491d-880c-c4690c5e3f98@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/10/26 5:03 PM, Qingfang Deng wrote:
> Hi,
>
> On 2026/9/10 14:09, Xuanqiang Luo wrote:
>>> nf_flow_table_init() adds the flowtable to the global flowtables list.
>>> However, tcf_ct_flow_table_get() sets the table's network namespace 
>>> only
>>> after that call, leaving a window where the published table has a NULL
>>> namespace pointer.
>>
>> The window does exist, but can any existing code path actually read
>> flowtable->net during this window? Could you also describe that path
>> in the commit message? 
>
> There's none. The patch is a preparation for:
> https://lore.kernel.org/netfilter-devel/20260909081705.1512600-1-qingfang.deng@linux.dev/ 
>
>
Thanks for clarifying.

Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Thanks,
Xuanqiang
