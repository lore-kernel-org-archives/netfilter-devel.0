Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.238.174.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686816;
	b=H/gVGakYwStrSnz43Ga78w+fDPT1zpENeGV3E/WLbuINzYTnipT/dIpkB63UKjONgZX3
	 XiZidhKUPXv0/0cLDCpwXgQsTxyD87xQCNvc7ZkB8jhhhnghZC6sCKsIxE+ZGffRv/LzJ
	 7dlscJAvwLJi5mmXHremMipGPe3Qlbr/Gb+D+yis2b3LOdVVxb5JEi6+w3n4uAULZaJVq
	 nzUGa3JwX1JQ9A38/YXu2mTLsFodr+b/scu2HlKw9OAM36UUuW1T5C5d7snWr1jF/5KeQ
	 FlmYwPv6bJ783n1ejJjWtOjKy1347sz2/4Zn5N+AtW95FCZ3KR96es/H98/6w9/OBQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686816;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=HKSzWYKLNjtCq0HxqsF4oeDc7gbuKwYRJtFWl4RcZos=;
	b=Arh5ev/MbGl9ghTPCU4t7QUZJ0E49xFagSpsil/UnGR3PRNMZeznFXUER3PxQGtuMIYe
	 CzRmZTEX2IB3ZUzg3jYht/4nkENvzFwKhAVT5vKeHBR6C0CiEtTuO6xyZ1O2nOeHye2Rs
	 1A0gSHY3WmHoQ69DYIBEbiAXWdpodngKhYQJd5zJS45e4xY+wAq7fX0FnU4jx5abrp1zT
	 0t/q6dH0mFIfJCQJuULJvYg0GfV3fJsAYYNZ59us1HEGn0RTzwpiDXvOJFOT5JncC02eK
	 p2bguq03tTF2U2JX47UtD+iKZJAaD56m0A32IbH9D9E2mIHd82yOjoChMuA7S6+/VKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ssi.bg;
	spf=pass smtp.mailfrom=ssi.bg;
	dkim=pass header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=YzqBs9dX;
	arc=none smtp.remote-ip=193.238.174.39
Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A150606A323;
	Sat, 14 Nov 2026 20:06:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A150606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=YzqBs9dX
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 0AAEA21274;
	Sat, 14 Nov 2026 22:06:47 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=HKSzWYKLNjtCq0HxqsF4oeDc7gbuKwYRJtFWl4RcZos=; b=YzqBs9dXJ9Ik
	+0WXanedLWKoFZpd+92ViD9AtgFWPAIyiEph6SEUDfxAWN+l0GBJLGlt4ewCfXKk
	D9MfF0utl9+TNzOzXx/tGdoM8MX5MSlpmmJDBpEh2KQYYUfU+T4zY4B4zu/oESJp
	EdgfZL/nQSJdOwmar/m5HZV2yusIMMOpYD3ondi789u+LzyxdEuD1bW4dfkwMeqM
	Mgnl+RysItYgPZ0feASFIHLlHW2GSPQbTQjN2a5d49rbfBiiEACwnAceQKO9QIc1
	FHBOAbKtHohwiAbYAGAkSTl+JXKnFhT6TuW/l58+1kzqrfl37Nl1sQofSGwYoFzM
	A0JAfKrm+ulQ1B4IUr0tXl5U/Ytecl2nhwjEZTLYm7yhPhrkLBe21Jn4NgmKXhg+
	P0GV6Q0nzYv3UkgzMaGCqlPnPj9Iqd6DUX/hpwcy/buElHFL+cNYTnrLASm1VLPH
	QhQU3vOSeZrI/xuOBTikJn+6bc5y2hABGVNFLyd7LfmOpWRZ/xb0nY4/xWdkYqh+
	n8FmLlckndkZlZzP4o/f5gTWMAiKFtlfhCg+a6iTiqVhhTD8MjJJIDuPSz8Lj7Pm
	LG3RbsvnEAcS4BfCl6JGN4hwSglLZCHvEfEBE54WN0Y6VfncFjbYCHuTYPkGoJCn
	OTH46RxcMb5tHXHZR425udi+wrR5wSk=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Sat, 14 Nov 2026 22:06:46 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 791D6609CF;
	Sat, 14 Nov 2026 22:06:46 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 6AEK6cPX056652;
	Sat, 14 Nov 2026 22:06:38 +0200
Date: Sat, 14 Nov 2026 22:06:38 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: netdev-bot+sashiko@kernel.org
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@kernel.org, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 01/15] ipvs: avoid out-of-bounds write in
 ip_vs_nat_icmp_v6
In-Reply-To: <179462253904.2199510.6723175642724870986@kernel.org>
Message-ID: <19ba5516-0938-495a-5e7f-57f5fd9a2b45@ssi.bg>
References: <20261113011447.2357709-2-pablo@netfilter.org> <179462253904.2199510.6723175642724870986@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-272803136-1794686798=:48633"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-272803136-1794686798=:48633
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Sat, 14 Nov 2026, netdev-bot+sashiko@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.

	In summary: we can drop current patches 1, 2, 15 and
should address problems in 7.

	We plan to update patch 2 to check for present data.
Both patches 1 and 2 go together, so they can be dropped for
now and improved in next version.

Patches 4, 8, 10 and 14 are ok, even if wording can be improved.

Patch 5: we prefer to drop the traffic when port 0 is involved

Patch 7 should be checked by the Netfilter guys.

Patch 11: NO_CPORT is before connection is established and
we do not sync conns in master before establishment. So,
nothing bad can happen in practice.

Patch 12: races are possible but nothing fatal

Patch 15: The patch was meant for ip_vs_bind_xmit_v6. daddr can
be further limited in next version, so this patch can be dropped.

> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-272803136-1794686798=:48633--

