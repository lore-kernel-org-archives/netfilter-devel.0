Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DFE31F9A2
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Apr 2026 04:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776313833; cv=pass; b=LTb9TFKkh6Ag2hy4b+sxdyYcTrr7HQyQe5EalR+cM8TSxEvF/gSj4wl/N4y8vphH1Ae2ljmxYbK5o1s2akvrTqq9Q/DpSKWk93K1Bvtio5V4JAXCK6gjrdSsq2sPl+/kdvP1iEvQpQTUrrBSH88RUY5v8JFX8mRmlmWeJRzsWQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776313833; c=relaxed/simple;
	bh=eBwEvLyvW5ty9QcQNpdbMGy+nVAi1rn9GyGF/2Ur5sE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uWbA+YafThXUChMkS8Vye6PpQIZWT6H08lsqN0TjCiyD4BDbdpOWZkcVLufX14K28VCLhXtSjB1j0fzZLnkbGZMWP7pRe/H/7uNI9B8Tj9u3aS9WM1hvId0sG+KU/vm0m2Dcap15y50fzQ7Qid3KYvf3DmFCtdccxtzbP0D5qTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=VvJil7dD; arc=pass smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="VvJil7dD"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b2503753efso66383615ad.0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 21:30:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776313831; cv=none;
        d=google.com; s=arc-20240605;
        b=HoqpUuC3El6tIWVaDj45fOA4zBsxZ0IVuIFCmDXFO0R3dIA82zIK/cjHeyy1X8sLIe
         rUCJlZiwIJHmgpO8jRrhCHQmGzHH8MYmrCKC5ApIHZmHziZezg98CrhOgf5ZjoSi4LL3
         p8bXq0/h/aVzvDrb+CPPFW7vY5xWBo0JyogOwYeZkHcuX+N1KVp6lWdT0ddCId/A4gw4
         W4yeGj8SVm+chYUa1zxgveT4GFcnOMgsRjeJ+Y6p7qhDvDp7W4SQiKIhEgKlDerUcqdc
         ruWSxf6zduZqw7bKxtKZvFOf/Iq0dgKFbif2yp5NNCYWnUBGwTYd3VMFHppklrRPUTOG
         iXJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eBwEvLyvW5ty9QcQNpdbMGy+nVAi1rn9GyGF/2Ur5sE=;
        fh=PMfVofhUmrhqMq3ynGxxlDHw1LjZozyyd2v6p5KUSds=;
        b=OaqG/lGrcIUpo73fbMwLqjFjptPRTAPq5EFR4QtbvR//RwnBHCLvJIvIh4/Gi4wDbq
         i29ePLT2izPqq+9+JaBaNhtpLiRkFJq4NSiihUs0uKA5omzHXmY9f/ak4S3QF36Xp4V2
         h8OsUoyE6PEWAfyPRoaOgi5g9uLc+vJhuHPMpG/8annEz3PHvUhaANLZlr+JkfhmxRfk
         e/7JRAQ5ijDenCD0DcurW3oKnTRX4rT77xQa8y537IvvJoVjdEUlZUQdanax6oSo6YrB
         QizoDIlAXcrtDJut9y8DaN2NFNX27cCZ8BpamekVBnkndjODUOvf1AfRFAyjlSPWS5Vq
         r6UQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1776313831; x=1776918631; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eBwEvLyvW5ty9QcQNpdbMGy+nVAi1rn9GyGF/2Ur5sE=;
        b=VvJil7dDSM3pzbsfhd8hsLU8WjpiLTMSVFqpebNd0WzoQh44CdszYLFISosexLRJDt
         Rn28tsBJxrma1aILOPMzQyRAmQMOTWqExl/CFbYqTAQ1XxB4jdoQQYt9Dv5e14kKACrD
         zly2eUlXdT06FYYYtvHEMipUj+bEIsEATW8NIyF5R/7SwngKGxU/9aF3QKNJGnomihC1
         NkN/HqzDQrJc2rosTXUG+XFlZER4Xngb67vhrYhxnlDhLdkYctin3CaEu6GQnuMxJtZ/
         FQrpiWA+srrkIs0OH7CXnvnyBUV2kmLu5hptEibQFstxiJPFSzI4rV7B4udLOhAzX8YQ
         TjVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776313831; x=1776918631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eBwEvLyvW5ty9QcQNpdbMGy+nVAi1rn9GyGF/2Ur5sE=;
        b=gwT/6nYQRQXYfvcT4Fz73RwBuqNWh0CRdkjM3KSnMgVE+csLVJ8E3vFbL+KBEqbXM9
         bh+utY6uhaZDfCVLHriYk2Q9h/V0eLGJn1zD8gRXBcR1ljKzT+GGI+GZseRaOPvLkYuK
         bQ9yZMN+VOz+GoC0+Ajdvp7vc1lV2/a2mRFfWreVJBNgfYDITq0QLkZnSO5dqYru5F3Z
         yaekTMMIMP+Z9LhO3zFHSMFtzCKGActxZhXTgBaXcXFbw1/LJx0MZZKQKhTl4VJHBe5a
         KmiCHfwWsddPcFMz0I18v8qOhrxUDSgTUnm70eRlPkYMkpO8kEQ8aJTtLnlB1UmA1t0o
         TUqA==
