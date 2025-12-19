Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BB0320CA8;
	Fri, 19 Dec 2025 13:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766151589; cv=none; b=H58YsCxygitMdJxO3GJ4O0SmalZM1CcizemjU/nmVw2KRKm5G7xFtw1CyShWMdl6EENVhCql3Z2taxIOciFcZfQK+zYXPZJOoalEmuPdxY5B7MX8imYLakhYg/vmerPmiCzOY0dW2Gr7SIDepuoIGZWvZqWNhVLO2K6plhoCUms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766151589; c=relaxed/simple;
	bh=B7gy/6fcyRRQm9I3gjotnDVopYfBrxz7/tSUiK+f0lE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SEmNZEBjgxxqCAhF+eQtFhVoGV0sL64d6rHPDyMAOyEPFS3DFADEgc8CRt1j4LPfiLUEHIj8mc/HC6CrU6BcGZZcyLiOevj9f3UpPHbv1yqEkfzkuXfpsw51ZLITBHE7tb9XImdUQBHUw//S24pZVagIY7R8TrmRbwoHJLdXvcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umgsFRhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umgsFRhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BFCC116C6;
	Fri, 19 Dec 2025 13:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766151588;
	bh=B7gy/6fcyRRQm9I3gjotnDVopYfBrxz7/tSUiK+f0lE=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=umgsFRhI/tLq/rGjvhZY5yLoaa2+cNDKAXbkW3WzgyHCXYgck6ifXVN5uPuIJzrkh
	 4jR745ZgRXCOhaX0KQPU3DcLIWgAyXfHH99ge2mjBhdzluWGNL6raJ46Htrnijns6h
	 v+08m1gkz6mzrbNz9cfpBt4/5/XGEZUuWvnBRwF/uOS46QBI40bWJYKubEDnuwq8nk
	 h7A/N8h6LdwdqnSD1K6pZPH1NmihIl1gQMoJ/i+qBPaI3sB313iAQmhI6ZU5ONfhwR
	 0xjhUJkOGazBQyjM1l6YNPSqKtSlvtRfOXhbSiQ4126+w7FSnWOddtb6DCTHDITaGx
	 gPIlsmJ6Uh60Q==
Message-ID: <fdb9f97d-7813-48a0-9fdf-ddc039d853eb@kernel.org>
Date: Fri, 19 Dec 2025 14:39:40 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Daniel Gomez <da.gomez@kernel.org>
Subject: Re: [PATCH] netfilter: replace -EEXIST with -EBUSY
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
 Petr Pavlu <petr.pavlu@suse.com>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, Lucas De Marchi <demarchi@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 Daniel Gomez <da.gomez@samsung.com>
References: <20251219-dev-module-init-eexists-netfilter-v1-1-efd3f62412dc@samsung.com>
 <aUUDRGqMQ_Ss3bDJ@strlen.de>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
Organization: kernel.org
In-Reply-To: <aUUDRGqMQ_Ss3bDJ@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/12/2025 08.48, Florian Westphal wrote:
> Daniel Gomez <da.gomez@kernel.org> wrote:
>> From: Daniel Gomez <da.gomez@samsung.com>
>>
>> The -EEXIST error code is reserved by the module loading infrastructure
>> to indicate that a module is already loaded. When a module's init
>> function returns -EEXIST, userspace tools like kmod interpret this as
>> "module already loaded" and treat the operation as successful, returning
>> 0 to the user even though the module initialization actually failed.
>>
>> This follows the precedent set by commit 54416fd76770 ("netfilter:
>> conntrack: helper: Replace -EEXIST by -EBUSY") which fixed the same
>> issue in nf_conntrack_helper_register().
>>
>> Affected modules:
>>   * ebtable_broute ebtable_filter ebtable_nat arptable_filter
>>   * ip6table_filter ip6table_mangle ip6table_nat ip6table_raw
>>   * ip6table_security iptable_filter iptable_mangle iptable_nat
>>   * iptable_raw iptable_security
> 
> But this is very different from what 54416fd76770 fixes.
> 
> Before 54416fd76770. userspace can make a configuration entry that
> prevents and unrelated module from getting loaded but at the same time
> it doesn't provide any error to userspace.
> 
> All these -EEXIST should not be possible unless the module is
> already loaded.

I see.

> I'll apply this patch but its not related to 54416fd76770 afaics.

Thanks.

Then, what about removing that paragraph that mentions the commit and add
something like:

Replace -EEXIST with -EBUSY to ensure correct error reporting in the module
initialization path.
