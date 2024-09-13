Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9129E3716D
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 11:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726225362; cv=none; b=A47P2BVedAPN0UFkzCQSm69ShXFSOUjqax11tkf3l//sDZeVseOAXuJQl2Dcjfc2r9qxDhslra/hmQ54fyZNSkc8TGCu5jiyWpckXEKtlyagW15NtJ+qCgI6QkvxQdTBwnTOY6X9rZDIRNQZetRuBV9+vUuOfggnH6dCKi6rNhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726225362; c=relaxed/simple;
	bh=q/nbbegraOsNKa3GughEPc5EgMhmPunFeYJ3Rwr7nZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H5BCcvG8dADlUpoan2TIzbclYvfrmncpKkhzETlB034cjjUzSaHf57G2+6MA1FOeFGU/l44eFEUM8laOR74Q86oOS9438JibyLVgtQD/qtLL4Er8lgKPgw09rmmZ03B8OP8T01aVcKPxyQ8h55L9ivGxMgDtefgOPQacIleCp/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mcgWOpzZ; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcgWOpzZ"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-39d2e4d73bcso8106985ab.1
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 04:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726225359; x=1726830159; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3gI3lReJ8dEK67Z0qFV75ztQWDKCtLAAnvVgsQT1018=;
        b=mcgWOpzZ+OAEYFSmLk2y6FttVVTPmIFte7IgsRplQEqeIMyerP5poRJar3KoInUo6D
         0HTOvhCUPCe+JbMcNrHVeiTZnmesDSHVND84w20zY0bQlPzbGt6xBn4GUpXGVdXRylx3
         +nc4VjjKz/vRHSlqHGH0atlhov2jxPS/OKWPqV6KvR3dgyleR7bUl/snqumuM0kn3hgC
         p0icfQe03kFfEqWTCP6MnOLOLgJp/8PiVNrmQFjoJvKxFH9aZwJeeCQ6G9xvJ3bJ/ZZC
         Am6+IoUtMMKf2CP7OvA8r8FOMFxGDdDZ/x9x8+nhi+K5n44RtjMW1D7N5V4bNI2fk/FP
         3EZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726225359; x=1726830159;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3gI3lReJ8dEK67Z0qFV75ztQWDKCtLAAnvVgsQT1018=;
        b=qtD49lLpshLMvxoSBMPwnLhCGy5GE9gQGynnX4ylFZ0C9Vp+zEx4H+JB8FFOISCtZh
         K3w1JkshAI9J9aHUOSitj2FDLmLc4HOpd6RyQ2JEpe5TaC7uGsiu5Xxu3d0n/LDgZEC9
         cqjryfZab1UhZjRKqElismbLZnq89k8LaQNB96T4hh3OnLkgw5FJzIMji2UTY2hBmcKH
         ATnqmP2sqMjK+37BgESj3MWEMUiMbvVAjnVFFAOi9J2E6YYlH86IKyPkeftR8B/KNAke
         Tsch6BAQzKsO+JGgr8bPq6JCc9Jr5GM5T34M8TyunX/2m7RhG2yxQ0mW4hT7QoILTdsQ
         oCtg==
X-Forwarded-Encrypted: i=1; AJvYcCV4pgfcwX64WbhoJHUTyIXr4rb4nlDYGd2oE+386wbIWIlvJsOQWJ4coJRtUTRN/0KEAM5UanCYHcNFshxaGFM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcLq+hMky9M9t3IvD2BuoF/j4sTSDg4Gcn0TlRG3Pb/3HEJrlo
	XQzhfVGWD23Aotu0a/sZGrUTEsVjQzlpOvzJFzeI08kzUORC5Y98aYyTz5fvt3jH+Zx+yxKfDSM
	8TjbH32vlgJ1OmXVkY2LrshRwJUOaRKFk
X-Google-Smtp-Source: AGHT+IEZH8KVY7kkj/Hc59/Xye1eUNavgKnIQGphleos+2y9E7tvSIqzL4GsLgYfj5Jllzb33ZshgR1NGmihPZNiAnQ=
X-Received: by 2002:a05:6e02:1486:b0:39f:5147:ba7b with SMTP id
 e9e14a558f8ab-3a08497f558mr67854045ab.25.1726225359646; Fri, 13 Sep 2024
 04:02:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913102023.3948-1-pablo@netfilter.org> <20240913102347.GA15700@breakpoint.cc>
 <ZuQT60TznuVOHtZg@calendula> <20240913104101.GA16472@breakpoint.cc> <ZuQYPr3ugqG-Yz82@calendula>
In-Reply-To: <ZuQYPr3ugqG-Yz82@calendula>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Fri, 13 Sep 2024 13:02:02 +0200
Message-ID: <CABhP=tZKgrWo2oH3h=cA8KreLZtYr1TZw7EfqgGwWitWZAPqyw@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, phil@nwl.cc
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Sept 2024 at 12:47, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Fri, Sep 13, 2024 at 12:41:01PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Fri, Sep 13, 2024 at 12:23:47PM +0200, Florian Westphal wrote:
> > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > tproxy action must be terminal since the intent of the user to steal the
> > > > > traffic and redirect to the port.
> > > > > Align this behaviour to iptables to make it easier to migrate by issuing
> > > > > NF_ACCEPT for packets that are redirect to userspace process socket.
> > > > > Otherwise, NF_DROP packet if socket transparent flag is not set on.
> > > >
> > > > The nonterminal behaviour is intentional. This change will likely
> > > > break existing setups.
> > > >
> > > > nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
> > > >
> > > > This is a documented example.
> > >
> > > Ouch. Example could have been:
> > >
> > >   nft add rule filter divert tcp dport 80 socket transparent meta set 1 tproxy to :50080
> >
> > Yes, but its not the same.
> >
> > With the statements switched, all tcp dport 80 have the mark set.
> > With original example, the mark is set only if tproxy found a
> > transparent sk.
>
> Indeed, thanks for correcting me.
>
> I'm remembering now why this was done to provide to address the ugly
> mark hack that xt_TPROXY provides.
>
> While this is making harder to migrate, making it non-terminal is
> allowing to make more handling such as ct/meta marking after it.
>
> I think we just have to document this in man nft(8).

I think that at this point in time the current state can not be broken
based on this discussion, I just left the comment in the bugzilla
about the possibility but it is clear now that people that have
already started using this feature with nftables must not experience a
disruption.
On the other side, users that need to migrate will have to adapt more
things so I don't think it should be a big deal.
What I really think is that users should have a way to terminate
processing to avoid other rules to interfere with the tproxy
functionality
