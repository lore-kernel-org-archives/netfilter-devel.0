Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=136.143.169.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793979739;
	b=jL4TztvhrnKnpGuyjV2+e83LjhByqevdjyR6OdMOvjz5u6XiCtV78RsiL16wmzS+sQ4G
	 pAWSgwGxzWy+CMVUe0lk6L/0ByvplZbFExQMs6Zp1P2om/pfvJE3LPLcRu9mRVOC4/eYc
	 sdgBi5dwXOR6w+B0JqC0kR2MbU7nqFc9ae/BND1q4gEpDeKBesKzbsKAtvbzHRk8N6fkz
	 6qfB9q1oLgIIr/XwEuxZ0BU+X/YaCK5aOfsOb6LZSt8ZPso1ztu4cVjctWlbNMh1789G4
	 mOOwU0IM4iqnEQsb16iGDf/kdwz+4uzfRweyfPsLcNrSLmysXh2f9/4GFPbFNyxB1xg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979739;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Message-ID:
	 In-Reply-To:References:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Importance:User-Agent:X-Mailer;
	bh=v0mcE5o+mEfokba0wzKYkjJQYfiDpuF/z2AJeteosKc=;
	b=vxhvrRnPMAuHuGSchDI4S5ONPZPdO25ESMLOUkvtuECWRDtYBDBjtYNYx39ZS+6JIzeE
	 X5PY/VaFJBDEWVrcKtb5sxSzlp0lw6gbF4NFz7gijfzC+b3ERXRMDpFNPHXPJfwG9F33I
	 0kw7M8e4FQloRm0Iox30boj20KFz+mE04Ri4hIqKqr5CX1wn9XwZy36sOgI9kppkiJXML
	 LNgrIYiXo2dTeBiNUc3ZKdA1lhPJpfQy01sEwcmcJHW4YuDIR4mOV2OfcwF3InKbBQ1xe
	 nUMFqP8sn61ze6wSI8cPEISsZ1ivQBxoWPmgoEuk8/0Io/17tMcoqbxyFCHYdPW32yw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=asgari.net;
	spf=pass smtp.mailfrom=asgari.net;
	dkim=pass header.d=asgari.net header.i=@asgari.net header.a=rsa-sha256 header.s=zmail header.b=cA34GPsB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=136.143.169.50
