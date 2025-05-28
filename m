Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8DC2853EB;
	Wed, 28 May 2025 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748440232; cv=none; b=SAe6lk9rAF/G9jjQ/aZXKtTl93B3gv1eeABUUvKOKIgzMfyEEiHVkIkcl7lLQzyiv0zdmaemT2W/h9daXcVEYe9DpA5X613Vhebt2XhGbkIs41VkAKl+ixg1NqvDBYYFodGie61f2RZeGaUqpng3A24l2IQZ9KBU7wRv6f/0qac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748440232; c=relaxed/simple;
	bh=LhTAubIh/5Hl+CIcaPgophp5ZeXXrXTUiUkisse0S+8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZOXrLcwSWE4PgZ/UXCjtbnQunoJHT9SD99zltYbiK6sRhge/BYwdPffeH3+hFnVhGIOFMnFBpq/W44nAC9G/Rm6f1y58IHSb378lbtkyyEH3n9SH9i9liVJ6LOPxaxgYSYVM8metTQxPMR7zgTbs/ltOmiqAhQbWX2Va4lf2/zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=IXiTzO5i; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="IXiTzO5i"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id CC9A15C001C8;
	Wed, 28 May 2025 15:41:51 +0200 (CEST)
Authentication-Results: smtp012.wigner.hu (amavis); dkim=pass (1024-bit key)
 reason="pass (just generated, assumed good)" header.d=blackhole.kfki.hu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1748439709; x=1750254110; bh=/fG8h8umIg
	Qf40nj8YywHmoTEtPnasUPoFQqus8jBP8=; b=IXiTzO5iaeYL9q7PkhRaFysSgs
	hS9M2kyI5eChYASXA82JeUJszt0TltYhlv/o8/gkWGIHtECXjJCUT3gNSmEtXDoj
	F/VUwbusekwlwpktWUYQjBTcayTroVlZtpvq/kBx7y6n65554Lcso4yM9MK2p4cR
	0gXh4zL5hhWepBsc8=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id eU4Vi8ytn2d6; Wed, 28 May 2025 15:41:49 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 6E60A5C001C0;
	Wed, 28 May 2025 15:41:49 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id F1D4234316A; Wed, 28 May 2025 15:41:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id EFBAD343169;
	Wed, 28 May 2025 15:41:48 +0200 (CEST)
Date: Wed, 28 May 2025 15:41:48 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: ying chen <yc1082463@gmail.com>
cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org, kadlec@netfilter.org, 
    davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
    pabeni@redhat.com, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in
 the SYN_SENT state caused the nf_conntrack table to be full.
In-Reply-To: <CAN2Y7hzKd+VxWy56q9ad8xwCcHPy5qoEaswZapnF87YkyYMcsA@mail.gmail.com>
Message-ID: <a752bbbf-08c0-3885-65ba-79577a1ad5a8@blackhole.kfki.hu>
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com> <aDcLIh2lPkAWOVCI@strlen.de> <CAN2Y7hzKd+VxWy56q9ad8xwCcHPy5qoEaswZapnF87YkyYMcsA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-2043345281-1748439708=:6759"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-2043345281-1748439708=:6759
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On Wed, 28 May 2025, ying chen wrote:

> On Wed, May 28, 2025 at 9:10=E2=80=AFPM Florian Westphal <fw@strlen.de>=
 wrote:
>>
>> ying chen <yc1082463@gmail.com> wrote:
>>> Hello all,
>>>
>>> I encountered an "nf_conntrack: table full" warning on Linux 6.15-rc4=
.
>>> Running cat /proc/net/nf_conntrack showed a large number of
>>> connections in the SYN_SENT state.
>>> As is well known, if we attempt to connect to a non-existent port, th=
e
>>> system will respond with an RST and then delete the conntrack entry.
>>> However, when we frequently connect to non-existent ports, the
>>> conntrack entries are not deleted, eventually causing the nf_conntrac=
k
>>> table to fill up.
>>
>> Yes, what do you expect to happen?
> I understand that the conntrack entry should be deleted immediately=20
> after receiving the RST reply.

No, the conntrack entry will be in the CLOSE state with the timeout value=
=20
of /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close

Best regards,
Jozsef
--110363376-2043345281-1748439708=:6759--
