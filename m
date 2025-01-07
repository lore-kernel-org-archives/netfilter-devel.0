Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933091547D2;
	Tue,  7 Jan 2025 22:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736289545; cv=none; b=M23ZiWp0BmHepEbcdwUrvQ5oUVKh2ogEs08CRcFYy6DSbt3xBFUhC54vpehCMCspu+OKSHRrvIOV0G2TOT0nmbhYBGtHzpHA81Z0NIvIYAKTg1UAsuNty0o8JnGfbLlWPg+qYYHp7Zat+1kXUKZwDERtMR6Xsu6NApOH1CyQF8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736289545; c=relaxed/simple;
	bh=Qa8LA5Y5xgNZmvmGtgICbFuXajYj3IhqCQdFnKNpyME=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=T83V+ZsdR6w0FY2BN379EigqMEY7OF2pPMYS7h52JI7iHqhlk+ak2CfboZ59zjC1XhQ7HPFvhVQZvDS7wM8QDioC1okADZkrEpgW7HOL6zg5Jt//h6eaUvGIXN10TK0Oj0Gx0H7ToFjfRlBBoc5pVrn8b3j9eF6xp4890XCEVkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 493C51003C1BC3; Tue,  7 Jan 2025 23:38:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 479281100AD650;
	Tue,  7 Jan 2025 23:38:54 +0100 (CET)
Date: Tue, 7 Jan 2025 23:38:54 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
cc: Jozsef Kadlecsik <kadlec@netfilter.org>, fw@strlen.de, pablo@netfilter.org, 
    lorenzo@kernel.org, daniel@iogearbox.net, leitao@debian.org, 
    amiculas@cisco.com, davem@davemloft.net, dsahern@kernel.org, 
    edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/10] netfilter: Add message pragma for deprecated
 xt_*.h, ipt_*.h.
In-Reply-To: <0e51464d-301d-4b48-ad38-ca04ff7d9151@freemail.hu>
Message-ID: <n72qp2s8-00q1-3n32-n600-p59o2oqo7s43@vanv.qr>
References: <20250107024120.98288-1-egyszeregy@freemail.hu> <20250107024120.98288-10-egyszeregy@freemail.hu> <1cd443f7-df1e-20cf-cfe8-f38ac72491e4@netfilter.org> <0e51464d-301d-4b48-ad38-ca04ff7d9151@freemail.hu>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Tuesday 2025-01-07 23:06, Szőke Benjamin wrote:
>> 
>> I still don't know whether adding the pragmas to notify about header file
>> deprecation is a good idea.
>
> Do you have any other ideas how can you display this information to the
> users/customers, that it is time to stop using the uppercase header files then
> they shall to use its merged lowercase named files instead in their userspace
> SW?

``__attribute__`` is just as implementation-specific as ``#pragma``, so it's
not really an improvement, but here goes:

----
struct __attribute__((deprecated("This header file is deprecated"))) dontusethisstruct {
};
extern struct dontusethisstruct undefinedstruct;
----
