Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301741C9EAB;
	Thu, 10 Oct 2024 13:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728568441; cv=none; b=SOB1FBcVvSYBW7+FFlv/YcMWCc7g2CAwd8Va0Z1orVeGTsf13AExJy0CcYSGuL5xarJLwgCQ6AV3nKa2uMIqZ0iZ3oSV1UoXeKW71yZYOmn4QibrqIErCbrW9O2m0xLkjuUtM5zFh/B6FIriDYXxUFjxAyKF6vJv7eAtF8S/4Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728568441; c=relaxed/simple;
	bh=/3g+rKYvTqXXNiQj+qxHRmKbKsjubcdqbQmufXDhlJY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BFVD76UwzJ+QZssFpcJ+vZDWNsY7iSg+87CLS7GTYNCHMYqQi0Ates1/wbkQ12VAe4hnEHD9JFdgRooHdVwVTdAg2S5RlvGcMYnsM3KG8ywCBmSYERMBZkmL7jAI8gqvaCqK3zxtcYZzSI84/6wqOJUNkaQBZWvEXoe1P32CSYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id C87A01003C4C01; Thu, 10 Oct 2024 15:53:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id C676A1100AC240;
	Thu, 10 Oct 2024 15:53:48 +0200 (CEST)
Date: Thu, 10 Oct 2024 15:53:48 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Florian Westphal <fw@strlen.de>
cc: Richard Weinberger <richard@sigma-star.at>, 
    Richard Weinberger <richard@nod.at>, upstream@sigma-star.at, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pabeni@redhat.com, 
    kuba@kernel.org, edumazet@google.com, davem@davemloft.net, 
    kadlec@netfilter.org, pablo@netfilter.org, rgb@redhat.com, 
    paul@paul-moore.com, upstream+net@sigma-star.at
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
In-Reply-To: <20241010134827.GC30424@breakpoint.cc>
Message-ID: <612s9310-r348-960q-893n-79nns3o69p38@vanv.qr>
References: <20241009203218.26329-1-richard@nod.at> <20241009213345.GC3714@breakpoint.cc> <3048359.FXINqZMJnI@somecomputer> <20241010134827.GC30424@breakpoint.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thursday 2024-10-10 15:48, Florian Westphal wrote:
>Richard Weinberger <richard@sigma-star.at> wrote:
>> Am Mittwoch, 9. Oktober 2024, 23:33:45 CEST schrieb Florian Westphal:
>> > There is no need to follow ->file backpointer anymore, see
>> > 6acc5c2910689fc6ee181bf63085c5efff6a42bd and
>> > 86741ec25462e4c8cdce6df2f41ead05568c7d5e,
>> > "net: core: Add a UID field to struct sock.".
>> 
>> Oh, neat!
>>  
>> > I think we could streamline all the existing paths that fetch uid
>> > from sock->file to not do that and use sock_net_uid() instead as well.
>>  
>> Also xt_owner?
>
>sk->sk_uid is already used e.g. for fib lookups so I think it makes
>sense to be consistent, so, yes, xt_owner, nfqueue, nft_meta.c, all can
>be converted.

I doubt it. We've been there before... if a process does setuid,
some uid field doesn't change, and others do, so that's user-visible
behavior you can't just change.
