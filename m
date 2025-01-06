Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1361DE4C4;
	Mon,  6 Jan 2025 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736170816; cv=none; b=QgMqYMkJnD5Y4jmkfE2edWBucsthJNFaw8DEUIdk3eJnGDNyruCAlu3gT+QrYRcb5Bl27yw7VuYd/IqUT+uUlfK0Tgj8B4g3TW/FnIYrFIbxaB1tS7UNY+edYfHKPhfWQImSu54BaUrFBEpWYdiz3yg8+doW9bBQNYkABxr/88A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736170816; c=relaxed/simple;
	bh=4emKOfZ/O0yjFty8Iare45FHTZpCl2r2jU+8TaUtb8I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=C2y0s0a7CWcaEnILItCNpnlQLq3YzYfP1Cxajaf0+JhHlb2HKxnP5PA68YTgixlat4rmGsCj5rjAq6sAv8n4YLS+apFhOVNZ/BZfaMNP1Cm7Fw8yq0vFYP1TQYfbr3KShVatk0SyEbCwNaKhHVq8+wHhbelgsBeam9pkdIx4uNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=eVR47ZSy; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="eVR47ZSy"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 9BE0732E01CE;
	Mon,  6 Jan 2025 14:40:10 +0100 (CET)
Authentication-Results: smtp012.wigner.hu (amavis); dkim=pass (1024-bit key)
 reason="pass (just generated, assumed good)" header.d=blackhole.kfki.hu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=content-id:mime-version:references
	:message-id:in-reply-to:from:from:date:date:received:received
	:received:received; s=20151130; t=1736170808; x=1737985209; bh=o
	SPf0Psyc/TqoBccVQvmLVP/sXwAecmcaTnAxvPhyyw=; b=eVR47ZSyygFX5QXCP
	p+NQEEIcwSdJ8w+bF6dc1t03ozbQseJQWbzYFK4MqRFaMzeEmKPNczDyBoRRAxNf
	pmx5R+DswcVYUfkw/latnOY49NfJzSIIupElOhjXcow7uTI3LZYmh2YZ2+yYPF/j
	e62L40whgHd7yrJqc2jzIQWQcM=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id CC743cccf_DH; Mon,  6 Jan 2025 14:40:08 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 9792732E01CA;
	Mon,  6 Jan 2025 14:40:07 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 6FD9C34316A; Mon,  6 Jan 2025 14:40:07 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 6E623343169;
	Mon,  6 Jan 2025 14:40:07 +0100 (CET)
Date: Mon, 6 Jan 2025 14:40:07 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: =?ISO-8859-2?Q?Sz=F5ke_Benjamin?= <egyszeregy@freemail.hu>
cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>, 
    lorenzo@kernel.org, daniel@iogearbox.net, leitao@debian.org, 
    amiculas@cisco.com, kadlec@netfilter.org, 
    David Miller <davem@davemloft.net>, dsahern@kernel.org, 
    edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h
 files which has same name.
In-Reply-To: <33196cbc-2763-48d5-9e26-7295cd70b2c4@freemail.hu>
Message-ID: <f1f0e509-d14f-3731-0b44-3727dfdf18d9@blackhole.kfki.hu>
References: <20250105231900.6222-1-egyszeregy@freemail.hu> <20250105231900.6222-2-egyszeregy@freemail.hu> <8f20c793-7985-72b2-6420-fd2fd27fe69c@blackhole.kfki.hu> <33196cbc-2763-48d5-9e26-7295cd70b2c4@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-817496460-1736170753=:36632"
Content-ID: <683f5b24-6318-e169-2e5f-bc0c061c9ba8@blackhole.kfki.hu>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-817496460-1736170753=:36632
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-ID: <f1fa5e61-cfe6-ed0f-a975-ddc6644396cc@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable


On Mon, 6 Jan 2025, Sz=F5ke Benjamin wrote:

