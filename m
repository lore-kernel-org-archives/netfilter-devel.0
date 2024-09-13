Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C88D2EB02
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 15:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726241942; cv=none; b=q/ulXkGAH/EDto7Q1no9t0NmWXfgtRarJGaQrZv6zhb27DoPF/Rpa/m5SyEhkY8BroJaEHzQtrdtFW2Zzk7zbgbnAsWiyn2gHS/kDJDUIG7lSl5EA5envsdQ4CnixjwPq3aWb/00jr4MloKMLTbIVzIwxbSeV44dQlJ+Q0d/sMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726241942; c=relaxed/simple;
	bh=GSLpE1tEuher9rgwbchd8qWEm6/ak0mJdIjd4GIg8PI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VW5hSPuzOnmQrS1Bjxitmra17LV+wc0iuCo0oMK/GgYccswmurUfTmCUiNiI6jv1ORun1pg/gnO8rmz+kAXghHYzy8EgZhPYbZnzA+WMoJWQIvKxl/tPvyuBpqsbirvqzjyZamVtqXJkPDRh7+aUZRz8QNC94YQjsgC3vcENRco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RAd+h0PS; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RAd+h0PS"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a08ca8d3fdso2685075ab.0
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 08:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726241940; x=1726846740; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XMTClK8umwm0gUHRb4bj+Ty3lVvsmfUZgBVSu+Ych8M=;
        b=RAd+h0PSRdQqoPF2+lesp30cZ1+rHfnVvANnoz44pluSgxAImLe7XTe4oHXGZNpM5N
         n4AoCPfZobMuU1N21SGdsSR5oxLq0+IUIKiX9Y4nTBMTrsjn1eDLA4ejKROfyFjepLqu
         CyeflHZ4Nbw3HnvbhJ2Yk/gpGmMZsd98V3ACh7/LAVyrA6Oh6Px4/e0UMIsdSnzsmEA0
         adMAzlTpwUR4lZA5kZwMrihc/pl+lU5lPEqygBsVGwgj3yysbkkBYtQVJTeVAqB3BXd/
         x50NdfD8AMoudCOlD6ROhfZm5ax1evO6RgHiR49iDUIEt/vdMwjMeWGRuAZjzeCsPr6f
         1lkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726241940; x=1726846740;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XMTClK8umwm0gUHRb4bj+Ty3lVvsmfUZgBVSu+Ych8M=;
        b=DIXfmQaJ+3tm43cllvDNs1Gs6NuBAiLWaKkRBqV8GqGjTQ+7KYZ+HNj8Pgel/4KoC6
         vAQKAM4lXtXcbXWKWFg2kMILWv3WpD3ZfxMpemnO9SyoAPHJfd0Na/hYTWUAG567FJui
         OMW/npDQBeqewD9DaHzlM/JfvZeW2XsizfmTyj9ws7Q6YuW/DG8oOfIfcc+SClj8MYQL
         LYRPvkoXt32R9UaNXV6QkuV7SWOtkqNyplsX5V0XSzIeVsSWZnChXdRdV7EQFkIMIxWO
         thVN8yMP8caPRn7GeAkvG+x/I/kXlTjTzOOnjozPkWk0FzfvDsw1iKmD6WjhHMTcX7ce
         lOdA==
X-Forwarded-Encrypted: i=1; AJvYcCXDDm9MLTzuD/CLjC8oNbKo6VZ8D6uAWnKAutWjaIyvf1pwyfuYp9iDOwa2mlAqtl3gjwLsWbOvNLC94dBIKCs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUtMCr4kimtpkQxjZRAB9d92lx6Glfh9o9ATDJjkjg4wieDmYU
	K58MSZ09FpnlkvGDs0PsNIW19YLHtfFlwdOovWqLegiRpOoEEirYsC9T4MFUKPteE1b2j/XeYLm
	akio1SDN/VoJm9KoFTYauZUT5nTM=
X-Google-Smtp-Source: AGHT+IFg+SgDVIWxGqSfulbRszB5VeEGmzIU+SKKQWYvEosTCNrFszMJP9byhBo49WUpUQXF7KsUyacmqNR7nxuqmZ4=
X-Received: by 2002:a92:c24c:0:b0:3a0:4b2d:78d7 with SMTP id
 e9e14a558f8ab-3a084911895mr71971425ab.13.1726241939612; Fri, 13 Sep 2024
 08:38:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913102023.3948-1-pablo@netfilter.org> <20240913102347.GA15700@breakpoint.cc>
 <ZuQT60TznuVOHtZg@calendula> <20240913104101.GA16472@breakpoint.cc>
 <ZuQYPr3ugqG-Yz82@calendula> <CABhP=tZKgrWo2oH3h=cA8KreLZtYr1TZw7EfqgGwWitWZAPqyw@mail.gmail.com>
 <ZuQg6d9zGDZKbWBO@calendula> <ZuQpbnjAoutXEFUj@orbyte.nwl.cc>
 <ZuQx3_x6JJgzA0gS@calendula> <20240913141804.GA22091@breakpoint.cc>
In-Reply-To: <20240913141804.GA22091@breakpoint.cc>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Fri, 13 Sep 2024 17:38:21 +0200
Message-ID: <CABhP=tYWf7-Ydi6HyOQ_syeS=k6Y9xPbSGYTSjOjhYpA=Jk-TQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Sept 2024 at 16:18, Florian Westphal <fw@strlen.de> wrote:
>
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Hmm. Looking at nft_nat.c, 'accept' seems consistent with what nat
> > > statements do implicitly.
> >
> > Yes, and xt_TPROXY does NF_ACCEPT.
> >
> > On the other hand, I can see it does NF_DROP it socket is not
> > transparent, it does NFT_BREAK instead, so policy keeps evaluating the
> > packet.
>
> Yes, this is more flexible since you can log+drop for instance in next
> rule(s) to alert that proxy isn't running for example.
>

This is super useful, in the scenario that the transparent proxy takes
over the DNATed virtual IP, if the transparent proxy process is not
running the packet goes to the DNATed virtual IP so the clients don't
observe any disruption.

> > > > is this sufficient in your opinion? If so, I made this quick update
> > > > for man nft(8).
> > >
> > > Acked-by: Phil Sutter <phil@nwl.cc>
> > >
> > > In addition to that, I will update tproxy_tg_xlate() in iptables.git to
> > > emit a verdict, too.
> >
> > Thanks, this is very convenient.
>
> Agreed, it should append accept keyword in the translator.

I'm not completely following the technical details sorry.

With my current configuration I do set an accept action

   udp dport 53 tproxy ip to 127.0.0.1:46659 accept

and I have dnat statements after that action.

The packet is "proxied" but "nftrace monitor" shows that the
subsequent rules are evaluated and I also can observe that the NAT
entries are added on the conntrack table despite the packet being
proxied.

I think that there has to be a way to indicate that after some point
the subsequent rules can not take actions, per example, the conntrack
entries generated by the DNAT rules, at least with UDP, interfere with
subsequent packets .
