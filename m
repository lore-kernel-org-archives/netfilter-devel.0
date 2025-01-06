Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568DF1946CC;
	Mon,  6 Jan 2025 07:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736150151; cv=none; b=itnH7aDTc+1e0YWuf+wPCTBNavt+/fOFKJANmo6XoA6V+t3j5rsAPXYRUSB7i8EcIiQsEdcYaMmzh1s6Xdxh8B70GdDF/5at3lGrH8ISFTYUAdcWtVNPURtiFLTLY9TjIz0+EBxtqrZWiHuNGThyyr6QYGFto5AFNK99QEbci/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736150151; c=relaxed/simple;
	bh=ELMzeTQE8WIBydCunmd35FwZKzEyRplwBVRd00fPSvk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lzVlMNadiwSBoJsnuDVFEG2rVceTZdU5sHss9h3vtMVzIDTG6KbAPUd9h5nAxcCYpJhxKVA4pZbCKlcdnqp7q40ZxuCsrntwV9uEALmPXr/yjHi2K1Pyiki2cDSsp9k4n5R/SOb+RsSlwGybLcziHfLpxkL/0nZJGRxv5IBrkx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=BWyvDXSB; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="BWyvDXSB"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 26FA95C001C2;
	Mon,  6 Jan 2025 08:48:38 +0100 (CET)
Authentication-Results: smtp012.wigner.hu (amavis); dkim=pass (1024-bit key)
 reason="pass (just generated, assumed good)" header.d=blackhole.kfki.hu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1736149715; x=1737964116; bh=MI0J9Rqtux
	2YcfZGbO6p6FvAFgAGG4cMPCCBqbT1Cpo=; b=BWyvDXSBvR9W1LMoPTZz0AawL+
	BwOyhcgzknJP2HrwgHtQwdbzE/Sy2AcQ737vE9o4wvtuxEVsNxroY1hlJ/XsPlsx
	1Az7L04FIpp7LKT+OoiFWHy7WONKN83COnerU3GaXtFhL7iQYDXm0Pq/JsRaUV/Q
	0TNXPJYDxg/2VJnaw=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 6FHFBcY7N0iG; Mon,  6 Jan 2025 08:48:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 1E6925C001BF;
	Mon,  6 Jan 2025 08:48:34 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id E4D3A34316A; Mon,  6 Jan 2025 08:48:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id E2B53343169;
	Mon,  6 Jan 2025 08:48:34 +0100 (CET)
Date: Mon, 6 Jan 2025 08:48:34 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: =?ISO-8859-2?Q?Sz=F5ke_Benjamin?= <egyszeregy@freemail.hu>
cc: Andrew Lunn <andrew@lunn.ch>, Florian Westphal <fw@strlen.de>, 
    Pablo Neira Ayuso <pablo@netfilter.org>, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    kadlec@netfilter.org, David Miller <davem@davemloft.net>, 
    dsahern@kernel.org, edumazet@google.com, kuba@kernel.org, 
    pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, linux-kernel@vger.kernel.org, 
    netdev@vger.kernel.org
Subject: Re: [PATCH v5 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h
 files which has same name.
In-Reply-To: <defa70d2-0f0c-471e-88c0-d63f3f1cd146@freemail.hu>
Message-ID: <ee78ed44-7eed-0a80-6525-61b5925df431@blackhole.kfki.hu>
References: <20250105203452.101067-1-egyszeregy@freemail.hu> <43f658e7-b33e-4ac9-8152-42b230a416b7@lunn.ch> <defa70d2-0f0c-471e-88c0-d63f3f1cd146@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-498301477-1736149714=:36632"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-498301477-1736149714=:36632
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Jan 2025, Sz=C5=91ke Benjamin wrote:

> 2025. 01. 05. 22:27 keltez=C3=A9ssel, Andrew Lunn =C3=ADrta:
>> On Sun, Jan 05, 2025 at 09:34:52PM +0100, egyszeregy@freemail.hu wrote=
:
>>> From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
>>>=20
>>> Merge xt_*.h, ipt_*.h and ip6t_*.h header files, which has
>>> same upper and lower case name format.
>>>=20
>>> Add #pragma message about recommended to use
>>> header files with lower case format in the future.
>>=20
>> It looks like only patch 1/3 make it to the list.
>>=20
>> Also, with a patchset, please include a patch 0/X which gives the big
>> picture of what the patchset does. The text will be used for the merge
>> commit, so keep it formal. 'git format-patch --cover-letter' will
>> create the empty 0/X patch you can edit, or if you are using b4 prep,
>> you can use 'b4 prep --edit-cover' and then 'b4 send' will
>> automatically generate and send it.
>>=20
>> https://docs.kernel.org/process/maintainer-netdev.html
>> https://docs.kernel.org/process/submitting-patches.html
>>
>>      Andrew
>
> https://lore.kernel.org/lkml/20250105233157.6814-1-egyszeregy@freemail.=
hu/T/
>
> It is terribly chaotic how slowly start to appear the full patch list i=
n the=20
> mailing list website. It's really time to replace 1990s dev technology =
with=20
> something like GitLab or GitHub developing style can provide in 2024.

No, it was your fault in the v5 series of your patches: you managed to=20
send all the patches in a single email instead of separated ones.

Best regards,
Jozsef
--110363376-498301477-1736149714=:36632--
