Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B044A27AC50
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754063684; cv=none; b=SPgwxlCEQvgKeJUrWs8ibrH1X7PTxp3XDqp7K6/1dzsq8X39m0clrzq6Deb3nAFvRswjwaFqKRjrfxjH1GYFpmVzZrsiaF4CtGyNOBY40vM+j4FVtoFEqaYl2gKUDm84AAGRXpcf/hwIV7+CXoNk64Ee0gUr+W5i0H4bxsnhfMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754063684; c=relaxed/simple;
	bh=R0sWKuJzzCsnYBn2G19Zby89bF8xLTfAk4Ms8HmqqpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AUulWBNsQoMXK9P6E+yXETi6jwwBwMmtlwA4Sz6fCGDo4ajPicuj95ymjExmosJUIzHDUFnFb4ulpB2KggZ5Ek8gFFrAClcOdRf7q6sYoIkkjg7bEIUuJ0eCbOLZeg9kanm6Ac+Qv4VAicSNKB6B4peiyhbrz3sgXE6u5GKL8uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QtPP2BIY; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QtPP2BIY"
Message-ID: <5960cc57-6f40-42b5-9d51-288a2e7101c0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754063680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R0sWKuJzzCsnYBn2G19Zby89bF8xLTfAk4Ms8HmqqpE=;
	b=QtPP2BIYAqcRoDJ7f6JHNKsiMUL4cOoFyZArgt+zwIRW6QY3eFCvoODf3QBcVWVAFbQtbO
	2dnQPKTCJp1Dv4mykxL7nJ6gEnDXmjHdmf4UzlzoSbdad0GQkkPPOO/ECsD8H6dVpwMmrc
	X6Wcn2lTzQh1ZsrLIW/fCuBeVpljz5Q=
Date: Fri, 1 Aug 2025 08:54:35 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf 2/4] bpf: Check netfilter ctx accesses are aligned
Content-Language: en-GB
To: Paul Chaignon <paul.chaignon@gmail.com>, bpf@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>, Martin KaFai Lau
 <martin.lau@linux.dev>, netfilter-devel@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Petar Penkov <ppenkov@google.com>,
 Florian Westphal <fw@strlen.de>
References: <cc1b036be484c99be45eddf48bd78cc6f72839b1.1754039605.git.paul.chaignon@gmail.com>
 <853ae9ed5edaa5196e8472ff0f1bb1cc24059214.1754039605.git.paul.chaignon@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <853ae9ed5edaa5196e8472ff0f1bb1cc24059214.1754039605.git.paul.chaignon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 8/1/25 2:48 AM, Paul Chaignon wrote:
> Similarly to the previous patch fixing the flow_dissector ctx accesses,
> nf_is_valid_access also doesn't check that ctx accesses are aligned.
> Contrary to flow_dissector programs, netfilter programs don't have
> context conversion. The unaligned ctx accesses are therefore allowed by
> the verifier.
>
> Fixes: fd9c663b9ad6 ("bpf: minimal support for programs hooked into netfilter framework")
> Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>

Acked-by: Yonghong Song <yonghong.song@linux.dev>