Received: from sender-of-o50.zoho.eu (sender-of-o50.zoho.eu [136.143.169.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D59606D833;
	Fri,  6 Nov 2026 15:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0D59606D833
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asgari.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asgari.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=asgari.net header.i=@asgari.net header.a=rsa-sha256 header.s=zmail header.b=cA34GPsB
ARC-Seal: i=1; a=rsa-sha256; t=1793979729; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=ZvM0nvnr4mCdsXkGh05UM6rSz4LNIhu27OnfvN1FpKh/VM/9GgqF6NKl5JKtfSXRplfc5hNlh5JDtOJs+GN7uc7Lgo3eql93max1cJwHsKOP2WRhkS0xyzQQ6NSVPVo1fGEZyX3UVBKTguK4FQscISpYqk5kUZ4vdC9aqOne3xk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1793979729; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=v0mcE5o+mEfokba0wzKYkjJQYfiDpuF/z2AJeteosKc=; 
	b=LGJENBlh1mpEvOxUDvn4UHeTc1hWY+LcpcpgZnxSExfl9VJQ7pJ/bKDfRq1/3D6q+dO3vAA9ehuIKf7SiYGmfiv6p67WGL+bk5C1ygiVA3MRD6cxA4RDpylMPRv2gBvg5mcR9TQ29+mHDn2qfOehyuIHGTOTeH8HECE5eLaFedw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=asgari.net;
	spf=pass  smtp.mailfrom=alireza@asgari.net;
	dmarc=pass header.from=<alireza@asgari.net>
DKIM-Signature: a=rsa-sha256; b=cA34GPsBkXzs4Icrlstu7swvyhxBpFTAXQJObKq8ZTfblwGjzK8k2EFZH77aUR97c9vRLi1Z0JWkZ2BWdbyWsrntzCDv0KU2ZjTtqAZTtjjX26olVKiNEoH4PSvE6a6blCmcx9fr1sXieTRPueBlcd/GmpHKAcv1xHDtqefV3WA=; c=relaxed/relaxed; s=zmail; d=asgari.net; v=1; bh=v0mcE5o+mEfokba0wzKYkjJQYfiDpuF/z2AJeteosKc=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: from mail.zoho.eu by mx.zoho.eu
	with SMTP id 1793979727867542.1179257146615; Fri, 6 Nov 2026 16:42:07 +0100 (CET)
Date: Fri, 06 Nov 2026 16:42:07 +0100
From: Alireza Asgari <alireza@asgari.net>
To: "Florian Westphal" <fw@strlen.de>
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>, "Phil Sutter" <phil@nwl.cc>,
	"netfilter-devel" <netfilter-devel@vger.kernel.org>,
	"netdev" <netdev@vger.kernel.org>,
	"kunit-dev" <kunit-dev@googlegroups.com>
Message-ID: <1a1b1863ff2.22494b4c856594.8212473696088017300@asgari.net>
In-Reply-To: <au3qeEf0LVzO84d3@strlen.de>
References: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net> <au1difVZWMSV78wV@strlen.de> <1a1b040da34.2a9c00de770859.6266910270967560587@asgari.net> <au3qeEf0LVzO84d3@strlen.de>
Subject: Re: [PATCH RFC net 0/3] netfilter: nfnetlink_queue: handle packet
 ID reuse and large gaps
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Florian,

Thanks for the pointers. I=E2=80=99d like to give this a try. I=E2=80=99ll =
take some time to understand the code first and follow up with what I find.



From: Florian Westphal <fw@strlen.de>
To: "Alireza Asgari"<alireza@asgari.net>
Cc: "Pablo Neira Ayuso"<pablo@netfilter.org>, "Phil Sutter"<phil@nwl.cc>, "=
netfilter-devel"<netfilter-devel@vger.kernel.org>, "netdev"<netdev@vger.ker=
nel.org>, "kunit-dev"<kunit-dev@googlegroups.com>
Date: Fri, 06 Nov 2026 15:55:52 +0100
Subject: Re: [PATCH RFC net 0/3] netfilter: nfnetlink_queue: handle packet =
ID reuse and large gaps

 > Alireza Asgari <alireza@asgari.net> wrote:=20
 > > Thanks for the review.=20
 > >=20
 > > I understand that batch verdicts are intended to be used in strict seq=
uence. The scenarios motivating this RFC did not establish a failure under =
that usage model, and the evidence presented does not justify the additiona=
l epoch and missing-boundary handling.=20
 > >=20
 > > I=E2=80=99ll drop the current series. I also understand that the propo=
sed collision disposition being reasonable does not by itself establish a n=
eed for the duplicate-ID guard. I would revisit that separately only if I c=
an provide a concrete use case.=20
 > >=20
 > > Thanks for taking the time to review it.=20
 > =20
 > If you want to work on something else that is actually a problem, then=
=20
 > you could investigate the mem exhaustion issue.=20
 > =20
 > The current limitation is queue length based, this is very old from=20
 > a time when GSO/TSO aggregate skbs did not exist.=20
 > =20
 > Untested idea:=20
 > =20
 > 1. compute a memory size limit based off the old NFQA_CFG_QUEUE_MAXLEN:=
=20
 >  sizeof(sk_buff shell structure) + 2048 (half a 4k page).=20
 > 2. store skb->truesize in the entry struct when queueing.=20
 > 3. charge the truesize to the queue entry (and uncharge on reinject).=20
 > 4. in addition to the queue length check, also check if the new=20
 >  skb->truesize would bring us over the limit, refuse queueing if thats=
=20
 >  the case.=20
 > 5. Make sure NFQA_CFG_QUEUE_MAXLEN updates continue to work.=20
 > =20
 > This leaves on major issue: userspace can request 64k queues, so these=
=20
 > limits don't help.=20
 > =20
 > One possible solution:=20
 > 1. For init netns, no changes.=20
 > 2. For non-init netns:=20
 >  at queue creation time resp. when limit is altered, pre-charge=20
 >  the worst case occupancy to kmemcg.=20
 > =20
 > Refuse queue creation if that fails.=20
 > Ideally this could be split into several patches to ease review.=20
 > =20
 > Thanks.=20
 >=20


