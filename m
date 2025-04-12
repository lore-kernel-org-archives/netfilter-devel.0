Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4FA197A7A;
	Sat, 12 Apr 2025 21:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744492592; cv=none; b=OA45PdIPrKhPdUxynBbDQgniqvIAfbfZYZZQpPQJ/b5yk1GBpbBoNou0krB+hQYFJwtm8N0Y7gQIbbBaGJ3So7KO2rdq38O1hnSPCWSbJ0V8xwGmoWvhKS+dG/MDFLtrwVjTp2KlZrwet+uhSE+hK+3eR+rV3e0wJZ94QbpTOjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744492592; c=relaxed/simple;
	bh=LSm8n2JgBGQCeORLX5c07y6Iq9IWghBzRfmMe+pyr3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OYvC5ncCvOWdh8ccABVcHMsUmrnkM0qpf7ASrXzhGUV1XPmOTfg2sckUlYKhqmSjBUaTu+1urBV7TVxORkTW6r5JZkXPSv7zw+15pxD0MJlgsWpdcQy9W0LmRBy+2efNWcPmTlArw47zNWjo9RsDnnSLeau6fYg/kLfS1JLT9TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TA7ONDyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TA7ONDyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B05FC4CEE3;
	Sat, 12 Apr 2025 21:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744492591;
	bh=LSm8n2JgBGQCeORLX5c07y6Iq9IWghBzRfmMe+pyr3Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TA7ONDyjxdZCdBDb304gFf4xzIuDoNv4zFL/14N8yKiQiINbcs6ZdPsWT437tuL5G
	 0/myzNd7c8OfzqRDn/NXTAbe8KKaLPwMXQyFA8VqCJRcYXODdECAJjHavyW9yywiZw
	 VHXql/6NMZApCD0E7QUY7h19ALR81BsqMuopDbXZ1W+Wjgp4EtMFgj6/Oa2uzfDX0s
	 uZI831l0pMfyXQ01/0B661njG+ox4K3tG7VCTGHUlkiMKfHuyaDyNjSaM6eQlE3Mnm
	 X5yCIUCl3qzyDFKtjr2F4QEZ4lLz0XxwPtTGHXyTQntCaIsEbqdf1gMBYiMHFvKuJY
	 gcNACIKN2egNg==
Date: Sat, 12 Apr 2025 14:16:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: lvxiafei <xiafei_xupt@163.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
 horms@kernel.org, kadlec@netfilter.org, linux-kernel@vger.kernel.org,
 lvxiafei@sensetime.com, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org
Subject: Re: [PATCH V5] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <20250412141630.635c2b34@kernel.org>
In-Reply-To: <20250412172610.37844-1-xiafei_xupt@163.com>
References: <20250407095052.49526-1-xiafei_xupt@163.com>
	<20250412172610.37844-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 13 Apr 2025 01:26:10 +0800 lvxiafei wrote:
> +static inline unsigned int nf_conntrack_max(const struct net *net)
> +{
> +	return likely(init_net.ct.sysctl_max && net->ct.sysctl_max) ?
> +	    min(init_net.ct.sysctl_max, net->ct.sysctl_max) :
> +	    max(init_net.ct.sysctl_max, net->ct.sysctl_max);

If you CC netdev@ please do not post multiple versions a day.
Please wait with posting v6 until you get some feedback (and
this email does not count).

You need to be careful with the Kconfig, this file may be included=20
when contrack is not built:

In file included from ./include/linux/kernel.h:28,
                 from ./include/linux/cpumask.h:11,
                 from ./arch/x86/include/asm/cpumask.h:5,
                 from ./arch/x86/include/asm/msr.h:11,
                 from ./arch/x86/include/asm/tsc.h:10,
                 from ./arch/x86/include/asm/timex.h:6,
                 from ./include/linux/timex.h:67,
                 from ./include/linux/time32.h:13,
                 from ./include/linux/time.h:60,
                 from ./include/linux/compat.h:10,
                 from ./include/linux/ethtool.h:17,
                 from drivers/net/vrf.c:12:
include/net/netfilter/nf_conntrack.h:365:25: error: =E2=80=98struct net=E2=
=80=99 has no member named =E2=80=98ct=E2=80=99
  365 |             min(init_net.ct.sysctl_max, net->ct.sysctl_max) :
      |                         ^
