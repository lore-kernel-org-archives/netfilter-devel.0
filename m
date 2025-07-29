Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E644C1DE3BE
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 01:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753752131; cv=none; b=guBRPsSCrvuhcE/rzcHVK5L3LYaG6Pyoa4UjlyqgXiQQNT20NdTilUmepCaDGbuG73K/Pkr0v/Mby6SqAc9ZBA2zh/9NPMLdOHBmZNeLdT6X9CWRv4i/iZLYZtAGH6B/cMVmis81mxKMvhR+MDGUdxaAKMuNj1TTkHj78a6nKWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753752131; c=relaxed/simple;
	bh=IyWVg6fv6jorhhnIZt/1wvfudukMy1aGNscDyyEBtYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u6YsTaCxJ8vwL9bsGIL5f5bvTGMwP0JX3CYhSN3MY6sROvDOdN4y7WDZk1o8/SQj9lbklVV6aAuBy462AOMvRKZtI38s92I0yjrUSDrLz5fdIOnTI62kFdeA8T/cErnoOz+2G6BY29H92V+Jnp/qj1w+CI9lxly4GCc4smtKEZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WgE/WML7; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WgE/WML7"
Message-ID: <b36532a2-506b-4ba5-b6a3-a089386a190e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753752116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GWpYFOkLsYnJ9p2ZFvtVNIwL5tEHltSN8BWwkp1apnw=;
	b=WgE/WML74rD1+eaiOmDCUACg4lRY0yiI97gO1U4BTY+WlYmnjBk9GHu9qMOaIEi7E9661E
	S6cdKz7drn5/cAPiiOk2+WOqIqzMlsmvrqZ57k2/fAFBTZcCx12xuwzV1XRIYMfDmU4xlF
	Y08DWk+rPUj6rmDlY7FOadBKFtCNm+s=
Date: Mon, 28 Jul 2025 18:21:50 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 0/4] bpf: add icmp_send_unreach kfunc
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: alexei.starovoitov@gmail.com, andrii@kernel.org, ast@kernel.org,
 bpf@vger.kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
 fw@strlen.de, john.fastabend@gmail.com, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
 pablo@netfilter.org, lkp@intel.com
References: <202507270940.kXGmRbg5-lkp@intel.com>
 <20250728094345.46132-1-mahe.tardy@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20250728094345.46132-1-mahe.tardy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 7/28/25 2:43 AM, Mahe Tardy wrote:
> Hello,
> 
> This is v3 of adding the icmp_send_unreach kfunc, as suggested during
> LSF/MM/BPF 2025[^1]. The goal is to allow cgroup_skb programs to
> actively reject east-west traffic, similarly to what is possible to do
> with netfilter reject target.
> 
> The first step to implement this is using ICMP control messages, with
> the ICMP_DEST_UNREACH type with various code ICMP_NET_UNREACH,
> ICMP_HOST_UNREACH, ICMP_PROT_UNREACH, etc. This is easier to implement
> than a TCP RST reply and will already hint the client TCP stack to abort
> the connection and not retry extensively.
> 
> Note that this is different than the sock_destroy kfunc, that along
> calls tcp_abort and thus sends a reset, destroying the underlying
> socket.
> 
> Caveats of this kfunc design are that a cgroup_skb program can call this
> function N times, thus send N ICMP unreach control messages and that the
> program can return from the BPF filter with SK_PASS leading to a
> potential confusing situation where the TCP connection was established
> while the client received ICMP_DEST_UNREACH messages.
> 
> Another more sophisticated design idea would be for the kfunc to set the
> kernel to send an ICMP_HOST_UNREACH control message with the appropriate
> code when the cgroup_skb program terminates with SK_DROP. Creating a new
> 'SK_REJECT' return code for cgroup_skb program was generally rejected
> and would be too limited for other program types support.
> 
> We should bear in mind that we want to add a TCP reset kfunc next and
> also could extend this kfunc to other program types if wanted.

Some high level questions.

Which other program types do you need this kfunc to send icmp and the future tcp 
rst?

This cover letter mentioned sending icmp unreach is easier than sending tcp rst. 
What problems do you see in sending tcp rst?