X-Forwarded-Encrypted: i=1; AFNElJ9aDTmyHsyN3Z7tJe/0cyMy7HHhzptfwIkNiMcE2EUBX4JZCVr/xiZmOAqpIbMoOAg7ZijDcDzPwZFTAFIC+uk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhoCAj+XQ0E/p2eH6AkXf2KXOu+Uqwhd8RFN5MMeFoAIY34cmG
	wKkKhDFArpItZFdTupUk8k+iAKp6tYN59f8XuhRiK2J/HvWHHma5Z7y0aIEpQ+ZtF7Jx7Aes7ND
	2uPeK2U0WfdHQbrilHlD3xNt4Dpjsm5a966B+sSNh
X-Gm-Gg: AeBDieuAYOgBB94vRYSwM+t2V5utcDLI2VIRmsDKBLIMw6LKhKytPLhwGZKIxd6Crlc
	ldeTxFSIIwzkHYWkcQ+mgdYZ3C2siLUJqNkB7UVbxYfm1EoLKR5g5Ouynfbc3s9SqFkv2v9W/x/
	Nn+AqVKv75mrD1wIL9R2R/nqZQQjJo5YeW9km/YLjjvK8rU5V0XCSonzYYtwSmRPBMJdpf/56Db
	b2RjLqxsI8anKPXK3bTdOWSCkV0IfF6UNum4ZAQh6IrOh3gEnDOhZ6vJGQA0/nQvb5BYrucQGBA
	ZRCERr6sSWSteV/9b9k=
X-Received: by 2002:a17:902:bd82:b0:2b2:4eec:9806 with SMTP id
 d9443c01a7336-2b2d59435e7mr175378765ad.8.1776313831108; Wed, 15 Apr 2026
 21:30:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410101321.915190-2-bestswngs@gmail.com> <ad_C1f2cW5-kctHi@chamomile>
In-Reply-To: <ad_C1f2cW5-kctHi@chamomile>
From: Xiang Mei <xmei5@asu.edu>
Date: Wed, 15 Apr 2026 21:30:19 -0700
X-Gm-Features: AQROBzArZIGP7P6PYpJC0RLfY5oWoqPDja93CqgujU7BKVV_JgidCYZGHAKQ3wE
Message-ID: <CAPpSM+Q7GTCwzYwJmcvRz2_XP12Dstwtm4cViyRo16C00C3FDA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: use RCU-safe list primitives for
 basechain hook list
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Weiming Shi <bestswngs@gmail.com>, Florian Westphal <fw@strlen.de>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Phil Sutter <phil@nwl.cc>, 
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 9:55=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Fri, Apr 10, 2026 at 06:13:22PM +0800, Weiming Shi wrote:
> > NFT_MSG_GETCHAIN runs as an NFNL_CB_RCU callback, so chain dumps
> > traverse basechain->hook_list under rcu_read_lock() without holding
> > commit_mutex. Meanwhile, nft_delchain_hook() mutates that same live
> > hook_list with plain list_move() and list_splice(), and the commit/abor=
t
> > paths splice hooks back with plain list_splice(). None of these are
> > RCU-safe list operations.
> >
> > A concurrent GETCHAIN dump can observe partially updated list pointers,
> > follow them into stack-local or transaction-private list heads, and
> > crash when container_of() produces a bogus struct nft_hook pointer.
>
> For the record, v1 of proposed series to fix this is here:
>
> https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=3D49975=
7

Hi Pablo,

Thanks for working on this.
If this addresses the issue I originally reported, could you please
consider adding:
Reported-by: Xiang Mei <xmei5@asu.edu>

Thanks,
Xiang