> 2025. 01. 06. 9:19 keltez=E9ssel, Jozsef Kadlecsik =EDrta:
>> On Mon, 6 Jan 2025, egyszeregy@freemail.hu wrote:
>>=20
>>> From: Benjamin Sz=F5ke <egyszeregy@freemail.hu>
>>>=20
>>> Merge xt_*.h, ipt_*.h and ip6t_*.h header files, which has
>>> same upper and lower case name format.
>>>=20
>>> Add #pragma message about recommended to use
>>> header files with lower case format in the future.
>>>=20
>>> Signed-off-by: Benjamin Sz=F5ke <egyszeregy@freemail.hu>
>>> ---
>>> include/uapi/linux/netfilter/xt_CONNMARK.h=A0 |=A0 8 +++---
>>> include/uapi/linux/netfilter/xt_DSCP.h=A0=A0=A0=A0=A0 | 22 ++--------=
------
>>> include/uapi/linux/netfilter/xt_MARK.h=A0=A0=A0=A0=A0 |=A0 8 +++---
>>> include/uapi/linux/netfilter/xt_RATEEST.h=A0=A0 | 12 ++-------
>>> include/uapi/linux/netfilter/xt_TCPMSS.h=A0=A0=A0 | 14 ++++------
>>> include/uapi/linux/netfilter/xt_connmark.h=A0 |=A0 7 +++--
>>> include/uapi/linux/netfilter/xt_dscp.h=A0=A0=A0=A0=A0 | 20 ++++++++++=
+---
>>> include/uapi/linux/netfilter/xt_mark.h=A0=A0=A0=A0=A0 |=A0 6 ++---
>>> include/uapi/linux/netfilter/xt_rateest.h=A0=A0 | 15 ++++++++---
>>> include/uapi/linux/netfilter/xt_tcpmss.h=A0=A0=A0 | 12 ++++++---
>>> include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 29 ++------------------=
-
>>> include/uapi/linux/netfilter_ipv4/ipt_TTL.h | 25 ++++--------------
>>> include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 26 ++++++++++++++++++
>>> include/uapi/linux/netfilter_ipv4/ipt_ttl.h | 23 +++++++++++++---
>>> include/uapi/linux/netfilter_ipv6/ip6t_HL.h | 26 ++++--------------
>>> include/uapi/linux/netfilter_ipv6/ip6t_hl.h | 22 +++++++++++++---
>>> net/ipv4/netfilter/ipt_ECN.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0 2 +-
>>> net/netfilter/xt_DSCP.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0 2 +-
>>> net/netfilter/xt_HL.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0 4 +--
>>> net/netfilter/xt_RATEEST.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0 2 +-
>>> net/netfilter/xt_TCPMSS.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 2 +-
>>> 21 files changed, 143 insertions(+), 144 deletions(-)
>>=20
>> Technically you split up your single patch into multiple parts but not=
=20
>> separated it into functionally disjunct parts. So please prepare
>>=20
>> - one patch for
>>  =A0=A0=A0=A0include/uapi/linux/netfilter_ipv6/ip6t_HL.h
>>  =A0=A0=A0=A0include/uapi/linux/netfilter_ipv6/ip6t_hl.h
>>  =A0=A0=A0=A0net/netfilter/xt_HL.c
>>  =A0=A0=A0=A0net/netfilter/xt_hl.c
>>  =A0=A0=A0=A0[ I'd prefer corresponding Kconfig and Makefile changes a=
s well]
>> - one patch for
>>  =A0=A0=A0=A0include/uapi/linux/netfilter/xt_RATEEST.h
>>  =A0=A0=A0=A0include/uapi/linux/netfilter/xt_rateest.h
>>  =A0=A0=A0=A0net/netfilter/xt_RATEEST.c
>>  =A0=A0=A0=A0net/netfilter/xt_rateest.c
>>  =A0=A0=A0=A0[I'd prefer corresponding Kconfig and Makefile changes as=
 well]
>> - and so on...
>>=20
>> That way the reviewers can follow what was moved from where to where i=
n a=20
>> functionally compact way.
>
> First suggestion was to split it 2 parts, it is done, i split in 3 part=
s, it=20
> was more then needed. Your idea will lead to split it about to 20 patch=
=20
> parts, then the next problem from you could be "there are to many small=
=20
> singel patches, please reduce it".

It'd mean 8 patches according to the merged match/TARGET files: mark/MARK=
,=20
connmark/CONNMARK, dscp/DSCP, rateest/RATEEST, tcpmss/TCPMSS, ecn/ECN,=20
ttl/TTL, hl/HL. Each one of them would be a unit which then could be=20
reviewed, tested independently all of the other ones.

> If you like to see it in a human readable format you can found the full=
 diff=20
> and the separted patches also in this link:
> https://github.com/torvalds/linux/compare/master...Livius90:linux:uapi
>
> Please start to use any modern reviewing tool in 2025 and you can solve=
 your=20
> problem. In GitHub history view i can see easly what was moved from whe=
re to=20
> where in 1-3 mouse clicking, eg.: click to xt_DSCP.h then click to xt_d=
scp.h=20
> and you can see everything nicely. So it is ready for reviewing, please=
 sit=20
> down and start work on it as a maintainer, It's your turn now.
>
> https://github.com/torvalds/linux/commit/1ee2f4757ff025b74569cce922147a=
6a8734b670

Thanks the suggestion: still, all changes are lumped together and cannot=20
be handled separatedly.

>> Also, mechanically moving the comments results in text like this:
>>=20
>>> /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>> -/* ip6tables module for matching the Hop Limit value
>>> +/* Hop Limit modification module for ip6tables
>>> + * ip6tables module for matching the Hop Limit value
>>=20
>> which is ... not too nice. The comments need manual fixing.
>
> I do not know what small and compact "title" should be good here in the=
=20
> merged header files. Most simplest solution was to copy paste them and =
merge=20
> these titles text.

It's pretty trivial in the example: "ip6tables module for=20
matching/modifying the Hop Limit value". But any automated merging needs=20
manual verifying and fixing if needed.

> You should know it better, please send a new compact and perfectly good=
=20
> "title" text for all header files which are in the patchset and i can c=
hange=20
> them finally. I think it is out of my scope in this business.

Sorry, but no: it's your responsibility to produce proper patches,
including the modified comments.

>> I also still don't like adding pragmas to emit warnings about=20
>> deprecated header files. It doesn't make breaking API easier and it=20
>> doesn't make possible to remove the warnings and enforce the changes=20
>> just after a few kernel releases.
>
> I also still like adding pragmas, because duplicating these header file=
s=20
> is not acceptable in SW dev/coding. It must have to be taught for the=20
> user how should use it in the future. This is a common way in any SW,=20
> for example Python or Matlab always send a notice in run-time for you=20
> which will be a deprecated things soon, when you import or start to use=
=20
> an old function or module.
>
> Why don't you think it can not help breaking API easier? This is the=20
> bare minimum what you can do for it. Tell to user what should use=20
> instead, then 3-5 years later you can change it finally, when 90-95%=20
> percent of your customers learnt to it and already started to use it in=
=20
> their userspace codes.

However as far as I'm concerned, breaking API is not a decided and=20
accepted thing. Breaking API in the kernel is not a "normal business" at=20
all.

Best regards,
Jozsef
--110363376-817496460-1736170753=:36632--
