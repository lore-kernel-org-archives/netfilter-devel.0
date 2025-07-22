Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0A728A714;
	Tue, 22 Jul 2025 23:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753225408; cv=none; b=B9EtaXJaD/HHwsF6wcccrlxYV8zlzU4o9yyJeSUp6I4antf+w4bp6xKalTI3F9X7Q6JS8qs/3JVbRireoLkxHNc2VQmTEiCZE0MniZHXpf3gCkQ7d0iAFn55vpZz0m5UE1CE+aqbCehvb9sZN3K2Kd20kt8DJS3H2MzNeKAFxM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753225408; c=relaxed/simple;
	bh=B6nPUTIP3USxcbirTYQcqoYaw7qcoH4UsXnI0FAqQLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSXCcqZQw/XI9XjwvnRpm43TT/qHqQJoo+M/XfAmqdVlgMAzfj6zqw8C5x4nBqBqxpsCL9dFkzyVym4uoOavR/Qnuwc6jJO2Bnpcil88l8AlaCd3hM1bFD2WDCDcu7rU2+PUEOLxYsZ9iMZLDVUe4sa5IPX1jY7auC1s4920R9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B234C60491; Wed, 23 Jul 2025 01:03:17 +0200 (CEST)
Date: Wed, 23 Jul 2025 01:03:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	syzbot+40f772d37250b6d10efc@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 bpf] bpf: Disable migration in nf_hook_run_bpf().
Message-ID: <aIAYrGxkWZyfiwYh@strlen.de>
References: <20250722224041.112292-1-kuniyu@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722224041.112292-1-kuniyu@google.com>

Kuniyuki Iwashima <kuniyu@google.com> wrote:
> syzbot reported that the netfilter bpf prog can be called without
> migration disabled in xmit path.
> 
> Then the assertion in __bpf_prog_run() fails, triggering the splat
> below. [0]
> 
> Let's use bpf_prog_run_pin_on_cpu() in nf_hook_run_bpf().

Acked-by: Florian Westphal <fw@strlen.de>
