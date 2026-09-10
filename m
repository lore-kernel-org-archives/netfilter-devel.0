Received: from mta1.migadu.com (out-68.mta1.migadu.com [95.215.58.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5640C390987
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 06:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789020582; cv=none; b=A/hUBl0zTglVo80GkM1uSgfI1/KqF+6YlC1F6IktJYv0PnMZjLA1yjklJ04prqSrDZrW+qa8qf2v748AkXQPy7ZF9BmH7lYcNjbX1KEEt91XOUF2BYXq/wwUcHO0xKAuddm5hC1Bj20tMvq6a5fHnV06QE0uL8uvkoiXaIq7G6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789020582; c=relaxed/simple;
	bh=3HCylPQKsJ8fUNFwZtSlf0bSntqmGVxL++6F/eBsEyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=aIUc+Qo91w6kd3YOqEs4EqOEeiFCCzuAxOpqFRp4OlBEQnmpRE0Kzz+xUw0FTQFF4hsK2I9/s+2N6pkayCjdCMbP5NTWikpkko5jAz593WM+ydjRfTyG09UUoANAUEcFVnO0U7B/xFQnry4wCfxfpwjW4FMDoYroR/Ps8p/dQTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tWD1akzZ; arc=none smtp.client-ip=95.215.58.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tWD1akzZ"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3HCylPQKsJ8fUNFwZtSlf0bSntqmGVxL++6F/eBsEyk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789020570; v=1; x=1789625370;
 b=tWD1akzZtMLkfbT9ggj2f1pwGykNKiEdiQP/STXZRYpWaJ7P6Qrl7kr7Ole1+I8wjlOlSwgI
 nM6SqhWV1xwLxqQ9AlAnZr+YCCRjQORShZROvXTNRjL3xKW1SEtPDZV2YByD5z4tEjqOwCOLej+
 7mW6KjYYRHz+WX+bmX+ByZyo=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 11fc99cf0e5798a2;
	Thu, 10 Sep 2026 06:09:30 +0000
X-Mizu-Trace-ID: 11fc99cf0e5798a2
X-Migadu-Flow: FLOW_OUT
Message-ID: <fa0181b9-d715-41c6-8086-af410ee4131b@linux.dev>
Date: Thu, 10 Sep 2026 14:09:25 +0800
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
References: <20260909075606.1508155-1-qingfang.deng@linux.dev>
Cc: netfilter-devel@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
 Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
In-Reply-To: <20260909075606.1508155-1-qingfang.deng@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> nf_flow_table_init() adds the flowtable to the global flowtables list.
> However, tcf_ct_flow_table_get() sets the table's network namespace only
> after that call, leaving a window where the published table has a NULL
> namespace pointer.

The window does exist, but can any existing code path actually read
flowtable->net during this window? Could you also describe that path
in the commit message?

Thanks,
Xuanqiang

