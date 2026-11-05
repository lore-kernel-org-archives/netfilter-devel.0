Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793888807;
	b=c1mLAw8weMNeGE6Ojs1dNkKWzJTM94bqP1UYiZ9p7t50qBbuqWhEO+0iM5otyKW3DL8H
	 A1VTb81H9di3Fqn8sLU5GiVYY11B3BF92csrqsnkqjEngAXEt5D+OxyMluTTjcRiAzcnm
	 Q+/n095ZxaYlsdSIR9Zqhr9X9Ijw6e0lb8s+zKhoWEawe+EZQ0SUl1HvOgtKD/LF5LjV1
	 zEtS3U0IHH4orZOoX02WTAuLreMFOtzr5Mwh7DtGG4o7dR7cNDOUb4Gch7UR4xEqPcCCj
	 phtFi+H1PbHGSt+JvdW/FJFowESnLRRgW1CIGtyRKcJEAdRGCDb6hslYN8P8fl7RHUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793888807;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=L8Rb50XkmO6XeB6blehC4ZCWZ4kvWegiRHR0v/W8P68=;
	b=wbJtP+Jmx8T15gJeif2REKqBIbBcC0yhD6VjOIMUOapUEI+Fvnuv9+4TCANGCO9jdQms
	 nsyakAc3UvjriNbSt7kakjclZzDFIfNDv8KntcOQt1GNfJokI/3Rwdu6XMTUryC1Ci+Hd
	 /51iSiwHMpDh0Qnz1L1GpXgZH/lZKYd9NdL/zNDJNWNfAWyFERf/e4ArCNyE7kf3yvWFL
	 JQlgwlFd5LdW6e5vEOugAxfqvCQjze5UmstB9BA3YeewPTmZUNMHT5YLF0t8YALn/UBxn
	 aDCGGYleL1fIjcMGiHifZh6XSVS4463aWb1ul0MhuQv175ph7JFUR43gCV2uXsxHynA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98080606A333;
	Thu,  5 Nov 2026 14:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98080606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 480B760380; Thu, 05 Nov 2026 15:26:44 +0100 (CET)
Date: Thu, 5 Nov 2026 15:26:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Dumazet <edumazet@kernel.org>
Cc: henry martin <bsdhenrymartin@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: fix pernet use-after-free on
 UNREGISTER rebroadcast
Message-ID: <auySI28pT75B4hWM@strlen.de>
References: <20261105114817.3033625-1-bsdhenrymartin@gmail.com>
 <aux2zX3dLKYnzG56@chamomile>
 <CAEnQdOox6ddd_GScf24z65bocnMvX0KHeDTju_8j3bzQjLi0HQ@mail.gmail.com>
 <CAL4Wiir+91dO7AVVq3O86bWu9NC+8Z+kFUeYveJqfW44-5ChvQ@mail.gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL4Wiir+91dO7AVVq3O86bWu9NC+8Z+kFUeYveJqfW44-5ChvQ@mail.gmail.com>

Eric Dumazet <edumazet@kernel.org> wrote:
> Instead of working around the problem, what about fixing it in the core?

> commit bbe8af9893694c807435178eb428c42d3305db97
> Author: Eric Dumazet <edumazet@kernel.org>
> Date:   Thu Nov 5 13:44:07 2026 +0100
> 
>     net: wait for in-flight device unregistrations before netns dismantle

Thanks Eric, that looks much more sensible.
