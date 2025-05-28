Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0528F1F37D3;
	Wed, 28 May 2025 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748440231; cv=none; b=ZUpZyjw+e87Ke6TTdfoaGxCVT1y2Ksc86HliN9PdK3F3ddpkAfbo4umMT4ffFyLvueXIZCCI2kf0EJB2y8WF9prt0tmqn6x+ZKDmwNEhd4phxX2Iy5rC1bQmXvpbSdJ0npl48YCEW9vHMHZW1dKoI+sDk7hlIluMfP5LpsQULWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748440231; c=relaxed/simple;
	bh=Mpg9XUQl59h3pBUPCN3zmB3GaCOs4B75IwcrLW4NqHU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=dtK0e/1HCGUpw8NUeUtfpNUesPk5z+bFzGM5TsuvcHWVfyL16HVqep9iRg4VsCxo/MPwoae9b/3yXGVjAzlHOAjkGKliXtRO7Lw4LlgwvipQrK1k9gUvdNw2IGwuLoRVLE5UGcNQ/0DDodxhLP+1Z2/woPQh3H5S8SW68hnT1oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=APQCFQVk; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="APQCFQVk"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id E1F8719201A0;
	Wed, 28 May 2025 15:45:02 +0200 (CEST)
Authentication-Results: smtp012.wigner.hu (amavis); dkim=pass (1024-bit key)
 reason="pass (just generated, assumed good)" header.d=blackhole.kfki.hu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=content-id:mime-version:references
	:message-id:in-reply-to:from:from:date:date:received:received
	:received:received; s=20151130; t=1748439901; x=1750254302; bh=h
	8HpPOKmadZTCE9YZDzfLUVOhtwWReeTJejqPLhcSh0=; b=APQCFQVkqQ4hnav5I
	QB6OUfiOG26fnJRO2a3/UiISo/Rd/E9cFQvj9Mo6JofAC9UNoIZAQfdKGLgjiASD
	ZktPvu3kIFP58NkjcTWmUpPswyq+9b0NddrmaVTRd0BnED1mrPhbvKl9GSsSmitQ
	JfU7eO4ulRul6hMa/fQgdqlspU=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id W5zIGn_boHeP; Wed, 28 May 2025 15:45:01 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 09878192019E;
	Wed, 28 May 2025 15:45:00 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 90E6C34316A; Wed, 28 May 2025 15:45:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 8F5B1343169;
	Wed, 28 May 2025 15:45:00 +0200 (CEST)
Date: Wed, 28 May 2025 15:45:00 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Eric Dumazet <edumazet@google.com>
cc: ying chen <yc1082463@gmail.com>, Florian Westphal <fw@strlen.de>, 
    pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net, 
    kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, netdev@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in
 the SYN_SENT state caused the nf_conntrack table to be full.
In-Reply-To: <CANn89iLG4mgzHteS7ARwafw-5KscNv7vBD3zM9J6yZwDq+RbcQ@mail.gmail.com>
Message-ID: <5611b12b-d560-cbb8-1d74-d935f60244dd@blackhole.kfki.hu>
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com> <aDcLIh2lPkAWOVCI@strlen.de> <CAN2Y7hzKd+VxWy56q9ad8xwCcHPy5qoEaswZapnF87YkyYMcsA@mail.gmail.com> <CANn89iLG4mgzHteS7ARwafw-5KscNv7vBD3zM9J6yZwDq+RbcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-769770083-1748439818=:6759"
Content-ID: <c1387642-c4d5-c4ae-a0e2-bda921178228@blackhole.kfki.hu>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-769770083-1748439818=:6759
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-ID: <0fe7b6ac-9804-75fc-cbe2-69870eb5e0cf@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

On Wed, 28 May 2025, Eric Dumazet wrote:

> On Wed, May 28, 2025 at 6:26=E2=80=AFAM ying chen <yc1082463@gmail.com>=
 wrote:
>>
>> On Wed, May 28, 2025 at 9:10=E2=80=AFPM Florian Westphal <fw@strlen.de=
> wrote:
>>>
>>> ying chen <yc1082463@gmail.com> wrote:
>>>> Hello all,
>>>>
>>>> I encountered an "nf_conntrack: table full" warning on Linux 6.15-rc=
4.
>>>> Running cat /proc/net/nf_conntrack showed a large number of
>>>> connections in the SYN_SENT state.
>>>> As is well known, if we attempt to connect to a non-existent port, t=
he
>>>> system will respond with an RST and then delete the conntrack entry.
>>>> However, when we frequently connect to non-existent ports, the
>>>> conntrack entries are not deleted, eventually causing the nf_conntra=
ck
>>>> table to fill up.
>>>
>>> Yes, what do you expect to happen?
>> I understand that the conntrack entry should be deleted immediately
>> after receiving the RST reply.
>
> Then it probably hints that you do not receive RST for all your SYN=20
> packets.

And Eric has got right: because the states are in SYN_SENT then either th=
e=20
RST packets were not received or out of the window or invalid from other=20
reasons.

Best regards,
Jozsef
--110363376-769770083-1748439818=:6759--
