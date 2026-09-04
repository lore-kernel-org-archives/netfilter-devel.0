Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E9050C2B7;
	Fri,  4 Sep 2026 16:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788540953; cv=none; b=esv+En1jVWAWbbfRjb7x4nGAsHqN8tT9epg+s+XYrEMvjx7q3qe6CKSAfStfIkZcwvYTlIfx55FYQvyuL49DltzEC4eUROM/oQkUC+evwS95gboGOJrYYjwfBUaCj7026BEaFnHOb7gVXjlSLIaYqhj86sVgueScG5TyCrU90SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788540953; c=relaxed/simple;
	bh=PMKRteyqCXyoT9j2cQ6OndqOm2Znk0k8aZ/GwApvEKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FccFe2N4YnUxdE07uUxoTxMuIiat2NKzP7/HgGuVpvWLxcLVr0VmcILFishWP3w+iRV1atrSFm8YbTdsGHqLqkcmuKoDPehJWeJupGVULBWA7unA2zHmGqRGEtU08vf9vE2Te5iPwOqlyZcn40pwxukULQixu8fgHxJ3IlVnXxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elx3YIa1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elx3YIa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8631F00A3D;
	Fri,  4 Sep 2026 16:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788540950;
	bh=1caeJ4CBjFZSEixrsLbgrXs0FWOuP0V+WtvS5rQmTwk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=elx3YIa1UmECc6XcWgUzuUoENTeFEaSvXhXKx5/wy+KO8TgsJhIwSii3mQTTESX7v
	 e5VB6xj6d1RBPVaOpUJQVczODEWvU26SNw1FgCUl3dgfIbzg+7KWrg76RdLCl1LsWz
	 g9sxWWich6b55LjLx2WjhAVG2HirNEB7mvhwI3Bu4QgZq8piomOpcy1MP00M89RFF0
	 U1dYp/3r4bdIuOqTrn/GS0VwRfCmg2Cv053z9fyu7dxBlQO2X8mXeiubzSz5VouaQQ
	 eUcC/DVzrAhgWkomBTpg1p8tuV1jp9ZtqRs3HskBSeMy9Ipitgo7YpSI82z2R/gQh2
	 NhRCmFXfY/B6w==
Message-ID: <3ce5323e-18a5-41d0-860b-588b79074589@kernel.org>
Date: Fri, 4 Sep 2026 18:55:43 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net 1/2] selftests: netfilter: use KHDR_INCLUDES in CFLAGS
Content-Language: fr
To: Ilya Maximets <i.maximets@ovn.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260904-net-sft-nf-khdr_includes-v1-0-92455af428e9@kernel.org>
 <20260904-net-sft-nf-khdr_includes-v1-1-92455af428e9@kernel.org>
 <5d871ca2-1db4-47b8-bd48-34b3fa42961e@ovn.org>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <5d871ca2-1db4-47b8-bd48-34b3fa42961e@ovn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ilya,

On 04/09/2026 18:41, Ilya Maximets wrote:
> On 9/4/26 6:13 PM, Matthieu Baerts (NGI0) wrote:
>> KHDR_INCLUDES is typically used to include headers from the kernel
>> source directory instead of only relying on the ones from the host: they
>> can be missing or outdated.
>>
>> The kselftest doc recommends assigning KHDR_INCLUDES to CFLAGS in a
>> target Makefile. lib.mk will set KHDR_INCLUDES to "-isystem
>> $(top_srcdir)/usr/include" if the user didn't set it, e.g. if the kernel
>> was built in a different build directory.
>>
>> Other net targets have KHDR_INCLUDES added to their CFLAGS.
>>
>> Fixes: 3f189349e52a ("selftests: netfilter: move to net subdir")
> 
> I think, this should point to a commit that added the first C test:
> 
> Fixes: a64d558d8cf9 ("selftests: netfilter: add nfqueue test case")

Good catch! I saw that CFLAGS was set before, but indeed, KHDR_INCLUDES
wasn't.

If we want to change the Fixes tag, we will also need to add:

Fixes: a52540522c95 ("selftests/landlock: Fix out-of-tree builds")

Which is when KHDR_INCLUDES got introduced. (Or it is enough with the
current Fixes tag, as long as it is included in the last stable version:
that's probably enough for CIs using kselftests from the last stable
version on older ones.)

@Net maintainers: please tell me if I need to change the Fixes tag in a v2.

>> Link: https://docs.kernel.org/dev-tools/kselftest.html#contributing-new-tests-details
>> Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
>> ---
>>  tools/testing/selftests/net/netfilter/Makefile | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
>> index f88dd4ef8d26..df3c20c90f5d 100644
>> --- a/tools/testing/selftests/net/netfilter/Makefile
>> +++ b/tools/testing/selftests/net/netfilter/Makefile
>> @@ -2,6 +2,8 @@
>>  
>>  top_srcdir = ../../../../..
>>  
>> +CFLAGS += $(KHDR_INCLUDES)
>> +
>>  HOSTPKG_CONFIG := pkg-config
>>  MNL_CFLAGS := $(shell $(HOSTPKG_CONFIG) --cflags libmnl 2>/dev/null)
>>  MNL_LDLIBS := $(shell $(HOSTPKG_CONFIG) --libs libmnl 2>/dev/null || echo -lmnl)
>>
> 
> This solves my problem with building netfilter tests locally with uAPI
> modifications.  Beside the Fixes tag, LGTM.
Thank you for having checked!

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

