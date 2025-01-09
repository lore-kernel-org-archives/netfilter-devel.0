Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45B721C173;
	Thu,  9 Jan 2025 15:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736434808; cv=none; b=DjcOTWNHip6gdn/oqKOHQIG6w/u2xJ9VCdarK3kIoCZi/Izwk3rYQ/+AHk/fQHnnS50DAzL4iioPLVA/sIrA/c5dZKNmvvri3Jj9KyJk2T5NVQaLax0coEIDn/ZXufd/gfr6DrLOhOYUdVWJF07VkmHWkiAZXaLMDI6M/RMQBSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736434808; c=relaxed/simple;
	bh=qy0cOgKZMKaHBf1ZSyMrw8UzWrsa/7+5DNZN3D6ClxM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=sKuOaXVnuqFqHoTcOsHYzEsxNg30cZQRv8MtnFebsoSNdveZUB38lwVN4tXkNTNLnMjyCUFK+wyO6m432XqolSqJfV14xMUv/fkylxzcMQ6ZjCGJuZKUcZBpy8Y87DifQZSnv53DHeFnN3laswXGVRJ55asiQTwuYNgrfUHB+Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=Aarefuv+; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Aarefuv+"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 7628D5C001C1;
	Thu,  9 Jan 2025 16:00:02 +0100 (CET)
Authentication-Results: smtp012.wigner.hu (amavis); dkim=pass (1024-bit key)
 reason="pass (just generated, assumed good)" header.d=blackhole.kfki.hu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1736434800; x=1738249201; bh=N3i12alHig
	CwPVvfmYnCbCQRAmnOP77N7AI8TyQW6ek=; b=Aarefuv+or2Ql8vk2pLn3U6PW/
	fwSpnhZvbDnHSTVJVOVSTCaliF0riRYX4rnOI6yJOS+216WZStgOY3Ml2QmMknzV
	40DudLPqQHWZ1Lb9ncPFXdPnai9nX35QWcu53uZ98Otm+o4+vimC0X9lZsuj0PLv
	Lh1WhlNpnm+AqaFOc=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id NV8O3dG5qeUU; Thu,  9 Jan 2025 16:00:00 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 1398E5C001D0;
	Thu,  9 Jan 2025 15:59:59 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id E404C34316A; Thu,  9 Jan 2025 15:59:59 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id E21F9343169;
	Thu,  9 Jan 2025 15:59:59 +0100 (CET)
Date: Thu, 9 Jan 2025 15:59:59 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: =?ISO-8859-2?Q?Sz=F5ke_Benjamin?= <egyszeregy@freemail.hu>
cc: Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
    Pablo Neira Ayuso <pablo@netfilter.org>, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    David Miller <davem@davemloft.net>, dsahern@kernel.org, 
    edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/10] netfilter: x_tables: Merge xt_DSCP.h to
 xt_dscp.h
In-Reply-To: <a42bcc51-255f-4c52-b95c-56e562946d3a@freemail.hu>
Message-ID: <128620a6-a02e-db25-dd69-4ebee326d15c@blackhole.kfki.hu>
References: <20250107024120.98288-1-egyszeregy@freemail.hu> <20250107024120.98288-2-egyszeregy@freemail.hu> <4fab5e14-2782-62d2-a32d-54b673201f26@netfilter.org> <98387132-330e-4068-9b71-e98dbcc9cd40@freemail.hu> <d7190f89-da4d-40df-2910-5e87ca3cd314@netfilter.org>
 <a42bcc51-255f-4c52-b95c-56e562946d3a@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1821688513-1736434799=:36632"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1821688513-1736434799=:36632
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Jan 2025, Sz=C5=91ke Benjamin wrote:

> 2025. 01. 08. 21:11 keltez=C3=A9ssel, Jozsef Kadlecsik =C3=ADrta:
>> On Tue, 7 Jan 2025, Sz=C5=91ke Benjamin wrote:
>>=20
>>> 2025. 01. 07. 20:23 keltez=C3=A9ssel, Jozsef Kadlecsik =C3=ADrta:
>>>> On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
>>>>=20
>>>>> From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
>>>>>=20
>>>>> Merge xt_DSCP.h to xt_dscp.h header file.
>>>>=20
>>>> I think it'd be better worded as "Merge xt_DSCP.h into the xt_dscp.h
>>>> header file." (and in the other patches as well).
>>>=20
>>> There will be no any new patchset refactoring anymore just of some
>>> cosmetics change. If you like to change it, feel free to modify it in=
 my
>>> pacthfiles before the final merging. You can do it as a maintainer.
>>=20
>> We don't modify accepted patches. It rarely happens when time presses =
and
>> even in that case it is discussed publicly: "sorry, no time to wait fo=
r
>> *you* to respin your patch, so I'm going to fix this part, OK?"
>>=20
>> But there's no time constrain here. So it'd be strange at the minimum =
if
>> your submitted patches were modified by a maintainer at merging.
>>=20
>> Believe it or not, I'm just trying to help to get your patches into th=
e
>> best shape.
>
> Holyday session is end, i have no time to refactoring and regenerate my=
=20
> patchset in every day, because you have a new idea about cosmetics=20
> changes in every next days. (this is why asked you before what you like=
=20
> to get, there was no any answer) If you feel it is need, you can solve=20
> it as a maintainer, i know. If you found any critical issue i can fix i=
t=20
> later, please start to look for them, but i will not waste my time with=
=20
> this usless commit name and header comment changes, sorry. It is a=20
> hobby, i am not a paied Linux developer which is supported by a company=
=20
> for this stuff.

Your patches do not fix any bug in the code itself. The unified=20
match/target modules would be a good to have for less memory usage but=20
it's not pressing either.

So there's no time pressure at all, if you wish/need you can continue to=20
improve your patchset when you'll have the time.

Best regards,
Jozsef

Ps: I have been doing my Linux developing/maintenance in my spare time.
--110363376-1821688513-1736434799=:36632--
