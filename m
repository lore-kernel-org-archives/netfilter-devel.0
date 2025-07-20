Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40ADA930
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Jul 2025 16:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753030518; cv=none; b=GAY4YE4GEAJMOCny+o6bp4Q5RzABLEmBsR7m+XO9ChagC6QsNk05tsUKCy9QuWh0L3FZ7xMc7uEVX2nOXo2cspkYb+mniKQmkFVBn1hPaY1nOcyH/KiRJJurW78rlYpm5g13kmLM6Hegc9g0oAV5ujcHyWh+JJYGOH/JwaHJHaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753030518; c=relaxed/simple;
	bh=nFhs36PsggzZ2S4l9X3zF8agI99OSEplT6czX5kHmS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XUT5iT7S0CYNCZZ9BsQj/b3SJYE4+7O3h2okGH7NTFdpKbU0CxElXAigesQ8XQwZ5p7k++6QILOD4BrmNHR+MIIHk6PKTWLgCkqZ0GKv3josUXVpWAk8GYvS93U+6V/5N2h5xWYOs8H0ePpMGqVEZnO8tHLFGxwRfWtS+SjD5PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ofP0STnR; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ofP0STnR"
Message-ID: <4105903a-470c-4808-b0b8-aa32eb36191d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753030504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNDS5QyE6DXcHr+EMDsjwO4EjpUASLLtOxWcFEtzaAE=;
	b=ofP0STnR6yKsGLz69L8WJNemTHWD6p+3iwl/GXebUAqJ5MvnbP2Dt8mpy2iQ780326Gyst
	1niJnluSQ1kHb7xN0GY4dBJGYV9TgJKCqkZOIABCYLijWYyj2d8RHVkxVcHxNGL6wwqcLz
	0HqjIEyyE2tEecS6DWoSUUVwyWlksYg=
Date: Mon, 21 Jul 2025 00:54:50 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next] netfilter: bpf: Disable migrate before bpf_prog
 run
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Florian Westphal <fw@strlen.de>,
 netfilter-devel <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
 Network Development <netdev@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 syzbot+92c5daf9a23f04ccfc99@syzkaller.appspotmail.com
References: <20250718172746.1268813-1-chen.dylane@linux.dev>
 <CAADnVQKMVJ_2SMcm0hvg2GDc-RPVU7GVAWRqbSdGn2ZtwUbUng@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Chen <chen.dylane@linux.dev>
In-Reply-To: <CAADnVQKMVJ_2SMcm0hvg2GDc-RPVU7GVAWRqbSdGn2ZtwUbUng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2025/7/19 02:25, Alexei Starovoitov 写道:
> On Fri, Jul 18, 2025 at 10:30 AM Tao Chen <chen.dylane@linux.dev> wrote:
>>
>>
>> The cant_migrate() check in __bpf_prog_run requires to disable
>> migrate before running the bpf_prog, it seems that migrate is
>> not disabled in the above execution path.
> 
> bpf@vger mailing list exists, so that developers
> read it and participate in the community.
> 
> https://lore.kernel.org/bpf/20250717185837.1073456-1-kuniyu@google.com/
> 
> --
> pw-bot: cr

well, since it's already under review, I'm happy to drop my version. Thanks.

-- 
Best Regards
Tao Chen
