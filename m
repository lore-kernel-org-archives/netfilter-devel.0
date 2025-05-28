Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB05919B3CB;
	Wed, 28 May 2025 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748441912; cv=none; b=ragr9AO8dzirnoF3oNkkWquf+3u0xkaKp+X8jKwviR4UlsDng9jH4yX/uTnoXSM+HCn47xRTC5cyACxYlTmlWxllT7NL7VsY2d9GHWYRTPRzc7eGt+uaaepsTPhAZylpHpx2xxbeYqQIDDUoY15JgMh4pVIIFfcBfaDq6S336DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748441912; c=relaxed/simple;
	bh=6M/v2fzkiyJF+7ss0mIkL0h8Qze2igYDZv1WDkBUazM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=C7SVmnp6cAj5iq4OTILXwEj0GiHF7rZlZkD+6QDy5QUk3zdxJ1c1/a5OuBFL9gXAIJp6/IT/KCVD6hDCqXVOmQuoSsujOqJzHWVAkXMz2GO+WlTU9pIINFxLSd7/zBMGRXR5fbd+/B6FJjJMmpRX4awUewo7MxaLmZi1DAE2YK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=InFNyCxO; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="InFNyCxO"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id D54315C001C8;
	Wed, 28 May 2025 16:18:27 +0200 (CEST)
Authentication-Results: smtp012.wigner.hu (amavis); dkim=pass (1024-bit key)
 reason="pass (just generated, assumed good)" header.d=blackhole.kfki.hu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=content-id:mime-version:references
	:message-id:in-reply-to:from:from:date:date:received:received
	:received:received; s=20151130; t=1748441906; x=1750256307; bh=N
	4WEikdHsV0G9jD6Juw+YqI0CSAD7KKrObbmYIgn/Z4=; b=InFNyCxO+uwwuOkK6
	PqFvwU3qeI/DLV1AFD3T5q7T25ujO6H7mgik6SI8+/p7jN5WDS3tzd21A7hiAxkF
	5e9RVZYw5OcomMYf7R1mk6rj1r9xIRnmFMCvkB34TZxMQrF8JHauogac7OxPwmdl
	GmF8QJ6Mrxhd9DKEyonje9UZko=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id OcjPxtQOXhh1; Wed, 28 May 2025 16:18:26 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp1.kfki.hu (Postfix) with ESMTP id DFE855C001C0;
	Wed, 28 May 2025 16:18:25 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 98F6F34316A; Wed, 28 May 2025 16:18:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 97B8A343169;
	Wed, 28 May 2025 16:18:25 +0200 (CEST)
Date: Wed, 28 May 2025 16:18:25 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: ying chen <yc1082463@gmail.com>
cc: Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>, 
    pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net, 
    kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, netdev@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in
 the SYN_SENT state caused the nf_conntrack table to be full.
In-Reply-To: <CAN2Y7hxZdWLfd34LPzhUPZJ-oMksajLMVt5K8B6Gy70e9TXMpw@mail.gmail.com>
Message-ID: <c9255252-3b6a-886a-5959-d59d0bb4640e@blackhole.kfki.hu>
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com> <aDcLIh2lPkAWOVCI@strlen.de> <CAN2Y7hzKd+VxWy56q9ad8xwCcHPy5qoEaswZapnF87YkyYMcsA@mail.gmail.com> <CANn89iLG4mgzHteS7ARwafw-5KscNv7vBD3zM9J6yZwDq+RbcQ@mail.gmail.com>
 <5611b12b-d560-cbb8-1d74-d935f60244dd@blackhole.kfki.hu> <CAN2Y7hxZdWLfd34LPzhUPZJ-oMksajLMVt5K8B6Gy70e9TXMpw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1127963621-1748441824=:6759"
Content-ID: <d964ed54-d089-1618-352e-efd16b44b2df@blackhole.kfki.hu>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1127963621-1748441824=:6759
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-ID: <c7035ed8-91a2-96cf-8334-b403f81ddcd1@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

On Wed, 28 May 2025, ying chen wrote:

> On Wed, May 28, 2025 at 9:45=E2=80=AFPM Jozsef Kadlecsik
> <kadlec@blackhole.kfki.hu> wrote:
>>
>> On Wed, 28 May 2025, Eric Dumazet wrote:
>>
>>> On Wed, May 28, 2025 at 6:26=E2=80=AFAM ying chen <yc1082463@gmail.co=
m> wrote:
>>>>
>>>> On Wed, May 28, 2025 at 9:10=E2=80=AFPM Florian Westphal <fw@strlen.=
de> wrote:
>>>>>
>>>>> ying chen <yc1082463@gmail.com> wrote:
>>>>>> Hello all,
>>>>>>
>>>>>> I encountered an "nf_conntrack: table full" warning on Linux 6.15-=
rc4.
>>>>>> Running cat /proc/net/nf_conntrack showed a large number of
>>>>>> connections in the SYN_SENT state.
>>>>>> As is well known, if we attempt to connect to a non-existent port,=
 the
>>>>>> system will respond with an RST and then delete the conntrack entr=
y.
>>>>>> However, when we frequently connect to non-existent ports, the
>>>>>> conntrack entries are not deleted, eventually causing the nf_connt=
rack
>>>>>> table to fill up.
>>>>>
>>>>> Yes, what do you expect to happen?
>>>> I understand that the conntrack entry should be deleted immediately
>>>> after receiving the RST reply.
>>>
>>> Then it probably hints that you do not receive RST for all your SYN
>>> packets.
>>
>> And Eric has got right: because the states are in SYN_SENT then either=
 the
>> RST packets were not received or out of the window or invalid from oth=
er
>> reasons.
> I also suspect it's due to being "out of the window", but I'm not sure =
why.

tcpdump of the traffic from the targeted machine with both the SYN and RS=
T=20
packets could help (raw pcap or at least the output with absolute seqs).

Best regards,
Jozsef
--110363376-1127963621-1748441824=:6759--
