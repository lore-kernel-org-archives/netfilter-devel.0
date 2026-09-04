Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E5751C34D;
	Fri,  4 Sep 2026 18:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788545605; cv=none; b=tGMNo1YvrEiYg7jVZPuADWeAktESEN9FDyev7Jtku+1XW3LaWALKAOGMJQLZTcBaUeowBhcs83NMVkd4MCPU4X0E5nMpLB6z1XeFDXqeALN+aMLKqSnDW1fljkBEGZa6VYrylnNmSTeqVUQ1EXnnFdUpF7V7pDUzBdKN7kkSBts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788545605; c=relaxed/simple;
	bh=Ln3gAUSzCB5HMVUDQiFq3TwODoT8YzzxNhNfCV04lRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M9HHRsmUrNww66q0z1GNCSUOdeVPmNxxZa5vV9smJcxCjwL4myi5ykYaBpFXLcRD92avcelngswjjSpR5Lc9NrGTzWtCJ7AE6Dky+f5dfCFKhugWkbyos7P1xdQMxH8jZZvusXg5+y0i2f1w3XqzIRoTml88Ng7OoRwoFgpyvPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBUJFiB7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBUJFiB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6991F00A3F;
	Fri,  4 Sep 2026 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788545604;
	bh=ObkFAWguM+b0ApnsFDARamSmV0+WgAi5JakfcjNI4Pc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IBUJFiB7tKI4sEXSQyjZhHQNLTbjxHUkWgbvMo/ZmodXN/f9zK8LURJmtGiiPf1YM
	 GBGjphFMyroVfDlFCD43i3OeeE9loubfrOse9QSgV+t2Nv8uxfuW3E5x7k39EskcTB
	 e+911pBnEDUn9rHkUKeaJ5USW+dbRkVzpzuOO274am3hf83K1P85pld8WFcznoEhyG
	 h48SemBTIQjK7FrwmJkZE0xXL5hEbBGNF/gUtO4O/tNBcMAgdLZPkdofuLXSj8cp6n
	 E6QNt0vh6oIxE6f6BrL7pNe1Kwrnye0POng8HrCeVa2y8gBCRVCVx94RbNW/aMwHdk
	 NfwEvpiLBkkJg==
Message-ID: <b51812fb-3140-4dd5-8fdb-3715616e3bcc@kernel.org>
Date: Fri, 4 Sep 2026 20:13:17 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH nf-next] netfilter: conntrack: make filtering by zone
 discoverable
Content-Language: fr
To: Ilya Maximets <i.maximets@ovn.org>, netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 Shuah Khan <shuah@kernel.org>, =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?=
 <ast@fiberby.net>, "Remy D. Farley" <one-d-wide@protonmail.com>,
 linux-kernel@vger.kernel.org, coreteam@netfilter.org,
 linux-kselftest@vger.kernel.org
References: <20260904174452.1913072-1-i.maximets@ovn.org>
 <35704da5-5a12-4b23-b684-dcadc432a380@ovn.org>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <35704da5-5a12-4b23-b684-dcadc432a380@ovn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/09/2026 20:06, Ilya Maximets wrote:
> On 9/4/26 7:44 PM, Ilya Maximets wrote:
>> Conntrack flush supports filtering by zone using CTA_ZONE, but this
>> attribute is really hard to use from user space applications.  The
>> reason is that it is not possible to tell if it's supported or not.
>>
>> Older kernels silently ignore CTA_ZONE.  And in that case they just
>> happily flush all the entries from all zones breaking all the existing
>> connections.  So, applications have to infer support from the kernel
>> version.  While it works in most cases, it's not a particularly
>> reliable or desired way to check kernel capabilities from applications
>> that aim to be portable.  There should be a better way to probe or
>> discover features in the kernel.
>>
>> The CTA_FILTER interface on the other hand is simple enough to probe.
>> We can check for NLM_F_DUMP_FILTERED in the dump to see if filtering
>> is supported.  And unknown sub-attributes in CTA_FILTER are rejected
>> explicitly since strict validation is in use there.
>>
>> Let's add new CTA_FILTER_ZONE that signals that CTA_ZONE should be
>> filtered on.  It is a flag, since everything in the CTA_FILTER is a
>> bit mask, i.e., a form of a flag.  If set, it means that CTA_ZONE must
>> be present and be used for filtering.  If the flag is not set however,
>> the filtering on CTA_ZONE will still take place to ensure backwards
>> compatibility.  So, the flag doesn't really change the filtering
>> behavior, but it allows user space applications to properly discover
>> support for CTA_ZONE filtering without need to rely on kernel version
>> parsing or risk accidental flushes of the entire conntrack table,
>> and also without modifying the kernel state.
>>
>> A new test variant is added to test with and without the new flag.
>> Since the setup code is moved into a shared function, expectations
>> replaced with assertions to bail early if the base setup fails to
>> avoid the cascade of secondary failures that can be misleading.
>> Error return is only for the SKIP cases.
>>
>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>> ---
> CI reported a build failure for the selftest.  It is caused by this issue:
>   https://lore.kernel.org/r/20260904-net-sft-nf-khdr_includes-v1-1-92455af428e9@kernel.org
> 
> Not related to the patch itself.

Mmh, my patch didn't get picked up in the tests because the Clang build
failed with Rust programs. Not sure why it got that with my patch, nor
why your patch didn't hit the same issue :)

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

