Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF923DEAD1;
	Tue,  9 Jun 2026 22:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781043319; cv=none; b=nmgQ03nLsu6G/y+Ak0Ucp1p/Yhldk3l/fcpXBGxO/NdRjMjsI02CcJgvfZ5Ppf5aKYbt+IDnOwSqtlULBXGeKfNZc39s48NtArIoRtno8nIdpzTS5DRAu6WX40tGFB8P5noG9ZWWkEEDPhN/2wPxHHAfotjM4Ml8yxCaB74DXxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781043319; c=relaxed/simple;
	bh=Tsi7Eid3oYjZKZqrrt1SsBzu3O+/ppa0eG8VXuOYUF0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d9ElgJ0Iusskkzq5FIJfEl4kHX86P73dOal3OGVdf16cOyyJmKIlYLeldUrb7d+bnFtWd+WrCXTDV5rgjVUXs2gmzi29Ea6CZGr2ftVtZg1BrabQ0O+quMs/OfPUP+jSzQbe/DlVsFeW+vArQYieoEBVlBraS2951Dhn+9Ajey4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4QbA69r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4QbA69r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C4A1F00893;
	Tue,  9 Jun 2026 22:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781043318;
	bh=JXc/IJa6zvTygittkeGvqwNmBwKvXXAouvf+JVGAfyg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=G4QbA69rI5lRSCdbDw5QhxqsrSjAYiIA2HzYucRY03h3wAdKXvs10wUAxnVzAemWZ
	 faSXkd7+He/8XislWC2uUj/wBwGFv5I1tqVSVtjjobW9OyEcNGCVxC6GrmRvtkFbBx
	 R8T1tI+ZlwlyDc473reKeLKkWICGRrLKXjjg8Be4/8FdzHLRGUpuS89dd2RD+pRePM
	 R1sLmJ4W89g7T3bUGsYUxvLtptSNvSheFNH6tjsIiEFs+bvb9N1xr5DkJPxTdk1oiT
	 1sf30I0iDA9pUSo+pP99RES01IzoD5ehi5al7Tmk4I9ydjfP3mKY2BZ5BtT0nI53M6
	 FKwx1W1bBfBMg==
Date: Tue, 9 Jun 2026 15:15:17 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dummy: add phony ndo_setup_tc stub
Message-ID: <20260609151517.186b1cac@kernel.org>
In-Reply-To: <20260609142813.9197-1-fw@strlen.de>
References: <20260609142813.9197-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  9 Jun 2026 16:28:09 +0200 Florian Westphal wrote:
> Unlike netdevsim, dummy is a data sink so no capabilities (e.g.
> u32-style matcher, vport device redirects, PPPoE header push/pop etc).
> have to be implemented.

If no "peer" is configured netdevsim is also a data sink.

We added netdevsim because dummy and veth started accumulating
"features" which were clearly just for test harnesses. Would be
great if we could stay the course and put whatever changes you
need in netdevsim, even if it requires some hacks.

Is there anything fundamentally blocking the use of netdevsim?
Or is it just convenience (since netdevsim is a bit of a PITA
to create and establish the name of)?
